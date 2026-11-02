# M06 — Toolbox Comptes privilégiés & Délégation

> Objectif : vérifier les privilèges réellement accordés et démontrer qu'une délégation fonctionne uniquement dans son périmètre.

## Inventorier les groupes sensibles

~~~powershell
Get-ADGroupMember "Domain Admins" -Recursive
Get-ADGroupMember "Enterprise Admins" -Recursive
Get-ADGroupMember "Schema Admins" -Recursive
Get-ADGroupMember "Administrators" -Recursive
Get-ADGroupMember "Protected Users" -Recursive
~~~

## Inspecter un compte

~~~powershell
Get-ADUser admin1 -Properties MemberOf,AdminCount,AccountNotDelegated | Select SamAccountName,Enabled,AdminCount,AccountNotDelegated,MemberOf
~~~

~~~cmd
whoami /groups
whoami /priv
~~~

## Séparer compte quotidien / admin

~~~text
user1
→ usage quotidien

adm-user1
→ administration ciblée
~~~

Exemple :

~~~powershell
New-ADUser -Name "adm-helpdesk01" -SamAccountName "adm-helpdesk01" -Enabled $true -AccountPassword (Read-Host -AsSecureString)
~~~

## Empêcher la délégation d'un compte sensible

~~~powershell
Set-ADAccountControl -Identity "adm-helpdesk01" -AccountNotDelegated $true
Get-ADUser "adm-helpdesk01" -Properties AccountNotDelegated | Select SamAccountName,AccountNotDelegated
~~~

## Protected Users

~~~powershell
Add-ADGroupMember -Identity "Protected Users" -Members "adm-helpdesk01"
Get-ADGroupMember "Protected Users"
~~~

Rollback :

~~~powershell
Remove-ADGroupMember -Identity "Protected Users" -Members "adm-helpdesk01" -Confirm:$false
~~~

## Schema Admins

~~~powershell
Get-ADGroupMember "Schema Admins"
~~~

Le groupe peut rester vide en fonctionnement normal.

## Délégation Helpdesk

Créer un groupe dédié :

~~~powershell
New-ADGroup -Name "GG_Helpdesk_ResetPwd" -GroupScope Global -GroupCategory Security
Add-ADGroupMember -Identity "GG_Helpdesk_ResetPwd" -Members "helpdesk01"
~~~

Déléguez ensuite uniquement le reset password sur l'OU Finance via Active Directory Users and Computers → Delegate Control.

Test positif :

~~~powershell
Set-ADAccountPassword -Identity "alice.finance" -Reset -NewPassword (Read-Host -AsSecureString)
~~~

Refaire le test sur un utilisateur Direction : il doit être refusé.

~~~text
ALLOW attendu
+
DENY attendu
=
délégation réellement validée
~~~

## Inspecter les ACL d'une OU

~~~powershell
(Get-Acl "AD:OU=Finance,OU=NovaCorp,DC=novacorp,DC=local").Access | Select IdentityReference,ActiveDirectoryRights,AccessControlType,ObjectType,InheritedObjectType
~~~

~~~cmd
dsacls "OU=Finance,OU=NovaCorp,DC=novacorp,DC=local"
~~~

## Troubleshooting

| Symptôme | Vérification |
|---|---|
| Helpdesk ne peut rien faire | groupe + ACL OU + nouveau token |
| peut agir partout | droits trop larges / groupe privilégié |
| membership non pris en compte | logoff/logon |
| Finance refusé | cible dans la bonne OU ? |
| Direction autorisé | héritage / groupe admin / ACL parent |
| compte protégé étrange | AdminSDHolder / AdminCount |

~~~powershell
Get-ADUser user1 -Properties AdminCount | Select SamAccountName,AdminCount
~~~

AdminCount=1 est un indice, pas une preuve suffisante : inspectez les ACL effectives.

## Break-glass

Checklist :
- usage exceptionnel ;
- secret protégé ;
- surveillance ;
- procédure d'autorisation ;
- rotation après usage ;
- revue de chaque utilisation.

## Liens Microsoft

- Least privilege : https://learn.microsoft.com/windows-server/identity/ad-ds/plan/security-best-practices/implementing-least-privilege-administrative-models
- Security groups : https://learn.microsoft.com/windows-server/identity/ad-ds/manage/understand-security-groups
- Protected accounts / AdminSDHolder : https://learn.microsoft.com/windows-server/identity/ad-ds/plan/security-best-practices/appendix-c--protected-accounts-and-groups-in-active-directory
- Account delegation protection : https://learn.microsoft.com/windows/security/identity-protection/access-control/active-directory-accounts
