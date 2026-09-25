-- luacheck: ignore

local SpecHelper = require("SpecHelper");

insulate("DequoteString", function()
	setup(function()
		SpecHelper.LoadFile("totalRP3/Core/StringUtil.lua");
	end);

	it("removes supported matching surrounding quotes", function()
		local quotedStrings = {
			'"quoted"',
			"'quoted'",
			"“quoted”",
			"«quoted»",
		};

		for _, quotedString in ipairs(quotedStrings) do
			local result, wasDequoted = TRP3_StringUtil.DequoteString(quotedString);
			assert.are.equal("quoted", result);
			assert.is_true(wasDequoted);
		end
	end);

	it("preserves strings without matching surrounding quotes", function()
		local result, wasDequoted = TRP3_StringUtil.DequoteString("'quoted\"");
		assert.are.equal("'quoted\"", result);
		assert.is_false(wasDequoted);
	end);
end);

insulate("CapitalizeWords", function()
	setup(function()
		SpecHelper.LoadFile("totalRP3/Core/StringUtil.lua");
	end);

	it("capitalizes the first character of each word", function()
		local result = TRP3_StringUtil.CapitalizeWords("hello world");
		assert.are.equal("Hello World", result);
	end);

	it("preserves the rest of each word and the original whitespace", function()
		local result = TRP3_StringUtil.CapitalizeWords("hELLO\t wORLD\nagain");
		assert.are.equal("HELLO\t WORLD\nAgain", result);
	end);

	it("returns an empty string unchanged", function()
		local result = TRP3_StringUtil.CapitalizeWords("");
		assert.are.equal("", result);
	end);

	it("passes the complete initial multi-byte codepoint to C_Intl.ToUpper", function()
		local original = C_Intl.ToUpper;
		local received;

		-- We can't use a regular stub to replace this function as it's passed
		-- as a direct argument to string.gsub; stubs replace functions with
		-- tables which doesn't mix well with gsub's treatment of tables.
		C_Intl.ToUpper = function(codepoint)
			received = codepoint;
			return "É";
		end;

		finally(function() C_Intl.ToUpper = original; end);

		assert.are.equal("Éclair", TRP3_StringUtil.CapitalizeWords("éclair"));
		assert.are.equal("é", received);
	end);
end);
