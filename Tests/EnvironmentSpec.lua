-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local Environment = require("Environment");

describe("Test environment", function()
	it("loads addon into an initialized API namespace", function()
		local addon = Environment.LoadAddOn();

		assert.are.equal(addon, TRP3_API);
		assert.is_table(addon.globals);
		assert.is_table(addon.GameEvents);
		assert.is_table(TRP3_InterfaceIconIDs);
		assert.is_string(addon.loc.REG_PLAYER_FIRSTNAME);
	end);
end);
