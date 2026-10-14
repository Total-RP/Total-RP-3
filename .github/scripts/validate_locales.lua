-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

package.path = "Tests/?.lua;Tests/?/Init.lua;" .. package.path;

local Environment = require("Environment");
local LocaleValidator = require("LocaleValidator");

local addon = Environment.LoadAddOn();
local locales = addon.loc:GetLocales(true);
local reference = locales.enUS;
local paths = {};

for _, path in ipairs(arg) do
	local code = string.match(path, "^totalRP3/Locales/(%a%a%a%a)%.lua$");
	assert(code and locales[code], "Unknown locale path: " .. path);
	if code ~= "enUS" then
		paths[path] = code;
	end
end

if #arg == 0 then
	for code in pairs(locales) do
		if code ~= "enUS" then
			paths["totalRP3/Locales/" .. code .. ".lua"] = code;
		end
	end
end

local sortedPaths = {};

for path in pairs(paths) do
	table.insert(sortedPaths, path);
end

table.sort(sortedPaths);

local errorCount = 0;

for _, path in ipairs(sortedPaths) do
	local locations = LocaleValidator.GetLocations(path);
	local diagnostics = LocaleValidator.CheckLocale(reference, locales[paths[path]], locations);
	local errors = 0;
	local warnings = 0;

	for _, diagnostic in ipairs(diagnostics) do
		if diagnostic.severity == "error" then
			errors = errors + 1;
		else
			warnings = warnings + 1;
		end
	end

	local status = #diagnostics == 0 and "OK" or string.format("%d errors, %d warnings", errors, warnings);

	print(string.format("Checking %-50s %s", path, status));

	for _, diagnostic in ipairs(diagnostics) do
		print(string.format("    %s:%d:%d: %s: %s", path, diagnostic.line, diagnostic.column, diagnostic.severity, diagnostic.message));

		if os.getenv("GITHUB_ACTIONS") == "true" then
			print(LocaleValidator.FormatAnnotation(path, diagnostic));
		end
	end

	print("");

	errorCount = errorCount + errors;
end

os.exit(math.min(errorCount, 1));
