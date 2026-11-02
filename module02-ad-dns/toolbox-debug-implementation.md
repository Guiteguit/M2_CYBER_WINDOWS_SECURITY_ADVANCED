# M02 — Toolbox AD DS & DNS

> Support technique pour implémenter, tester et dépanner le lab. Le README principal reste la référence pour la mission.

## Baseline réseau

~~~powershell
ipconfig /all
Get-NetIPConfiguration
Get-DnsClientServerAddress
Test-Connection DC01 -Count 2
Resolve-DnsName DC01
~~~

À vérifier : IP, gateway, DNS pointant vers DC01, résolution de DC01.

## Installer et vérifier AD DS

~~~powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Get-WindowsFeature AD-Domain-Services
Install-ADDSForest -DomainName "novacorp.local" -DomainNetbiosName "NOVACORP" -InstallDNS
~~~

Après redémarrage :

~~~powershell
Get-ADDomain
Get-ADForest
~~~

## Vérifier DNS AD

~~~powershell
Get-DnsServerZone
Resolve-DnsName novacorp.local
Resolve-DnsName DC01.novacorp.local
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.novacorp.local
Resolve-DnsName -Type SRV _kerberos._tcp.novacorp.local
~~~

Alternative :

~~~cmd
nslookup -type=SRV _ldap._tcp.dc._msdcs.novacorp.local
~~~

## Diagnostic contrôleur de domaine

~~~cmd
dcdiag
dcdiag /test:dns /v
dcdiag /q
nltest /dsgetdc:novacorp.local
nltest /dclist:novacorp.local
~~~

~~~powershell
Get-SmbShare -Name SYSVOL,NETLOGON
~~~

## Jointure domaine

Avant la jointure :

~~~powershell
Resolve-DnsName novacorp.local
Test-NetConnection DC01 -Port 53
Test-NetConnection DC01 -Port 389
Test-NetConnection DC01 -Port 88
~~~

Jointure :

~~~powershell
Add-Computer -DomainName "novacorp.local" -Credential "NOVACORP\Administrator" -Restart
~~~

Validation :

~~~powershell
Get-CimInstance Win32_ComputerSystem | Select Name,Domain,PartOfDomain
Test-ComputerSecureChannel -Verbose
~~~

~~~cmd
nltest /sc_verify:novacorp.local
~~~

## Troubleshooting

| Symptôme | Vérification prioritaire |
|---|---|
| Domaine introuvable | DNS client + SRV records |
| Jointure échoue | DNS, heure, ports AD, credentials |
| Login domaine impossible | canal sécurisé + DNS + horloge |
| SRV LDAP absent | DNS AD / Netlogon |
| SYSVOL absent | AD DS / Netlogon / dcdiag |
| Internet fonctionne mais AD non | DNS public configuré sur le client |

~~~powershell
ipconfig /flushdns
ipconfig /registerdns
Restart-Service Netlogon
w32tm /query /status
~~~

Méthode :

~~~text
DNS client
→ résolution DC
→ SRV AD
→ ports AD
→ heure
→ canal sécurisé
→ authentification
~~~

## Liens Microsoft

- DCDiag : https://learn.microsoft.com/windows-server/administration/windows-commands/dcdiag
- AD DS overview : https://learn.microsoft.com/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview
- DNS concepts for AD DS : https://learn.microsoft.com/windows-server/identity/ad-ds/plan/reviewing-dns-concepts
