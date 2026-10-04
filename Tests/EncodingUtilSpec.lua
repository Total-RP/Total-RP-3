-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local Environment = require("Environment");
local AceSerializer = LibStub:GetLibrary("AceSerializer-3.0");

Environment.LoadAddOn();

describe("DecodeAce", function()
	local SERIALIZED_DATA = "^1^T^N1^N142^N2^SabcDEF^t^^";
	local DESERIALIZED_DATA = "abcDEF";

	before_each(function()
		local success = true;
		stub(AceSerializer, "Deserialize", success, DESERIALIZED_DATA);
	end);

	it("passes valid data to AceSerializer for deserialization", function()
		local actualData = TRP3_EncodingUtil.DecodeAce(SERIALIZED_DATA);

		assert.stub(AceSerializer.Deserialize).called_with(AceSerializer, SERIALIZED_DATA);
		assert.are.equal(actualData, DESERIALIZED_DATA);
	end);

	-- What copy-pasting from a browser, Discord or a word processor tends to add.
	it("skips a non-breaking space pasted before the AceSerializer string", function()
		local actualData = TRP3_EncodingUtil.DecodeAce("\194\160" .. SERIALIZED_DATA);
		assert.are.equal(actualData, DESERIALIZED_DATA);
	end);

	it("skips a zero-width space pasted before the AceSerializer string", function()
		local actualData = TRP3_EncodingUtil.DecodeAce("\226\128\139" .. SERIALIZED_DATA);
		assert.are.equal(actualData, DESERIALIZED_DATA);
	end);

	it("skips a byte order mark pasted before the AceSerializer string", function()
		local actualData = TRP3_EncodingUtil.DecodeAce("\239\187\191" .. SERIALIZED_DATA);
		assert.are.equal(actualData, DESERIALIZED_DATA);
	end);

	it("skips a code fence pasted before the AceSerializer string", function()
		local actualData = TRP3_EncodingUtil.DecodeAce("```\n" .. SERIALIZED_DATA);
		assert.are.equal(actualData, DESERIALIZED_DATA);
	end);

	it("skips a quote pasted before the AceSerializer string", function()
		local actualData = TRP3_EncodingUtil.DecodeAce("\"" .. SERIALIZED_DATA);
		assert.are.equal(actualData, DESERIALIZED_DATA);
	end);

	it("skips a message with a smiley pasted before the AceSerializer string", function()
		local actualData = TRP3_EncodingUtil.DecodeAce("Here it is ^^\n" .. SERIALIZED_DATA);
		assert.are.equal(actualData, DESERIALIZED_DATA);
	end);

	it("returns nil when the data holds no AceSerializer string", function()
		assert.is_nil(TRP3_EncodingUtil.DecodeAce("Hello, this is my profile!"));
		assert.is_nil(TRP3_EncodingUtil.DecodeAce("-----BEGIN TRP3 PROFILE-----\nQUJD\n-----END TRP3 PROFILE-----"));
	end);

	it("raises the error of a malformed AceSerializer string", function()
		local ERROR_MESSAGE = "Supplied data is malformed";

		local success = false;
		stub(AceSerializer, "Deserialize", success, ERROR_MESSAGE);

		assert.error_matches(function() TRP3_EncodingUtil.DecodeAce("look: ^1^Tbroken"); end, ERROR_MESSAGE);
	end);
end);
