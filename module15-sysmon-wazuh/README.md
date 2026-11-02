# Module 15 — Sysmon + Wazuh

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | source Windows / Sysmon | 2 | 4 Go | 60 Go |
| SRV01 | source Windows / Sysmon | 2 | 4 Go | 60 Go |
| CLT01 | source Windows / Sysmon | 2 | 4–6 Go | 64 Go |
| SEC01 | Wazuh all-in-one de lab | 4 | 8 Go minimum | 100 Go |

Pour Wazuh, 8 Go de RAM est un minimum de lab. Si l'hôte le permet, 12 Go améliorent nettement le confort.


## Contexte NovaCorp

NovaCorp dispose désormais de plusieurs mécanismes de sécurité, mais manque encore de visibilité centralisée.

Un contrôle de sécurité qui produit des événements inutilisés apporte peu de capacité de détection.

Votre mission est de construire une chaîne complète :

```text
ACTIVITÉ
   ↓
ÉVÉNEMENT
   ↓
TÉLÉMÉTRIE
   ↓
COLLECTE
   ↓
CENTRALISATION
   ↓
ANALYSE
   ↓
DÉTECTION
```

Le but n'est pas simplement “d'installer Wazuh”.

---

## Objectifs

À la fin du module, vous devez être capables de :

- expliquer ce que Sysmon ajoute aux journaux Windows natifs ;
- distinguer télémétrie, collecte, corrélation, détection et alerte ;
- centraliser plusieurs sources Windows ;
- générer des événements légitimes et les suivre de bout en bout ;
- interpréter les champs utiles ;
- construire une petite démarche de threat hunting défensive ;
- identifier les limites d'un SIEM/XDR sans connaissance du contexte.

---

# Partie A — Concevoir la télémétrie

Avant installation, déterminez quelles informations vous souhaitez observer.

Étudiez au minimum :

- processus ;
- parent process ;
- ligne de commande ;
- utilisateur ;
- connexion réseau ;
- authentification ;
- PowerShell ;
- gestion utilisateurs/groupes.

Expliquez quelles sources Windows fournissent ces informations et ce que Sysmon apporte en complément.

---

# Partie B — Sysmon

Installez et configurez Sysmon sur les machines choisies.

Ne cherchez pas à tout journaliser.

Votre configuration doit permettre de retrouver au minimum :

- création de processus ;
- parent process ;
- command line ;
- utilisateur ;
- connexion réseau pertinente.

Expliquez également le risque d'une configuration trop bavarde :

```text
plus de logs
≠
meilleure détection
```

---

# Partie C — Wazuh

Déployez ou utilisez Wazuh puis connectez les agents.

Collectez au minimum :

```text
Security
System
PowerShell
Sysmon
```

Pour chaque source, vérifiez :

```text
événement local présent
→ agent actif
→ événement transmis
→ événement visible côté Wazuh
```

Ne concluez pas qu'un événement “n'existe pas” avant d'avoir vérifié chaque étape de la chaîne.

---

# Partie D — Générer des événements contrôlés

Générez uniquement des activités légitimes de laboratoire.

Au minimum :

- ouverture ou commande PowerShell ;
- création d'un processus ;
- échec de connexion ;
- création ou modification d'un utilisateur ;
- changement d'appartenance à un groupe ;
- connexion réseau.

Aucun malware n'est nécessaire.

Pour chaque scénario :

1. annoncez l'événement attendu ;
2. générez l'activité ;
3. vérifiez le journal local ;
4. recherchez l'événement dans Wazuh ;
5. expliquez les champs utiles ;
6. concluez sur la capacité de détection.

---

# Partie E — Hunt

Choisissez au moins trois événements différents et construisez un mini hunt.

Votre analyse doit répondre à :

```text
Qui ?
Quoi ?
Quand ?
Où ?
Avec quel processus parent ?
Avec quelle commande ?
Vers quelle destination ?
Est-ce normal dans le contexte NovaCorp ?
```

Ne vous contentez pas d'une capture d'écran.

---

# Partie F — Télémétrie vs détection

Pour chaque scénario, classez le résultat :

- **télémétrie disponible** ;
- **événement centralisé** ;
- **règle de détection existante** ;
- **alerte générée** ;
- **analyse humaine nécessaire**.

Expliquez pourquoi ces niveaux ne sont pas équivalents.

---

## Répartition suggérée

- A : Sysmon sur DC01
- B : Sysmon sur SRV01
- C : Sysmon sur CLT01
- D : Wazuh / collecte
- E : détection / requêtes / documentation

Dans un groupe de 4, fusionnez collecte et analyse.

---

## Questions de réflexion

1. Pourquoi Sysmon n'est-il pas un SIEM ?
2. Pourquoi Wazuh n'est-il pas “la sécurité” à lui seul ?
3. Quelle différence entre événement, détection et alerte ?
4. Pourquoi une collecte exhaustive peut-elle diminuer la qualité opérationnelle ?
5. Comment prouver qu'un événement a été perdu entre la machine et le SIEM ?
6. Pourquoi le contexte métier reste-t-il nécessaire ?
7. Quels événements de vos modules précédents seraient intéressants à surveiller ?

---

## Livrables

- `telemetry-design.md`
- `event-hunt.md`
- preuves dans `evidence/`

### `telemetry-design.md`

Doit contenir :

- sources collectées ;
- rôle de Sysmon ;
- flux de collecte ;
- agents ;
- risques de bruit ;
- critères de validation.

### `event-hunt.md`

Pour au moins trois événements :

| Champ | Contenu |
|---|---|
| Activité générée | |
| Source | |
| Event ID / type | |
| Machine | |
| Utilisateur | |
| Processus / parent | |
| Command line | |
| Réseau éventuel | |
| Interprétation | |
| Détection / simple télémétrie | |

---

## Validation

```text
[ ] Sysmon produit les événements attendus
[ ] logs natifs et Sysmon distingués
[ ] agents Wazuh connectés
[ ] Security / System / PowerShell / Sysmon collectés
[ ] au moins trois scénarios suivis de bout en bout
[ ] événements interprétés
[ ] différence télémétrie / détection expliquée
[ ] preuves conservées
```

---

## Restitution

Répondez à :

> **Si Wazuh reçoit un événement mais ne génère aucune alerte, la chaîne de sécurité a-t-elle échoué ? Expliquez.**

---

## Checkpoint M15

```text
Événement généré
→ retrouvé localement
→ centralisé
→ interprété
```

Le module n'est pas validé par la seule présence d'un dashboard.
