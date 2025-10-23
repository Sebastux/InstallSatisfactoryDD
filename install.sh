#!/bin/bash
# -*- coding: utf-8 -*-

#==============================================================================
# Titre            : install.sh
# Description      : Prépare et lance l'éxécution du role ansible.
# Auteur           : Sébastux
# Date             : 22/10/2025
# Modification     : 22/10/2025
# Version          : 1.00
# Utilisation      : install.sh
# Notes            : Script permettant l'installation d'ansible dedicated server.
#==============================================================================

# Nettoyage de l'écran
clear

# Installation de divers package
echo "**** Installation des packages pour l'exécution d'Ansible. ****"
apt-get update
apt-get install aptitude python3 python3-pip python3-apt

# Création du venv
echo "**** Création d'un environement virtuel pour python. ****"
python3 venv -m venv
source ./venv/bin/activate

# Installation des packages ansible
pip install --upgrade -r requirements.txt

# Execution du playbook d'installation
ansible-playbook ./site.yml -i ./staging/ --flush-cache

# Désactivation du venv
deactivate