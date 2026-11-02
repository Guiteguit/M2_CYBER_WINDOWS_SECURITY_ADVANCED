# M03 — Toolbox GPO & Hardening

> Objectif : comprendre pourquoi une GPO s'applique ou non, vérifier l'effet réel et savoir revenir en arrière.

## Inventaire

~~~powershell
Get-GPO -All | Select DisplayName,Id,GpoStatus
Get-GPInheritance -Target "OU=Computers,OU=NovaCorp,DC=novacorp,DC=local"
New-Item -ItemType Directory -Path C:\Temp -Force
Get-GPOReport -All -ReportType Html -Path C:\Temp\gpo-report.html
~~~

## Vérifier côté client

~~~cmd
gpupdate /force
gpresult /r
gpresult /h C:\Temp\gpresult.html
rsop.msc
~~~

~~~powershell
Get-GPResultantSetOfPolicy -ReportType Html -Path C:\Temp\rsop.html
~~~

## Si une GPO ne s'applique pas

~~~text
1. Objet dans la bonne OU ?
2. GPO liée à cette OU ?
3. Lien activé ?
4. Partie Computer/User activée ?
5. Security Filtering correct ?
6. WMI Filter ?
7. Priorité / héritage ?
8. gpupdate effectué ?
9. gpresult dit quoi ?
~~~

OU réelle :

~~~powershell
Get-ADComputer CLT01 -Properties DistinguishedName | Select DistinguishedName
~~~

Permissions GPO :

~~~powershell
Get-GPPermission -Name "Nom-GPO" -All
~~~

## Logs Group Policy

~~~powershell
Get-WinEvent -LogName "Microsoft-Windows-GroupPolicy/Operational" -MaxEvents 50 | Select TimeCreated,Id,LevelDisplayName,Message
~~~

## Validation

~~~text
GPO configurée
→ gpupdate
→ gpresult
→ réglage effectif
→ test fonctionnel
~~~

## Backup / rollback

~~~powershell
New-Item -ItemType Directory -Path C:\GPO-Backup -Force
Backup-GPO -All -Path C:\GPO-Backup
~~~

## Troubleshooting

| Symptôme | Piste |
|---|---|
| GPO visible mais absente sur CLT01 | OU / filtering / gpresult |
| valeur différente | autre GPO / precedence |
| Computer settings absents | mauvaise OU |
| User settings absents | user OU / loopback |
| gpupdate erreur réseau | DNS / SYSVOL / accès DC |
| serveur OK mais poste KO | scope différent |

~~~cmd
whoami /groups
echo %LOGONSERVER%
~~~

## Liens Microsoft

- Group Policy troubleshooting : https://learn.microsoft.com/troubleshoot/windows-server/group-policy/group-policy-overview
- Applying Group Policy troubleshooting : https://learn.microsoft.com/troubleshoot/windows-server/group-policy/applying-group-policy-troubleshooting-guidance
- gpresult : https://learn.microsoft.com/windows-server/administration/windows-commands/gpresult
- Get-GPResultantSetOfPolicy : https://learn.microsoft.com/powershell/module/grouppolicy/get-gpresultantsetofpolicy
