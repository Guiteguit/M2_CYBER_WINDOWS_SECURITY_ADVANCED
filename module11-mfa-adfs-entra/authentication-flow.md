# Authentication Flow — M11

## Objectif

Documenter le flux réel observé dans le POC NovaCorp.

## Séquence

Complétez :

1. L'utilisateur ouvre `https://claims.novacorp.local/`.
2. L'application détecte que :
3. Le navigateur est redirigé vers :
4. AD FS authentifie l'utilisateur via :
5. AD FS interroge :
6. Les règles de claims produisent :
7. AD FS signe :
8. Le navigateur renvoie :
9. L'application valide :
10. L'application crée :

## Schéma

```text
CLT01
  ↓
NovaCorp-Claims
  ↓
AD FS
  ↓
AD DS
  ↓
Claims Rules
  ↓
Token
  ↓
NovaCorp-Claims
```

Ajoutez les informations réellement observées.

## Claims observés

| Claim Type | Valeur | Issuer | Utilité |
|---|---|---|---|
| | | | |

## Token

- protocole :
- relying party identifier :
- issuer :
- certificat de signature :
- méthode de validation :

## Session

- mécanisme de session :
- condition nécessaire côté Application Pool :
- impact si la session ne peut pas être créée :

## Intervention MFA

Indiquez exactement où un facteur supplémentaire serait demandé.

## Point de confiance principal

Expliquez ce que l'application doit réellement considérer comme digne de confiance.
