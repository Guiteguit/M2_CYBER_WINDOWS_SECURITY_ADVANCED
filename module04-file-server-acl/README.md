# Module 04 — File Server, SMB, NTFS & ACL

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | identités / groupes | 2 | 4 Go | 60 Go |
| SRV01 | File Server | 2 | 4 Go | 80 Go |
| CLT01 | tests utilisateurs | 2 | 4–6 Go | 64 Go |

Le disque de `SRV01` peut être augmenté si vous souhaitez manipuler davantage de données de test.


## Contexte

NovaCorp doit mettre à disposition des espaces de fichiers pour plusieurs équipes sans exposer les données sensibles aux mauvais utilisateurs.

Le serveur SRV01 devient le premier File Server de l'entreprise.

## Objectifs

- installer le rôle File Server ;
- comprendre la différence entre permissions SMB et NTFS ;
- utiliser groupes et héritage ;
- appliquer le principe du moindre privilège ;
- éviter les permissions directement attribuées aux utilisateurs ;
- valider les permissions effectives.

## Mission

Créer au minimum les espaces suivants :

- `Finance`
- `Direction`
- `IT`
- `Commun`

Les accès doivent être gérés par groupes.

## Contraintes

- Pas de permissions directes sur des utilisateurs, sauf justification exceptionnelle.
- Les utilisateurs ne doivent accéder qu'aux données nécessaires.
- Les permissions SMB et NTFS doivent être cohérentes.
- Le groupe doit documenter son modèle de groupes.
- Un utilisateur doit être utilisé pour tester les accès réels.

## Modèle recommandé à étudier

Utilisateur → Groupe global → Groupe local de domaine → Permission

Vous devez décider si ce modèle est adapté à votre environnement et l'expliquer.

## Travail distribué

- A : création des partages
- B : groupes et modèle d'accès
- C : ACL NTFS
- D : tests utilisateurs
- E : audit des permissions effectives / documentation

## Scénarios minimums

Un utilisateur Finance doit pouvoir :

- modifier `Finance` ;
- accéder à `Commun` ;
- ne pas accéder à `Direction`.

Un utilisateur Direction doit obtenir les droits définis par votre politique.

## Questions

1. Quelle permission gagne si SMB et NTFS sont différentes ?
2. Pourquoi les permissions directes aux utilisateurs deviennent-elles difficiles à gérer ?
3. Quel est l'intérêt de l'héritage ?
4. Dans quel cas casser l'héritage peut-il être justifié ?
5. Comment prouvez-vous les permissions réellement obtenues par un utilisateur ?

## Livrables

- `access-matrix.csv`
- `group-model.md`
- `validation.md`

## Checkpoint M04

- [ ] partages créés ;
- [ ] groupes utilisés ;
- [ ] ACL cohérentes ;
- [ ] tests réalisés avec plusieurs utilisateurs ;
- [ ] aucun accès non justifié détecté ;
- [ ] audit croisé réalisé.

Snapshot : `M04-FILESERVER-OK`.
