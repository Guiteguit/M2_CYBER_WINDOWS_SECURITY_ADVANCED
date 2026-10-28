# Jour 2 — Identité, domaine et premiers contrôles de sécurité

## Objectif de la journée

À partir du socle construit au Jour 1, votre équipe doit transformer son environnement en un premier SI Windows d'entreprise cohérent et administrable.

La journée couvre :

1. Active Directory Domain Services et DNS
2. GPO et hardening
3. File Server, SMB, NTFS et ACL
4. Audit Active Directory avec PingCastle
5. Comptes privilégiés et délégation

## Règle de fonctionnement

Chaque module suit la même logique :

> DESIGN → BUILD → TEST → REVIEW → FIX → VALIDATE

Personne ne valide son propre travail.

Les rôles doivent tourner entre les modules. Un étudiant ne doit pas rester toute la journée "responsable du DC" ou "responsable documentation".

## Répartition recommandée

### Groupe de 4

- Étudiant A : infrastructure / DC
- Étudiant B : serveur membre / services
- Étudiant C : poste client / tests utilisateurs
- Étudiant D : sécurité / audit / validation

### Groupe de 5

- Étudiant A : infrastructure / DC
- Étudiant B : serveur membre / services
- Étudiant C : poste client 1
- Étudiant D : poste client 2 / tests croisés
- Étudiant E : sécurité / audit / validation

À chaque nouveau module, les rôles tournent.

## Checkpoints

- `M02-AD-DNS-OK`
- `M03-GPO-OK`
- `M04-FILESERVER-OK`
- `M05-AUDIT-OK`
- `M06-PRIVILEGES-OK`

Un groupe ne passe au module suivant qu'après validation minimale du checkpoint précédent.
