-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LocaleValidator = {};

function LocaleValidator.GetFormatArguments(text)
	local arguments = {};
	local unknownTokens = {};
	local implicitIndex = 0;
	local offset = 1;

	while true do
		local start = string.find(text, "%", offset, true);

		if not start then
			break;
		end

		local token = string.sub(text, start);

		if string.sub(token, 1, 2) == "%%" then
			offset = start + 2;
		else
			-- WoW extends Lua's format strings with positional arguments (%2$s).
			local position, specifier = string.match(token, "^%%(%d+)%$([-+ #0]*%d*%.?%d*[cdiouxXeEfgGqs])");
			local matched = position and ("%" .. position .. "$" .. specifier);

			if not matched then
				specifier = string.match(token, "^%%([-+ #0]*%d*%.?%d*[cdiouxXeEfgGqs])");
				matched = specifier and ("%" .. specifier);
			end

			if matched then
				if not position then
					implicitIndex = implicitIndex + 1;
				end

				local conversion = string.sub(specifier, -1);

				table.insert(arguments, {
					index = tonumber(position) or implicitIndex,
					kind = (conversion == "s" or conversion == "q") and "string" or "number",
				});
			else
				-- Keep UTF-8 tokens intact without requiring a Unicode library.
				matched = string.match(token, "^%%[^%s%p]*");
				table.insert(unknownTokens, matched);
			end

			offset = start + (matched and #matched or 1);
		end
	end

	return arguments, unknownTokens;
end

local function AddDiagnostic(diagnostics, severity, message)
	table.insert(diagnostics, { severity = severity, message = message });
end

local function CheckMarkup(text, diagnostics)
	local offset = 1;

	while true do
		local start = string.find(text, "|", offset, true);

		if not start then
			break;
		end

		local token = string.sub(text, start);
		local escape = string.sub(token, 2, 2);
		local length = 2;

		if escape == "c" then
			local color;
			local expectation;

			if string.sub(token, 3, 3) == "n" then
				color = string.match(token, "^|cn[A-Z][A-Z0-9_]*:");
				expectation = "|cnCOLOR_NAME:";
			else
				local hex = string.sub(token, 3, 10);
				if #hex == 8 and not string.find(hex, "[^%x]") then
					color = string.sub(token, 1, 10);
				end
				expectation = "|c followed by eight hexadecimal digits";
			end

			if color then
				length = #color;
			else
				AddDiagnostic(diagnostics, "error", "malformed color escape; expected " .. expectation);
			end
		elseif escape ~= "|" and (escape == "" or not string.find("rnHhTtAaWw1234", escape, 1, true)) then
			AddDiagnostic(diagnostics, "error", "unrecognized or unexpected WoW escape sequence |" .. escape);
		end

		offset = start + length;
	end
end

function LocaleValidator.CheckText(reference, translation)
	local argumentCount = 0;
	local expected = {};

	for _, argument in ipairs(LocaleValidator.GetFormatArguments(reference)) do
		argumentCount = math.max(argumentCount, argument.index);

		-- Numeric conversions require numbers; %s can also accept numbers.
		if not expected[argument.index] or argument.kind == "number" then
			expected[argument.index] = argument.kind;
		end
	end

	local diagnostics = {};
	local reported = {};
	local present = {};
	local arguments, unknownTokens = LocaleValidator.GetFormatArguments(translation);

	for _, argument in ipairs(arguments) do
		local message;
		present[argument.index] = true;

		if argument.index > argumentCount then
			message = string.format("extra format argument %d (%s)", argument.index, argument.kind);
		elseif expected[argument.index] == "string" and argument.kind == "number" then
			message = string.format("format argument %d expects a string but uses a numeric specifier", argument.index);
		end

		if message and not reported[argument.index] then
			AddDiagnostic(diagnostics, "error", message);
			reported[argument.index] = true;
		end
	end

	for index = 1, argumentCount do
		if expected[index] and not present[index] then
			AddDiagnostic(diagnostics, "warning", string.format("format argument %d (%s) is missing", index, expected[index]));
		end
	end

	for _, token in ipairs(unknownTokens) do
		AddDiagnostic(diagnostics, "warning", "unrecognized percent token '" .. token .. "'; may be literal text");
	end

	CheckMarkup(translation, diagnostics);

	return diagnostics;
end

-- Only index assignment locations; Lua itself loads and evaluates the values.
-- Diagnostics point to the key, including for multiline string values.
function LocaleValidator.GetLocations(path)
	local locations = {};
	local lineNumber = 0;

	for line in io.lines(path) do
		local column, key = string.match(line, "^%s*()%[%s*\"([%w_]+)\"%s*%]%s*=");
		lineNumber = lineNumber + 1;

		if key then
			locations[key] = { line = lineNumber, column = column };
		end
	end

	return locations;
end

function LocaleValidator.CheckLocale(reference, locale, locations)
	local diagnostics = {};

	for key, translation in locale:EnumerateTexts() do
		local original = reference:GetText(key);

		if original then
			for _, diagnostic in ipairs(LocaleValidator.CheckText(original, translation)) do
				local location = locations[key] or { line = 1, column = 1 };
				table.insert(diagnostics, {
					line = location.line,
					column = location.column,
					severity = diagnostic.severity,
					message = key .. ": " .. diagnostic.message,
				});
			end
		end
	end

	local function CompareSortDiagnostics(left, right)
		if left.line ~= right.line then
			return left.line < right.line;
		end

		return left.message < right.message;
	end

	table.sort(diagnostics, CompareSortDiagnostics);
	return diagnostics;
end

local function EscapeAnnotation(text)
	text = string.gsub(text, "%%", "%%25");
	text = string.gsub(text, "\r", "%%0D");
	text = string.gsub(text, "\n", "%%0A");
	return text;
end

function LocaleValidator.FormatAnnotation(path, diagnostic)
	path = EscapeAnnotation(path);
	path = string.gsub(path, ":", "%%3A");
	path = string.gsub(path, ",", "%%2C");
	return string.format("::%s file=%s,line=%d,col=%d::%s", diagnostic.severity, path, diagnostic.line, diagnostic.column, EscapeAnnotation(diagnostic.message));
end

return LocaleValidator;
