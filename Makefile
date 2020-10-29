# Options
V=v3.0.0
GITMOJI_VERSION=$(V)
F=semver.yml
SEMVER_FILE_PATH=$(F)

BASE_FILE=https://raw.githubusercontent.com/carloscuesta/gitmoji/$(GITMOJI_VERSION)/src/data/gitmojis.json

# See: https://gist.github.com/rsperl/d2dfe88a520968fbc1f49db0a29345b9
COLOR := $(shell tput -Txterm setaf 5)
RESET := $(shell tput -Txterm sgr0)

help:
	@echo
	@echo "Usage:"
	@echo
	@echo "    make COMMAND [Options]"
	@echo
	@echo "Options:"
	@echo
	@echo "    V=version	Specify the base gitmoji version"
	@echo "    F=filepath	Specify semver.yml file path"
	@echo
	@echo "Commands:"
	@echo
	@echo "    gen		Generate gitmojis.json with semver field (alias: g)"
	@echo "    list	Show generated gitmojis.json (alias: l)"
	@echo "    scaffold	Generate semantic-release configs (alias: s)"

# Short commands
l: list
g: gen
s: scaffold
h: help

# Generate gitmojis.json with semver field
gen:
	@echo
	@echo "$(COLOR)# GEN: 1. Fetch gitmojis.json ($(GITMOJI_VERSION))$(RESET)"
	mkdir -p build build/src build/dist
	curl -so build/src/gitmojis.json $(BASE_FILE)

	@echo
	@echo
	@echo "$(COLOR)# GEN: 2. Add semver field$(RESET)"
	yq '.' $(SEMVER_FILE_PATH) > build/src/semver.json
	node gitmoji-semver.js
	cat build/dist/tmp.json | jq > build/dist/gitmojis.json
	yq -y '.' build/dist/gitmojis.json > build/dist/gitmojis.yml
	rm build/dist/tmp.json

	@echo
	@echo
	@echo "$(COLOR)# GEN: 3. Generated!$(RESET)"
	@echo "Generated gitmojis.json and gitmojis.yml whith semver field"
	@echo "See ./build/dist"

	@echo
	@make list

FORMAT={emoji:.emoji, code:.code, desc: .description}
GITMOJI_FILE=build/dist/gitmojis.json

list:
	@echo
	@echo "$(COLOR)# LIST: show list gitmoji grouped by semver$(RESET)"
	@echo "\n# Major (Breaking)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="major") | $(FORMAT)'
	@echo "\n# Minor (Feature)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="minor") | $(FORMAT)'
	@echo "\n# Patch (Fix)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="patch") | $(FORMAT)'
	@echo "\n# None"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="none") | $(FORMAT)'

scaffold:
	@echo
	@echo "$(COLOR)# SCAFFOLD: Generate semantic-release configs$(RESET)"
#	cp templates/commit-template.hbs build/dist/commit-template.hbs
	node gen-semantic-release-template.js
	ls -l build/dist/
	@echo

