-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local SpecHelper = require("SpecHelper");

insulate("DeserializeProfile", function()
	setup(function()
		-- Error keys stand in for their text, so a spec only sees which error is reported.
		_G.TRP3_API = { loc = setmetatable({}, { __index = function(_, key) return key; end }) };

		-- Only read by the file-level icon tables in ProfileUtil.lua.
		_G.TRP3_InterfaceIconIDs = setmetatable({}, { __index = function(_, key) return key; end });
		_G.AddOn_TotalRP3 = { Enums = { ROLEPLAY_EXPERIENCE = setmetatable({}, { __index = function(_, key) return key; end }) } };

		SpecHelper.LoadFile("totalRP3/Core/ProfileUtil.lua", "totalRP3", TRP3_API);
	end);

	before_each(function()
		_G.TRP3_EncodingUtil = { DecodeAce = spy.new(function() end), DecodePEM = spy.new(function() end) };
		_G.C_EncodingUtil = {
			DecompressString = function(data) return data; end,
			DeserializeCBOR = function() return { 166, "id", {} }; end,
		};
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
		assert.are.equal("PR_IMPORT_ERROR_UNRECOGNIZED_FORMAT", reportedError);

		_, reportedError = TRP3_ProfileUtil.DeserializeProfile("-----BEGIN TRP3 PROFILE-----\nQUJD");
		assert.are.equal("PR_IMPORT_ERROR_UNRECOGNIZED_FORMAT", reportedError);
	end);

	it("reports a malformed older export as unrecognized", function()
		TRP3_EncodingUtil.DecodeAce = spy.new(function() error("Supplied data is malformed"); end);
		local _, reportedError = TRP3_ProfileUtil.DeserializeProfile("^1^Tbroken");
		assert.are.equal("PR_IMPORT_ERROR_UNRECOGNIZED_FORMAT", reportedError);
	end);

	it("returns the flavor from the PEM headers", function()
		TRP3_EncodingUtil.DecodePEM = function() return "TRP3 PROFILE", "data", { Flavor = "Forever" }; end;
		local _, _, _, flavor = TRP3_ProfileUtil.DeserializeProfile("-----BEGIN TRP3 PROFILE-----");
		assert.are.equal("Forever", flavor);
	end);

	it("assumes Retail when the export has no flavor", function()
		TRP3_EncodingUtil.DecodePEM = function() return "TRP3 PROFILE", "data", {}; end;
		local _, _, _, flavor = TRP3_ProfileUtil.DeserializeProfile("-----BEGIN TRP3 PROFILE-----");
		assert.are.equal("Retail", flavor);
	end);
end);
