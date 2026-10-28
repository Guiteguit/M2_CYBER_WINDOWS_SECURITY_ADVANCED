# Module 15 — Sysmon + Wazuh

## Contexte
NovaCorp manque de visibilité sur les événements de sécurité produits par ses machines Windows.

## Mission
Déployez une chaîne de télémétrie et de centralisation :

Windows → Sysmon → Wazuh

## Répartition suggérée
- A : Sysmon sur DC01
- B : Sysmon sur SRV01
- C : Sysmon sur CLT01
- D : Wazuh / collecte
- E : détection / requêtes / documentation

Dans un groupe de 4, la collecte et l'analyse peuvent être fusionnées.

## Travail demandé
### Sysmon
- installer et configurer Sysmon ;
- produire des événements de processus et réseau ;
- retrouver parent process, command line, utilisateur et destination.

### Wazuh
- déployer / utiliser Wazuh ;
- connecter les agents ;
- collecter au minimum :
  - Security
  - System
  - PowerShell
  - Sysmon

### Validation
Générez et retrouvez plusieurs événements légitimes :
- ouverture PowerShell ;
- création d'un processus ;
- échec de connexion ;
- création ou modification d'un utilisateur ;
- changement de groupe ;
- connexion réseau.

## Questions
- Quelle différence entre télémétrie et détection ?
- Pourquoi Sysmon n'est-il pas un SIEM ?
- Pourquoi Wazuh ne remplace-t-il pas la compréhension des logs ?

## Livrables
- `telemetry-design.md`
- `event-hunt.md`
- preuves dans `evidence/`

## Checkpoint CP15
- Sysmon produit des événements ;
- Wazuh les reçoit ;
- au moins trois événements sont retrouvés et expliqués.
