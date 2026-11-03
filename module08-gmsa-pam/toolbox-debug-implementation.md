# M08 — Toolbox gMSA & concepts PAM

> Support technique pour implémenter, tester et dépanner un gMSA dans NovaCorp.

## 1. Rappel de logique

Un **gMSA** permet :
- d’exécuter un service avec une identité AD ;
- sans gérer manuellement le mot de passe ;
- avec restriction des machines autorisées.

Cela ne remplace pas une vraie solution PAM, mais réduit fortement le risque des comptes `svc_*` statiques.

## 2. Vérifier ou créer la KDS Root Key

### Vérifier l’existant

```powershell
Get-KdsRootKey
```

### Créer en lab mono-DC

```powershell
Add-KdsRootKey -EffectiveImmediately
```

ou, en lab, si nécessaire pour éviter l’attente :

```powershell
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
```

> Réserver cette logique accélérée au **lab**, pas à une prod multi-DC.

## 3. Préparer le groupe des hôtes autorisés

```powershell
New-ADGroup \
  -Name "GG_GMSA_DEMO_HOSTS" \
  -GroupScope Global \
  -GroupCategory Security

Add-ADGroupMember \
  -Identity "GG_GMSA_DEMO_HOSTS" \
  -Members "SRV01$"
```

## 4. Créer le gMSA

```powershell
New-ADServiceAccount \
  -Name "gmsa-demo" \
  -DNSHostName "novacorp.local" \
  -PrincipalsAllowedToRetrieveManagedPassword "GG_GMSA_DEMO_HOSTS"
```

### Vérifier le compte

```powershell
Get-ADServiceAccount gmsa-demo -Properties *
```

## 5. Installer le gMSA sur SRV01

Sur SRV01 :

```powershell
Install-ADServiceAccount -Identity gmsa-demo
Test-ADServiceAccount -Identity gmsa-demo
```

Attendu :
- installation OK ;
- test retournant `True`.

## 6. Utiliser le gMSA dans un service

Exemple de logique :
- service Windows ou tâche applicative ;
- identité = `NOVACORP\gmsa-demo$` ;
- mot de passe laissé vide.

Dans certains scénarios IIS, `appcmd` ou l’interface du pool d’application sont nécessaires. Dans d’autres cas, un service Windows classique peut suffire pour la démonstration.

## 7. Tests de validation

### Test A — hôte autorisé
- `SRV01` est dans `GG_GMSA_DEMO_HOSTS` ;
- `Test-ADServiceAccount` renvoie `True`.

### Test B — hôte non autorisé
- tester depuis une machine non autorisée ;
- l’installation ou le test doit échouer.

### Test C — service réel
- le service démarre avec `gmsa-demo$` ;
- aucune saisie de mot de passe humain ;
- le service reste fonctionnel.

## 8. Troubleshooting

| Symptôme | Vérification |
|---|---|
| `Test-ADServiceAccount` retourne `False` | KDS key, groupe hôtes, réplication, orthographe du gMSA |
| impossible d’installer le gMSA | machine non autorisée, module AD absent |
| le service ne démarre pas | syntaxe du compte, dépendances du service, droits locaux |
| comportement incohérent juste après création KDS | délai de prise en compte en environnement de lab |

### Commandes utiles

```powershell
Get-KdsRootKey
Get-ADGroupMember GG_GMSA_DEMO_HOSTS
Get-ADServiceAccount gmsa-demo -Properties PrincipalsAllowedToRetrieveManagedPassword
Get-WinEvent -LogName System -MaxEvents 50
```

## 9. Rollback

```powershell
Uninstall-ADServiceAccount -Identity gmsa-demo
Remove-ADServiceAccount -Identity gmsa-demo
Remove-ADGroupMember -Identity "GG_GMSA_DEMO_HOSTS" -Members "SRV01$" -Confirm:$false
```

Supprimer ensuite le groupe si besoin :

```powershell
Remove-ADGroup "GG_GMSA_DEMO_HOSTS"
```

## 10. Liens Microsoft

- gMSA overview : https://learn.microsoft.com/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview
- Manage gMSA : https://learn.microsoft.com/windows-server/security/group-managed-service-accounts/getting-started-with-group-managed-service-accounts
- KDS root key : https://learn.microsoft.com/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key
