# Module 06 — Comptes privilégiés & délégation

## Contexte

Les administrateurs NovaCorp utilisent encore trop souvent des comptes très privilégiés pour des tâches courantes. Le RSSI souhaite réduire l'exposition des privilèges et déléguer certaines tâches sans distribuer des droits Domain Admin.

## Objectifs

- identifier les groupes AD sensibles ;
- séparer compte utilisateur et compte d'administration ;
- comprendre le principe du moindre privilège ;
- déléguer une administration ciblée ;
- réfléchir aux comptes break-glass ;
- préparer les futurs modules LAPS, gMSA et PAM.

## Mission

Construisez un modèle d'administration privilégiée NovaCorp.

Vous devez au minimum :

- identifier les groupes hautement privilégiés ;
- supprimer les appartenances inutiles ;
- créer un modèle de comptes administratifs séparés ;
- déléguer une tâche administrative sur une OU sans utiliser Domain Admin ;
- documenter un mécanisme de compte d'urgence.

## Exemple de problème

Un administrateur utilise aujourd'hui le même compte pour :

- lire ses mails ;
- naviguer sur Internet ;
- administrer les serveurs ;
- modifier Active Directory.

Votre design doit réduire ce risque.

## Travail distribué

- A : inventaire des groupes privilégiés
- B : modèle de comptes administratifs
- C : délégation sur une OU
- D : tests de droits / refus
- E : modèle break-glass / audit croisé

## Travail demandé

1. Identifier les groupes sensibles.
2. Cartographier les utilisateurs qui les possèdent.
3. Proposer un modèle de séparation des comptes.
4. Implémenter au moins une délégation ciblée.
5. Tester qu'un compte délégué peut faire ce qui est prévu.
6. Tester qu'il ne peut pas effectuer une action non autorisée.
7. Proposer une stratégie pour les comptes d'urgence.

## Questions

1. Pourquoi Domain Admin ne doit-il pas être un groupe d'usage quotidien ?
2. Pourquoi la séparation des comptes réduit-elle le risque ?
3. Quelle différence entre délégation et élévation permanente ?
4. Que doit-on protéger particulièrement sur un compte break-glass ?
5. Quelles limites de ce modèle seront traitées plus tard par LAPS/PAM ?

## Livrables

- `privileged-model.md`
- `delegation-tests.md`
- `security-review.md`

## Checkpoint M06

- [ ] groupes sensibles inventoriés ;
- [ ] comptes privilégiés séparés ;
- [ ] délégation ciblée fonctionnelle ;
- [ ] refus d'une action non autorisée démontré ;
- [ ] modèle break-glass documenté ;
- [ ] audit croisé terminé.

Snapshot : `M06-PRIVILEGES-OK`.
