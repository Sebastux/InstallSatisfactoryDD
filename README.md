# InstallSatisfactoryDD

Installation du serveur de jeu Satisfactory sur un serveur Ubuntu server 24.04.

## Table des matières

- [Pré-requis](#Pré-requis)
- [Variables](#variables)
- [Execution](#Exécution)
- [Ressources](#ressources)
- [Licence](#licence)
- [Auteur](#auteurs)

## Pré-requis

### Logiciel
Liste des conditions nécessaires pour utiliser ce rôle :  
- Version ansible : 12.1.0 ou supérieur
- Version ansible-core : 2.19.3 ou supérieur
- Systèmes supportés : Ubuntu server 24.04.
- Droits nécessaires : sudo

### Matériel[^2]

- Un processeur Intel (i5-3570 ou supérieur) ou AMD (Ryzen 5 3600 ou supérieur) compatible x86-64, relativement récent.<br/>
Le serveur utilise plusieurs cœurs, mais privilégie fortement les performances élevées d'un seul cœur.<br/>
Tout processeur avec un indice de thread unique de 2000 ou supérieur devrait fonctionner.<br/>
Il n'y a pas de prise en charge 32 bits (x86) ni ARM.<br/>
S'il s'agit d'une machine virtuelle (VM) (un VPS en est certainement un), un processeur kvm64 ne fonctionnera pas !<br/>

- Mémoire : 8 Go. 16 Go de RAM peuvent être recommandés pour des sauvegardes plus importantes ou pour héberger plus de 4 joueurs.<br/>
- Stockage (Linux) : 8 Go. L’installation de base des distributions de serveur standard peut atteindre 2 Go, plus 2 Go de fichiers serveur de jeu.<br/>
- Système d’exploitation : Ubuntu server 24.04.<br/>
- Connexion Internet : Connexion Internet haut débit. L’hébergement à domicile nécessite la possibilité de configurer une redirection de port ou un VPN.<br/>

## Variables

Liste et description des variables configurables du rôle.

| Variable               | Description                                                | Valeur par défaut                  |
| ---------------------- | ---------------------------------------------------------- | ---------------------------------- |
| compte_satisfactory    | Nom du compte utilisateur satisfactory.                    | satisfactorydd                     |
| satisfactory_passwd    | Mot de passe du compte utilisateur satisfactory.           | P@ssW0rd#2025                      |
| satisfactory_salt      | Chaine de caractères permettant le salage de mot de passe. | SeBa5TuX59                         |
| fail2ban_ssh_whitelist | Liste d'IP à ne pas bannir par fail2ban.                   | 1.1.1.1                            |
| hostname_svr           | Nom d'hôte de la machine qui sera appliqué par le rôle.    | Team-Ginette.unsatifactoryds.local |
| location_svr           | Localisation du serveur.                                   | Lille - Haut de France             |

## Exécution

Se connecter sur le serveur et passer en root avec la commande sudo -i.
Installer le méta package git-all.
Lancer le script config.sh pour installer les packages nécessaires.

```bash
sudo apt-get update
sudo apt-get -y install git-all
git clone https://github.com/Sebastux/InstallSatisfactoryDD.git
cd InstallSatisfactoryDD
sudo ./config.sh
make install
sudo make run
```

## Fail2ban

Fail2ban est un service analysant en temps réel les journaux d’événement de divers services (SSH, Apache, FTP, entre autres) à la recherche de comportements malveillants et permet d'exécuter une ou plusieurs actions lorsqu'un événement malveillant est détecté.
Ces comportements malveillants sont définis par des filtres. Typiquement, un nombre élevé et répété de tentatives infructueuses de connexion provenant d'une même machine[^1].

Fail2ban est installé afin de bloquer toute attaque de type brut force. Ce type d'attaque consiste à tester des couples identifiant / mot de passe sur le service SSH.
Si une attaque de ce type est détectée, Fail2ban va bannir l'adresse IP de l'attaquant et donc empêcher toute tentative de connexion à la machine.
Pour éviter d'être considéré comme un attaquant en cas d'erreur de connexion, vous devez modifier la valeur de la variable fail2ban_ssh_whitelist située dans le fichier production/inventory.
Si cette valeur n'est pas modifiée, cela fera échouer l'installation.

Lorsque le serveur est hébergé chez vous (il est branché sur votre box internet), vous devez mettre l'adresse d'une ou de plusieurs machines qui se connectent en SSH sur le serveur Satisfactory.
Si vous ajoutez plusieurs adresses, elles doivent être séparées par un espace. Il est aussi possible d'ajouter plusieurs adresses en utilisant la forme 192.168.0.0/224.

Lorsque vous utilisez un serveur distant comme un VPS par exemple, vous devez utiliser l'adresse IP de votre box internet, peu importe le nombre de PC qui se connecte en SSH depuis chez vous.
Pour connaitre votre adresse IP, vous devez consulter votre opérateur internet ou vous rendre sur un site comme [celui-ci](https://www.mon-ip.com/). Récupérez l'adresse **IP V4** et ajoutez là dans le fichier, vous pouvez ajouter l'adresse IP d'autre personne si vous le souhaitez.

## SSH

Le rôle de durcissement configure le serveur SSH pour interdire la connexion en utilisant un mot de passe. Il crée une paire de clés dans le répertoire /root/cles_ssh.
Cette paire de clés permet de se connecter au serveur sans avoir besoin de mot de passe.
Vous devez installer la clé publique sur votre compte utilisateur, afin de pouvoir vous connecter sur le serveur.
Voici la procédure à suivre pour installer la clé sur votre compte utilisateur.

Commencez par copier le répertoire sur votre compte utilisateur avec la commande suivante :
```bash
sudo cp -r /root/cles_ssh .
```

ATTENTION : vérifiez bien qu'après le répertoire cles_ssh il y ait bien un espace suivi d'un point. C'est un raccourci permettant de copier le répertoire cles_ssh dans le répertoire dans lequel vous vous trouvez.

Récupérez la propriété de répertoire grâce à la commande suivante :

```bash
sudo chown -R <nom de votre compte>: ./cles_ssh/
```

Exemple :

```bash
sudo chown -R toto: ./cles_ssh/
```

Si vous regardez à l'intérieur du répertoire, vous devriez voir 2 fichiers. Le premier fichier n'a pas d'extension et le second possède l'extension ".pub".
Ce fichier contient la clé publique et doit être installé sur le compte de connexion grâce à la commande suivante :

```bash
cat ./cles_ssh/<nom du fichier.pub> >> ~/.ssh/authorized_keys && echo "Clé copié."
```
Téléchargez ensuite le répertoire sur être PC de jeu et installez la clé privée (le fichier sans extension) sur celui-ci. Vous avez pour cela la possibilité d’utiliser le client natif disponible sous PowerShell, pour cela rendez-vous [ici](https://www.it-connect.fr/comment-utiliser-le-client-ssh-natif-de-windows-10/). Vous pouvez aussi utiliser le client [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html), celui-ci prend en charge les clés SSH Linux contrairement au client MobaXterm. Il est nécessaire de [convertir](https://robodk.com/doc/fr/Robots-KEBA-Utilisation-fichier-PPK-SFTP.html) la clé SSH au format PuTTY

## Ressources

[Documentation officielle du wiki d'installation du serveur](https://satisfactory.wiki.gg/wiki/Dedicated_servers)

[Documentation officielle d'installation de SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)

## Licence

The unlicense

## Auteur
- Sébastux

## Versions

![alt text](https://img.shields.io/badge/version-v1.0.0-brightgreen.svg "Logo Version") (25/10/2024) :

  - Création du rôle.
  - Installation et configuration de la version 1.1 de satisfactory sur Ubuntu 24.04.

[^1]: Source [Wikipédia](https://fr.wikipedia.org/wiki/Fail2ban)

[^2]: La configuration matérielle est fournie par coffee stain studios sur le site officiel du jeu.
