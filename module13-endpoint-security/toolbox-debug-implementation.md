# M13 — Toolbox Debug & Exemples d'implémentation

> Ce document est une boîte à outils. Il ne remplace pas la réflexion demandée dans le README.
> Utilisez-le pour diagnostiquer, valider un état, reproduire un test contrôlé et effectuer un rollback.

---

# 1. Baseline rapide

## Defender

~~~powershell
Get-MpComputerStatus
Get-MpPreference

Get-MpComputerStatus | Select AntivirusEnabled,RealTimeProtectionEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,IsTamperProtected
~~~

Points utiles : AntivirusEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled, AttackSurfaceReductionRules_Ids, AttackSurfaceReductionRules_Actions.

## Firewall

~~~powershell
Get-NetFirewallProfile | Select Name,Enabled,DefaultInboundAction,DefaultOutboundAction
Get-NetConnectionProfile
~~~

Vérifiez notamment si l'interface est en DomainAuthenticated.

## AppLocker

~~~powershell
Get-Service AppIDSvc
Get-AppLockerPolicy -Local
Get-AppLockerPolicy -Effective
Get-AppLockerPolicy -Effective | Select -ExpandProperty RuleCollections
~~~

## PowerShell Logging

~~~powershell
Get-WinEvent -ListLog "Microsoft-Windows-PowerShell/Operational"
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 20 | Select TimeCreated,Id,Message
~~~

---

# 2. ASR — Attack Surface Reduction

## Scénario validé

Règle : Block process creations originating from PSExec and WMI commands

GUID :

~~~text
d1e49aac-8f56-4280-b9ba-993a6d77406c
~~~

Objectif :

~~~text
Audit  -> action autorisée -> Event 1122
Block  -> action refusée   -> Event 1121
~~~

## Voir les règles ASR

~~~powershell
$p = Get-MpPreference

0..($p.AttackSurfaceReductionRules_Ids.Count - 1) | ForEach-Object {
    [PSCustomObject]@{
        Id     = $p.AttackSurfaceReductionRules_Ids[$_]
        Action = $p.AttackSurfaceReductionRules_Actions[$_]
    }
}
~~~

Repères :

~~~text
0 = Disabled
1 = Block
2 = Audit
6 = Warn
~~~

## Exemple Audit

~~~powershell
Add-MpPreference -AttackSurfaceReductionRules_Ids "d1e49aac-8f56-4280-b9ba-993a6d77406c" -AttackSurfaceReductionRules_Actions AuditMode
~~~

Test WMI bénin :

~~~powershell
Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine="notepad.exe"}
~~~

Attendu : ReturnValue = 0 et Notepad démarre.

~~~powershell
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-Windows Defender/Operational"
    Id      = 1122
} -MaxEvents 10 | Select TimeCreated,Id,Message
~~~

## Exemple Block

~~~powershell
Set-MpPreference -AttackSurfaceReductionRules_Ids "d1e49aac-8f56-4280-b9ba-993a6d77406c" -AttackSurfaceReductionRules_Actions Enabled
~~~

Rejouez exactement le même test WMI.

Dans le lab validé, le blocage a produit ReturnValue = 2 et aucun processus n'a été créé.

~~~powershell
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-Windows Defender/Operational"
    Id      = 1121
} -MaxEvents 10 | Select TimeCreated,Id,Message
~~~

## Debug ASR

~~~powershell
Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" -MaxEvents 100 |
Where-Object Id -in 1121,1122,1129,5007 |
Select TimeCreated,Id,Message
~~~

| Event ID | Signification |
|---:|---|
| 1121 | action bloquée par ASR |
| 1122 | action auditée |
| 1129 | override utilisateur en mode Warn |
| 5007 | modification de configuration |

Si aucune trace n'apparaît :

~~~powershell
Get-MpComputerStatus | Select AntivirusEnabled,RealTimeProtectionEnabled,BehaviorMonitorEnabled
Get-MpPreference | Select AttackSurfaceReductionRules_Ids,AttackSurfaceReductionRules_Actions
~~~

## Rollback ASR

~~~powershell
Set-MpPreference -AttackSurfaceReductionRules_Ids "d1e49aac-8f56-4280-b9ba-993a6d77406c" -AttackSurfaceReductionRules_Actions Disabled
~~~

Ne modifiez pas les autres règles déjà présentes sans les avoir identifiées.

---

# 3. AppLocker

## Logique du lab

~~~text
SYSTEM32 autorisé
EXE copié dans C:\Temp hors règle Allow

AuditOnly -> exécution autorisée -> Event 8003
Enabled   -> exécution bloquée   -> Event 8004
~~~

## Application Identity

~~~powershell
Get-Service AppIDSvc
Start-Service AppIDSvc
~~~

## Attention aux Windows localisés

Le nom anglais Everyone peut ne pas être résolu.

~~~powershell
Get-LocalGroup | Where-Object SID -eq "S-1-1-0"
~~~

Utilisez le nom réellement retourné. Sur notre lab français : Tout le monde.

## Générer une policy minimale

~~~powershell
$files = Get-ChildItem "C:\Windows\System32\*.exe"
$info = $files | Get-AppLockerFileInformation

$policy = $info | New-AppLockerPolicy -AllowWindows -RuleType Path -User "Tout le monde" -Optimize
~~~

## Export XML

~~~powershell
New-Item -ItemType Directory -Path C:\Temp -Force
$policyXml = $policy.ToXml()
$policyXml | Out-File C:\Temp\AppLocker-Audit.xml -Encoding utf8
notepad C:\Temp\AppLocker-Audit.xml
~~~

Vous devez retrouver une collection Exe, généralement en NotConfigured au départ.

## Passer en AuditOnly

~~~powershell
[xml]$xml = Get-Content C:\Temp\AppLocker-Audit.xml

$xml.AppLockerPolicy.RuleCollection |
Where-Object Type -eq "Exe" |
ForEach-Object {
    $_.EnforcementMode = "AuditOnly"
}

$xml.Save("C:\Temp\AppLocker-Audit.xml")

Set-AppLockerPolicy -XmlPolicy "C:\Temp\AppLocker-Audit.xml"
~~~

Vérification :

~~~powershell
Get-AppLockerPolicy -Effective | Select -ExpandProperty RuleCollections
~~~

## EXE bénin hors politique

~~~powershell
New-Item -ItemType Directory -Path C:\Temp\AppLockerTest -Force
Copy-Item C:\Windows\System32\notepad.exe C:\Temp\AppLockerTest\notepad-test.exe

C:\Temp\AppLockerTest\notepad-test.exe
~~~

En AuditOnly, l'application continue de démarrer.

~~~powershell
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-AppLocker/EXE and DLL"
    Id      = 8003
} -MaxEvents 20 | Select TimeCreated,Id,Message
~~~

## Passer temporairement en Enforcement

~~~powershell
[xml]$xml = Get-Content C:\Temp\AppLocker-Audit.xml

$xml.AppLockerPolicy.RuleCollection |
Where-Object Type -eq "Exe" |
ForEach-Object {
    $_.EnforcementMode = "Enabled"
}

$xml.Save("C:\Temp\AppLocker-Enforce.xml")

Set-AppLockerPolicy -XmlPolicy "C:\Temp\AppLocker-Enforce.xml"
~~~

Rejouez exactement :

~~~powershell
C:\Temp\AppLockerTest\notepad-test.exe
~~~

Puis :

~~~powershell
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-AppLocker/EXE and DLL"
    Id      = 8004
} -MaxEvents 20 | Select TimeCreated,Id,Message
~~~

| Event ID | Signification |
|---:|---|
| 8001 | policy appliquée |
| 8002 | EXE/DLL autorisé |
| 8003 | aurait été bloqué en enforcement |
| 8004 | EXE/DLL réellement bloqué |

## Tester une policy sans se limiter à l'exécution

~~~powershell
$effective = Get-AppLockerPolicy -Effective

Test-AppLockerPolicy -PolicyObject $effective -Path "C:\Temp\AppLockerTest\notepad-test.exe" -User "$env:USERDOMAIN\$env:USERNAME"
~~~

## Debug AppLocker

~~~powershell
Get-Service AppIDSvc
Get-AppLockerPolicy -Effective
Get-WinEvent -ListLog "Microsoft-Windows-AppLocker/EXE and DLL"

Get-WinEvent -LogName "Microsoft-Windows-AppLocker/EXE and DLL" -MaxEvents 50 |
Select TimeCreated,Id,Message
~~~

Si beaucoup d'applications légitimes apparaissent en 8003, la policy est probablement trop restrictive ou incomplète. Ne passez pas directement en enforcement.

## Rollback AppLocker

~~~powershell
[xml]$xml = Get-Content C:\Temp\AppLocker-Enforce.xml

$xml.AppLockerPolicy.RuleCollection |
Where-Object Type -eq "Exe" |
ForEach-Object {
    $_.EnforcementMode = "AuditOnly"
}

$xml.Save("C:\Temp\AppLocker-Audit-Final.xml")
Set-AppLockerPolicy -XmlPolicy "C:\Temp\AppLocker-Audit-Final.xml"
~~~

---

# 4. Windows Firewall

## Vérification

~~~powershell
Get-NetFirewallProfile | Select Name,Enabled,DefaultInboundAction,DefaultOutboundAction
Get-NetConnectionProfile
~~~

## Listener TCP temporaire sur CLT01

Dans une console dédiée :

~~~powershell
$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Any,18080)
$listener.Start()

Write-Host "Listening on TCP/18080"

while ($true) {
    $client = $listener.AcceptTcpClient()
    Write-Host "Connexion reçue de $($client.Client.RemoteEndPoint)"
    $client.Close()
}
~~~

Dans une autre console :

~~~powershell
Get-NetTCPConnection -LocalPort 18080 -State Listen
netstat -ano | findstr :18080
~~~

## Allow

~~~powershell
New-NetFirewallRule -DisplayName "M13-LAB-Allow-18080" -Direction Inbound -Protocol TCP -LocalPort 18080 -Profile Domain -Action Allow
~~~

Depuis SRV01 :

~~~powershell
Test-NetConnection CLT01 -Port 18080
~~~

Attendu : TcpTestSucceeded = True.

## Block

~~~powershell
New-NetFirewallRule -DisplayName "M13-LAB-Block-18080" -Direction Inbound -Protocol TCP -LocalPort 18080 -Profile Domain -Action Block
~~~

Vérifiez que le listener existe toujours :

~~~powershell
Get-NetTCPConnection -LocalPort 18080 -State Listen
~~~

Puis depuis SRV01 :

~~~powershell
Test-NetConnection CLT01 -Port 18080
~~~

Attendu : TcpTestSucceeded = False.

## Rollback

~~~powershell
Remove-NetFirewallRule -DisplayName "M13-LAB-Allow-18080"
Remove-NetFirewallRule -DisplayName "M13-LAB-Block-18080"

Get-NetFirewallRule | Where-Object DisplayName -like "M13-LAB-*"
~~~

---

# 5. PowerShell Logging

## Script Block Logging

~~~powershell
Get-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -ErrorAction SilentlyContinue

New-Item "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Force | Out-Null
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name EnableScriptBlockLogging -Value 1
~~~

## Module Logging

~~~powershell
New-Item "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Force | Out-Null
New-Item "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -Force | Out-Null

Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name EnableModuleLogging -Value 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -Name "*" -Value "*"
~~~

## Transcription

~~~powershell
New-Item "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Force | Out-Null

Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name EnableTranscripting -Value 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name EnableInvocationHeader -Value 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription" -Name OutputDirectory -Value "C:\Transcripts"
~~~

Ouvrez ensuite une nouvelle console PowerShell.

## Activité identifiable

~~~powershell
$M13TestValue = "M13-POWERSHELL-LOGGING"
Write-Output $M13TestValue

Get-Service | Where-Object Status -eq "Running" | Select -First 5
~~~

## Event 4104

~~~powershell
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-PowerShell/Operational"
    Id      = 4104
} -MaxEvents 50 | Select TimeCreated,Id,Message
~~~

Recherche ciblée :

~~~powershell
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-PowerShell/Operational"
    Id      = 4104
} |
Where-Object {
    $_.Message -like "*M13-POWERSHELL-LOGGING*"
} |
Select TimeCreated,Id,Message
~~~

## Transcripts

~~~powershell
$latest = Get-ChildItem C:\Transcripts -Recurse -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

$latest | Select FullName,LastWriteTime,Length
notepad $latest.FullName

Select-String -Path $latest.FullName -Pattern "M13-POWERSHELL-LOGGING"
~~~

Attention : les journaux et transcripts peuvent contenir des informations sensibles. N'utilisez jamais de vrais secrets dans les tests.

---

# 6. Diagnostic rapide

| Symptôme | Vérification |
|---|---|
| ASR sans événement | Defender actif, Real-Time, règle effective |
| 1122 mais rien n'est bloqué | normal : Audit |
| AppLocker sans log | AppIDSvc, policy effective, journal EXE and DLL |
| beaucoup de 8003 | policy trop restrictive / baseline incomplète |
| EXE immédiatement bloqué | collection en Enforcement |
| Firewall semble bloquer | vérifier que le service est toujours LISTEN |
| 4104 absent | Script Block Logging + nouvelle session |
| transcript absent | stratégie Transcription + nouvelle console |

---

# 7. Événements à retenir

| Technologie | Event ID | Interprétation |
|---|---:|---|
| ASR | 1121 | Block |
| ASR | 1122 | Audit |
| ASR | 1129 | Warn / override |
| Defender | 5007 | changement de configuration |
| AppLocker | 8001 | policy appliquée |
| AppLocker | 8002 | EXE/DLL autorisé |
| AppLocker | 8003 | aurait été bloqué |
| AppLocker | 8004 | EXE/DLL bloqué |
| PowerShell | 4104 | Script Block Logging |

---

# 8. Méthode de debug conseillée

~~~text
1. Vérifier le composant / service
2. Vérifier la configuration effective
3. Vérifier le scope
4. Reproduire une action simple
5. Observer le résultat fonctionnel
6. Lire le journal correspondant
7. Comparer attendu / réel
8. Modifier une seule variable
9. Rejouer le même test
10. Rollback
~~~

Préférez toujours :

~~~text
Hypothèse
-> Test
-> Preuve
-> Conclusion
~~~

plutôt que de modifier plusieurs paramètres à la fois.

---

# 9. Références Microsoft

- [Troubleshoot ASR rules](https://learn.microsoft.com/defender-endpoint/troubleshoot-asr)
- [New-AppLockerPolicy](https://learn.microsoft.com/powershell/module/applocker/new-applockerpolicy)
- [Use the AppLocker PowerShell cmdlets](https://learn.microsoft.com/windows/security/application-security/application-control/app-control-for-business/applocker/use-the-applocker-windows-powershell-cmdlets)
- [Using Event Viewer with AppLocker](https://learn.microsoft.com/windows/security/application-security/application-control/app-control-for-business/applocker/using-event-viewer-with-applocker)
- [PowerShell about_Logging](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_logging)

Les commandes correspondent au scénario M13 validé dans le lab NovaCorp. Pour un environnement de production : gestion centralisée, déploiement progressif, audit préalable et analyse d'impact avant enforcement.
