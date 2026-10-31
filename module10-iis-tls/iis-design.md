# IIS NovaCorp — Design

## FQDN

```text
web.novacorp.local
```

## Serveur

```text
SRV01
```

## DNS

| Élément | Valeur |
|---|---|
| Nom | `web.novacorp.local` |
| Cible | SRV01 |
| Validation | `Resolve-DnsName web.novacorp.local` |

## Site IIS

```text
Nom            : NovaCorp-Web
Répertoire     : C:\inetpub\NovaCorp-Web
HTTP           : 80 / Host Header web.novacorp.local
HTTPS          : 443 / SNI web.novacorp.local
```

## Application Pool

```text
NovaCorp-AppPool
```

Identité :

```text
NOVACORP\gmsa-demo$
```

Validation gMSA :

```powershell
Test-ADServiceAccount gmsa-demo
```

## Authentification

```text
Anonymous Authentication : Disabled
Windows Authentication   : Enabled
Providers                 : Negotiate, NTLM
useKernelMode             : True
useAppPoolCredentials     : True
```

## SPN

```text
HTTP/web.novacorp.local
```

Porté dans le lab par :

```text
NOVACORP\gmsa-demo$
```

Contrôles :

```powershell
setspn -Q HTTP/web.novacorp.local
setspn -L NOVACORP\gmsa-demo$
setspn -X
```

## Certificat

- Subject / SAN : `web.novacorp.local`
- Issuer : PKI NovaCorp
- EKU : Server Authentication
- Private Key : présente sur SRV01

## Mesures de sécurité

- TLS obligatoire pour l'accès final ;
- certificat correspondant au FQDN réellement utilisé ;
- identité gMSA sans mot de passe géré manuellement ;
- droits NTFS minimaux (`RX`) sur le contenu Web ;
- authentification anonyme désactivée ;
- Windows Authentication activée ;
- SPN unique ;
- Kerberos prouvé explicitement, pas supposé ;
- logs IIS et événements Windows conservés comme preuves ;
- configuration navigateur documentée pour l'Intranet local.

## État du lab de référence

| Élément | État |
|---|---|
| IIS / site | ✅ |
| HTTPS / PKI | ✅ |
| AppPool gMSA | ✅ |
| SSO Windows | ✅ |
| Kerberos explicitement prouvé | ⏳ |
| `index.asp` validé | ⏳ |
