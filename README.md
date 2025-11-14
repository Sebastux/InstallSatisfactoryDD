# InstallSatisfactoryDD

Installation du serveur de jeu Satisfactory sur un serveur Ubuntu server 24.04.

## Table des matières

- [Pré-requis](#Pré-requis)
- [Variables](#variables)
- [Exécution](#Exécution)
- [Fail2ban](#Fail2ban)
- [SSH](#SSH)
- [Durcissement](#Durcissement)
- [Installation du serveur Satisfactory](#Installation du serveur Satisfactory)
- [Ressources](#ressources)
- [Licence](#licence)
- [Auteur](#auteurs)
- [Versions](#Versions)

## Pré-requis

### Logiciel
Liste des conditions nécessaires pour utiliser ce rôle :  
- Version ansible : 12.1.0 ou supérieur
- Version ansible-core : 2.19.3 ou supérieur
- Systèmes supportés : Ubuntu server 24.04.
- Droits nécessaires : sudo

### Matériel[^1]

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

Se connecter sur le serveur avec un compte utilisateur ayant les droits sudo.
Pour vérifier, vous pouvez utiliser la commande sudo -l
Installer le méta package git pour pouvoir cloner le dépôt.
Lancer le script config.sh pour installer les packages nécessaires à l'utilisation.
Suivez les instructions en fin d'exécution du script.

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
Ces comportements malveillants sont définis par des filtres. Typiquement, un nombre élevé et répété de tentatives infructueuses de connexion provenant d'une même machine[^2].

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
sudo cp -r /root/cles_ssh $HOME
```

==INFORMATION== : "$HOME" est une variable d'environnement contenant le chemin du répertoire utilisateur.

Récupérez la propriété de répertoire grâce à la commande suivante :

```bash
sudo chown -R <nom de votre compte>: $HOME/cles_ssh/
```

Exemple :

```bash
sudo chown -R toto: $HOME/cles_ssh/
```

Si vous regardez à l'intérieur du répertoire, vous devriez voir 2 fichiers. Le premier fichier n'a pas d'extension et le second possède l'extension ".pub".
Ce fichier contient la clé publique et doit être installé sur le compte de connexion grâce à la commande suivante :

```bash
cat $HOME/cles_ssh/<nom du fichier.pub> >> ~/.ssh/authorized_keys && echo "Clé publique ajoutée."
```

Exemple :

```bash
cat $HOME/cles_ssh/satisfactory-Team-Ginette.pub >> ~/.ssh/authorized_keys && echo "Clé publique ajoutée."
```

Téléchargez ensuite le répertoire sur être PC de jeu et installez la clé privée (le fichier sans extension) sur celui-ci. Vous avez pour cela la possibilité d’utiliser le client natif disponible sous PowerShell, pour cela rendez-vous [ici](https://www.it-connect.fr/comment-utiliser-le-client-ssh-natif-de-windows-10/). Vous pouvez aussi utiliser le client [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html), celui-ci prend en charge les clés SSH Linux contrairement au client MobaXterm. Il est nécessaire de [convertir](https://robodk.com/doc/fr/Robots-KEBA-Utilisation-fichier-PPK-SFTP.html) la clé SSH au format PuTTY

## Durcissement

Pour un système d'exploitation, le durcissement consiste en une modification de plusieurs paramètres afin d'augmenter la sécurité de celui-ci. L'installation du serveur Satisfactory va exécuter plusieurs instructions permettant de durcir la sécurité d'Ubuntu serveur. Plusieurs fichiers de configurations vont être modifiés par ansible, ceux-ci verront leur première modifiée par un commentaire indiquant que celui-ci a été modifié par ansible. Si vous avez un doute sur le contenu de ce fichier (modification par une autre personne ou par un autre logiciel), rendez-vous dans le répertoire du script d'installation et utilisez la commande suivante :

```bash
sudo make run TAGS=durcissement
```

Cette commande va exécuter **l'intégralité** de la procédure de durcissement. Si vous souhaitez utiliser une partie spécifique du durcissement, voici la liste des mots clé à utiliser à la place de durcissement :


| Mot clé      | Effets                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------- |
| durcissement | Durcissement de l'intégralité du système, nécessite un redémarrage de la machine.                 |
| fail2ban     | Installe et configure le logiciel fail2ban.                                                       |
| firewalld    | Installe et configure le pare-feu firewalld.                                                      |
| hostname     | Modifie le nom d’hôte de la machine et réalise la résolution du nom.                              |
| kernel       | Modifie certains paramètres du noyau Linux, nécessite un redémarrage de la machine.               |
| maj          | Lance une mise à jour complète du système, nécessite un redémarrage de la machine.                |
| modules      | Désactive certains "drivers" non utilisés par le système, nécessite un redémarrage de la machine. |
| passwd       | Modifie la politique de complexité des mots de passe de compte utilisateur.                       |
| permissions  | Réserve la permission de certains logiciels critique au compte administrateur (root)              |
| ssh          | Configure le serveur SSH afin de désactiver les connexions par mot de passe                       |
| temps        | Installe et configure le serveur de temps chrony afin de garder l'heure du serveur Ubuntu à jour. |
| unattended   | Installe et configure le service de mise à jour automatique d'Ubuntu.                             |

*INFORMATION* : Le durcissement obtient un score de 78 sur 100 sur le logiciel Lynis dans sa version 3.1.6-100. Aucun plugin n'a été utilisé.
## Installation du serveur Satisfactory

La procédure d'installation installe steamCMD et le serveur Satisfactory en utilisant un compte anonyme. Il n'est pas nécessaire d'utiliser votre compte Steam pour installer le serveur.
Le compte anonyme permet l'installation complète du jeu pour une durée indéterminée (sauf changement de politique de valve ou de coffee stain studios).
Un fichier propre à Linux permet de transformer le logiciel en service. Cela a pour avantage de lancer le serveur Satisfactory en arrière-plan lors du démarrage de la machine physique ou virtuelle.
Le service redémarre automatiquement en cas de crash du serveur Satisfactory. Les mises à jour du serveur Satisfactory se font lors du redémarrage d'Ubuntu grâce à la commande suivante :

```bash
sudo reboot
```

La meilleure solution est de simplement redémarrer le service grâce à la commande suivante :

```bash
sudo systemctl restart satisfactory
```

Pour connaitre l'état du service Satisfactory, utilisez la commande suivante :

```bash
sudo systemctl status satisfactory
```

*INFORMATION* : Suite à un redémarrage du service, soyez patient, car le redémarrage peut être plus ou moins long en fonction de votre configuration matérielle. Le serveur effectue plusieurs tâches qui nécessitent parfois un redémarrage automatique du service.

Pour installer le serveur Satisfactory, l'installeur crée un compte système afin de stocker les fichiers du jeu. Ce compte n'est pas un compte utilisateur standard, cela veut dire qu'il n'est pas possible
de s'y connecter depuis l'extérieur grâce à une connexion SSH. Il est par contre possible de s'y connecter depuis un compte utilisateur standard. Pour cela, récupérer l'identifiant et le mot de passe configuré dans le fichier inventaire (dans les variables "compte_satisfactory" et "satisfactory_passwd") puis entrez la commande suivante :

```bash
su - <identifiant du compte>
```

Entre su et l'identifiant du compte, n’oubliez pas le signe moins (disponible sur le pavé numérique ou sur la touche 6 au-dessus de la lettre T).
Pour quitter le compte, vous pouvez soit utiliser la commande exit, soit la combinaison des touches CTRL+d.
## Ressources

[Documentation officielle du wiki d'installation du serveur](https://satisfactory.wiki.gg/wiki/Dedicated_servers)
[Documentation officielle d'installation de SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
[Site officiel du développeur de Lynis](https://cisofy.com/lynis/)
[Tuto IT-connect.fr](https://www.it-connect.fr/scan-de-votre-systeme-unix-avec-lynis/)
[Tuto stephane-robert.info](https://blog.stephane-robert.info/docs/securiser/durcissement/lynis/)
## Licence

[The unlicense](https://milvus.io/ai-quick-reference/how-does-the-unlicense-work-for-public-domain-software)

## Auteur
[Sébastux](https://github.com/Sebastux)

## Versions

![alt text](https://img.shields.io/badge/version-V1.1.0-brightgreen.svg "Logo Version") (14/11/2025) :
  -  Modularisation du code.
  - Ajout d'un rôle du durcissement du système.
  - Ajout d'un rôle commun permettant l'installation d'outils et de configuration divers.
  - Ajout d'un rôle spécifique pour l'installation du serveur Satisfactory.
  - Ajout de plusieurs tags permettant une granularité plus fine.
  - Création d'un compte système pour l'installation du serveur Satisfactory.
  - La connexion SSH nécessite obligatoirement une clé SSH.
  - Une clé SSH est générée lors de la configuration du serveur SSH.
  - L'installation ne se fait plus grâce au script bash mais grâce à un Makefile. La commande make nécessite les droits sudo.
  - Mise à jour du fichier README.
  - Amélioration de la configuration du service unuttended-upgrades. Les mises à jour et le reboot du serveur sont automatiques.
  - Installation du noyau hwe afin d'avoir une meilleure compatibilité avec le matériel récent.

![alt text](https://img.shields.io/badge/version-V1.0.0-brightgreen.svg "Logo Version") (25/10/2025) :
  - Création du rôle.
  - Installation et configuration de la version 1.1 de satisfactory sur Ubuntu 24.04.


[^1]: La configuration matérielle est fournie par coffee stain studios sur le site officiel du jeu.
[^2]: Source [Wikipédia](https://fr.wikipedia.org/wiki/Fail2ban)
