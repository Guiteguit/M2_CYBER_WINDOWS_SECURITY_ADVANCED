# Recovery Plan — M12

## Déclencheurs possibles

Dans quelles situations BitLocker peut-il demander une récupération ?

## Recovery ID

Expliquez son rôle.

## Où se trouve la Recovery Password ?

- emplacement :
- objet AD éventuel :
- mécanisme de sauvegarde :

## Qui peut y accéder ?

Définissez les identités autorisées et appliquez le moindre privilège.

## Procédure

    Utilisateur bloqué
          ↓
    Recovery ID
          ↓
    Recherche autorisée
          ↓
    Recovery Password
          ↓
    déverrouillage
          ↓
    analyse de la cause
          ↓
    audit

Décrivez chaque étape.

## Après récupération

Que faut-il vérifier après un passage en recovery ?

## Risques

- clé perdue ;
- clé divulguée ;
- droits de lecture excessifs ;
- absence d'audit ;
- stockage de la clé sur le poste protégé.

## Preuves

Ne placez jamais une vraie Recovery Password dans Git.
