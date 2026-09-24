# Copyright The Total RP 3 Authors
# SPDX-License-Identifier: Apache-2.0

libdir := "totalRP3/Libs"
packager_url := "https://raw.githubusercontent.com/BigWigsMods/packager/eca4e176cd6ae5404c66bef5c11c08200a458400/release.sh"
schema_url := "https://raw.githubusercontent.com/Gethe/wow-ui-source/refs/heads/live/Interface/AddOns/Blizzard_SharedXML/UI.xsd"
schema_file := "Types/UI.xsd"
cf_project_id := "75973"
locales_dir := "totalRP3/Locales"
localization_script := ".github/scripts/localization.py"

# Build the distributable addon package.
all: dist

# Run the full pre-commit check suite.
check:
    pre-commit run --all-files

# Build a distributable package using the packager script.
dist:
    curl -s {{ packager_url }} | bash -s -- -d

# Download and install packaged libraries.
libs:
    curl -s {{ packager_url }} | bash -s -- -cdlz
    cp -aTv .release/{{ libdir }} {{ libdir }}

# Refresh the vendored Blizzard UI schema.
schema:
    curl -s {{ schema_url }} -o {{ schema_file }}

# Synchronize translations; export enUS and import all others.
translations: translations-export translations-import

# Export the enUS locale.
translations-export:
    python3 {{ localization_script }} upload --locale enUS --project-id {{ cf_project_id }} --delete-missing-phrases <{{ locales_dir }}/enUS.lua

# Export every locale.
translations-export-all:
    python3 {{ localization_script }} upload --locale enUS --project-id {{ cf_project_id }} --delete-missing-phrases <{{ locales_dir }}/enUS.lua
    python3 {{ localization_script }} upload --locale deDE --project-id {{ cf_project_id }} <{{ locales_dir }}/deDE.lua
    python3 {{ localization_script }} upload --locale esES --project-id {{ cf_project_id }} <{{ locales_dir }}/esES.lua
    python3 {{ localization_script }} upload --locale esMX --project-id {{ cf_project_id }} <{{ locales_dir }}/esMX.lua
    python3 {{ localization_script }} upload --locale frFR --project-id {{ cf_project_id }} <{{ locales_dir }}/frFR.lua
    python3 {{ localization_script }} upload --locale itIT --project-id {{ cf_project_id }} <{{ locales_dir }}/itIT.lua
    python3 {{ localization_script }} upload --locale koKR --project-id {{ cf_project_id }} <{{ locales_dir }}/koKR.lua
    python3 {{ localization_script }} upload --locale ptBR --project-id {{ cf_project_id }} <{{ locales_dir }}/ptBR.lua
    python3 {{ localization_script }} upload --locale ruRU --project-id {{ cf_project_id }} <{{ locales_dir }}/ruRU.lua
    python3 {{ localization_script }} upload --locale zhCN --project-id {{ cf_project_id }} <{{ locales_dir }}/zhCN.lua
    python3 {{ localization_script }} upload --locale zhTW --project-id {{ cf_project_id }} <{{ locales_dir }}/zhTW.lua

# Import all non-enUS locale translations.
translations-import:
    python3 {{ localization_script }} download --locale deDE --project-id {{ cf_project_id }} >{{ locales_dir }}/deDE.lua
    python3 {{ localization_script }} download --locale esES --project-id {{ cf_project_id }} >{{ locales_dir }}/esES.lua
    python3 {{ localization_script }} download --locale esMX --project-id {{ cf_project_id }} >{{ locales_dir }}/esMX.lua
    python3 {{ localization_script }} download --locale frFR --project-id {{ cf_project_id }} >{{ locales_dir }}/frFR.lua
    python3 {{ localization_script }} download --locale itIT --project-id {{ cf_project_id }} >{{ locales_dir }}/itIT.lua
    python3 {{ localization_script }} download --locale koKR --project-id {{ cf_project_id }} >{{ locales_dir }}/koKR.lua
    python3 {{ localization_script }} download --locale ptBR --project-id {{ cf_project_id }} >{{ locales_dir }}/ptBR.lua
    python3 {{ localization_script }} download --locale ruRU --project-id {{ cf_project_id }} >{{ locales_dir }}/ruRU.lua
    python3 {{ localization_script }} download --locale zhCN --project-id {{ cf_project_id }} >{{ locales_dir }}/zhCN.lua
    python3 {{ localization_script }} download --locale zhTW --project-id {{ cf_project_id }} >{{ locales_dir }}/zhTW.lua
