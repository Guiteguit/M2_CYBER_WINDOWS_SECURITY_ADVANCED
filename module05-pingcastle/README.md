# Module 05 — Audit Active Directory avec PingCastle

## Contexte

Votre domaine fonctionne désormais depuis plusieurs modules. Le RSSI souhaite obtenir une première photographie de sa posture de sécurité.

Votre mission est d'utiliser PingCastle pour identifier les risques de configuration Active Directory et prioriser les améliorations.

## Objectifs

- exécuter un audit AD ;
- comprendre qu'un score n'est pas une vérité absolue ;
- distinguer constat, risque et recommandation ;
- prioriser les corrections ;
- comparer une posture avant/après remédiation.

## Mission

1. Déployer ou exécuter PingCastle dans votre environnement.
2. Réaliser un Health Check.
3. Examiner les résultats.
4. Identifier cinq constats pertinents.
5. Corriger au moins deux problèmes sans dégrader le fonctionnement du lab.
6. Relancer l'audit.
7. Comparer les résultats.

## Contraintes

- Ne cherchez pas à obtenir un score parfait.
- Une recommandation doit être comprise avant correction.
- Ne corrigez pas un paramètre uniquement pour faire baisser un score.
- Les impacts opérationnels doivent être pris en compte.

## Travail distribué

- A : exécution de l'audit
- B : analyse comptes / privilèges
- C : analyse configuration / politiques
- D : priorisation / risque
- E : validation des remédiations / comparaison avant-après

## Questions

1. Quel est le constat le plus critique pour votre environnement ?
2. Quel constat possède un score élevé mais un risque réel faible dans votre lab ?
3. Quelle correction pourrait avoir un impact en production ?
4. Quelles limites identifiez-vous à un outil d'audit automatisé ?
5. Quels contrôles humains doivent compléter PingCastle ?

## Livrables

- `top-risks.md`
- `remediation.md`
- `comparison.md`

N'ajoutez pas de secrets ou de données sensibles dans le repo.

## Checkpoint M05

- [ ] audit initial réalisé ;
- [ ] cinq constats analysés ;
- [ ] risques priorisés ;
- [ ] au moins deux remédiations testées ;
- [ ] nouvel audit réalisé ;
- [ ] comparaison documentée.

Snapshot : `M05-AUDIT-OK`.
