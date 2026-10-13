-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local Environment = require("Environment");

local function MarkSpan(text)
	return "{" .. text .. "}";
end

insulate("TransformSpans", function()
	setup(function()
		Environment.LoadAddOn();
	end);

	it("uses original text and indices even when replacements change length", function()
		local text = "a[one][two]z";
		local searches = {};
		local spans = {};

		local function TransformSpan(...)
			table.insert(spans, { ... });
			return "";
		end

		local function FindSpan(original, searchStart)
			assert.are.equal(text, original);
			table.insert(searches, searchStart);
			return string.find(original, "%b[]", searchStart);
		end

		local result = TRP3_ChatFrameUtil.TransformSpans(text, TransformSpan, FindSpan);

		assert.are.equal("az", result);
		assert.are.same({ 1, 7, 12 }, searches);
		assert.are.same({ { "[one]", 2, 6 }, { "[two]", 7, 11 } }, spans);
	end);

	it("preserves nil and false replacements but accepts an empty replacement", function()
		local function TransformSpan(_, startIndex)
			if startIndex == 1 then
				return nil;
			elseif startIndex == 6 then
				return false;
			else
				return "";
			end
		end

		local function FindSpan(text, searchStart)
			return string.find(text, "%b[]", searchStart);
		end

		local result = TRP3_ChatFrameUtil.TransformSpans("[one][two][three]", TransformSpan, FindSpan);
		assert.are.equal("[one][two]", result);
	end);

	it("returns unmatched text unchanged without invoking the transform", function()
		local transform = spy.new(MarkSpan);

		local function FindSpan(text, searchStart)
			return string.find(text, "%b[]", searchStart);
		end

		assert.are.equal("plain text", TRP3_ChatFrameUtil.TransformSpans("plain text", transform, FindSpan));
		assert.are.equal("", TRP3_ChatFrameUtil.TransformSpans("", transform, FindSpan));
		assert.spy(transform).was_not.called();
	end);
end);

insulate("TransformEmoteSpans", function()
	setup(function()
		Environment.LoadAddOn();
	end);

	it("detects both delimiter forms in the same message", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("Hello *waves* and <smiles>!", MarkSpan);
		assert.are.equal("Hello {*waves*} and {<smiles>}!", result);
	end);

	it("preserves doubled star delimiters", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("**waves** *smiles*", MarkSpan);
		assert.are.equal("{**waves**} {*smiles*}", result);
	end);

	it("does not pair stars with angle brackets", function()
		for _, text in ipairs({ "*waves>", "<smiles*" }) do
			assert.are.equal(text, TRP3_ChatFrameUtil.TransformEmoteSpans(text, MarkSpan));
		end
	end);

	it("retries after an unmatched opener", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("<unfinished *waves*", MarkSpan);
		assert.are.equal("<unfinished {*waves*}", result);
	end);

	it("does not reinterpret part of an unmatched doubled opener", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("**unfinished *", MarkSpan);
		assert.are.equal("**unfinished *", result);
	end);

	it("skips simple and nosed angle mouths inside spans", function()
		for _, face in ipairs({ ":>", ";<", "=->", ":^<" }) do
			local text = "<hello " .. face .. ">";
			assert.are.equal("{" .. text .. "}", TRP3_ChatFrameUtil.TransformEmoteSpans(text, MarkSpan));
		end
	end);

	it("skips kissing faces and star noses inside star spans", function()
		for _, face in ipairs({ ":*", ":-*", ":*)", ";*>" }) do
			local text = "*hello " .. face .. "*";
			assert.are.equal("{" .. text .. "}", TRP3_ChatFrameUtil.TransformEmoteSpans(text, MarkSpan));
		end
	end);

	it("skips emoticons immediately before doubled closing stars", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("**hello :***", MarkSpan);
		assert.are.equal("{**hello :***}", result);
	end);

	it("skips hearts and angry eyebrows as opening tokens", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("<3 </3 >:( >:D <waves>", MarkSpan);
		assert.are.equal("<3 </3 >:( >:D {<waves>}", result);
	end);

	it("skips angry eyebrows inside angle spans", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("<hello >:(>", MarkSpan);
		assert.are.equal("{<hello >:(>}", result);
	end);

	it("skips both eyes in common eye faces", function()
		for _, face in ipairs({ ">_<", "<.<", ">_>", "*_*", "*.*" }) do
			assert.are.equal(face, TRP3_ChatFrameUtil.TransformEmoteSpans(face, MarkSpan));
			local text = "<hello " .. face .. ">";
			assert.are.equal("{" .. text .. "}", TRP3_ChatFrameUtil.TransformEmoteSpans(text, MarkSpan));
		end
	end);

	it("preserves text without complete spans", function()
		for _, text in ipairs({ "", "hello", "*", "<", "hello :>", ":* :*" }) do
			assert.are.equal(text, TRP3_ChatFrameUtil.TransformEmoteSpans(text, MarkSpan));
		end
	end);

	it("passes the span and original byte indices to the callback", function()
		local received;
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans("hi <waves>!", function(...)
			received = { ... };
		end);
		assert.are.same({ "<waves>", 4, 10 }, received);
		assert.are.equal("hi <waves>!", result);
	end);

	it("can remove spans while preserving emoticons and surrounding text", function()
		local result = TRP3_ChatFrameUtil.TransformEmoteSpans(":* *waves :** then <smiles :>> <3", function() return ""; end);
		assert.are.equal(":*  then  <3", result);
	end);
end);

insulate("TransformOOCSpans", function()
	setup(function()
		Environment.LoadAddOn();
	end);

	it("detects single and doubled parentheses in the same message", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans("Hello (one) and ((two))!", MarkSpan);
		assert.are.equal("Hello {(one)} and {((two))}!", result);
	end);

	it("transforms nested parentheses as one outer span", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans("(one (two) (three (four)))", MarkSpan);
		assert.are.equal("{(one (two) (three (four)))}", result);
	end);

	it("transforms adjacent and empty spans", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans("()(())(hello)", MarkSpan);
		assert.are.equal("{()}{(())}{(hello)}", result);
	end);

	it("ignores simple opening and closing emoticon parentheses", function()
		for _, face in ipairs({ ":)", ":(", ";)", ";(", "=)", "=(" }) do
			local text = "(hello " .. face .. ")";
			assert.are.equal("{" .. text .. "}", TRP3_ChatFrameUtil.TransformOOCSpans(text, MarkSpan));
		end
	end);

	it("ignores nosed opening and closing emoticon parentheses", function()
		for _, nose in ipairs({ "-", "^", "*", "'", "~", "o" }) do
			for _, mouth in ipairs({ "(", ")" }) do
				local text = "(hello :" .. nose .. mouth .. ")";
				assert.are.equal("{" .. text .. "}", TRP3_ChatFrameUtil.TransformOOCSpans(text, MarkSpan));
			end
		end
	end);

	it("preserves emoticons outside OOC spans", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans(":( hello :) (world) ;-(", MarkSpan);
		assert.are.equal(":( hello :) {(world)} ;-(", result);
	end);

	it("handles emoticons inside doubled parentheses", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans("((hello :) and :())", MarkSpan);
		assert.are.equal("{((hello :) and :())}", result);
	end);

	it("retries inner spans after an unmatched outer opener", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans("(unfinished (one) then ((two))", MarkSpan);
		assert.are.equal("(unfinished {(one)} then {((two))}", result);
	end);

	it("preserves unmatched closing parentheses and trailing openers", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans(") (hello)) then (unfinished", MarkSpan);
		assert.are.equal(") {(hello)}) then (unfinished", result);
	end);

	it("does not call the transform without a complete span", function()
		local transform = spy.new(MarkSpan);
		for _, text in ipairs({ "", "hello", "(", ")", "((unfinished", ":( :)", ":-( ;-)" }) do
			assert.are.equal(text, TRP3_ChatFrameUtil.TransformOOCSpans(text, transform));
		end
		assert.spy(transform).was_not.called();
	end);

	it("passes each span and its original byte indices to the callback", function()
		local received = {};
		local result = TRP3_ChatFrameUtil.TransformOOCSpans("hi (one) ((two))!", function(...)
			table.insert(received, { ... });
			return "OOC";
		end);
		assert.are.same({ { "(one)", 4, 8 }, { "((two))", 10, 16 } }, received);
		assert.are.equal("hi OOC OOC!", result);
	end);

	it("preserves spans when the callback returns nil or false", function()
		local text = "hi (one) ((two))!";
		assert.are.equal(text, TRP3_ChatFrameUtil.TransformOOCSpans(text, function() end));
		assert.are.equal(text, TRP3_ChatFrameUtil.TransformOOCSpans(text, function() return false; end));
	end);

	it("can remove spans while preserving surrounding text and emoticons", function()
		local result = TRP3_ChatFrameUtil.TransformOOCSpans(":) (one) then ((two :)))!", function() return ""; end);
		assert.are.equal(":)  then !", result);
	end);
end);
