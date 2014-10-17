uglifyjs = ./node_modules/.bin/uglifyjs

build:
	rm -rf build && mkdir build
	@$(uglifyjs) debug.js -o build/debug.min.js -m

default: build

.PHONY: build

