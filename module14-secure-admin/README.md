# Module 14 — Administration distante sécurisée

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | identité / Kerberos / délégation | 2 | 4 Go | 60 Go |
| SRV01 | cible d'administration | 2 | 4–6 Go | 60 Go |
| CLT01 | poste d'administration | 2 | 4–6 Go | 64 Go |
| PKI01 | certificats si WinRM HTTPS est testé | 2 | 4 Go | 60 Go |


## Prérequis et dépendances

**Réutilise :**
- M06 : séparation des comptes privilégiés et délégation ;
- M09 : certificats issus de `PKI01` si WinRM HTTPS est utilisé ;
- M10 : Kerberos et SPN ;
- M13 : Firewall, journalisation et logique de durcissement.

**Produit pour la suite :**
- flux d'administration distante documentés ;
- événements RDP / WinRM / PowerShell Remoting ;
- matrice d'accès et refus explicites.

M15 pourra collecter et analyser ces événements d'administration.

## Contexte NovaCorp

Les administrateurs NovaCorp doivent gérer les serveurs sans se connecter physiquement sur chaque machine.

Cependant, exposer RDP ou WinRM sans contrôle augmente la surface d'attaque.

Votre mission est de construire un modèle où l'administration distante est :

- limitée ;
- authentifiée ;
- filtrée ;
- journalisée ;
- adaptée au besoin.

---

## Objectifs

Vous devez comparer et sécuriser :

- RDP ;
- WinRM ;
- PowerShell Remoting ;
- Windows Admin Center ;
- authentification Kerberos ;
- WinRM HTTP / HTTPS ;
- NLA ;
- filtrage Firewall ;
- délégation des droits ;
- traçabilité.

---

# Partie A — Définir le besoin

Avant de configurer quoi que ce soit, construisez une matrice :

```text
Qui ?
→ administre quoi ?
→ depuis quelle machine ?
→ avec quel protocole ?
→ avec quel niveau de privilège ?
```

Une méthode d'administration ne doit pas être ouverte “pour tous les admins vers tous les serveurs”.

---

# Partie B — RDP

Analysez puis sécurisez RDP.

Votre travail doit couvrir :

- NLA ;
- groupes autorisés ;
- Firewall ;
- scope réseau ;
- journalisation ;
- événements de connexion ;
- risque lié à l'utilisation d'un compte très privilégié.

Démontrez :

```text
Utilisateur autorisé
→ connexion possible

Utilisateur non autorisé
→ connexion refusée
```

---

# Partie C — WinRM / PowerShell Remoting

Mettez en place une session distante fonctionnelle.

Expliquez :

- le rôle de WinRM ;
- la différence entre 5985 et 5986 ;
- pourquoi HTTP ne signifie pas automatiquement “mot de passe en clair” en domaine ;
- le rôle de Kerberos ;
- les risques de `TrustedHosts=*` ;
- quand HTTPS devient pertinent.

Votre architecture doit privilégier une authentification de domaine propre avant les contournements.

---

# Partie D — Windows Admin Center

Utilisez WAC comme point d'administration centralisé.

Au minimum :

- ajouter plusieurs machines ;
- réaliser une opération d'administration ;
- identifier l'identité utilisée ;
- observer les droits nécessaires ;
- analyser les risques liés à la centralisation.

Posez-vous notamment la question :

> Que se passe-t-il si le poste ou la passerelle d'administration est compromis ?

---

# Partie E — Moindre privilège

Analysez si toutes les opérations testées nécessitent réellement Domain Admin.

Proposez une séparation entre :

- accès serveur ;
- administration AD ;
- administration poste ;
- opérations ponctuelles.

Le bonus consiste à expliquer comment **JEA** pourrait réduire davantage les commandes disponibles sans donner une session administrative complète.

---

# Partie F — Journalisation

Pour au moins une méthode d'administration distante, démontrez :

```text
connexion
→ événement local
→ identité identifiable
→ action retraçable
```

L'objectif est de pouvoir répondre à :

> Qui s'est connecté, où, quand, et par quelle méthode ?

---

## Répartition suggérée

- A : RDP / NLA / droits
- B : WinRM / PowerShell Remoting
- C : certificats / WinRM HTTPS
- D : Windows Admin Center
- E : audit / firewall / documentation

---

## Questions de réflexion

1. RDP et PowerShell Remoting répondent-ils au même besoin ?
2. Pourquoi limiter les sources réseau autorisées ?
3. Dans un domaine, quel rôle Kerberos joue-t-il dans PowerShell Remoting ?
4. Pourquoi `TrustedHosts=*` est-il une mauvaise solution par défaut ?
5. WinRM HTTPS est-il toujours obligatoire ?
6. Pourquoi un poste d'administration devient-il un actif critique ?
7. Que pourrait apporter JEA ?

---

## Livrables

- `remote-admin-design.md`
- `access-matrix.md`
- preuves dans `evidence/`

### `remote-admin-design.md`

Doit contenir :

- méthodes retenues ;
- protocoles / ports ;
- authentification ;
- Firewall ;
- logging ;
- risques ;
- choix d'architecture.

### `access-matrix.md`

Doit documenter :

| Identité | Source | Cible | Méthode | Autorisé ? | Justification |
|---|---|---|---|---|---|

Incluez au moins un accès refusé.

---

## Validation

```text
[ ] besoin d'administration cartographié
[ ] RDP sécurisé et limité
[ ] PowerShell Remoting fonctionnel
[ ] TrustedHosts non utilisé comme contournement général
[ ] WAC opérationnel
[ ] droits documentés
[ ] accès refusé démontré
[ ] événement de connexion retrouvé
[ ] risques de centralisation analysés
```

---

## Restitution

Répondez à :

> **Pourquoi “ça marche à distance” n'est-il pas un critère suffisant pour considérer une méthode d'administration comme sécurisée ?**

---

## Checkpoint M14

```text
Accès limité
+
authentification maîtrisée
+
administration fonctionnelle
+
traçabilité démontrée
```
