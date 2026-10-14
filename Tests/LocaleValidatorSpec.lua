-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local LocaleValidator = require("LocaleValidator");

describe("Locale format validation", function()
	it("reports extra implicit string and number arguments", function()
		assert.are.same({
			{ severity = "error", message = "extra format argument 1 (string)" },
			{ severity = "error", message = "extra format argument 2 (number)" },
		}, LocaleValidator.CheckText("Error on startup", "Error: %s (%d)"));
	end);

	it("reports an argument beyond the English argument count", function()
		assert.are.same({ { severity = "error", message = "extra format argument 3 (string)" } },
			LocaleValidator.CheckText("%s changed to %s", "%s %s %s"));
	end);

	it("allows reordered and repeated positional arguments", function()
		assert.are.same({}, LocaleValidator.CheckText("%s %d", "%2$d %1$s %1$s"));
	end);

	it("reports a repeated extra positional argument only once", function()
		assert.are.same({ { severity = "error", message = "extra format argument 3 (string)" } },
			LocaleValidator.CheckText("%s %d", "%1$s %2$d %3$s %3$d"));
	end);

	it("uses the highest English positional index as the argument count", function()
		assert.are.same({}, LocaleValidator.CheckText("%2$s", "%1$s %2$s"));
	end);

	it("ignores escaped percent signs", function()
		assert.are.same({}, LocaleValidator.CheckText("No arguments", "100%% %%s %%t"));
		assert.are.same({ { severity = "error", message = "extra format argument 1 (string)" } },
			LocaleValidator.CheckText("%%s", "%%%s"));
	end);

	it("recognizes flags width precision and Lua conversion types", function()
		assert.are.same({
			{ index = 1, kind = "number" },
			{ index = 2, kind = "number" },
			{ index = 3, kind = "string" },
			{ index = 4, kind = "number" },
		}, LocaleValidator.GetFormatArguments("%+08.2f %-4c %q %4$#x"));
	end);
end);

describe("Locale format diagnostics", function()
	it("rejects numeric conversions of English string arguments", function()
		assert.are.same({
			{ severity = "error", message = "format argument 1 expects a string but uses a numeric specifier" },
		}, LocaleValidator.CheckText("%s %d", "%2$d %1$.2f %1$d"));
	end);

	it("allows string conversions of English numeric arguments", function()
		assert.are.same({}, LocaleValidator.CheckText("%d %s", "%s %q"));
	end);

	it("reports omitted arguments by their positional index", function()
		assert.are.same({
			{ severity = "warning", message = "format argument 1 (string) is missing" },
			{ severity = "warning", message = "format argument 3 (number) is missing" },
		}, LocaleValidator.CheckText("%s %d %.2f", "%2$d"));
	end);

	it("does not require positional holes unused by English", function()
		assert.are.same({}, LocaleValidator.CheckText("%2$s", "%2$s"));
	end);

	it("reports an entirely omitted format string", function()
		assert.are.same({
			{ severity = "warning", message = "format argument 1 (string) is missing" },
		}, LocaleValidator.CheckText("Profile %s", "Profile"));
	end);

	it("reports unknown percent tokens including UTF-8 and trailing percent signs", function()
		assert.are.same({
			{ severity = "warning", message = "unrecognized percent token '%p'; may be literal text" },
			{ severity = "warning", message = "unrecognized percent token '%t'; may be literal text" },
			{ severity = "warning", message = "unrecognized percent token '%AUTHORS'; may be literal text" },
			{ severity = "warning", message = "unrecognized percent token '%АВТОРЫ'; may be literal text" },
			{ severity = "warning", message = "unrecognized percent token '%'; may be literal text" },
		}, LocaleValidator.CheckText("Text", "%p, %t %AUTHORS$s %АВТОРЫ$s %"));
	end);

	it("continues checking arguments after an unknown percent token", function()
		assert.are.same({
			{ severity = "error", message = "extra format argument 1 (string)" },
			{ severity = "warning", message = "unrecognized percent token '%t'; may be literal text" },
		}, LocaleValidator.CheckText("Text", "%t%s"));
	end);
end);

describe("Locale markup diagnostics", function()
	it("accepts balanced hexadecimal and named colors", function()
		assert.are.same({}, LocaleValidator.CheckText("Text", "|cFf00aAbBText|r |cnGREEN_FONT_COLOR:Text|r"));
	end);

	it("accepts balanced nested color pairs", function()
		assert.are.same({}, LocaleValidator.CheckText("Text", "|cffffffffOuter |cnRED_FONT_COLOR:Inner|r|r"));
	end);

	it("rejects short hexadecimal colors", function()
		assert.are.same({
			{ severity = "error", message = "malformed color escape; expected |c followed by eight hexadecimal digits" },
		}, LocaleValidator.CheckText("Text", "|cffffffText|r"));
	end);

	it("rejects non-hexadecimal color components", function()
		assert.are.same({
			{ severity = "error", message = "malformed color escape; expected |c followed by eight hexadecimal digits" },
		}, LocaleValidator.CheckText("Text", "|cgg000000Text"));
	end);

	it("rejects named colors without the name delimiter", function()
		assert.are.same({
			{ severity = "error", message = "malformed color escape; expected |cnCOLOR_NAME:" },
		}, LocaleValidator.CheckText("Text", "|cnGREEN_FONT_COLOR Text"));
	end);

	it("ignores escaped pipes even when followed by markup-like text", function()
		assert.are.same({}, LocaleValidator.CheckText("Text", "||c ||r ||o ||"));
	end);

	it("recognizes non-color escape sequences without validating their payloads", function()
		assert.are.same({}, LocaleValidator.CheckText("Text",
			"|n|Hitem:1|h[Item]|h |Ticon:16|t |A:atlas:16:16|a |WText|w |1 |2 |3 |4one:many;"));
	end);

	it("warns about unknown escapes and bare pipes", function()
		assert.are.same({
			{ severity = "warning", message = "unrecognized or unexpected WoW escape sequence |o" },
			{ severity = "warning", message = "unrecognized or unexpected WoW escape sequence | " },
			{ severity = "warning", message = "unrecognized or unexpected WoW escape sequence |" },
		}, LocaleValidator.CheckText("Text", "|oText | Text |"));
	end);
end);
