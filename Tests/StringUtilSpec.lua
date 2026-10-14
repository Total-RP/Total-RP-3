-- luacheck: ignore

local Environment = require("Environment");

Environment.LoadAddOn();

describe("DequoteString", function()
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

describe("CapitalizeWords", function()
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

describe("GenerateIncrementalName", function()
	it("returns an available prefix unchanged", function()
		local function Predicate()
			return true;
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob");
		assert.are.equal("Bob", result);
	end);

	it("returns an available numbered prefix unchanged", function()
		local function Predicate()
			return true;
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob (23)");
		assert.are.equal("Bob (23)", result);
	end);

	it("starts new suffixes at two", function()
		local function Predicate(name)
			return name ~= "Bob";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob");
		assert.are.equal("Bob (2)", result);
	end);

	it("checks successive names until one is available", function()
		local candidates = {};

		local function Predicate(name)
			table.insert(candidates, name);
			return name ~= "Bob" and name ~= "Bob (2)" and name ~= "Bob (3)";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob");
		assert.are.equal("Bob (4)", result);
		assert.are.same({ "Bob", "Bob (2)", "Bob (3)", "Bob (4)" }, candidates);
	end);

	it("continues counting from an existing suffix", function()
		local candidates = {};

		local function Predicate(name)
			table.insert(candidates, name);
			return name ~= "Bob (23)" and name ~= "Bob (24)";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob (23)");
		assert.are.equal("Bob (25)", result);
		assert.are.same({ "Bob (23)", "Bob (24)", "Bob (25)" }, candidates);
	end);

	it("uses a custom suffix for new names", function()
		local function Predicate(name)
			return name ~= "Bob";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob", " - %d");
		assert.are.equal("Bob - 2", result);
	end);

	it("continues a custom suffix with literal pattern characters", function()
		local function Predicate(name)
			return name ~= "Bob.[23]+";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob.[23]+", ".[%d]+");
		assert.are.equal("Bob.[24]+", result);
	end);

	it("continues the complete number without a suffix delimiter", function()
		local function Predicate(name)
			return name ~= "Bob23";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob23", "%d");
		assert.are.equal("Bob24", result);
	end);

	it("preserves numbers that do not match the suffix", function()
		local function Predicate(name)
			return name ~= "Bob 23";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob 23");
		assert.are.equal("Bob 23 (2)", result);
	end);

	it("only recognizes a suffix at the end of the prefix", function()
		local function Predicate(name)
			return name ~= "Bob (23) Smith";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob (23) Smith");
		assert.are.equal("Bob (23) Smith (2)", result);
	end);

	it("only increments the final matching suffix", function()
		local function Predicate(name)
			return name ~= "Bob (2) (23)";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob (2) (23)");
		assert.are.equal("Bob (2) (24)", result);
	end);

	it("preserves formatting for other numeric suffix formats", function()
		local function Predicate(name)
			return name ~= "Bob (23)";
		end

		local result = TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob (23)", " (%02d)");
		assert.are.equal("Bob (23) (02)", result);
	end);

	it("errors when a suffix repeats a rejected name", function()
		local candidates = {};

		local function Predicate(name)
			table.insert(candidates, name);
			return #candidates > 2;
		end

		local function Generate()
			return TRP3_StringUtil.GenerateIncrementalName(Predicate, "Bob", " copy");
		end

		assert.error_matches(Generate, "attempted to generate a duplicate incremental name");
		assert.are.same({ "Bob", "Bob copy" }, candidates);
	end);
end);
