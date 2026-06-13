ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
QUARTZ := $(ROOT)quartz

_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(_ARGS):;@:)

.PHONY: setup preview new

setup:
	git clone --depth 1 https://github.com/jackyzha0/quartz $(QUARTZ) && \
	cd $(QUARTZ) && \
	bun install && \
	rm -rf content && ln -s ../notes content && \
	bun run quartz create --template obsidian --strategy symlink --source ../notes --links shortest --baseUrl localhost && \
	sed -i '' '/- git/d' $(QUARTZ)/quartz.config.yaml

preview:
	cd $(QUARTZ) && bun run quartz build --serve

new:
	@test -n "$(_ARGS)" || (echo "Usage: make new <path/title>"; exit 1)
	@DATE=$$(date +%Y-%m-%d); \
	FILE="$(ROOT)notes/$(_ARGS).md"; \
	BASENAME=$$(basename "$(_ARGS)"); \
	mkdir -p "$$(dirname "$$FILE")"; \
	sed -e "s/{{title}}/$$BASENAME/" -e "s/{{date:YYYY-MM-DD}}/$$DATE/" $(ROOT)template.md > "$$FILE"; \
	echo "Created: $$FILE"
