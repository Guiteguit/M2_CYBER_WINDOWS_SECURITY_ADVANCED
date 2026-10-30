# Module 11 — MFA, AD FS et Entra ID

## Contexte NovaCorp

NovaCorp utilise Active Directory pour son identité interne mais souhaite comprendre comment sécuriser l'accès à des applications modernes, mettre en place de la fédération et préparer une éventuelle identité hybride.

L'objectif n'est pas de déployer artificiellement tous les produits Microsoft.

Vous devez surtout être capables d'expliquer **qui authentifie qui, où se trouve l'identité, comment le token est produit et ce que le MFA change réellement**.

La réussite du module ne dépend pas d'une licence Microsoft 365.

---

## Objectifs

À la fin du module, vous devez distinguer clairement :

- AD DS ;
- AD FS ;
- Microsoft Entra ID ;
- MFA ;
- fédération ;
- Identity Provider ;
- Relying Party / Service Provider ;
- claims ;
- tokens ;
- SAML ;
- OpenID Connect ;
- OAuth 2.0 à haut niveau.

---

# Partie A — Cartographier les rôles

Pour chaque composant suivant, expliquez son rôle et ce qu'il **ne fait pas** :

```text
AD DS
AD FS
Entra ID
MFA
Application
```

Évitez les définitions isolées.

Replacez chaque composant dans un vrai flux d'authentification.

---

# Partie B — Construire le flux

Dessinez un flux permettant à un utilisateur NovaCorp d'accéder à une application.

Votre schéma doit faire apparaître au minimum :

```text
Utilisateur
    ↓
Application
    ↓
Identity Provider
    ↓
Authentification
    ↓
MFA éventuel
    ↓
Token / Claims
    ↓
Application
```

Identifiez clairement :

- qui stocke ou connaît l'identité ;
- qui authentifie ;
- qui produit le token ;
- qui fait confiance à qui ;
- qui consomme les claims.

---

# Partie C — Démonstration

Selon les ressources disponibles, réalisez **une** des options suivantes :

### Option 1 — AD FS

- déployer ou utiliser AD FS ;
- configurer un scénario simple de relying party ;
- observer le flux d'authentification ;
- identifier les claims produits.

### Option 2 — Entra / MFA

Si un tenant et les droits nécessaires sont disponibles :

- observer ou configurer un scénario MFA ;
- documenter le parcours ;
- identifier où intervient Entra ID.

### Option 3 — Architecture documentée

Si aucune ressource cloud exploitable n'est disponible :

- construire un flux complet et techniquement cohérent ;
- tester les éléments locaux disponibles ;
- documenter précisément les étapes non réalisées.

L'absence de tenant cloud ne doit pas bloquer le module.

---

# Partie D — Comprendre le MFA

Répondez à ces questions :

1. quels facteurs peuvent être combinés ?
2. qu'est-ce que le MFA réduit comme risque ?
3. qu'est-ce qu'il ne protège pas ?
4. pourquoi un utilisateur peut-il être compromis malgré le MFA ?
5. pourquoi le MFA doit-il être replacé dans une architecture complète ?

Ne résumez pas le MFA à :

```text
mot de passe + téléphone = sécurisé
```

---

# Partie E — Choisir une architecture

NovaCorp doit choisir entre :

- identité principalement on-prem ;
- identité hybride ;
- stratégie cloud-first.

Proposez une architecture et justifiez-la selon :

- applications existantes ;
- dépendance Internet ;
- expérience utilisateur ;
- disponibilité ;
- administration ;
- sécurité ;
- coûts / complexité ;
- dépendances techniques.

Il n'existe pas une réponse unique.

---

## Répartition suggérée

- A : AD DS
- B : AD FS
- C : application / relying party
- D : MFA
- E : Entra / architecture / audit

---

## Questions de réflexion

1. AD DS et Entra ID sont-ils le même type d'annuaire ?
2. Pourquoi AD FS existe-t-il alors qu'AD DS authentifie déjà des utilisateurs ?
3. Quelle différence entre authentification et autorisation ?
4. À quoi servent les claims ?
5. SAML, OIDC et OAuth répondent-ils exactement au même besoin ?
6. Où se situe le MFA dans un flux d'identité ?
7. Que se passe-t-il si l'IdP devient indisponible ?
8. Quels nouveaux risques apparaissent avec la fédération ?

---

## Livrables

- `identity-architecture.md`
- `authentication-flow.md`
- `security-review.md`
- preuves éventuelles dans `evidence/`

### `identity-architecture.md`

Doit contenir :

- architecture choisie ;
- composants ;
- trusts ;
- justification du modèle on-prem / hybride / cloud-first.

### `authentication-flow.md`

Doit contenir :

- séquence utilisateur → application → IdP → token → application ;
- rôle de chaque acteur ;
- positionnement MFA ;
- protocole envisagé.

### `security-review.md`

Doit contenir :

- bénéfices ;
- risques ;
- dépendances ;
- limites ;
- mesures compensatoires.

---

## Validation

```text
[ ] AD DS / AD FS / Entra clairement distingués
[ ] IdP / relying party / claims / token compris
[ ] flux complet expliqué
[ ] MFA correctement positionné
[ ] au moins un POC ou une validation partielle réalisée
[ ] dépendances et limites identifiées
[ ] architecture cible justifiée
```

---

## Restitution

Répondez à :

> **À quel moment exact le MFA intervient-il dans votre architecture, et pourquoi ne suffit-il pas à lui seul à sécuriser l'identité NovaCorp ?**

---

## Checkpoint M11

```text
Flux compris
+
fédération expliquée
+
MFA positionné
+
architecture justifiée
```
