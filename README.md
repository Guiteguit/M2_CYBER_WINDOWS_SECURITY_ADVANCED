# M2 — Sécurité avancée des systèmes Windows

Fil rouge pédagogique : **NovaCorp**

Ce dépôt contient les travaux pratiques étudiants du module **T1 — Sécurité avancée des systèmes Windows**.

- Niveau : M2
- 13 étudiants
- Groupes : 4 / 4 / 5
- 16 modules
- 4 journées
- Approche : construction, sécurisation, audit, validation et observabilité

---

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

---

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
- [M10 — IIS + TLS](module10-iis-tls/README.md)
- [M11 — MFA / AD FS / Entra ID](module11-mfa-adfs-entra/README.md)

Voir : [day03.md](day03.md)

## Jour 4 — Endpoint, administration, SIEM et vulnérabilités

- [M12 — BitLocker](module12-bitlocker/README.md)
- [M13 — Endpoint Security](module13-endpoint-security/README.md)
- [M14 — Administration distante sécurisée](module14-secure-admin/README.md)
- [M15 — Sysmon + Wazuh](module15-sysmon-wazuh/README.md)
- [M16 — Greenbone / OpenVAS](module16-vulnerability-management/README.md)

Voir : [day04.md](day04.md)

---

# Architecture générale

Le SI évolue pendant le cursus autour de plusieurs rôles :

- `DC01` — Active Directory / DNS / GPO
- `SRV01` — File Server / IIS / services
- `CLT01` — poste Windows 11
- `CLT02` ou machine transverse selon les groupes
- `PKI01` — AD CS lorsque l'architecture le permet
- `SEC01` — Wazuh
- `VULN01` — Greenbone / OpenVAS

L'architecture exacte dépend des ressources disponibles. Plusieurs rôles peuvent être mutualisés dans un lab contraint tant que les choix sont documentés.

---

# Groupes et rôles

Les groupes sont composés de **4, 4 et 5 étudiants**.

Les responsabilités tournent entre :

- identité / AD ;
- serveurs / services ;
- poste client ;
- sécurité / audit ;
- documentation / architecture.

Un rôle d'audit ou de documentation ne signifie jamais « observer » : il inclut des contrôles techniques et une validation croisée.

---

# Checkpoints

Les snapshots/checkpoints permettent de reprendre rapidement après une erreur de manipulation.

Repères conseillés :

- `M01-FOUNDATION-OK`
- `M06-AD-HARDENING-OK`
- `M11-IDENTITY-PKI-OK`
- `M16-SECURITY-OBSERVABILITY-OK`

---

# Documentation commune

- [Architecture](docs/architecture.md)
- [Conventions](docs/conventions.md)
- [Livrables](docs/deliverables.md)

---

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
