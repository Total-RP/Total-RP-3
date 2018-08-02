----------------------------------------------------------------------------------
-- Total RP 3
-- Characters and companions tooltip
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

-- imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local colorCode, hexaToNumber, getTempTable, releaseTempTable = Utils.color.colorCode, Utils.color.hexaToNumber, Utils.table.getTempTable, Utils.table.releaseTempTable;
local loc = TRP3_API.loc;
local getUnitIDCurrentProfile, isIDIgnored = TRP3_API.register.getUnitIDCurrentProfile, TRP3_API.register.isIDIgnored;
local getIgnoreReason = TRP3_API.register.getIgnoreReason;
local ui_CharacterTT, ui_CompanionTT = TRP3_CharacterTooltip, TRP3_CompanionTooltip;
local getCharacterUnitID = Utils.str.getUnitID;
local get = TRP3_API.profile.getData;
local getConfigValue = TRP3_API.configuration.getValue;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local strconcat = strconcat;
local getCompleteName = TRP3_API.register.getCompleteName;
local getOtherCharacter = TRP3_API.register.getUnitIDCharacter;
local getYourCharacter = TRP3_API.profile.getPlayerCharacter;
local IsUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local UnitAffectingCombat = UnitAffectingCombat;
local Events = TRP3_API.events;
local GameTooltip, _G, pairs, wipe, tinsert, strtrim = GameTooltip, _G, pairs, wipe, tinsert, strtrim;
local UnitName, UnitPVPName, UnitFactionGroup, UnitIsAFK, UnitIsDND = UnitName, UnitPVPName, UnitFactionGroup, UnitIsAFK, UnitIsDND;
local UnitIsPVP, UnitRace, UnitLevel, GetGuildInfo, UnitIsPlayer, UnitClass = UnitIsPVP, UnitRace, UnitLevel, GetGuildInfo, UnitIsPlayer, UnitClass;
local hasProfile, getRelationColors = TRP3_API.register.hasProfile, TRP3_API.register.relation.getRelationColors;
local checkGlanceActivation = TRP3_API.register.checkGlanceActivation;
local IC_GUILD, OOC_GUILD;
local originalGetTargetType, getCompanionFullID = TRP3_API.ui.misc.getTargetType, TRP3_API.ui.misc.getCompanionFullID;
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
local EMPTY = Globals.empty;
local unitIDToInfo = Utils.str.unitIDToInfo;
local lightenColorUntilItIsReadable = Utils.color.lightenColorUntilItIsReadable;
local isPlayerIC;
local unitIDIsFilteredForMatureContent;
local crop = Utils.str.crop;
local IsAltKeyDown = IsAltKeyDown;
local ColorManager = TRP3_API.Ellyb.ColorManager;

-- ICONS
local AFK_ICON = "|TInterface\\FriendsFrame\\StatusIcon-Away:15:15|t";
local DND_ICON = "|TInterface\\FriendsFrame\\StatusIcon-DnD:15:15|t";
local OOC_ICON = "|TInterface\\COMMON\\Indicator-Red:15:15|t";
local ALLIANCE_ICON = "|TInterface\\GROUPFRAME\\UI-Group-PVP-Alliance:20:20|t";
local HORDE_ICON = "|TInterface\\GROUPFRAME\\UI-Group-PVP-Horde:20:20|t";
local PVP_ICON = "|TInterface\\GossipFrame\\BattleMasterGossipIcon:15:15|t";
local BEGINNER_ICON = "|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20:20|t";
local VOLUNTEER_ICON = "|TInterface\\TARGETINGFRAME\\PortraitQuestBadge:15:15|t";
local BANNED_ICON = "|TInterface\\EncounterJournal\\UI-EJ-HeroicTextIcon:15:15|t";
local GLANCE_ICON = "|TInterface\\MINIMAP\\TRACKING\\None:18:18|t";
local NEW_ABOUT_ICON = "|TInterface\\Buttons\\UI-GuildButton-PublicNote-Up:18:18|t";
local PEEK_ICON_SIZE = 20;

-- Config keys
local CONFIG_PROFILE_ONLY = "tooltip_profile_only";
local CONFIG_IN_CHARACTER_ONLY = "tooltip_in_character_only";
local CONFIG_CHARACT_COMBAT = "tooltip_char_combat";
local CONFIG_CHARACT_COLOR = "tooltip_char_color";
local CONFIG_CROP_TEXT = "tooltip_crop_text";
local CONFIG_CHARACT_CONTRAST = "tooltip_char_contrast";
local CONFIG_CHARACT_ANCHORED_FRAME = "tooltip_char_AnchoredFrame";
local CONFIG_CHARACT_ANCHOR = "tooltip_char_Anchor";
local CONFIG_CHARACT_HIDE_ORIGINAL = "tooltip_char_HideOriginal";
local CONFIG_CHARACT_MAIN_SIZE = "tooltip_char_mainSize";
local CONFIG_CHARACT_SUB_SIZE = "tooltip_char_subSize";
local CONFIG_CHARACT_TER_SIZE = "tooltip_char_terSize";
local CONFIG_CHARACT_ICONS = "tooltip_char_icons";
local CONFIG_CHARACT_FT = "tooltip_char_ft";
local CONFIG_CHARACT_RACECLASS = "tooltip_char_rc";
local CONFIG_CHARACT_REALM = "tooltip_char_realm";
local CONFIG_CHARACT_GUILD = "tooltip_char_guild";
local CONFIG_CHARACT_TARGET = "tooltip_char_target";
local CONFIG_CHARACT_TITLE = "tooltip_char_title";
local CONFIG_CHARACT_NOTIF = "tooltip_char_notif";
local CONFIG_CHARACT_CURRENT = "tooltip_char_current";
local CONFIG_CHARACT_OOC = "tooltip_char_ooc";
local CONFIG_CHARACT_CURRENT_SIZE = "tooltip_char_current_size";
local CONFIG_CHARACT_RELATION = "tooltip_char_relation";
local CONFIG_CHARACT_SPACING = "tooltip_char_spacing";
local CONFIG_NO_FADE_OUT = "tooltip_no_fade_out";
local CONFIG_PREFER_OOC_ICON = "tooltip_prefere_ooc_icon";
local CONFIG_CHARACT_CURRENT_LINES = "tooltip_char_current_lines";

local ANCHOR_TAB;

local MATURE_CONTENT_ICON = Utils.str.texture("Interface\\AddOns\\totalRP3\\resources\\18_emoji.tga", 20);
local registerTooltipModuleIsEnabled = false;

local currentDate = date("*t");
local seriousDay = currentDate.month == 4 and currentDate.day == 1
local Rainbowify = TRP3_API.utils.Rainbowify;

local isTrial = IsTrialAccount();

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config getters
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getAnchoredFrame()
	if getConfigValue(CONFIG_CHARACT_ANCHORED_FRAME) == "" then return nil end;
	return _G[getConfigValue(CONFIG_CHARACT_ANCHORED_FRAME)] or GameTooltip;
end

local function showRelationColor()
	return getConfigValue(CONFIG_CHARACT_RELATION);
end

local function getAnchoredPosition()
	return getConfigValue(CONFIG_CHARACT_ANCHOR);
end

local function shouldHideGameTooltip()
	return getConfigValue(CONFIG_CHARACT_HIDE_ORIGINAL);
end
TRP3_API.ui.tooltip.shouldHideGameTooltip = shouldHideGameTooltip;

local function getMainLineFontSize()
	return getConfigValue(CONFIG_CHARACT_MAIN_SIZE);
end
TRP3_API.ui.tooltip.getMainLineFontSize = getMainLineFontSize;

local function getSubLineFontSize()
	return getConfigValue(CONFIG_CHARACT_SUB_SIZE);
end
TRP3_API.ui.tooltip.getSubLineFontSize = getSubLineFontSize;

local function getSmallLineFontSize()
	return getConfigValue(CONFIG_CHARACT_TER_SIZE);
end
TRP3_API.ui.tooltip.getSmallLineFontSize = getSmallLineFontSize;

function TRP3_API.ui.tooltip.shouldCropTexts()
	if not registerTooltipModuleIsEnabled then
		return true;
	else
		return getConfigValue(CONFIG_CROP_TEXT);
	end
end

local function showIcons()
	return getConfigValue(CONFIG_CHARACT_ICONS);
end

local function showFullTitle()
	return getConfigValue(CONFIG_CHARACT_FT);
end

local function showRaceClass()
	return getConfigValue(CONFIG_CHARACT_RACECLASS);
end

local function showRealm()
	return getConfigValue(CONFIG_CHARACT_REALM);
end

local function showGuild()
	return getConfigValue(CONFIG_CHARACT_GUILD);
end

local function showTarget()
	return getConfigValue(CONFIG_CHARACT_TARGET);
end

local function showTitle()
	return getConfigValue(CONFIG_CHARACT_TITLE);
end

local function showNotifications()
	return getConfigValue(CONFIG_CHARACT_NOTIF);
end

local function showCurrently()
	return getConfigValue(CONFIG_CHARACT_CURRENT);
end

local function showMoreInformation()
	return getConfigValue(CONFIG_CHARACT_OOC);
end

local function getCurrentMaxSize()
	return getConfigValue(CONFIG_CHARACT_CURRENT_SIZE);
end

local function showSpacing()
	return getConfigValue(CONFIG_CHARACT_SPACING);
end

local function fadeOutEnabled()
	return not getConfigValue(CONFIG_NO_FADE_OUT);
end

local function getCurrentMaxLines()
	return getConfigValue(CONFIG_CHARACT_CURRENT_LINES);
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

local function setLineFont(tooltip, lineIndex, fontSize)
	local line = _G[strconcat(tooltip:GetName(), "TextLeft", lineIndex)];
	local font, _ , flag = line:GetFont();
	line:SetFont(font, fontSize, flag);
end

local function setDoubleLineFont(tooltip, lineIndex, fontSize)
	setLineFont(tooltip, lineIndex, fontSize);
	local line = _G[strconcat(tooltip:GetName(), "TextRight", lineIndex)];
	local font, _ , flag = line:GetFont();
	line:SetFont(font, fontSize, flag);
end

local GetCursorPosition = GetCursorPosition;
local function placeTooltipOnCursor(tooltip)
	local effScale, x, y = ui_CharacterTT:GetEffectiveScale(), GetCursorPosition();
	ui_CharacterTT:ClearAllPoints();
	ui_CharacterTT:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (x / effScale) + 10, (y / effScale) + 10);
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

		return string.sub(input, 1, maxCharLength) .. "…";
	end

	-- Otherwise extract the substring up to the character preceeding the
	-- last matched newline or to the maximum allowable length of the text,
	-- whichever is shorter.
	return string.sub(input, 1, math.min(finish - 1, maxCharLength)) .. "…";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TOOLTIP BUILDER
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local BUILDER_TYPE_LINE = 1;
local BUILDER_TYPE_DOUBLELINE = 2;
local BUILDER_TYPE_SPACE = 3;

local function AddLine(self, text, red, green, blue, lineSize, lineWrap)
	local lineStructure = getTempTable();
	lineStructure.type = BUILDER_TYPE_LINE;
	lineStructure.text = text;
	lineStructure.red = red;
	lineStructure.green = green;
	lineStructure.blue = blue;
	lineStructure.lineSize = lineSize;
	lineStructure.lineWrap = lineWrap;
	tinsert(self._content, lineStructure);
end

local function AddDoubleLine(self, textL, textR, redL, greenL, blueL, redR, greenR, blueR, lineSize)
	local lineStructure = getTempTable();
	lineStructure.type = BUILDER_TYPE_DOUBLELINE;
	lineStructure.textL = textL;
	lineStructure.redL = redL;
	lineStructure.greenL = greenL;
	lineStructure.blueL = blueL;
	lineStructure.textR = textR;
	lineStructure.redR = redR;
	lineStructure.greenR = greenR;
	lineStructure.blueR = blueR;
	lineStructure.lineSize = lineSize;
	tinsert(self._content, lineStructure);
end

local function AddSpace(self)
	if #self._content > 0 and self._content[#self._content].type == BUILDER_TYPE_SPACE then
		return; -- Don't add two spaces in a row.
	end
	local lineStructure = getTempTable();
	lineStructure.type = BUILDER_TYPE_SPACE;
	tinsert(self._content, lineStructure);
end

local function Build(self)
	local size = #self._content;
	local tooltipLineIndex = 1;
	for lineIndex, line in pairs(self._content) do
		if line.type == BUILDER_TYPE_LINE then
			self.tooltip:AddLine(line.text, line.red, line.green, line.blue, line.lineWrap);
			setLineFont(self.tooltip, tooltipLineIndex, line.lineSize);
			tooltipLineIndex = tooltipLineIndex + 1;
		elseif line.type == BUILDER_TYPE_DOUBLELINE then
			self.tooltip:AddDoubleLine(line.textL, line.textR, line.redL, line.greenL, line.blueL, line.redR, line.greenR, line.blueR);
			setDoubleLineFont(self.tooltip, tooltipLineIndex, line.lineSize);
			tooltipLineIndex = tooltipLineIndex + 1;
		elseif line.type == BUILDER_TYPE_SPACE and showSpacing() and lineIndex ~= size then
			self.tooltip:AddLine(" ", 1, 0.50, 0);
			setLineFont(self.tooltip, tooltipLineIndex, getSubLineFontSize());
			tooltipLineIndex = tooltipLineIndex + 1;
		end
	end
	self.tooltip:Show();
	for index, tempTable in pairs(self._content) do
		self._content[index] = nil;
		releaseTempTable(tempTable);
	end
end

local function createTooltipBuilder(tooltip)
	local builder = {
		_content = {},
		tooltip = tooltip,
	};
	builder.AddLine = AddLine;
	builder.AddDoubleLine = AddDoubleLine;
	builder.AddSpace = AddSpace;
	builder.Build = Build;
	return builder;
end
TRP3_API.ui.tooltip.createTooltipBuilder = createTooltipBuilder;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTER TOOLTIP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tooltipBuilder = createTooltipBuilder(ui_CharacterTT);

local function getUnitID(targetType)
	local currentTargetType = originalGetTargetType(targetType);
	if currentTargetType == TYPE_CHARACTER then
		return getCharacterUnitID(targetType), currentTargetType;
	elseif currentTargetType == TYPE_BATTLE_PET or currentTargetType == TYPE_PET then
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




--- The complete character's tooltip writing sequence.
local function writeTooltipForCharacter(targetID, originalTexts, targetType)
	local info = getCharacterInfoTab(targetID);
	local character = getCharacter(targetID);
	local targetName = UnitName(targetType);

	local FIELDS_TO_CROP = {
		TITLE = 150,
		NAME  = 100,
		RACE  = 50,
		CLASS = 50,
	}

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if isIDIgnored(targetID) then
		tooltipBuilder:AddLine(loc.REG_TT_IGNORED, 1, 0, 0, getSubLineFontSize());
		tooltipBuilder:AddLine("\"" .. getIgnoreReason(targetID) .. "\"", 1, 0.75, 0, getSmallLineFontSize());
		tooltipBuilder:Build();
		return;
    elseif unitIDIsFilteredForMatureContent(targetID) then
        tooltipBuilder:AddLine(MATURE_CONTENT_ICON .. " " .. loc.MATURE_FILTER_TOOLTIP_WARNING, 1, 0.75, 0.86, getSubLineFontSize());
        tooltipBuilder:AddLine(loc.MATURE_FILTER_TOOLTIP_WARNING_SUBTEXT, 1, 0.75, 0, getSmallLineFontSize(), true);
        tooltipBuilder:Build();
        return;
    end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- icon, complete name, RP/AFK/PVP/Volunteer status
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local localizedClass, englishClass = UnitClass(targetType);
	local color = Utils.color.getClassColor(englishClass);
	local rightIcons = "";
	local leftIcons = "";


    -- Only use custom colors if the option is enabled and if we have one
    if getConfigValue(CONFIG_CHARACT_COLOR) and info.characteristics and info.characteristics.CH then
        local customColor = Utils.color.getColorFromHexadecimalCode(info.characteristics.CH);
	
		if getConfigValue(CONFIG_CHARACT_CONTRAST) then
			customColor:LightenColorUntilItIsReadable();
		end
		
		color = customColor or color;
    end


	local completeName = getCompleteName(info.characteristics or {}, targetName, not showTitle());

	if getConfigValue(CONFIG_CROP_TEXT) then
		completeName = crop(completeName, FIELDS_TO_CROP.NAME);
	end

	completeName = color:WrapTextInColorCode(completeName);

	-- OOC
	if info.character and info.character.RP ~= 1 then
		if getConfigValue(CONFIG_PREFER_OOC_ICON) == "TEXT" then
			completeName = strconcat(ColorManager.RED("[" .. loc.CM_OOC .. "] "), completeName);
		else
			rightIcons = strconcat(rightIcons, OOC_ICON);
		end
	end

	if showIcons() then
		-- Player icon
		if info.characteristics and info.characteristics.IC then
			leftIcons = strconcat(Utils.str.icon(info.characteristics.IC, 25), leftIcons, " ");
		end
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
		if info.character and info.character.XP == 1 then
			rightIcons = strconcat(rightIcons, BEGINNER_ICON);
		elseif info.character and info.character.XP == 3 then
			rightIcons = strconcat(rightIcons, VOLUNTEER_ICON);
		end
	end

	tooltipBuilder:AddDoubleLine(leftIcons .. completeName, rightIcons, 1, 1, 1, 1, 1, 1, getMainLineFontSize());

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showFullTitle() then
		local fullTitle = "";
		if info.characteristics and info.characteristics.FT and info.characteristics.FT:len() > 0 then
			fullTitle = info.characteristics.FT;
		elseif UnitPVPName(targetType) ~= targetName then
			fullTitle = UnitPVPName(targetType);
		end
		if fullTitle:len() > 0 then

			if getConfigValue(CONFIG_CROP_TEXT) then
				fullTitle = crop(fullTitle, FIELDS_TO_CROP.TITLE);
			end

			tooltipBuilder:AddLine(strconcat("< ", fullTitle, " |r>"), 1, 0.50, 0, getSubLineFontSize(), true);
		end
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- race, class, level and faction
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showRaceClass() then
		local lineLeft = "";
		local lineRight;
		local race = UnitRace(targetType);
		local class = localizedClass;
		if info.characteristics and info.characteristics.RA and info.characteristics.RA:len() > 0 then
			race = info.characteristics.RA;
		end
		if info.characteristics and info.characteristics.CL and info.characteristics.CL:len() > 0 then
			class = info.characteristics.CL;
		end
		if getConfigValue(CONFIG_CROP_TEXT) then
			race = crop(race, FIELDS_TO_CROP.RACE);
			class = crop(class, FIELDS_TO_CROP.CLASS);
		end
		lineLeft = strconcat("|cffffffff", race, " ", color:WrapTextInColorCode(class));
		lineRight = strconcat("|cffffffff", loc.REG_TT_LEVEL:format(getLevelIconOrText(targetType), getFactionIcon(targetType)));

		tooltipBuilder:AddDoubleLine(lineLeft, lineRight, 1, 1, 1, 1, 1, 1, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Realm
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local _, realm = UnitName(targetType);
	if showRealm() and realm then
		tooltipBuilder:AddLine(loc.REG_TT_REALM:format(realm), 1, 1, 1, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Guild
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local guild, grade = GetGuildInfo(targetType);
	if showGuild() and guild then
		local text = loc.REG_TT_GUILD:format(grade, guild);
		local membership;
		if info.misc and info.misc.ST then
			if info.misc.ST["6"] == 1 then -- IC guild membership
				membership = IC_GUILD;
			elseif info.misc.ST["6"] == 2 then -- OOC guild membership
				membership = OOC_GUILD;
			end
		end
		tooltipBuilder:AddDoubleLine(text, membership, 1, 1, 1, 1, 1, 1, getSubLineFontSize());
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- CURRENTLY
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCurrently() and info.character and (info.character.CU or ""):len() > 0 then
		tooltipBuilder:AddLine(loc.REG_PLAYER_CURRENT, 1, 1, 1, getSubLineFontSize());

		local text = strtrim(info.character.CU);
		text = limitText(text, getCurrentMaxSize(), getCurrentMaxLines());
		tooltipBuilder:AddLine(text, 1, 0.75, 0, getSmallLineFontSize(), true);
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- OOC More information
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showMoreInformation() and info.character and (info.character.CO or ""):len() > 0 then
		tooltipBuilder:AddLine(loc.DB_STATUS_CURRENTLY_OOC, 1, 1, 1, getSubLineFontSize());

		local text = strtrim(info.character.CO);
		text = limitText(text, getCurrentMaxSize(), getCurrentMaxLines());
		tooltipBuilder:AddLine(text, 1, 0.75, 0, getSmallLineFontSize(), true);
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Target
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showTarget() and UnitName(targetType .. "target") then
		local name = UnitName(targetType .. "target");
		local targetTargetID = getUnitID(targetType .. "target");
		if targetTargetID then
			local localizedClass, englishClass = UnitClass(targetType .. "target");
			local targetInfo = getCharacterInfoTab(targetTargetID);
			local color = englishClass and Utils.color.getClassColor(englishClass) or Utils.color.CreateColor(1, 1, 1, 1);
			
			-- Only use custom colors if the option is enabled and if we have one
			if getConfigValue(CONFIG_CHARACT_COLOR) and targetInfo.characteristics and targetInfo.characteristics.CH then
				local customColor = Utils.color.getColorFromHexadecimalCode(targetInfo.characteristics.CH);
				
				if getConfigValue(CONFIG_CHARACT_CONTRAST) then
					customColor:LightenColorUntilItIsReadable();
				end
				
				color = customColor or color;
			end
			
			name = getCompleteName(targetInfo.characteristics or {}, name, true);

			if getConfigValue(CONFIG_CROP_TEXT) then
				name = crop(name, FIELDS_TO_CROP.NAME);
			end

			name = color:WrapTextInColorCode(name);
		end
		tooltipBuilder:AddLine(loc.REG_TT_TARGET:format(name), 1, 1, 1, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Quick peek & new description notifications & Client
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showNotifications() then
		local notifText = "";
		if info.misc and info.misc.PE and checkGlanceActivation(info.misc.PE) then
			notifText = GLANCE_ICON;
		end
		if targetID ~= Globals.player_id and info.about and not info.about.read then
			notifText = notifText .. " " ..NEW_ABOUT_ICON;
		end
		local clientText = "";
		if targetID == Globals.player_id then
			clientText = strconcat("|cffffffff", Globals.addon_name_me, " v", Globals.version_display);
			if isTrial then
				clientText = strconcat(clientText, " ", ColorManager.ORANGE("(" .. loc.REG_TRIAL_ACCOUNT .. ")"));
			end
		elseif IsUnitIDKnown(targetID) then
			if character.client then
				clientText = strconcat("|cffffffff", character.client, " v", character.clientVersion);
			end
			if character.isTrial then
				clientText = strconcat(clientText, " ", ColorManager.ORANGE("(" .. loc.REG_TRIAL_ACCOUNT .. ")"));
			end
		end
		if notifText:len() > 0 or clientText:len() > 0 then
			if notifText:len() == 0 then
				notifText = " "; -- Prevent bad right line height
			end
			tooltipBuilder:AddDoubleLine(notifText, clientText, 1, 1, 1, 0, 1, 0, getSmallLineFontSize());
		end
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

local CONFIG_PETS_ICON = "tooltip_pets_icons";
local CONFIG_PETS_TITLE = "tooltip_pets_title";
local CONFIG_PETS_OWNER = "tooltip_pets_owner";
local CONFIG_PETS_NOTIF = "tooltip_pets_notif";
local CONFIG_PETS_INFO = "tooltip_pets_info";

local function showCompanionIcons()
	return getConfigValue(CONFIG_PETS_ICON);
end

local function showCompanionFullTitle()
	return getConfigValue(CONFIG_PETS_TITLE);
end

local function showCompanionOwner()
	return getConfigValue(CONFIG_PETS_OWNER);
end

local function showCompanionNotifications()
	return getConfigValue(CONFIG_PETS_NOTIF);
end

local function showCompanionWoWInfo()
	return getConfigValue(CONFIG_PETS_INFO);
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
	local ownerID, companionID = companionIDToInfo(compagnonFullID);
	return isIDIgnored(ownerID);
end

local function writeCompanionTooltip(companionFullID, originalTexts, targetType, targetMode)
	local ownerID, companionID = companionIDToInfo(companionFullID);
	local data = getCompanionInfo(ownerID, companionID);
	local info = data.data or EMPTY;
	local PE = data.PE or EMPTY;
	local targetName = UnitName(targetType);
	local companionFamily = UnitCreatureType(targetType);


	local FIELDS_TO_CROP = {
		TITLE = 150,
		NAME  = 100
	}


	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if isIDIgnored(ownerID) then
		tooltipBuilder:AddLine(loc.REG_TT_IGNORED_OWNER, 1, 0, 0, getSubLineFontSize());
		tooltipBuilder:AddLine("\"" .. getIgnoreReason(ownerID) .. "\"", 1, 0.75, 0, getSmallLineFontSize());
		tooltipBuilder:Build();
		return;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Icon and name
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local leftIcons = "";

	if showCompanionIcons() then
		-- Companion icon
		if info.IC then
			leftIcons = strconcat(Utils.str.icon(info.IC, 25), leftIcons, " ");
		end
	end

	local petName = info.NA or targetName or UNKNOWN;

	if getConfigValue(CONFIG_CROP_TEXT) then
		petName = crop(petName, FIELDS_TO_CROP.NAME);
	end

	if seriousDay and getConfigValue("AF_STUFF") then
		petName = Rainbowify(petName);
	end


	tooltipBuilder:AddLine(leftIcons .. "|cff" .. (info.NH or "ffffff") .. (petName or companionID), 1, 1, 1, getMainLineFontSize());

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionFullTitle() then
		local fullTitle = "";
		if info.TI then
			fullTitle = strconcat("< ", info.TI, " |r>");
		end
		if fullTitle:len() > 0 then

			if getConfigValue(CONFIG_CROP_TEXT) then
				fullTitle = crop(fullTitle, FIELDS_TO_CROP.TITLE);
			end
			tooltipBuilder:AddLine(fullTitle, 1, 0.50, 0, getSubLineFontSize());
		end
	end

	tooltipBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Owner
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionOwner() then
		local ownerName, ownerRealm = unitIDToInfo(ownerID);
		local ownerFinalName, ownerColor = ownerName, Utils.color.CreateColor(1, 1, 1, 1);
		if ownerID == Globals.player_id or (IsUnitIDKnown(ownerID) and hasProfile(ownerID)) then
			local ownerInfo = getCharacterInfoTab(ownerID);
			if ownerInfo.characteristics then
				ownerFinalName = getCompleteName(ownerInfo.characteristics, ownerFinalName, true);

				if getConfigValue(CONFIG_CROP_TEXT) then
					ownerFinalName = crop(ownerFinalName, FIELDS_TO_CROP.NAME);
				end

				if getConfigValue(CONFIG_CHARACT_COLOR) and ownerInfo.characteristics.CH then
					local customColor = Utils.color.getColorFromHexadecimalCode(ownerInfo.characteristics.CH);
						
						if getConfigValue(CONFIG_CHARACT_CONTRAST) then
							customColor:LightenColorUntilItIsReadable();
						end
					
					ownerColor = customColor or ownerColor;
				end
			end
		else
			if ownerRealm ~= Globals.player_realm_id then
				ownerFinalName = ownerID;
			end
		end

		if seriousDay and getConfigValue("AF_STUFF") then
			ownerFinalName = Rainbowify(ownerFinalName);
		else
			ownerFinalName = ownerColor:WrapTextInColorCode(ownerFinalName);
		end
		ownerFinalName = loc("REG_COMPANION_TF_OWNER"):format(ownerFinalName);

		tooltipBuilder:AddLine(ownerFinalName, 1, 1, 1, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Wow info
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionWoWInfo() then
		local text;
		if targetMode == TYPE_PET then
			local creatureType = UnitCreatureType(targetType);
			text = TOOLTIP_UNIT_LEVEL_TYPE:format(UnitLevel(targetType) or "??", creatureType);
		elseif targetMode == TYPE_BATTLE_PET then
			local type = UnitBattlePetType(targetType);
			local type = _G["BATTLE_PET_NAME_" .. type];
			text = TOOLTIP_UNIT_LEVEL_TYPE:format(UnitBattlePetLevel(targetType) or "??", type);
		end

		tooltipBuilder:AddLine(text, 1, 1, 1, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Quick peek & new description notifications
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionNotifications() then
		local notifText = "";
		if PE and checkGlanceActivation(PE) then
			notifText = GLANCE_ICON;
		end
		if ownerID ~= Globals.player_id and info.read == false then
			notifText = notifText .. " " .. NEW_ABOUT_ICON;
		end
		if notifText:len() > 0 then
			tooltipBuilder:AddLine(notifText, 1, 1, 1, getSmallLineFontSize());
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Build tooltip
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	tooltipBuilder:Build();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MOUNTS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tooltipCompanionBuilder = createTooltipBuilder(ui_CompanionTT);
local getCurrentMountProfile = TRP3_API.companions.player.getCurrentMountProfile;
local getCurrentMountSpellID = TRP3_API.companions.player.getCurrentMountSpellID;
local getCompanionNameFromSpellID = TRP3_API.companions.getCompanionNameFromSpellID;

local function getMountProfile(ownerID, companionFullID)
	if ownerID == Globals.player_id then
		local profile, profileID = getCurrentMountProfile();
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
	local PE = profile.PE or EMPTY;


	local FIELDS_TO_CROP = {
		TITLE = 150,
		NAME  = 100
	}

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Icon and name
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local leftIcons = "";

	if showCompanionIcons() then
		-- Companion icon
		if info.IC then
			leftIcons = strconcat(Utils.str.icon(info.IC, 25), leftIcons, " ");
		end
	end
	local mountCustomName = info.NA

	if getConfigValue(CONFIG_CROP_TEXT) then
		mountCustomName = crop(mountCustomName, FIELDS_TO_CROP.NAME);
	end

	if seriousDay and getConfigValue("AF_STUFF") then
		mountCustomName = Rainbowify(mountCustomName);
	end


	tooltipCompanionBuilder:AddLine(leftIcons .. "|cff" .. (info.NH or "ffffff") .. (mountCustomName or mountName), 1, 1, 1, getMainLineFontSize());

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionFullTitle() then
		local fullTitle = "";
		if info.TI then
			fullTitle = strconcat("< ", info.TI, " |r>");
		end
		if fullTitle:len() > 0 then
			if getConfigValue(CONFIG_CROP_TEXT) then
				fullTitle = crop(fullTitle, FIELDS_TO_CROP.TITLE);
			end
			tooltipCompanionBuilder:AddLine(fullTitle, 1, 0.50, 0, getSubLineFontSize());
		end
	end

	tooltipCompanionBuilder:AddSpace();

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Wow info
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionWoWInfo() then
		tooltipCompanionBuilder:AddLine(loc.PR_CO_MOUNT .. " |cff" .. (info.NH or "ffffff") .. mountName, 1, 1, 1, getSubLineFontSize());
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Glance & new description notifications
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionNotifications() then
		local notifText = "";
		if PE and checkGlanceActivation(PE) then
			notifText = GLANCE_ICON;
		end
		if ownerID ~= Globals.player_id and info.read == false then
			notifText = notifText .. " " .. NEW_ABOUT_ICON;
		end
		if notifText:len() > 0 then
			tooltipCompanionBuilder:AddLine(notifText, 1, 1, 1, getSmallLineFontSize());
		end
	end

	tooltipCompanionBuilder:Build();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MAIN
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GameTooltip_SetDefaultAnchor, UIParent = GameTooltip_SetDefaultAnchor, UIParent;

local function show(targetType, targetID, targetMode)
	ui_CharacterTT:Hide();
	ui_CompanionTT:Hide();

	-- If option is to only show tooltips when player is in character and player is out of character, stop here
	if getConfigValue(CONFIG_IN_CHARACTER_ONLY) and not isPlayerIC() then return end

	-- If using TRP TT
	if not UnitAffectingCombat("player") or not getConfigValue(CONFIG_CHARACT_COMBAT) then
		-- If we have a target
		if targetID then
			ui_CharacterTT.target = targetID;
			ui_CharacterTT.targetType = targetType;
			ui_CharacterTT.targetMode = targetMode;
			ui_CompanionTT.target = targetID;
			ui_CompanionTT.targetType = targetType;
			ui_CompanionTT.targetMode = targetMode;

			-- Check if has a profile
			if getConfigValue(CONFIG_PROFILE_ONLY) then
				if targetMode == TYPE_CHARACTER and targetID ~= Globals.player_id and (not IsUnitIDKnown(targetID) or not hasProfile(targetID)) then
					return;
				end
				if (targetMode == TYPE_BATTLE_PET or targetMode == TYPE_PET) and (getCompanionInfo(companionIDToInfo(targetID)) == EMPTY) then
					return;
				end
			end

			-- We have a target
			if targetMode then

				-- Stock all the current text from the GameTooltip
				local originalTexts = getGameTooltipTexts(GameTooltip);

				if (targetMode == TYPE_CHARACTER and isIDIgnored(targetID)) or ((targetMode == TYPE_BATTLE_PET or targetMode == TYPE_PET) and ownerIsIgnored(targetID)) then
					ui_CharacterTT:SetOwner(GameTooltip, "ANCHOR_TOPRIGHT");
				elseif not getAnchoredFrame() then
					GameTooltip_SetDefaultAnchor(ui_CharacterTT, UIParent);
				elseif getAnchoredPosition() == "ANCHOR_CURSOR" then
					GameTooltip_SetDefaultAnchor(ui_CharacterTT, UIParent);
					placeTooltipOnCursor(ui_CharacterTT);
				else
					ui_CharacterTT:SetOwner(getAnchoredFrame(), getAnchoredPosition());
				end

				ui_CharacterTT:SetBackdropBorderColor(1, 1, 1);
				if targetMode == TYPE_CHARACTER then
					writeTooltipForCharacter(targetID, originalTexts, targetType);
					if showRelationColor() and targetID ~= Globals.player_id and not isIDIgnored(targetID) and IsUnitIDKnown(targetID) and hasProfile(targetID) then
						ui_CharacterTT:SetBackdropBorderColor(getRelationColors(hasProfile(targetID)));
					end
					if shouldHideGameTooltip() and not (isIDIgnored(targetID) or unitIDIsFilteredForMatureContent(targetID)) then
						GameTooltip:Hide();
					end
					-- Mounts
					if targetID == Globals.player_id and getCurrentMountProfile() then
						local mountSpellID = getCurrentMountSpellID();
						local mountName = getCompanionNameFromSpellID(mountSpellID);
						ui_CompanionTT:SetOwner(ui_CharacterTT, "ANCHOR_TOPLEFT");
						writeTooltipForMount(Globals.player_id, nil, mountName);
					else
						local companionFullID, profileID, mountSpellID = TRP3_API.companions.register.getUnitMount(targetID, "mouseover");
						if profileID then
							local mountName = getCompanionNameFromSpellID(mountSpellID);
							ui_CompanionTT:SetOwner(ui_CharacterTT, "ANCHOR_TOPLEFT");
							writeTooltipForMount(targetID, companionFullID, mountName);
						end
					end
				elseif targetMode == TYPE_BATTLE_PET or targetMode == TYPE_PET then
					writeCompanionTooltip(targetID, originalTexts, targetType, targetMode);
					if shouldHideGameTooltip() and not (ownerIsIgnored(targetID) or unitIDIsFilteredForMatureContent(targetID)) then
						GameTooltip:Hide();
					end
				end
			end

			ui_CharacterTT:ClearAllPoints(); -- Prevent to break parent frame fade out if parent is a tooltip.
		end
	end
end

local function getFadeTime()
	return (getAnchoredPosition() == "ANCHOR_CURSOR" or not fadeOutEnabled()) and 0 or 0.5;
end

local function onUpdate(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

	if getAnchoredPosition() == "ANCHOR_CURSOR" then
		placeTooltipOnCursor(self);
	end

	if (self.TimeSinceLastUpdate > getFadeTime()) then
		self.TimeSinceLastUpdate = 0;
		if self.target and self.targetType and not self.isFading then
			if self.target ~= getUnitID(self.targetType) then
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
			if self.target ~= getUnitID(self.targetType) then
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	-- Listen to the mouse over event
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", function(...)
		-- The event UPDATE_MOUSEOVER_UNIT is fired even when there is no unit on tooltip
		-- But there is a target on mouseover (maintaining ALT on spell buttons)
		-- So we need to check that we have indeed a unit before displaying our tooltip.
		if GameTooltip:GetUnit() then
			local targetID, targetMode = getUnitID("mouseover");
			Events.fireEvent(Events.MOUSE_OVER_CHANGED, targetID, targetMode);
		end
	end);
end);

local function onModuleInit()
	registerTooltipModuleIsEnabled = true;
	getCompanionProfile = TRP3_API.companions.player.getCompanionProfile;
	getCompanionRegisterProfile = TRP3_API.companions.register.getCompanionProfile;
    isPlayerIC = TRP3_API.dashboard.isPlayerIC;
	unitIDIsFilteredForMatureContent = TRP3_API.register.unitIDIsFilteredForMatureContent;

	Events.listenToEvent(Events.MOUSE_OVER_CHANGED, function(targetID, targetMode)
		show("mouseover", targetID, targetMode);
	end);

	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, profileID, dataType)
		if not unitID or (ui_CharacterTT.target == unitID) then
			show("mouseover", getUnitID("mouseover"));
		end
	end);

	ui_CharacterTT.TimeSinceLastUpdate = 0;
	ui_CharacterTT:SetScript("OnUpdate", onUpdate);
	ui_CompanionTT.TimeSinceLastUpdate = 0;
	ui_CompanionTT:SetScript("OnUpdate", onUpdateCompanion);

	IC_GUILD = " |cff00ff00(" .. loc.REG_TT_GUILD_IC .. ")";
	OOC_GUILD = " |cffff0000(" .. loc.REG_TT_GUILD_OOC .. ")";

	-- Config default value
	registerConfigKey(CONFIG_PROFILE_ONLY, true);
	registerConfigKey(CONFIG_IN_CHARACTER_ONLY, false);
	registerConfigKey(CONFIG_CHARACT_COMBAT, false);
	registerConfigKey(CONFIG_CHARACT_COLOR, true);
	registerConfigKey(CONFIG_CHARACT_CONTRAST, false);
	registerConfigKey(CONFIG_CROP_TEXT, true);
	registerConfigKey(CONFIG_CHARACT_ANCHORED_FRAME, "GameTooltip");
	registerConfigKey(CONFIG_CHARACT_ANCHOR, "ANCHOR_TOPRIGHT");
	registerConfigKey(CONFIG_CHARACT_HIDE_ORIGINAL, true);
	registerConfigKey(CONFIG_CHARACT_MAIN_SIZE, 16);
	registerConfigKey(CONFIG_CHARACT_SUB_SIZE, 12);
	registerConfigKey(CONFIG_CHARACT_TER_SIZE, 10);
	registerConfigKey(CONFIG_CHARACT_ICONS, true);
	registerConfigKey(CONFIG_CHARACT_FT, true);
	registerConfigKey(CONFIG_CHARACT_RACECLASS, true);
	registerConfigKey(CONFIG_CHARACT_REALM, true);
	registerConfigKey(CONFIG_CHARACT_GUILD, true);
	registerConfigKey(CONFIG_CHARACT_TARGET, true);
	registerConfigKey(CONFIG_CHARACT_TITLE, true);
	registerConfigKey(CONFIG_CHARACT_NOTIF, true);
	registerConfigKey(CONFIG_CHARACT_CURRENT, true);
	registerConfigKey(CONFIG_CHARACT_OOC, true);
	registerConfigKey(CONFIG_CHARACT_CURRENT_SIZE, 140);
	registerConfigKey(CONFIG_CHARACT_RELATION, true);
	registerConfigKey(CONFIG_CHARACT_SPACING, true);
	registerConfigKey(CONFIG_NO_FADE_OUT, false);
	registerConfigKey(CONFIG_PREFER_OOC_ICON, "TEXT");
	registerConfigKey(CONFIG_PETS_ICON, true);
	registerConfigKey(CONFIG_PETS_TITLE, true);
	registerConfigKey(CONFIG_PETS_OWNER, true);
	registerConfigKey(CONFIG_PETS_NOTIF, true);
	registerConfigKey(CONFIG_PETS_INFO, true);
	registerConfigKey(CONFIG_CHARACT_CURRENT_LINES, 4);

	ANCHOR_TAB = {
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
		{loc.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_TEXT .. ColorManager.RED("[" .. loc.CM_OOC .. "] "), "TEXT"},
		{loc.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_ICON .. OOC_ICON, "ICON"}
	}

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
				configKey = CONFIG_PROFILE_ONLY,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_IN_CHARACTER_ONLY,
				configKey = CONFIG_IN_CHARACTER_ONLY,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_COMBAT,
				configKey = CONFIG_CHARACT_COMBAT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_COLOR,
				configKey = CONFIG_CHARACT_COLOR,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_CONTRAST,
				configKey = CONFIG_CHARACT_CONTRAST,
				help = loc.CO_TOOLTIP_CONTRAST_TT,
				dependentOnOptions = {CONFIG_CHARACT_COLOR},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_CROP_TEXT,
				configKey = CONFIG_CROP_TEXT,
				help = loc.CO_TOOLTIP_CROP_TEXT_TT
			},
			{
				inherit = "TRP3_ConfigEditBox",
				title = loc.CO_TOOLTIP_ANCHORED,
				configKey = CONFIG_CHARACT_ANCHORED_FRAME,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Charact_Anchor",
				title = loc.CO_TOOLTIP_ANCHOR,
				listContent = ANCHOR_TAB,
				configKey = CONFIG_CHARACT_ANCHOR,
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_HIDE_ORIGINAL,
				configKey = CONFIG_CHARACT_HIDE_ORIGINAL,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_MAINSIZE,
				configKey = CONFIG_CHARACT_MAIN_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_SUBSIZE,
				configKey = CONFIG_CHARACT_SUB_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_TERSIZE,
				configKey = CONFIG_CHARACT_TER_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_SPACING,
				help = loc.CO_TOOLTIP_SPACING_TT,
				configKey = CONFIG_CHARACT_SPACING,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_NO_FADE_OUT,
				configKey = CONFIG_NO_FADE_OUT,
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
				configKey = CONFIG_PREFER_OOC_ICON,
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_ICONS,
				configKey = CONFIG_CHARACT_ICONS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_TITLE,
				configKey = CONFIG_CHARACT_TITLE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_FT,
				configKey = CONFIG_CHARACT_FT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_RACE,
				configKey = CONFIG_CHARACT_RACECLASS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_REALM,
				configKey = CONFIG_CHARACT_REALM,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_GUILD,
				configKey = CONFIG_CHARACT_GUILD,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_TARGET,
				configKey = CONFIG_CHARACT_TARGET,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_CURRENT,
				configKey = CONFIG_CHARACT_CURRENT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.DB_STATUS_CURRENTLY_OOC,
				configKey = CONFIG_CHARACT_OOC,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_NOTIF,
				configKey = CONFIG_CHARACT_NOTIF,
				help = loc.CO_TOOLTIP_NOTIF_TT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_RELATION,
				help = loc.CO_TOOLTIP_RELATION_TT,
				configKey = CONFIG_CHARACT_RELATION,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_CURRENT_SIZE,
				configKey = CONFIG_CHARACT_CURRENT_SIZE,
				min = 40,
				max = 200,
				step = 10,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_TOOLTIP_CURRENT_LINES,
				configKey = CONFIG_CHARACT_CURRENT_LINES,
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
				configKey = CONFIG_PETS_ICON,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_FT,
				configKey = CONFIG_PETS_TITLE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_OWNER,
				configKey = CONFIG_PETS_OWNER,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_PETS_INFO,
				configKey = CONFIG_PETS_INFO,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_TOOLTIP_NOTIF,
				configKey = CONFIG_PETS_NOTIF,
			},
		}
	}

	if seriousDay then
		registerConfigKey("AF_STUFF", true);
		tinsert(CONFIG_STRUCTURE.elements, 2, {
				inherit = "TRP3_ConfigCheck",
				title = Rainbowify("Enable April Fools' joke"),
				help = "Disable this option to remove this year's April Fools' joke.",
				configKey = "AF_STUFF",
			})
	end

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