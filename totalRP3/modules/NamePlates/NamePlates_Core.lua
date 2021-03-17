--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local function SafeSet(table, key, value)
	if key ~= nil then
		table[key] = value;
	end
end

local function ShouldDisableOutOfCharacter()
	return TRP3_API.configuration.getValue("NamePlates_DisableOutOfCharacter");
end

local function ShouldDisableOutOfCharacterUnits()
	return TRP3_API.configuration.getValue("NamePlates_DisableOutOfCharacterUnits");
end

local function ShouldDisableInCombat()
	return TRP3_API.configuration.getValue("NamePlates_DisableInCombat");
end

local function ShouldHideNonRoleplayUnits()
	return TRP3_API.configuration.getValue("NamePlates_HideNonRoleplayUnits");
end

local function ShouldHideOutOfCharacterUnits()
	return TRP3_API.configuration.getValue("NamePlates_HideOutOfCharacterUnits");
end

local function ShouldCustomizeNames()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeNames");
end

local function ShouldCustomizeNameColors()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeNameColors");
end

local function ShouldCustomizeTitles()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeTitles");
end

local function ShouldCustomizeIcons()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeIcons");
end

local function ShouldCustomizeHealthColors()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeHealthColors");
end

local function ShouldCustomizeRoleplayStatus()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeRoleplayStatus");
end

local function ShouldCustomizeFullTitles()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeFullTitles");
end

local function ShouldRequestProfiles()
	return TRP3_API.configuration.getValue("NamePlates_EnableActiveQuery");
end

local function GetUnitRegisterID(unitToken)
	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
	local registerID;

	if unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		registerID = TRP3_API.utils.str.getUnitID(unitToken);
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
		registerID = TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType);
	end

	if registerID and string.find(registerID, UNKNOWNOBJECT, 1, true) == 1 then
		-- The player that owns this profile isn't yet known to the client.
		registerID = nil;
	end

	return registerID;
end

local function GetUnitRoleplayStatus(unitToken)
	local player;

	if not unitToken then
		return nil;
	elseif UnitIsUnit(unitToken, "player") then
		player = AddOn_TotalRP3.Player.GetCurrentUser();
	elseif UnitIsPlayer(unitToken) then
		player = AddOn_TotalRP3.Player.CreateFromUnit(unitToken);
	else
		-- For companion units query the OOC state of their owner.
		local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
		local characterID = select(2, TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType));

		if characterID then
			if characterID == TRP3_API.globals.player_id then
				player = AddOn_TotalRP3.Player.GetCurrentUser();
			else
				player = AddOn_TotalRP3.Player.CreateFromCharacterID(characterID);
			end
		end
	end

	if not player then
		return nil;
	else
		return player:GetRoleplayStatus();
	end
end

local function IsUnitOutOfCharacter(unitToken)
	local roleplayStatus = GetUnitRoleplayStatus(unitToken);
	return roleplayStatus == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
end

local function ShouldCustomizeUnitNamePlate(unitToken)
	if not unitToken or (not UnitIsPlayer(unitToken) and not UnitIsOtherPlayersPet(unitToken)) then
		return false;  -- Unit can't have a roleplay profile.
	elseif UnitIsUnit(unitToken, "player") then
		return false;  -- Never decorate personal nameplates.
	elseif ShouldDisableInCombat() and TRP3_NamePlates.isInCombat then
		return false;  -- Player is in (or about to enter) combat.
	elseif ShouldDisableOutOfCharacter() and IsUnitOutOfCharacter("player") then
		return false;  -- Player is currently OOC.
	elseif ShouldDisableOutOfCharacterUnits() and IsUnitOutOfCharacter(unitToken) then
		return false;  -- Unit is currently OOC.
	else
		return true;
	end
end

local function GetCompanionColorForDisplay(colorHexString)
	if not colorHexString then
		return nil;
	end

	local color = TRP3_API.Ellyb.Color.CreateFromHexa(colorHexString);

	if AddOn_TotalRP3.Configuration.shouldDisplayIncreasedColorContrast() then
		color:LightenColorUntilItIsReadableOnDarkBackgrounds();
	end

	return color;
end

local function GetCharacterColorForDisplay(player, classToken)
	local color = player:GetCustomColorForDisplay();

	if not color then
		color = TRP3_API.Ellyb.ColorManager[classToken];
	end

	return color;
end

local function GetCharacterUnitDisplayInfo(unitToken, characterID)
	local displayInfo = {};

	if characterID and TRP3_API.register.isUnitIDKnown(characterID) then
		local player = AddOn_TotalRP3.Player.CreateFromCharacterID(characterID);
		local classToken = UnitClassBase(unitToken);

		if ShouldCustomizeFullTitles() then
			displayInfo.fullTitle = player:GetFullTitle();
		end

		if ShouldCustomizeHealthColors() then
			displayInfo.healthColor = GetCharacterColorForDisplay(player, classToken);
		end

		if ShouldCustomizeIcons() then
			displayInfo.icon = player:GetCustomIcon();
		end

		if ShouldCustomizeNameColors() then
			displayInfo.nameColor = GetCharacterColorForDisplay(player, classToken);
		end

		if ShouldCustomizeNames() then
			displayInfo.nameText = player:GetFullName();
		end

		if ShouldCustomizeTitles() then
			displayInfo.prefixTitle = player:GetTitle();
		end

		if ShouldCustomizeRoleplayStatus() then
			displayInfo.roleplayStatus = player:GetRoleplayStatus();
		end

		if ShouldHideOutOfCharacterUnits() then
			displayInfo.shouldHide = displayInfo.shouldHide or not player:IsInCharacter();
		end
	else
		-- Unit has no profile and so is a non-roleplay unit.
		displayInfo.shouldHide = ShouldHideNonRoleplayUnits();
	end

	return displayInfo;
end

local function GetCompanionUnitDisplayInfo(unitToken, companionFullID)
	local displayInfo = {};

	local profile = TRP3_API.companions.register.getCompanionProfile(companionFullID);

	if profile and profile.data then
		if ShouldCustomizeTitles() then
			displayInfo.fullTitle = profile.data.TI;
		end

		if ShouldCustomizeHealthColors() then
			displayInfo.healthColor = GetCompanionColorForDisplay(profile.data.NH);
		end

		if ShouldCustomizeIcons() then
			displayInfo.icon = profile.data.IC;
		end

		if ShouldCustomizeNameColors() then
			displayInfo.nameColor = GetCompanionColorForDisplay(profile.data.NH);
		end

		if ShouldCustomizeNames() then
			displayInfo.nameText = profile.data.NA;
		end

		if ShouldCustomizeRoleplayStatus() then
			displayInfo.roleplayStatus = GetUnitRoleplayStatus(unitToken);
		end

		if ShouldHideNonRoleplayUnits() then
			displayInfo.shouldHide = displayInfo.shouldHide or IsUnitOutOfCharacter(unitToken);
		end
	else
		-- Unit has no profile and so is a non-roleplay unit.
		displayInfo.shouldHide = ShouldHideNonRoleplayUnits();
	end

	return displayInfo;
end

--
-- Note that the contents of the TRP3_NamePlates table is intended for private
-- internal use by the addon and shouldn't be assumed stable.
--
-- Public API will be added to the AddOn_TotalRP3 table at a later date.
--

local TRP3_NamePlates = {};

function TRP3_NamePlates:OnModuleInitialize()
	self.callbacks = LibStub:GetLibrary("CallbackHandler-1.0"):New(self);
	self.isInCombat = InCombatLockdown();
	self.unitRegisterIDs = {};

	-- Register configuration keys and the settings page early on so that
	-- everything can access it.

	for _, setting in pairs(TRP3_NamePlatesUtil.Configuration) do
		TRP3_API.configuration.registerConfigKey(setting.key, setting.default);
	end

	TRP3_API.configuration.registerConfigurationPage(TRP3_NamePlatesUtil.ConfigurationPage);
end

function TRP3_NamePlates:OnModuleEnable()
	-- External code can define the below global before the PLAYER_LOGIN event
	-- fires to disable all of our integrations.

	if TRP3_DISABLE_NAMEPLATES then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	TRP3_API.Ellyb.GameEvents.registerCallback("NAME_PLATE_UNIT_ADDED", function(...) return self:OnNamePlateUnitAdded(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("NAME_PLATE_UNIT_REMOVED", function(...) return self:OnNamePlateUnitRemoved(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("UNIT_NAME_UPDATE", function(...) return self:OnUnitNameUpdate(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("PLAYER_REGEN_DISABLED", function(...) return self:OnPlayerRegenDisabled(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("PLAYER_REGEN_ENABLED", function(...) return self:OnPlayerRegenEnabled(...); end);

	TRP3_API.Events.registerCallback("CONFIGURATION_CHANGED", function(...) return self:OnConfigurationChanged(...); end);
	TRP3_API.Events.registerCallback("REGISTER_DATA_UPDATED", function(...) return self:OnRegisterDataUpdated(...); end);
end

function TRP3_NamePlates:OnNamePlateUnitAdded(unitToken)
	self:UpdateRegisterIDForUnit(unitToken);
	self:UpdateNamePlateForUnit(unitToken);
end

function TRP3_NamePlates:OnNamePlateUnitRemoved(unitToken)
	self:ClearRegisterIDForUnit(unitToken);
	self:UpdateNamePlateForUnit(unitToken);
end

function TRP3_NamePlates:OnUnitNameUpdate(unitToken)
	if string.find(unitToken, "^nameplate[0-9]+$") then
		self:UpdateRegisterIDForUnit(unitToken);
		self:UpdateNamePlateForUnit(unitToken);
	end
end

function TRP3_NamePlates:OnPlayerRegenDisabled()
	self.isInCombat = true;
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnPlayerRegenEnabled()
	self.isInCombat = false;
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnConfigurationChanged(key)
	if string.find(key, "^NamePlates_") then
		self:UpdateAllNamePlates();
	end
end

function TRP3_NamePlates:OnRegisterDataUpdated(registerID)
	if registerID == TRP3_API.globals.player_id then
		self:UpdateAllNamePlates();
	else
		self:UpdateNamePlateForRegisterID(registerID);
	end
end

function TRP3_NamePlates:GetUnitDisplayInfo(unitToken)
	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
	local registerID = GetUnitRegisterID(unitToken);

	if not ShouldCustomizeUnitNamePlate(unitToken) then
		return nil;  -- Customizations disabled for this unit.
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		return GetCharacterUnitDisplayInfo(unitToken, registerID);
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
		return GetCompanionUnitDisplayInfo(unitToken, registerID);
	end
end

function TRP3_NamePlates:RequestUnitProfile(unitToken)
	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);

	if unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		local characterID = TRP3_API.utils.str.getUnitID(unitToken);
		TRP3_API.r.sendQuery(characterID);
		TRP3_API.r.sendMSPQuery(characterID);
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
		local characterID = select(2, TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType));
		TRP3_API.r.sendQuery(characterID);
	end
end

function TRP3_NamePlates:UpdateAllNamePlates()
	for _, nameplate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitToken = nameplate.namePlateUnitToken;

		if unitToken then
			self:UpdateNamePlateForUnit(unitToken);
		end
	end
end

function TRP3_NamePlates:UpdateNamePlateForUnit(unitToken)
	local nameplate = C_NamePlate.GetNamePlateForUnit(unitToken);

	if nameplate then
		local displayInfo = self:GetUnitDisplayInfo(unitToken);
		TRP3_NamePlates.callbacks:Fire("OnNamePlateDataUpdated", nameplate, unitToken, displayInfo);
	end
end

function TRP3_NamePlates:UpdateNamePlateForRegisterID(registerID)
	local unitToken = TRP3_NamePlates.unitRegisterIDs[registerID];

	if unitToken then
		return self:UpdateNamePlateForUnit(unitToken);
	end
end

function TRP3_NamePlates:ClearRegisterIDForUnit(unitToken)
	-- This removes the two-way mapping for the unit token <=> register ID.
	SafeSet(TRP3_NamePlates.unitRegisterIDs, TRP3_NamePlates.unitRegisterIDs[unitToken], nil);
	SafeSet(TRP3_NamePlates.unitRegisterIDs, unitToken, nil);
end

function TRP3_NamePlates:UpdateRegisterIDForUnit(unitToken)
	local registerID = GetUnitRegisterID(unitToken);

	if registerID and TRP3_NamePlates.unitRegisterIDs[unitToken] ~= registerID and ShouldRequestProfiles() then
		self:RequestUnitProfile(unitToken);
	end

	-- This updates the two-way mapping for the unit token <=> register ID.
	SafeSet(TRP3_NamePlates.unitRegisterIDs, TRP3_NamePlates.unitRegisterIDs[unitToken], nil);
	SafeSet(TRP3_NamePlates.unitRegisterIDs, unitToken, registerID);
	SafeSet(TRP3_NamePlates.unitRegisterIDs, registerID, unitToken);
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_nameplates",
	name = L.NAMEPLATES_MODULE_NAME,
	description = L.NAMEPLATES_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 92,
	onInit = function() return TRP3_NamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_NamePlates:OnModuleEnable(); end,
});

_G.TRP3_NamePlates = TRP3_NamePlates;
