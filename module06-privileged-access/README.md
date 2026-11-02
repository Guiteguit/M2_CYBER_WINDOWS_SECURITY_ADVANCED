# Module 06 — Comptes privilégiés & délégation

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | AD DS / délégation | 2 | 4 Go | 60 Go |
| CLT01 | tests comptes standards / admins | 2 | 4–6 Go | 64 Go |
| SRV01 | cible d'administration si nécessaire | 2 | 4 Go | 60 Go |


## Contexte NovaCorp

NovaCorp utilise encore des comptes très privilégiés pour des opérations qui pourraient être réalisées avec beaucoup moins de droits.

Le RSSI souhaite réduire :

- les privilèges permanents ;
- l'utilisation quotidienne de comptes administrateurs ;
- le nombre de membres des groupes critiques ;
- l'impact d'une compromission d'identifiants.

Votre mission est de construire un modèle d'administration dans lequel **le niveau de privilège correspond réellement au besoin**.

---

## Objectifs

À la fin du module, vous devez être capables de :

- identifier les groupes AD hautement privilégiés ;
- comprendre la différence entre Domain Admins, Enterprise Admins et Schema Admins ;
- séparer identité quotidienne et identité administrative ;
- protéger les comptes privilégiés contre certains scénarios de délégation ;
- déléguer une tâche précise sur une OU ;
- démontrer à la fois un accès autorisé et un accès refusé ;
- expliquer le rôle d'un compte break-glass ;
- préparer les notions LAPS, gMSA et PAM.

---

# Partie A — Cartographier les privilèges

Identifiez les groupes sensibles de votre domaine.

Au minimum, étudiez :

```text
Domain Admins
Enterprise Admins
Schema Admins
Administrators
Protected Users
```

Pour chacun, expliquez :

- son périmètre ;
- le type d'opération qu'il permet ;
- pourquoi son appartenance doit être limitée ;
- s'il doit normalement contenir des membres permanents.

Ne partez pas du principe qu'un groupe privilégié doit être peuplé simplement parce qu'il existe.

---

# Partie B — Séparer les comptes

Un administrateur utilise aujourd'hui le même compte pour :

- travailler quotidiennement ;
- ouvrir des applications ;
- naviguer sur Internet ;
- administrer des serveurs ;
- modifier Active Directory.

Proposez un modèle plus sûr.

Architecture attendue au niveau conceptuel :

```text
Compte utilisateur
        ↓
usage quotidien

Compte administrateur
        ↓
opérations d'administration uniquement
```

Expliquez pourquoi cette séparation réduit l'exposition des credentials privilégiés.

---

# Partie C — Comptes sensibles et délégation Kerberos

Identifiez les protections pertinentes pour un compte privilégié.

Analysez notamment :

- l'option **This account is sensitive and cannot be delegated** ;
- le groupe **Protected Users** ;
- les impacts potentiels sur la compatibilité.

Votre objectif n'est pas d'activer toutes les protections sans réflexion, mais de comprendre **ce qu'elles empêchent** et **dans quels cas elles peuvent poser problème**.

---

# Partie D — Schema Admins

Analysez le rôle du groupe Schema Admins.

Répondez notamment à :

1. qu'est-ce que le schéma Active Directory ?
2. pourquoi une modification du schéma est-elle particulièrement sensible ?
3. pourquoi Schema Admins peut-il être vide en fonctionnement normal ?
4. dans quel cas un administrateur devrait-il y être ajouté temporairement ?
5. pourquoi doit-il être retiré après l'opération ?

---

# Partie E — Délégation ciblée

NovaCorp souhaite qu'un technicien Helpdesk puisse effectuer une tâche limitée sur une OU donnée sans devenir Domain Admin.

Exemple de scénario :

> Le Helpdesk peut réinitialiser les mots de passe des utilisateurs Finance, mais ne doit pas administrer Direction, les serveurs ou les groupes privilégiés.

Concevez puis implémentez cette délégation.

Vous devez démontrer :

```text
Action autorisée
→ fonctionne

Action hors périmètre
→ refusée
```

Une délégation n'est considérée comme valide que si **le refus est testé autant que l'autorisation**.

---

# Partie F — Compte break-glass

Proposez un modèle de compte d'urgence.

Votre réflexion doit inclure :

- quand il peut être utilisé ;
- qui peut y accéder ;
- comment protéger son secret ;
- comment détecter son utilisation ;
- pourquoi il ne doit pas devenir un compte d'administration quotidien ;
- quelle procédure suivre après son utilisation.

Aucune solution commerciale n'est imposée.

---

## Travail distribué

- A : inventaire groupes privilégiés
- B : modèle de comptes administratifs
- C : délégation d'OU
- D : tests autorisés / refusés
- E : break-glass / audit croisé

---

## Questions de réflexion

1. Pourquoi Domain Admin ne doit-il pas être utilisé comme un rôle de confort ?
2. Quelle différence entre **délégation** et **élévation permanente** ?
3. Pourquoi Schema Admins peut-il rester vide ?
4. Quels risques apparaissent lorsqu'un Domain Admin se connecte sur un poste utilisateur ?
5. Quelle différence entre protéger un compte et lui accorder davantage de droits ?
6. Quels contrôles restent absents même avec une bonne séparation des comptes ?
7. Qu'est-ce qu'un futur PAM apporterait en plus ?

---

## Livrables

- `privileged-model.md`
- `delegation-tests.md`
- `security-review.md`

### `privileged-model.md`

Doit contenir :

- groupes sensibles identifiés ;
- modèle comptes standards / administratifs ;
- politique Schema Admins ;
- protections des comptes privilégiés ;
- stratégie break-glass.

### `delegation-tests.md`

Doit contenir :

- tâche déléguée ;
- périmètre ;
- groupe utilisé ;
- test positif ;
- test négatif ;
- preuves.

### `security-review.md`

Doit expliquer :

- risques du modèle initial ;
- améliorations apportées ;
- limites restantes ;
- points qui seront traités par LAPS / gMSA / PAM.

---

## Validation

```text
[ ] groupes sensibles compris
[ ] membres inutiles retirés
[ ] comptes privilégiés séparés
[ ] protection contre la délégation étudiée
[ ] Schema Admins compris et maîtrisé
[ ] délégation ciblée fonctionnelle
[ ] refus hors périmètre démontré
[ ] modèle break-glass documenté
[ ] limites du modèle identifiées
```

---

## Restitution

Répondez à la question :

> **Pourquoi “donner Domain Admin” est-il généralement une mauvaise réponse à un besoin d'administration limité ?**

---

## Checkpoint M06

```text
Privilèges compris
+
comptes séparés
+
délégation ciblée
+
refus démontré
```

Snapshot : `M06-PRIVILEGES-OK`.
