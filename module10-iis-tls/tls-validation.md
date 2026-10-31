# TLS / Kerberos Validation

## URL

```text
https://web.novacorp.local
```

## DNS

```powershell
Resolve-DnsName web.novacorp.local
Test-NetConnection web.novacorp.local -Port 443
```

Résultat :

```text
À renseigner
```

## Certificat

- Subject :
- SAN : `web.novacorp.local`
- Issuer :
- Expiration :
- EKU Server Authentication :
- HasPrivateKey sur SRV01 :

Commande :

```powershell
Get-ChildItem Cert:\LocalMachine\My |
  Select Subject,Issuer,NotAfter,HasPrivateKey,Thumbprint
```

## Binding IIS

```powershell
Get-WebBinding -Name "NovaCorp-Web"
netsh http show sslcert
```

- HTTPS / 443 :
- Hostname : `web.novacorp.local`
- SNI :
- Certificat attendu :

## Confiance client

Depuis `CLT01` :

- navigateur sans avertissement :
- chaîne vers NovaCorp Root CA :

## Authentification Windows

```text
Anonymous : Disabled
Windows   : Enabled
Providers : Negotiate puis NTLM
```

Zone navigateur :

```text
https://web.novacorp.local → Intranet local
```

SSO sans nouvelle saisie de mot de passe :

```text
✅ validé dans le lab de référence
```

## Validation Kerberos

> À finaliser explicitement dans le lab de référence.

Depuis `CLT01` :

```powershell
whoami
klist purge
klist get HTTP/web.novacorp.local
klist
```

Preuve recherchée :

```text
Ticket de service : HTTP/web.novacorp.local
```

Contrôle serveur complémentaire si l'audit est disponible :

```text
Security Event ID 4624
Authentication Package / mécanisme à examiner
```

### Conclusion protocolaire

- SSO Windows : ✅ / ❌
- ticket HTTP présent : ✅ / ❌
- preuve Kerberos explicite : ✅ / ❌
- fallback NTLM constaté : ✅ / ❌

## Page Classic ASP

Fichier :

```text
resources/index.asp
```

Validation attendue :

- `LOGON_USER` affiche le bon utilisateur AD ;
- `AUTH_TYPE` est visible ;
- serveur et heure affichés ;
- la page ne doit pas être utilisée seule comme preuve de Kerberos.

État :

```text
⏳ à tester dans le lab de référence
```

## Logs IIS

- fichier / chemin :
- requête retrouvée :
- heure :
- utilisateur :
- code HTTP :

## Conclusion

Décrire séparément :

1. validation DNS ;
2. validation TLS ;
3. identité AppPool ;
4. validation SSO Windows ;
5. preuve Kerberos ;
6. fonctionnement de `index.asp`.
