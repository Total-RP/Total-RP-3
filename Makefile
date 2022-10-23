# Copyright The Total RP 3 Authors
# SPDX-License-Identifier: Apache-2.0

SHELL = /bin/bash
LIBDIR := totalRP3/libs
PACKAGER_URL := https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh
SCHEMA_URL := https://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd

.PHONY: check dist libs locales

all: check

check:
	@luacheck -q $(shell git ls-files '*.lua' ':!:totalRP3/Locales/????.lua')
	@xmllint --schema <(curl -s $(SCHEMA_URL)) --noout $(shell git ls-files '*.xml' ':!:totalRP3/Libs/*' ':!:*/Bindings.xml')

dist:
	@curl -s $(PACKAGER_URL) | bash -s -- -d -S

libs:
	@curl -s $(PACKAGER_URL) | bash -s -- -c -d -z
	@cp -a .release/$(LIBDIR)/* $(LIBDIR)/

locales:
	bash Scripts/generate-locales.sh
