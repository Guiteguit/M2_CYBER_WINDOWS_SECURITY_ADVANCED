# M2 — Sécurité avancée des systèmes Windows

Fil rouge pédagogique : **NovaCorp**

Ce dépôt contient les travaux pratiques étudiants du module **T1 — Sécurité avancée des systèmes Windows**.

- Niveau : M2
- 13 étudiants
- Groupes : 4 / 4 / 5
- 16 modules
- 4 journées
- Approche : construction, sécurisation, audit, validation et observabilité

## Méthode de travail

Chaque module suit le cycle :

**DESIGN → BUILD → TEST → REVIEW → FIX → VALIDATE**

Règles communes :

1. Chaque étudiant réalise une action technique identifiable.
2. Les rôles tournent entre les modules.
3. Personne ne valide son propre travail.
4. Une configuration doit être expliquée et testée, pas seulement appliquée.
5. Les livrables restent courts, mais contiennent des preuves.
6. Aucun mot de passe, secret, clé privée ou certificat privé ne doit être versionné.
7. Les commandes fournies servent prioritairement au diagnostic et à la validation.
8. Lorsqu'un lab ne peut pas être exécuté complètement pour une contrainte technique, le résultat attendu et le mécanisme doivent être compris et documentés.

# Parcours

## Jour 1 — Fondations

- [M01 — Fondations du lab Windows](module01-foundations/README.md)

Voir : [day01.md](day01.md)

## Jour 2 — Domaine, hardening et audit AD

- [M02 — Active Directory + DNS](module02-ad-dns/README.md)
- [M03 — GPO + Hardening](module03-gpo-hardening/README.md)
- [M04 — File Server / SMB / NTFS / ACL](module04-file-server-acl/README.md)
- [M05 — Audit AD avec PingCastle](module05-pingcastle/README.md)
- [M06 — Comptes privilégiés et délégation](module06-privileged-access/README.md)

Voir : [day02.md](day02.md)

## Jour 3 — Identités avancées et services sécurisés

- [M07 — Windows LAPS](module07-laps/README.md)
- [M08 — gMSA + concepts PAM](module08-gmsa-pam/README.md)
- [M09 — AD CS / PKI](module09-adcs-pki/README.md)
- [M10 — IIS + TLS + Kerberos](module10-iis-tls/README.md)
- [M11 — MFA / AD FS / Entra ID](module11-mfa-adfs-entra/README.md)

Voir : [day03.md](day03.md)

## Jour 4 — Endpoint, administration, SIEM et vulnérabilités

- [M12 — BitLocker / TPM / Recovery](module12-bitlocker/README.md)
- [M13 — Endpoint Security](module13-endpoint-security/README.md)
- [M14 — Administration distante sécurisée](module14-secure-admin/README.md)
- [M15 — Sysmon + Wazuh](module15-sysmon-wazuh/README.md)
- [M16 — Greenbone / OpenVAS](module16-vulnerability-management/README.md)

Voir : [day04.md](day04.md)

# Architecture générale

Le SI évolue autour de plusieurs rôles :

- `DC01` — Active Directory / DNS / GPO
- `SRV01` — File Server / IIS / services applicatifs
- `CLT01` — poste Windows 11
- `CLT02` — poste supplémentaire selon les groupes
- `PKI01` — AD CS / autorité de certification dédiée
- `ADFS01` — AD FS dans le POC M11
- `SEC01` — Wazuh
- `VULN01` — Greenbone / OpenVAS

Les rôles applicatifs peuvent être mutualisés dans un lab contraint tant que les choix sont documentés. **AD CS reste toutefois dédié à `PKI01` dans le parcours de référence**, afin de séparer clairement l'autorité de certification des serveurs applicatifs.

# Groupes et rôles

Les groupes sont composés de **4, 4 et 5 étudiants**.

Les responsabilités tournent entre :

- identité / AD ;
- serveurs / services ;
- poste client ;
- sécurité / audit ;
- documentation / architecture.

Un rôle d'audit ou de documentation inclut toujours des contrôles techniques.

# Checkpoints

Repères conseillés :

- `M01-FOUNDATION-OK`
- `M02-AD-DNS-OK`
- `M03-GPO-OK`
- `M04-FILESERVER-OK`
- `M05-AUDIT-OK`
- `M06-PRIVILEGES-OK`
- `M07-LAPS-OK`
- `M08-GMSA-PAM-OK`
- `M09-ADCS-PKI-OK`
- `M10-IIS-TLS-KERBEROS-OK`
- `M11-ADFS-FEDERATION-OK`
- `M12-BITLOCKER-OK`

Les snapshots sont des points de retour techniques, pas une preuve pédagogique à eux seuls.

# Documentation commune

- [Architecture](docs/architecture.md)
- [Conventions](docs/conventions.md)
- [Livrables](docs/deliverables.md)

# Sécurité du dépôt

Ne jamais commiter :

- mots de passe ;
- clés BitLocker ;
- secrets LAPS ;
- clés privées ;
- fichiers PFX/P12 ;
- credentials de service ;
- tokens cloud ;
- fichiers `.env` contenant des secrets.

Le `.gitignore` fournit une première protection, mais ne remplace pas la vigilance.
