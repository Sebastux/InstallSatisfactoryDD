# InstallSatisfactoryDD

Installation du serveur de jeu Satisfactory sur un serveur Ubuntu server 24.04.

## Table des matières

- [Pré-requis](#pré-requis)
- [Variables](#variables)
- [Utilisation](#utilisation)
- [Execution](#execution)
- [Ressources](#ressources)
- [Licence](#licence)
- [Auteurs](#auteurs)

## Pré-requis

Liste des conditions nécessaires pour utiliser ce rôle :  
(par exemple : version d’Ansible, système, accès, dépendances...)

- Ansible version : 
- Systèmes supportés : Ubuntu server 24.04.
- Droits nécessaires : root

## Variables

Liste et description des variables configurables du rôle.

| Variable      | Description                             | Valeur par défaut |
|---------------|-----------------------------------------|-------------------|
| user_passwd | Mot de passe du compte satisfactorydd   | `P@ssW0rd#2025`   |
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

Se connecter sur le serveur et passer en root.
Installer git.
Lancer le script et attendre la fin de l'exécution.

```bash
sudo -i
apt-get -y install git-all
git clone https://github.com/Sebastux/InstallSatisfactoryDD.git
git checkout develop
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
