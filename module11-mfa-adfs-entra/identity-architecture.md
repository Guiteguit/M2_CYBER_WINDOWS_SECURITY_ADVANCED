# Architecture identité NovaCorp — M11

## Situation actuelle

Décrivez l'environnement avant M11.

## Besoin

Pourquoi NovaCorp souhaite-t-elle introduire un IdP et une fédération ?

## Architecture du POC

Documentez :

- DC01 ;
- SRV01 ;
- PKI01 ;
- ADFS01 ;
- CLT01 ;
- fs.novacorp.local ;
- claims.novacorp.local.

## AD DS — DC01

Rôle :

Ce qu'il ne fait pas dans ce scénario :

## PKI — PKI01

Rôle de la CA NovaCorp :

Certificats émis pour le POC :

Pourquoi la PKI est-elle séparée de SRV01 et ADFS01 ?

## AD FS — ADFS01

Rôle :

Service account :

Base de configuration :

Nom du Federation Service :

## Relying Party — SRV01

Application :

Identifier / Realm :

Endpoint :

## Certificats

### TLS / Service-Communications

Rôle :

CA émettrice :

### Token-Signing

Rôle :

Pourquoi ce certificat est-il distinct du certificat TLS ?

### Token-Decrypting

Rôle :

## Claims

Listez uniquement les claims réellement nécessaires.

## Entra ID

Expliquez comment le rôle d'IdP évoluerait dans une architecture cloud ou hybride.

## MFA

Position exacte dans le flux :

## Architecture cible NovaCorp

Choisissez :

- on-prem ;
- hybride ;
- cloud-first.

Justification :

## Risques / compromis

| Risque / compromis | Impact | Mesure |
|---|---|---|
| | | |
