# Module 05 — Audit Active Directory avec PingCastle

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | domaine audité | 2 | 4 Go | 60 Go |
| CLT01 | poste d'audit / consultation | 2 | 4–6 Go | 64 Go |

PingCastle peut être exécuté depuis une machine membre disposant des droits nécessaires ; il n'est pas nécessaire de l'installer sur le contrôleur de domaine.


## Prérequis et dépendances

**Réutilise :**
- M02 : domaine et DNS ;
- M03 : GPO / hardening ;
- M04 : groupes, ACL et premières décisions de moindre privilège.

**Produit pour la suite :**
- photographie de la posture AD ;
- findings priorisés ;
- remédiations testées.

Les constats servent de base à M06 pour réduire les privilèges et préparer LAPS / gMSA / PAM.

## Aide technique et troubleshooting

Le README reste orienté **mission, conception et validation**.

Pour les commandes utiles, exemples d'implémentation, méthodes de test, troubleshooting, rollback et références officielles, utilisez :

- [Toolbox Debug & Exemples d'implémentation](toolbox-debug-implementation.md)

Utilisez cette toolbox pour comprendre et diagnostiquer, pas pour recopier une procédure sans analyser le résultat.

---

## Contexte NovaCorp

Le domaine `novacorp.local` fonctionne désormais depuis plusieurs modules.

Le RSSI souhaite obtenir une première photographie de la posture de sécurité Active Directory avant de poursuivre les travaux. L'objectif n'est pas d'obtenir un score parfait, mais de transformer un rapport automatisé en **décisions de sécurité argumentées**.

PingCastle doit donc être utilisé comme un outil d'aide à l'audit, pas comme une liste de paramètres à corriger aveuglément.

---

## Objectifs

À la fin du module, vous devez être capables de :

- exécuter un audit Active Directory ;
- comprendre les grandes familles de risques remontées ;
- distinguer **constat, risque, impact, priorité et remédiation** ;
- identifier les faux positifs, risques acceptés et limites propres au laboratoire ;
- corriger plusieurs constats sans dégrader l'environnement ;
- comparer une posture avant/après ;
- expliquer pourquoi un score automatisé ne remplace pas une analyse humaine.

---

## Mission

Réalisez un Health Check PingCastle de NovaCorp.

Votre travail doit suivre la logique :

```text
AUDITER
   ↓
COMPRENDRE
   ↓
PRIORISER
   ↓
CORRIGER
   ↓
VALIDER
   ↓
COMPARER
```

Vous devez :

1. produire un audit initial ;
2. sélectionner au moins cinq constats pertinents ;
3. analyser leur risque réel pour NovaCorp ;
4. classer chaque constat ;
5. choisir au moins deux remédiations raisonnables ;
6. tester les impacts avant/après ;
7. relancer l'audit ;
8. expliquer les différences observées.

---

## Classification attendue

Pour chaque finding important, classez-le dans une catégorie :

- **action immédiate** ;
- **à traiter dans un module ultérieur** ;
- **risque accepté dans le laboratoire** ;
- **informatif** ;
- **à confirmer manuellement**.

Vous devez être capables de justifier cette classification.

---

## Analyse des findings

Pour chacun des cinq constats retenus, documentez au minimum :

| Élément | Contenu attendu |
|---|---|
| Finding | règle / constat PingCastle |
| Risque | ce qui pourrait réellement arriver |
| Impact NovaCorp | conséquences dans votre environnement |
| Probabilité / exposition | faible / moyenne / forte, argumentée |
| Correction possible | action envisagée |
| Risque de la correction | ce qui pourrait casser |
| Priorité | P1 / P2 / P3 ou équivalent |
| Décision | corriger / reporter / accepter / investiguer |

---

## Contraintes

- Ne cherchez pas à obtenir un score de 0.
- Ne modifiez pas une configuration uniquement pour faire baisser le score.
- Une correction doit être comprise avant application.
- Les impacts opérationnels doivent être évalués.
- Une recommandation pertinente en production peut être inutile ou impossible dans un lab.
- Un finding supprimé du rapport n'est pas une preuve suffisante : vérifiez aussi le fonctionnement réel.

---

## Travail distribué

- A : exécution et conservation des rapports
- B : analyse comptes / privilèges
- C : analyse configuration / politiques
- D : priorisation / risque
- E : validation des remédiations / comparaison avant-après

Dans un groupe de 4, fusionnez analyse et validation.

---

## Questions de réflexion

1. Quel constat présente le risque réel le plus important pour NovaCorp ?
2. Quel finding a un score élevé mais une priorité faible dans votre laboratoire ?
3. Quelle correction pourrait provoquer une panne ou une incompatibilité en production ?
4. Pourquoi certaines recommandations doivent-elles être reportées à un module ultérieur ?
5. Quelle différence entre **score PingCastle** et **risque métier** ?
6. Quels contrôles humains complètent nécessairement l'audit automatisé ?
7. Pourquoi “faire disparaître un finding” n'est-il pas toujours synonyme de sécurisation ?

---

## Livrables

- `top-risks.md`
- `remediation.md`
- `comparison.md`

### `top-risks.md`

Doit contenir :

- les cinq constats retenus ;
- leur classification ;
- leur priorité ;
- leur justification ;
- les éventuels risques acceptés.

### `remediation.md`

Doit contenir :

- remédiations choisies ;
- justification ;
- risques de changement ;
- méthode de test ;
- résultat obtenu.

### `comparison.md`

Doit contenir :

- score avant/après ;
- findings disparus ;
- findings toujours présents ;
- findings volontairement non corrigés ;
- explication des écarts.

N'ajoutez aucun secret dans le repository.

---

## Validation

Le module est réussi si :

```text
[ ] audit initial conservé
[ ] cinq constats réellement analysés
[ ] priorisation argumentée
[ ] risques de changement identifiés
[ ] au moins deux remédiations testées
[ ] fonctionnement du lab validé après correction
[ ] second audit réalisé
[ ] comparaison avant/après expliquée
[ ] au moins un finding non corrigé est volontairement justifié
```

---

## Restitution

Répondez à la question :

> **Pourquoi le finding ayant le plus de points n'est-il pas nécessairement la première chose que NovaCorp doit corriger ?**

---

## Checkpoint M05

Avant de poursuivre :

```text
Audit compris
+
risques priorisés
+
remédiations validées
+
comparaison argumentée
```

Snapshot : `M05-AUDIT-OK`.
