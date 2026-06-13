ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: setup preview

setup:
	git clone --depth 1 https://github.com/jackyzha0/quartz $(ROOT)quartz
	cd $(ROOT)quartz && bun install
	cd $(ROOT)quartz && rm -rf content && ln -s ../notes content
	cd $(ROOT)quartz && bun run quartz create --template obsidian --strategy symlink --source ../notes --links shortest --baseUrl localhost

preview:
	cd $(ROOT)quartz && bun run quartz build --serve
