-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:open",
	name = L.LAUNCHER_ACTION_OPEN,

	Activate = function()
		TRP3_API.navigation.switchMainFrame();
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:toolbar",
	name = L.LAUNCHER_ACTION_TOOLBAR,

	Activate = function()
		if TRP3_API.toolbar then
			TRP3_API.toolbar.switch();
		end
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:status",
	name = L.LAUNCHER_ACTION_STATUS,

	Activate = function()
		local player = AddOn_TotalRP3.Player.GetCurrentUser();

		if player:IsInCharacter() then
			player:SetRoleplayStatus(AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER);
			TRP3_Addon:Print(L.AUTOMATION_ACTION_ROLEPLAY_STATUS_CHANGED_OOC);
		else
			player:SetRoleplayStatus(AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER);
			TRP3_Addon:Print(L.AUTOMATION_ACTION_ROLEPLAY_STATUS_CHANGED_IC);
		end
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:settings",
	name = L.LAUNCHER_ACTION_SETTINGS,

	Activate = function()
		TRP3_API.navigation.openMainFrame();
		TRP3_API.navigation.menu.selectMenu("main_90_config");
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:directory",
	name = L.LAUNCHER_ACTION_DIRECTORY,

	Activate = function()
		TRP3_API.navigation.openMainFrame();
		TRP3_API.navigation.menu.selectMenu("main_30_register");
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:profiles",
	name = L.LAUNCHER_ACTION_PROFILES,

	Activate = function()
		TRP3_API.navigation.openMainFrame();
		TRP3_API.navigation.menu.selectMenu("main_11_profiles");
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:player",
	name = L.LAUNCHER_ACTION_PLAYER,

	Activate = function()
		TRP3_API.navigation.openMainFrame();
		TRP3_API.navigation.menu.selectMenu("main_12_player_character");
	end,
});

--[[
	TODO: Stuff for Sol to do over in ye olde Extended land.

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:extended:container",
	name = L.LAUNCHER_ACTION_TODO,

	Activate = function()
		-- Toggle the visibility of the main container.
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:extended:inventory",
	name = L.LAUNCHER_ACTION_TODO,

	Activate = function()
		-- Open the main window and go to the inventory page.
	end,
});

TRP3_LauncherUtil.RegisterAction({
	id = "trp3:extended:questlog",
	name = L.LAUNCHER_ACTION_TODO,

	Activate = function()
		-- Open the main window and go to the quest log page.
	end,
});

]]--
