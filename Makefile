# Copyright The Total RP 3 Authors
# SPDX-License-Identifier: Apache-2.0

PYTHON ?= python3
LIBDIR := totalRP3/libs
PACKAGER_URL := https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh
SCHEMA_URL := https://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd

CF_PROJECT_ID := 75973
LOCALE_DIR := totalRP3/Locales

.PHONY: check dist libs translations translations/download translations/upload
.DEFAULT: all
.DELETE_ON_ERROR:
.FORCE:

all: dist

check: .github/scripts/ui.xsd
	pre-commit run --all-files

dist:
	@curl -s $(PACKAGER_URL) | bash -s -- -d -S

libs:
	@curl -s $(PACKAGER_URL) | bash -s -- -c -d -z
	@cp -a .release/$(LIBDIR)/* $(LIBDIR)/

translations: translations/upload translations/download

translations/download:
	$(PYTHON) .github/scripts/localization.py --project-id=$(CF_PROJECT_ID) --locale-dir=$(LOCALE_DIR) download

translations/upload:
	$(PYTHON) .github/scripts/localization.py --project-id=$(CF_PROJECT_ID) --locale-dir=$(LOCALE_DIR) upload

translations/upload-all:
	$(PYTHON) .github/scripts/localization.py --project-id=$(CF_PROJECT_ID) --locale-dir=$(LOCALE_DIR) upload -l "*"

.github/scripts/ui.xsd: .FORCE
	curl -s $(SCHEMA_URL) -o $@
