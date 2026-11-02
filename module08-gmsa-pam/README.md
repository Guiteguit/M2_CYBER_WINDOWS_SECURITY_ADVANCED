# Module 08 — gMSA & concepts PAM

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | AD DS / KDS / gMSA | 2 | 4 Go | 60 Go |
| SRV01 | hôte du service utilisant le gMSA | 2 | 4–6 Go | 60 Go |
| CLT01 | validation / administration | 2 | 4 Go | 64 Go |


## Prérequis et dépendances

**Réutilise :**
- M02 : domaine AD et objets ordinateur ;
- M06 : séparation des privilèges et comptes administratifs ;
- M07 : logique de rotation et de délégation de secrets.

**Produit pour la suite :**
- KDS Root Key validée ;
- groupe d'hôtes autorisés ;
- gMSA `NOVACORP\gmsa-demo$` utilisable sur `SRV01` ;
- comparaison LAPS / gMSA / PAM.

Le gMSA sera réutilisé directement dans M10 pour l'Application Pool IIS et la logique gMSA sera reprise dans M11 pour AD FS.

## Objectifs

À la fin de ce module, vous devez être capables de :

- comprendre pourquoi les comptes de service classiques à mot de passe statique représentent un risque ;
- mettre en place un **gMSA** pour exécuter un service sans mot de passe administré manuellement ;
- limiter précisément les machines autorisées à utiliser ce compte ;
- vérifier qu’un service fonctionne réellement avec cette identité ;
- distinguer les rôles de **Windows LAPS**, **gMSA** et d’une solution **PAM** ;
- identifier les limites d’un modèle reposant sur des privilèges permanents ;
- proposer une architecture de gestion des accès privilégiés adaptée à NovaCorp.

---

# Contexte NovaCorp

NovaCorp possède plusieurs services Windows nécessitant une identité de domaine.

Historiquement, les administrateurs pourraient être tentés de créer des comptes de ce type :

```text
svc_web
svc_backup
svc_app
```

avec :

- un mot de passe défini manuellement ;
- un mot de passe rarement renouvelé ;
- éventuellement l’option `PasswordNeverExpires` ;
- un secret connu de plusieurs administrateurs ;
- parfois le même secret utilisé sur plusieurs systèmes ;
- parfois des privilèges excessifs.

Cette architecture doit être améliorée.

Vous devez également analyser la gestion des **comptes privilégiés humains** de NovaCorp.

---

# Partie A — Comprendre le problème des comptes de service

Avant toute modification, expliquez :

1. pourquoi un compte de service avec un mot de passe statique représente un risque ;
2. pourquoi `PasswordNeverExpires` ne constitue pas une solution ;
3. quels problèmes apparaissent lorsqu’un mot de passe de service est utilisé dans :
   - un script ;
   - un fichier de configuration ;
   - une tâche planifiée ;
   - un service Windows ;
4. pourquoi un service a besoin d’une **identité**, mais pas nécessairement d’un mot de passe connu par un humain.

Documentez vos réponses dans :

```text
gmsa-design.md
```

---

# Partie B — Préparer l’utilisation d’un gMSA

NovaCorp souhaite exécuter un service sur :

```text
SRV01
```

avec une identité dédiée.

Vous devez construire une architecture permettant :

```text
SRV01
   ↓
Service Windows
   ↓
gMSA
   ↓
Mot de passe géré automatiquement par Active Directory
```

Le mot de passe du compte ne doit pas être connu ni saisi manuellement par un administrateur.

---

# Partie C — KDS Root Key

Un environnement Active Directory utilisant des gMSA nécessite une infrastructure permettant à Active Directory de générer les secrets associés.

Identifiez :

- le rôle de la **KDS Root Key** ;
- si une clé existe déjà dans votre forêt ;
- pourquoi la création d’une nouvelle clé ne doit pas être faite sans vérification préalable ;
- la différence entre un environnement mono-DC de laboratoire et un environnement Active Directory multi-DC en production.

Conservez une preuve de votre vérification.

---

# Partie D — Définir les machines autorisées

Créez un groupe de sécurité permettant d’identifier les serveurs autorisés à utiliser le gMSA.

Architecture cible :

```text
GG_GMSA_DEMO_HOSTS
        ↓
      SRV01$
        ↓
   autorisé à utiliser
        ↓
     gmsa-demo$
```

Vous devez être capables d’expliquer :

- pourquoi l’objet ordinateur apparaît avec un `$` ;
- pourquoi il est préférable d’utiliser un groupe plutôt que d’autoriser arbitrairement plusieurs machines ;
- ce qui empêcherait une machine non autorisée de récupérer le secret du gMSA.

---

# Partie E — Créer le gMSA

Créez un gMSA nommé :

```text
gmsa-demo
```

Le compte devra être utilisable uniquement par les machines explicitement autorisées.

Vérifiez ensuite :

- que le compte existe dans Active Directory ;
- quels hôtes sont autorisés à récupérer son secret ;
- que `SRV01` est bien présent dans cette liste.

---

# Partie F — Installer et tester le gMSA sur SRV01

Sur `SRV01`, préparez le système pour utiliser le compte de service.

Votre objectif est d’obtenir un test fonctionnel du gMSA.

Vous devez être capables de prouver que :

```text
SRV01
   ↓
peut utiliser gmsa-demo
```

et qu’un serveur non autorisé ne devrait pas pouvoir faire de même.

Conservez les éléments de preuve dans :

```text
evidence/
```

---

# Partie G — Utiliser le gMSA avec un vrai service

Choisissez un service Windows ou une application adaptée au laboratoire.

Configurez-le pour utiliser :

```text
NOVACORP\gmsa-demo$
```

Le service doit fonctionner sans qu’aucun mot de passe du compte ne soit saisi ou stocké manuellement.

Vous devez prouver :

- que le service démarre ;
- qu’il s’exécute sous l’identité attendue ;
- qu’aucun mot de passe statique n’est utilisé ;
- que la machine exécutant le service est explicitement autorisée à utiliser le gMSA.

---

# Partie H — Réflexion PAM

La mise en place de Windows LAPS et d’un gMSA améliore fortement la sécurité.

Mais NovaCorp utilise encore des comptes privilégiés humains.

Exemple :

```text
admin.gaetan
        ↓
Domain Admin permanent
```

Vous devez maintenant déterminer si :

```text
Windows LAPS + gMSA
```

suffisent à constituer une solution complète de gestion des accès privilégiés.

Ne vous contentez pas de donner une définition du PAM.

Analysez le problème.

---

# Scénario

NovaCorp possède :

- 6 administrateurs ;
- plusieurs serveurs critiques ;
- des comptes Domain Admin ;
- un prestataire externe intervenant environ deux heures par mois ;
- des applications nécessitant des comptes de service.

Aujourd’hui, certains privilèges pourraient être accordés en permanence.

La direction souhaite réduire le risque lié à la compromission d’un compte administrateur.

---

# Travail demandé

Recherchez et expliquez les notions suivantes :

- Privileged Access Management ;
- Just-In-Time access ;
- Just Enough Administration ;
- élévation temporaire de privilèges ;
- approbation d’un accès ;
- MFA pour les opérations privilégiées ;
- coffre-fort de secrets ;
- rotation des secrets ;
- journalisation des accès privilégiés ;
- enregistrement des sessions administratives ;
- comptes d’administration permanents ;
- accès ponctuel d’un prestataire.

---

# Analyse comparative

Complétez et justifiez un tableau de ce type :

| Besoin | Windows LAPS | gMSA | PAM |
|---|---|---|---|
| Gestion des administrateurs locaux | ? | ? | ? |
| Comptes de service | ? | ? | ? |
| Rotation automatique des secrets | ? | ? | ? |
| Just-In-Time | ? | ? | ? |
| MFA | ? | ? | ? |
| Approbation d’une élévation | ? | ? | ? |
| Limitation temporelle des privilèges | ? | ? | ? |
| Traçabilité des actions | ? | ? | ? |
| Enregistrement des sessions | ? | ? | ? |
| Gestion des prestataires | ? | ? | ? |

Les réponses doivent être argumentées.

---

# Questions de réflexion

Votre document doit répondre au minimum aux questions suivantes.

### 1. Windows LAPS

Quel problème Windows LAPS résout-il ?

Quels problèmes ne résout-il pas ?

---

### 2. gMSA

Quel problème un gMSA résout-il ?

Pourquoi est-il préférable à un compte :

```text
svc_application
PasswordNeverExpires = True
```

dans de nombreux scénarios ?

---

### 3. Comptes privilégiés

Pourquoi un compte :

```text
Domain Admin
```

utilisé en permanence représente-t-il un risque important ?

---

### 4. Just-In-Time

Quel serait l'intérêt de transformer :

```text
admin.gaetan
→ Domain Admin permanent
```

en :

```text
admin.gaetan
→ Domain Admin pendant une durée limitée
```

?

---

### 5. Approbation

Dans quels scénarios une demande de privilège pourrait-elle nécessiter :

```text
demande
   ↓
validation
   ↓
élévation temporaire
```

?

---

### 6. Prestataire externe

Le prestataire NovaCorp intervient deux heures par mois.

Proposez une méthode permettant :

- de limiter la durée de son accès ;
- de limiter les systèmes accessibles ;
- d'éviter un privilège permanent ;
- de tracer les actions réalisées ;
- de révoquer automatiquement l'accès après l'intervention.

---

### 7. Architecture cible

Proposez une architecture simplifiée permettant d'obtenir quelque chose de ce type :

```text
Utilisateur standard
        ↓

Compte d'administration séparé
        ↓

Demande d'élévation
        ↓

MFA / approbation
        ↓

Privilège temporaire
        ↓

Session administrateur
        ↓

Journalisation
        ↓

Expiration automatique
```

Vous pouvez vous inspirer de solutions du marché telles que :

- CyberArk ;
- Wallix ;
- BeyondTrust ;
- Delinea ;

sans installer ces produits.

---

# Question expert

Expliquez la différence entre :

```text
LAPS
gMSA
PAM
```

et pourquoi ces technologies sont davantage **complémentaires** que concurrentes.

---

# Bonus — SPN

Identifiez le rôle d'un :

```text
Service Principal Name
```

et expliquez :

- son lien avec Kerberos ;
- pourquoi certains services nécessitent un SPN ;
- dans quels scénarios un SPN pourrait être associé à un gMSA.

Aucune modification complexe de l'infrastructure Kerberos n'est demandée.

---

# Livrables

Vous devez produire :

```text
gmsa-design.md
pam-gap-analysis.md
evidence/
```

## `gmsa-design.md`

Doit contenir au minimum :

- problème initial ;
- architecture gMSA ;
- rôle de la KDS Root Key ;
- machines autorisées ;
- compte gMSA créé ;
- service choisi ;
- méthode de validation ;
- risques évités.

## `pam-gap-analysis.md`

Doit contenir au minimum :

- différences LAPS / gMSA / PAM ;
- analyse des privilèges permanents ;
- JIT ;
- MFA ;
- approbation ;
- audit ;
- gestion d'un prestataire ;
- tableau comparatif ;
- architecture cible NovaCorp ;
- conclusion argumentée.

---

# Validation

Le module est considéré comme réussi si vous pouvez démontrer :

```text
[ ] Le problème des comptes de service statiques est expliqué
[ ] Une KDS Root Key valide est disponible
[ ] Un groupe d'hôtes autorisés est utilisé
[ ] Le gMSA existe
[ ] SRV01 est autorisé à l'utiliser
[ ] Le gMSA est utilisable depuis SRV01
[ ] Un service fonctionne sous le gMSA
[ ] Aucun mot de passe du gMSA n'est administré manuellement
[ ] Les différences LAPS / gMSA / PAM sont comprises
[ ] Les risques des privilèges permanents sont identifiés
[ ] Une architecture PAM conceptuelle est proposée
[ ] Les choix sont argumentés
```

---

# Restitution

À la fin du module, préparez une restitution courte répondant à la question :

> **NovaCorp utilise maintenant Windows LAPS et gMSA. Pourquoi l'entreprise pourrait-elle malgré tout avoir besoin d'un PAM ?**

Votre réponse doit être argumentée à partir de votre architecture et de vos tests.

---

# Checkpoint M08

Avant de poursuivre :

```text
gMSA fonctionnel
+
service fonctionnel
+
analyse PAM terminée
```

Ne poursuivez pas uniquement parce que les commandes ont fonctionné.

Vous devez être capables d'expliquer **pourquoi l'architecture construite est plus sûre que la situation initiale**.


Snapshot conseillé :

```text
M08-GMSA-PAM-OK
```
