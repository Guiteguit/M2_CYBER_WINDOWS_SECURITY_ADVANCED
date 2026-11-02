# Module 03 — GPO & Hardening Windows

## Ressources système recommandées

| VM | Rôle dans ce TP | vCPU | RAM | Disque |
|---|---|---:|---:|---:|
| DC01 | GPMC / AD DS | 2 | 4 Go | 60 Go |
| SRV01 | cible GPO serveur | 2 | 4 Go | 60 Go |
| CLT01 | cible GPO poste | 2 | 4–6 Go | 64 Go |


## Contexte

L'Active Directory de NovaCorp fonctionne. Le RSSI demande maintenant une première politique de sécurité homogène pour les postes et serveurs.

Votre mission n'est pas d'activer toutes les options disponibles : vous devez choisir, appliquer et justifier des mesures adaptées.

## Objectifs

- comprendre la portée des GPO ;
- distinguer Computer Configuration et User Configuration ;
- comprendre héritage, priorité, filtrage et exceptions ;
- construire une baseline de sécurité ;
- vérifier l'application effective des politiques ;
- mesurer les impacts d'un durcissement.

## Mission

Définissez et appliquez une première baseline NovaCorp.

Elle doit couvrir au minimum plusieurs catégories parmi :

- mots de passe et verrouillage ;
- verrouillage de session ;
- audit ;
- firewall ;
- protocoles ou fonctions héritées ;
- restrictions utilisateurs ;
- paramètres de sécurité locaux ;
- sécurité des postes clients ;
- sécurité des serveurs.

## Contraintes

- Ne désactivez pas un service ou protocole sans comprendre son impact.
- Une même GPO ne doit pas devenir un "fourre-tout" incontrôlable.
- Les choix doivent être documentés.
- Au moins une stratégie doit être testée sur un poste client.
- Au moins une stratégie doit être testée sur un serveur membre.

## Répartition possible

- A : baseline comptes / verrouillage
- B : baseline postes clients
- C : baseline serveurs
- D : vérification RSOP / gpresult
- E : audit des impacts / documentation

## Travail demandé

1. Définir votre stratégie de GPO.
2. Créer les GPO nécessaires.
3. Les lier aux bonnes OU.
4. Vérifier leur application.
5. Identifier une configuration qui pourrait casser un usage métier.
6. Proposer une méthode d'exception ou de rollback.

## Questions

1. Pourquoi éviter de modifier directement la Default Domain Policy pour tout ?
2. Dans quel cas utiliser un Security Filtering ?
3. Quelle différence entre "Configured" et "Effectively Applied" ?
4. Comment vérifier la politique réellement reçue par une machine ?
5. Pourquoi une baseline CIS ou Microsoft ne doit-elle pas être appliquée aveuglément ?

## Livrables

- `baseline.md`
- `gpo-map.md`
- `validation.md`

## Checkpoint M03

- [ ] plusieurs GPO existent ;
- [ ] elles sont liées aux bonnes OU ;
- [ ] l'application est démontrée ;
- [ ] les choix sont justifiés ;
- [ ] un impact potentiel est identifié ;
- [ ] audit croisé effectué.

Snapshot : `M03-GPO-OK`.
