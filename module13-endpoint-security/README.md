# Module 13 — Endpoint Security

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | GPO / politiques de domaine | 2 | 4 Go | 60 Go |
| CLT01 | endpoint principal de test | 2 | 4–6 Go | 64 Go |
| SRV01 | poste de validation réseau / tests croisés | 2 | 4 Go | 60 Go |

## Prérequis et dépendances

**Réutilise :**
- M03 : GPO, scope, filtrage et rollback ;
- M06 : moindre privilège ;
- M12 : protection des données au repos sur CLT01.

**Produit pour la suite :**
- baseline Defender / ASR / Firewall ;
- contrôle applicatif AppLocker ;
- journalisation PowerShell ;
- preuves Audit / Enforcement ;
- événements réutilisables dans M15.

M14 réutilise notamment le Firewall et le moindre privilège. M15 réutilise directement les événements Defender, AppLocker et PowerShell générés ici.

---

## Contexte NovaCorp

NovaCorp veut réduire la surface d'attaque de ses endpoints sans transformer la politique de sécurité en source de panne.

Votre mission consiste à construire une **baseline endpoint défendable**, puis à prouver son efficacité par des tests contrôlés.

Le principe du module est :

```text
OBSERVER
→ AUDITER
→ MESURER L'IMPACT
→ AJUSTER
→ BLOQUER SI JUSTIFIÉ
→ CONSERVER LES PREUVES
```

Une protection n'est pas considérée comme validée simplement parce qu'elle apparaît dans une GPO ou une commande.

## Aide technique et debug

Le README reste volontairement orienté **mission, analyse et validation**.

Si vous bloquez sur l'implémentation ou le diagnostic, utilisez :

- [Toolbox Debug & Exemples d'implémentation](toolbox-debug-implementation.md)

Cette toolbox contient notamment :

- commandes de baseline Defender / Firewall / AppLocker / PowerShell ;
- exemple ASR WMI/PsExec en Audit puis Block ;
- exemple AppLocker AuditOnly puis Enforcement ;
- événements 1121 / 1122 / 8003 / 8004 / 4104 ;
- mini-lab Firewall TCP ;
- exemples de rollback ;
- tableau de diagnostic rapide.

Utilisez-la comme **support de dépannage**, pas comme procédure à recopier sans comprendre.

---

## Objectifs

À la fin du module, vous devez savoir distinguer et articuler :

- **Microsoft Defender Antivirus** : détection / protection antimalware ;
- **Attack Surface Reduction (ASR)** : réduction de comportements d'attaque ;
- **Windows Firewall** : contrôle des flux réseau ;
- **AppLocker** : contrôle de l'exécution applicative ;
- **PowerShell Logging** : visibilité et investigation ;
- **Audit** vs **Enforcement** ;
- sécurité vs compatibilité opérationnelle.

---

# Partie A — État initial

Avant toute modification, inventoriez CLT01.

Documentez au minimum :

- état de Microsoft Defender ;
- protection temps réel ;
- protections comportementales ;
- règles ASR présentes ;
- profils Windows Firewall ;
- profil réseau réellement actif ;
- politique AppLocker effective ;
- service Application Identity ;
- état du journal PowerShell Operational ;
- GPO ou stratégies locales susceptibles de piloter ces paramètres.

Conservez une preuve **M13 BEFORE**.

---

# Partie B — Defender et ASR

## Mission

Choisissez une règle ASR testable sans dépendance logicielle externe.

Le scénario de référence du lab est la protection contre les **créations de processus provenant de PsExec ou WMI**.

Vous devez démontrer successivement :

```text
ASR non configuré
→ règle en Audit
→ comportement WMI contrôlé
→ comportement autorisé mais journalisé
→ analyse de l'événement
→ passage en Block
→ même comportement refusé
→ nouvelle preuve
```

## Contraintes

- Le test doit être bénin.
- Aucun malware réel ne doit être utilisé.
- La même action doit être utilisée avant et après enforcement.
- Vous devez prouver le résultat par le comportement **et** par les journaux.

## Preuves attendues

Vous devez notamment être capables d'identifier :

- la règle ASR sélectionnée ;
- son mode ;
- un événement **1122** en Audit ;
- un événement **1121** en Block ;
- la différence observable entre les deux modes.

### Question d'analyse

Pourquoi le mode Audit est-il particulièrement important avant un déploiement large d'une règle ASR ?

---

# Partie C — Windows Firewall

## Mission

Construisez un test réseau contrôlé permettant de démontrer qu'un **service TCP réellement en écoute** :

1. est joignable lorsque le flux est autorisé ;
2. reste actif localement ;
3. devient injoignable lorsque le Firewall bloque le même flux ;
4. redevient propre après rollback.

Le scénario de référence utilise un service TCP temporaire sur CLT01 et une validation depuis SRV01.

## Contraintes

- Ne validez pas uniquement avec ICMP / ping.
- Vérifiez que le port est réellement en écoute avant le test.
- Ciblez le profil Firewall correspondant au profil réseau actif.
- Ne perturbez pas IIS, AD FS, PKI ou les services des modules précédents.
- Supprimez les règles temporaires à la fin.

## Preuves attendues

```text
Service TCP en LISTEN
+
flux autorisé
→ connexion réussie

Service toujours en LISTEN
+
flux bloqué
→ connexion échouée

Rollback
→ règles de test supprimées
```

### Question d'analyse

Pourquoi prouver que le service écoute encore au moment du blocage permet-il d'isoler le Firewall comme cause du refus ?

---

# Partie D — AppLocker

## Mission

Construisez une politique AppLocker minimale sur la collection **EXE**, puis validez-la selon la démarche :

```text
Politique
→ AuditOnly
→ observation
→ identification des applications hors politique
→ analyse d'impact
→ Enforcement contrôlé
→ rollback
```

Le scénario de référence doit comporter :

- au moins une application correspondant à une règle Allow ;
- un exécutable bénin copié dans un emplacement non couvert par la règle ;
- une phase Audit ;
- une phase Enforcement.

## Points d'attention

Une application non autorisée par la politique n'est pas nécessairement malveillante.

Pendant l'audit, vous pouvez découvrir que des logiciels légitimes seraient eux aussi bloqués. C'est précisément l'objectif de cette phase.

## Preuves attendues

Vous devez identifier :

- la collection de règles utilisée ;
- son mode d'enforcement ;
- un événement **8003** : application autorisée pendant l'audit mais qui aurait été bloquée ;
- un événement **8004** : exécution réellement empêchée ;
- au moins un exemple d'application légitime révélant un risque de faux positif ou de rupture métier.

### Question d'analyse

Quelle différence fondamentale existe entre AppLocker et un antivirus ?

---

# Partie E — PowerShell Security

## Mission

Activez ou validez les mécanismes de journalisation nécessaires pour disposer d'une trace exploitable des activités PowerShell.

Le lab s'intéresse particulièrement à :

- **Script Block Logging** ;
- **Module Logging** ;
- **PowerShell Transcription**.

Générez ensuite une activité PowerShell bénigne et identifiable.

Vous devez pouvoir démontrer :

```text
commande / script
→ journal PowerShell
→ Event ID 4104
→ contenu retrouvé

session PowerShell
→ transcription
→ fichier texte
→ commandes et résultats retrouvés
```

## Attention aux données sensibles

La journalisation PowerShell améliore fortement la capacité d'investigation, mais peut également conserver des informations sensibles.

Ne placez aucun vrai mot de passe, token ou secret dans vos tests.

## Lien avec M15

```text
PowerShell
→ Event Log
→ collecte
→ Wazuh
→ détection / corrélation / investigation
```

### Question d'analyse

Pourquoi **journaliser**, **détecter** et **bloquer** sont-ils trois fonctions différentes ?

---

# Partie F — Validation croisée

Chaque protection doit disposer d'un test reproductible.

Complétez pour chaque scénario :

| Élément | À documenter |
|---|---|
| Protection | règle / technologie |
| Risque visé | comportement réduit |
| État initial | before |
| Mode | Audit / Block / Enforce |
| Test | action contrôlée réalisée |
| Résultat attendu | autorisé / bloqué / audité |
| Résultat réel | observation |
| Événement | journal + Event ID |
| Impact métier | risque identifié |
| Rollback | méthode prévue et validée |

---

## Répartition suggérée

- A : Defender / ASR
- B : Firewall
- C : AppLocker
- D : PowerShell Security
- E : audit croisé / preuves / documentation

Un étudiant ne valide pas seul sa propre configuration.

---

## Questions de réflexion

1. Pourquoi une protection bloquante doit-elle souvent commencer en mode Audit ?
2. Quelle différence entre antivirus, ASR et application control ?
3. Pourquoi le Firewall reste-t-il utile sur un LAN interne ?
4. Une règle qui bloque un test signifie-t-elle forcément que la configuration est bonne ?
5. Que vous apprend la découverte d'Edge ou d'une autre application légitime dans les événements AppLocker d'audit ?
6. Pourquoi la télémétrie PowerShell reste-t-elle utile même si aucune commande n'est bloquée ?
7. Quels risques crée une journalisation trop riche ?
8. Quelle preuve permet de distinguer une panne applicative d'un blocage Firewall ?

---

## Livrables

- `endpoint-policy.md`
- `security-tests.md`
- preuves pertinentes dans `evidence/`

Ne versionnez aucun secret.

---

## Validation

```text
[ ] état initial documenté
[ ] Defender vérifié
[ ] ASR testé en Audit
[ ] ASR testé en Block
[ ] événements 1122 / 1121 interprétés
[ ] service TCP réellement testé via Windows Firewall
[ ] flux autorisé puis bloqué démontré
[ ] politique AppLocker testée en AuditOnly
[ ] politique AppLocker testée en Enforcement
[ ] événements 8003 / 8004 interprétés
[ ] PowerShell Script Block Logging validé
[ ] Event ID 4104 retrouvé et interprété
[ ] transcription PowerShell validée
[ ] rollback connu
[ ] impacts potentiels discutés
```

---

## Restitution

Répondez à :

> **Comment durcir fortement un poste Windows sans transformer la politique de sécurité en cause de panne ?**

Votre réponse doit s'appuyer sur au moins une preuve issue d'ASR, du Firewall, d'AppLocker et de PowerShell Logging.

---

## Checkpoint M13

Snapshot conseillé après validation complète :

```text
M13-ENDPOINT-SECURITY-OK
```
