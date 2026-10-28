# Module 13 — Endpoint Security

## Contexte
NovaCorp veut réduire la surface d'exposition des postes et empêcher l'exécution de comportements ou applications non autorisés.

## Mission
Construisez une politique endpoint combinant :
- Microsoft Defender ;
- règles ASR ;
- Windows Firewall ;
- AppLocker ou WDAC ;
- journalisation PowerShell.

## Répartition suggérée
- A : Defender / ASR
- B : Firewall
- C : AppLocker / WDAC
- D : PowerShell Security
- E : audit / tests / documentation

## Travail demandé
### Defender / ASR
- inspecter la configuration actuelle ;
- proposer et activer des protections adaptées ;
- justifier les règles retenues.

### Firewall
- examiner les profils ;
- limiter les flux inutiles ;
- vérifier qu'un service nécessaire reste accessible.

### AppLocker / WDAC
- construire une politique permettant les applications légitimes ;
- empêcher au moins un scénario d'exécution non souhaité ;
- utiliser l'audit avant l'enforcement si nécessaire.

### PowerShell
- activer les mécanismes de journalisation pertinents ;
- générer une activité visible dans les logs.

## Livrables
- `endpoint-policy.md`
- `security-tests.md`
- preuves dans `evidence/`

## Checkpoint CP13
- protections actives ;
- règles justifiées ;
- application autorisée fonctionnelle ;
- scénario bloqué ou détecté démontré ;
- logs PowerShell disponibles.
