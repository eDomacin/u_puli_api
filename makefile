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

# db
generate_db_schema:
	dart run drift_dev schema dump lib/src/wrappers/drift/drift_wrapper.dart lib/src/wrappers/drift/migrations/schemas/

generate_db_migration_steps: 
	dart run drift_dev schema steps lib/src/wrappers/drift/migrations/schemas/ lib/src/wrappers/drift/migrations/schemas_versions/schema_versions.dart

start_tests_db:
	docker-compose -f test/helpers/database/docker-compose.yml up -d



# scraper 
run_scraper_dev:
	dart run bin/scraper/scraper.dart

build_scraper_prod:
	mkdir -p build && dart compile exe bin/scraper/scraper.dart -o build/scraper

run_scraper_prod:
	./build/scraper
