# Copyright The Total RP 3 Authors
# SPDX-License-Identifier: Apache-2.0

PYTHON ?= python3
LIBDIR := totalRP3/Libs
PACKAGER_URL := https://raw.githubusercontent.com/BigWigsMods/packager/eca4e176cd6ae5404c66bef5c11c08200a458400/release.sh
SCHEMA_URL := https://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd

CF_PROJECT_ID := 75973

LOCALES := enUS deDE esES esMX frFR itIT koKR ptBR ruRU zhCN zhTW
LOCALES_DIR := totalRP3/Locales
LOCALE_PUSH_TARGETS := $(addprefix push-locales-,$(LOCALES))
LOCALE_PULL_TARGETS := $(addprefix pull-locales-,$(LOCALES))
PUSH_LOCALES := enUS
PULL_LOCALES := $(filter-out enUS,$(LOCALES))

.DEFAULT: all
.DELETE_ON_ERROR:
.FORCE:

.PHONY: all
all: dist

.PHONY: check
check: .github/scripts/ui.xsd
	pre-commit run --all-files

.PHONY: dist
dist:
	curl -s $(PACKAGER_URL) | bash -s -- -dS

.PHONY: libs
libs:
	curl -s $(PACKAGER_URL) | bash -s -- -cdlz
	cp -aTv .release/$(LIBDIR) $(LIBDIR)

.PHONY: locales
locales: push-locales pull-locales

.PHONY: push-all-locales
push-all-locales: $(addprefix push-locales-,$(LOCALES))

.PHONY: push-locales
push-locales: $(addprefix push-locales-,$(PUSH_LOCALES))

.PHONY: $(LOCALE_PUSH_TARGETS)
$(LOCALE_PUSH_TARGETS): push-locales-%:
	$(PYTHON) .github/scripts/localization.py upload --delete-missing-phrases --locale $* --project-id $(CF_PROJECT_ID) <$(LOCALES_DIR)/$*.lua

.PHONY: pull-all-locales
pull-all-locales: $(addprefix pull-locales-,$(LOCALES))

.PHONY: pull-locales
pull-locales: $(addprefix pull-locales-,$(PULL_LOCALES))

.PHONY: $(LOCALE_PULL_TARGETS)
$(LOCALE_PULL_TARGETS): pull-locales-%:
	$(PYTHON) .github/scripts/localization.py download --locale $* --project-id $(CF_PROJECT_ID) >$(LOCALES_DIR)/$*.lua

.github/scripts/ui.xsd: .FORCE
	curl -s $(SCHEMA_URL) -o $@
