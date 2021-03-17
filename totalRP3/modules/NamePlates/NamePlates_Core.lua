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

local function GetCharacterUnitDisplayInfo(unitToken, characterID)
	-- If the character has no profile, we want to explicitly not return any
	-- information in such a case to make it clear to decorators that
	-- this unit has no known roleplay attributes.

	if not characterID or not TRP3_API.register.isUnitIDKnown(characterID) then
		return nil;
	end

	local player = AddOn_TotalRP3.Player.CreateFromCharacterID(characterID);
	local classToken = UnitClassBase(unitToken);
	local displayInfo = {};

	if TRP3_NamePlatesUtil.ShouldCustomizeFullTitles() then
		displayInfo.fullTitle = player:GetFullTitle();
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeHealthColors() then
		displayInfo.healthColor = player:GetCustomColorForDisplay();

		if not displayInfo.healthColor then
			displayInfo.healthColor = CreateColor(GetClassColor(classToken));
		end
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeIcons() then
		displayInfo.icon = player:GetCustomIcon();
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeNameColors() then
		displayInfo.nameColor = player:GetCustomColorForDisplay();

		if not displayInfo.nameColor then
			displayInfo.nameColor = CreateColor(GetClassColor(classToken));
		end
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeNames() then
		displayInfo.nameText = player:GetFullName();
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeTitles() then
		displayInfo.prefixTitle = player:GetTitle();
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeRoleplayStatus() then
		displayInfo.roleplayStatus = player:GetRoleplayStatus();
	end

	return displayInfo;
end

local function GetCompanionUnitDisplayInfo(unitToken, companionFullID) -- luacheck: ignore 212 (unused unitToken)
	local profile = TRP3_API.companions.register.getCompanionProfile(companionFullID);

	if not profile or not profile.data then
		return nil;
	end

	-- Color data is a bit annoying for companions, so do it early on.

	local color;

	if profile.data.NH then
		color = TRP3_API.Ellyb.Color.CreateFromHexa(profile.data.NH);

		if AddOn_TotalRP3.Configuration.shouldDisplayIncreasedColorContrast() then
			color:LightenColorUntilItIsReadableOnDarkBackgrounds();
		end
	end

	-- Then build the rest of the data.

	local displayInfo = {};

	if TRP3_NamePlatesUtil.ShouldCustomizeTitles() then
		displayInfo.fullTitle = profile.data.TI;
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeHealthColors() then
		displayInfo.healthColor = color;
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeIcons() then
		displayInfo.icon = profile.data.IC;
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeNameColors() then
		displayInfo.nameColor = color;
	end

	if TRP3_NamePlatesUtil.ShouldCustomizeNames() then
		displayInfo.nameText = profile.data.NA;
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
	TRP3_NamePlatesUtil.SetInCombat(true);
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnPlayerRegenEnabled()
	TRP3_NamePlatesUtil.SetInCombat(false);
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

	if not registerID then
		return nil;  -- Unit can't have a profile.
	elseif not TRP3_NamePlatesUtil.ShouldCustomizeUnitNamePlate(unitToken) then
		return nil;  -- Customizations disabled for this unit by config.
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

	if registerID and TRP3_NamePlates.unitRegisterIDs[unitToken] ~= registerID and TRP3_NamePlatesUtil.ShouldRequestProfiles() then
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
