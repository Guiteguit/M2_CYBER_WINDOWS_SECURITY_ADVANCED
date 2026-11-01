# M11 — Troubleshooting AD FS / Fédération

## Méthode

Ne modifiez pas plusieurs paramètres à la fois.

Pour chaque panne :

```text
1. Décrire le symptôme
2. Situer la panne dans le flux
3. Proposer plusieurs hypothèses
4. Collecter une preuve
5. Corriger un seul élément
6. Rejouer le test
7. Conserver la preuve finale
```

---

# Tip 1 — AD FS répond localement mais pas depuis CLT01

## Symptôme

`fs.novacorp.local` fonctionne depuis ADFS01 mais pas depuis le client.

## Outils

```powershell
Resolve-DnsName fs.novacorp.local
Test-NetConnection fs.novacorp.local -Port 443
Get-NetFirewallProfile
Get-NetFirewallRule
Get-Service adfssrv
```

## À retenir

- TCP/443 est le port principal du POC ;
- ne désactivez pas le firewall pour "tester" ;
- créez une règle ciblée sur le profil Domain.

---

# Tip 2 — /adfs/ls/ affiche une erreur

## Symptôme

L'ouverture directe de :

```text
https://fs.novacorp.local/adfs/ls/
```

retourne une erreur.

## Explication

Cet endpoint attend normalement un contexte de protocole.

Une erreur obtenue en ouvrant l'URL directement ne prouve pas que le service AD FS est cassé.

Préférez un test via une vraie Relying Party.

---

# Tip 3 — Formulaire de login au lieu du SSO transparent

## Symptôme

AD FS fonctionne, mais demande les credentials.

## Pistes

- zone Intranet local ;
- Windows Integrated Authentication ;
- user-agent Edge ;
- SPN ;
- fallback Forms.

## Outils

```powershell
Get-AdfsGlobalAuthenticationPolicy
Get-AdfsProperties
setspn -Q HOST/fs.novacorp.local
```

Ne bloquez pas tout le module sur le SSO transparent : l'émission du token reste l'objectif principal.

---

# Incident 4 — MSIS7012 / ClaimType invalide

## Symptôme

Le navigateur affiche une erreur générique AD FS.

Dans le journal AD FS/Admin :

```text
ID4216
ClaimType invalide
```

## Diagnostic

Cherchez les événements récents :

```powershell
Get-WinEvent -LogName "AD FS/Admin" -MaxEvents 30 |
Format-List TimeCreated,Id,LevelDisplayName,Message
```

## Cause typique

Un type de claim sortant a été saisi comme texte arbitraire au lieu d'un ClaimType valide.

## Leçon

Un libellé lisible n'est pas forcément l'identifiant technique du claim.

---

# Incident 5 — Certificat Token-Signing non approuvé

## Symptôme

L'application reçoit le token mais retourne une erreur de validation :

```text
SecurityTokenValidationException
ADFS Signing certificate not trusted
```

## À vérifier

- certificat Token-Signing réellement utilisé ;
- thumbprint ;
- magasin de certificats de l'application ;
- confiance explicite.

## Leçon

```text
TLS certificate
!=
Token-Signing certificate
```

La Relying Party doit pouvoir valider la signature du token.

---

# Incident 6 — ProtectedData / DPAPI / profil utilisateur

## Symptôme

Le token est validé mais la création de session échoue avec une erreur du type :

```text
ProtectedDataCookieTransform
CryptographicException
user profile not loaded
```

## Cause typique

Le profil utilisateur de l'Application Pool n'est pas chargé.

## Vérification

```powershell
(Get-ItemProperty "IIS:\AppPools\NovaCorp-ClaimsPool").processModel.loadUserProfile
```

## Leçon

Une authentification fédérée peut réussir alors que l'application échoue ensuite pendant la création de sa session.

---

# Incident 7 — Mauvais Realm / Relying Party

## Symptômes

- redirection AD FS ;
- erreur après redirection ;
- relying party inconnue.

## Vérification

```powershell
Get-AdfsRelyingPartyTrust -Name "NovaCorp-Claims" |
Format-List Name,Enabled,Identifier,WSFedEndpoint,AccessControlPolicyName
```

Comparez :

- `realm` côté application ;
- `Identifier` côté AD FS ;
- endpoint de retour.

---

# Incident 8 — Où est réellement la panne ?

Utilisez le flux :

```text
CLIENT
  ↓
DNS
  ↓
HTTPS
  ↓
APPLICATION
  ↓
REDIRECTION
  ↓
AD FS
  ↓
AD DS
  ↓
CLAIMS RULES
  ↓
TOKEN SIGNING
  ↓
APPLICATION
  ↓
VALIDATION TOKEN
  ↓
COOKIE SESSION
  ↓
UTILISATEUR CONNECTÉ
```

Pour chaque symptôme, indiquez la dernière étape certaine qui fonctionne.

---

# Matrice de restitution

| Incident | Dernière étape OK | Hypothèses | Preuve | Cause | Correction | Retest |
|---|---|---|---|---|---|---|
| Firewall | | | | | | |
| SSO transparent | | | | | | |
| ClaimType | | | | | | |
| Token-Signing | | | | | | |
| DPAPI | | | | | | |
| Realm / RP | | | | | | |
