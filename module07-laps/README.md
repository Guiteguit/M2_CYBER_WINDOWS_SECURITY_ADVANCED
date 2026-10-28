# Module 07 — Windows LAPS

## Contexte
NovaCorp utilise encore des mots de passe administrateur local partagés ou gérés manuellement.

## Mission
Déployez Windows LAPS sur au moins deux machines et démontrez :
- un secret différent par machine ;
- une rotation automatique ;
- une lecture réservée aux identités autorisées ;
- l'absence de secret dans Git.

## Répartition suggérée
- A : préparation AD
- B : GPO / stratégie
- C : test CLT01
- D : audit des permissions
- E : test CLT02 + documentation

## Travail demandé
1. Concevoir la politique LAPS.
2. Déployer sur au moins deux machines.
3. Tester lecture autorisée et refus non autorisé.
4. Vérifier ou provoquer une rotation.
5. Répondre :
   - Quel risque LAPS réduit-il ?
   - Pourquoi LAPS ne remplace-t-il pas un PAM ?

## Livrables
- `laps-design.md`
- `security-review.md`
- preuves dans `evidence/`

## Checkpoint CP07
- LAPS fonctionnel ;
- permissions vérifiées ;
- secrets non commités ;
- audit croisé effectué.
