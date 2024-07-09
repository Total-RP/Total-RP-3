-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local loc = TRP3_API.loc;
local getUnitIDCurrentProfile, isIDIgnored = TRP3_API.register.getUnitIDCurrentProfile, TRP3_API.register.isIDIgnored;
local getIgnoreReason = TRP3_API.register.getIgnoreReason;
local getCharacterUnitID = Utils.str.getUnitID;
local get = TRP3_API.profile.getData;
local getConfigValue = TRP3_API.configuration.getValue;
local getCompleteName = TRP3_API.register.getCompleteName;
local getOtherCharacter = TRP3_API.register.getUnitIDCharacter;
local getYourCharacter = TRP3_API.profile.getPlayerCharacter;
local IsUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local Events = TRP3_Addon.Events;
local hasProfile, getRelationColors = TRP3_API.register.hasProfile, TRP3_API.register.relation.getRelationColors;
local originalGetTargetType, getCompanionFullID = TRP3_API.ui.misc.getTargetType, TRP3_API.ui.misc.getCompanionFullID;
local EMPTY = Globals.empty;
local unitIDToInfo = Utils.str.unitIDToInfo;
local isPlayerIC;
local unitIDIsFilteredForMatureContent;
local crop = Utils.str.crop;
local TRP3_Enums = AddOn_TotalRP3.Enums;

-- ICONS
local OOC_ICON = "|TInterface\\COMMON\\Indicator-Red:15:15|t";
local ALLIANCE_ICON = "|TInterface\\GROUPFRAME\\UI-Group-PVP-Alliance:20:20|t";
local HORDE_ICON = "|TInterface\\GROUPFRAME\\UI-Group-PVP-Horde:20:20|t";
local NEW_ABOUT_ICON = "|A:QuestNormal:22:22|a";
local PROFILE_NOTES_ICON = "|TInterface\\Buttons\\UI-GuildButton-PublicNote-Up:22:22|t";
local TRANSPARENT_ICON = "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\transparent:22:22|t";
local WALKUP_ICON = "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\ui-walkup:18:18:5|t";

local ConfigKeys = {
	PROFILE_ONLY = "tooltip_profile_only";
	IN_CHARACTER_ONLY = "tooltip_in_character_only";
	CHARACT_COMBAT = "tooltip_char_combat";
	HIDE_IN_INSTANCE = "tooltip_hide_in_instance";
	HIDE_ON_MODIFIER = "tooltip_hide_on_modifier";
	CHARACT_COLOR = "tooltip_char_color";
	CROP_TEXT = "tooltip_crop_text";
	CHARACT_ANCHORED_FRAME = "tooltip_char_AnchoredFrame";
	CHARACT_ANCHOR = "tooltip_char_Anchor";
	CHARACT_HIDE_ORIGINAL = "tooltip_char_HideOriginal";
	CHARACT_MAIN_SIZE = "tooltip_char_mainSize";
	CHARACT_SUB_SIZE = "tooltip_char_subSize";
	CHARACT_TER_SIZE = "tooltip_char_terSize";
	CHARACT_ICONS = "tooltip_char_icons";
	CHARACT_FT = "tooltip_char_ft";
	CHARACT_RACECLASS = "tooltip_char_rc";
	CHARACT_REALM = "tooltip_char_realm";
	CHARACT_GUILD = "tooltip_char_guild";
	CHARACT_TARGET = "tooltip_char_target";
	CHARACT_TITLE = "tooltip_char_title";
	CHARACT_NOTIF = "tooltip_char_notif";
	CHARACT_CURRENT = "tooltip_char_current";
	CHARACT_OOC = "tooltip_char_ooc";
	CHARACT_PRONOUNS = "tooltip_char_pronouns";
	CHARACT_VOICE_REFERENCE = "tooltip_char_voice_reference";
	CHARACT_ZONE = "tooltip_char_zone";
	CHARACT_HEALTH = "tooltip_char_health";
	CHARACT_CURRENT_SIZE = "tooltip_char_current_size";
	CHARACT_RELATION_LINE = "tooltip_char_relation_line";
	CHARACT_RELATION = "tooltip_char_relation";
	CHARACT_SPACING = "tooltip_char_spacing";
	NO_FADE_OUT = "tooltip_no_fade_out";
	SHOW_WORLD_CURSOR = "tooltip_show_world_cursor";
	PREFER_OOC_ICON = "tooltip_prefere_ooc_icon";
	CHARACT_CURRENT_LINES = "tooltip_char_current_lines";
	TOOLTIP_TITLE_COLOR = "tooltip_title_color";
	TOOLTIP_MAIN_COLOR = "tooltip_main_color";
	TOOLTIP_SECONDARY_COLOR = "tooltip_secondary_color";
	-- Companion tooltip options
	PETS_ICON = "tooltip_pets_icons",
	PETS_TITLE = "tooltip_pets_title",
	PETS_OWNER = "tooltip_pets_owner",
	PETS_NOTIF = "tooltip_pets_notif",
	PETS_INFO = "tooltip_pets_info",
};

local MATURE_CONTENT_ICON = Utils.str.texture("Interface\\AddOns\\totalRP3\\resources\\18_emoji.tga", 20);
local registerTooltipModuleIsEnabled = false;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config getters
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getAnchoredFrame()
	if getConfigValue(ConfigKeys.CHARACT_ANCHORED_FRAME) == "" then return nil end;
	return _G[getConfigValue(ConfigKeys.CHARACT_ANCHORED_FRAME)] or GameTooltip;
end

local function showRelationColor()
	return getConfigValue(ConfigKeys.CHARACT_RELATION);
end

local function getAnchoredPosition()
	return getConfigValue(ConfigKeys.CHARACT_ANCHOR);
end

local function shouldHideGameTooltip()
	return getConfigValue(ConfigKeys.CHARACT_HIDE_ORIGINAL);
end
TRP3_API.ui.tooltip.shouldHideGameTooltip = shouldHideGameTooltip;

local function getMainLineFontSize()
	return getConfigValue(ConfigKeys.CHARACT_MAIN_SIZE);
end
TRP3_API.ui.tooltip.getMainLineFontSize = getMainLineFontSize;

local function getSubLineFontSize()
	return getConfigValue(ConfigKeys.CHARACT_SUB_SIZE);
end
TRP3_API.ui.tooltip.getSubLineFontSize = getSubLineFontSize;

local function getSmallLineFontSize()
	return getConfigValue(ConfigKeys.CHARACT_TER_SIZE);
end
TRP3_API.ui.tooltip.getSmallLineFontSize = getSmallLineFontSize;

function TRP3_API.ui.tooltip.setTooltipDefaultAnchor(tooltip, parent)
	-- This function may be overridden by other modules (eg. ElvUI).
	GameTooltip_SetDefaultAnchor(tooltip, parent);
end

function TRP3_API.ui.tooltip.shouldCropTexts()
	if not registerTooltipModuleIsEnabled then
		return true;
	else
		return getConfigValue(ConfigKeys.CROP_TEXT);
	end
end

local function showIcons()
	return getConfigValue(ConfigKeys.CHARACT_ICONS);
end

local function showFullTitle()
	return getConfigValue(ConfigKeys.CHARACT_FT);
end

local function showRaceClass()
	return getConfigValue(ConfigKeys.CHARACT_RACECLASS);
end

local function showRealm()
	return getConfigValue(ConfigKeys.CHARACT_REALM);
end

local function showRelationLine()
	return getConfigValue(ConfigKeys.CHARACT_RELATION_LINE);
end

local function showTarget()
	return getConfigValue(ConfigKeys.CHARACT_TARGET);
end

local function showTitle()
	return getConfigValue(ConfigKeys.CHARACT_TITLE);
end

local function showNotifications()
	return getConfigValue(ConfigKeys.CHARACT_NOTIF);
end

local function showCurrently()
	return getConfigValue(ConfigKeys.CHARACT_CURRENT);
end

local function showMoreInformation()
	return getConfigValue(ConfigKeys.CHARACT_OOC);
end

local function showPronouns()
	return getConfigValue(ConfigKeys.CHARACT_PRONOUNS);
end

local function showVoiceReference()
	return getConfigValue(ConfigKeys.CHARACT_VOICE_REFERENCE);
end

local function showZone()
	return getConfigValue(ConfigKeys.CHARACT_ZONE);
end

local function getCurrentMaxSize()
	return getConfigValue(ConfigKeys.CHARACT_CURRENT_SIZE);
end

local function showSpacing()
	return getConfigValue(ConfigKeys.CHARACT_SPACING);
end

local function fadeOutEnabled()
	return not getConfigValue(ConfigKeys.NO_FADE_OUT);
end

local function showWorldCursor()
	return getConfigValue(ConfigKeys.SHOW_WORLD_CURSOR);
end

local function getCurrentMaxLines()
	return getConfigValue(ConfigKeys.CHARACT_CURRENT_LINES);
end

local function getTooltipTextColors()
	local colors = {
		TITLE = TRP3_API.CreateColorFromHexString(getConfigValue(ConfigKeys.TOOLTIP_TITLE_COLOR)),
		MAIN = TRP3_API.CreateColorFromHexString(getConfigValue(ConfigKeys.TOOLTIP_MAIN_COLOR)),
		SECONDARY = TRP3_API.CreateColorFromHexString(getConfigValue(ConfigKeys.TOOLTIP_SECONDARY_COLOR)),
	};

	return colors;
end
TRP3_API.ui.tooltip.getTooltipTextColors = getTooltipTextColors;

TRP3_API.ui.tooltip.tooltipBorderColor = TRP3_API.Colors.White;

local TooltipGuildDisplayOption = {
	-- Old setting was a boolean; use false/true for sensible defaults here.
	Hidden = false,
	ShowWithCustomGuild = true,
	ShowWithOriginalGuild = 2,
	ShowWithAllGuilds = 3,
};

local function ShouldDisplayOriginalGuild(displayOption, originalName, customName)
	if displayOption == TooltipGuildDisplayOption.Hidden or not originalName or originalName == "" then
		return false;
	elseif displayOption == TooltipGuildDisplayOption.ShowWithOriginalGuild then
		return true;
	elseif displayOption == TooltipGuildDisplayOption.ShowWithCustomGuild and (not customName or customName == "") then
		return true;
	elseif displayOption == TooltipGuildDisplayOption.ShowWithAllGuilds then
		return true;
	else
		return false;
	end
end

local function ShouldDisplayCustomGuild(displayOption, customName)
	if displayOption == TooltipGuildDisplayOption.Hidden or not customName or customName == "" then
		return false;
	elseif displayOption == TooltipGuildDisplayOption.ShowWithOriginalGuild then
		return false;
	elseif displayOption == TooltipGuildDisplayOption.ShowWithCustomGuild then
		return true;
	elseif displayOption == TooltipGuildDisplayOption.ShowWithAllGuilds then
		return true;
	else
		return false;
	end
end

local function ShouldDisplayUnmodifiedTooltip()
	local modifierKey = getConfigValue(ConfigKeys.HIDE_ON_MODIFIER);

	if modifierKey == "" then
		return false;
	elseif TRP3_BindingUtil.IsKeyDown(modifierKey) then
		return true;
	else
		return false;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTIL METHOD
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getGameTooltipTexts(tooltip)
	local tab = {};
	for j = 1, tooltip:NumLines() do
		tab[j] = _G[tooltip:GetName() .. "TextLeft" ..  j]:GetText();
	end
	return tab;
end
TRP3_API.ui.tooltip.getGameTooltipTexts = getGameTooltipTexts;

local GetCursorPosition = GetCursorPosition;
local function placeTooltipOnCursor()
	local effScale, x, y = TRP3_CharacterTooltip:GetEffectiveScale(), GetCursorPosition();
	TRP3_CharacterTooltip:ClearAllPoints();
	TRP3_CharacterTooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (x / effScale) + 10, (y / effScale) + 10);
end

local function limitText(input, maxCharLength, maxLinesCount)
	-- Loop through the string finding newline characters until we either
	-- reach the end of the string or find enough to break our max line limit.
	local finish, matches = 0, 0;
	repeat
		finish = string.find(input, "\n", finish + 1, true);
		matches = matches + 1;
	until not finish or matches >= maxLinesCount + 1

	-- If we exited because we reached the end of the string then there's
	-- not too many lines, so we just need to limit the total length of the
	-- text. This would likely be the most common case.
	if not finish then
		if #input <= maxCharLength then
			return input;
		end

		return TRP3_API.utils.str.crop(input, maxCharLength);
	end

	-- Otherwise extract the substring up to the character preceeding the
	-- last matched newline or to the maximum allowable length of the text,
	-- whichever is shorter.
	return TRP3_API.utils.str.crop(input, math.min(finish - 1, maxCharLength));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TOOLTIP BUILDER
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ICON_TEXTURE_OPTIONS = {
	width = 32,
	height = 32,
	anchor = Enum.TooltipTextureAnchor.LeftCenter,
	margin = { left = 0, right = 4, top = 0, bottom = 0 },
};

local function GenerateColoredTooltipLine(text, color)
	-- Workaround for issue #606 where certain unicode character ranges make
	-- GameTooltip:AddLine not respect colors. We wrap the text in an
	-- enclosing pair of color sequences to force it to be respected.
	--
	-- Empty lines need to have one character at-minimum to prevent errors
	-- when assigning tooltip line fonts later.
	if not text or text == "" then
		text = " ";
	end

	return color:WrapTextInColorCode(text);
end

---@class TRP3.TooltipBuilder
---@field private tooltip GameTooltip
local TooltipBuilder = {};

function TooltipBuilder:__init(tooltip)
	self.tooltip = tooltip;
	self.lines = 0;
	self.spaceBeforeNextLine = false;
end

---@private
function TooltipBuilder:PreLineAdded()
	if self.lines == 0 then
		self.tooltip:ClearLines();
	end

	if self.spaceBeforeNextLine then
		if self.lines > 0 and showSpacing() then
			TRP3_TooltipUtil.AddBlankLine(self.tooltip);
			self.lines = self.lines + 1;
			TRP3_TooltipUtil.SetLineFontOptions(self.tooltip, self.lines, getSubLineFontSize());
		end

		self.spaceBeforeNextLine = false;
	end
end

---@private
function TooltipBuilder:PostLineAdded()
	self.lines = self.lines + 1;
end

function TooltipBuilder:AddLine(text, color, height, wrap)
	text = GenerateColoredTooltipLine(text, color);

	self:PreLineAdded();
	TRP3_TooltipUtil.AddLine(self.tooltip, text, { wrap = wrap });
	self:PostLineAdded();
	TRP3_TooltipUtil.SetLineFontOptions(self.tooltip, self.lines, height);
end

function TooltipBuilder:AddDoubleLine(textL, textR, colorL, colorR, height)
	textL = GenerateColoredTooltipLine(textL, colorL);
	textR = GenerateColoredTooltipLine(textR, colorR);

	self:PreLineAdded();
	TRP3_TooltipUtil.AddDoubleLine(self.tooltip, textL, textR);
	self:PostLineAdded();
	TRP3_TooltipUtil.SetLineFontOptions(self.tooltip, self.lines, height);
end

function TooltipBuilder:AddSpace()
	self.spaceBeforeNextLine = true;
end

---@param texture TextureAssetDisk
---@param options TooltipTextureInfo
function TooltipBuilder:AddTexture(texture, options)
	if not TRP3_ClientFeatures.OldTooltipAPI then
		self.tooltip:AddTexture(texture, options);
	else
		-- In Classic, AddTexture won't work on the first line of the tooltip,
		-- which is also coincidentally the only line that we actually care
		-- to stick icons on currently.
		--
		-- Fall back to a legacy |T string prefix approach for this case. Note
		-- that we can't use the size values in the options table either, as
		-- for some reason they aren't equivalent.

		local line = self.tooltip:NumLines();
		local leftFontString = TRP3_TooltipUtil.GetLineFontStrings(self.tooltip, line);
		local leftText = leftFontString:GetText();
		local iconText = string.format("|T%s:%d:%d|t ", texture, 24, 24);

		leftFontString:SetText(iconText .. leftText);
	end
end

function TooltipBuilder:Build()
	self.tooltip:Show();
	self.lines = 0;
end

---@return TRP3.TooltipBuilder
function TRP3_API.ui.tooltip.createTooltipBuilder(tooltip)
	return TRP3_API.CreateObject(TooltipBuilder, tooltip);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTER TOOLTIP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tooltipBuilder = TRP3_API.ui.tooltip.createTooltipBuilder(TRP3_CharacterTooltip);

local function getUnitID(targetType)
	local currentTargetType = originalGetTargetType(targetType);
	if currentTargetType == TRP3_Enums.UNIT_TYPE.CHARACTER then
		return getCharacterUnitID(targetType), currentTargetType;
	elseif currentTargetType == TRP3_Enums.UNIT_TYPE.BATTLE_PET or currentTargetType == TRP3_Enums.UNIT_TYPE.PET then
		return getCompanionFullID(targetType, currentTargetType), currentTargetType;
	end
end

TRP3_API.register.getUnitID = getUnitID;

--- Returns a not nil table containing the character information.
-- The returned table is not nil, but could be empty.
local function getCharacterInfoTab(unitID)
	if unitID == Globals.player_id then
		return get("player");
	elseif IsUnitIDKnown(unitID) then
		return getUnitIDCurrentProfile(unitID) or {};
	end
	return {};
end

local function getCharacter(unitID)
	if unitID == Globals.player_id then
		return getYourCharacter();
	elseif IsUnitIDKnown(unitID) then
		return getOtherCharacter(unitID);
	end
	return {};
end

local function getFactionIcon(targetType)
	if UnitFactionGroup(targetType) == "Alliance" then
		return ALLIANCE_ICON;
	elseif UnitFactionGroup(targetType) == "Horde" then
		return HORDE_ICON;
	end
	return "";
end

local function getLevelIconOrText(targetType)
	if UnitLevel(targetType) ~= -1 then
		return UnitLevel(targetType);
	else
		return "|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Skull:16:16|t";
	end
end

local TOOLTIP_BLOCKED_IGNORED_COLOR = TRP3_API.Colors.Red;
local TOOLTIP_BLOCKED_MATURE_COLOR = TRP3_API.CreateColor(1.00, 0.75, 0.86, 1.00);
local TOOLTIP_BLOCKED_MAIN_COLOR = TRP3_API.CreateColor(1.00, 0.75, 0.00, 1.00);

local function SetProgressSpinnerShown(tooltip, shown)
	local spinner = tooltip.ProgressSpinner;

	if shown then
		local lineIndex = tooltip:NumLines();
		local leftFontString = TRP3_TooltipUtil.GetLineFontStrings(tooltip, lineIndex);

		spinner:ClearAllPoints();
		spinner:SetPoint("RIGHT", leftFontString);
		spinner:Show();
	else
		spinner:Hide();
	end
end

--- The complete character's tooltip writing sequence.
local function writeTooltipForCharacter(targetID, targetType)
	local info = getCharacterInfoTab(targetID);
	local character = getCharacter(targetID);
	local targetName = UnitName(targetType);
	local colors = getTooltipTextColors();
	---@type Player
	local player = AddOn_TotalRP3.Player.CreateFromCharacterID(targetID)

	local FIELDS_TO_CROP = {
		TITLE = 150,
		NAME = 100,
		RACE = 50,
		CLASS = 50,
		PRONOUNS = 30,
		GUILD_NAME = 30,
		GUILD_RANK = 30,
		VOICE_REFERENCE = 30,
	}

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if isIDIgnored(targetID) then
		tooltipBuilder:AddLine(loc.REG_TT_IGNORED, TOOLTIP_BLOCKED_IGNORED_COLOR, getSubLineFontSize());
		tooltipBuilder:AddLine("\"" .. getIgnoreReason(targetID) .. "\"", TOOLTIP_BLOCKED_MAIN_COLOR, getSmallLineFontSize());
		tooltipBuilder:Build();
		return;
	elseif unitIDIsFilteredForMatureContent(targetID) then
		tooltipBuilder:AddLine(MATURE_CONTENT_ICON .. " " .. loc.MATURE_FILTER_TOOLTIP_WARNING, TOOLTIP_BLOCKED_MATURE_COLOR, getSubLineFontSize());
		tooltipBuilder:AddLine(loc.MATURE_FILTER_TOOLTIP_WARNING_SUBTEXT, TOOLTIP_BLOCKED_MAIN_COLOR, getSmallLineFontSize(), true);
		tooltipBuilder:Build();
		return;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- icon, complete name, RP/AFK/PVP/Volunteer status
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local localizedClass, englishClass = UnitClass(targetType);
	local color = TRP3_API.GetClassDisplayColor(englishClass);
	local rightIcons = "";


	-- Only use custom colors if the option is enabled and if we have one
	if getConfigValue(ConfigKeys.CHARACT_COLOR) then
		color = player:GetCustomColorForDisplay() or color;
	end


	local completeName = getCompleteName(info.characteristics or {}, targetName, not showTitle());

	if getConfigValue(ConfigKeys.CROP_TEXT) then
		completeName = crop(completeName, FIELDS_TO_CROP.NAME);
	end

	completeName = color:WrapTextInColorCode(completeName);

	-- OOC
	if info.character and info.character.RP ~= 1 then
		if getConfigValue(ConfigKeys.PREFER_OOC_ICON) == TRP3_OOCIndicatorStyle.Text then
			completeName = strconcat(TRP3_API.Colors.Red("[" .. loc.CM_OOC .. "] "), completeName);
		else
			rightIcons = strconcat(rightIcons, OOC_ICON);
		end
	end

	if showIcons() then
		local AFK_ICON = "|TInterface\\FriendsFrame\\StatusIcon-Away:15:15|t";
		local DND_ICON = "|TInterface\\FriendsFrame\\StatusIcon-DnD:15:15|t";
		local PVP_ICON = "|TInterface\\GossipFrame\\BattleMasterGossipIcon:15:15|t";

		-- AFK / DND status
		if UnitIsAFK(targetType) then
			rightIcons = strconcat(rightIcons, AFK_ICON);
		elseif UnitIsDND(targetType) then
			rightIcons = strconcat(rightIcons, DND_ICON);
		end
		-- PVP icon
		if UnitIsPVP(targetType) then -- Icone PVP
			rightIcons = strconcat(rightIcons, PVP_ICON);
		end
		-- Beginner icon / volunteer icon
		do
			local experience = player:GetRoleplayExperience();
			local experienceIcon = TRP3_API.GetRoleplayExperienceIconMarkup(experience);

			if experienceIcon then
				rightIcons = strconcat(rightIcons, experienceIcon);
			end
		end
	end

	tooltipBuilder:AddDoubleLine(completeName, rightIcons, colors.MAIN, colors.MAIN, getMainLineFontSize());

	-- Player icon
	if showIcons() and info.characteristics and info.characteristics.IC then
		tooltipBuilder:AddTexture(TRP3_API.utils.getIconTexture(info.characteristics.IC), ICON_TEXTURE_OPTIONS);
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showFullTitle() then
		local fullTitle;

		if info.characteristics and info.characteristics.FT and info.characteristics.FT ~= "" then
			fullTitle = info.characteristics.FT;
		elseif UnitPVPName(targetType) ~= targetName then
			fullTitle = UnitPVPName(targetType);
		end

		if fullTitle and fullTitle ~= "" then
			if getConfigValue(ConfigKeys.CROP_TEXT) then
				fullTitle = crop(fullTitle, FIELDS_TO_CROP.TITLE);
			end

			tooltipBuilder:AddLine(strconcat("< ", fullTitle, " >"), colors.TITLE, getSubLineFontSize(), true);
		end
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- race, class, level and faction
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showRaceClass() then
		local lineLeft;
		local lineRight;
		local race = UnitRace(targetType);
		local class = localizedClass;
		if info.characteristics and info.characteristics.RA and info.characteristics.RA ~= "" then
			race = info.characteristics.RA;
		end
		if info.characteristics and info.characteristics.CL and info.characteristics.CL ~= "" then
			class = info.characteristics.CL;
		end
		if getConfigValue(ConfigKeys.CROP_TEXT) then
			race = crop(race, FIELDS_TO_CROP.RACE);
			class = crop(class, FIELDS_TO_CROP.CLASS);
		end
		lineLeft = strconcat(race, " ", color:WrapTextInColorCode(class));
		lineRight = loc.REG_TT_LEVEL:format(getLevelIconOrText(targetType), getFactionIcon(targetType));

		tooltipBuilder:AddDoubleLine(lineLeft, lineRight, colors.MAIN, colors.MAIN, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Realm
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local _, realm = UnitName(targetType);
	if showRealm() and realm then
		tooltipBuilder:AddLine(loc.REG_TT_REALM:format(colors.SECONDARY:WrapTextInColorCode(realm)), colors.MAIN, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Guild
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local guildDisplayOption = TRP3_API.configuration.getValue(ConfigKeys.CHARACT_GUILD);

	if guildDisplayOption ~= TooltipGuildDisplayOption.Hidden then
		local customGuildInfo = player:GetCustomGuildMembership();
		local customGuildName = customGuildInfo.name and string.trim(customGuildInfo.name) or nil;
		local customGuildRank = customGuildInfo.rank and string.trim(customGuildInfo.rank) or nil;

		if customGuildRank == "" then
			customGuildRank = nil;
		end

		local originalGuildName, originalGuildRank = GetGuildInfo(targetType);

		if ShouldDisplayOriginalGuild(guildDisplayOption, originalGuildName, customGuildName) then
			local displayName = crop(originalGuildName, FIELDS_TO_CROP.GUILD_NAME);
			local displayRank = crop(originalGuildRank or loc.DEFAULT_GUILD_RANK, FIELDS_TO_CROP.GUILD_RANK);
			local displayText = string.format(loc.REG_TT_GUILD, displayRank, colors.SECONDARY:WrapTextInColorCode(displayName));
			local displayMembership = "";

			if info.misc and info.misc.ST then
				if info.misc.ST["6"] == 1 then -- IC guild membership
					displayMembership = " |cff00ff00(" .. loc.REG_TT_GUILD_IC .. ")";
				elseif info.misc.ST["6"] == 2 then -- OOC guild membership
					displayMembership = " |cffff0000(" .. loc.REG_TT_GUILD_OOC .. ")";
				end
			end

			tooltipBuilder:AddDoubleLine(displayText, displayMembership, colors.MAIN, colors.MAIN, getSubLineFontSize());
		end

		if ShouldDisplayCustomGuild(guildDisplayOption, customGuildName) then
			local displayName = crop(customGuildName, FIELDS_TO_CROP.GUILD_NAME);
			local displayRank = crop(customGuildRank or loc.DEFAULT_GUILD_RANK, FIELDS_TO_CROP.GUILD_RANK);
			local displayText = string.format(loc.REG_TT_GUILD, displayRank, colors.SECONDARY:WrapTextInColorCode(displayName));
			local displayMembership = " |cff82c5ff(" .. loc.REG_TT_GUILD_CUSTOM .. ")";

			tooltipBuilder:AddDoubleLine(displayText, displayMembership, colors.MAIN, colors.MAIN, getSubLineFontSize());
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Relationship
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showRelationLine() and player:GetProfileID() then
		local relation = TRP3_API.register.relation.getRelation(player:GetProfileID());
		if relation and relation.id ~= "NONE" then
			local relationColor = TRP3_API.register.relation.getColor(relation) or colors.SECONDARY;
			local relationName = TRP3_API.register.relation.getRelationText(player:GetProfileID());
			tooltipBuilder:AddLine(loc.REG_RELATION .. ": " .. relationColor:WrapTextInColorCode(relationName), colors.MAIN, getSubLineFontSize());
		end
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- CURRENTLY
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCurrently() and info.character and info.character.CU and info.character.CU ~= "" then
		local text = strtrim(info.character.CU);

		if text ~= "" then
			text = limitText(text, getCurrentMaxSize(), getCurrentMaxLines());
			tooltipBuilder:AddLine(loc.DB_STATUS_CURRENTLY, colors.MAIN, getSubLineFontSize());
			tooltipBuilder:AddLine(text, colors.SECONDARY, getSmallLineFontSize(), true);
		end
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- OOC More information
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showMoreInformation() and info.character and info.character.CO and info.character.CO ~= "" then
		local text = strtrim(info.character.CO);

		if text ~= "" then
			text = limitText(text, getCurrentMaxSize(), getCurrentMaxLines());
			tooltipBuilder:AddLine(loc.DB_STATUS_CURRENTLY_OOC, colors.MAIN, getSubLineFontSize());
			tooltipBuilder:AddLine(text, colors.SECONDARY, getSmallLineFontSize(), true);
		end
	end

	tooltipBuilder:AddSpace();

	--
	-- Pronouns
	--

	if showPronouns() then
		local pronouns = player:GetCustomPronouns();

		if pronouns then
			local leftText = loc.REG_PLAYER_MISC_PRESET_PRONOUNS;
			local rightText = crop(pronouns, FIELDS_TO_CROP.PRONOUNS);
			local lineText = string.format("%1$s: %2$s", leftText, colors.SECONDARY:WrapTextInColorCode(rightText));

			tooltipBuilder:AddLine(lineText, colors.MAIN, getSubLineFontSize(), true);
		end
	end

	--
	-- Voice reference
	--

	if showVoiceReference() then
		local pronouns = player:GetCustomVoiceReference();

		if pronouns then
			local leftText = loc.REG_PLAYER_MISC_PRESET_VOICE_REFERENCE;
			local rightText = crop(pronouns, FIELDS_TO_CROP.VOICE_REFERENCE);
			local lineText = string.format("%1$s: %2$s", leftText, colors.SECONDARY:WrapTextInColorCode(rightText));

			tooltipBuilder:AddLine(lineText, colors.MAIN, getSubLineFontSize(), true);
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Target
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showTarget() and UnitExists(targetType .. "target") then
		local name = UnitName(targetType .. "target");
		local targetTargetID = getUnitID(targetType .. "target");
		if targetTargetID then
			local unitType = TRP3_API.ui.misc.getTargetType(targetType .. "target");

			local targetClassColor;
			if unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.BATTLE_PET or unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
				local owner, companionID = TRP3_API.utils.str.companionIDToInfo(targetTargetID);
				targetClassColor = TRP3_API.Colors.White;

				local profile;
				if owner == TRP3_API.globals.player_id then
					profile = TRP3_API.companions.player.getCompanionProfile(companionID);
				else
					profile = TRP3_API.companions.register.getCompanionProfile(targetTargetID);
				end

				if profile and profile.data then
					if getConfigValue(ConfigKeys.CHARACT_COLOR) then
						targetClassColor = profile.data.NH and TRP3_API.CreateColorFromHexString(profile.data.NH) or targetClassColor;
						targetClassColor = TRP3_API.GenerateReadableColor(targetClassColor, TRP3_ReadabilityOptions.TextOnBlackBackground);
					end

					name = profile.data.NA;
				end
			else
				---@type Player
				local targetTarget = AddOn_TotalRP3.Player.static.CreateFromCharacterID(targetTargetID)
				local _, targetEnglishClass = UnitClass(targetType .. "target");
				local targetInfo = getCharacterInfoTab(targetTargetID);
				targetClassColor = targetEnglishClass and TRP3_API.GetClassDisplayColor(targetEnglishClass) or TRP3_API.Colors.White;

				if getConfigValue(ConfigKeys.CHARACT_COLOR) then
					targetClassColor = targetTarget:GetCustomColorForDisplay() or targetClassColor;
				end

				name = getCompleteName(targetInfo.characteristics or {}, name, true);
			end

			if getConfigValue(ConfigKeys.CROP_TEXT) then
				name = crop(name, FIELDS_TO_CROP.NAME);
			end

			name = targetClassColor:WrapTextInColorCode(name);
		end
		tooltipBuilder:AddLine(loc.REG_TT_TARGET:format(name), colors.MAIN, getSubLineFontSize());
	end

	--
	-- Zone
	--

	if showZone() and targetType ~= "player" then
		local mapID = C_Map.GetBestMapForUnit(targetType);
		local playerMapID = C_Map.GetBestMapForUnit("player");
		if mapID and mapID ~= playerMapID then
			local mapInfo = C_Map.GetMapInfo(mapID);
			local lineText = string.format("%1$s: %2$s", TRP3_API.loc.REG_TT_ZONE, colors.SECONDARY:WrapTextInColorCode(mapInfo.name));
			tooltipBuilder:AddLine(lineText, colors.MAIN, getSubLineFontSize());
		end
	end

	--
	-- Health
	--

	local healthFormat = getConfigValue(ConfigKeys.CHARACT_HEALTH);
	if healthFormat ~= 0 then
		local targetHP = UnitHealth(targetType);
		local targetHPMax = UnitHealthMax(targetType);
		-- Don't show health if full
		if targetHP ~= targetHPMax then
			local percentHP = targetHP / targetHPMax;
			local lineText;

			local targetHPText = AbbreviateLargeNumbers(targetHP);
			local percentHPText = FormatPercentage(percentHP, true);
			local targetHPMaxText = AbbreviateLargeNumbers(targetHPMax);

			-- Number
			if healthFormat == 1 then
				local rightText = string.format("%1$s/%2$s", targetHPText, targetHPMaxText);
				lineText = string.format("%1$s: %2$s", HEALTH, colors.SECONDARY:WrapTextInColorCode(rightText));
				-- Percentage
			elseif healthFormat == 2 then
				local rightText = string.format("%1$s", percentHPText);
				lineText = string.format("%1$s: %2$s", HEALTH, colors.SECONDARY:WrapTextInColorCode(rightText));
				-- Both
			else
				local rightText = string.format("%1$s/%2$s (%3$s)", targetHPText, targetHPMaxText, percentHPText);
				lineText = string.format("%1$s: %2$s", HEALTH, colors.SECONDARY:WrapTextInColorCode(rightText));
			end
			tooltipBuilder:AddLine(lineText, colors.MAIN, getSubLineFontSize());
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Quick peek & new description notifications & Client
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showNotifications() then
		local notifPieces = {};

		if targetID ~= Globals.player_id and info.about and not info.about.read then
			table.insert(notifPieces, NEW_ABOUT_ICON);
		end

		if player:GetCharacterSpecificNotes() or player:GetAccountWideNotes() then
			table.insert(notifPieces, PROFILE_NOTES_ICON);
		end

		if player:IsWalkupFriendly() then
			table.insert(notifPieces, WALKUP_ICON);
		end

		-- Forcing an icon ensures the line height remains consistent. This
		-- also acts as the anchor for the progress spinner, so needs to be
		-- the last one.
		table.insert(notifPieces, TRANSPARENT_ICON);

		local notifText = table.concat(notifPieces, " ");

		local clientText = "";
		if targetID == Globals.player_id then
			clientText = strconcat(Utils.str.sanitize(Globals.addon_name_me), " v", Utils.str.sanitizeVersion(Globals.version_display));
			if Globals.extended_version then
				clientText = strconcat(clientText, " x ", Utils.str.sanitizeVersion(Globals.extended_display_version));
			end
			if AddOn_TotalRP3.Player.GetCurrentUser():IsOnATrialAccount() then
				clientText = strconcat(clientText, " ", colors.SECONDARY("(" .. loc.REG_TRIAL_ACCOUNT .. ")"));
			end
		elseif IsUnitIDKnown(targetID) then
			if character.client then
				clientText = strconcat(character.client, " v", character.clientVersion);
				if character.extendedVersion then
					clientText = strconcat(clientText, " x ", character.extendedVersion);
				end
			end
			if player:IsOnATrialAccount() then
				clientText = strconcat(clientText, " ", colors.SECONDARY("(" .. loc.REG_TRIAL_ACCOUNT .. ")"));
			end
		end
		if (notifText and notifText ~= "") or (clientText and clientText ~= "") then
			if notifText == "" then
				notifText = " "; -- Prevent bad right line height
			end
			tooltipBuilder:AddDoubleLine(notifText, clientText, colors.MAIN, colors.MAIN, getSmallLineFontSize());
		end

		SetProgressSpinnerShown(TRP3_CharacterTooltip, TRP3_API.register.HasActiveRequest(targetID));
	else
		SetProgressSpinnerShown(TRP3_CharacterTooltip, false);
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Build tooltip
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	tooltipBuilder:Build();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPANION TOOLTIP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local UnitBattlePetType, UnitBattlePetLevel, UnitCreatureType = UnitBattlePetType, UnitBattlePetLevel, UnitCreatureType;
local companionIDToInfo = Utils.str.companionIDToInfo;
local getCompanionProfile, getCompanionRegisterProfile;

local function showCompanionIcons()
	return getConfigValue(ConfigKeys.PETS_ICON);
end

local function showCompanionFullTitle()
	return getConfigValue(ConfigKeys.PETS_TITLE);
end

local function showCompanionOwner()
	return getConfigValue(ConfigKeys.PETS_OWNER);
end

local function showCompanionNotifications()
	return getConfigValue(ConfigKeys.PETS_NOTIF);
end

local function showCompanionWoWInfo()
	return getConfigValue(ConfigKeys.PETS_INFO);
end

local function getCompanionInfo(owner, companionID)
	local profile;
	if owner == Globals.player_id then
		profile = getCompanionProfile(companionID) or EMPTY;
	else
		profile = getCompanionRegisterProfile(owner .. "_" .. companionID) or EMPTY;
	end
	return profile or EMPTY;
end

local function ownerIsIgnored(compagnonFullID)
	local ownerID = companionIDToInfo(compagnonFullID);
	return isIDIgnored(ownerID);
end

local function writeCompanionTooltip(companionFullID, targetType, targetMode)
	local ownerID, companionID = companionIDToInfo(companionFullID);
	local data = getCompanionInfo(ownerID, companionID);
	local info = data.data or EMPTY;
	local targetName = UnitName(targetType);
	local colors = getTooltipTextColors();

	local FIELDS_TO_CROP = {
		TITLE = 150,
		NAME  = 100,
	}

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if isIDIgnored(ownerID) then
		tooltipBuilder:AddLine(loc.REG_TT_IGNORED_OWNER, TOOLTIP_BLOCKED_IGNORED_COLOR, getSubLineFontSize());
		tooltipBuilder:AddLine("\"" .. getIgnoreReason(ownerID) .. "\"", TOOLTIP_BLOCKED_MAIN_COLOR, getSmallLineFontSize());
		tooltipBuilder:Build();
		return;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Icon and name
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local petName = info.NA or targetName or UNKNOWN;

	if getConfigValue(ConfigKeys.CROP_TEXT) then
		petName = crop(petName, FIELDS_TO_CROP.NAME);
	end

	local companionCustomColor = info.NH and TRP3_API.CreateColorFromHexString(info.NH) or TRP3_API.Colors.White
	companionCustomColor = TRP3_API.GenerateReadableColor(companionCustomColor, TRP3_ReadabilityOptions.TextOnBlackBackground);
	tooltipBuilder:AddLine(companionCustomColor:WrapTextInColorCode((petName or companionID)), colors.MAIN, getMainLineFontSize());

	if showCompanionIcons() then
		-- Companion icon
		if info.IC then
			tooltipBuilder:AddTexture(TRP3_API.utils.getIconTexture(info.IC), ICON_TEXTURE_OPTIONS);
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionFullTitle() then
		local fullTitle = "";
		if info.TI then
			fullTitle = strconcat("< ", info.TI, " >");
		end
		if fullTitle and fullTitle ~= "" then

			if getConfigValue(ConfigKeys.CROP_TEXT) then
				fullTitle = crop(fullTitle, FIELDS_TO_CROP.TITLE);
			end
			tooltipBuilder:AddLine(fullTitle, colors.TITLE, getSubLineFontSize(), true);
		end
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Owner
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionOwner() then
		local ownerName, ownerRealm = unitIDToInfo(ownerID);
		local ownerFinalName, ownerColor = ownerName, TRP3_API.Colors.White;
		if ownerID == Globals.player_id or (IsUnitIDKnown(ownerID) and hasProfile(ownerID)) then
			local ownerInfo = getCharacterInfoTab(ownerID);
			if ownerInfo.characteristics then
				ownerFinalName = getCompleteName(ownerInfo.characteristics, ownerFinalName, true);

				if getConfigValue(ConfigKeys.CROP_TEXT) then
					ownerFinalName = crop(ownerFinalName, FIELDS_TO_CROP.NAME);
				end

				if getConfigValue(ConfigKeys.CHARACT_COLOR) and ownerInfo.characteristics.CH then
					local customColor = TRP3_API.CreateColorFromHexString(ownerInfo.characteristics.CH);
					customColor = TRP3_API.GenerateReadableColor(customColor, TRP3_ReadabilityOptions.TextOnBlackBackground);
					ownerColor = customColor or ownerColor;
				end
			end
		else
			if ownerRealm ~= Globals.player_realm_id then
				ownerFinalName = ownerID;
			end
		end

		ownerFinalName = ownerColor:WrapTextInColorCode(ownerFinalName);

		ownerFinalName = loc("REG_COMPANION_TF_OWNER"):format(ownerFinalName);

		tooltipBuilder:AddLine(ownerFinalName, colors.MAIN, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Wow info
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionWoWInfo() then
		local text;
		if targetMode == TRP3_Enums.UNIT_TYPE.PET then
			local creatureType = UnitCreatureType(targetType);
			if not creatureType then
				-- Can be nil if the creature type isn't available yet
				-- such as after freshly crossing a load screen.
				creatureType = UNKNOWNOBJECT;
			end

			text = TOOLTIP_UNIT_LEVEL_TYPE:format(UnitLevel(targetType) or "??", creatureType);
		elseif targetMode == TRP3_Enums.UNIT_TYPE.BATTLE_PET then
			if UnitBattlePetType then
				local type = UnitBattlePetType(targetType);
				if type then
					type = _G["BATTLE_PET_NAME_" .. type];
				end

				if not type then
					-- It's possible for UnitBattlePetType to return a non-nil
					-- value and for Blizzard to forget to define a global
					-- string for the localized type name.
					type = UNKNOWNOBJECT;
				end

				text = TOOLTIP_UNIT_LEVEL_TYPE:format(UnitBattlePetLevel(targetType) or "??", type);
			end
		end

		if text then
			tooltipBuilder:AddLine(text, colors.MAIN, getSubLineFontSize());
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Quick peek & new description notifications
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionNotifications() then
		local notifText = "";
		if ownerID ~= Globals.player_id and info.read == false then
			notifText = notifText .. " " .. NEW_ABOUT_ICON;
		end
		if notifText and notifText ~= "" then
			tooltipBuilder:AddLine(notifText, colors.MAIN, getSmallLineFontSize());
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Build tooltip
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	SetProgressSpinnerShown(TRP3_CharacterTooltip, false);
	tooltipBuilder:Build();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MOUNTS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tooltipCompanionBuilder = TRP3_API.ui.tooltip.createTooltipBuilder(TRP3_CompanionTooltip);
local getCurrentMountProfile = TRP3_API.companions.player.getCurrentMountProfile;
local getCurrentMountSpellID = TRP3_API.companions.player.getCurrentMountSpellID;
local getCompanionNameFromSpellID = TRP3_API.companions.getCompanionNameFromSpellID;

local function getMountProfile(ownerID, companionFullID)
	if ownerID == Globals.player_id then
		local profile, _ = getCurrentMountProfile();
		return profile;
	elseif companionFullID then
		local profile = getCompanionRegisterProfile(companionFullID);
		return profile;
	end
end

local function writeTooltipForMount(ownerID, companionFullID, mountName)
	if isIDIgnored(ownerID) then
		return;
	end

	local profile = getMountProfile(ownerID, companionFullID);
	local info = profile.data or EMPTY;
	local colors = getTooltipTextColors();


	local FIELDS_TO_CROP = {
		TITLE = 150,
		NAME  = 100
	}

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Icon and name
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local mountCustomName = info.NA

	if getConfigValue(ConfigKeys.CROP_TEXT) then
		mountCustomName = crop(mountCustomName, FIELDS_TO_CROP.NAME);
	end

	local mountCustomColor = info.NH and TRP3_API.CreateColorFromHexString(info.NH) or TRP3_API.Colors.White
	mountCustomColor = TRP3_API.GenerateReadableColor(mountCustomColor, TRP3_ReadabilityOptions.TextOnBlackBackground);
	tooltipCompanionBuilder:AddLine(mountCustomColor:WrapTextInColorCode((mountCustomName or mountName)), colors.MAIN, getMainLineFontSize());

	if showCompanionIcons() then
		-- Companion icon
		if info.IC then
			tooltipCompanionBuilder:AddTexture(TRP3_API.utils.getIconTexture(info.IC), ICON_TEXTURE_OPTIONS);
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionFullTitle() then
		local fullTitle = "";
		if info.TI then
			fullTitle = strconcat("< ", info.TI, " >");
		end
		if fullTitle and fullTitle ~= "" then
			if getConfigValue(ConfigKeys.CROP_TEXT) then
				fullTitle = crop(fullTitle, FIELDS_TO_CROP.TITLE);
			end
			tooltipCompanionBuilder:AddLine(fullTitle, colors.TITLE, getSubLineFontSize(), true);
		end
	end

	tooltipCompanionBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Wow info
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionWoWInfo() then
		tooltipCompanionBuilder:AddLine(loc.PR_CO_MOUNT .. " " .. mountCustomColor:WrapTextInColorCode(mountName), colors.MAIN, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Glance & new description notifications
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionNotifications() then
		local notifText = "";
		if ownerID ~= Globals.player_id and info.read == false then
			notifText = notifText .. " " .. NEW_ABOUT_ICON;
		end
		if notifText and notifText ~= "" then
			tooltipCompanionBuilder:AddLine(notifText, colors.MAIN, getSmallLineFontSize());
		end
	end

	tooltipCompanionBuilder:Build();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MAIN
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function UpdateCharacterTooltipClampInsets()
	local left = 0;
	local right = 0;
	local top = 15;
	local bottom = 0;

	if TRP3_CompanionTooltip:IsShown() then
		top = top + TRP3_CompanionTooltip:GetHeight();
	end

	TRP3_CharacterTooltip:SetClampRectInsets(left, right, top, bottom);
end

local function show(targetType, targetID, targetMode)
	TRP3_CharacterTooltip:Hide();
	TRP3_CompanionTooltip:Hide();

	-- If option is to only show tooltips when player is in character and player is out of character, stop here
	if getConfigValue(ConfigKeys.IN_CHARACTER_ONLY) and not isPlayerIC() then return end
	if getConfigValue(ConfigKeys.HIDE_IN_INSTANCE) and IsInInstance() then return end
	if ShouldDisplayUnmodifiedTooltip() then return; end

	-- If using TRP TT
	if not UnitAffectingCombat("player") or not getConfigValue(ConfigKeys.CHARACT_COMBAT) then
		-- If we have a target
		if targetID then
			TRP3_CharacterTooltip.target = targetID;
			TRP3_CharacterTooltip.targetType = targetType;
			TRP3_CharacterTooltip.targetMode = targetMode;
			TRP3_CompanionTooltip.target = targetID;
			TRP3_CompanionTooltip.targetType = targetType;
			TRP3_CompanionTooltip.targetMode = targetMode;

			-- Check if has a profile
			if getConfigValue(ConfigKeys.PROFILE_ONLY) then
				if targetMode == TRP3_Enums.UNIT_TYPE.CHARACTER and targetID ~= Globals.player_id and (not IsUnitIDKnown(targetID) or not hasProfile(targetID)) then
					return;
				end
				if (targetMode == TRP3_Enums.UNIT_TYPE.BATTLE_PET or targetMode == TRP3_Enums.UNIT_TYPE.PET) and (getCompanionInfo(companionIDToInfo(targetID)) == EMPTY) then
					return;
				end
			end

			-- We have a target
			if targetMode then

				-- Stock all the current text from the GameTooltip
				local isMatureFlagged = unitIDIsFilteredForMatureContent(targetID);

				if (targetMode == TRP3_Enums.UNIT_TYPE.CHARACTER and (isIDIgnored(targetID) or isMatureFlagged)) or ((targetMode == TRP3_Enums.UNIT_TYPE.BATTLE_PET or targetMode == TRP3_Enums.UNIT_TYPE.PET) and (ownerIsIgnored(targetID) or isMatureFlagged)) then
					TRP3_CharacterTooltip:SetOwner(GameTooltip, "ANCHOR_TOPRIGHT");
				elseif not getAnchoredFrame() then
					TRP3_API.ui.tooltip.setTooltipDefaultAnchor(TRP3_CharacterTooltip, UIParent);
				elseif getAnchoredPosition() == "ANCHOR_CURSOR" then
					TRP3_API.ui.tooltip.setTooltipDefaultAnchor(TRP3_CharacterTooltip, UIParent);
					placeTooltipOnCursor(TRP3_CharacterTooltip);
				elseif getAnchoredFrame() == GameTooltip and getConfigValue(ConfigKeys.CHARACT_HIDE_ORIGINAL) then
					if GameTooltip:GetOwner() ~= nil and GameTooltip:GetNumPoints() > 0 then
						TRP3_CharacterTooltip:SetOwner(UIParent, "ANCHOR_NONE");
						TRP3_CharacterTooltip:SetPoint(GameTooltip:GetPoint(1));
					else
						TRP3_API.ui.tooltip.setTooltipDefaultAnchor(TRP3_CharacterTooltip, UIParent);
					end
				else
					TRP3_CharacterTooltip:SetOwner(getAnchoredFrame(), getAnchoredPosition());
				end

				TRP3_CharacterTooltip:SetBorderColor(TRP3_API.ui.tooltip.tooltipBorderColor:GetRGB());
				if targetMode == TRP3_Enums.UNIT_TYPE.CHARACTER then
					writeTooltipForCharacter(targetID, targetType);
					if showRelationColor() and targetID ~= Globals.player_id and not isIDIgnored(targetID) and IsUnitIDKnown(targetID) and hasProfile(targetID) then
						local borderColor = getRelationColors(hasProfile(targetID));
						if borderColor then
							TRP3_CharacterTooltip:SetBorderColor(borderColor:GetRGB());
						end
					end
					if shouldHideGameTooltip() and not (isIDIgnored(targetID) or unitIDIsFilteredForMatureContent(targetID)) then
						GameTooltip:Hide();
					end
					-- Mounts
					if targetID == Globals.player_id and getCurrentMountProfile() then
						local mountSpellID = getCurrentMountSpellID();
						local mountName = getCompanionNameFromSpellID(mountSpellID);
						TRP3_CompanionTooltip:SetOwner(TRP3_CharacterTooltip, "ANCHOR_TOPLEFT");
						writeTooltipForMount(Globals.player_id, nil, mountName);
					else
						local companionFullID, profileID, mountSpellID = TRP3_API.companions.register.getUnitMount(targetID, targetType);
						if profileID then
							local mountName = getCompanionNameFromSpellID(mountSpellID);
							TRP3_CompanionTooltip:SetOwner(TRP3_CharacterTooltip, "ANCHOR_TOPLEFT");
							writeTooltipForMount(targetID, companionFullID, mountName);
						end
					end
				elseif targetMode == TRP3_Enums.UNIT_TYPE.BATTLE_PET or targetMode == TRP3_Enums.UNIT_TYPE.PET then
					writeCompanionTooltip(targetID, targetType, targetMode);
					if shouldHideGameTooltip() and not (ownerIsIgnored(targetID) or unitIDIsFilteredForMatureContent(targetID)) then
						GameTooltip:Hide();
					end
				end
			end

			TRP3_CharacterTooltip:ClearAllPoints(); -- Prevent to break parent frame fade out if parent is a tooltip.
		end
	end
end

local function getFadeTime()
	return (getAnchoredPosition() == "ANCHOR_CURSOR" or not fadeOutEnabled()) and 0.05 or 0.5;
end

local function onUpdate(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

	if getAnchoredPosition() == "ANCHOR_CURSOR" then
		placeTooltipOnCursor(self);
	end

	if (self.TimeSinceLastUpdate > getFadeTime()) then
		self.TimeSinceLastUpdate = 0;
		if self.target and self.targetType and not self.isFading then
			if self.target ~= getUnitID(self.targetType) or not getUnitID(self.targetType) then
				self.isFading = true;
				self.target = nil;
				if fadeOutEnabled() then
					self:FadeOut();
				else
					self:Hide();
				end
			end
		end
	end
end

local function onUpdateCompanion(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
	if (self.TimeSinceLastUpdate > getFadeTime()) then
		self.TimeSinceLastUpdate = 0;
		if self.target and self.targetType and not self.isFading then
			if self.target ~= getUnitID(self.targetType) or not getUnitID(self.targetType) then
				self.isFading = true;
				self.target = nil;
				if fadeOutEnabled() then
					self:FadeOut();
				else
					self:Hide();
				end
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function GetWorldCursorUnit()
	local tooltipData;

	if C_TooltipInfo and C_TooltipInfo.GetWorldCursor then
		tooltipData = C_TooltipInfo.GetWorldCursor();
	end

	if tooltipData and tooltipData.type == Enum.TooltipDataType.Unit then
		return UnitTokenFromGUID(tooltipData.guid);
	else
		return nil;
	end
end

local function GetCurrentTooltipUnit()
	local unitToken;

	if UnitExists("mouseover") then
		unitToken = "mouseover";
	elseif showWorldCursor() and getAnchoredPosition() ~= "ANCHOR_CURSOR" then
		-- World cursor units are not consulted if the tooltip is set to
		-- anchor to the cursor itself, as it looks a bit silly.
		unitToken = GetWorldCursorUnit();
	end

	return unitToken;
end

local function NotifyTooltipUnitChanged()
	local unitToken = GetCurrentTooltipUnit();

	if unitToken then
		local targetID, targetMode = getUnitID(unitToken);
		TRP3_Addon:TriggerEvent(Events.MOUSE_OVER_CHANGED, targetID, targetMode, unitToken);
	end
end

local function ShowUnitTooltip(unitToken)
	local targetID, targetMode = getUnitID(unitToken);

	if targetID and targetMode then
		show(unitToken, targetID, targetMode);
	end
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOAD, function()
	-- Listen to the mouse over event
	TRP3_API.RegisterCallback(TRP3_API.GameEvents, "UPDATE_MOUSEOVER_UNIT", NotifyTooltipUnitChanged);
	hooksecurefunc(GameTooltip, "SetUnit", NotifyTooltipUnitChanged);
	if GameTooltip.SetWorldCursor then
		hooksecurefunc(GameTooltip, "SetWorldCursor", NotifyTooltipUnitChanged);
	end
	GameTooltip:HookScript("OnShow", function()
		if not GameTooltip:GetUnit() then
			TRP3_CharacterTooltip:Hide();
			TRP3_CompanionTooltip:Hide();
		end
	end);
end);

local function onModuleInit()
	registerTooltipModuleIsEnabled = true;
	getCompanionProfile = TRP3_API.companions.player.getCompanionProfile;
	getCompanionRegisterProfile = TRP3_API.companions.register.getCompanionProfile;
	isPlayerIC = TRP3_API.dashboard.isPlayerIC;
	unitIDIsFilteredForMatureContent = TRP3_API.register.unitIDIsFilteredForMatureContent;

	TRP3_API.RegisterCallback(TRP3_Addon, Events.MOUSE_OVER_CHANGED, function(_, targetID, targetMode, unitID)
		show(unitID, targetID, targetMode);
	end);

	local function RefreshCharacterTooltip(targetID)
		local unitToken = GetCurrentTooltipUnit();

		if unitToken and (not targetID or TRP3_CharacterTooltip.target == targetID) then
			ShowUnitTooltip(unitToken);
		end
	end

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_DATA_UPDATED, function(_, targetID, _, _)
		RefreshCharacterTooltip(targetID);
	end);

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_REQUEST_STATE_CHANGED, function(_, targetID)
		RefreshCharacterTooltip(targetID);
	end);

	TRP3_API.RegisterCallback(TRP3_API.GameEvents, "MODIFIER_STATE_CHANGED", function()
		if TRP3_CharacterTooltip:IsShown() and ShouldDisplayUnmodifiedTooltip() then
			local unitToken = TRP3_CharacterTooltip.targetType;
			TRP3_CharacterTooltip:Hide();

			TRP3_API.ui.tooltip.setTooltipDefaultAnchor(GameTooltip, UIParent);
			GameTooltip:SetUnit(unitToken);
			GameTooltip:Show();
		elseif GameTooltip:IsShown() then
			local unitToken = (select(2, GameTooltip:GetUnit())) or "none";
			ShowUnitTooltip(unitToken);
		end
	end);

	TRP3_CharacterTooltip.TimeSinceLastUpdate = 0;
	TRP3_CharacterTooltip:SetScript("OnUpdate", onUpdate);
	TRP3_CompanionTooltip.TimeSinceLastUpdate = 0;
	TRP3_CompanionTooltip:SetScript("OnUpdate", onUpdateCompanion);
	TRP3_CompanionTooltip:HookScript("OnShow", UpdateCharacterTooltipClampInsets);
	TRP3_CompanionTooltip:HookScript("OnHide", UpdateCharacterTooltipClampInsets);

	-- Config default value
	local registerConfigKey = TRP3_API.configuration.registerConfigKey;
	registerConfigKey(ConfigKeys.PROFILE_ONLY, true);
	registerConfigKey(ConfigKeys.IN_CHARACTER_ONLY, false);
	registerConfigKey(ConfigKeys.CHARACT_COMBAT, false);
	registerConfigKey(ConfigKeys.HIDE_IN_INSTANCE, false);
	registerConfigKey(ConfigKeys.CHARACT_COLOR, true);
	registerConfigKey(ConfigKeys.CROP_TEXT, true);
	registerConfigKey(ConfigKeys.CHARACT_ANCHORED_FRAME, "GameTooltip");
	registerConfigKey(ConfigKeys.CHARACT_ANCHOR, "ANCHOR_TOPRIGHT");
	registerConfigKey(ConfigKeys.CHARACT_HIDE_ORIGINAL, true);
	registerConfigKey(ConfigKeys.HIDE_ON_MODIFIER, "ALT");
	registerConfigKey(ConfigKeys.CHARACT_MAIN_SIZE, 16);
	registerConfigKey(ConfigKeys.CHARACT_SUB_SIZE, 12);
	registerConfigKey(ConfigKeys.CHARACT_TER_SIZE, 10);
	registerConfigKey(ConfigKeys.CHARACT_ICONS, true);
	registerConfigKey(ConfigKeys.CHARACT_FT, true);
	registerConfigKey(ConfigKeys.CHARACT_RACECLASS, true);
	registerConfigKey(ConfigKeys.CHARACT_REALM, true);
	registerConfigKey(ConfigKeys.CHARACT_GUILD, TooltipGuildDisplayOption.ShowWithCustomGuild);
	registerConfigKey(ConfigKeys.CHARACT_TARGET, true);
	registerConfigKey(ConfigKeys.CHARACT_TITLE, true);
	registerConfigKey(ConfigKeys.CHARACT_NOTIF, true);
	registerConfigKey(ConfigKeys.CHARACT_CURRENT, true);
	registerConfigKey(ConfigKeys.CHARACT_OOC, true);
	registerConfigKey(ConfigKeys.CHARACT_PRONOUNS, true);
	registerConfigKey(ConfigKeys.CHARACT_VOICE_REFERENCE, true);
	registerConfigKey(ConfigKeys.CHARACT_ZONE, true);
	registerConfigKey(ConfigKeys.CHARACT_HEALTH, 0);
	registerConfigKey(ConfigKeys.CHARACT_CURRENT_SIZE, 140);
	registerConfigKey(ConfigKeys.CHARACT_RELATION_LINE, true);
	registerConfigKey(ConfigKeys.CHARACT_RELATION, true);
	registerConfigKey(ConfigKeys.CHARACT_SPACING, true);
	registerConfigKey(ConfigKeys.SHOW_WORLD_CURSOR, true);
	registerConfigKey(ConfigKeys.NO_FADE_OUT, false);
	registerConfigKey(ConfigKeys.PREFER_OOC_ICON, TRP3_OOCIndicatorStyle.Text);
	registerConfigKey(ConfigKeys.PETS_ICON, true);
	registerConfigKey(ConfigKeys.PETS_TITLE, true);
	registerConfigKey(ConfigKeys.PETS_OWNER, true);
	registerConfigKey(ConfigKeys.PETS_NOTIF, true);
	registerConfigKey(ConfigKeys.PETS_INFO, true);
	registerConfigKey(ConfigKeys.CHARACT_CURRENT_LINES, 4);
	registerConfigKey(ConfigKeys.TOOLTIP_TITLE_COLOR, "ff8000");
	registerConfigKey(ConfigKeys.TOOLTIP_MAIN_COLOR, "ffffff");
	registerConfigKey(ConfigKeys.TOOLTIP_SECONDARY_COLOR, "ffc000");

	local ANCHOR_TAB = {
		{loc.CO_ANCHOR_TOP_LEFT, "ANCHOR_TOPLEFT"},
		{loc.CO_ANCHOR_TOP, "ANCHOR_TOP"},
		{loc.CO_ANCHOR_TOP_RIGHT, "ANCHOR_TOPRIGHT"},
		{loc.CO_ANCHOR_RIGHT, "ANCHOR_RIGHT"},
		{loc.CO_ANCHOR_BOTTOM_RIGHT, "ANCHOR_BOTTOMRIGHT"},
		{loc.CO_ANCHOR_BOTTOM, "ANCHOR_BOTTOM"},
		{loc.CO_ANCHOR_BOTTOM_LEFT, "ANCHOR_BOTTOMLEFT"},
		{loc.CO_ANCHOR_LEFT, "ANCHOR_LEFT"},
		{loc.CO_ANCHOR_CURSOR, "ANCHOR_CURSOR"},
	};

	local OOC_INDICATOR_TYPES = {
		{loc.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_TEXT .. TRP3_API.Colors.Red("[" .. loc.CM_OOC .. "] "), TRP3_OOCIndicatorStyle.Text},
		{loc.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_ICON .. OOC_ICON, TRP3_OOCIndicatorStyle.Icon}
	};

	local HEALTH_FORMAT_TAB = {
		{loc.CO_TOOLTIP_HEALTH_DISABLED, 0},
		{loc.CO_TOOLTIP_HEALTH_NUMBER, 1},
		{loc.CO_TOOLTIP_HEALTH_PERCENT, 2},
		{loc.CO_TOOLTIP_HEALTH_BOTH, 3},
	};

	-- Build configuration page
	local CONFIG_STRUCTURE = {
		id = "main_config_tooltip",
		menuText = loc.CO_TOOLTIP,
		pageText = loc.CO_TOOLTIP,
		elements = {
			{
				inherit = "TRP3_ConfigH1",
				title = loc.CO_TOOLTIP_COMMON,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_PROFILE_ONLY,
				configKey = ConfigKeys.PROFILE_ONLY,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_IN_CHARACTER_ONLY,
				configKey = ConfigKeys.IN_CHARACTER_ONLY,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_COMBAT,
				configKey = ConfigKeys.CHARACT_COMBAT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_HIDE_IN_INSTANCE,
				configKey = ConfigKeys.HIDE_IN_INSTANCE,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = loc.CO_TOOLTIP_HIDE_ON_MODIFIER,
				help = loc.CO_TOOLTIP_HIDE_ON_MODIFIER_TT,
				listContent = {
					{loc.CO_TOOLTIP_HIDE_ON_MODIFIED_NEVER, ""},
					{loc.CM_ALT, "ALT"},
					{loc.CM_CTRL, "CTRL"},
					{loc.CM_SHIFT, "SHIFT"},
				},
				configKey = ConfigKeys.HIDE_ON_MODIFIER,
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_COLOR,
				configKey = ConfigKeys.CHARACT_COLOR,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_CROP_TEXT,
				configKey = ConfigKeys.CROP_TEXT,
				help = loc.CO_TOOLTIP_CROP_TEXT_TT
			},
			{
				inherit = "TRP3_ConfigEditBox",
				title = loc.CO_TOOLTIP_ANCHORED,
				configKey = ConfigKeys.CHARACT_ANCHORED_FRAME,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Charact_Anchor",
				title = loc.CO_TOOLTIP_ANCHOR,
				listContent = ANCHOR_TAB,
				configKey = ConfigKeys.CHARACT_ANCHOR,
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_HIDE_ORIGINAL,
				configKey = ConfigKeys.CHARACT_HIDE_ORIGINAL,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_MAINSIZE,
				configKey = ConfigKeys.CHARACT_MAIN_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_SUBSIZE,
				configKey = ConfigKeys.CHARACT_SUB_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_TERSIZE,
				configKey = ConfigKeys.CHARACT_TER_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigColorPicker",
				title = loc.CO_TOOLTIP_TITLE_COLOR,
				help = loc.CO_TOOLTIP_TITLE_COLOR_HELP,
				configKey = ConfigKeys.TOOLTIP_TITLE_COLOR,
			},
			{
				inherit = "TRP3_ConfigColorPicker",
				title = loc.CO_TOOLTIP_MAIN_COLOR,
				help = loc.CO_TOOLTIP_MAIN_COLOR_HELP,
				configKey = ConfigKeys.TOOLTIP_MAIN_COLOR,
			},
			{
				inherit = "TRP3_ConfigColorPicker",
				title = loc.CO_TOOLTIP_SECONDARY_COLOR,
				help = loc.CO_TOOLTIP_SECONDARY_COLOR_HELP,
				configKey = ConfigKeys.TOOLTIP_SECONDARY_COLOR,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_SPACING,
				help = loc.CO_TOOLTIP_SPACING_TT,
				configKey = ConfigKeys.CHARACT_SPACING,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_NO_FADE_OUT,
				configKey = ConfigKeys.NO_FADE_OUT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_SHOW_WORLD_CURSOR,
				help = loc.CO_TOOLTIP_SHOW_WORLD_CURSOR_TT,
				configKey = ConfigKeys.SHOW_WORLD_CURSOR,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc.CO_TOOLTIP_CHARACTER,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Charact_OOC_Indicator",
				title = loc.CO_TOOLTIP_PREFERRED_OOC_INDICATOR,
				listContent = OOC_INDICATOR_TYPES,
				configKey = ConfigKeys.PREFER_OOC_ICON,
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_ICONS,
				configKey = ConfigKeys.CHARACT_ICONS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_TITLE,
				configKey = ConfigKeys.CHARACT_TITLE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_FT,
				configKey = ConfigKeys.CHARACT_FT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_RACE,
				configKey = ConfigKeys.CHARACT_RACECLASS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_REALM,
				configKey = ConfigKeys.CHARACT_REALM,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = loc.CO_TOOLTIP_GUILD,
				listContent = {
					{ loc.CO_TOOLTIP_GUILD_HIDDEN, TooltipGuildDisplayOption.Hidden },
					{ loc.CO_TOOLTIP_GUILD_SHOW_WITH_ORIGINAL, TooltipGuildDisplayOption.ShowWithOriginalGuild },
					{ loc.CO_TOOLTIP_GUILD_SHOW_WITH_CUSTOM, TooltipGuildDisplayOption.ShowWithCustomGuild },
					{ loc.CO_TOOLTIP_GUILD_SHOW_WITH_ALL, TooltipGuildDisplayOption.ShowWithAllGuilds },
				},
				configKey = ConfigKeys.CHARACT_GUILD,
				help = (function()
					local lines = {};
					table.insert(lines, loc.CO_TOOLTIP_GUILD_TT);
					table.insert(lines, string.format("|cff00ff00%s:|r %s", loc.CO_TOOLTIP_GUILD_HIDDEN, loc.CO_TOOLTIP_GUILD_TT_HIDDEN));
					table.insert(lines, string.format("|cff00ff00%s:|r %s", loc.CO_TOOLTIP_GUILD_SHOW_WITH_ORIGINAL, loc.CO_TOOLTIP_GUILD_TT_SHOW_WITH_ORIGINAL));
					table.insert(lines, string.format("|cff00ff00%s:|r %s", loc.CO_TOOLTIP_GUILD_SHOW_WITH_CUSTOM, loc.CO_TOOLTIP_GUILD_TT_SHOW_WITH_CUSTOM));
					table.insert(lines, string.format("|cff00ff00%s:|r %s", loc.CO_TOOLTIP_GUILD_SHOW_WITH_ALL, loc.CO_TOOLTIP_GUILD_TT_SHOW_WITH_ALL));
					return table.concat(lines, "|n|n");
				end)(),
				listWidth = nil,
				listCancel = false,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_TARGET,
				configKey = ConfigKeys.CHARACT_TARGET,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_CURRENT,
				configKey = ConfigKeys.CHARACT_CURRENT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.DB_STATUS_CURRENTLY_OOC,
				configKey = ConfigKeys.CHARACT_OOC,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_PRONOUNS,
				configKey = ConfigKeys.CHARACT_PRONOUNS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_VOICE_REFERENCE,
				configKey = ConfigKeys.CHARACT_VOICE_REFERENCE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_ZONE,
				help = loc.CO_TOOLTIP_ZONE_TT,
				configKey = ConfigKeys.CHARACT_ZONE,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Charact_Health",
				title = loc.CO_TOOLTIP_HEALTH,
				listContent = HEALTH_FORMAT_TAB,
				configKey = ConfigKeys.CHARACT_HEALTH,
				help = loc.CO_TOOLTIP_HEALTH_TT,
				listWidth = nil,
				listCancel = false,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_NOTIF,
				configKey = ConfigKeys.CHARACT_NOTIF,
				help = loc.CO_TOOLTIP_NOTIF_TT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_RELATION_LINE,
				configKey = ConfigKeys.CHARACT_RELATION_LINE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_RELATION,
				help = loc.CO_TOOLTIP_RELATION_TT,
				configKey = ConfigKeys.CHARACT_RELATION,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_CURRENT_SIZE,
				configKey = ConfigKeys.CHARACT_CURRENT_SIZE,
				min = 40,
				max = 200,
				step = 10,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_CURRENT_LINES,
				configKey = ConfigKeys.CHARACT_CURRENT_LINES,
				min = 0,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc.CO_TOOLTIP_PETS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_ICONS,
				configKey = ConfigKeys.PETS_ICON,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_FT,
				configKey = ConfigKeys.PETS_TITLE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_OWNER,
				configKey = ConfigKeys.PETS_OWNER,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_PETS_INFO,
				configKey = ConfigKeys.PETS_INFO,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_NOTIF,
				configKey = ConfigKeys.PETS_NOTIF,
			},
		}
	}

	TRP3_API.ui.tooltip.CONFIG = CONFIG_STRUCTURE;

	TRP3_API.configuration.registerConfigurationPage(CONFIG_STRUCTURE);
end

local MODULE_STRUCTURE = {
	["name"] = "Characters and companions tooltip",
	["description"] = "Use TRP3 custom tooltip for characters and companions",
	["version"] = 1.000,
	["id"] = "trp3_tooltips",
	["onStart"] = onModuleInit,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
