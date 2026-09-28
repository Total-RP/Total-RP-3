-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local SpecHelper = require("SpecHelper");

insulate("DecodeAce", function()
	local SerializedData = "^1^T^N1^N142^N2^SabcDEF^t^^";
	local serializer;

	setup(function()
		serializer = {};
		_G.LibStub = { GetLibrary = function() return serializer; end };
		SpecHelper.LoadFile("totalRP3/Core/EncodingUtil.lua");
	end);

	before_each(function()
		-- AceSerializer isn't tracked in the repository; this stand-in hands back what it was given.
		function serializer:Deserialize(data) return true, data; end
	end);

	it("passes valid data to AceSerializer for deserialization", function()
		function serializer:Deserialize()
			return true, "<Deserialized Data>";
		end;

		spy.on(serializer, "Deserialize");

		local deserializedData = TRP3_EncodingUtil.DecodeAce(SerializedData);
		assert.spy(serializer.Deserialize).called_with(serializer, SerializedData);
		assert.are.equal(deserializedData, "<Deserialized Data>");
	end);

	-- What copy-pasting from a browser, Discord or a word processor tends to add.
	it("skips a non-breaking space pasted before the AceSerializer string", function()
		assert.are.equal(SerializedData, TRP3_EncodingUtil.DecodeAce("\194\160" .. SerializedData));
	end);

	it("skips a zero-width space pasted before the AceSerializer string", function()
		assert.are.equal(SerializedData, TRP3_EncodingUtil.DecodeAce("\226\128\139" .. SerializedData));
	end);

	it("skips a byte order mark pasted before the AceSerializer string", function()
		assert.are.equal(SerializedData, TRP3_EncodingUtil.DecodeAce("\239\187\191" .. SerializedData));
	end);

	it("skips a code fence pasted before the AceSerializer string", function()
		assert.are.equal(SerializedData, TRP3_EncodingUtil.DecodeAce("```\n" .. SerializedData));
	end);

	it("skips a quote pasted before the AceSerializer string", function()
		assert.are.equal(SerializedData, TRP3_EncodingUtil.DecodeAce("\"" .. SerializedData));
	end);

	it("skips a message with a smiley pasted before the AceSerializer string", function()
		assert.are.equal(SerializedData, TRP3_EncodingUtil.DecodeAce("Here it is ^^\n" .. SerializedData));
	end);

	it("returns nil when the data holds no AceSerializer string", function()
		assert.is_nil(TRP3_EncodingUtil.DecodeAce("Hello, this is my profile!"));
		assert.is_nil(TRP3_EncodingUtil.DecodeAce("-----BEGIN TRP3 PROFILE-----\nQUJD\n-----END TRP3 PROFILE-----"));
	end);

	it("raises the error of a malformed AceSerializer string", function()
		function serializer:Deserialize() return false, "Supplied data is malformed"; end
		assert.error_matches(function() TRP3_EncodingUtil.DecodeAce("look: ^1^Tbroken"); end, "Supplied data is malformed");
	end);
end);
