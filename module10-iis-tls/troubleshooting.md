# M10 — Troubleshooting IIS / TLS / Kerberos

## Méthode imposée

Pour chaque incident :

```text
1. Décrire le symptôme
2. Formuler plusieurs hypothèses
3. Collecter des preuves
4. Isoler la cause
5. Corriger
6. Rejouer le test
7. Documenter la preuve finale
```

Ne faites pas de changement “au hasard”.

---

# Incident 1 — SPN absent

## Symptôme possible

- le site est accessible ;
- Windows Authentication fonctionne ;
- Kerberos n'est pas démontré ;
- une négociation peut retomber sur NTLM.

## Points à investiguer

```powershell
setspn -Q HTTP/web.novacorp.local
setspn -L NOVACORP\gmsa-demo$
```

Vérifiez également :

```powershell
klist
klist get HTTP/web.novacorp.local
```

## Questions

- Quel compte doit porter le SPN dans l'architecture NovaCorp ?
- Pourquoi l'absence de SPN n'empêche-t-elle pas nécessairement tout accès Windows Authentication ?
- Quelle preuve permet de différencier Kerberos d'un fallback NTLM ?

---

# Incident 2 — SPN dupliqué

## Injection formateur

Créer volontairement un doublon uniquement dans un environnement de laboratoire maîtrisé, puis demander aux étudiants de le détecter.

## Diagnostic

```powershell
setspn -Q HTTP/web.novacorp.local
setspn -X
```

## Questions

- Pourquoi Kerberos a-t-il besoin d'un SPN unique ?
- Pourquoi `setspn -S` est-il préférable à `setspn -A` ?
- Quel objet AD possède actuellement le SPN attendu ?

## Validation

Après correction :

```powershell
setspn -Q HTTP/web.novacorp.local
klist purge
klist get HTTP/web.novacorp.local
```

---

# Incident 3 — DNS incorrect

## Symptôme possible

- le client atteint une mauvaise IP ;
- le nom du certificat ne correspond pas au nom utilisé ;
- le SPN demandé ne correspond pas au service visé ;
- HTTP/HTTPS peut échouer avant même l'authentification.

## Diagnostic

```powershell
Resolve-DnsName web.novacorp.local
ipconfig /all
Test-NetConnection web.novacorp.local -Port 443
```

Comparez la réponse DNS avec l'adresse réelle de `SRV01`.

## Questions

- Pourquoi DNS intervient-il à la fois dans l'accès au service et indirectement dans Kerberos ?
- Pourquoi tester uniquement `ping` est-il insuffisant ?

---

# Incident 4 — NTLM au lieu de Kerberos

## Symptôme

Le SSO semble fonctionner, mais aucune preuve Kerberos n'est observée.

## Diagnostic

Vérifiez successivement :

```powershell
setspn -Q HTTP/web.novacorp.local
setspn -L NOVACORP\gmsa-demo$
klist
klist get HTTP/web.novacorp.local
```

Puis contrôlez IIS :

```text
Windows Authentication = Enabled
Providers = Negotiate puis NTLM
useKernelMode = True
useAppPoolCredentials = True
```

Contrôlez également les événements de connexion sur `SRV01` lorsque l'audit le permet.

## Hypothèses possibles

- SPN absent ;
- SPN sur le mauvais compte ;
- SPN dupliqué ;
- accès au site avec un autre nom que `web.novacorp.local` ;
- provider / configuration IIS incorrect ;
- ticket non obtenu ;
- comportement navigateur.

## Question

Pourquoi “aucune popup de credentials” ne suffit-il pas à prouver Kerberos ?

---

# Incident 5 — Zone Intranet local

## Symptôme

Le site répond correctement mais Edge demande les identifiants Windows.

## Diagnostic

Vérifiez le classement du site :

```text
inetcpl.cpl
→ Sécurité
→ Intranet local
→ Sites
→ Avancé
```

Le site de lab attendu est :

```text
https://web.novacorp.local
```

## Validation

Fermez / relancez le navigateur puis ouvrez le site.

## Question

Pourquoi la zone de sécurité du navigateur affecte-t-elle l'envoi automatique de l'identité Windows ?

---

# Matrice de restitution

| Incident | Symptôme | Première preuve | Cause | Correction | Validation |
|---|---|---|---|---|---|
| SPN absent | | | | | |
| SPN dupliqué | | | | | |
| DNS incorrect | | | | | |
| NTLM au lieu de Kerberos | | | | | |
| Zone Intranet local | | | | | |
