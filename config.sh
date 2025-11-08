#!/bin/bash
# -*- coding: utf-8 -*-

#==============================================================================
# Titre            : config.sh
# Description      : Prépare l'éxécution du role ansible.
# Auteur           : Sébastux
# Date             : 08/11/2025
# Modification     : 08/11/2025
# Version          : 1.00
# Utilisation      : config.sh
# Notes            : Script permettant l'installation de satisfactory dedicated server.
#==============================================================================

# Nettoyage de l'écran
clear

# Installation de divers package
echo "**** Installation des packages pour l'exécution d'Ansible. ****"
apt-get update
apt-get install -y aptitude python3 python3-pip python3-apt python3-venv build-essential

echo "***************************************************************"
echo "Pour installer ansible, utilisez la commande make install."
echo "Pour installer le serveur satisfactory, utilisez la commande make run."
echo "Pour avoir plus de commande, utilisez la commande make."
echo "Bon jeux."