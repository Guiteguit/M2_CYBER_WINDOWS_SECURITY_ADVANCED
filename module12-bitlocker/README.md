# Module 12 — BitLocker

## Contexte
NovaCorp veut protéger les données stockées sur les postes mobiles et sensibles.

## Mission
Activez BitLocker sur un poste Windows et démontrez que la protection des données au repos est correctement mise en place.

## Répartition suggérée
- A : analyse du poste / prérequis
- B : configuration BitLocker
- C : gestion de la recovery key
- D : validation / scénario de récupération
- E : audit sécurité / documentation

## Travail demandé
- identifier les prérequis ;
- vérifier TPM / Secure Boot ;
- activer BitLocker ;
- vérifier l'état du chiffrement ;
- documenter le stockage de la recovery key ;
- expliquer ce qui se passe en cas de modification majeure du boot.

## Questions
- BitLocker protège-t-il un poste déjà déverrouillé ?
- TPM et BitLocker sont-ils la même chose ?
- Pourquoi la recovery key est-elle critique ?

## Livrables
- `bitlocker-design.md`
- `recovery-plan.md`
- preuves dans `evidence/`

## Checkpoint CP12
- volume protégé ;
- recovery key gérée ;
- validation croisée effectuée.
