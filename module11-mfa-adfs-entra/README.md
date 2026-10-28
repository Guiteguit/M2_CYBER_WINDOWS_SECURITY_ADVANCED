# Module 11 — MFA, AD FS et Entra ID

## Contexte
NovaCorp veut comprendre comment sécuriser l'accès à des applications modernes et préparer une identité hybride.

## Objectifs
Distinguer :
- AD DS ;
- AD FS ;
- Entra ID ;
- MFA ;
- SAML ;
- OIDC/OAuth à haut niveau.

## Mission
Concevez une architecture d'identité cible pour NovaCorp et démontrez, selon l'environnement disponible :
- soit un POC AD FS ;
- soit un POC Entra/MFA ;
- soit un flux d'authentification fédérée documenté et partiellement testé.

La réussite ne dépend pas d'une licence Microsoft 365.

## Répartition suggérée
- A : AD DS
- B : AD FS
- C : application / relying party
- D : MFA
- E : Entra / architecture / audit

## Travail demandé
- comparer AD DS, AD FS, Entra ID et MFA ;
- dessiner le flux utilisateur → application → IdP → token/claims → application ;
- identifier IdP, relying party, claims, token et trust ;
- expliquer ce que le MFA protège et ce qu'il ne protège pas ;
- choisir une architecture : on-prem, hybride ou cloud-first.

## Livrables
- `identity-architecture.md`
- `authentication-flow.md`
- `security-review.md`

## Checkpoint CP11
- rôles AD DS / AD FS / Entra compris ;
- MFA correctement positionné ;
- flux expliqué ;
- architecture cible justifiée.
