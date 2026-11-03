# M10 — Toolbox IIS, TLS & Kerberos SSO

> Support technique pour implémenter et dépanner IIS, HTTPS, gMSA et authentification Windows intégrée.

## 1. Vérifier IIS

```powershell
Get-WindowsFeature Web-Server,Web-Windows-Auth,Web-Mgmt-Console,Web-ASP
Get-Service W3SVC
Get-Website
Invoke-WebRequest http://localhost -UseBasicParsing
```

## 2. Vérifier le site NovaCorp

```powershell
Import-Module WebAdministration
Get-Website
Get-WebBinding -Name "NovaCorp-Web"
```

## 3. Vérifier le certificat TLS

```powershell
Get-ChildItem Cert:\LocalMachine\My |
Select Subject,Issuer,NotAfter,HasPrivateKey,Thumbprint

netsh http show sslcert
```

Vérifier :
- bon certificat ;
- bonne empreinte ;
- bon binding HTTPS ;
- hostname `web.novacorp.local`.

## 4. Vérifier DNS

Depuis CLT01 :

```powershell
Resolve-DnsName web.novacorp.local
Test-NetConnection web.novacorp.local -Port 443
```

## 5. Vérifier le gMSA du pool IIS

Sur SRV01 :

```powershell
Test-ADServiceAccount -Identity gmsa-demo
```

Vérifier aussi :
- `NovaCorp-AppPool` existe ;
- identité = `NOVACORP\gmsa-demo$` ;
- mot de passe vide ;
- le pool démarre réellement.

## 6. SPN HTTP

Sur DC01 :

```powershell
setspn -Q HTTP/web.novacorp.local
setspn -S HTTP/web.novacorp.local NOVACORP\gmsa-demo$
setspn -L NOVACORP\gmsa-demo$
```

Attention aux doublons :
- un SPN dupliqué casse souvent Kerberos ;
- `-S` est préférable à `-A`.

## 7. Windows Authentication IIS

Vérifier dans IIS :
- Anonymous Authentication = Disabled ;
- Windows Authentication = Enabled ;
- Providers : `Negotiate` avant `NTLM`.

Paramètres importants :
- `useKernelMode = True` ;
- `useAppPoolCredentials = True`.

## 8. Vérifier Kerberos côté client

Depuis CLT01 :

```powershell
whoami
klist
klist get HTTP/web.novacorp.local
```

Attendu :
- un ticket de service `HTTP/web.novacorp.local`.

## 9. Zone Intranet local

Si Edge/IE demande les credentials au lieu d’utiliser le SSO :
- `inetcpl.cpl` ;
- Sécurité ;
- Intranet local ;
- Sites ;
- Avancé ;
- ajouter `https://web.novacorp.local`.

## 10. Classic ASP / page dynamique

Vérifier le support ASP :

```powershell
Get-WindowsFeature Web-ASP
```

Tester ensuite la page qui expose :
- `LOGON_USER` ;
- `AUTH_TYPE` ;
- serveur ;
- date/heure.

> `AUTH_TYPE=Negotiate` ne prouve pas à lui seul Kerberos. Il faut confirmer avec `klist` et, si possible, les événements côté serveur.

## 11. Troubleshooting

| Symptôme | Vérification |
|---|---|
| le site HTTPS ne répond pas | service W3SVC, binding, DNS, port 443 |
| alerte certificat | mauvais cert, chaîne non approuvée, nom incorrect |
| prompt d’identifiants | zone Intranet, providers IIS, SPN, useAppPoolCredentials |
| SSO fonctionne mais pas preuve Kerberos | `klist`, ticket HTTP, audit côté serveur |
| le pool IIS ne démarre pas | gMSA, droits NTFS, identité du pool |
| le site rend une erreur ASP | rôle Web-ASP, document par défaut, syntaxe page |

### Commandes utiles

```powershell
Get-WinEvent -LogName Security -MaxEvents 50
Get-WebBinding -Name "NovaCorp-Web"
Restart-WebAppPool "NovaCorp-AppPool"
```

## 12. Rollback

- remettre une page statique si la page ASP casse le site ;
- retirer le SPN de test si erreur de conception ;
- réactiver temporairement l’anonymous auth seulement si c’est explicitement une phase de diagnostic ;
- conserver un export de la config IIS de lab.

## 13. Liens Microsoft

- Windows Authentication in IIS : https://learn.microsoft.com/iis/configuration/system.webserver/security/authentication/windowsauthentication/
- Service Principal Names : https://learn.microsoft.com/windows-server/administration/windows-commands/setspn
- Kerberos overview : https://learn.microsoft.com/windows-server/security/kerberos/kerberos-authentication-overview
- IIS PowerShell / WebAdministration : https://learn.microsoft.com/powershell/module/webadministration/
