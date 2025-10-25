# InstallSatisfactoryDD

Installation du serveur de jeu Satisfactory sur un serveur Ubuntu server 24.04.

## Table des matières

- [Pré-requis](#Pré-requis)
- [Variables](#variables)
- [Utilisation](#utilisation)
- [Execution](#execution)
- [Ressources](#ressources)
- [Licence](#licence)
- [Auteur](#auteurs)

## Pré-requis

### logiciel
Liste des conditions nécessaires pour utiliser ce rôle :  
- Version ansible      : 12.1.0
- Version ansible-core : 2.19.3
- Systèmes supportés   : Ubuntu server 24.04.
- Droits nécessaires   : sudo

### materiel
- Un processeur Intel (i5-3570 ou supérieur) ou AMD (Ryzen 5 3600 ou supérieur) compatible x86-64, relativement récent.<br/>
Le serveur utilise plusieurs cœurs, mais privilégie fortement les performances élevées d'un seul cœur.<br/>
Tout processeur avec un indice de thread unique de 2000 ou supérieur devrait fonctionner.<br/>
Il n'y a pas de prise en charge 32 bits (x86) ni ARM.<br/>
S'il s'agit d'une machine virtuelle (VM) (un VPS en est certainement un), un processeur kvm64 ne fonctionnera pas !<br/>

- Mémoire : 8 Go. 16 Go de RAM peuvent être recommandés pour des sauvegardes plus importantes ou pour héberger plus de 4 joueurs.<br/>
- Stockage (Windows) : 12,4 Go de fichiers serveur. L’installation complète du jeu n’est pas requise.<br/>
- Stockage (Linux) : 8 Go. L’installation de base des distributions de serveur standard peut atteindre 2 Go, plus 2 Go de fichiers serveur de jeu.<br/>
- Système d’exploitation : Windows 10, 11, Server 2016, Server 2019 ou Server 2022, ou une distribution Linux comme Debian ou Ubuntu.<br/>
- Connexion Internet : Connexion Internet haut débit. L’hébergement à domicile nécessite la possibilité de configurer une redirection de port ou un VPN.<br/>

## Variables

Liste et description des variables configurables du rôle.

| Variable      | Description                             | Valeur par défaut |
|---------------|-----------------------------------------|-------------------|
| compte_satisfactory    | Nom du compte utilisateur satisfactory  | `satisfactorydd`  |
| satisfactory_passwd | Mot de passe du compte utilisateur satisfactory    | `P@ssW0rd#2025`   |
| fail2ban_ssh_whitelist | Liste d'IP à ne pas bannir par fail2ban | `192.168.0.10`    |

## Utilisation

Comment inclure ce rôle dans un playbook.

```yaml
- hosts: your_hosts
  become: yes
  roles:
    - role: satisfactorydd
```

## Execution

Se connecter sur le serveur et passer en root avec la commande sudo -i.
Installer le méta package git-all.
Lancer le script et attendre la fin de l'exécution.

```bash
sudo -i
apt-get update
apt-get -y install git-all
git clone https://github.com/Sebastux/InstallSatisfactoryDD.git
cd InstallSatisfactoryDD
./install.sh
```

## Ressources

[Documentation officielle du wiki d'installation du serveur](https://satisfactory.wiki.gg/wiki/Dedicated_servers)

[Documentation officielle d'installation de SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)

## Licence

The unlicense

## Auteur

- Sébastux
