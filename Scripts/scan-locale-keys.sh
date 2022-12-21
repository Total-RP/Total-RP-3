#!/bin/bash
set -euo pipefail

declare locale_keys=()

function scan_locale_keys {
	declare pattern='; "([A-Z0-9_]+)"'

	while read -r line; do
		if [[ "$line" =~ $pattern ]]; then
			locale_keys+=("${BASH_REMATCH[1]}")
		fi
	done
}

function remove_locale_key {
	local locale_key="$1"
	local new_array=()

	for value in "${locale_keys[@]}"; do
		if [[ "$value" != "$locale_key" ]]; then
			new_array+=("$value")
		fi
	done

	locale_keys=("${new_array[@]}")
}

function scan_script_files {
	local file_name=
	local file_contents=

	while read -r file_name; do
		file_contents=$(cat "$file_name")

		for locale_key in "${locale_keys[@]}"; do
			if [[ "$file_contents" =~ "$locale_key" ]]; then
				remove_locale_key "$locale_key"
			fi
		done
	done
}

scan_locale_keys < <(luac -l -p totalRP3/Locales/enUS.lua)
scan_script_files < <(git ls-files '*.lua' ':!:totalRP3/Locales/????.lua')

if [[ "${#locale_keys[@]}" -ne 0 ]]; then
	echo "Found potentially unused localization keys:"

	for k in "${locale_keys[@]}"; do
		echo -e "\t$k"
	done | sort -n
else
	echo "No potentially unused localization keys found."
fi
