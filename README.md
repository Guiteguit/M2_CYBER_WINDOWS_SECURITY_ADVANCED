# M2 — Sécurité avancée des systèmes Windows

## Fil rouge — NovaCorp

Bienvenue dans le module **T1 : Sécurité avancée des systèmes Windows**.

Ce cours est organisé autour d'un fil rouge : vous intervenez comme équipe infrastructure & sécurité pour **NovaCorp**, une entreprise qui reconstruit progressivement son système d'information Windows.

L'objectif n'est pas de suivre des procédures pas-à-pas. Vous devrez **concevoir, construire, sécuriser, auditer, tester et justifier** vos choix.

---

## Organisation générale

- Niveau : M2 Cyber
- Volume : 16 modules de 1h30
- Organisation : 3 groupes (2 groupes de 4, 1 groupe de 5)
- Méthode : travail distribué, rôles tournants, audit croisé
- Principe : personne ne valide son propre travail

### Méthode de travail

```text
DESIGN
  ↓
BUILD
  ↓
TEST
  ↓
REVIEW
  ↓
FIX
  ↓
VALIDATE
```

Chaque module se termine par un **checkpoint**. Lorsque le checkpoint est validé, le groupe peut poursuivre.

---

## Architecture progressive

Au cours des 4 journées, votre SI va évoluer vers une architecture de ce type :

```text
                         NovaCorp
                            │
                        Réseau interne
                            │
        ┌──────────────┬────┼────┬───────────────┐
        │              │         │               │
      DC01           SRV01     CLT01         PKI01
   AD DS / DNS    SMB / IIS   Windows 11     AD CS
        │              │         │               │
        └──────────────┴─────────┴───────────────┘
                            │
                     Services sécurité
                            │
                  ┌─────────┴─────────┐
                  │                   │
                SEC01               VULN01
                Wazuh          Greenbone/OpenVAS
```

Cette architecture est volontairement progressive : toutes les machines et tous les services ne sont pas présents dès le départ.

---

## Répartition des rôles

Chaque groupe répartit les responsabilités entre ses membres. Les rôles changent régulièrement.

Exemples de rôles :

- Responsable infrastructure
- Responsable sécurité
- Responsable réseau
- Responsable audit / validation
- Responsable documentation / architecture

Chaque étudiant doit :

1. réaliser au moins une action technique concrète ;
2. auditer au moins une action réalisée par un autre étudiant ;
3. contribuer à un livrable du groupe ;
4. être capable d'expliquer les choix techniques du groupe.

---

## Modules

### Jour 1 — Fondations

- [Module 01 — Fondations du laboratoire Windows](module01-foundations/README.md)

### Jour 2 — Identité, domaine et contrôle

- Module 02 — Active Directory + DNS
- Module 03 — GPO & hardening
- Module 04 — File Server / SMB / NTFS / ACL
- Module 05 — Audit AD avec PingCastle
- Module 06 — Comptes privilégiés & délégation

### Jour 3 — Identité avancée et services sécurisés

- Module 07 — Windows LAPS
- Module 08 — gMSA & concepts PAM
- Module 09 — AD CS / PKI
- Module 10 — IIS + TLS
- Module 11 — MFA / AD FS / Entra ID

### Jour 4 — Endpoint, administration et détection

- Module 12 — BitLocker / TPM
- Module 13 — Defender / Firewall / AppLocker / PowerShell Security
- Module 14 — RDP / WinRM / Windows Admin Center
- Module 15 — Sysmon + Wazuh
- Module 16 — Greenbone/OpenVAS / Vulnerability Management

---

## Livrables

Les livrables doivent être courts, lisibles et exploitables.

Vous devrez généralement fournir :

- un schéma ou une description d'architecture ;
- les éléments de configuration importants ;
- des preuves de fonctionnement ;
- les choix de sécurité retenus ;
- les écarts ou risques identifiés ;
- les corrections apportées ;
- les contributions individuelles.

Voir : [docs/deliverables.md](docs/deliverables.md)

---

## Règles du laboratoire

1. **Ne désactivez pas une protection simplement parce qu'elle gêne un test.**
2. Toute modification de sécurité doit être justifiée.
3. Un problème de connectivité doit être diagnostiqué avant de modifier le firewall.
4. Ne modifiez pas l'infrastructure d'un autre groupe.
5. Ne partagez pas de mots de passe ou secrets dans le dépôt Git.
6. Les scripts fournis ou créés doivent être relus avant exécution.
7. Les snapshots/checkpoints doivent être créés lorsque demandé.

---

## Évaluation

Les modules sont évalués sur la qualité du raisonnement autant que sur le fonctionnement technique.

| Critère | Importance |
|---|---:|
| Fonctionnement technique | Forte |
| Sécurité de la solution | Forte |
| Justification des choix | Forte |
| Vérifications / preuves | Moyenne |
| Documentation | Moyenne |
| Qualité / propreté | Moyenne |

Un système qui fonctionne mais qui est mal sécurisé n'est pas considéré comme terminé.

---

## Conseil

Si vous êtes bloqués, ne commencez pas par chercher une commande au hasard.

Posez-vous les questions suivantes :

```text
Quel est le symptôme ?
Quel composant est concerné ?
Quelle hypothèse puis-je formuler ?
Comment puis-je la tester ?
Quelle preuve permet de conclure ?
```

La capacité à diagnostiquer fait partie du cours.

---

## Jour 2 — Modules 02 à 06

Le Jour 2 transforme le lab en véritable environnement Windows d'entreprise :

- Module 02 — Active Directory + DNS
- Module 03 — GPO + Hardening
- Module 04 — File Server + SMB + NTFS + ACL
- Module 05 — Audit AD avec PingCastle
- Module 06 — Comptes privilégiés + délégation

Consultez [`day02.md`](day02.md) avant de commencer la journée.
