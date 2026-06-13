ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
QUARTZ := $(ROOT)quartz

.PHONY: setup preview

setup:
	git clone --depth 1 https://github.com/jackyzha0/quartz $(QUARTZ) && \
	cd $(QUARTZ) && \
	bun install && \
	rm -rf content && ln -s ../notes content && \
	bun run quartz create --template obsidian --strategy symlink --source ../notes --links shortest --baseUrl localhost && \
	sed -i '' '/- git/d' $(QUARTZ)/quartz.config.yaml

preview:
	cd $(QUARTZ) && bun run quartz build --serve
