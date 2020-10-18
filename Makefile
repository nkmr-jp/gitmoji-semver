GITMOJI_VERSION=v3.0.0
BASE_FILE=https://raw.githubusercontent.com/carloscuesta/gitmoji/$(GITMOJI_VERSION)/src/data/gitmojis.json

gen:
	@echo ""
	@echo "---- Fetch gitmojis.json ($(GITMOJI_VERSION))----"
	mkdir -p build build/src build/dist
	curl -so build/src/gitmojis.json $(BASE_FILE)

	@echo ""
	@echo ""
	@echo "---- Add semver field to gitmojis.json from semver.yml ----"
	yq '.' semver.yml > build/src/semver.json
	node script.js
	cat build/dist/tmp.json | jq > build/dist/gitmojis.json
	yq -y '.' build/dist/gitmojis.json > build/dist/gitmojis.yml
	rm build/dist/tmp.json

	@echo ""
	@echo ""
	@echo "---- Successfully ----"
	@echo "Semver field added to gitmojis.json and gitmojis.yml created"
	@echo "See ./build/dist"
