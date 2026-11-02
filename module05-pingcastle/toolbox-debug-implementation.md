# M05 — Toolbox PingCastle & Audit AD

> L'objectif n'est pas de faire disparaître des points mais de comprendre les findings et vérifier les remédiations.

## Préparer l'audit

~~~powershell
whoami
whoami /groups
Resolve-DnsName novacorp.local
~~~

~~~cmd
nltest /dsgetdc:novacorp.local
~~~

## Exécuter PingCastle

~~~cmd
PingCastle.exe
PingCastle.exe --healthcheck --server novacorp.local
~~~

Conservez rapport initial, date/heure, contexte et rapport après remédiation.

## Lire un finding

~~~text
Finding
→ quel objet ?
→ quel mécanisme ?
→ quel scénario d'attaque ?
→ quel impact NovaCorp ?
→ quelle correction ?
→ quel risque de correction ?
→ comment valider ?
~~~

## Vérifications manuelles utiles

~~~powershell
Get-ADGroupMember "Domain Admins"
Get-ADGroupMember "Enterprise Admins"
Get-ADGroupMember "Schema Admins"
Get-ADUser -Filter * -Properties PasswordNeverExpires | Where-Object PasswordNeverExpires | Select SamAccountName,Enabled
Get-ADUser -Filter 'Enabled -eq $false' | Select SamAccountName
Get-GPO -All | Select DisplayName,GpoStatus
~~~

~~~cmd
dcdiag /q
~~~

## Avant / après remédiation

~~~text
BEFORE
→ finding
→ objet concerné
→ dépendances
→ test métier
→ rollback
→ correction
→ re-test
→ nouveau rapport
~~~

Ne validez pas seulement avec le score. Revalidez login, DNS, GPO, File Server, groupes et délégations.

## Troubleshooting

| Symptôme | Vérification |
|---|---|
| domaine introuvable | DNS / nltest |
| collecte incomplète | droits / connectivité |
| finding incompris | objet + règle + mécanisme |
| score ne baisse pas | correction partielle / autre finding |
| score baisse mais service cassé | correction trop agressive |
| résultat surprenant | confirmer manuellement |

~~~text
Score
≠ risque métier
≠ preuve de sécurité
~~~

## Liens utiles

Microsoft :
- AD security groups : https://learn.microsoft.com/windows-server/identity/ad-ds/manage/understand-security-groups
- AD security best practices : https://learn.microsoft.com/windows-server/identity/ad-ds/plan/security-best-practices/best-practices-for-securing-active-directory
- DCDiag : https://learn.microsoft.com/windows-server/administration/windows-commands/dcdiag

PingCastle :
- https://www.pingcastle.com/
- https://github.com/netwrix/pingcastle
