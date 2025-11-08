# Variables principales
VENV_DIR := venv
REQ_FILE := requirements.txt
PLAYBOOK ?= site.yml    # <-- Playbook par défaut
PYTHON := python3

# Environnement : staging (par défaut) ou production
ENV ?= staging

# Options additionnelles
TAGS ?=
EXTRA_VARS ?=

# Détection du support couleurs
use_colors := $(shell if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ $$(tput colors) -ge 8 ]; then echo yes; else echo no; fi)

ifeq ($(use_colors),yes)
GREEN   := $(shell tput setaf 2)
YELLOW  := $(shell tput setaf 3)
RED     := $(shell tput setaf 1)
RESET   := $(shell tput sgr0)
else
GREEN   :=
YELLOW  :=
RED     :=
RESET   :=
endif

.DEFAULT_GOAL := help

## Création du venv et installation des dépendances Python
$(VENV_DIR)/bin/activate: $(REQ_FILE)
	@printf "%s\n" "$(YELLOW)Création de l'environnement virtuel...$(RESET)"
	@test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR)
	@printf "%s\n" "$(YELLOW)Installation des dépendances Python...$(RESET)"
	@$(VENV_DIR)/bin/pip install --upgrade -r req_pip.txt
	@$(VENV_DIR)/bin/pip install -r $(REQ_FILE)
	@touch $(VENV_DIR)/bin/activate
	@printf "%s\n" "$(GREEN)✅ Environnement virtuel prêt !$(RESET)"

install: $(VENV_DIR)/bin/activate
	@printf "%s\n" "$(GREEN)✅ Installation terminée.$(RESET)"

check-env:
	@if [ ! -d "$(ENV)" ]; then \
		printf "%s\n" "$(RED)❌ Le répertoire d'environnement '$(ENV)' n'existe pas.$(RESET)"; \
		exit 1; \
	fi

## Exécution du playbook
run: install check-env
	@CMD="$(VENV_DIR)/bin/ansible-playbook $(PLAYBOOK) -i $(ENV)"; \
	if [ -n "$(TAGS)" ]; then \
		CMD="$$CMD --tags $(TAGS)"; \
		printf "%s\n" "$(YELLOW)→ Exécution avec tags : $(TAGS)$(RESET)"; \
	fi; \
	if [ -n "$(EXTRA_VARS)" ]; then \
		CMD="$$CMD -e '$(EXTRA_VARS)'"; \
		printf "%s\n" "$(YELLOW)→ Variables supplémentaires : $(EXTRA_VARS)$(RESET)"; \
	fi; \
	printf "%s\n" "$(YELLOW)Lancement du playbook $(PLAYBOOK) sur $(ENV)...$(RESET)"; \
	$$CMD; \
	printf "%s\n" "$(GREEN)✅ Playbook exécuté avec succès sur $(ENV).$(RESET)"

clean:
	@printf "%s\n" "$(YELLOW)Suppression de l'environnement virtuel...$(RESET)"
	@rm -rf $(VENV_DIR)
	@printf "%s\n" "$(GREEN)✅ Environnement supprimé.$(RESET)"

reinstall: clean install

help:
	@echo "Commandes disponibles :"
	@echo "  make install                          - Crée le venv et installe les dépendances Python"
	@echo "  make run                              - Exécute le playbook par défaut (site.yml)"
	@echo "  make run PLAYBOOK=playbooks/x.yml     - Exécute un playbook spécifique"
	@echo "  make run ENV=production               - Exécute sur la production"
	@echo "  make run TAGS=install                 - Exécute avec certains tags"
	@echo "  make run EXTRA_VARS=\"key=value\"       - Passe des variables supplémentaires"
	@echo "  make clean                            - Supprime le venv"
	@echo "  make reinstall                        - Réinstalle tout proprement"

