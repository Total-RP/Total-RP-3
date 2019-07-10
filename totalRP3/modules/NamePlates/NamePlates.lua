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
local TRP3_Register = TRP3_API.register;

-- Local declarations.
local GetNamePlateDisplayDecorator;
local OnConfigSettingChanged;
local OnModuleInitialize;
local OnModuleStart;
local OnMouseOverChanged;
local OnNamePlateUnitAdded;
local OnNamePlateUnitRemoved;
local OnRegisterDataUpdated;
local OnRoleplayStatusChanged;
local SetNamePlateDisplayDecorator;

-- List of addon names that conflict with this module. If these are enabled
-- for the current character on initialization of this module, we won't
-- set up customizations.
local CONFLICTING_ADDONS = {
	"Kui_Nameplates", -- No errors, however modifications aren't visible.
	"Plater",         -- Untested. Assuming it won't work.
};

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
	local decorator = GetNamePlateDisplayDecorator();
	if not decorator then
		return false;
	end

	return decorator:UpdateNamePlateForUnit(unitToken);
end

-- Updates all nameplates managed by this module.
function NamePlates.UpdateAllNamePlates()
	local decorator = GetNamePlateDisplayDecorator();
	if not decorator then
		return;
	end

	return decorator:UpdateAllNamePlates();
end

-- Private module functions.

-- Returns the decorator in use for the nameplate display.
function GetNamePlateDisplayDecorator()
	return NamePlates.decorator;
end

-- Sets the decorator to use for the nameplate display.
function SetNamePlateDisplayDecorator(decorator)
	NamePlates.decorator = decorator;
end

-- Game integration handlers.

-- Handler triggered then the game assigns a nameplate unit token.
function OnNamePlateUnitAdded(unitToken)
	-- Issue a request for the profile ahead of notifying the decorator.
	if NamePlates.ShouldRequestUnitProfile(unitToken) then
		NamePlates.RequestUnitProfile(unitToken);
	end

	-- Forward to the active decorator.
	local decorator = GetNamePlateDisplayDecorator();
	if decorator then
		decorator:OnNamePlateUnitAdded(unitToken);
	end
end

-- Handler triggered then the game deactivates a nameplate unit token.
function OnNamePlateUnitRemoved(unitToken)
	-- Forward to the active decorator.
	local decorator = GetNamePlateDisplayDecorator();
	if decorator then
		decorator:OnNamePlateUnitRemoved(unitToken);
	end
end

-- TRP integration handlers.

-- Handler triggered when a configuration setting is changed.
function OnConfigSettingChanged(key, _)
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
function OnMouseOverChanged()
	-- The nameplate API can link mouseover/target/etc. units to frames, so
	-- just validate it.
	if not NamePlates.IsUnitValid("mouseover") then
		return;
	end

	NamePlates.UpdateNamePlateForUnit("mouseover");
end

-- Handler triggered when TRP updates the registry for a named profile.
function OnRegisterDataUpdated(registerID)
	-- Get the unit token associated with the updated profile.
	local unitToken = NamePlates.GetUnitForRegisterID(registerID);
	if not NamePlates.IsUnitValid(unitToken) then
		return;
	end

	NamePlates.UpdateNamePlateForUnit(unitToken);
end

-- Handler triggered when the roleplay status of the character changes, such
-- as from IC to OOC.
function OnRoleplayStatusChanged()
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
function OnModuleInitialize()
	-- Prevent the module from actually being set up if there's any of the
	-- conflicting addons installed.
	for _, addonName in ipairs(CONFLICTING_ADDONS) do
		local state = GetAddOnEnableState(TRP3_Globals.player, addonName);
		if state == 2 then
			return false, format(L.NAMEPLATES_ERR_ADDON_CONFLICT, addonName);
		end
	end

	-- Register the configuration keys early so we can access them whenever.
	NamePlates.RegisterConfigurationKeys();
end

-- Handler called when the module is started up. This is responsible for
-- fully starting the module, registering events and hooks as needed.
function OnModuleStart()
	-- Activate an appropriate decorator based on the environment.
	local decoratorMixin;

	if IsAddOnLoaded("Blizzard_NamePlates") then
		-- Blizzard_NamePlate should be a last resort. Add custom integrations
		-- above this one.
		decoratorMixin = NamePlates.BlizzardDecoratorMixin;
	else
		return false, L.NAMEPLATES_ERR_NO_VALID_PROVIDER;
	end

	local decorator = CreateAndInitFromMixin(decoratorMixin);
	SetNamePlateDisplayDecorator(decorator);

	-- Register events and script handlers.
	local eventFrame = CreateFrame("Frame");
	eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
	eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
	eventFrame:SetScript("OnEvent", function(_, event, ...)
		if event == "NAME_PLATE_UNIT_ADDED" then
			OnNamePlateUnitAdded(...);
		elseif event == "NAME_PLATE_UNIT_REMOVED" then
			OnNamePlateUnitRemoved(...);
		end
	end);

	-- Register internal events.
	TRP3_Events.registerCallback("MOUSE_OVER_CHANGED", OnMouseOverChanged);
	TRP3_Events.registerCallback("REGISTER_DATA_UPDATED", OnRegisterDataUpdated);
	TRP3_Events.registerCallback("CONFIG_SETTING_CHANGED", OnConfigSettingChanged);
	TRP3_Events.registerCallback("ROLEPLAY_STATUS_CHANGED", OnRoleplayStatusChanged);

	-- Set up a timer to periodically prune the cooldown table.
	C_Timer.NewTicker(30, NamePlates.PruneUnitRequestCooldowns);

	-- Install the configuration UI.
	NamePlates.RegisterConfigurationUI();
end

-- Module exports.
AddOn_TotalRP3.NamePlates = NamePlates;

-- Module registration.
TRP3_API.module.registerModule({
	name        = L.NAMEPLATES_MODULE_NAME,
	description = L.NAMEPLATES_MODULE_DESCRIPTION,
	version     = 1,
	id          = "NamePlates",
	onInit      = OnModuleInitialize,
	onStart     = OnModuleStart,
	minVersion  = 70,
});
