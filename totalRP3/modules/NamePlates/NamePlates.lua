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
local TRP3_UI = TRP3_API.ui;
local TRP3_Utils = TRP3_API.utils;

-- Local declarations.
local GetNamePlateDisplayDecorator;
local GetRegisterIDForUnit;
local GetRegisterIDRequestCooldown;
local OnConfigSettingChanged;
local OnModuleInitialize;
local OnModuleStart;
local OnMouseOverChanged;
local OnNamePlateUnitAdded;
local OnNamePlateUnitRemoved;
local OnRegisterDataUpdated;
local OnRoleplayStatusChanged;
local PruneRegisterIDRequestCooldowns;
local SetNamePlateDisplayDecorator;
local SetRegisterIDRequestCooldown;
local UnitIsCombatPet;

-- Cooldown between queries for the same profile from nameplate activity
-- alone, in seconds. Defaults to 5 minutes.
--
-- This should be higher than the cooldown imposed by protocols because
-- nameplates are generally more numerous than tooltips or the number of
-- people you can actively mouse-over.
local ACTIVE_QUERY_COOLDOWN = 300;

-- List of addon names that conflict with this module. If these are enabled
-- for the current character on initialization of this module, we won't
-- set up customizations.
local CONFLICTING_ADDONS = {
	"Kui_Nameplates", -- No errors, however modifications aren't visible.
	"Plater",         -- Untested. Assuming it won't work.
};

-- Nameplate module table.
local NamePlates = {
	-- Mapping of register IDs ("unit IDs") to request cooldowns.
	registerIDCooldowns = {},
	-- Active decorator that is used to customize nameplates.
	decorator = nil,
};

-- Returns true if the given unit token is valid, and refers to either a
-- player or a combat pet.
--
-- The unit token may or may not have a nameplate assigned; this function
-- only tests if it's capable of having one.
function NamePlates.IsValidUnit(unitToken)
	-- Obviously invalid tokens are invalid. Who knew.
	if not unitToken or unitToken == "" then
		return false;
	end

	-- Validate the type of unit it represents.
	if not UnitIsPlayer(unitToken) and not UnitIsCombatPet(unitToken) then
		return false;
	end

	return true;
end

-- Returns true if a request for the given unit token can be issued.
--
-- This will return false for invalid unit tokens, or in cases where
-- actively requesting units is disabled.
function NamePlates.ShouldRequestUnitProfile(unitToken)
	-- Don't allow requests if customizations are turned off. This is more
	-- an optimization, since they wouldn't be shown anyway.
	if not NamePlates.ShouldCustomizeNamePlates() then
		return false;
	end

	-- Don't allow requests if they themselves are disabled.
	if not NamePlates.ShouldActivelyQueryProfiles() then
		return false;
	end

	-- Validate the unit token.
	if not NamePlates.IsValidUnit(unitToken) then
		return false;
	end

	-- Get the register ID for this unit and see if they have a profile.
	local registerID = GetRegisterIDForUnit(unitToken);
	if not registerID then
		return false;
	end

	if TRP3_Register.isUnitIDKnown(registerID)
	and TRP3_Register.hasProfile(registerID) then
		return false;
	end

	-- Otherwise, check if we've sent a request too recently.
	local cooldown = GetRegisterIDRequestCooldown(registerID);
	if cooldown and (GetTime() - cooldown) < ACTIVE_QUERY_COOLDOWN then
		return false;
	end

	-- Otherwise, allow requests to occur.
	return true;
end

-- Requests a profile for the given unit token.
--
-- Returns true if a request was issued, or false if no request was issued.
--
-- This function will do nothing if ShouldRequestUnitProfile would itself
-- return false.
function NamePlates.RequestUnitProfile(unitToken)
	-- Don't dispatch a request if we shouldn't do so.
	if not NamePlates.ShouldRequestUnitProfile(unitToken) then
		return false;
	end

	-- Get the register ID for this unit token, if available.
	local registerID = GetRegisterIDForUnit(unitToken);
	if not registerID then
		return false;
	end

	-- Issue requests via both TRP and MSP protocols. MSP is limited to
	-- players only, so don't send anything for pets out.
	if UnitIsPlayer(unitToken) then
		TRP3_API.r.sendQuery(registerID);
		TRP3_API.r.sendMSPQueryIfAppropriate(registerID);
	elseif UnitIsCombatPet(unitToken) then
		-- Queries for companions take a little bit extra effort.
		local ownerID = TRP3_Utils.str.companionIDToInfo(registerID);
		if TRP3_Register.isUnitIDKnown(ownerID) then
			TRP3_API.r.sendQuery(ownerID);
		end
	else
		-- Unknown unit type.
		return false;
	end

	-- Debounce further requests for a significant amount of time.
	local cooldown = GetTime() + ACTIVE_QUERY_COOLDOWN;
	SetRegisterIDRequestCooldown(registerID, cooldown);

	return true;
end

-- Updates a single nameplate for the given unit token, if one exists.
--
-- Return true if a nameplate is successfully updated, or false if not.
function NamePlates.UpdateNamePlateForUnit(unitToken)
	-- Validate the unit token.
	if not NamePlates.IsValidUnit(unitToken) then
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

-- Returns the TRP3 API internal "unit ID" for a given unit token. This will
-- typically be a "name-realm" string for a player, or a "name-realm_pet"
-- for a companion pet.
--
-- Due to the similarity of unit tokens ("player", "target", ...) and the
-- internal "unit ID" moniker, the nameplate module refers to these as
-- register IDs.
function GetRegisterIDForUnit(unitToken)
	if UnitIsPlayer(unitToken) then
		return TRP3_Utils.str.getUnitID(unitToken);
	elseif UnitIsCombatPet(unitToken) then
		local companionType = TRP3_UI.misc.TYPE_PET;
		return TRP3_UI.misc.getCompanionFullID(unitToken, companionType);
	end
end

-- Returns the cooldown for requests for a given register ID, or nil if
-- no cooldown is set.
function GetRegisterIDRequestCooldown(unitToken)
	local registerIDCooldowns = NamePlates.registerIDCooldowns;
	return registerIDCooldowns[unitToken];
end

-- Sets the cooldown for future requests for a given register ID. The given
-- value should be a number in seconds, or nil to unset the cooldown.
function SetRegisterIDRequestCooldown(unitToken, cooldown)
	local registerIDCooldowns = NamePlates.registerIDCooldowns;
	registerIDCooldowns[unitToken] = cooldown;
end

-- Prunes the table of cooldowns for requests, removing all expired request
-- cooldowns.
function PruneRegisterIDRequestCooldowns()
	local registerIDCooldowns = NamePlates.registerIDCooldowns;
	for registerID, cooldown in pairs(registerIDCooldowns) do
		if (GetTime() - cooldown) >= ACTIVE_QUERY_COOLDOWN then
			SetRegisterIDRequestCooldown(registerID, nil);
		end
	end
end

-- Returns the decorator in use for the nameplate display.
function GetNamePlateDisplayDecorator()
	return NamePlates.decorator;
end

-- Sets the decorator to use for the nameplate display.
function SetNamePlateDisplayDecorator(decorator)
	NamePlates.decorator = decorator;
end

-- Returns true if the given unit token refers to a combat companion pet.
--
-- Returns false if the unit is invalid, refers to a player, or is a
-- battle pet companion.
function UnitIsCombatPet(unitToken)
	-- Ensure battle pets don't accidentally pass this test, in case one
	-- day they get nameplates added for no reason.
	if UnitIsBattlePetCompanion(unitToken) then
		return false;
	end

	return UnitIsOtherPlayersPet(unitToken) or UnitIsUnit(unitToken, "pet");
end

-- Game integration handlers.

-- Handler triggered then the game assigns a nameplate unit token.
function OnNamePlateUnitAdded(unitToken)
	-- Forward to the active decorator.
	local decorator = GetNamePlateDisplayDecorator();
	if decorator then
		decorator:OnNamePlateUnitAdded(unitToken);
	end

	-- Issue a request for the profile.
	NamePlates.RequestUnitProfile(unitToken);

	-- Update the unit frame for them immediately with whatever data we have.
	NamePlates.UpdateNamePlateForUnit(unitToken);
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
	local unitToken = "mouseover";
	if not NamePlates.IsValidUnit(unitToken) then
		return;
	end

	NamePlates.UpdateNamePlateForUnit(unitToken);
end

-- Handler triggered when TRP updates the registry for a named profile.
function OnRegisterDataUpdated(registerID)
	-- Trigger an update for the nameplate linked to this ID, if one exists.
	for _, frame in pairs(C_NamePlate.GetNamePlates()) do
		local frameRegisterID = GetRegisterIDForUnit(frame.namePlateUnitToken);
		if registerID == frameRegisterID then
			NamePlates.UpdateNamePlateForUnit(frame.namePlateUnitToken);
			return;
		end
	end
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
	C_Timer.NewTicker(30, PruneRegisterIDRequestCooldowns);

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
