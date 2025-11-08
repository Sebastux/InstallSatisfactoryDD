# Variables principales
VENV_DIR := .venv
REQ_FILE := requirements.txt
ANSIBLE_PLAYBOOK := site.yml
PYTHON := python3

# Environnement : staging (par défaut) ou production
ENV ?= staging

# Options additionnelles
TAGS ?=
EXTRA_VARS ?=

# Couleurs
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

# Règle par défaut
.DEFAULT_GOAL := help

## Détection et installation des paquets système nécessaires
system-deps:
	@echo "$(YELLOW)🔍 Détection du système et installation des dépendances système...$(NC)"
	@if [ -f /etc/debian_version ]; then \
		echo "$(YELLOW)→ Distribution Debian/Ubuntu détectée.$(NC)"; \
		sudo apt-get update -y && \
		sudo apt-get install -y python3-venv python3-dev libffi-dev libssl-dev build-essential; \
	elif [ -f /etc/redhat-release ]; then \
		echo "$(YELLOW)→ Distribution Red Hat/CentOS/Fedora détectée.$(NC)"; \
		sudo dnf install -y python3-venv python3-devel libffi-devel openssl-devel gcc || \
		sudo yum install -y python3-venv python3-devel libffi-devel openssl-devel gcc; \
	else \
		echo "$(RED)⚠️  Distribution non reconnue. Installe manuellement les dépendances nécessaires.$(NC)"; \
	fi
	@echo "$(GREEN)✅ Paquets système installés ou déjà présents.$(NC)"

## Création du venv et installation des dépendances Python
$(VENV_DIR)/bin/activate: $(REQ_FILE)
	@echo "$(YELLOW)Création de l'environnement virtuel...$(NC)"
	@test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR)
	@echo "$(YELLOW)Installation des dépendances Python...$(NC)"
	@$(VENV_DIR)/bin/pip install --upgrade pip
	@$(VENV_DIR)/bin/pip install -r $(REQ_FILE)
	@touch $(VENV_DIR)/bin/activate
	@echo "$(GREEN)✅ Environnement virtuel prêt !$(NC)"

## Installer ou mettre à jour les dépendances
install: system-deps $(VENV_DIR)/bin/activate

## Vérifie que le répertoire d'environnement existe
check-env:
	@if [ ! -d "$(ENV)" ]; then \
		echo "$(RED)❌ Le répertoire d'environnement '$(ENV)' n'existe pas.$(NC)"; \
		exit 1; \
	fi

## Exécution du playbook
run: install check-env
	@CMD="$(VENV_DIR)/bin/ansible-playbook $(ANSIBLE_PLAYBOOK) -i $(ENV)"; \
	if [ -n "$(TAGS)" ]; then \
		CMD="$$CMD --tags $(TAGS)"; \
		echo "$(YELLOW)→ Exécution avec tags : $(TAGS)$(NC)"; \
	fi; \
	if [ -n "$(EXTRA_VARS)" ]; then \
		CMD="$$CMD -e '$(EXTRA_VARS)'"; \
		echo "$(YELLOW)→ Variables supplémentaires : $(EXTRA_VARS)$(NC)"; \
	fi; \
	echo "$(YELLOW)Lancement du playbook sur l'environnement $(ENV)...$(NC)"; \
	$$CMD; \
	echo "$(GREEN)✅ Playbook exécuté avec succès sur $(ENV).$(NC)"

## Nettoyage
clean:
	@echo "$(YELLOW)Suppression de l'environnement virtuel...$(NC)"
	@rm -rf $(VENV_DIR)
	@echo "$(GREEN)✅ Environnement supprimé.$(NC)"

## Réinstallation complète
reinstall: clean install

## Aide
help:
	@echo "Commandes disponibles :"
	@echo "  make system-deps                   - Installe les paquets système nécessaires"
	@echo "  make install                       - Crée le venv et installe les dépendances Python"
	@echo "  make run [ENV=staging]             - Exécute le playbook sur staging (par défaut)"
	@echo "  make run ENV=production            - Exécute le playbook sur la production"
	@echo "  make run TAGS=install              - Exécute uniquement certains tags"
	@echo "  make run EXTRA_VARS=\"key=value\"    - Passe des variables supplémentaires"
	@echo "  make clean                         - Supprime le venv"
	@echo "  make reinstall                     - Réinstalle tout proprement"
