# Module 02 — Active Directory Domain Services & DNS

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | AD DS / DNS | 2 | 4 Go | 60 Go |
| SRV01 | serveur membre | 2 | 4 Go | 60 Go |
| CLT01 | client joint au domaine | 2 | 4–6 Go | 64 Go |
| CLT02 | client optionnel | 2 | 4 Go | 64 Go |


## Prérequis et dépendances

**Réutilise :**
- M01 : plan IP, hostnames, connectivité inter-VM, firewall actif et snapshot `M01-FOUNDATION-OK`.

**Produit pour la suite :**
- domaine `novacorp.local` ;
- DNS Active Directory ;
- OU, utilisateurs et groupes ;
- `SRV01` et `CLT01` joints au domaine.

Ces éléments deviennent le socle des modules M03 à M16.

## Contexte

NovaCorp souhaite centraliser les identités, les machines et les politiques de sécurité. Votre équipe doit construire le premier domaine Active Directory de l'entreprise.

Le domaine doit être fonctionnel, documenté et prêt à accueillir les futurs services de sécurité du cursus.

## Objectifs

À la fin du module, votre groupe doit être capable de :

- installer AD DS ;
- créer une forêt et un domaine ;
- comprendre le rôle du DNS dans Active Directory ;
- structurer les OU ;
- créer des utilisateurs et groupes ;
- joindre des machines au domaine ;
- vérifier la découverte des services AD ;
- expliquer pourquoi un DNS public ne remplace pas le DNS Active Directory.

## Mission

Construisez l'annuaire de NovaCorp.

Votre architecture doit au minimum contenir :

- un contrôleur de domaine ;
- un DNS Active Directory ;
- une structure d'OU cohérente ;
- plusieurs comptes utilisateurs ;
- plusieurs groupes de sécurité ;
- SRV01 joint au domaine ;
- au moins un poste client joint au domaine.

## Contraintes

- Le domaine doit être cohérent avec l'architecture retenue par votre groupe.
- Les utilisateurs ne doivent pas être placés directement dans des groupes privilégiés sans justification.
- Les postes clients doivent utiliser le DNS du domaine.
- Le groupe doit expliquer son choix de structure d'OU.
- La résolution de noms interne doit fonctionner.

## Travail distribué

Exemple de répartition :

- A : installation AD DS / promotion DC
- B : DNS / validation des enregistrements
- C : structure OU / utilisateurs / groupes
- D : jointure SRV01 / tests d'authentification
- E : jointure CLT01/CLT02 / audit croisé

Les rôles sont adaptables selon la taille du groupe.

## À démontrer

Votre groupe doit prouver :

- que le domaine existe ;
- que le DNS AD répond ;
- que SRV01 est membre du domaine ;
- qu'un client peut ouvrir une session avec un compte de domaine ;
- que les principaux enregistrements SRV nécessaires à AD existent ;
- que l'organisation logique de l'annuaire est documentée.

## Questions à traiter

1. Pourquoi Active Directory dépend-il autant de DNS ?
2. Que se passerait-il si CLT01 utilisait uniquement `8.8.8.8` comme DNS ?
3. Quelle différence faites-vous entre une OU et un groupe de sécurité ?
4. Pourquoi éviter une OU unique contenant tous les objets ?
5. Quels éléments de votre design faciliteront les GPO du module suivant ?

## Livrables

Créer dans ce dossier :

- `ad-design.md`
- `objects.csv`
- `validation.md`

Le fichier `validation.md` doit contenir les preuves de fonctionnement et les anomalies rencontrées.

## Audit croisé

Un étudiant qui n'a pas réalisé la promotion du DC doit vérifier :

- le domaine ;
- le DNS ;
- les OU ;
- les groupes ;
- les machines jointes ;
- les comptes de test.

## Checkpoint M02

Le module est validé lorsque :

- [ ] le domaine fonctionne ;
- [ ] DNS AD fonctionne ;
- [ ] SRV01 est joint au domaine ;
- [ ] un client est joint au domaine ;
- [ ] les utilisateurs/groupes existent ;
- [ ] la structure OU est justifiée ;
- [ ] un autre étudiant a audité la configuration.

Créer ensuite un snapshot : `M02-AD-DNS-OK`.
