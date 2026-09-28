-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local SpecHelper = require("SpecHelper");

insulate("RemoveUnsharedFields", function()
	setup(function()
		-- Only read by the file-level tables in ProfileUtil.lua.
		_G.TRP3_API = { loc = setmetatable({}, { __index = function(_, key) return key; end }) };
		_G.TRP3_InterfaceIcons = setmetatable({}, { __index = function(_, key) return key; end });
		_G.AddOn_TotalRP3 = { Enums = { ROLEPLAY_EXPERIENCE = setmetatable({}, { __index = function(_, key) return key; end }) } };

		SpecHelper.LoadFile("totalRP3/Core/ProfileUtil.lua", "totalRP3", TRP3_API);
	end);

	it("removes the owner's notes and relations", function()
		local profile = {
			notes = { ["0123456789ABCDEF"] = "Owes me gold" },
			relation = { ["0123456789ABCDEF"] = "FRIEND" },
		};

		TRP3_ProfileUtil.RemoveUnsharedFields(profile);

		assert.is_nil(profile.notes);
		assert.is_nil(profile.relation);
	end);

	it("removes fields it does not know about", function()
		local profile = { profileName = "Main", player = {}, someAddonData = { secret = true } };

		TRP3_ProfileUtil.RemoveUnsharedFields(profile);

		assert.is_nil(profile.someAddonData);
	end);

	it("keeps the profile name and player data", function()
		local profile = { profileName = "Main", player = { characteristics = { FN = "Elly" } }, notes = {} };

		TRP3_ProfileUtil.RemoveUnsharedFields(profile);

		assert.are.same({ profileName = "Main", player = { characteristics = { FN = "Elly" } } }, profile);
	end);
end);
