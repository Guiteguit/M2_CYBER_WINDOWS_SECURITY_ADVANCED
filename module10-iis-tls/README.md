# Module 10 — IIS, TLS et SSO Kerberos

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | AD DS / DNS / KDC | 2 | 4 Go | 60 Go |
| PKI01 | CA NovaCorp | 2 | 4 Go | 60 Go |
| SRV01 | IIS / NovaCorp-Web | 2 | 4–6 Go | 60 Go |
| CLT01 | client domaine / tests Kerberos | 2 | 4–6 Go | 64 Go |


## Prérequis et dépendances

**Réutilise :**
- M02 : DNS, domaine et Kerberos/KDC ;
- M08 : gMSA `NOVACORP\gmsa-demo$` ;
- M09 : `PKI01`, chaîne de confiance et certificat pour `web.novacorp.local`.

**Produit pour la suite :**
- site IIS `NovaCorp-Web` ;
- authentification Windows intégrée ;
- SPN HTTP maîtrisé ;
- preuve Kerberos ;
- distinction TLS / Kerberos / gMSA.

Ces notions sont réutilisées dans M11 pour comparer authentification intégrée et fédération.

## Contexte NovaCorp

NovaCorp souhaite publier un intranet interne sécurisé sur :

```text
https://web.novacorp.local
```

Ce module réutilise les briques construites précédemment :

- **M08** : le gMSA `NOVACORP\gmsa-demo$` ;
- **M09** : la PKI NovaCorp et le certificat TLS de `web.novacorp.local`.

Votre objectif n'est pas de suivre une recette IIS.

Vous devez concevoir, construire, tester et expliquer une architecture dans laquelle :

```text
CLT01
   ↓
https://web.novacorp.local
   ↓
SRV01 / IIS
   ↓
NovaCorp-AppPool
   ↓
NOVACORP\gmsa-demo$
```

avec :

```text
TLS      → confidentialité, intégrité et identité du serveur
Kerberos → authentification de l'utilisateur auprès du service HTTP
gMSA     → identité d'exécution du processus IIS
```

Ces trois mécanismes répondent à des problèmes différents.

---

# Infrastructure imposée

| Élément | Valeur |
|---|---|
| Domaine | `novacorp.local` |
| DC / DNS / KDC | `DC01` |
| Autorité de certification | `PKI01` |
| Serveur IIS | `SRV01` |
| Client domaine | `CLT01` |
| Site | `NovaCorp-Web` |
| URL | `https://web.novacorp.local` |
| Répertoire Web | `C:\inetpub\NovaCorp-Web` |
| Application Pool | `NovaCorp-AppPool` |
| Identité AppPool | `NOVACORP\gmsa-demo$` |
| Certificat | PKI NovaCorp |
| Authentification finale | Windows Authentication / Kerberos |

---

# Objectifs

À la fin du module, vous devez être capables de :

- publier un site IIS avec un nom DNS dédié ;
- réutiliser correctement un certificat issu d'une PKI interne ;
- expliquer le rôle d'un binding HTTPS et du SNI ;
- exécuter un Application Pool avec un gMSA ;
- expliquer les échanges Kerberos **AS-REQ / AS-REP / TGS-REQ / TGS-REP** ;
- distinguer **TGT** et **ticket de service** ;
- expliquer le rôle d'un **SPN** ;
- mettre en place une authentification Windows intégrée ;
- distinguer **Kerberos** de **NTLM** ;
- expliquer le rôle de la zone **Intranet local** du navigateur ;
- démontrer techniquement que Kerberos est utilisé ;
- diagnostiquer un problème DNS, TLS, SPN, IIS ou navigateur.

---

# Règle du module

Vous pouvez utiliser :

- IIS Manager ;
- PowerShell ;
- `appcmd` ;
- les consoles MMC ;
- les outils Kerberos / SPN ;
- la documentation Microsoft.

Le choix de la méthode vous appartient.

Vous devez toutefois être capables d'expliquer :

```text
ce que vous configurez
+
pourquoi vous le configurez
+
comment vous prouvez que cela fonctionne
```

---

# Mission 1 — Publier l'intranet NovaCorp

Construisez sur `SRV01` un site IIS nommé :

```text
NovaCorp-Web
```

qui répond au nom :

```text
web.novacorp.local
```

Contraintes :

- le contenu Web doit être stocké dans `C:\inetpub\NovaCorp-Web` ;
- le DNS interne doit permettre à `CLT01` de résoudre le FQDN ;
- le site doit être accessible depuis `CLT01` ;
- vous devez identifier les composants IIS réellement nécessaires ;
- vous devez conserver une preuve de l'état du site.

## Questions

1. Pourquoi utiliser un FQDN dédié plutôt que `SRV01` directement ?
2. Quel rôle joue le Host Header ?
3. Quelle différence entre le service IIS, un site IIS et un Application Pool ?
4. Pourquoi un test `ping` ne suffit-il pas pour valider un service Web ?

## Preuves attendues

- résolution DNS correcte ;
- port du service accessible ;
- site IIS démarré ;
- réponse HTTP obtenue depuis `CLT01`.

---

# Mission 2 — Passer de HTTP à HTTPS

Réutilisez le certificat délivré par la CA NovaCorp hébergée sur `PKI01` au M09 pour sécuriser :

```text
https://web.novacorp.local
```

Contraintes :

- le certificat doit correspondre au nom réellement utilisé par les clients ;
- la clé privée doit être disponible sur `SRV01` ;
- le client doit faire confiance à la chaîne de certification ;
- le site final doit répondre sur 443 ;
- le SNI doit être compris et justifié.

## Questions

1. Pourquoi un certificat valide pour `SRV01` n'est-il pas forcément valide pour `web.novacorp.local` ?
2. Quelle différence entre Subject, SAN, EKU et clé privée ?
3. À quoi sert SNI ?
4. Que protège TLS ?
5. Que **ne protège pas** TLS ?

## Preuves attendues

- certificat adapté au FQDN ;
- chaîne de confiance valide côté `CLT01` ;
- accès HTTPS sans avertissement ;
- binding HTTPS documenté.

---

# Mission 3 — Exécuter IIS avec le gMSA

Le processus applicatif doit utiliser :

```text
NOVACORP\gmsa-demo$
```

Vous devez :

- créer ou utiliser un Application Pool dédié ;
- associer ce pool à `NovaCorp-Web` ;
- configurer le gMSA comme identité du pool ;
- accorder uniquement les droits NTFS nécessaires au contenu Web ;
- démontrer que le site fonctionne toujours.

## Questions

1. Quelle différence entre l'identité TLS et l'identité du processus IIS ?
2. Pourquoi le gMSA n'a-t-il pas besoin d'un mot de passe saisi manuellement ?
3. Pourquoi ne faut-il pas donner `Full Control` au gMSA sur le répertoire Web ?
4. Quels droits le processus IIS a-t-il réellement besoin d'avoir dans ce scénario ?

## Preuves attendues

- gMSA utilisable depuis `SRV01` ;
- Application Pool démarré ;
- identité du pool documentée ;
- droits NTFS justifiés ;
- site toujours fonctionnel en HTTPS.

---

# Mission 4 — Comprendre Kerberos avant de le configurer

Avant toute configuration SSO, produisez un schéma montrant :

```text
CLT01          DC01 / KDC                  SRV01
  |                |                         |
  |--- AS-REQ ---->|                         |
  |<-- AS-REP -----|                         |
  |     TGT        |                         |
  |                |                         |
  |--- TGS-REQ --->|                         |
  |  HTTP/...      |                         |
  |<-- TGS-REP ----|                         |
  | ticket service |                         |
  |                                          |
  |----------- requête HTTP + ticket ------->|
```

Votre explication doit contenir :

- KDC ;
- TGT ;
- ticket de service ;
- SPN ;
- service HTTP ;
- rôle de l'identité portant le SPN.

## Questions

1. Le mot de passe de l'utilisateur est-il envoyé à `SRV01` ?
2. Quelle différence entre TGT et ticket de service ?
3. Pourquoi Kerberos a-t-il besoin d'un SPN ?
4. Pourquoi un SPN doit-il être unique ?
5. Quelle différence entre l'utilisateur authentifié et l'identité qui exécute IIS ?

---

# Mission 5 — Mettre en place le SSO Windows

Configurez `NovaCorp-Web` afin que l'utilisateur connecté au domaine puisse accéder au site sans ressaisir ses identifiants.

Contraintes :

- Anonymous Authentication doit être désactivée ;
- Windows Authentication doit être activée ;
- **Negotiate** doit être disponible avant NTLM ;
- le SPN HTTP doit correspondre au FQDN réellement utilisé ;
- le SPN doit être porté par l'identité cohérente avec l'architecture de l'Application Pool ;
- le navigateur doit pouvoir envoyer automatiquement l'identité Windows ;
- un simple SSO sans popup ne suffit pas à prouver Kerberos.

Le SPN attendu est lié au service :

```text
HTTP/web.novacorp.local
```

Vous devez déterminer sur quel objet AD il doit être porté et pourquoi.

## Questions

1. Pourquoi Windows Authentication peut-elle fonctionner même si Kerberos échoue ?
2. Que signifie `Negotiate` ?
3. Pourquoi NTLM peut-il masquer une mauvaise configuration Kerberos ?
4. Quel est le lien entre le gMSA, le SPN et l'Application Pool ?
5. Pourquoi l'accès avec un alias DNS différent peut-il modifier le comportement Kerberos ?

---

# Mission 6 — Navigateur et zone Intranet local

Un utilisateur connecté au domaine accède à :

```text
https://web.novacorp.local
```

mais Edge lui demande ses identifiants.

Analysez le rôle des zones de sécurité Windows / navigateur dans l'authentification intégrée.

Votre objectif est d'obtenir :

```text
Utilisateur connecté au domaine
        ↓
navigation vers web.novacorp.local
        ↓
identité Windows envoyée automatiquement
        ↓
aucune nouvelle saisie de mot de passe
```

## Questions

1. Pourquoi un site fonctionnel peut-il tout de même provoquer une popup d'authentification ?
2. Quelle différence entre “le serveur accepte Kerberos” et “le navigateur envoie automatiquement les credentials” ?
3. Pourquoi l'ajout du site à la zone Intranet local peut-il modifier le comportement ?
4. Est-ce une preuve de Kerberos ? Pourquoi ?

---

# Mission 7 — Prouver Kerberos

Le SSO sans mot de passe fonctionne désormais.

Vous devez maintenant prouver que le mécanisme utilisé est bien Kerberos et non un fallback NTLM.

Votre preuve doit inclure au minimum deux angles parmi :

- ticket de service présent sur `CLT01` ;
- vérification du SPN ;
- événement d'authentification côté serveur ;
- autre preuve technique pertinente et expliquée.

Le ticket recherché doit correspondre au service :

```text
HTTP/web.novacorp.local
```

## Critère important

```text
Pas de popup
≠
preuve Kerberos
```

## Questions

1. Quelle preuve considérez-vous comme la plus forte ?
2. Que signifie l'absence de ticket HTTP côté client ?
3. Quel résultat indiquerait un fallback NTLM ?
4. Pourquoi purger les tickets peut-il être utile pendant un diagnostic ?

---

# Mission 8 — Personnaliser l'intranet

Le fichier suivant est fourni :

```text
resources/index.asp
```

Déployez-le afin d'afficher au minimum :

- l'utilisateur AD authentifié ;
- le type d'authentification exposé par IIS ;
- le serveur ;
- la date et l'heure du serveur.

Vous devez déterminer :

- quel composant IIS supplémentaire est nécessaire ;
- comment faire de `index.asp` le document par défaut ;
- comment vérifier que la page s'exécute réellement côté serveur.

## Attention

La variable IIS :

```text
AUTH_TYPE
```

peut aider à comprendre le contexte d'authentification mais **ne suffit pas à prouver à elle seule Kerberos**.

## État du lab de référence

Le lab de référence a validé l'affichage de l'utilisateur authentifié dans la page IIS après configuration de Windows Authentication et du contexte navigateur approprié.

---

# Mission 9 — Troubleshooting

Le formateur peut introduire un ou plusieurs incidents :

- SPN absent ;
- SPN dupliqué ;
- DNS incorrect ;
- fallback NTLM ;
- site non classé en Intranet local.

Pour chaque incident, appliquez :

```text
SYMPTÔME
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

Ne modifiez pas plusieurs paramètres simultanément sans savoir lequel corrige le problème.

---

# Boîte à outils de diagnostic

Ces commandes sont volontairement fournies comme **outils d'observation**, pas comme procédure d'installation.

## DNS / réseau

```powershell
Resolve-DnsName web.novacorp.local
Test-NetConnection web.novacorp.local -Port 443
ipconfig /all
```

## IIS

```powershell
Get-Website
Get-WebBinding
Get-WebAppPoolState
```

## Certificats

```powershell
Get-ChildItem Cert:\LocalMachine\My
```

## gMSA

```powershell
Test-ADServiceAccount gmsa-demo
```

## SPN

```text
setspn -Q <SPN>
setspn -L <compte>
setspn -X
```

## Kerberos

```text
klist
klist purge
klist get <SPN>
```

## Identité

```text
whoami
whoami /groups
```

## Logs

Utilisez :

- Event Viewer ;
- journaux Security ;
- journaux IIS ;
- événements Kerberos / authentification pertinents.

---

# Livrables

Vous devez compléter :

```text
iis-design.md
tls-validation.md
evidence/
```

et fournir votre propre documentation technique de mise en œuvre.

## `iis-design.md`

Doit expliquer :

- architecture IIS ;
- choix du FQDN ;
- Application Pool ;
- gMSA ;
- droits NTFS ;
- modèle d'authentification ;
- SPN ;
- relation entre identité du service et utilisateur authentifié.

## `tls-validation.md`

Doit contenir :

- DNS ;
- validation TLS ;
- chaîne de confiance ;
- binding HTTPS ;
- SSO Windows ;
- preuve Kerberos ;
- résultat de `index.asp`.

---

# Validation du module

Le M10 est terminé uniquement si vous pouvez démontrer :

```text
[ ] web.novacorp.local résout correctement
[ ] le site IIS fonctionne
[ ] HTTPS fonctionne sans avertissement
[ ] le certificat correspond au FQDN
[ ] l'Application Pool utilise le gMSA
[ ] les droits NTFS sont minimaux et justifiés
[ ] Windows Authentication fonctionne
[ ] le SSO navigateur fonctionne
[ ] le SPN HTTP est unique et porté par la bonne identité
[ ] un ticket HTTP est observé ou une preuve Kerberos équivalente est fournie
[ ] Kerberos est distingué explicitement de NTLM
[ ] index.asp affiche l'utilisateur AD
[ ] une panne Kerberos peut être diagnostiquée méthodiquement
```

---

# Questions de restitution

Préparez une réponse courte aux questions suivantes :

1. Pourquoi TLS, Kerberos et gMSA sont-ils complémentaires ?
2. Pourquoi le certificat et le SPN utilisent-ils tous les deux `web.novacorp.local` mais pour des usages différents ?
3. Pourquoi un site accessible sans popup de credentials peut-il encore utiliser NTLM ?
4. Pourquoi le SPN est-il porté par une identité de service ?
5. Que se passerait-il si le SPN HTTP était enregistré sur deux objets AD ?
6. Quel est le rôle exact de la zone Intranet local ?
7. Quelle preuve utilisez-vous pour affirmer : **“Kerberos fonctionne”** ?

---

# Checkpoint M10

```text
IIS fonctionnel
+
TLS valide
+
gMSA opérationnel
+
SSO Windows fonctionnel
+
Kerberos prouvé
+
troubleshooting maîtrisé
```

Snapshot recommandé :

```text
M10-IIS-TLS-KERBEROS-OK
```
