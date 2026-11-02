# Endpoint Policy NovaCorp

> Ce document décrit la politique retenue. Il ne doit pas devenir une simple copie de commandes.

## 1. État initial

| Contrôle | État observé | Preuve |
|---|---|---|
| Defender Antivirus | | |
| Real-Time Protection | | |
| ASR | | |
| Firewall Domain | | |
| Firewall Private | | |
| Firewall Public | | |
| Profil réseau actif | | |
| AppLocker | | |
| PowerShell Logging | | |

---

## 2. Defender / ASR

### Risque visé

Décrivez le comportement que la règle sélectionnée cherche à réduire.

### Règle retenue

- Nom :
- Identifiant :
- Scope :
- Mode initial :
- Mode final :
- Impact potentiel :

### Stratégie de déploiement

Expliquez pourquoi vous passez ou non par :

```text
Audit
→ observation
→ ajustement
→ Block
```

### Rollback

Décrivez comment revenir à l'état précédent.

---

## 3. Windows Firewall

### Profil concerné

- Profil réseau actif :
- Justification :

### Flux nécessaire

- Source :
- Destination :
- Protocole :
- Port :
- Service associé :

### Politique

Expliquez :

- ce qui doit rester autorisé ;
- ce qui doit être refusé ;
- pourquoi la règle n'est pas plus large que nécessaire.

### Rollback

---

## 4. AppLocker

### Collection utilisée

- EXE / Script / MSI / autre :
- Mode initial :
- Mode final :

### Modèle d'autorisation

Décrivez les emplacements, éditeurs ou fichiers que votre politique autorise.

### Risque de compatibilité

Listez au moins une application légitime susceptible d'être impactée.

### Passage Audit → Enforcement

Expliquez les critères qui vous permettraient de décider qu'une politique est prête à être appliquée en blocage.

### Rollback

---

## 5. PowerShell Logging

### Mécanismes retenus

| Mécanisme | Activé ? | Objectif |
|---|---|---|
| Script Block Logging | | |
| Module Logging | | |
| Transcription | | |

### Destination des traces

- Journal Windows :
- Répertoire de transcription :
- Futur collecteur / SIEM :

### Risques

Expliquez pourquoi ces traces peuvent contenir des données sensibles et comment elles devraient être protégées.

---

## 6. Exceptions

Documentez uniquement les exceptions réellement nécessaires.

| Exception | Justification | Risque induit | Compensating control |
|---|---|---|---|
| | | | |

---

## 7. Risques / impacts métier

Quels usages légitimes pourraient être cassés par :

- ASR ;
- Windows Firewall ;
- AppLocker ;
- journalisation PowerShell.

---

## 8. Conclusion

Répondez en quelques lignes :

> Pourquoi cette baseline est-elle défendable plutôt que simplement "plus restrictive" ?
