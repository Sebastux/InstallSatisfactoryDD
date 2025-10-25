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
apt-get install -y aptitude python3 python3-pip python3-apt python3-venv

# Création du venv
echo "**** Création d'un environement virtuel pour python. ****"
python3 -m venv venv
source ./venv/bin/activate

# Installation des packages ansible
echo ""
echo "**** Installation des packages python. ****"
pip install --upgrade -r requirements.txt

# Execution du playbook d'installation
echo ""
echo "**** Exécution du playbook. ****"
ansible-playbook ./site.yml -i ./production/ --flush-cache

# Désactivation du venv
deactivate