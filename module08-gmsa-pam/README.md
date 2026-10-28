# Module 08 — gMSA et concepts PAM

## Contexte
NovaCorp possède encore des comptes de service statiques avec mots de passe non expirants.

## Mission
Remplacez un compte de service traditionnel par un gMSA.

Le service doit :
- fonctionner sans mot de passe saisi manuellement ;
- être utilisable uniquement sur les machines prévues ;
- disposer du minimum de privilèges.

## Répartition suggérée
- A : conception des droits
- B : création du gMSA
- C : serveur consommateur
- D : validation sécurité
- E : comparaison avec un PAM

## Travail demandé
- analyser les risques des comptes statiques ;
- créer et tester le gMSA ;
- comparer LAPS, gMSA et PAM ;
- couvrir : vault, rotation, JIT, approbation, audit, session recording.

## Livrables
- `gmsa-design.md`
- `pam-gap-analysis.md`
- preuves dans `evidence/`

## Checkpoint CP08
- gMSA fonctionnel ;
- droits limités ;
- différences LAPS / gMSA / PAM comprises.
