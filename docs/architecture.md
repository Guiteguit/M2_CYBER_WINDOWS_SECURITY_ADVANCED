# Architecture NovaCorp

Ce document sert de référence pour décrire l'évolution de l'architecture du laboratoire.

## Convention de nommage

Les rôles principaux utilisent les noms suivants :

- `DC01` — Active Directory / DNS
- `SRV01` — serveur membre et services
- `CLT01` — poste Windows
- `CLT02` — second poste si nécessaire
- `PKI01` — AD CS / CA dédiée
- `ADFS01` — AD FS pour le POC M11
- `SEC01` — Wazuh
- `VULN01` — Greenbone / OpenVAS

Les rôles applicatifs peuvent être mutualisés si nécessaire, mais **la PKI ne l'est pas dans l'architecture de référence** : AD CS est installé sur `PKI01` afin d'isoler l'autorité de certification de `DC01`, `SRV01` et `ADFS01`.

Cette séparation facilite la compréhension des flux de confiance, limite le mélange des rôles et prépare mieux aux architectures PKI de production.

## Réseaux

Chaque groupe doit être isolé logiquement des autres groupes.

Exemple :

| Groupe | Réseau recommandé |
|---|---|
| Groupe 1 | `10.10.10.0/24` |
| Groupe 2 | `10.10.20.0/24` |
| Groupe 3 | `10.10.30.0/24` |

Le plan d'adressage exact est défini par chaque groupe puis documenté.

## Lab de référence du formateur

L'architecture peut notamment contenir :

    DC01    → AD DS / DNS
    SRV01   → services / IIS
    PKI01   → AD CS / CA NovaCorp
    ADFS01  → AD FS
    CLT01   → poste Windows

Les adresses IP exactes ne sont pas imposées aux groupes.
