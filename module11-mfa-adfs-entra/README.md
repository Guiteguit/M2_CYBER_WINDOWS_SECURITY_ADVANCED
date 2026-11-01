# Module 11 — MFA, AD FS, fédération et Entra ID

## Contexte NovaCorp

NovaCorp utilise Active Directory Domain Services pour ses identités internes.

Après les modules précédents, l'infrastructure dispose déjà de :

- `DC01` : AD DS, DNS, KDC ;
- `SRV01` : IIS, PKI NovaCorp et applications internes ;
- `CLT01` : poste client joint au domaine ;
- une PKI interne ;
- des gMSA ;
- un premier intranet sécurisé en HTTPS.

Le M11 introduit une nouvelle question :

> Comment une application peut-elle faire confiance à l'identité d'un utilisateur sans interroger directement Active Directory ni connaître son mot de passe ?

Le module repose sur un POC AD FS réel, mais l'objectif n'est pas de devenir expert AD FS.

Vous devez surtout comprendre et démontrer :

```text
AD DS
  ↓
AD FS / Identity Provider
  ↓
Token signé
  ↓
Relying Party
  ↓
Claims consommés par l'application
```

La réussite du module ne dépend pas d'une licence Microsoft 365.

---

# Architecture de référence

```text
DC01
AD DS / DNS
192.168.150.10

SRV01
IIS / PKI / NovaCorp-Claims
192.168.150.20

ADFS01
AD FS / WID
192.168.150.30
fs.novacorp.local

CLT01
Client utilisateur
192.168.150.100
```

Application de démonstration :

```text
https://claims.novacorp.local/
```

Service de fédération :

```text
https://fs.novacorp.local/
```

---

# Objectifs

À la fin du module, vous devez être capables de distinguer clairement :

- AD DS ;
- AD FS ;
- Microsoft Entra ID ;
- MFA ;
- authentification ;
- autorisation ;
- fédération ;
- Identity Provider / IdP ;
- Relying Party / Service Provider ;
- claims ;
- tokens ;
- certificat TLS ;
- certificat Token-Signing ;
- SAML ;
- WS-Federation ;
- OpenID Connect ;
- OAuth 2.0 à haut niveau.

---

# 1. Comprendre avant de construire

## AD DS

AD DS stocke et gère notamment :

- utilisateurs ;
- groupes ;
- ordinateurs ;
- mots de passe ;
- attributs ;
- relations d'appartenance.

AD DS peut authentifier un utilisateur, mais cela ne signifie pas qu'une application externe doit accéder directement à l'annuaire.

## AD FS

AD FS agit comme fournisseur d'identité.

Il peut :

1. authentifier un utilisateur ;
2. récupérer des informations sur son identité ;
3. appliquer des règles de claims ;
4. émettre un token ;
5. signer cryptographiquement ce token.

L'application fait confiance au token, pas au mot de passe de l'utilisateur.

## Relying Party

Une Relying Party est une application qui fait confiance à AD FS.

Dans ce lab :

```text
NovaCorp-Claims
=
Relying Party
```

## Claims

Un claim est une affirmation sur l'utilisateur.

Exemples :

```text
UPN = alice.it@novacorp.local
Role = Admin
Group = GG_IT
AuthenticationMethod = ...
```

Une application ne doit recevoir que les informations dont elle a réellement besoin.

## Token

Le token contient des claims et est signé par AD FS.

```text
AD FS
  ↓
Claims
  ↓
Token
  ↓
Signature Token-Signing
  ↓
Application
```

La signature permet à l'application de vérifier que le token :

- provient bien de l'IdP attendu ;
- n'a pas été modifié.

---

# 2. Mission — Construire le fournisseur d'identité NovaCorp

Déployez un service de fédération dédié :

```text
fs.novacorp.local
```

Contraintes :

- serveur dédié `ADFS01` ;
- Windows Server ;
- membre du domaine `novacorp.local` ;
- certificat TLS issu de la PKI NovaCorp ;
- gMSA dédié au service AD FS ;
- stockage WID acceptable pour ce POC ;
- service accessible en HTTPS depuis CLT01 ;
- ne pas désactiver le firewall Windows pour résoudre un problème.

## Preuves attendues

- résolution DNS ;
- connectivité TCP/443 ;
- service AD FS démarré ;
- propriétés de la ferme ;
- certificats AD FS ;
- test d'authentification réussi.

## Boîte à outils

```powershell
Resolve-DnsName fs.novacorp.local
Test-NetConnection fs.novacorp.local -Port 443
Get-Service adfssrv
Get-AdfsProperties
Get-AdfsCertificate
```

---

# 3. Certificats AD FS

Identifiez et expliquez les rôles suivants :

## Service-Communications

Utilisé pour l'identité TLS du service HTTPS AD FS.

Il doit correspondre à :

```text
fs.novacorp.local
```

## Token-Signing

Utilisé pour signer les tokens émis par AD FS.

Il ne doit pas être confondu avec le certificat TLS.

## Token-Decrypting

Utilisé pour les scénarios nécessitant le déchiffrement de tokens.

## Question

Pourquoi une application peut-elle faire confiance au certificat TLS d'AD FS tout en refusant malgré tout un token signé par AD FS ?

---

# 4. Mission — Créer une relation de confiance

Créez une Relying Party nommée :

```text
NovaCorp-Claims
```

Application :

```text
https://claims.novacorp.local/
```

Protocole retenu pour le POC :

```text
WS-Federation Passive
```

Vous devez être capables d'expliquer :

- Relying Party Identifier / Realm ;
- WS-Federation endpoint ;
- relation de confiance ;
- rôle du paramètre `wtrealm` ;
- pourquoi l'application ne reçoit pas directement le mot de passe.

## Contraintes

- application claims-aware ;
- HTTPS obligatoire ;
- règles de claims minimales ;
- aucun attribut inutile ;
- accès ouvert à tous uniquement pour le POC.

---

# 5. Mission — Construire le flux d'authentification

Produisez un schéma comprenant au minimum :

```text
CLT01
  ↓
NovaCorp-Claims
  ↓ redirection
AD FS
  ↓
AD DS
  ↓
Claims Rules
  ↓
Token signé
  ↓
NovaCorp-Claims
  ↓
Session utilisateur
```

Vous devez identifier :

- où l'identité est stockée ;
- où l'utilisateur est authentifié ;
- où les claims sont construits ;
- où le token est signé ;
- où le token est validé ;
- où la session applicative est créée.

---

# 6. Mission — Claims

Commencez avec un nombre minimal de claims.

Exemple pertinent :

```text
User-Principal-Name → UPN
```

Vous pourrez ensuite enrichir progressivement.

## Questions

1. Pourquoi ne pas envoyer tous les attributs AD ?
2. Que se passe-t-il si un claim attendu est absent ?
3. Une valeur lisible comme "Given Name" est-elle forcément un ClaimType valide ?
4. Quelle différence entre attribut LDAP et type de claim sortant ?

---

# 7. Application NovaCorp-Claims

Une petite application ASP.NET de démonstration est fournie dans :

```text
resources/NovaCorp-Claims/
```

Elle permet d'afficher :

- identité authentifiée ;
- type d'authentification ;
- claims reçus ;
- issuer de chaque claim.

L'objectif n'est pas de développer l'application.

Vous devez en revanche comprendre les paramètres suivants :

```text
issuer
realm
audience
trusted issuer
WS-Federation module
session authentication module
```

## Important

Le fichier `web.config.template` contient des valeurs à adapter au lab.

Ne committez jamais de clé privée ou de secret.

---

# 8. SSO AD FS

Un utilisateur peut être authentifié de deux manières principales dans ce POC :

- formulaire AD FS ;
- Windows Integrated Authentication.

Si l'authentification formulaire fonctionne mais que le SSO transparent ne fonctionne pas, ne considérez pas automatiquement AD FS comme défaillant.

Analysez :

- zone Intranet local ;
- WIA ;
- user-agent navigateur ;
- SPN ;
- fallback Forms.

Le SSO transparent est un objectif secondaire du POC.

La fédération et l'émission du token doivent fonctionner indépendamment.

---

# 9. MFA

Le MFA intervient pendant le processus d'authentification auprès de l'Identity Provider.

```text
Application
  ↓
IdP
  ↓
Authentification primaire
  ↓
MFA éventuel
  ↓
Token
  ↓
Application
```

Répondez :

1. quels facteurs peuvent être combinés ?
2. qu'est-ce que le MFA réduit comme risque ?
3. qu'est-ce qu'il ne protège pas ?
4. comment un token ou une session volée peut-elle contourner le bénéfice du MFA ?
5. pourquoi le MFA doit-il être associé à d'autres contrôles ?

---

# 10. Entra ID — comparaison d'architecture

L'objectif n'est pas de reproduire artificiellement Entra ID dans le lab.

Comparez :

```text
AD FS
→ fédération principalement on-prem

Entra ID
→ Identity Provider cloud
→ applications SaaS
→ MFA
→ Conditional Access
→ identité hybride / cloud
```

Proposez une architecture NovaCorp :

- on-prem ;
- hybride ;
- cloud-first.

Justifiez votre choix selon :

- applications existantes ;
- disponibilité Internet ;
- sécurité ;
- expérience utilisateur ;
- administration ;
- dépendances ;
- coûts ;
- complexité.

---

# 11. Troubleshooting

Le M11 est volontairement accompagné par une méthodologie de diagnostic.

Pour chaque panne :

```text
SYMPTÔME
  ↓
ÉTAPE DU FLUX ATTEINTE
  ↓
HYPOTHÈSES
  ↓
PREUVES
  ↓
CAUSE
  ↓
CORRECTION
  ↓
RETEST
```

Consultez :

```text
troubleshooting.md
```

---

# 12. Répartition des rôles

## Groupe de 5

- A : AD DS / DNS / identité ;
- B : AD FS ;
- C : PKI / certificats / gMSA ;
- D : Relying Party / application ;
- E : client / audit / troubleshooting.

## Groupe de 4

- A : AD DS / identité ;
- B : AD FS ;
- C : PKI + application ;
- D : client + audit.

Les rôles doivent tourner.

Personne ne valide son propre travail.

---

# 13. Livrables

- `identity-architecture.md`
- `authentication-flow.md`
- `security-review.md`
- preuves dans `evidence/`

## identity-architecture.md

Doit contenir :

- situation actuelle ;
- architecture du POC ;
- composants ;
- relations de confiance ;
- rôle des certificats ;
- architecture cible on-prem / hybride / cloud-first ;
- compromis.

## authentication-flow.md

Doit contenir :

- séquence complète ;
- rôle de chaque acteur ;
- protocole ;
- claims ;
- token ;
- signature ;
- session ;
- position du MFA.

## security-review.md

Doit contenir :

- bénéfices ;
- risques ;
- dépendances ;
- limites ;
- points uniques de panne ;
- mesures compensatoires ;
- recommandations.

---

# Validation

```text
[ ] AD DS / AD FS / Entra clairement distingués
[ ] IdP / Relying Party compris
[ ] fs.novacorp.local opérationnel
[ ] certificat TLS valide
[ ] rôle Token-Signing compris
[ ] Relying Party NovaCorp-Claims fonctionnelle
[ ] redirection WS-Federation observée
[ ] token accepté par l'application
[ ] au moins un claim visible
[ ] issuer identifié
[ ] AuthenticationType = Federation ou équivalent observé
[ ] incidents principaux diagnostiqués
[ ] MFA correctement positionné
[ ] architecture cible justifiée
```

---

# Questions de restitution

1. Pourquoi AD FS existe-t-il alors qu'AD DS authentifie déjà les utilisateurs ?
2. Quelle différence entre SSO et fédération ?
3. Quelle différence entre Relying Party et Identity Provider ?
4. Pourquoi l'application n'a-t-elle pas besoin de connaître le mot de passe ?
5. Pourquoi Token-Signing et TLS ne sont-ils pas le même certificat ?
6. Comment déterminer à quelle étape du flux une panne se produit ?
7. Où intervient exactement le MFA ?
8. Pourquoi Entra ID peut-il remplacer certains usages historiques d'AD FS sans être "AD FS dans le cloud" ?

---

# Checkpoint M11

```text
Identité comprise
+
fédération fonctionnelle
+
token observé
+
claims visibles
+
troubleshooting maîtrisé
+
MFA positionné
+
architecture justifiée
```

Snapshot recommandé :

```text
M11-ADFS-FEDERATION-OK
```
