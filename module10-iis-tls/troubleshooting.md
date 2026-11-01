# M10 — Troubleshooting IIS / TLS / Kerberos

## Principe

Ce document fournit des **pistes d'observation**, pas des corrections.

Pour chaque incident :

```text
1. Décrire précisément le symptôme
2. Proposer au moins deux hypothèses
3. Choisir une preuve permettant de départager les hypothèses
4. Isoler la cause
5. Corriger un seul élément
6. Rejouer le test
7. Conserver la preuve finale
```

---

# Incident A — Le site ne répond pas en HTTPS

## Symptômes possibles

- timeout ;
- connexion refusée ;
- mauvais site IIS ;
- certificat non présenté ;
- erreur de nom ou de confiance.

## Boîte à outils

```text
Resolve-DnsName
Test-NetConnection
Get-Website
Get-WebBinding
Get-ChildItem Cert:\LocalMachine\My
```

## Questions

- Le problème est-il DNS, transport, IIS ou TLS ?
- Le certificat correspond-il au nom utilisé ?
- Le site écouté sur 443 est-il le bon ?

---

# Incident B — Le SSO fonctionne, mais Kerberos n'est pas prouvé

## Symptôme

Le navigateur n'affiche aucune popup, mais aucune preuve Kerberos n'est disponible.

## Boîte à outils

```text
klist
klist get <SPN>
setspn -Q <SPN>
setspn -L <compte>
```

## Questions

- Un fallback NTLM est-il possible ?
- Le SPN existe-t-il ?
- Est-il porté par la bonne identité ?
- Le client demande-t-il réellement le bon SPN ?

---

# Incident C — SPN absent ou porté par le mauvais compte

## Symptômes possibles

- Kerberos ne fonctionne pas ;
- NTLM fonctionne ;
- le ticket HTTP attendu n'apparaît pas.

## Boîte à outils

```text
setspn -Q <SPN>
setspn -L <compte>
```

## Questions

- Quelle identité exécute le service ?
- Quel objet AD doit porter le SPN ?
- Pourquoi l'absence de SPN n'empêche-t-elle pas forcément tout accès ?

---

# Incident D — SPN dupliqué

## Symptômes possibles

- comportement Kerberos incohérent ;
- erreurs d'authentification ;
- ticket non utilisable.

## Boîte à outils

```text
setspn -Q <SPN>
setspn -X
```

## Questions

- Pourquoi Kerberos exige-t-il l'unicité du SPN ?
- Quels objets possèdent le même SPN ?
- Quelle inscription est légitime ?

---

# Incident E — DNS incorrect

## Symptômes possibles

- mauvaise IP ;
- mauvais certificat ;
- mauvais SPN demandé ;
- service injoignable.

## Boîte à outils

```text
Resolve-DnsName
ipconfig /all
Test-NetConnection
```

## Questions

- Le FQDN pointe-t-il vers le bon serveur ?
- Quel nom est réellement utilisé par le navigateur ?
- Pourquoi DNS intervient-il indirectement dans Kerberos ?

---

# Incident F — Edge demande les credentials

## Symptôme

Le site répond mais le navigateur demande l'utilisateur et le mot de passe.

## Points à investiguer

- zone de sécurité du site ;
- paramètres d'authentification IIS ;
- identité de l'utilisateur ;
- provider utilisé.

## Question

Pourquoi ce symptôme ne prouve-t-il pas que le serveur IIS ou Kerberos sont mal configurés ?

---

# Incident G — Le gMSA fonctionne mais le site retourne 401/500

## Points à investiguer

- état de l'Application Pool ;
- identité configurée ;
- droits NTFS ;
- logs IIS ;
- événements système ;
- configuration Windows Authentication.

## Question

Pourquoi `Test-ADServiceAccount = True` ne prouve-t-il pas que l'application IIS est correctement configurée ?

---

# Matrice de restitution

| Incident | Symptôme | Hypothèses | Preuve décisive | Cause | Correction | Validation |
|---|---|---|---|---|---|---|
| HTTPS | | | | | | |
| Kerberos non prouvé | | | | | | |
| SPN incorrect | | | | | | |
| SPN dupliqué | | | | | | |
| DNS | | | | | | |
| Navigateur | | | | | | |
| gMSA / AppPool | | | | | | |
