# M07 — Toolbox Windows LAPS

> Support technique pour implémenter, vérifier et dépanner Windows LAPS dans NovaCorp.

## Pré-requis et logique

Objectif :
- gérer le mot de passe du compte administrateur local ;
- stocker ce secret dans Active Directory ;
- éviter les mots de passe locaux identiques et statiques ;
- contrôler qui peut lire ou réinitialiser le mot de passe.

LAPS protège les comptes locaux. gMSA protège les comptes de service. Une solution PAM va plus loin sur la gouvernance et l’élévation contrôlée.

## Vérifier les prérequis côté AD

~~~powershell
Get-Command *Laps*
Update-LapsADSchema

Get-ADObject -SearchBase (Get-ADRootDSE).SchemaNamingContext -LDAPFilter "(lDAPDisplayName=msLAPS-Password)"
~~~

## Préparer les permissions sur l’OU

~~~powershell
Set-LapsADComputerSelfPermission -Identity "OU=Computers,OU=NovaCorp,DC=novacorp,DC=local"

Set-LapsADReadPasswordPermission -Identity "OU=Computers,OU=NovaCorp,DC=novacorp,DC=local" -AllowedPrincipals "GG_LAPS_Readers"

Set-LapsADResetPasswordPermission -Identity "OU=Computers,OU=NovaCorp,DC=novacorp,DC=local" -AllowedPrincipals "GG_LAPS_Resetters"

Find-LapsADExtendedRights -Identity "OU=Computers,OU=NovaCorp,DC=novacorp,DC=local"
~~~

## Configurer la policy côté client

La configuration peut être faite via GPO : activation LAPS, compte cible, stockage AD, complexité et expiration.

~~~powershell
gpupdate /force
Get-LapsDiagnostics
~~~

## Lire le mot de passe

~~~powershell
Get-LapsADPassword -Identity CLT01
~~~

## Forcer une rotation

~~~powershell
Reset-LapsPassword -Identity CLT01
~~~

## Tests de validation

- lecture autorisée par un membre de GG_LAPS_Readers ;
- lecture refusée pour un compte non autorisé ;
- login local avec le secret LAPS ;
- rotation et invalidation de l’ancien secret.

## Troubleshooting

| Symptôme | Vérification |
|---|---|
| Get-LapsADPassword ne renvoie rien | schéma, GPO, OU, droits SelfPermission |
| le poste n’écrit pas son secret | GPO non appliquée, machine hors OU, droits AD |
| lecture refusée | groupe lecteur, nouveau token |
| rotation sans effet | stratégie non appliquée |
| login local impossible | compte local désactivé ou renommé |

~~~powershell
gpresult /h C:\Temp\laps-gpresult.html
Get-WinEvent -LogName "Microsoft-Windows-LAPS/Operational" -MaxEvents 50
whoami /groups
~~~

## Rollback

- retirer la GPO LAPS ;
- retirer les groupes de lecture/réinitialisation temporaires ;
- retirer les permissions déléguées si nécessaire ;
- documenter le rollback.

## Liens Microsoft

- Windows LAPS overview : https://learn.microsoft.com/windows-server/identity/laps/laps-overview
- Windows LAPS PowerShell : https://learn.microsoft.com/powershell/module/laps/
- Scénario AD DS : https://learn.microsoft.com/windows-server/identity/laps/laps-scenarios-windows-server-active-directory
- Logs LAPS : https://learn.microsoft.com/windows-server/identity/laps/laps-management-event-log
