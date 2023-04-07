# Copyright The Total RP 3 Authors
# SPDX-License-Identifier: Apache-2.0

LIBDIR := totalRP3/libs
PACKAGER_URL := https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh
SCHEMA_URL := https://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd

.PHONY: check dist libs locales
.DEFAULT: all
.DELETE_ON_ERROR:
.FORCE:

all: dist

check: Scripts/UI.xsd
	pre-commit run --all-files

dist:
	@curl -s $(PACKAGER_URL) | bash -s -- -d -S

libs:
	@curl -s $(PACKAGER_URL) | bash -s -- -c -d -z
	@cp -a .release/$(LIBDIR)/* $(LIBDIR)/

locales:
	bash Scripts/generate-locales.sh

Scripts/UI.xsd: .FORCE
	curl -s $(SCHEMA_URL) -o $@
