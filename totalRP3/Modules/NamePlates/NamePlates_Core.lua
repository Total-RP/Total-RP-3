-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local displayInfoPool = {};
local playerCharacterPool = setmetatable({}, { __mode = "kv" });
local isInCombat = InCombatLockdown();

local function GetOrCreateDisplayInfo(unitToken)
	if not displayInfoPool[unitToken] then
		displayInfoPool[unitToken] = {};
	end

	local displayInfo = displayInfoPool[unitToken];

	displayInfo.color = nil;
	displayInfo.fullTitle = nil;
	displayInfo.icon = nil;
	displayInfo.name = nil;
	displayInfo.roleplayStatus = nil;
	displayInfo.shortenedFullTitle = nil;
	displayInfo.shortenedName = nil;
	displayInfo.shouldColorHealth = nil;
	displayInfo.shouldColorName = nil;
	displayInfo.shouldHide = nil;

	return displayInfo;
end

local function GetOrCreatePlayerFromCharacterID(characterID)
	-- TODO: Quick hack to reduce memory churn; should rework the Player class
	-- to be implicitly pooled at some point as it has no internal mutable
	-- state but don't want to take the risk yet.

	local player = playerCharacterPool[characterID];

	if player then
		return player;
	end

	player = AddOn_TotalRP3.Player.CreateFromCharacterID(characterID);
	playerCharacterPool[characterID] = player;
	return player;
end

local function SafeSet(table, key, value)
	if key ~= nil then
		table[key] = value;
	end
end

local function GetUnitRoleplayStatus(unitToken)
	local player;

	if not unitToken then
		return nil;
	elseif UnitIsUnit(unitToken, "player") then
		player = AddOn_TotalRP3.Player.GetCurrentUser();
	elseif UnitIsPlayer(unitToken) then
		local characterID = TRP3_API.utils.str.getUnitID(unitToken);

		if characterID then
			player = GetOrCreatePlayerFromCharacterID(characterID);
		end
	else
		-- For companion units query the OOC state of their owner.
		local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
		local characterID = select(2, TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType));

		if characterID then
			if characterID == TRP3_API.globals.player_id then
				player = AddOn_TotalRP3.Player.GetCurrentUser();
			else
				player = GetOrCreatePlayerFromCharacterID(characterID);
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
	if not unitToken then
		return false;  -- Unit is invalid.
	elseif UnitIsUnit(unitToken, "player") then
		return false;  -- Never decorate personal nameplates.
	elseif TRP3_NamePlatesSettings.DisableInCombat and isInCombat then
		return false;  -- Player is in (or about to enter) combat.
	elseif TRP3_NamePlatesSettings.DisableOutOfCharacter and IsUnitOutOfCharacter("player") then
		return false;  -- Player is currently OOC.
	elseif TRP3_NamePlatesSettings.DisableNonPlayableUnits and (not UnitIsPlayer(unitToken) and not UnitIsOtherPlayersPet(unitToken)) then
		return false;  -- NPC unit decorations are disabled.
	elseif TRP3_NamePlatesSettings.DisableOutOfCharacterUnits and IsUnitOutOfCharacter(unitToken) then
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

	if not color and TRP3_NamePlatesSettings.EnableClassColorFallback then
		color = TRP3_API.Ellyb.ColorManager[classToken];
	end

	return color;
end

local function GetCharacterUnitDisplayInfo(unitToken, characterID)
	local displayInfo = GetOrCreateDisplayInfo(unitToken);

	if characterID and TRP3_API.register.isUnitIDKnown(characterID) then
		local player = GetOrCreatePlayerFromCharacterID(characterID);
		local classToken = UnitClassBase(unitToken);

		do  -- Names/Titles
			if TRP3_NamePlatesSettings.CustomizeNames then
				displayInfo.name = player:GetRoleplayingName();
			end

			if TRP3_NamePlatesSettings.CustomizeTitles then
				local prefix = player:GetTitle();

				if prefix then
					displayInfo.name = strjoin(" ", prefix, displayInfo.name or player:GetName());
				end
			end

			if TRP3_NamePlatesSettings.CustomizeFullTitles then
				displayInfo.fullTitle = player:GetFullTitle();
			end
		end

		do  -- Colors
			if TRP3_NamePlatesSettings.CustomizeHealthColors then
				displayInfo.shouldColorHealth = true;
			end

			if TRP3_NamePlatesSettings.CustomizeNameColors then
				displayInfo.shouldColorName = true;
			end

			if displayInfo.shouldColorHealth or displayInfo.shouldColorName then
				displayInfo.color = GetCharacterColorForDisplay(player, classToken);

				if not displayInfo.color then
					displayInfo.shouldColorHealth = nil;
					displayInfo.shouldColorName = nil;
				end
			end
		end

		do  -- Additional Indicators
			if TRP3_NamePlatesSettings.CustomizeIcons then
				displayInfo.icon = player:GetCustomIcon();
			end

			if TRP3_NamePlatesSettings.CustomizeRoleplayStatus then
				displayInfo.roleplayStatus = player:GetRoleplayStatus();
			end
		end

		if TRP3_NamePlatesSettings.HideOutOfCharacterUnits then
			displayInfo.shouldHide = displayInfo.shouldHide or not player:IsInCharacter();
		end
	else
		-- Unit has no profile and so is a non-roleplay unit.
		displayInfo.shouldHide = TRP3_NamePlatesSettings.HideNonRoleplayUnits;
	end

	if displayInfo.name then
		displayInfo.shortenedName = TRP3_API.utils.str.crop(displayInfo.name, TRP3_NamePlatesSettings.MaximumNameLength);
	end

	if displayInfo.fullTitle then
		displayInfo.shortenedFullTitle = TRP3_API.utils.str.crop(displayInfo.fullTitle, TRP3_NamePlatesSettings.MaximumTitleLength);
	end

	return displayInfo;
end

local function GetCompanionUnitDisplayInfo(unitToken, companionFullID)
	local displayInfo = GetOrCreateDisplayInfo(unitToken);

	local profile = TRP3_API.companions.register.getCompanionProfile(companionFullID);

	if profile and profile.data then
		do  -- Names/Titles
			if TRP3_NamePlatesSettings.CustomizeNames then
				displayInfo.name = profile.data.NA;
			end

			if TRP3_NamePlatesSettings.CustomizeTitles then
				displayInfo.fullTitle = profile.data.TI;
			end
		end

		do  -- Colors
			if TRP3_NamePlatesSettings.CustomizeHealthColors then
				displayInfo.shouldColorHealth = true;
			end

			if TRP3_NamePlatesSettings.CustomizeNameColors then
				displayInfo.shouldColorName = true;
			end

			if displayInfo.shouldColorHealth or displayInfo.shouldColorName then
				displayInfo.color = GetCompanionColorForDisplay(profile.data.NH);

				if not displayInfo.color then
					displayInfo.shouldColorHealth = nil;
					displayInfo.shouldColorName = nil;
				end
			end
		end

		do  -- Additional Indicators
			if TRP3_NamePlatesSettings.CustomizeIcons then
				displayInfo.icon = profile.data.IC;
			end

			if TRP3_NamePlatesSettings.HideOutOfCharacterUnits then
				displayInfo.shouldHide = displayInfo.shouldHide or IsUnitOutOfCharacter(unitToken);
			end
		end
	else
		-- Unit has no profile and so is a non-roleplay unit.
		displayInfo.shouldHide = TRP3_NamePlatesSettings.HideNonRoleplayUnits;
	end

	if displayInfo.name then
		displayInfo.shortenedName = TRP3_API.utils.str.crop(displayInfo.name, TRP3_NamePlatesSettings.MaximumNameLength);
	end

	if displayInfo.fullTitle then
		displayInfo.shortenedFullTitle = TRP3_API.utils.str.crop(displayInfo.fullTitle, TRP3_NamePlatesSettings.MaximumTitleLength);
	end

	return displayInfo;
end

local function GetNonPlayableUnitDisplayInfo(unitToken)
	local displayInfo = GetOrCreateDisplayInfo(unitToken);
	displayInfo.shouldHide = TRP3_NamePlatesSettings.HideNonRoleplayUnits;
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
	self.unitCharacterIDs = {};
	self.displayInfoFilters = {};

	self.callbacks.OnUsed = function() self:OnModuleUsed(); end;

	TRP3_NamePlatesUtil.RegisterSettings();
	TRP3_NamePlatesUtil.LoadSettings();
end

function TRP3_NamePlates:OnModuleEnable()
	-- External code can define the below global before the PLAYER_LOGIN event
	-- fires to disable all of our integrations.

	if TRP3_DISABLE_NAMEPLATES then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	self.moduleEnabled = true;
	self:ActivateModule();
end

function TRP3_NamePlates:OnModuleUsed()
	self.moduleUsed = true;
	self:ActivateModule();
end

function TRP3_NamePlates:ActivateModule()
	if self.moduleActivated or (not self.moduleEnabled or not self.moduleUsed) then
		return;
	end

	self.moduleActivated = true;
	self.requests = CreateAndInitFromMixin(TRP3_NamePlatesRequestManagerMixin);

	TRP3_API.Ellyb.GameEvents.registerCallback("NAME_PLATE_UNIT_ADDED", function(...) return self:OnNamePlateUnitAdded(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("NAME_PLATE_UNIT_REMOVED", function(...) return self:OnNamePlateUnitRemoved(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("UNIT_NAME_UPDATE", function(...) return self:OnUnitNameUpdate(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("PLAYER_REGEN_DISABLED", function(...) return self:OnPlayerRegenDisabled(...); end);
	TRP3_API.Ellyb.GameEvents.registerCallback("PLAYER_REGEN_ENABLED", function(...) return self:OnPlayerRegenEnabled(...); end);

	TRP3_API.Events.registerCallback("CONFIGURATION_CHANGED", function(...) return self:OnConfigurationChanged(...); end);
	TRP3_API.Events.registerCallback("REGISTER_DATA_UPDATED", function(...) return self:OnRegisterDataUpdated(...); end);

	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnNamePlateUnitAdded(unitToken)
	self:UpdateCharacterIDForUnit(unitToken);
	self:UpdateNamePlateForUnit(unitToken);
end

function TRP3_NamePlates:OnNamePlateUnitRemoved(unitToken)
	self.requests:DequeueUnitQuery(unitToken);
	self:ClearCharacterIDForUnit(unitToken);
	self:UpdateNamePlateForUnit(unitToken);
end

function TRP3_NamePlates:OnUnitNameUpdate(unitToken)
	if string.find(unitToken, "^nameplate[0-9]+$") then
		self:UpdateCharacterIDForUnit(unitToken);
		self:UpdateNamePlateForUnit(unitToken);
	end
end

function TRP3_NamePlates:OnPlayerRegenDisabled()
	isInCombat = true;
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnPlayerRegenEnabled()
	isInCombat = false;
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnConfigurationChanged(key)
	if TRP3_NamePlatesUtil.IsValidSetting(key) then
		TRP3_NamePlatesUtil.LoadSettings();
		self:UpdateAllNamePlates();
	end
end

function TRP3_NamePlates:OnRegisterDataUpdated(characterID)
	if characterID == TRP3_API.globals.player_id then
		self:UpdateAllNamePlates();
	else
		local unitToken = self.unitCharacterIDs[characterID];

		if unitToken then
			self.requests:DequeueUnitQuery(unitToken);
			self:UpdateNamePlateForUnit(unitToken);
		end
	end
end

function TRP3_NamePlates:RegisterDisplayInfoFilter(filter)
	-- Display info filters can be used by external addons to modify the
	-- data for a nameplate after we've pulled profile data for it and before
	-- any nameplate decorators have received it.
	--
	-- The filter function will be invoked with the unit token ("nameplate3")
	-- and the display info table as parameters. The filter does not need to
	-- return any values, and may modify any fields in the display info table
	-- to change how the nameplate will be shown.

	table.insert(self.displayInfoFilters, filter);
end

function TRP3_NamePlates:GetUnitDisplayInfo(unitToken)
	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
	local characterID = TRP3_NamePlatesUtil.GetUnitCharacterID(unitToken);
	local displayInfo;

	if not ShouldCustomizeUnitNamePlate(unitToken) then
		displayInfo = nil;  -- Customizations disabled for this unit.
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		displayInfo = GetCharacterUnitDisplayInfo(unitToken, characterID);
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
		displayInfo = GetCompanionUnitDisplayInfo(unitToken, characterID);
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.NPC then
		displayInfo = GetNonPlayableUnitDisplayInfo(unitToken);
	end

	if displayInfo then
		for _, filter in ipairs(self.displayInfoFilters) do
			securecallfunction(filter, unitToken, displayInfo);
		end
	end

	return displayInfo;
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
		self.callbacks:Fire("OnNamePlateDataUpdated", nameplate, unitToken, displayInfo);
	end
end

function TRP3_NamePlates:RequestUnitProfile(unitToken)
	if TRP3_NamePlatesSettings.EnableActiveQuery then
		self.requests:EnqueueUnitQuery(unitToken);
	else
		self.requests:DequeueUnitQuery(unitToken);
	end
end

function TRP3_NamePlates:ClearCharacterIDForUnit(unitToken)
	-- This removes the two-way mapping for the unit token <=> register ID.
	SafeSet(self.unitCharacterIDs, self.unitCharacterIDs[unitToken], nil);
	SafeSet(self.unitCharacterIDs, unitToken, nil);
end

function TRP3_NamePlates:UpdateCharacterIDForUnit(unitToken)
	local characterID = TRP3_NamePlatesUtil.GetUnitCharacterID(unitToken);

	if characterID and self.unitCharacterIDs[unitToken] ~= characterID then
		self:RequestUnitProfile(unitToken);
	end

	-- This updates the two-way mapping for the unit token <=> register ID.
	SafeSet(self.unitCharacterIDs, self.unitCharacterIDs[unitToken], nil);
	SafeSet(self.unitCharacterIDs, unitToken, characterID);
	SafeSet(self.unitCharacterIDs, characterID, unitToken);
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
