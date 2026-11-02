# Tests sécurité endpoint

Pour chaque test, conservez une preuve exploitable et expliquez ce qu'elle démontre.

## Matrice de validation

| Contrôle | Scénario | Résultat attendu | Résultat observé | Preuve / Event ID |
|---|---|---|---|---|
| Defender | protection active | protection opérationnelle | | |
| ASR Audit | création de processus via WMI / PsExec | autorisée mais auditée | | 1122 |
| ASR Block | même scénario | création refusée | | 1121 |
| Firewall Allow | service TCP en écoute + règle Allow | connexion réussie | | |
| Firewall Block | même service toujours actif + règle Block | connexion échouée | | |
| AppLocker Audit | EXE hors règle Allow | exécution autorisée mais auditée | | 8003 |
| AppLocker Enforce | même EXE | exécution empêchée | | 8004 |
| PowerShell | activité identifiable | contenu présent dans Operational | | 4104 |
| Transcription | même session PowerShell | commandes / résultats retrouvés | | fichier transcript |

---

## Test ASR

### Comportement testé

Décrivez l'action WMI / PsExec utilisée sans recopier uniquement la commande.

### Audit

- résultat fonctionnel :
- événement :
- interprétation :

### Block

- résultat fonctionnel :
- événement :
- interprétation :

### Conclusion

Que prouve la comparaison Audit / Block ?

---

## Test Windows Firewall

### Avant blocage

- service :
- port :
- état local du port :
- machine cliente du test :
- résultat :

### Après blocage

- service toujours actif ?
- port toujours en écoute ?
- résultat distant :
- conclusion :

### Rollback

- règles temporaires supprimées :
- service temporaire arrêté :
- vérification finale :

---

## Test AppLocker

### AuditOnly

- application testée :
- emplacement :
- résultat :
- Event ID 8003 :
- autres applications légitimes observées dans l'audit :

### Enforcement

- même application :
- résultat :
- Event ID 8004 :

### Analyse

Expliquez pourquoi une application apparaissant dans un événement AppLocker n'est pas nécessairement malveillante.

---

## Test PowerShell

### Script Block Logging

- activité générée :
- Event ID 4104 :
- élément identifiable retrouvé :

### Transcription

- fichier généré :
- commandes retrouvées :
- sorties retrouvées :

### Analyse

Expliquez la différence entre :

```text
Logging
Detection
Blocking
```

et indiquez comment M15 pourra exploiter ces traces.

---

## Conclusion

Répondez à :

1. Quelles protections ont réellement empêché une action ?
2. Quelles protections ont uniquement produit de la visibilité ?
3. Où avez-vous identifié un risque de faux positif ou de rupture métier ?
4. Quelle protection nécessiterait le plus de travail avant un déploiement en production ?
