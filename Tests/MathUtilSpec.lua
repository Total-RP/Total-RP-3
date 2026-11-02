-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local Environment = require("Environment");

Environment.LoadAddOn();

describe("NormalizeZero", function()
	it("converts negative zero to positive zero", function()
		local negativeZero = tonumber("-0");
		assert.are.equal(-math.huge, 1 / negativeZero);

		local value = TRP3_MathUtil.NormalizeZero(negativeZero);

		assert.are.equal(math.huge, 1 / value);
		assert.are.equal("0", tostring(value));
		assert.are.equal("0.00", string.format("%.2f", value));
	end);

	it("preserves positive zero", function()
		assert.are.equal(math.huge, 1 / TRP3_MathUtil.NormalizeZero(0));
	end);

	it("preserves nonzero numbers", function()
		assert.are.equal(3, TRP3_MathUtil.NormalizeZero(3));
		assert.are.equal(-2.5, TRP3_MathUtil.NormalizeZero(-2.5));
	end);
end);
