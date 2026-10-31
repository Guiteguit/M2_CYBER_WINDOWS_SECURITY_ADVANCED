# Module 10 — IIS, TLS et SSO Kerberos

## Contexte NovaCorp

NovaCorp souhaite publier un intranet interne sécurisé sur :

```text
https://web.novacorp.local
```

Le module réutilise directement les briques construites précédemment :

- **M08** : compte de service géré `NOVACORP\\gmsa-demo$` ;
- **M09** : PKI NovaCorp et certificat TLS valide pour `web.novacorp.local` ;
- **M10** : IIS, TLS, identité de processus, authentification Windows et SSO Kerberos.

L'objectif n'est pas seulement d'obtenir un cadenas HTTPS. Vous devez distinguer quatre sujets différents :

```text
TLS      → protège le transport et authentifie le serveur
IIS      → publie l'application Web
Kerberos → authentifie l'utilisateur auprès du service HTTP
MFA      → ajoute un ou plusieurs facteurs à une authentification
```

Un site peut donc être correctement protégé en TLS tout en utilisant une mauvaise identité de processus, ou fonctionner en SSO Windows tout en retombant sur NTLM.

---

## Infrastructure

| Élément | Valeur |
|---|---|
| Domaine | `novacorp.local` |
| DC / DNS / KDC | `DC01` |
| Serveur IIS | `SRV01` |
| Client domaine | `CLT01` |
| Site | `NovaCorp-Web` |
| URL | `https://web.novacorp.local` |
| Répertoire Web | `C:\\inetpub\\NovaCorp-Web` |
| Application Pool | `NovaCorp-AppPool` |
| Identité AppPool | `NOVACORP\\gmsa-demo$` |
| SPN HTTP | `HTTP/web.novacorp.local` |
| Certificat | émis par la PKI NovaCorp |

---

# Objectifs

À la fin du module, vous devez être capables de :

- installer et valider IIS ;
- publier un site avec un nom DNS dédié ;
- réutiliser un certificat issu d'une PKI interne ;
- configurer un binding HTTPS avec SNI ;
- exécuter un Application Pool avec un gMSA ;
- expliquer les échanges Kerberos **AS-REQ / AS-REP / TGS-REQ / TGS-REP** ;
- distinguer **TGT** et **ticket de service** ;
- expliquer le rôle d'un **SPN** ;
- configurer Windows Authentication sur IIS ;
- distinguer **Kerberos** de **NTLM** ;
- expliquer le rôle de la zone **Intranet local** pour l'authentification intégrée du navigateur ;
- prouver, par des éléments techniques, si Kerberos est réellement utilisé ;
- diagnostiquer un SPN absent, dupliqué ou porté par le mauvais compte.

---

# 1. Installer et valider IIS

Sur `SRV01` :

```powershell
Install-WindowsFeature `
    Web-Server, `
    Web-Windows-Auth, `
    Web-Mgmt-Console `
    -IncludeManagementTools
```

Vérifiez le service et le site par défaut :

```powershell
Get-Service W3SVC
Get-Website
Invoke-WebRequest http://localhost -UseBasicParsing
```

Résultats attendus :

```text
W3SVC = Running
Default Web Site = Started
HTTP local = 200
```

Créez ensuite le répertoire du site :

```powershell
New-Item -Path "C:\inetpub\NovaCorp-Web" `
    -ItemType Directory -Force
```

Puis le site :

```powershell
Import-Module WebAdministration

New-Website `
    -Name "NovaCorp-Web" `
    -PhysicalPath "C:\inetpub\NovaCorp-Web" `
    -Port 80 `
    -HostHeader "web.novacorp.local"
```

Le DNS interne doit résoudre :

```text
web.novacorp.local → SRV01
```

Depuis `CLT01`, vérifiez d'abord la résolution DNS puis l'accès HTTP.

```powershell
Resolve-DnsName web.novacorp.local
Test-NetConnection web.novacorp.local -Port 80
```

---

# 2. Réutiliser la PKI NovaCorp

Le certificat créé au M09 doit correspondre au **nom réellement utilisé par les clients** :

```text
web.novacorp.local
```

Vérifiez le magasin machine de `SRV01` :

```powershell
Get-ChildItem Cert:\LocalMachine\My |
    Select-Object Subject,Issuer,NotAfter,HasPrivateKey,Thumbprint
```

Contrôles attendus :

- SAN contenant `web.novacorp.local` ;
- EKU **Server Authentication** ;
- certificat non expiré ;
- `HasPrivateKey = True` ;
- chaîne reconnue par `CLT01`.

> Un certificat valide pour `SRV01` n'est pas automatiquement valide pour `web.novacorp.local`. Le SAN doit correspondre au nom utilisé dans l'URL.

---

# 3. Configurer HTTPS

Ajoutez une liaison IIS :

```text
Type     : https
Port     : 443
Hostname : web.novacorp.local
SNI      : activé
Certificat : certificat NovaCorp du site
```

Vérifiez :

```powershell
Get-WebBinding -Name "NovaCorp-Web"
netsh http show sslcert
```

Depuis `CLT01` :

```powershell
Test-NetConnection web.novacorp.local -Port 443
```

Puis ouvrez :

```text
https://web.novacorp.local
```

Le navigateur doit présenter le site **sans avertissement de certificat**.

---

# 4. Exécuter IIS avec un gMSA

Le compte `gmsa-demo$` a été préparé au M08.

Sur `SRV01`, vérifiez :

```powershell
Test-ADServiceAccount -Identity gmsa-demo
```

Résultat attendu :

```text
True
```

Créez l'Application Pool :

```powershell
New-WebAppPool -Name "NovaCorp-AppPool"

Set-ItemProperty "IIS:\AppPools\NovaCorp-AppPool" `
    -Name managedRuntimeVersion -Value ""
```

Configurez son identité :

```powershell
$appcmd = "$env:windir\System32\inetsrv\appcmd.exe"

& $appcmd set apppool "NovaCorp-AppPool" `
    /processModel.identityType:SpecificUser `
    /processModel.userName:"NOVACORP\gmsa-demo$" `
    /processModel.password:""
```

Donnez uniquement les droits nécessaires sur le contenu Web :

```powershell
icacls "C:\inetpub\NovaCorp-Web" /grant 'NOVACORP\gmsa-demo$:(OI)(CI)RX'
```

Associez le pool au site :

```powershell
Set-ItemProperty "IIS:\Sites\NovaCorp-Web" `
    -Name applicationPool -Value "NovaCorp-AppPool"

Restart-WebAppPool "NovaCorp-AppPool"
```

Validez que le site continue de répondre en HTTPS.

## Point pédagogique

```text
Identité TLS            ≠ identité du processus
web.novacorp.local        NOVACORP\gmsa-demo$
```

Le certificat identifie le **serveur Web auprès du client**.
Le gMSA identifie le **processus IIS auprès de Windows / Active Directory**.

---

# 5. Kerberos — fonctionnement théorique

## Les acteurs

```text
CLT01                   DC01 / KDC                     SRV01 / IIS
Utilisateur             Active Directory              web.novacorp.local
                                                   AppPool : gmsa-demo$
```

Le KDC est porté par les contrôleurs de domaine et fournit deux services logiques :

- **AS — Authentication Service** : délivre le TGT ;
- **TGS — Ticket Granting Service** : délivre les tickets de service.

## Étape 1 — obtenir un TGT

```text
CLT01                     DC01
  |                        |
  |------ AS-REQ --------->|
  |<----- AS-REP ----------|
  |                        |
  |   TGT obtenu           |
```

Le **TGT** ne donne pas accès directement au site IIS. Il sert à demander d'autres tickets au KDC.

## Étape 2 — demander un ticket HTTP

Lorsque l'utilisateur ouvre :

```text
https://web.novacorp.local
```

le client doit identifier le service :

```text
HTTP/web.novacorp.local
```

Il demande alors un ticket :

```text
CLT01                     DC01
  |                        |
  |------ TGS-REQ -------->|
  |   HTTP/web...          |
  |<----- TGS-REP ---------|
  |                        |
  | ticket de service HTTP |
```

## Étape 3 — présenter le ticket à IIS

```text
CLT01                                     SRV01
  |                                         |
  |---- HTTPS + ticket Kerberos ----------->|
  |                                         |
  |                     IIS valide l'identité
  |<------------- page intranet ------------|
```

### Vue complète

```text
             1. AS-REQ / AS-REP
CLT01  <---------------------------->  DC01 / KDC
  |                                      |
  |             TGT                      |
  |                                      |
  |        2. TGS-REQ / TGS-REP          |
  |        HTTP/web.novacorp.local       |
  |<------------------------------------>|
  |
  | 3. HTTPS + ticket de service
  +----------------------------------------------> SRV01 / IIS
                                                   |
                                                   | AppPool
                                                   v
                                            NOVACORP\gmsa-demo$
```

---

# 6. SPN — l'identité Kerberos du service

Un **Service Principal Name** associe un nom de service à l'identité AD qui exécute ce service.

Dans ce lab :

```text
Service demandé : HTTP/web.novacorp.local
Identité IIS     : NOVACORP\gmsa-demo$
```

Vérifiez d'abord l'existence du SPN :

```powershell
setspn -Q HTTP/web.novacorp.local
```

Puis enregistrez-le sur le gMSA si nécessaire :

```powershell
setspn -S HTTP/web.novacorp.local NOVACORP\gmsa-demo$
```

Vérifiez :

```powershell
setspn -L NOVACORP\gmsa-demo$
```

Utilisez `-S`, pas `-A`, car `-S` recherche les doublons avant l'ajout.

## Pourquoi un doublon est dangereux ?

Kerberos doit savoir **quel compte possède le service**. Si le même SPN existe sur plusieurs objets AD, l'identité cible devient ambiguë et l'authentification Kerberos peut échouer.

Recherche globale de doublons :

```powershell
setspn -X
```

---

# 7. Authentification Windows dans IIS

Sur `NovaCorp-Web` :

```text
Anonymous Authentication → Disabled
Windows Authentication   → Enabled
```

Dans les providers de Windows Authentication :

```text
1. Negotiate
2. NTLM
```

`Negotiate` doit être placé avant `NTLM` : il permet d'utiliser Kerberos lorsque les conditions sont réunies, avec NTLM comme mécanisme de repli possible.

Dans l'éditeur de configuration IIS :

```text
system.webServer/security/authentication/windowsAuthentication
```

Paramètres du lab :

```text
enabled               = True
useKernelMode          = True
useAppPoolCredentials  = True
```

Dans cette architecture, `HTTP/web.novacorp.local` est porté par le gMSA de l'Application Pool. `useAppPoolCredentials` permet à IIS d'utiliser cette identité pour l'authentification Kerberos au lieu de s'appuyer uniquement sur l'identité machine.

> Ne confondez pas **l'utilisateur authentifié** (`NOVACORP\\alice...`) et **l'identité qui exécute le worker process IIS** (`NOVACORP\\gmsa-demo$`).

---

# 8. Navigateur et zone Intranet local

Lors du TP, Edge demandait les credentials Windows alors que l'utilisateur était déjà connecté au domaine.

Le site n'était pas considéré comme appartenant à la zone **Intranet local** permettant l'envoi automatique de l'identité Windows selon la configuration du poste.

Sur `CLT01` :

```text
inetcpl.cpl
→ Sécurité
→ Intranet local
→ Sites
→ Avancé
→ ajouter https://web.novacorp.local
```

Relancez Edge et retestez.

Résultat observé dans le lab :

```text
Avant  → demande interactive d'identifiants
Après  → accès SSO sans nouvelle saisie
```

## Attention

Cela prouve que **l'authentification Windows intégrée fonctionne**.

Cela ne prouve **pas** que Kerberos est utilisé : `Negotiate` peut, selon le contexte, utiliser NTLM.

---

# 9. Prouver Kerberos — validation encore à finaliser

> **État du lab : SSO validé, preuve explicite Kerberos à finaliser.**

Depuis `CLT01`, connecté avec un utilisateur du domaine :

```powershell
whoami
klist
```

Vous pouvez purger les tickets du contexte utilisateur avant un test contrôlé :

```powershell
klist purge
```

Puis demandez explicitement le ticket du service :

```powershell
klist get HTTP/web.novacorp.local
```

Accédez ensuite au site :

```text
https://web.novacorp.local
```

Puis :

```powershell
klist
```

Vous devez rechercher un ticket :

```text
HTTP/web.novacorp.local
```

Complétez par les événements de sécurité sur `SRV01` si l'audit correspondant est activé. Pour une connexion réussie, inspectez notamment l'événement **4624** et le champ du package d'authentification.

## Critère de validation

Ne validez pas “Kerberos fonctionne” uniquement parce que :

- la page s'ouvre sans mot de passe ;
- `AUTH_TYPE` affiche une authentification Windows ;
- le navigateur affiche le site correctement.

Une preuve Kerberos doit identifier explicitement un ticket / package Kerberos.

---

# 10. Intranet dynamique Classic ASP

Le fichier fourni dans :

```text
resources/index.asp
```

affiche :

- l'utilisateur Windows authentifié ;
- la valeur IIS `AUTH_TYPE` ;
- le serveur Web ;
- la date et l'heure du serveur.

Installez Classic ASP :

```powershell
Install-WindowsFeature Web-ASP
```

Copiez le fichier dans :

```text
C:\inetpub\NovaCorp-Web\index.asp
```

Ajoutez `index.asp` comme document par défaut et placez-le avant `index.html`, ou supprimez l'ancien fichier de démonstration si votre consigne le permet.

## Validation attendue

La page doit afficher l'identité de l'utilisateur authentifié, par exemple :

```text
NOVACORP\alice.it
```

et une valeur d'authentification IIS cohérente.

> **État du lab : page fournie mais validation d'exécution encore à réaliser.**

`AUTH_TYPE` ne suffit pas à distinguer Kerberos de NTLM. Utilisez les contrôles de la section précédente pour la preuve protocolaire.

---

# 11. Troubleshooting guidé

Travaillez les incidents détaillés dans :

```text
troubleshooting.md
```

Scénarios :

1. SPN absent ;
2. SPN dupliqué ;
3. DNS incorrect ;
4. fallback NTLM ;
5. site absent de la zone Intranet local.

Pour chaque panne, appliquez la méthode :

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
VALIDATION
```

Ne corrigez pas avant d'avoir produit au moins une preuve technique.

---

# 12. Questions pédagogiques

1. Quelle différence entre TLS et Kerberos ?
2. Pourquoi le certificat doit-il contenir `web.novacorp.local` dans ses SAN ?
3. Quel rôle joue le KDC ?
4. Quelle différence entre un TGT et un ticket de service ?
5. À quoi sert le SPN `HTTP/web.novacorp.local` ?
6. Pourquoi le SPN est-il enregistré sur `gmsa-demo$` dans notre architecture ?
7. Quelle différence entre l'utilisateur authentifié et l'identité de l'Application Pool ?
8. Pourquoi `Negotiate` n'est-il pas une preuve de Kerberos ?
9. Pourquoi la zone Intranet local peut-elle modifier le comportement SSO du navigateur ?
10. Pourquoi `AUTH_TYPE` ne permet-il pas de conclure à Kerberos ?
11. Quel problème un SPN dupliqué peut-il provoquer ?
12. Que protège HTTPS si l'utilisateur est authentifié par Kerberos ?
13. Un gMSA apporte-t-il du MFA ? Expliquez.
14. Pourquoi une page HTTPS fonctionnelle n'est-elle pas une preuve que l'architecture est correctement sécurisée ?

La correction formateur est fournie séparément dans `correction-formateur.md`.

---

# Livrables

- `iis-design.md`
- `tls-validation.md`
- `troubleshooting.md`
- preuves dans `evidence/`

Le fichier `resources/index.asp` est fourni comme ressource de laboratoire.

---

# Validation M10

```text
[ ] DNS web.novacorp.local correct
[ ] IIS et NovaCorp-Web fonctionnels
[ ] certificat web.novacorp.local valide
[ ] HTTPS sans avertissement depuis CLT01
[ ] NovaCorp-AppPool utilise gmsa-demo$
[ ] Test-ADServiceAccount = True
[ ] Anonymous Authentication désactivée
[ ] Windows Authentication activée
[ ] Negotiate placé avant NTLM
[ ] SPN HTTP/web.novacorp.local unique et porté par gmsa-demo$
[ ] SSO navigateur sans saisie de credentials
[ ] ticket HTTP/web.novacorp.local explicitement observé OU autre preuve Kerberos équivalente
[ ] index.asp affiche l'utilisateur AD attendu
[ ] AUTH_TYPE interprété sans le confondre avec la preuve Kerberos
[ ] au moins un scénario de troubleshooting diagnostiqué avec preuves
```

## État actuel du lab de référence

```text
IIS / HTTP               ✅ validé
TLS / HTTPS              ✅ validé
Certificat PKI           ✅ validé
Application Pool gMSA    ✅ validé
SSO Windows              ✅ validé
Preuve Kerberos          ⏳ à finaliser
Page index.asp            ⏳ à tester
```

Ne marquez pas M10 comme complètement terminé avant validation des deux derniers points.

---

# Checkpoint CP10

Le groupe doit pouvoir expliquer et démontrer :

```text
DNS
 ↓
TLS / PKI
 ↓
IIS
 ↓
gMSA
 ↓
SPN
 ↓
Kerberos / Windows Authentication
 ↓
SSO navigateur
 ↓
preuve technique
```

La réussite du module dépend autant de la **preuve du protocole réellement utilisé** que du fait que la page Web s'affiche.
