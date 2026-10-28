# Module 14 — Administration distante sécurisée

## Contexte
NovaCorp veut administrer ses serveurs à distance sans exposer inutilement RDP ou WinRM.

## Mission
Déployez une méthode d'administration distante sécurisée combinant :
- RDP ;
- WinRM / PowerShell Remoting ;
- Windows Admin Center.

## Répartition suggérée
- A : RDP / NLA / droits
- B : WinRM / PowerShell Remoting
- C : certificats / WinRM HTTPS
- D : Windows Admin Center
- E : audit / firewall / documentation

## Travail demandé
### RDP
- vérifier NLA ;
- limiter les comptes autorisés ;
- vérifier les règles firewall ;
- identifier les événements de connexion.

### WinRM
- établir une session distante ;
- comprendre la différence 5985 / 5986 ;
- expliquer le rôle de Kerberos ;
- éviter une configuration TrustedHosts trop permissive.

### Windows Admin Center
- installer / utiliser WAC ;
- ajouter au moins deux machines ;
- réaliser une opération d'administration ;
- identifier les risques liés à la centralisation de l'administration.

## Livrables
- `remote-admin-design.md`
- `access-matrix.md`
- preuves dans `evidence/`

## Checkpoint CP14
- RDP sécurisé ;
- PowerShell Remoting fonctionnel ;
- WAC opérationnel ;
- droits d'accès documentés.
