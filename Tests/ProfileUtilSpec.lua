-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local Environment = require("Environment");

Environment.LoadAddOn();

describe("DeserializeProfile", function()
	before_each(function()
		TRP3_EncodingUtil.DecodeAce = spy.new(function() end);
		TRP3_EncodingUtil.DecodePEM = spy.new(function() end);
	end);

	it("hands an older export to DecodeAce", function()
		TRP3_ProfileUtil.DeserializeProfile("^1^T^^");
		assert.spy(TRP3_EncodingUtil.DecodeAce).was.called_with("^1^T^^");
		assert.spy(TRP3_EncodingUtil.DecodePEM).was_not.called();
	end);

	it("hands text without a PEM block to DecodeAce, even with noise pasted before", function()
		TRP3_ProfileUtil.DeserializeProfile("\194\160^1^T^^");
		assert.spy(TRP3_EncodingUtil.DecodeAce).was.called_with("\194\160^1^T^^");
		assert.spy(TRP3_EncodingUtil.DecodePEM).was_not.called();
	end);

	it("hands text with a plain dashed line to DecodeAce", function()
		TRP3_ProfileUtil.DeserializeProfile("-----\n^1^T^^");
		assert.spy(TRP3_EncodingUtil.DecodeAce).was.called_with("-----\n^1^T^^");
		assert.spy(TRP3_EncodingUtil.DecodePEM).was_not.called();
	end);

	it("hands a PEM block with another label to DecodePEM", function()
		local export = "-----BEGIN TRP3 EXTENDED-----\nQUJD\n-----END TRP3 EXTENDED-----";
		TRP3_ProfileUtil.DeserializeProfile(export);
		assert.spy(TRP3_EncodingUtil.DecodePEM).was.called_with(export);
		assert.spy(TRP3_EncodingUtil.DecodeAce).was_not.called();
	end);

	it("hands text holding a PEM block to DecodePEM, even if it contains ^1^T", function()
		local export = "\194\160-----BEGIN TRP3 PROFILE-----\nName: Odd ^1^T name\n\nQUJD\n-----END TRP3 PROFILE-----";
		TRP3_ProfileUtil.DeserializeProfile(export);
		assert.spy(TRP3_EncodingUtil.DecodePEM).was.called_with(export);
		assert.spy(TRP3_EncodingUtil.DecodeAce).was_not.called();
	end);

	it("reports text where no export is found as unrecognized", function()
		local _, reportedError = TRP3_ProfileUtil.DeserializeProfile("Hello, this is my profile!");
		assert.are.equal(reportedError, TRP3_API.loc.PR_IMPORT_ERROR_UNRECOGNIZED_FORMAT);

		_, reportedError = TRP3_ProfileUtil.DeserializeProfile("-----BEGIN TRP3 PROFILE-----\nQUJD");
		assert.are.equal(reportedError, TRP3_API.loc.PR_IMPORT_ERROR_UNRECOGNIZED_FORMAT);
	end);

	it("reports a malformed older export as an Ace error", function()
		TRP3_EncodingUtil.DecodeAce = spy.new(function() error("Supplied data is malformed"); end);
		local _, reportedError = TRP3_ProfileUtil.DeserializeProfile("^1^Tbroken");
		assert.are.equal(reportedError, TRP3_API.loc.PR_IMPORT_ERROR_DESERIALIZE_ACE);
	end);
end);
