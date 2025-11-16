![alt text](../../docs/images/monit.png "Logo monit")


# **Monit** :

Ce rôle permet l'installation et la configuration du logiciel de monitoring [monit](https://mmonit.com/monit/ "Site officiel monit").
Il permet la configuration d'une connexion en ssl (non pris en charge pour le moment).
Il installe aussi un autre logiciel de monitoring nommé [monitorix](https://www.monitorix.org "Site officiel monitorix").

## **Prérequis** :
Connexion ssh à la machine par mot de passe ou par clé et installation du tronccommun.

## **Variables** :

:hourglass_flowing_sand:

## **Dépendances** :

FEDORA 32 Installé et accessible en ssh.

## **Fonctionnalités** :

- Installation et configuration de monit. Création d'un compte administrateur ainsi
  que d'un compte utilisateur qui ne possède que des droits d'observation.
- Installation et configuration de [monitorix](https://www.monitorix.org "Site officiel monitorix").
  Ce logiciel permet de monitorer la machine à l'aide de plusieurs tableau de bord.
  Il est accessible à partir de http://IP-de-la-machine:8080/monitorix ou
  http://FQDN-de-la-machine:8080/monitorix. Pour l'instant ni l'authentification
  ni le https ne sont encore mise en place.
- Par défaut, monit surveille le processus ssh ainsi que le fichier de configuration,
  les processus avec top, l'occupation du disque dur, un test smart est réalisé si
  ma machine n'est pas un raspberry, monitorix et son fichier de configuration,
  le fichier de configuration de monit, Chrony et son fichier de configuration,
  rsyslog ainsi que les sondes de la machine, l'occupation de la RAM.
- Une configuration de logrotate pour monit est aussi ajouté.

## **Auteur** :
Sebastux.

### **Versions** :

![alt text](https://img.shields.io/badge/version-v3.0.0-brightgreen.svg "Logo Version") (27/04/2020) :

  - Création du rôle.
