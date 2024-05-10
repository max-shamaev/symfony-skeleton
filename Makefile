## Local development
pre-start-local: ## Prepare application before first start
	@cp .env.local.dist .env

start-local: ## Start / restart local application
	@docker compose -f compose.local.yaml up -d --force-recreate --always-recreate-deps --remove-orphans --build
	@sleep 3
#	@docker compose -f compose.local.yaml exec fpm composer install -n
	@docker compose -f compose.local.yaml exec fpm bin/console messenger:setup-transports
#	@docker compose -f compose.local.yaml exec fpm bin/console doctrine:migrations:migrate -n
	@echo 'Web: http://localhost:8001/'

stop-local: ## Stop local application
	@docker compose -f compose.local.yaml down --remove-orphans

test-local: ## Test code local
	@docker compose -f compose.local.yaml exec fpm php -dxdebug.mode=coverage vendor/bin/phpunit --coverage-html coverage

check-local: ## Check code local
	@echo 'PHPStan'
	@docker compose -f compose.local.yaml exec fpm vendor/bin/phpstan
	@echo 'Psalm'
	@docker compose -f compose.local.yaml exec fpm vendor/bin/psalm
	@echo 'lint:container'
	@docker compose -f compose.local.yaml exec fpm bin/console lint:container
	@echo 'lint:twig'
	@docker compose -f compose.local.yaml exec fpm bin/console lint:twig templates
	@echo 'lint:yaml'
	@docker compose -f compose.local.yaml exec fpm bin/console lint:yaml config --parse-tags
	@echo 'php-cs-fixer'
	@docker compose -f compose.local.yaml exec fpm vendor/bin/php-cs-fixer fix --dry-run --allow-risky=yes
	@echo 'rector'
	@docker compose -f compose.local.yaml exec fpm vendor/bin/rector process -n

fix-local: ## Fix code local
	@echo 'php-cs-fixer'
	@docker compose -f compose.local.yaml exec fpm vendor/bin/php-cs-fixer fix --allow-risky=yes
	@echo 'rector'
	@docker compose -f compose.local.yaml exec fpm vendor/bin/rector process --xdebug

console-local: ## Open console local
	@docker compose -f compose.local.yaml exec -ti fpm /bin/sh

enable-git-hooks: ## Enable git hooks
	@git config core.hooksPath .githooks

## Help
help: ## List of all commands
	@grep -E '(^[a-zA-Z_0-9-]+:.*?##.*$$)|(^##)' Makefile \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "${G}%-24s${NC} %s\n", $$1, $$2}' \
	| sed -e 's/\[32m## /[33m/' && printf "\n";

.DEFAULT_GOAL := help
.PHONY: help
