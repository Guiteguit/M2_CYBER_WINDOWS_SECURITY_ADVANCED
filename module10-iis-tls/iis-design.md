# M10 — IIS Design

> Document à compléter par le groupe. Ne recopiez pas simplement la configuration finale : justifiez vos choix.

## 1. Architecture

Dessinez le flux :

```text
CLT01
  ↓
web.novacorp.local
  ↓
SRV01 / IIS
  ↓
Application Pool
  ↓
gMSA
```

Ajoutez les interactions avec :

- DNS ;
- PKI ;
- KDC ;
- Active Directory.

---

## 2. Identité du site

- FQDN retenu :
- justification :
- enregistrement DNS :
- méthode de validation :

---

## 3. Site IIS

- nom :
- chemin physique :
- bindings :
- Application Pool :
- composants IIS installés :
- justification :

---

## 4. Identité du processus

- identité du pool :
- pourquoi un gMSA ?
- droits NTFS nécessaires :
- droits volontairement non accordés :
- preuve de fonctionnement :

---

## 5. Authentification utilisateur

- méthode :
- Anonymous :
- Windows Authentication :
- providers :
- raison du choix :

---

## 6. Kerberos

- SPN attendu :
- objet AD qui le porte :
- justification :
- méthode de vérification d'unicité :
- preuve côté client :
- preuve côté serveur :

---

## 7. Navigateur

- comportement initial :
- zone de sécurité :
- modification réalisée :
- justification :
- impact sur l'envoi automatique des credentials :

---

## 8. Différences à maîtriser

Expliquez en quelques phrases :

### TLS vs Kerberos

### Utilisateur authentifié vs identité AppPool

### Kerberos vs NTLM

### SSO vs MFA

---

## 9. Risques / limites

Identifiez au moins trois risques ou limites de l'architecture et proposez une mesure pour chacun.
