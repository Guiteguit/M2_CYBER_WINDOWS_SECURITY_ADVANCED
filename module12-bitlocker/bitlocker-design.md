# BitLocker — Design NovaCorp

## Machine

- Machine :
- OS :
- Type physique / VM :
- Hyperviseur éventuel :

## État initial

- TPM présent :
- TPM prêt :
- Secure Boot :
- Volume système :
- État BitLocker initial :

## Architecture cryptographique

Expliquez :

    Données
      ↓
    FVEK
      ↓
    VMK
      ↓
    Key Protectors

## Protecteurs retenus

| Protector | Usage | Pourquoi | Risque / limite |
|---|---|---|---|
| TPM | | | |
| Recovery Password | | | |

## Méthode de chiffrement

- Méthode :
- Full Disk / Used Space Only :
- Justification :

## Recovery

- Stockage prévu :
- Identités autorisées :
- Procédure d'accès :

## Risques résiduels

Incluez au minimum :

- poste déjà déverrouillé ;
- compromission d'un compte autorisé ;
- fuite de Recovery Password ;
- indisponibilité / corruption du matériel ;
- risque spécifique VM / snapshot.

## Preuves

N'incluez aucune Recovery Password réelle.
