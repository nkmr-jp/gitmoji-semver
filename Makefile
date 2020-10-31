# Options
V=v3.0.0
GITMOJI_VERSION=$(V)
F=.semver.yml
SEMVER_FILE=$(F)
O=./
OUT_DIR=$(O)

BASE_FILE=https://raw.githubusercontent.com/carloscuesta/gitmoji/$(GITMOJI_VERSION)/src/data/gitmojis.json

# See: https://gist.github.com/rsperl/d2dfe88a520968fbc1f49db0a29345b9
# define standard colors
BLACK        := $(shell tput -Txterm setaf 0)
RED          := $(shell tput -Txterm setaf 1)
GREEN        := $(shell tput -Txterm setaf 2)
YELLOW       := $(shell tput -Txterm setaf 3)
LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
PURPLE       := $(shell tput -Txterm setaf 5)
BLUE         := $(shell tput -Txterm setaf 6)
WHITE        := $(shell tput -Txterm setaf 7)

RESET := $(shell tput -Txterm sgr0)

help:
	@echo
	@echo "$(GREEN)Usage:$(RESET)"
	@echo "    make COMMAND [Options]"
	@echo
	@echo "$(GREEN)Commands:$(RESET)"
	@echo "    gen		$(BLUE)Generate gitmojis.json with semver field (alias: g)$(RESET)"
	@echo "    list	$(BLUE)Show generated gitmojis.json (alias: l)$(RESET)"
	@echo "    scaffold	$(BLUE)Generate semantic-release setting files (alias: s)$(RESET)"
	@echo
	@echo "$(GREEN)Options:$(RESET)"
	@echo "    V=<version>		$(BLUE)Specify the base gitmoji version$(RESET)"
	@echo "    F=<filepath>	$(BLUE)Specify .semver.yml file path$(RESET)"
	@echo "    O=<output dir>	$(BLUE)Specify semantic-release setting files output directory$(RESET)"
	@echo
	@echo "$(GREEN)Examples:$(RESET)"
	@echo "    make gen V=v3.0.0 F=./.semver.yml"
	@echo "    make list"
	@echo "    make scaffold V=v3.0.0 F=./.semver.yml O=./.playground"
	@echo

# Generate gitmojis.json with semver field
gen:
	@echo
	@echo "$(PURPLE)# GEN: 1. Fetch gitmojis.json ($(GITMOJI_VERSION))$(RESET)"
	mkdir -p build build/src build/dist
	curl -so build/src/gitmojis.json $(BASE_FILE)

	@echo
	@echo
	@echo "$(PURPLE)# GEN: 2. Add semver field$(RESET)"
	yq '.' $(SEMVER_FILE) > build/src/semver.json
	node gitmoji-semver.js
	cat build/dist/tmp.json | jq > build/dist/gitmojis.json
	yq -y '.' build/dist/gitmojis.json > build/dist/gitmojis.yml
	rm build/dist/tmp.json

	@echo
	@echo
	@echo "$(PURPLE)# GEN: 3. Generated!$(RESET)"
	@echo "Generated gitmojis.json and gitmojis.yml with semver field"
	@echo "See ./build/dist"

	@echo
	@make list

FORMAT={emoji:.emoji, code:.code, desc: .description}
GITMOJI_FILE=build/dist/gitmojis.json

list:
	@echo
	@echo "$(PURPLE)# LIST: show list gitmoji grouped by semver$(RESET)"
	@echo "\n# Major (Breaking)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="major") | $(FORMAT)'
	@echo "\n# Minor (Feature)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="minor") | $(FORMAT)'
	@echo "\n# Patch (Fix)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="patch") | $(FORMAT)'
	@echo "\n# None"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="none") | $(FORMAT)'
	@echo "\n# Ignore (Not to be added to the changelog when use semantic-release)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="ignore") | $(FORMAT)'

scaffold: gen
	@echo
	@echo "$(PURPLE)# SCAFFOLD: Generate semantic-release setting files$(RESET)"
	node gen-release-template.js
	mkdir -p $(OUT_DIR)/.release
	cp -a ./semantic-release-template/. $(OUT_DIR)/.release
	cp ./build/dist/release-template.hbs $(OUT_DIR)/.release
	cp ./build/dist/gitmojis.json $(OUT_DIR)/.release
	cp ./build/src/semver.json $(OUT_DIR)/.release
	@echo
	@echo "$(LIGHTPURPLE)🎉  Add semantic-release setting files$(RESET)"
	@echo $(OUT_DIR)/.release

# Short commands
l: list
g: gen
s: scaffold
h: help
