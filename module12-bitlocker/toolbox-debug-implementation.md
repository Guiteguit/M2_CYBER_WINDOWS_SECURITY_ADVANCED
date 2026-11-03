# M12 — Toolbox BitLocker / TPM

> Support technique pour comprendre, vérifier et dépanner BitLocker dans le lab NovaCorp.

## 1. Rappel conceptuel

Le TPM peut protéger des secrets, mesurer l’intégrité du démarrage et servir d’ancrage à BitLocker.

BitLocker protège les données **au repos** via des clés et des Key Protectors.

## 2. Vérifier le TPM

```powershell
Get-Tpm
```

Champs utiles : `TpmPresent`, `TpmReady`, `TpmEnabled`, `TpmActivated`, `TpmOwned`.

## 3. Vérifier BitLocker

```powershell
Get-BitLockerVolume
manage-bde -status C:
```

## 4. Secure Boot

```powershell
Confirm-SecureBootUEFI
```

En VM, il peut être désactivé selon le firmware virtuel.

## 5. Contraintes du lab

Si l’espace disque manque ou si les VMs plantent :
- ne pas forcer un chiffrement complet lourd ;
- privilégier théorie + observation + démonstration ciblée ;
- documenter le résultat attendu.

## 6. Protecteurs

```powershell
(Get-BitLockerVolume -MountPoint 'C:').KeyProtector
manage-bde -protectors -get C:
```

## 7. Tests de validation

- TPM présent/prêt ;
- volume détecté ;
- protecteurs compris ;
- recovery process expliqué ;
- sauvegarde AD DS comprise ou démontrée.

## 8. Troubleshooting

| Symptôme | Vérification |
|---|---|
| BitLocker inactif | volume non configuré, protecteurs absents |
| TPM présent mais inutilisable | TPM non prêt / policy |
| Secure Boot False | possible en VM |
| VM instable / disque explose | arrêter chiffrement complet |
| recovery key introuvable | GPO / backup AD / process |

```powershell
Get-Tpm
Get-BitLockerVolume
manage-bde -status C:
manage-bde -protectors -get C:
```

## 9. Rollback

Selon le scénario :
- suspendre temporairement BitLocker ;
- supprimer un protecteur de test ;
- revenir à une validation théorique si le coût disque est trop important.

Toujours documenter ce qui a été réellement exécuté et ce qui reste théorique.

## 10. Liens Microsoft

- BitLocker overview : https://learn.microsoft.com/windows/security/operating-system-security/data-protection/bitlocker/
- BitLocker PowerShell : https://learn.microsoft.com/powershell/module/bitlocker/
- manage-bde : https://learn.microsoft.com/windows-server/administration/windows-commands/manage-bde
- TPM overview : https://learn.microsoft.com/windows/security/hardware-security/tpm/trusted-platform-module-overview
