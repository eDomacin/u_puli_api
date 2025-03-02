.PHONY: default dart_version
default: welcome

welcome:
	@echo "Welcome to 'U Puli api' project"

dart_version: 
	dart --version

generate:
	dart run build_runner build --delete-conflicting-outputs


run_dev: 
	@set -a && source .env && set +a && dart run bin/server.dart



