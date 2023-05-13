-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- The TRP3_Addon object registered with Ace3 acts as an event registry source
-- for all of our internally triggered events.

TRP3_Addon.Events =
{
	-- Workflow
	WORKFLOW_ON_API = "WORKFLOW_ON_API",
	WORKFLOW_ON_LOAD = "WORKFLOW_ON_LOAD",
	WORKFLOW_ON_LOADED = "WORKFLOW_ON_LOADED",
	WORKFLOW_ON_FINISH = "WORKFLOW_ON_FINISH",

	-- Broadcast
	BROADCAST_CHANNEL_CONNECTING = "BROADCAST_CHANNEL_CONNECTING",
	BROADCAST_CHANNEL_READY = "BROADCAST_CHANNEL_READY",
	BROADCAST_CHANNEL_OFFLINE = "BROADCAST_CHANNEL_OFFLINE",

	-- Navigation
	NAVIGATION_TUTORIAL_REFRESH = "NAVIGATION_TUTORIAL_REFRESH",
	NAVIGATION_RESIZED = "NAVIGATION_RESIZED",

	-- Called when the user changes the page in the main frame.
	PAGE_OPENED = "PAGE_OPENED",

	-- Fired when a config value is modified.
	CONFIGURATION_CHANGED = "CONFIGURATION_CHANGED",

	-- General event when a data changed in a profile of a certain unitID (character or companion).
	REGISTER_DATA_UPDATED = "REGISTER_DATA_UPDATED",

	-- Called when you switch from one profile to another.
	REGISTER_PROFILES_LOADED = "REGISTER_PROFILES_LOADED",

	-- Called when a profile is deleted (character or companion).
	REGISTER_PROFILE_DELETED = "REGISTER_PROFILE_DELETED",

	-- Called when as "About" page is shown.
	REGISTER_ABOUT_READ = "REGISTER_ABOUT_READ",

	-- Called when Wow Event UPDATE_MOUSEOVER_UNIT is fired.
	MOUSE_OVER_CHANGED = "MOUSE_OVER_CHANGED",

	-- Notification for when the players' current roleplay status has changed.
	ROLEPLAY_STATUS_CHANGED = "ROLEPLAY_STATUS_CHANGED",

	-- Notification for when a dice roll is executed.
	DICE_ROLL = "DICE_ROLL",
};

-- TODO: Would prefer to move this to OnInitialize, however that first requires
--       modularizing everything.
TRP3_Addon.callbacks = TRP3_API.InitCallbackRegistryWithEvents(TRP3_Addon, TRP3_Addon.Events);

function TRP3_Addon:TriggerEvent(event, ...)
	assert(self.Events[event], "attempted to trigger an invalid addon event");
	self.callbacks:Fire(event, ...);
end

-- The game event source provides a callback registry-based mechanism for
-- subscribing to and receiving game-triggered events like ADDON_LOADED.

TRP3_API.GameEvents = {};

local GameEventFrame = CreateFrame("Frame", "TRP3_GameEventFrame");
local GameEventRegistry = TRP3_API.InitCallbackRegistry(TRP3_API.GameEvents);

function GameEventFrame:OnEvent(...)
	GameEventRegistry:Fire(...);
end

GameEventFrame:SetScript("OnEvent", GameEventFrame.OnEvent);

function TRP3_API.GameEvents:OnEventUsed(event)
	GameEventFrame:RegisterEvent(event);
end

function TRP3_API.GameEvents:OnEventUnused(event)
	GameEventFrame:UnregisterEvent(event);
end

function TRP3_API.GameEvents:IsEventValid(event)
	return C_EventUtils == nil or C_EventUtils.IsEventValid(event);
end

-- TODO: Can this move elsewhere?

do
	local status = nil;

	local function OnRegisterDataUpdated()
		local current = AddOn_TotalRP3.Player.GetCurrentUser():GetRoleplayStatus();

		if status ~= current then
			status = current;
			TRP3_Addon:TriggerEvent("ROLEPLAY_STATUS_CHANGED", status);
		end
	end

	TRP3_API.RegisterCallback(TRP3_Addon, "REGISTER_DATA_UPDATED", OnRegisterDataUpdated);
end
