GITMOJI_VERSION=v3.0.0
BASE_FILE=https://raw.githubusercontent.com/carloscuesta/gitmoji/$(GITMOJI_VERSION)/src/data/gitmojis.json

# See: https://gist.github.com/rsperl/d2dfe88a520968fbc1f49db0a29345b9
COLOR := $(shell tput -Txterm setaf 5)
RESET := $(shell tput -Txterm sgr0)

gen:
	@echo
	@echo "$(COLOR)# Fetch gitmojis.json ($(GITMOJI_VERSION))$(RESET)"
	mkdir -p build build/src build/dist
	curl -so build/src/gitmojis.json $(BASE_FILE)

	@echo
	@echo
	@echo "$(COLOR)# Add semver field$(RESET)"
	yq '.' semver.yml > build/src/semver.json
	node script.js
	cat build/dist/tmp.json | jq > build/dist/gitmojis.json
	yq -y '.' build/dist/gitmojis.json > build/dist/gitmojis.yml
	rm build/dist/tmp.json

	@echo
	@echo
	@echo "$(COLOR)# Generated!$(RESET)"
	@echo "Generated gitmojis.json and gitmojis.yml whith semver field"
	@echo "See ./build/dist"

	@echo
	@make list

FORMAT={emoji:.emoji, code:.code, desc: .description}
GITMOJI_FILE=build/dist/gitmojis.json
list:
	@echo "\n# Major (Breaking)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="major") | $(FORMAT)'
	@echo "\n# Minor (Feature)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="minor") | $(FORMAT)'
	@echo "\n# Patch (Fix)"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="patch") | $(FORMAT)'
	@echo "\n# None"
	@cat $(GITMOJI_FILE) | jq -c '.gitmojis[] | select(.semver=="none") | $(FORMAT)'