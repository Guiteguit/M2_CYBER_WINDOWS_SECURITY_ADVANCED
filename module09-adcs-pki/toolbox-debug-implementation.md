# M09 — Toolbox PKI / AD CS

> Support technique pour déployer, vérifier et dépanner une PKI NovaCorp dans le lab.

## 1. Rôle et logique

La PKI sert ici à :
- délivrer des certificats internes ;
- sécuriser IIS / web.novacorp.local ;
- préparer des usages comme TLS, ADFS, potentiellement authentification machine/service.

## 2. Installer AD CS

Sur le serveur PKI dédié :

```powershell
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
Get-WindowsFeature ADCS-Cert-Authority
```

Configurer ensuite l’autorité de certification d’entreprise via l’assistant ou PowerShell.

## 3. Vérifier les services

```powershell
Get-Service CertSvc
certutil -config - -ping
```

## 4. Vérifier l’autorité

```powershell
certutil -ca.cert
certutil -cainfo
```

## 5. Modèles de certificats

Vérifier les templates disponibles :

```powershell
certutil -catemplates
```

Dans le lab, si le template voulu n’apparaît pas dans la demande :
- vérifier qu’il est bien **publié** sur la CA ;
- vérifier les **permissions** d’enrôlement ;
- vérifier les **Subject Name / SAN** selon le template.

## 6. Demande de certificat

Exemple de logique pour `web.novacorp.local` :
- modèle adapté au serveur web ;
- SAN DNS = `web.novacorp.local` ;
- clé privée présente ;
- certificat stocké dans `LocalMachine\My`.

### Vérifier le magasin local

```powershell
Get-ChildItem Cert:\LocalMachine\My |
Select Subject,Issuer,NotAfter,HasPrivateKey,Thumbprint
```

## 7. Vérifier la chaîne

```powershell
certutil -store my
certutil -verify -urlfetch <thumbprint-ou-fichier.cer>
```

## 8. Points de validation

### Test A — certificat émis
- le certificat est présent ;
- le sujet/SAN est correct ;
- la clé privée est présente.

### Test B — confiance
- le client fait confiance à la chaîne ;
- pas d’alerte de certificat sur le site interne.

### Test C — usage réel
- le certificat est réellement utilisé dans le binding IIS ou le service cible.

## 9. Troubleshooting

| Symptôme | Vérification |
|---|---|
| seul le template Ordinateur apparaît | template voulu non publié ou permissions manquantes |
| les champs de la demande ne s’appliquent pas | paramètres du template (Subject Name) |
| certificat présent mais site en alerte | chaîne non approuvée, mauvais binding, nom incorrect |
| pas de clé privée | demande/magasin incorrect ou certificat importé sans clé |
| demande impossible | service CA, firewall, droits, template |

### Commandes utiles

```powershell
Get-Service CertSvc
Get-ChildItem Cert:\LocalMachine\My
netsh http show sslcert
Get-WebBinding
```

## 10. Rollback

- supprimer le certificat de test du magasin ;
- retirer le binding s’il était temporaire ;
- dépublier un template de lab si nécessaire ;
- documenter tout changement sur la CA.

## 11. Liens Microsoft

- AD CS overview : https://learn.microsoft.com/windows-server/identity/ad-cs/active-directory-certificate-services-overview
- certutil : https://learn.microsoft.com/windows-server/administration/windows-commands/certutil
- Certificate templates : https://learn.microsoft.com/windows-server/identity/ad-cs/certificate-template-concepts
