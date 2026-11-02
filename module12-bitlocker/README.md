# Module 12 — BitLocker, TPM et récupération

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | stockage AD DS de la recovery | 2 | 4 Go | 60 Go |
| CLT01 | poste Windows 11 + vTPM | 2 | 4–6 Go | 64 Go |

**Attention stockage hyperviseur :** BitLocker peut faire grossir fortement les disques thin-provisioned et les snapshots. Vérifiez l'espace disponible avant toute conversion réelle.


## Prérequis et dépendances

**Réutilise :**
- M02 : `CLT01` joint au domaine et AD DS disponible ;
- M03 : logique de politique centralisée ;
- M06 : moindre privilège pour l'accès aux secrets de récupération.

**Produit pour la suite :**
- compréhension TPM / Secure Boot / chiffrement disque ;
- modèle de Recovery Password ;
- éventuelle sauvegarde AD DS.

M13 complète cette protection des données au repos par le durcissement de l'endpoint en fonctionnement.

## Contexte NovaCorp

NovaCorp souhaite protéger les données stockées sur les postes utilisateurs, en particulier en cas de perte, de vol ou d'accès physique au support.

L'objectif n'est pas simplement d'activer BitLocker : vous devez comprendre le mécanisme de protection.

    Données du volume
          ↓
         FVEK
          ↓
          VMK
          ↓
    Key Protectors
     ├── TPM
     └── Recovery Password

BitLocker protège principalement les données au repos. Il ne remplace ni les ACL, ni Defender, ni le MFA, ni le verrouillage de session.

## Objectifs

À la fin du module, vous devez être capables de :

- expliquer le rôle du TPM ;
- distinguer TPM, Secure Boot et BitLocker ;
- expliquer FVEK, VMK et Key Protectors ;
- identifier les prérequis d'un poste ;
- concevoir une politique BitLocker cohérente ;
- comprendre le rôle du protecteur TPM ;
- expliquer le rôle de la Recovery Password ;
- centraliser ou concevoir la sauvegarde de récupération dans AD DS ;
- décrire un scénario de recovery ;
- expliquer ce que BitLocker protège et ce qu'il ne protège pas ;
- identifier les risques spécifiques à la virtualisation.

# 1. Comprendre le TPM

Le TPM est un composant de sécurité matériel ou virtuel. Dans une VM, il peut prendre la forme d'un vTPM.

Le TPM ne chiffre pas lui-même le disque. Il peut notamment protéger des secrets cryptographiques, conserver des clés dans un environnement protégé, mesurer l'état du démarrage et participer à la libération conditionnelle d'une clé.

## PCR

Le TPM maintient des registres appelés Platform Configuration Registers (PCR).

    Firmware
      ↓
    Boot Manager
      ↓
    Configuration de boot
      ↓
    Mesures TPM / PCR

BitLocker peut s'appuyer sur cet état pour décider si le déverrouillage automatique doit avoir lieu.

# 2. Comprendre BitLocker

BitLocker ne chiffre pas directement le volume avec le mot de passe utilisateur ou avec le TPM.

La Full Volume Encryption Key (FVEK) chiffre les données du volume.

La Volume Master Key (VMK) protège la FVEK.

Un Key Protector protège l'accès à la VMK. Exemples : TPM, TPM + PIN, Recovery Password ou Startup Key selon le scénario.

    Fichiers / blocs
          ↓
         FVEK
          ↓
          VMK
          ↓
    TPM / Recovery Password

# 3. TPM, Secure Boot et BitLocker

    BitLocker   → chiffre le volume
    TPM         → protège et conditionne l'accès à des clés
    Secure Boot → vérifie la confiance dans les composants de démarrage

Un TPM présent n'implique pas que Secure Boot soit actif. Un Secure Boot désactivé ne signifie pas automatiquement que BitLocker est inutilisable.

# 4. Mission — État initial

Déterminez :

- présence et état du TPM ;
- état Secure Boot ;
- état BitLocker ;
- volumes concernés ;
- protecteurs existants ;
- méthode de chiffrement.

Boîte à outils :

    Get-Tpm
    Get-BitLockerVolume
    manage-bde -status C:
    Confirm-SecureBootUEFI

Exemple :

    TPM Present            : True
    TPM Ready              : True
    BitLocker              : FullyDecrypted
    Encryption Percentage  : 0
    Protection Status      : Off
    Key Protectors         : aucun

# 5. Mission — Concevoir les protecteurs

Architecture minimale :

    VMK
    ├── TPM
    └── Recovery Password

Fonctionnement normal :

    Boot cohérent
    → TPM satisfait
    → VMK accessible
    → FVEK accessible
    → volume déverrouillé

Fonctionnement recovery :

    État de boot inattendu
    → déverrouillage automatique impossible
    → écran BitLocker Recovery
    → Recovery Password
    → volume déverrouillé

# 6. Résultats attendus après activation

Le formateur peut réaliser la manipulation complète ou travailler à partir des résultats attendus lorsque les contraintes de virtualisation sont trop fortes.

Pendant la conversion :

    VolumeStatus         : EncryptionInProgress
    ProtectionStatus     : On
    EncryptionPercentage : progression
    EncryptionMethod     : XTS-AES

À la fin :

    VolumeStatus         : FullyEncrypted
    EncryptionPercentage : 100
    ProtectionStatus     : On

Protecteurs attendus :

    TPM
    Recovery Password

Validation :

    Get-BitLockerVolume -MountPoint "C:"
    manage-bde -protectors -get C:

# 7. Recovery Password

La Recovery Password est un mécanisme de secours.

Elle ne doit pas être stockée dans Git, dans un fichier texte sur le poste protégé, dans une capture d'écran partagée ou dans une documentation de cours.

Le lab doit démontrer ou expliquer son identifiant, son stockage, qui peut la consulter, comment elle est récupérée et comment l'accès est audité.

# 8. Sauvegarde AD DS

Architecture cible :

    CLT01
      ↓
    Recovery Password Protector
      ↓
    AD DS
      ↓
    objet msFVE-RecoveryInformation

Le poste doit pouvoir sauvegarder son protecteur de récupération dans Active Directory.

Exemple de validation côté AD DS :

    Get-ADObject -SearchBase (Get-ADComputer CLT01).DistinguishedName -SearchScope OneLevel -Filter 'objectClass -eq "msFVE-RecoveryInformation"' -Properties msFVE-RecoveryPassword,whenCreated

Aucune vraie Recovery Password ne doit être commitée.

# 9. Scénario de récupération

Vous devez savoir expliquer le scénario suivant :

> Le poste démarre mais BitLocker ne déverrouille plus automatiquement le volume système.

Analysez :

1. pourquoi le TPM peut refuser la libération automatique ;
2. ce que représente le Recovery ID ;
3. où le support doit rechercher la Recovery Password ;
4. qui doit être autorisé à la consulter ;
5. comment l'utilisateur récupère l'accès ;
6. ce qui doit être audité après l'incident.

# 10. Ce que BitLocker protège

BitLocker réduit notamment le risque lié au vol d'un ordinateur éteint, au retrait du SSD, au montage offline du volume et à l'accès physique au support sans protecteur valide.

# 11. Ce que BitLocker ne protège pas

Si le volume est déjà déverrouillé :

    Windows en fonctionnement
    → clés disponibles
    → volume monté
    → fichiers accessibles selon les droits de la session

BitLocker ne remplace donc pas l'authentification, le MFA, les ACL, Defender/EDR, le verrouillage de session ou le moindre privilège.

# 12. Virtualisation — attention aux snapshots

Le chiffrement dans une VM peut provoquer une forte croissance du stockage de l'hyperviseur.

BitLocker réécrit les blocs du volume sous forme chiffrée. Avec du thin provisioning, des snapshots, des deltas VMware ou un espace hôte limité, le stockage consommé peut augmenter rapidement.

Avant une conversion réelle :

- vérifier l'espace libre sur l'hôte ;
- limiter les snapshots ;
- utiliser une petite VM dédiée si nécessaire ;
- préférer Used Space Only pour un lab neuf ;
- ne pas lancer un chiffrement ou déchiffrement massif si le datastore est presque plein.

# 13. Troubleshooting

Consultez troubleshooting.md.

# 14. Répartition

## Groupe de 5

- A : TPM / Secure Boot / prérequis ;
- B : politique BitLocker ;
- C : Key Protectors ;
- D : Recovery / AD DS ;
- E : audit / risques / validation.

## Groupe de 4

- A : prérequis ;
- B : BitLocker ;
- C : Recovery / AD DS ;
- D : audit / validation.

Les rôles tournent et personne ne valide son propre travail.

# Livrables

- bitlocker-design.md
- recovery-plan.md
- troubleshooting.md
- preuves non sensibles dans evidence/

# Validation M12

    [ ] TPM expliqué
    [ ] TPM / Secure Boot / BitLocker distingués
    [ ] FVEK / VMK / Key Protector compris
    [ ] état initial vérifié
    [ ] politique de chiffrement justifiée
    [ ] TPM Protector compris
    [ ] Recovery Password comprise
    [ ] stockage de récupération AD DS expliqué ou validé
    [ ] scénario de recovery expliqué
    [ ] données au repos distinguées d'une session déverrouillée
    [ ] risque VM / snapshots identifié
    [ ] aucun secret versionné

# Questions de restitution

1. Pourquoi le TPM ne chiffre-t-il pas lui-même le disque ?
2. Quel est le rôle de la FVEK ?
3. Quel est le rôle de la VMK ?
4. Pourquoi plusieurs Key Protectors peuvent-ils protéger la même VMK ?
5. Pourquoi BitLocker ne protège-t-il pas une session déjà déverrouillée ?
6. Quelle différence entre TPM et Secure Boot ?
7. Pourquoi centraliser les Recovery Passwords ?
8. Que risque une entreprise qui perd à la fois le protecteur normal et la Recovery Password ?
9. Pourquoi BitLocker peut-il consommer beaucoup d'espace dans un environnement VMware avec snapshots ?

# Checkpoint M12

    Mécanisme compris
    +
    protecteurs compris
    +
    recovery maîtrisée
    +
    risques opérationnels identifiés

Snapshot conseillé après validation réelle : M12-BITLOCKER-OK.
