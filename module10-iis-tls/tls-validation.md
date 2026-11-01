# M10 — Validation IIS / TLS / Kerberos

## URL testée

```text
https://web.novacorp.local
```

---

## 1. DNS / connectivité

- IP obtenue :
- serveur attendu :
- port 443 accessible :
- preuve conservée :

### Conclusion

---

## 2. TLS

- Subject :
- SAN :
- Issuer :
- expiration :
- EKU :
- clé privée disponible côté serveur :
- chaîne de confiance valide côté client :

### Conclusion

Expliquez pourquoi le certificat est valide pour **ce FQDN précis**.

---

## 3. IIS

- site démarré :
- binding HTTPS :
- SNI :
- Application Pool :
- identité du pool :
- site accessible :

### Conclusion

---

## 4. gMSA

- compte utilisé :
- hôte autorisé :
- preuve que SRV01 peut utiliser le gMSA :
- droits NTFS accordés :
- justification :

---

## 5. SSO Windows

- Anonymous Authentication :
- Windows Authentication :
- providers :
- comportement navigateur avant configuration Intranet :
- comportement après :
- utilisateur connecté :

### Conclusion

Expliquez pourquoi l'absence de popup ne prouve pas Kerberos.

---

## 6. Validation Kerberos

> Cette partie doit être prouvée explicitement.

- SPN attendu :
- objet AD portant le SPN :
- doublon détecté : oui / non
- ticket HTTP côté client : oui / non
- preuve serveur complémentaire :
- NTLM observé : oui / non

### Conclusion protocolaire

```text
Kerberos prouvé : OUI / NON
```

Justification :

---

## 7. Classic ASP

- `index.asp` exécuté :
- utilisateur AD affiché :
- type d'authentification affiché :
- serveur affiché :
- heure serveur affichée :
- erreur éventuelle :

### Conclusion

Expliquez pourquoi `AUTH_TYPE` ne suffit pas à prouver Kerberos.

---

## 8. Troubleshooting

Incident traité :

- symptôme :
- hypothèses :
- preuves collectées :
- cause :
- correction :
- validation :

---

## Conclusion générale

Répondez en quelques lignes :

1. Qu'est-ce qui prouve TLS ?
2. Qu'est-ce qui prouve le SSO ?
3. Qu'est-ce qui prouve Kerberos ?
4. Quel rôle joue le gMSA ?
5. Quelle dépendance vous paraît la plus critique dans cette architecture ?
