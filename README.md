# InstallSatisfactoryDD

Installation du serveur de jeu Satisfactory sur un serveur Ubuntu server 24.04.

## Table des matières

- [Pré-requis](#pré-requis)
- [Variables](#variables)
- [Utilisation](#utilisation)
- [Exemples](#exemples)
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

| Variable      | Description            | Valeur par défaut         |
|---------------|-----------------------|---------------------------|
| `exemple_var` | Explication…          | `valeur`                  |

## Utilisation

Comment inclure ce rôle dans un playbook.

```yaml
- hosts: your_hosts
  become: yes
  roles:
    - role: nom_du_role
      vars:
        exemple_var: "valeur"
```

## Exemples

Des cas d’usage typiques, liens vers des fichiers d’exemple ou playbooks.

## Ressources

[Documentation officielle du wiki d'installation du serveur](https://satisfactory.wiki.gg/wiki/Dedicated_servers)
[Documentation officielle d'installation de SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)

## Licence

The unlicense

## Auteur

- Sébastux
