# Architecture NovaCorp

Ce document servira de référence pour décrire l'évolution de l'architecture du laboratoire.

## Convention de nommage

Les groupes doivent utiliser les noms suivants :

- `DC01`
- `SRV01`
- `CLT01`
- `CLT02` si nécessaire
- `PKI01`
- `SEC01`
- `VULN01`

Les noms pourront évoluer uniquement si cela est justifié et validé avec le formateur.

## Réseaux

Chaque groupe doit être isolé logiquement des autres groupes.

Exemple :

| Groupe | Réseau recommandé |
|---|---|
| Groupe 1 | `10.10.10.0/24` |
| Groupe 2 | `10.10.20.0/24` |
| Groupe 3 | `10.10.30.0/24` |

Le plan d'adressage exact est défini par chaque groupe puis documenté.
