# Copyright The Total RP 3 Authors
# SPDX-License-Identifier: Apache-2.0

PYTHON ?= python3
LIBDIR := totalRP3/Libs
PACKAGER_URL := https://raw.githubusercontent.com/BigWigsMods/packager/eca4e176cd6ae5404c66bef5c11c08200a458400/release.sh
SCHEMA_URL := https://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd

CF_PROJECT_ID := 75973

LOCALES := enUS deDE esES esMX frFR itIT koKR ptBR ruRU zhCN zhTW
LOCALES_DIR := totalRP3/Locales
LOCALES_SCRIPT := $(PYTHON) .github/scripts/localization.py
EXPORT_LOCALES := enUS
IMPORT_LOCALES := $(filter-out $(EXPORT_LOCALES),$(LOCALES))

.DEFAULT: all
.DELETE_ON_ERROR:
.FORCE:
.PHONY: all check dist libs schema

all: dist

check: schema
	pre-commit run --all-files

dist:
	curl -s $(PACKAGER_URL) | bash -s -- -d

libs:
	curl -s $(PACKAGER_URL) | bash -s -- -cdlz
	cp -aTv .release/$(LIBDIR) $(LIBDIR)

schema:
	curl -s $(SCHEMA_URL) -o .github/scripts/ui.xsd

.PHONY: translations translations-export translations-export-all translations-import translations-import-all
translations: translations-export translations-import
translations-export: $(addprefix translations-export-,$(EXPORT_LOCALES))
translations-export-all: $(addprefix translations-export-,$(LOCALES))
translations-import: $(addprefix translations-import-,$(IMPORT_LOCALES))
translations-import-all: $(addprefix translations-import-,$(LOCALES))

translations-export-enUS: EXPORT_OPTIONS := --delete-missing-phrases

.PHONY: $(addprefix translations-export-,$(LOCALES))
$(addprefix translations-export-,$(LOCALES)): translations-export-%:
	$(LOCALES_SCRIPT) upload --locale $* --project-id $(CF_PROJECT_ID) $(EXPORT_OPTIONS) <$(LOCALES_DIR)/$*.lua

.PHONY: $(addprefix translations-import-,$(LOCALES))
$(addprefix translations-import-,$(LOCALES)): translations-import-%:
	$(LOCALES_SCRIPT) download --locale $* --project-id $(CF_PROJECT_ID) $(IMPORT_OPTIONS) >$(LOCALES_DIR)/$*.lua
