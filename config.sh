#!/bin/bash
# -*- coding: utf-8 -*-

#==============================================================================
# Titre            : config.sh
# Description      : Prépare l'éxécution du role ansible.
# Auteur           : Sébastux
# Date             : 08/11/2025
# Modification     : 09/11/2025
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

# Affichage de divers informations
echo "***************************************************************"
cat ./ficscommun/satis
echo "Pour installer ansible, utilisez la commande make install."
echo "Pour installer le serveur satisfactory, utilisez la commande make run."
echo "Pour avoir plus de commande, utilisez la commande make."
echo ""
echo "ATTENTION :"
echo "Avant de lancer le serveur, pensez à éditer le fichier production/inventory pour configurer"
echo "l'adresse IP à mettre en liste blanche pour fail2ban ainsi que le mot de passe du compte applicatif."
echo "Consultez le README.md pour plus d'informations."
echo ""
echo "Bon jeux."