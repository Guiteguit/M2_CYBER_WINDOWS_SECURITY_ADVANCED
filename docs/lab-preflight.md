# Lab Preflight — Tests formateur

Avant de tester les 16 modules, valider le socle.

## Hyperviseur / réseau

- [ ] virtualisation matérielle disponible
- [ ] réseau interne du lab créé
- [ ] accès Internet possible lorsque nécessaire
- [ ] isolation du réseau de production
- [ ] snapshots disponibles

## VMs minimales

- [ ] DC01 — Windows Server
- [ ] SRV01 — Windows Server
- [ ] CLT01 — Windows 11

VMs supplémentaires à prévoir :

- [ ] PKI01 — Windows Server dédié à AD CS
- [ ] ADFS01 — Windows Server dédié à AD FS pour M11
- [ ] SEC01 — Linux pour Wazuh
- [ ] VULN01 — Linux pour Greenbone/OpenVAS

## Dimensionnement de référence

| VM | vCPU | RAM | Disque |
|---|---:|---:|---:|
| DC01 | 2 | 4 Go | 60 Go |
| SRV01 | 2 | 4–6 Go | 60–80 Go |
| PKI01 | 2 | 4 Go | 60 Go |
| ADFS01 | 2 | 4–6 Go | 60 Go |
| CLT01 | 2 | 4–6 Go | 64 Go |
| CLT02 | 2 | 4 Go | 64 Go |
| SEC01 | 4 | 8 Go minimum | 100 Go |
| VULN01 | 4 | 8 Go minimum | 100 Go |

Ces valeurs sont destinées au laboratoire. Wazuh et Greenbone sont les deux briques les plus consommatrices.

## Jour 1

- [ ] hostname
- [ ] IPv4 / masque
- [ ] gateway
- [ ] DNS temporaire
- [ ] heure / timezone
- [ ] Windows Firewall actif
- [ ] comptes locaux identifiés
- [ ] connectivité inter-VM
- [ ] snapshot `M01-FOUNDATION-OK`

## Ordre conseillé des tests

1. M01 Fondations
2. M02 AD DS + DNS
3. M03 GPO
4. M04 File Server
5. M05 PingCastle
6. M06 Privileged Access
7. M07 LAPS
8. M08 gMSA
9. M09 AD CS
10. M10 IIS/TLS
11. M11 identité/fédération
12. M12 BitLocker
13. M13 Endpoint
14. M14 Administration distante
15. M15 Sysmon/Wazuh
16. M16 Greenbone/OpenVAS

Ne pas tester toutes les briques à la fois : valider et snapshotter après chaque dépendance importante.
