# Module 07 — Windows LAPS

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | AD DS / attributs LAPS | 2 | 4 Go | 60 Go |
| CLT01 | poste géré par LAPS | 2 | 4–6 Go | 64 Go |
| CLT02 | second poste pour démontrer l'unicité | 2 | 4 Go | 64 Go |


## Prérequis et dépendances

**Réutilise :**
- M02 : AD DS, OU et machines jointes ;
- M03 : distribution de politiques par GPO ;
- M06 : modèle de comptes privilégiés et moindre privilège.

**Produit pour la suite :**
- mots de passe administrateur local uniques ;
- délégation de lecture contrôlée ;
- expérience de rotation automatique des secrets.

M08 réutilise cette logique pour comparer LAPS, gMSA et PAM.

## Contexte NovaCorp

NovaCorp utilise encore des mots de passe d'administrateur local partagés ou gérés manuellement.

Ce modèle crée un risque majeur : si plusieurs machines partagent le même secret local et qu'une machine est compromise, ce secret peut être réutilisé ailleurs.

Windows LAPS doit permettre d'obtenir :

    un poste
    → un secret administrateur local unique
    → rotation automatique
    → stockage contrôlé dans l'annuaire
    → lecture limitée aux identités autorisées

## Objectifs

À la fin du module, vous devez être capables de :

- expliquer le problème des mots de passe locaux partagés ;
- distinguer Windows LAPS moderne de l'ancien Microsoft LAPS ;
- préparer Active Directory ;
- définir une politique LAPS ;
- choisir le compte local géré ;
- limiter qui peut lire les mots de passe ;
- démontrer lecture autorisée et refus non autorisé ;
- provoquer ou vérifier une rotation ;
- expliquer pourquoi LAPS ne remplace pas un PAM ;
- éviter toute fuite de secret dans Git.

# Mission 1 — Modèle de menace

Expliquez pourquoi ce modèle est dangereux :

    CLT01 Administrateur = même mot de passe
    CLT02 Administrateur = même mot de passe
    SRV01 Administrateur = même mot de passe

Analysez notamment le risque de mouvement latéral.

# Mission 2 — Préparer AD

Vérifiez que l'environnement permet l'utilisation de Windows LAPS.

Vous devez comprendre :

- extensions de schéma nécessaires ;
- attributs LAPS ;
- droits des ordinateurs pour mettre à jour leur propre secret ;
- droits des identités autorisées à lire le secret ;
- héritage des permissions sur les OU.

Ne modifiez pas le schéma sans comprendre pourquoi.

# Mission 3 — Concevoir la politique

Définissez :

- OU concernée ;
- compte local à gérer ;
- complexité ;
- longueur ;
- durée de vie ;
- destination de sauvegarde ;
- actions post-authentification si utilisées.

Justifiez chaque choix.

# Mission 4 — Déployer

Déployez Windows LAPS sur au moins deux machines lorsque les ressources le permettent.

Résultat attendu :

    CLT01 → secret A
    CLT02 → secret B
    A != B

Ne copiez jamais les valeurs réelles dans les livrables.

# Mission 5 — Contrôler les droits

Utilisez un groupe dédié, par exemple :

    GG_LAPS_PASSWORD_READERS

Démontrez :

    identité autorisée
    → lecture possible

    identité non autorisée
    → lecture refusée

Une lecture qui fonctionne n'est pas suffisante si le refus n'a pas été testé.

# Mission 6 — Rotation

Vérifiez l'expiration du mot de passe puis observez ou provoquez une rotation contrôlée.

Expliquez qui génère le nouveau secret, où il est stocké, quand l'ancien secret cesse d'être valable et pourquoi une rotation régulière limite le risque.

# Boîte à outils

    Get-LapsADPassword
    Find-LapsADExtendedRights
    Get-LapsDiagnostics
    Reset-LapsPassword

Adaptez les commandes à votre version de Windows et aux droits disponibles.

# Travail distribué

## Groupe de 5

- A : préparation AD / schéma ;
- B : GPO / stratégie ;
- C : CLT01 ;
- D : CLT02 / rotation ;
- E : permissions / audit.

## Groupe de 4

- A : AD ;
- B : politique ;
- C : client ;
- D : audit / permissions.

# Livrables

- laps-design.md
- security-review.md
- preuves non sensibles dans evidence/

# Validation

    [ ] risque des mots de passe partagés expliqué
    [ ] stratégie LAPS conçue
    [ ] compte local géré identifié
    [ ] sauvegarde du secret comprise
    [ ] secrets distincts par machine
    [ ] lecture autorisée démontrée
    [ ] refus non autorisé démontré
    [ ] rotation comprise ou validée
    [ ] aucun secret versionné
    [ ] différence LAPS / PAM comprise

# Questions de restitution

1. Quel problème Windows LAPS résout-il ?
2. Pourquoi un mot de passe administrateur local commun facilite-t-il le mouvement latéral ?
3. Pourquoi le secret LAPS ne doit-il pas être lisible par tous ?
4. Que se passe-t-il si une personne récupère un mot de passe LAPS puis que celui-ci est rotaté ?
5. Pourquoi LAPS ne remplace-t-il pas un PAM ?
6. Pourquoi faut-il tester un refus de lecture ?

# Checkpoint M07

    LAPS fonctionnel
    +
    permissions maîtrisées
    +
    rotation comprise
    +
    aucun secret exposé

Snapshot conseillé : M07-LAPS-OK.
