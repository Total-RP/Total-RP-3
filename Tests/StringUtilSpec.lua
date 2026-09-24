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
