.PHONY: default dart_version
default: welcome

welcome:
	@echo "Welcome to 'U Puli api' project"

dart_version: 
	dart --version

generate:
	dart run build_runner build --delete-conflicting-outputs





run_dev: 
	@set -a && source .env && set +a && dart run bin/server/server.dart

build_prod:
	mkdir -p build && dart compile exe bin/server/server.dart -o build/server

# this expects the server to be built
run_prod:
	@set -a && source .env && set +a && ./build/server

build_prod_docker:
	docker build . -t myserver

run_prod_docker:
	docker run -it -p 8080:8080 --env-file .env  myserver

# db

generate_db:
	cd packages/database_wrapper && dart run build_runner build --delete-conflicting-outputs

generate_db_schema:
	cd packages/database_wrapper && dart run drift_dev schema dump lib/src/wrappers/drift/drift_wrapper.dart lib/src/wrappers/drift/migrations/schemas/

generate_db_migration_steps: 
	cd packages/database_wrapper && dart run drift_dev schema steps lib/src/wrappers/drift/migrations/schemas/ lib/src/wrappers/drift/migrations/schemas_versions/schema_versions.dart

start_tests_db:
	docker-compose -f test/helpers/database/docker-compose.yml up -d



# scraper 
run_scraper_dev:
	@set -a && source .env && set +a && dart run bin/scraper/scraper.dart

build_scraper_prod:
	mkdir -p build && dart compile exe bin/scraper/scraper.dart -o build/scraper

# this expects the scraper to be built
run_scraper_prod:
	@set -a && source .env && ./build/scraper



pubget:
	for package in $(PACKAGES); do \
		echo "Getting dependencies for $$package"; \
		cd $$package && dart pub get; \
	done




# vars - move to its own file
CURDIR = $(shell pwd)



# PACKAGES 
ENV_WRAPPER = $(CURDIR)/packages/env_wrapper
DATABASE_WRAPPER = $(CURDIR)/packages/database_wrapper
EVENTS_SCRAPER = $(CURDIR)/packages/events_scraper

# PACKAGES DIR LIST
PACKAGES = $(CURDIR) $(ENV_WRAPPER) $(DATABASE_WRAPPER) $(EVENTS_SCRAPER) 