# Module 13 — Endpoint Security

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | GPO / politiques de domaine | 2 | 4 Go | 60 Go |
| CLT01 | endpoint principal de test | 2 | 4–6 Go | 64 Go |
| SRV01 | validation de politiques serveur | 2 | 4 Go | 60 Go |


## Contexte NovaCorp

NovaCorp veut réduire la surface d'attaque de ses postes et serveurs sans rendre les machines inutilisables.

L'objectif n'est donc pas d'activer un maximum de protections.

Votre mission consiste à construire une **baseline endpoint défendable**, à tester ses effets et à démontrer qu'elle bloque ou détecte des comportements ciblés tout en conservant les usages légitimes.

---

## Objectifs

Vous devez comprendre et articuler :

- Microsoft Defender ;
- Attack Surface Reduction ;
- Windows Firewall ;
- AppLocker ou WDAC ;
- PowerShell Logging ;
- audit vs enforcement ;
- sécurité vs compatibilité.

---

# Partie A — État initial

Avant toute modification, inventoriez :

- état de Defender ;
- profils Firewall ;
- règles principales ;
- protections ASR présentes ;
- stratégie AppLocker / WDAC éventuelle ;
- journalisation PowerShell ;
- GPO qui pilotent ces paramètres.

Conservez un état **before**.

---

# Partie B — Defender et ASR

Sélectionnez plusieurs protections adaptées à NovaCorp.

Pour chaque règle ou réglage retenu :

1. quel comportement cherche-t-il à empêcher ?
2. quel risque réduit-il ?
3. quel impact utilisateur ou applicatif est possible ?
4. peut-il être testé d'abord en audit ?
5. comment validerez-vous son fonctionnement ?

Évitez d'activer des règles uniquement parce qu'elles semblent “plus sécurisées”.

---

# Partie C — Windows Firewall

Analysez les profils :

```text
Domain
Private
Public
```

Puis construisez une politique qui :

- conserve les flux nécessaires ;
- réduit les ouvertures inutiles ;
- évite les règles trop larges ;
- permet de démontrer un flux autorisé et un flux refusé.

Votre test doit porter sur le **service réellement attendu**, pas seulement sur un ping.

---

# Partie D — AppLocker ou WDAC

Choisissez une technologie adaptée au temps disponible.

Votre politique doit démontrer :

```text
Application légitime
→ autorisée

Scénario non autorisé
→ audité ou bloqué
```

Si nécessaire :

```text
Audit
→ observation
→ ajustement
→ enforcement
```

Expliquez pourquoi cette progression est préférable à un blocage immédiat en production.

---

# Partie E — PowerShell Security

Activez les mécanismes de journalisation pertinents.

Générez ensuite une activité PowerShell légitime permettant de démontrer que :

```text
commande exécutée
→ événement généré
→ événement retrouvé
→ contenu interprété
```

Vous devez distinguer :

- journaliser ;
- détecter ;
- bloquer.

---

# Partie F — Validation croisée

Chaque protection retenue doit disposer d'un test.

Pour chaque test, documentez :

| Élément | Attendu |
|---|---|
| Protection | règle / technologie |
| Risque visé | comportement réduit |
| Test | action réalisée |
| Résultat attendu | autorisé / bloqué / audité |
| Résultat réel | observation |
| Impact métier | éventuel |
| Rollback | méthode prévue |

---

## Répartition suggérée

- A : Defender / ASR
- B : Firewall
- C : AppLocker / WDAC
- D : PowerShell Security
- E : audit / tests / documentation

---

## Questions de réflexion

1. Pourquoi une protection “bloquante” doit-elle souvent passer par un mode audit ?
2. Quelle différence entre antivirus, ASR et application control ?
3. Pourquoi le Firewall reste-t-il utile dans un LAN interne ?
4. Une règle qui bloque un test signifie-t-elle forcément que la configuration est bonne ?
5. Pourquoi la télémétrie PowerShell est-elle utile même si aucune commande n'est bloquée ?
6. Quels impacts opérationnels pourriez-vous provoquer avec une baseline trop agressive ?

---

## Livrables

- `endpoint-policy.md`
- `security-tests.md`
- preuves dans `evidence/`

### `endpoint-policy.md`

Doit contenir :

- état initial ;
- protections retenues ;
- justification ;
- scope ;
- mode audit / enforcement ;
- risques et rollback.

### `security-tests.md`

Doit contenir :

- tests positifs ;
- tests négatifs ;
- résultats ;
- événements / logs ;
- écarts constatés.

---

## Validation

```text
[ ] état initial documenté
[ ] protections justifiées
[ ] flux nécessaire encore fonctionnel
[ ] au moins un comportement non souhaité audité ou bloqué
[ ] application légitime validée
[ ] logs PowerShell générés et interprétés
[ ] rollback connu
[ ] impacts potentiels discutés
```

---

## Restitution

Répondez à :

> **Comment durcir fortement un poste Windows sans transformer la politique de sécurité en cause de panne ?**

---

## Checkpoint M13

```text
Baseline définie
+
protections testées
+
compatibilité validée
+
preuves conservées
```
