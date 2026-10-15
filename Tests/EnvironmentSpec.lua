-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local Environment = require("Environment");

describe("Test environment", function()
	it("loads the addon under the Standard game type", function()
		local addon = Environment.LoadAddOn("Standard");
		assert.are.equal(addon, TRP3_API);
	end);

	it("loads the addon under the Forever game type", function()
		local addon = Environment.LoadAddOn("Forever");
		assert.are.equal(addon, TRP3_API);
	end);

	it("loads the addon under the Vanilla game type", function()
		local addon = Environment.LoadAddOn("Vanilla");
		assert.are.equal(addon, TRP3_API);
	end);

	it("loads the addon under the TBC game type", function()
		local addon = Environment.LoadAddOn("TBC");
		assert.are.equal(addon, TRP3_API);
	end);

	it("loads the addon under the Mists game type", function()
		local addon = Environment.LoadAddOn("Mists");
		assert.are.equal(addon, TRP3_API);
	end);

	it("loads addon into an initialized API namespace", function()
		local addon = Environment.LoadAddOn();

		assert.are.equal(addon, TRP3_API);
		assert.is_table(addon.globals);
		assert.is_table(addon.GameEvents);
		assert.is_table(TRP3_InterfaceIconIDs);
		assert.is_string(addon.loc.REG_PLAYER_FIRSTNAME);
	end);
end);
