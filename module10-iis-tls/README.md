# Module 10 — IIS + TLS

## Contexte
NovaCorp souhaite publier un intranet interne en HTTPS.

## Mission
Publiez `https://intranet.novacorp.local` avec :
- DNS interne ;
- IIS ;
- certificat délivré par la PKI NovaCorp ;
- binding HTTPS ;
- logs exploitables.

## Répartition suggérée
- A : IIS
- B : DNS
- C : certificat
- D : validation TLS
- E : logs / sécurité

## Travail demandé
- installer et publier IIS ;
- obtenir un certificat adapté ;
- configurer HTTPS ;
- démontrer que le navigateur fait confiance au certificat ;
- retrouver une requête dans les logs ;
- expliquer pourquoi HTTPS ne signifie pas que l'application est sécurisée.

## Livrables
- `iis-design.md`
- `tls-validation.md`
- preuves dans `evidence/`

## Checkpoint CP10
- DNS OK ;
- IIS OK ;
- HTTPS OK ;
- certificat valide ;
- logs vérifiés.
