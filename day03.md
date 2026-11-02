# Jour 3 — Identités avancées et services sécurisés

## Objectif de la journée

À la fin du Jour 3, NovaCorp doit disposer :

- d'une gestion sécurisée des administrateurs locaux avec Windows LAPS ;
- de comptes de service gérés avec gMSA ;
- d'une PKI interne fonctionnelle ;
- d'un intranet IIS publié en HTTPS avec authentification Windows ;
- d'une compréhension du flux Kerberos ;
- d'un POC de fédération AD FS avec une Relying Party ;
- d'un positionnement clair de MFA et Entra ID.

## Règles de travail

- Chaque étudiant réalise une action technique identifiable.
- Les rôles tournent à chaque module.
- Personne ne valide son propre travail.
- Chaque module produit une preuve de fonctionnement ou une analyse explicitement identifiée comme conceptuelle.
- Aucun secret ne doit être commité dans Git.

## Checkpoints

- M07 : LAPS opérationnel et droits de lecture maîtrisés
- M08 : gMSA fonctionnel et limites LAPS/gMSA/PAM comprises
- M09 : certificat délivré et chaîne de confiance validée
- M10 : IIS HTTPS + gMSA + SSO/Kerberos diagnostiqués
- M11 : fédération AD FS + token/claims compris

Snapshots conseillés :

    M07-LAPS-OK
    M08-GMSA-PAM-OK
    M09-ADCS-PKI-OK
    M10-IIS-TLS-KERBEROS-OK
    M11-ADFS-FEDERATION-OK
