# ==============================================================================
# VARIABLES

# -- Hugo
THEME = blowfish

# -- Docker
DOCKER_UID = $(shell id -u)
DOCKER_GID = $(shell id -g)
DOCKER_USER = $(DOCKER_UID):$(DOCKER_GID)
COMPOSE = DOCKER_USER=$(DOCKER_USER) docker compose
COMPOSE_RUN = $(COMPOSE) run --rm
COMPOSE_RUN_HUGO = $(COMPOSE_RUN) hugo

# ==============================================================================
# RULES

default: help

# -- Docker
run: ## run server
	@$(COMPOSE) up --force-recreate -d hugo
.PHONY: run

stop: ## stop container
	@$(COMPOSE) stop
.PHONY: stop

down: ## stop and remove container
	@$(COMPOSE) down
.PHONY: down

logs: ## display hugo logs
	@$(COMPOSE) logs -f hugo
.PHONY: logs

status: ## an alias for "docker-compose ps"
	@$(COMPOSE) ps
.PHONY: status

## -- Git
git-modules-init: ## init git modules
	 git submodule update --init --recursive
.PHONY: git-modules-init

git-modules-update: ## update git modules
	 git submodule update --remote --recursive
.PHONY: git-modules-update

git-modules-status: ## display git modules status (e.g: to display version)
	git submodule status
.PHONY: git-modules-status

git-clean: ## restore repository state as it was freshly cloned
	git clean -idx
.PHONY: clean

# -- Project
bootstrap: ## bootstrap project
bootstrap: \
	git-modules-init \
	run
.PHONY: bootstrap

build: ## build static blog
	@$(COMPOSE_RUN_HUGO) -t $(THEME)
.PHONY: build

# -- Misc
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help