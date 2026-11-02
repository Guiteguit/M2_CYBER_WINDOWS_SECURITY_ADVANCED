# M04 — Toolbox File Server, SMB & ACL

> Objectif : comprendre les permissions réellement obtenues et expliquer pourquoi un accès fonctionne ou échoue.

## Installer le rôle et préparer les dossiers

~~~powershell
Install-WindowsFeature FS-FileServer
Get-WindowsFeature FS-FileServer
New-Item -ItemType Directory -Path C:\Shares\Finance -Force
New-Item -ItemType Directory -Path C:\Shares\Direction -Force
New-Item -ItemType Directory -Path C:\Shares\IT -Force
New-Item -ItemType Directory -Path C:\Shares\Commun -Force
~~~

## Partage SMB

~~~powershell
New-SmbShare -Name "Finance" -Path "C:\Shares\Finance" -FullAccess "NOVACORP\Domain Admins" -ChangeAccess "NOVACORP\DL_Finance_RW"
Get-SmbShare
Get-SmbShareAccess -Name Finance
~~~

## ACL NTFS

~~~powershell
(Get-Acl C:\Shares\Finance).Access | Select IdentityReference,FileSystemRights,AccessControlType,IsInherited
~~~

~~~cmd
icacls C:\Shares\Finance
icacls C:\Shares\Finance /inheritance:r
icacls C:\Shares\Finance /grant "NOVACORP\DL_Finance_RW:(OI)(CI)M"
icacls C:\Shares\Finance /grant "NOVACORP\Domain Admins:(OI)(CI)F"
~~~

Repères : F = Full, M = Modify, RX = Read/Execute, OI = Object inherit, CI = Container inherit.

## Vérifier le token utilisateur

~~~cmd
whoami
whoami /groups
~~~

~~~powershell
Get-ADPrincipalGroupMembership alice.finance | Select Name,GroupScope
~~~

## Tester le partage

~~~powershell
Test-NetConnection SRV01 -Port 445
~~~

~~~cmd
dir \\SRV01\Finance
net use
~~~

Pour tester un autre compte :

~~~cmd
net use * /delete /y
runas /user:NOVACORP\alice.finance cmd
~~~

## Comprendre SMB + NTFS

~~~text
Share permissions
+
NTFS permissions
=
accès réellement obtenu
~~~

## Debug accès refusé

~~~text
1. SRV01 se résout ?
2. TCP/445 répond ?
3. Le partage existe ?
4. Share permissions ?
5. ACL NTFS ?
6. Token utilisateur contient le bon groupe ?
7. Session SMB déjà ouverte avec d'autres credentials ?
~~~

~~~powershell
Get-SmbSession
Get-SmbOpenFile
Get-SmbShareAccess -Name Finance
~~~

## Sauvegarder les ACL

~~~cmd
icacls C:\Shares /save C:\Temp\shares-acl.txt /t
icacls C:\ /restore C:\Temp\shares-acl.txt
~~~

## Liens Microsoft

- SMB overview : https://learn.microsoft.com/windows-server/storage/file-server/file-server-smb-overview
- New-SmbShare : https://learn.microsoft.com/powershell/module/smbshare/new-smbshare
- Get-SmbShareAccess : https://learn.microsoft.com/powershell/module/smbshare/get-smbshareaccess
- icacls : https://learn.microsoft.com/windows-server/administration/windows-commands/icacls
