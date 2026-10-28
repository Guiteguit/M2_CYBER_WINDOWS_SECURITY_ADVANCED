# Module 01 — Fondations du laboratoire Windows

## Durée

1h30

## Contexte

NovaCorp prépare la reconstruction de son infrastructure Windows.

Votre équipe dispose de plusieurs machines Windows fraîchement installées. Avant d'introduire Active Directory, vous devez construire un socle système et réseau cohérent, documenté et suffisamment propre pour servir de base aux 15 modules suivants.

À ce stade :

- aucun domaine Active Directory n'existe ;
- aucun rôle serveur métier n'est encore installé ;
- le réseau doit être conçu et validé ;
- chaque machine doit être inspectée avant son intégration au futur domaine.

---

# Objectifs

À la fin du module, votre groupe doit être capable de :

- concevoir un plan d'adressage ;
- préparer correctement une machine Windows ;
- vérifier sa configuration réseau ;
- inspecter les protections système principales ;
- identifier les comptes locaux et privilèges ;
- tester la connectivité entre machines ;
- réaliser un audit croisé ;
- produire un inventaire simple ;
- créer un checkpoint propre pour la suite du cours.

---

# Architecture minimale

## Groupe de 4

Votre groupe doit disposer au minimum de :

```text
DC01   — Windows Server
SRV01  — Windows Server
CLT01  — Windows 11
```

Le quatrième membre assure une responsabilité transverse sur le réseau, l'architecture et l'audit, puis intervient dans la validation technique des autres machines.

## Groupe de 5

Votre groupe doit disposer au minimum de :

```text
DC01   — Windows Server
SRV01  — Windows Server
CLT01  — Windows 11
CLT02  — Windows 11
```

Le cinquième membre prend la responsabilité architecture / réseau / audit puis participe aux validations croisées.

---

# Contraintes

- Chaque groupe utilise un réseau différent.
- Les serveurs doivent disposer d'une adresse IPv4 statique.
- Les machines doivent pouvoir communiquer entre elles.
- Le firewall Windows ne doit pas être désactivé pour résoudre un problème.
- Aucun étudiant ne valide sa propre machine.
- Toute modification de sécurité doit être justifiée.
- Aucun secret ne doit être stocké dans Git.

---

# Partie 1 — Concevoir le réseau

Avant toute configuration, définissez votre architecture.

Votre groupe doit renseigner :

| Machine | Rôle | Adresse IP | Masque | Gateway | DNS | Responsable |
|---|---|---|---|---|---|---|
| DC01 | Futur contrôleur de domaine | | | | | |
| SRV01 | Futur serveur membre | | | | | |
| CLT01 | Poste utilisateur | | | | | |
| CLT02 | Poste utilisateur si présent | | | | | |

Questions à traiter :

1. Pourquoi les serveurs doivent-ils avoir une IP stable ?
2. Quel DNS utilisez-vous aujourd'hui ?
3. Ce choix restera-t-il valide lorsque Active Directory sera installé ?
4. Quelle adresse sera utilisée comme gateway ?
5. Comment garantissez-vous que votre réseau ne chevauche pas celui d'un autre groupe ?

---

# Partie 2 — Préparer les machines

Chaque étudiant prend en charge une machine ou une responsabilité transverse.

Chaque machine doit être préparée et contrôlée.

Au minimum, vérifiez :

- nom de machine ;
- adresse IPv4 ;
- masque ;
- gateway ;
- DNS ;
- date et heure ;
- timezone ;
- état du firewall ;
- comptes locaux ;
- membres du groupe Administrators ;
- état de RDP ;
- état de WinRM ;
- services actifs ;
- version de Windows.

Vous pouvez utiliser l'interface graphique et PowerShell.

Le choix des commandes vous appartient.

---

# Partie 3 — Première inspection sécurité

Sur votre machine, identifiez :

## Comptes

- Quels comptes locaux existent ?
- Quels comptes possèdent des privilèges d'administration ?
- Ces comptes sont-ils tous nécessaires ?

## Firewall

- Quels profils Windows Firewall sont actifs ?
- Quel profil est actuellement appliqué ?
- Est-il cohérent avec votre situation ?

## Administration distante

- RDP est-il actif ?
- WinRM est-il actif ?
- Ont-ils besoin de l'être aujourd'hui ?

## Services

Identifiez :

- trois services importants ;
- un service dont vous ne connaissez pas immédiatement le rôle.

Recherchez son rôle avant de proposer une quelconque désactivation.

---

# Partie 4 — Audit croisé

Une fois la configuration terminée, échangez les responsabilités.

**Personne ne contrôle sa propre machine.**

L'auditeur doit vérifier :

```text
[ ] Hostname conforme
[ ] IPv4 correcte
[ ] Gateway cohérente
[ ] DNS cohérent
[ ] Heure correcte
[ ] Firewall actif
[ ] Comptes administrateurs identifiés
[ ] RDP connu et justifié
[ ] WinRM connu et justifié
[ ] Connectivité réseau validée
```

Pour chaque machine auditée, ajoutez au moins **une recommandation ou observation de sécurité**.

Le responsable initial corrige ensuite les écarts confirmés.

---

# Partie 5 — Valider la connectivité

Le groupe doit démontrer que les machines peuvent communiquer entre elles.

Au minimum :

```text
DC01  ↔ SRV01
DC01  ↔ CLT01
SRV01 ↔ CLT01
```

Ajoutez CLT02 si elle existe.

Attention :

> Un échec de `ping` ne démontre pas nécessairement qu'une machine ou qu'un service est inaccessible.

Votre groupe doit être capable de tester :

- une connectivité IP ;
- une résolution DNS ;
- un port TCP lorsque cela est pertinent.

---

# Partie 6 — Incident à identifier

Une anomalie a été introduite dans l'environnement de votre groupe.

Vous devez :

1. identifier le symptôme ;
2. formuler au moins deux hypothèses ;
3. réaliser des tests permettant de les confirmer ou de les écarter ;
4. identifier la cause ;
5. corriger le problème ;
6. documenter votre raisonnement.

Ne modifiez pas plusieurs paramètres simultanément sans savoir lequel corrige réellement le problème.

---

# Bonus — Inventaire PowerShell

Si votre groupe termine en avance, créez :

```text
scripts/inventory.ps1
```

Le script doit générer un inventaire contenant au minimum :

```text
Hostname
OS
IPv4
Gateway
DNS
Firewall
RDP
WinRM
```

Bonus supplémentaire : exportez les résultats en CSV.

---

# Livrables

Votre groupe doit produire :

```text
module01-foundations/
├── architecture.md
├── inventory.csv
├── security-review.md
└── scripts/
    └── inventory.ps1    # bonus
```

Des modèles sont fournis dans ce dossier.

---

# Checkpoint M01

Avant de poursuivre vers Active Directory, vous devez pouvoir démontrer :

```text
[ ] Toutes les machines démarrent correctement
[ ] Les hostnames sont conformes
[ ] Le plan IP est cohérent
[ ] La gateway est cohérente
[ ] Le DNS est documenté
[ ] Le firewall est actif
[ ] La date et l'heure sont correctes
[ ] Les comptes locaux privilégiés sont identifiés
[ ] Les machines communiquent entre elles
[ ] Chaque machine a été auditée par un autre étudiant
[ ] Les écarts détectés ont été corrigés ou justifiés
[ ] L'architecture est documentée
```

Lorsque le formateur valide le checkpoint, créez un snapshot :

```text
M01-FOUNDATION-OK
```

Ce snapshot est votre point de retour pour le module suivant.

---

# Questions de restitution

Votre groupe doit être capable de répondre oralement à ces questions :

1. Pourquoi DNS deviendra-t-il critique dans le module Active Directory ?
2. Pourquoi désactiver le firewall est-il une mauvaise méthode de diagnostic ?
3. Pourquoi un ping KO ne signifie-t-il pas nécessairement qu'un serveur est inaccessible ?
4. Pourquoi faut-il identifier les administrateurs locaux avant d'intégrer une machine au domaine ?
5. Quelle différence faites-vous entre construire, tester et auditer ?
