#!/bin/sh

# Base URL from which we'll download API data.
RESOURCES_REPO_URL="https://github.com/Resike/BlizzardInterfaceResources/raw/master";

# Formats stdin as a list of quoted Lua strings
quote() {
	# We'll filter anything abjectly broken here, like patterns in strings.
	sed -e '/\\/d' -e 's/^.*$/"\0"/g'
}

# Strips assignments from stdin, keeping only the keys from each assignment.
strip_assignments() {
	sed 's/\s*=.*$//g'
}

# Formats stdin as an indented list of lines with trailing commas.
indent() {
	sed "s/^.*$/\t\t\0,/g"
}

# Kill the existing stds.wow = { ... }; block in the luacheck file and
# replace it with our generated data.
sed -i '/stds.wow = {/,/};/d' .luacheckrc

cat <<EOF >> .luacheckrc
stds.wow = {
	-- The below data is automatically generated. ($(date +%Y/%m/%d))
	read_globals = {
		-- Lua API Globals
$(curl -sL "${RESOURCES_REPO_URL}/Resources/APILua.lua" | quote | indent)

		-- C API Globals
$(curl -sL "${RESOURCES_REPO_URL}/Resources/APIC.lua" | quote | indent)

		-- API Globals
$(curl -sL "${RESOURCES_REPO_URL}/Resources/API.lua" | quote | indent)

		-- FrameXML Objects
$(curl -sL "${RESOURCES_REPO_URL}/Resources/Objects.lua" | quote | indent)

		-- FrameXML Fonts
$(curl -sL "${RESOURCES_REPO_URL}/Resources/TemplatesFontString.lua" | indent)

		-- FrameXML Tables
$(curl -sL "${RESOURCES_REPO_URL}/Resources/Tables.lua" | quote | indent)

		-- FrameXML Strings
$(curl -sL "${RESOURCES_REPO_URL}/Resources/Strings.lua" | strip_assignments | quote | indent)

		-- FrameXML Numbers
$(curl -sL "${RESOURCES_REPO_URL}/Resources/Numbers.lua" | strip_assignments | quote | indent)
	},
};
EOF
