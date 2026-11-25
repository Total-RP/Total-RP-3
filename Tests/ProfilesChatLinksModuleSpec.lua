-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local Environment = require("Environment");

insulate("Importing profiles from chat links", function()
	local importProfileButton;
	local existingNames;
	local importedName;

	before_each(function()
		local addon = Environment.LoadAddOn();
		local onLoaded;
		local actions = {};
		local module = {};

		existingNames = {};
		importedName = nil;

		function module:NewActionButton(id)
			actions[id] = {};
			return actions[id];
		end

		addon.ChatLinks = { InstantiateModule = function() return module; end };
		stub(addon, "RegisterCallback", function(_, _, callback) onLoaded = callback; end);
		stub(addon.profile, "isProfileNameAvailable", function(name) return not existingNames[name]; end);
		stub(addon.profile, "duplicateProfile", function(_, name) importedName = name; end);
		stub(addon.navigation, "openMainFrame");
		stub(addon.navigation.page, "setPage");
		stub(TRP3_Addon, "TriggerEvent");

		assert(loadfile("totalRP3/Core/ProfilesChatLinksModule.lua"))("totalRP3", addon);
		onLoaded();
		importProfileButton = actions.IMPORT_PLAYER_PROFILE;
	end);

	it("keeps an available profile name", function()
		importProfileButton:OnAnswerCommandReceived({ profile = { profileName = "Bob", player = {} } });
		assert.are.equal("Bob", importedName);
	end);

	it("uses the same numbered suffix as other profile imports", function()
		existingNames = { Bob = true };
		importProfileButton:OnAnswerCommandReceived({ profile = { profileName = "Bob", player = {} } });
		assert.are.equal("Bob (2)", importedName);
	end);

	it("checks successive suffixes without appending them to one another", function()
		existingNames = { Bob = true, ["Bob 2"] = true, ["Bob (2)"] = true, ["Bob (3)"] = true };
		importProfileButton:OnAnswerCommandReceived({ profile = { profileName = "Bob", player = {} } });
		assert.are.equal("Bob (4)", importedName);
	end);

	it("continues numbering an already suffixed profile name", function()
		existingNames = { ["Bob (2)"] = true, ["Bob (3)"] = true };
		importProfileButton:OnAnswerCommandReceived({ profile = { profileName = "Bob (2)", player = {} } });
		assert.are.equal("Bob (4)", importedName);
	end);
end);
