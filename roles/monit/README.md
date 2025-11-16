![alt text](../../ficscommun/images/monit.png "Logo monit")


# **Monit** :

Ce playbook permet d'installer un ensemble de packages pour les PC et les Raspberry Pi.
Un ensemble de tache commune aux deux sont exécuté, puis les taches propres au type de
machine est exécuté. Il est aussi possible d'installer le logiciel de monitoring monit.


## **Prérequis** :
Connexion ssh à la machine par mot de passe ou par clé.

## **Variables** :

cible : Cette variable doit être passé en extra vars (Voir catégorie lancement)
        afin de choisir la machine cible. Le nom utilisé doit correspondre à un
        groupe utilisé dans le fichier inventaire.

## **Dépendances** :

Centos 7 Installé et accessible en ssh.

## **Fonctionnalités** :

tronccommun : Installe et configure le serveur

monit: Installe et configure monit et ajout des profils
permettant de superviser divers fonctionnalités de la machine.

## **Lancement** :

La commande doit avoir la forme suivante :
- Pour lancer tous les rôles, la commande doit avoir cette forme :
  ```yml
  ansible-playbook site.yml -i production -e "cible='Groupe_inventaire'"
  ```
- Pour lancer l'installation du tronc commun, utilisez la commande suivante :
  ```yml
  ansible-playbook playbooks/tronccommun.yml -i production -e "cible='Groupe_inventaire'"
  ```
- Pour lancer l'installation de monit, utilisez la commande suivante :
  ```yml
  ansible-playbook playbooks/monit.yml -i production -e "cible='Groupe_inventaire'"
  ```

Il est possible d'ajouter "--flush-cache" à la fin de la commande afin de
forcer ansible à recharger les facts.

## **Auteur** :
Sebastux.

## **Readme des différents rôles** :

* [Tronccommun](roles/tronccommun/README.md)
* [Monit](roles/monit/Readme.md)

### **Versions** :

![alt text](https://img.shields.io/badge/version-v3.0.0-brightgreen.svg "Logo Version") (27/04/2020) :

  - Transformation du rôle en playbook.
  - Mise à jour du rôle tronccommun.
  - Création du rôle monit.
