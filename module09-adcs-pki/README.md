# Module 09 — AD CS / PKI Windows

## Ressources système recommandées

> Dimensionnement de lab. La PKI dispose désormais de sa VM dédiée.

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | AD DS / DNS | 2 | 4 Go | 60 Go |
| PKI01 | AD CS / CA Enterprise | 2 | 4 Go | 60 Go |
| SRV01 | serveur consommateur de certificats | 2 | 4 Go | 60 Go |
| CLT01 | validation de la chaîne | 2 | 4–6 Go | 64 Go |

PKI01 doit être joint au domaine et disposer d'une IP statique. La CA n'est pas installée sur DC01 ni sur SRV01.


## Contexte NovaCorp

NovaCorp doit publier des services HTTPS internes sans dépendre de certificats autosignés distribués manuellement.

Vous devez mettre en place une PKI interne simple permettant d'émettre et de valider des certificats serveur.

L'objectif n'est pas uniquement d'obtenir un cadenas dans le navigateur.

    Autorité de certification
            ↓ signe
    Certificat serveur
            ↓ présenté par
    Service
            ↓ vérifié par
    Client

## Objectifs

À la fin du module, vous devez être capables de :

- expliquer le rôle d'une CA ;
- distinguer certificat, clé publique et clé privée ;
- comprendre Subject, SAN, EKU, Issuer et période de validité ;
- déployer une CA Enterprise adaptée au lab ;
- concevoir un template de certificat serveur ;
- contrôler qui peut enroll ;
- délivrer un certificat adapté à un FQDN ;
- valider la chaîne de confiance ;
- expliquer les risques d'une mauvaise PKI ;
- préparer les certificats utilisés dans M10 et M11.

# 1. Concevoir la PKI

Pour le laboratoire, une CA Enterprise Root simple est acceptable.

Expliquez pourquoi une architecture de production peut séparer :

    Root CA
      ↓
    Issuing CA
      ↓
    certificats finaux

Documentez le nom de la CA, le serveur, la durée de vie, les services consommateurs et le modèle de confiance.

# 2. Comprendre un certificat

Identifiez :

- Subject ;
- SAN ;
- Issuer ;
- numéro de série ;
- période de validité ;
- clé publique ;
- présence de la clé privée ;
- EKU ;
- chaîne de certification.

Pourquoi CN=srv01.novacorp.local n'est-il pas nécessairement valide pour web.novacorp.local ?

# 3. Template Web Server

Concevez un template pour les services Web NovaCorp.

Analysez :

- Server Authentication ;
- Subject / SAN ;
- qui peut lire ;
- qui peut enroll ;
- possibilité de fournir le Subject dans la requête ;
- implications de sécurité.

Ne donnez pas des droits d'enrollment larges sans justification.

# 4. Enrollment

Obtenez un certificat destiné à un service HTTPS interne.

Le certificat doit :

- correspondre au FQDN réellement utilisé ;
- contenir l'EKU Server Authentication ;
- disposer de sa clé privée sur le serveur consommateur ;
- chaîner vers la CA NovaCorp ;
- ne pas être expiré.

# 5. Validation de la chaîne

Démontrez :

    certificat serveur
          ↓
    Issuer NovaCorp
          ↓
    CA de confiance
          ↓
    validation client

Contrôlez également qu'un nom DNS incorrect ou une CA non approuvée produit une erreur différente.

# 6. Mauvaises pratiques PKI

Identifiez au moins trois risques parmi :

- droits Enroll trop larges ;
- template permettant des usages dangereux ;
- Supply in the request accordé sans contrôle ;
- export de clé privée inutile ;
- certificat trop long ;
- clé privée stockée ou partagée ;
- CA exposée à trop d'administrateurs ;
- absence de révocation / gouvernance ;
- wildcard utilisé sans besoin.

# 7. Préparation M10 / M11

Votre PKI doit permettre de comprendre ou délivrer des certificats pour :

    web.novacorp.local
    fs.novacorp.local
    claims.novacorp.local

# Boîte à outils

    Get-ChildItem Cert:\LocalMachine\My
    certutil -store My
    certutil -verify <certificat.cer>

Utilisez aussi MMC Certificats pour visualiser la chaîne.

# Travail distribué

## Groupe de 5

- A : architecture PKI ;
- B : installation CA ;
- C : templates / permissions ;
- D : enrollment / service ;
- E : validation / audit.

## Groupe de 4

- A : CA ;
- B : template ;
- C : certificat ;
- D : audit / validation.

# Livrables

- pki-design.md
- certificate-review.md
- preuves non sensibles dans evidence/

Aucune clé privée, PFX ou secret ne doit être versionné.

# Validation

    [ ] rôle de la CA expliqué
    [ ] CA opérationnelle
    [ ] template serveur conçu
    [ ] permissions d'enrollment justifiées
    [ ] certificat serveur émis
    [ ] Subject / SAN contrôlés
    [ ] EKU Server Authentication vérifiée
    [ ] clé privée présente uniquement où nécessaire
    [ ] chaîne de confiance validée
    [ ] au moins trois mauvaises pratiques expliquées
    [ ] aucun PFX / clé privée versionné

# Questions de restitution

1. Quelle différence entre clé publique et clé privée ?
2. Pourquoi la clé privée ne doit-elle jamais être dans Git ?
3. Quelle différence entre Subject et SAN ?
4. À quoi sert l'EKU ?
5. Pourquoi un client fait-il confiance à un certificat signé par NovaCorp ?
6. Pourquoi une CA compromise est-elle particulièrement grave ?
7. Quel risque introduit un template trop permissif ?
8. Pourquoi M10 et M11 dépendent-ils de la PKI construite ici ?

# Checkpoint M09

    CA opérationnelle
    +
    template contrôlé
    +
    certificat valide
    +
    chaîne de confiance comprise

Snapshot conseillé : M09-ADCS-PKI-OK.
