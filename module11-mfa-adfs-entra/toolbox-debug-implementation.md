# M11 — Toolbox ADFS / Fédération / MFA

> Support technique pour comprendre, implémenter et dépanner ADFS dans le lab NovaCorp.

## 1. Rappel conceptuel

ADFS n’est pas “juste du SSO”.

ADFS est un **Identity Provider / Security Token Service** qui :
- authentifie l’utilisateur ;
- émet des claims ;
- permet la fédération avec une application ou un service qui lui fait confiance.

SSO = expérience utilisateur.
ADFS = brique de fédération / émission de jetons.

## 2. Vérifier le rôle et le service

Sur le serveur ADFS :

```powershell
Get-WindowsFeature ADFS-Federation
Get-Service adfssrv
Get-AdfsProperties
```

## 3. Vérifier le certificat de service

```powershell
Get-AdfsSslCertificate
Get-AdfsCertificate | Select CertificateType,Thumbprint,NotAfter
Get-ChildItem Cert:\LocalMachine\My | Select Subject,Thumbprint,NotAfter
```

Vérifier :
- le certificat SSL correspond au nom de service ADFS ;
- chaîne de confiance OK ;
- certificat non expiré.

## 4. Vérifier DNS et connectivité

Depuis CLT01 :

```powershell
Resolve-DnsName fs.novacorp.local
Test-NetConnection fs.novacorp.local -Port 443
```

## 5. Pare-feu Windows / accès

S’assurer que le serveur ADFS autorise les flux nécessaires, en particulier HTTPS 443.

```powershell
Get-NetFirewallRule | Where-Object DisplayName -match "ADFS|443|HTTPS"
```

## 6. Relying Party Trust / application de test

Vérifier :
- la relying party trust existe ;
- l’URL de reply / redirection est correcte ;
- les règles de claims sont cohérentes.

```powershell
Get-AdfsRelyingPartyTrust | Select Name,Enabled,Identifier
Get-AdfsClaimDescription
```

## 7. Claims et annuaire

Si une application attend `Given Name`, `E-Mail Address` ou autre claim :
- vérifier l’attribut AD ;
- vérifier la règle d’émission ;
- vérifier le mapping demandé par l’application.

## 8. Tests de validation

- accès au service ADFS ;
- certificat valide ;
- login AD ;
- redirection vers l’application ;
- claims transmises et contrôlées.

## 9. Troubleshooting

| Symptôme | Vérification |
|---|---|
| page ADFS inaccessible | service `adfssrv`, DNS, 443, certificat |
| redirection mais échec applicatif | reply URL / trust / claims |
| claim manquante | attribut AD, règle de mapping |
| erreur après authentification | relying party, token-signing, règles |
| portail OK mais app KO | fédération partielle |
| caractères bizarres | encodage UTF-8 |

```powershell
Get-AdfsCertificate | Where-Object CertificateType -eq "Token-Signing"
Get-WinEvent -LogName "AD FS/Admin" -MaxEvents 50
```

## 10. MFA / logique pédagogique

Les étudiants doivent distinguer :
- authentification primaire ;
- MFA ;
- claims ;
- fédération ;
- SSO.

## 11. Rollback

- désactiver ou supprimer la relying party de test ;
- retirer les règles de claims temporaires ;
- revenir à une app de test minimale ;
- conserver la config fonctionnelle validée.

## 12. Liens Microsoft

- ADFS overview : https://learn.microsoft.com/windows-server/identity/ad-fs/ad-fs-overview
- ADFS PowerShell : https://learn.microsoft.com/powershell/module/adfs/
- Claims rules language : https://learn.microsoft.com/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claim-rule-language
- Troubleshooting AD FS : https://learn.microsoft.com/windows-server/identity/ad-fs/troubleshooting/ad-fs-tshoot-intro
