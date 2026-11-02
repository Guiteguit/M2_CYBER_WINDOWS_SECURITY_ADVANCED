# M12 — Troubleshooting / Tips

## Méthode

    1. Identifier l'état du volume
    2. Vérifier les protecteurs
    3. Vérifier le TPM
    4. Identifier un changement de boot éventuel
    5. Vérifier la disponibilité de la récupération
    6. Corriger une seule cause
    7. Retester

## Outils

    Get-Tpm
    Get-BitLockerVolume
    manage-bde -status C:
    manage-bde -protectors -get C:
    Confirm-SecureBootUEFI

## Cas 1 — Secure Boot = False

Ce résultat ne signifie pas à lui seul que BitLocker ne peut pas fonctionner. Distinguez TPM, Secure Boot et BitLocker.

## Cas 2 — Recovery demandée après changement de boot

Le disque n'est pas nécessairement endommagé. Le protecteur TPM peut simplement ne plus accepter l'état actuel du démarrage.

Recherchez notamment un changement firmware, TPM, UEFI, bootloader ou configuration de boot.

## Cas 3 — Recovery Password indisponible

Vérifiez si la clé a été sauvegardée, où elle est stockée, qui peut la lire et si le Recovery ID correspond.

## Cas 4 — VM / snapshot qui grossit fortement

Le chiffrement réécrit de nombreux blocs. Dans VMware avec snapshots ou thin provisioning, les fichiers delta / VMDK peuvent fortement grossir.

Avant de poursuivre :

- contrôler l'espace hôte ;
- éviter les snapshots inutiles ;
- privilégier une petite VM dédiée ;
- éviter un déchiffrement massif si le datastore est presque saturé.

## Cas 5 — Poste déjà déverrouillé

BitLocker protège principalement les données au repos. Une fois le volume déverrouillé, l'accès est contrôlé par Windows, les ACL et les autres mécanismes endpoint.
