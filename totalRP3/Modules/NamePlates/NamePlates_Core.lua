-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local displayInfoPool = {};
local playerCharacterPool = setmetatable({}, { __mode = "kv" });
local isInCombat = nil;

local function GetOrCreateDisplayInfo(unitToken)
	if not displayInfoPool[unitToken] then
		displayInfoPool[unitToken] = {};
	end

	local displayInfo = displayInfoPool[unitToken];

	displayInfo.color = nil;
	displayInfo.fullTitle = nil;
	displayInfo.guildName = nil;
	displayInfo.guildRank = nil;
	displayInfo.guildIsCustom = nil;
	displayInfo.icon = nil;
	displayInfo.isRoleplayUnit = false;
	displayInfo.name = nil;
	displayInfo.roleplayStatus = nil;
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

local function IsNPCUnit(unitToken)
	return not UnitIsPlayer(unitToken) and not UnitIsOtherPlayersPet(unitToken);
end

local function ShouldCustomizeUnitNamePlate(unitToken)
	local shouldCustomize;

	if not TRP3_NamePlates:IsEnabled() then
		shouldCustomize = false;  -- Module is disabled.
	elseif not unitToken then
		shouldCustomize = false;  -- Unit is invalid.
	elseif UnitIsUnit(unitToken, "player") then
		shouldCustomize = false;  -- Never decorate personal nameplates.
	elseif TRP3_NamePlatesSettings.DisableInCombat and isInCombat then
		shouldCustomize = false;  -- Player is in (or about to enter) combat.
	elseif TRP3_NamePlatesSettings.DisableInInstances and IsInInstance() then
		shouldCustomize = false;   -- Player is in instanced content.
	elseif TRP3_NamePlatesSettings.DisableOutOfCharacter and IsUnitOutOfCharacter("player") then
		shouldCustomize = false;  -- Player is currently OOC.
	elseif TRP3_NamePlatesSettings.CustomizeNPCUnits == TRP3_NamePlateUnitCustomizationState.Disable and IsNPCUnit(unitToken) then
		shouldCustomize = false;  -- NPC unit decorations are disabled.
	elseif TRP3_NamePlatesSettings.CustomizeOOCUnits == TRP3_NamePlateUnitCustomizationState.Disable and IsUnitOutOfCharacter(unitToken) then
		shouldCustomize = false;  -- Unit is currently OOC.
	else
		shouldCustomize = true;
	end

	return shouldCustomize;
end

local function ShouldHideUnitNamePlate(unitToken)
	local shouldHide;

	if TRP3_NamePlatesSettings.CustomizeNPCUnits == TRP3_NamePlateUnitCustomizationState.Hide and IsNPCUnit(unitToken) then
		shouldHide = true;   -- NPC units should be hidden.
	elseif TRP3_NamePlatesSettings.CustomizeOOCUnits == TRP3_NamePlateUnitCustomizationState.Hide and IsUnitOutOfCharacter(unitToken) then
		shouldHide = true;   -- OOC units should be hidden.
	else
		shouldHide = false;
	end

	return shouldHide;
end

local function GetCompanionColorForDisplay(colorHexString)
	if not colorHexString then
		return nil;
	end

	local color = TRP3_API.CreateColorFromHexString(colorHexString);
	color = TRP3_API.GenerateReadableColor(color, TRP3_API.Colors.Black);
	return color;
end

local function GetCharacterColorForDisplay(player, classToken)
	local color = player:GetCustomColorForDisplay();

	if not color and TRP3_NamePlatesSettings.EnableClassColorFallback then
		color = TRP3_API.GetClassDisplayColor(classToken);
	end

	return color;
end

local function GetCharacterUnitDisplayInfo(unitToken, characterID)
	local displayInfo = GetOrCreateDisplayInfo(unitToken);

	if characterID and TRP3_API.register.isUnitIDKnown(characterID) then
		local player = GetOrCreatePlayerFromCharacterID(characterID);
		local classToken = UnitClassBase(unitToken);

		-- Don't customize default profile nameplates
		if TRP3_API.profile.isDefaultProfile(player:GetProfileID()) then
			return displayInfo;
		end

		displayInfo.isRoleplayUnit = true;

		do  -- Names/Titles
			if TRP3_NamePlatesSettings.CustomizeNames == TRP3_NamePlateUnitNameDisplayMode.FirstName then
				displayInfo.name = player:GetFirstName();  -- May be nil or empty.
			elseif TRP3_NamePlatesSettings.CustomizeNames == TRP3_NamePlateUnitNameDisplayMode.OriginalName then
				displayInfo.name = player:GetName();  -- Should never be nil or empty.
			end

			if not displayInfo.name or displayInfo.name == "" then
				displayInfo.name = player:GetRoleplayingName();
			end

			if TRP3_NamePlatesSettings.CustomizeTitles then
				local prefix = player:GetTitle();

				if prefix then
					displayInfo.name = strjoin(" ", prefix, displayInfo.name);
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

		do  -- Guild Membership
			if TRP3_NamePlatesSettings.CustomizeGuild then
				local customGuildInfo = player:GetCustomGuildMembership();
				local customGuildName = customGuildInfo.name and string.trim(customGuildInfo.name) or nil;
				local customGuildRank = customGuildInfo.rank and string.trim(customGuildInfo.rank) or nil;

				local originalGuildName, originalGuildRank = GetGuildInfo(unitToken);

				if customGuildName and customGuildName ~= "" then
					displayInfo.guildName = TRP3_NamePlatesUtil.GenerateCroppedGuildName(customGuildName);
					displayInfo.guildRank = customGuildRank or L.DEFAULT_GUILD_RANK;
					displayInfo.guildIsCustom = true;
				elseif originalGuildName and originalGuildName ~= "" then
					displayInfo.guildName = TRP3_NamePlatesUtil.GenerateCroppedGuildName(originalGuildName);
					displayInfo.guildRank = originalGuildRank;
					displayInfo.guildIsCustom = false;
				end
			end
		end
	end

	if displayInfo.name then
		displayInfo.name = TRP3_NamePlatesUtil.GenerateCroppedNameText(displayInfo.name);
	end

	if displayInfo.fullTitle then
		displayInfo.fullTitle = TRP3_NamePlatesUtil.GenerateCroppedTitleText(displayInfo.fullTitle);
	end

	return displayInfo;
end

local function GetCompanionUnitDisplayInfo(unitToken, companionFullID)
	local displayInfo = GetOrCreateDisplayInfo(unitToken);

	if companionFullID == nil then
		return displayInfo;
	end

	local owner, companionID = TRP3_API.utils.str.companionIDToInfo(companionFullID);
	local profile;

	if owner == TRP3_API.globals.player_id then
		profile = TRP3_API.companions.player.getCompanionProfile(companionID);
	else
		profile = TRP3_API.companions.register.getCompanionProfile(companionFullID);
	end

	if profile and profile.data then
		displayInfo.isRoleplayUnit = true;

		do  -- Names/Titles
			if TRP3_NamePlatesSettings.CustomizeNames ~= TRP3_NamePlateUnitNameDisplayMode.OriginalName then
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
		end
	end

	if displayInfo.name then
		displayInfo.name = TRP3_NamePlatesUtil.GenerateCroppedNameText(displayInfo.name);
	end

	if displayInfo.fullTitle then
		displayInfo.fullTitle = TRP3_NamePlatesUtil.GenerateCroppedTitleText(displayInfo.fullTitle);
	end

	return displayInfo;
end

local function GetNonPlayableUnitDisplayInfo(unitToken)
	local displayInfo = GetOrCreateDisplayInfo(unitToken);
	return displayInfo;
end

--
-- Note that the contents of the TRP3_NamePlates table is intended for private
-- internal use by the addon and shouldn't be assumed stable.
--
-- Public API will be added to the AddOn_TotalRP3 table at a later date.
--

TRP3_NamePlates = TRP3_Addon:NewModule("NamePlates");

TRP3_NamePlates.Events =
{
	OnNamePlateDataUpdated = "OnNamePlateDataUpdated",
};

function TRP3_NamePlates:OnInitialize()
	self.callbacks = TRP3_API.InitCallbackRegistryWithEvents(self, TRP3_NamePlates.Events);
	self.requests = CreateAndInitFromMixin(TRP3_NamePlatesRequestManagerMixin);
	self.displayInfoFilters = {};
	self.unitCharacterIDs = {};

	self.events = TRP3_API.CreateCallbackGroup();
	self.events:AddCallback(TRP3_API.GameEvents, "NAME_PLATE_UNIT_ADDED", self.OnNamePlateUnitAdded, self);
	self.events:AddCallback(TRP3_API.GameEvents, "NAME_PLATE_UNIT_REMOVED", self.OnNamePlateUnitRemoved, self);
	self.events:AddCallback(TRP3_API.GameEvents, "UNIT_NAME_UPDATE", self.OnUnitNameUpdate, self);
	self.events:AddCallback(TRP3_API.GameEvents, "PLAYER_REGEN_DISABLED", self.OnCombatStatusChanged, self);
	self.events:AddCallback(TRP3_API.GameEvents, "PLAYER_REGEN_ENABLED", self.OnCombatStatusChanged, self);
	self.events:AddCallback(TRP3_API.GameEvents, "PLAYER_ENTERING_WORLD", self.OnPlayerEnteringWorld, self);
	self.events:AddCallback(TRP3_API.GameEvents, "PLAYER_TARGET_CHANGED", self.OnPlayerTargetChanged, self);

	self.events:AddCallback(TRP3_Addon, "CONFIGURATION_CHANGED",self.OnConfigurationChanged, self);
	self.events:AddCallback(TRP3_Addon, "REGISTER_DATA_UPDATED",self.OnRegisterDataUpdated, self);

	-- Settings are registered on initialization so that there's a UI element
	-- through which users can at least see if nameplates are working.

	TRP3_NamePlatesUtil.RegisterSettings();

	-- The nameplates module is disabled by default on initialization and will
	-- be enabled upon the first registration of an OnNamePlateDataUpdated
	-- callback.

	self:SetEnabledState(false);
end

function TRP3_NamePlates:OnEnable()
	self.events:Register();
	TRP3_NamePlatesUtil.LoadSettings();
	self:OnCombatStatusChanged();
	self:OnPlayerTargetChanged();
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnDisable()
	self.events:Unregister();
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnEventUsed(event)
	if event == "OnNamePlateDataUpdated" then
		self:Enable();
	end
end

function TRP3_NamePlates:OnEventUnused(event)
	if event == "OnNamePlateDataUpdated" then
		self:Disable();
	end
end

function TRP3_NamePlates:OnNamePlateUnitAdded(unitToken)
	if UnitIsUnit(unitToken, "target") then
		self:UpdateNamePlateTargetUnit();
	end

	self:UpdateCharacterIDForUnit(unitToken);
	self:UpdateNamePlateForUnit(unitToken);
end

function TRP3_NamePlates:OnNamePlateUnitRemoved(unitToken)
	if UnitIsUnit(unitToken, "target") then
		self:UpdateNamePlateTargetUnit();
	end

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

function TRP3_NamePlates:OnCombatStatusChanged()
	local function OnTick()
		isInCombat = InCombatLockdown();
		self:UpdateAllNamePlates();
	end

	C_Timer.After(0, OnTick);
end

function TRP3_NamePlates:OnPlayerEnteringWorld()
	self:UpdateAllNamePlates();
end

function TRP3_NamePlates:OnPlayerTargetChanged()
	if self.namePlateTargetToken then
		self:UpdateNamePlateForUnit(self.namePlateTargetToken);
	end

	self:UpdateNamePlateTargetUnit();

	if self.namePlateTargetToken then
		self:UpdateNamePlateForUnit(self.namePlateTargetToken);
	end
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

	-- Apply additional post-filter logic for non-roleplay units. Filters can
	-- flag display info as being roleplay related or not, allowing other
	-- addons to mark units like NPCs as being roleplay units.

	if displayInfo and not displayInfo.isRoleplayUnit then
		if TRP3_NamePlatesSettings.CustomizeNonRoleplayUnits == TRP3_NamePlateUnitCustomizationState.Disable then
			displayInfo = nil;
		elseif TRP3_NamePlatesSettings.CustomizeNonRoleplayUnits == TRP3_NamePlateUnitCustomizationState.Hide then
			displayInfo.shouldHide = true;
		end
	end

	-- If no explicit visibility was set by any filter, figure out a default
	-- based on the unit in question.

	if displayInfo and displayInfo.shouldHide == nil then
		displayInfo.shouldHide = ShouldHideUnitNamePlate(unitToken);
	end

	-- Target visibility takes priority over everything else and is forced.

	if displayInfo and TRP3_NamePlatesSettings.ShowTargetUnit and UnitIsUnit(unitToken, "target") then
		displayInfo.shouldHide = false;
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

function TRP3_NamePlates:UpdateNamePlateTargetUnit()
	local nameplate = C_NamePlate.GetNamePlateForUnit("target");
	local unitToken = nameplate and nameplate.namePlateUnitToken or nil;

	self.namePlateTargetToken = unitToken;
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
