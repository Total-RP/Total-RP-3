-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local _, TRP3_API = ...;

-- TRP3_API imports.
local L = TRP3_API.loc;
local TRP3_Events = TRP3_API.events;
local TRP3_Globals = TRP3_API.globals;

-- Nameplate module table.
local NamePlates = {
	-- Active decorator that is used to customize nameplates.
	decorator = nil,
};

-- Updates a single nameplate for the given unit token, if one exists.
--
-- Return true if a nameplate is successfully updated, or false if not.
function NamePlates.UpdateNamePlateForUnit(unitToken)
	-- Validate the unit token.
	if not NamePlates.IsUnitValid(unitToken) then
		return false;
	end

	-- Grab the decorator if one exists and trigger the update.
	local decorator = NamePlates.GetNamePlateDisplayDecorator();
	if not decorator then
		return false;
	end

	return decorator:UpdateNamePlateForUnit(unitToken);
end

-- Updates all nameplates managed by this module.
function NamePlates.UpdateAllNamePlates()
	local decorator = NamePlates.GetNamePlateDisplayDecorator();
	if not decorator then
		return;
	end

	return decorator:UpdateAllNamePlates();
end

-- Returns the mixin that should be used to provide a nameplate display.
--[[private]] function NamePlates.GetSuggestedNamePlateDisplayDecorator()
	-- Add any supported addons here. The Blizzard one should be a last
	-- resort option.
	if IsAddOnLoaded("Kui_Nameplates") then
		return NamePlates.KuiDecoratorMixin;
	elseif IsAddOnLoaded("Blizzard_NamePlates") then
		return NamePlates.BlizzardDecoratorMixin;
	end

	-- Nothing is supported.
	return nil;
end

-- Returns the decorator in use for the nameplate display.
--[[private]] function NamePlates.GetNamePlateDisplayDecorator()
	return NamePlates.decorator;
end

-- Sets the decorator to use for the nameplate display.
--[[private]] function NamePlates.SetNamePlateDisplayDecorator(decorator)
	NamePlates.decorator = decorator;
end

-- Handler triggered then the game assigns a nameplate unit token.
--[[private]] function NamePlates.OnNamePlateUnitAdded(unitToken)
	-- Issue a request for the profile ahead of notifying the decorator.
	if NamePlates.ShouldRequestUnitProfile(unitToken) then
		NamePlates.RequestUnitProfile(unitToken);
	end

	-- Forward to the active decorator.
	local decorator = NamePlates.GetNamePlateDisplayDecorator();
	if decorator then
		decorator:OnNamePlateUnitAdded(unitToken);
	end
end

-- Handler triggered then the game deactivates a nameplate unit token.
--[[private]] function NamePlates.OnNamePlateUnitRemoved(unitToken)
	-- Forward to the active decorator.
	local decorator = NamePlates.GetNamePlateDisplayDecorator();
	if decorator then
		decorator:OnNamePlateUnitRemoved(unitToken);
	end
end

-- Handler triggered when a configuration setting is changed.
--[[private]] function NamePlates.OnConfigSettingChanged(key, _)
	local shouldRefresh = false;

	-- If color contrast is changed, we should refresh things.
	if key == "increase_color_contrast" then
		shouldRefresh = true;
	end

	-- Otherwise, check for nameplate settings. We've got a lot, so use
	-- a heuristic for this instead of matching them all.
	if strfind(tostring(key), "^nameplates_") then
		shouldRefresh = true;
	end

	-- If we shouldn't refresh, we'll stop now.
	if not shouldRefresh then
		return;
	end

	-- In response to configuration changes update all frames.
	NamePlates.UpdateAllNamePlates();
end

-- Handler triggered when the player mouses over an in-game unit.
--[[private]] function NamePlates.OnMouseOverChanged()
	-- The nameplate API can link mouseover/target/etc. units to frames, so
	-- just validate it.
	if not NamePlates.IsUnitValid("mouseover") then
		return;
	end

	NamePlates.UpdateNamePlateForUnit("mouseover");
end

-- Handler triggered when TRP updates the registry for a named profile.
--[[private]] function NamePlates.OnRegisterDataUpdated(registerID)
	-- Get the unit token associated with the updated profile.
	local unitToken = NamePlates.GetUnitForRegisterID(registerID);
	if not NamePlates.IsUnitValid(unitToken) then
		return;
	end

	NamePlates.UpdateNamePlateForUnit(unitToken);
end

-- Handler triggered when the roleplay status of the character changes, such
-- as from IC to OOC.
--[[private]] function NamePlates.OnRoleplayStatusChanged()
	-- No need to handle status changes if we don't customize based on our
	-- IC/OOC state.
	if not NamePlates.ShouldCustomizeNamePlatesOnlyInCharacter() then
		return;
	end

	-- Otherwise, trigger updates.
	NamePlates.UpdateAllNamePlates();
end

-- Module lifecycle functions.

-- Handler called when the module is being initialized. This is responsible
-- for setting up the base internal state without actually enabling any
-- behaviours.
--[[private]] function NamePlates.OnModuleInitialize()
	-- Register the configuration keys early so we can access them whenever.
	NamePlates.RegisterConfigurationKeys();

	-- Prevent the module from actually being set up further if any
	-- known addon conflicts exists.
	for _, addonName in ipairs(NamePlates.CONFLICTING_ADDONS) do
		local state = GetAddOnEnableState(TRP3_Globals.player, addonName);
		if state == 2 then
			return false, format(L.NAMEPLATES_ERR_ADDON_CONFLICT, addonName);
		end
	end
end

-- Handler called when the module is started up. This is responsible for
-- fully starting the module, registering events and hooks as needed.
--[[private]] function NamePlates.OnModuleStart()
	-- Activate an appropriate decorator based on the environment.
	local decoratorMixin = NamePlates.GetSuggestedNamePlateDisplayDecorator();
	if not decoratorMixin then
		return false, L.NAMEPLATES_ERR_NO_VALID_PROVIDER;
	end

	-- Initialize and activate it.
	local decorator = CreateAndInitFromMixin(decoratorMixin);
	NamePlates.SetNamePlateDisplayDecorator(decorator);

	-- Register events and script handlers.
	local eventFrame = CreateFrame("Frame");
	eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
	eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
	eventFrame:SetScript("OnEvent", function(_, event, ...)
		if event == "NAME_PLATE_UNIT_ADDED" then
			NamePlates.OnNamePlateUnitAdded(...);
		elseif event == "NAME_PLATE_UNIT_REMOVED" then
			NamePlates.OnNamePlateUnitRemoved(...);
		end
	end);

	-- Register internal events.
	TRP3_Events.registerCallback("MOUSE_OVER_CHANGED", NamePlates.OnMouseOverChanged);
	TRP3_Events.registerCallback("REGISTER_DATA_UPDATED", NamePlates.OnRegisterDataUpdated);
	TRP3_Events.registerCallback("CONFIG_SETTING_CHANGED", NamePlates.OnConfigSettingChanged);
	TRP3_Events.registerCallback("ROLEPLAY_STATUS_CHANGED", NamePlates.OnRoleplayStatusChanged);

	-- Set up a timer to periodically prune the cooldown table.
	C_Timer.NewTicker(30, NamePlates.PruneUnitRequestCooldowns);

	-- Install the configuration UI.
	NamePlates.RegisterConfigurationUI();

	-- Trigger an update of all nameplates.
	NamePlates.UpdateAllNamePlates();
end

-- Module exports.
AddOn_TotalRP3.NamePlates = NamePlates;

-- Module registration.
TRP3_API.module.registerModule({
	name        = L.NAMEPLATES_MODULE_NAME,
	description = L.NAMEPLATES_MODULE_DESCRIPTION,
	version     = 1,
	id          = "NamePlates",
	onInit      = NamePlates.OnModuleInitialize,
	onStart     = NamePlates.OnModuleStart,
	minVersion  = 70,
});
