--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : RP Style section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local getUnitID = Utils.str.unitInfoToID;
local colorCodeFloat = Utils.color.colorCodeFloat;
local loc = TRP3_L;
local getCurrentProfile = TRP3_REGISTER.getCurrentProfile;
local ui_CharacterTT = TRP3_CharacterTooltip;
local getUnitID = Utils.str.getUnitID;
local get = TRP3_PROFILE.getData;
local Config = TRP3_CONFIG;
local getConfigValue = TRP3_CONFIG.getValue;
local registerConfigKey = TRP3_CONFIG.registerConfigKey;
local strconcat = strconcat;
local getOtherCharacter = TRP3_REGISTER.getCharacter;
local getYourCharacter = TRP3_PROFILE.getCharacter;
local IsUnitIDKnown = TRP3_IsUnitIDKnown;
local UnitAffectingCombat = UnitAffectingCombat;
local Events = TRP3_EVENTS;
local GameTooltip, _G, pairs = GameTooltip, _G, pairs;
local UnitName, UnitPVPName, UnitFactionGroup, UnitIsAFK, UnitIsDND = UnitName, UnitPVPName, UnitFactionGroup, UnitIsAFK, UnitIsDND;
local UnitIsPVP, UnitRace, UnitLevel, GetGuildInfo, UnitIsPlayer, UnitClass = UnitIsPVP, UnitRace, UnitLevel, GetGuildInfo, UnitIsPlayer, UnitClass;

local IC_GUILD, OOC_GUILD;

-- ICONS
local AFK_ICON = "Spell_Nature_Sleep";
local DND_ICON = "Ability_Mage_IncantersAbsorbtion";
local ALLIANCE_ICON = "INV_BannerPVP_02";
local HORDE_ICON = "INV_BannerPVP_01";
local PVP_ICON = "Ability_DualWield";
local BEGINNER_ICON = "inv_misc_toy_01";
local VOLUNTEER_ICON = "achievement_bg_tophealer_AB";
local PEEK_ICON_SIZE = 20;

-- Config keys
local CONFIG_CHARACT_COMBAT = "tooltip_char_combat";
local CONFIG_CHARACT_USE = "tooltip_char_use";
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
local CONFIG_CHARACT_CLIENT = "tooltip_char_client";
local CONFIG_CHARACT_NOTIF = "tooltip_char_notif";
local CONFIG_CHARACT_CURRENT = "tooltip_char_current";
local CONFIG_CHARACT_CURRENT_SIZE = "tooltip_char_current_size";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config getters
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getAnchoredFrame()
	return _G[getConfigValue(CONFIG_CHARACT_ANCHORED_FRAME)] or GameTooltip or error("Can't find any frame to anchor.");
end

local function getAnchoredPosition()
	return getConfigValue(CONFIG_CHARACT_ANCHOR);
end

local function shouldHideGameTooltip()
	return getConfigValue(CONFIG_CHARACT_HIDE_ORIGINAL);
end

local function getMainLineFontSize()
	return getConfigValue(CONFIG_CHARACT_MAIN_SIZE);
end

local function getSubLineFontSize()
	return getConfigValue(CONFIG_CHARACT_SUB_SIZE);
end

local function getSmallLineFontSize()
	return getConfigValue(CONFIG_CHARACT_TER_SIZE);
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

local function showClient()
	return getConfigValue(CONFIG_CHARACT_CLIENT);
end

local function showNotifications()
	return getConfigValue(CONFIG_CHARACT_NOTIF);
end

local function showCurrently()
	return getConfigValue(CONFIG_CHARACT_CURRENT);
end

local function getCurrentMaxSize()
	return getConfigValue(CONFIG_CHARACT_CURRENT_SIZE);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTIL METHOD
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getGameTooltipTexts()
	local tab = {};
	for j = 1, GameTooltip:NumLines() do
		tab[j] = _G["GameTooltipTextLeft" ..  j]:GetText();
	end
	return tab;
end

local function setLineFont(tooltip, lineIndex, fontSize)
	_G[strconcat(tooltip:GetName(), "TextLeft", lineIndex)]:SetFont("Fonts\\FRIZQT__.TTF", fontSize);
end

local function setDoubleLineFont(tooltip, lineIndex, fontSize)
	setLineFont(tooltip, lineIndex, fontSize);
	_G[strconcat(tooltip:GetName(), "TextRight", lineIndex)]:SetFont("Fonts\\FRIZQT__.TTF", fontSize);
end

local function checkGlanceActivation(dataTab)
	for _, glanceTab in pairs(dataTab) do
		if glanceTab.AC then return true end
	end
	return false;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTER TOOLTIP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Returns a not nil table containing the character information.
-- The returned table is not nil, but could be empty.
local function getCharacterInfoTab(unitID)
	if unitID == Globals.player_id then
		return get("player");
	elseif TRP3_IsUnitIDKnown(unitID) then
		return getCurrentProfile(unitID) or {};
	end
	return {};
end

local function getCharacter(unitID)
	if unitID == Globals.player_id then
		return getYourCharacter();
	elseif TRP3_IsUnitIDKnown(unitID) then
		return getOtherCharacter(unitID);
	end
	return {};
end

--- The complete character's tooltip writing sequence.
local function writeTooltipForCharacter(targetID, originalTexts, targetType)
	local lineIndex = 1;
	local info = getCharacterInfoTab(targetID);
	local character = getCharacter(targetID);
	local targetName = UnitName(targetType);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- icon, complete name, RP/AFK/PVP/Volunteer status
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local localizedClass, englishClass = UnitClass(targetType);
	local classColor = RAID_CLASS_COLORS[englishClass];
	local completeName = TRP3_GetCompleteName(info.characteristics or {}, targetName, not showTitle());
	local rightIcons = "";
	local leftIcons = "";

	if showIcons() then
		-- Player icon
		if info.characteristics and info.characteristics.IC then
			leftIcons = strconcat(Utils.str.icon(info.characteristics.IC, 25), leftIcons);
		elseif UnitFactionGroup(targetType) == "Alliance" then
			leftIcons = strconcat(Utils.str.icon(ALLIANCE_ICON, 25), leftIcons);
		elseif UnitFactionGroup(targetType) == "Horde" then
			leftIcons = strconcat(Utils.str.icon(HORDE_ICON, 25), leftIcons);
		end
		-- AFK / DND status
		if UnitIsAFK(targetType) then
			rightIcons = strconcat(rightIcons, Utils.str.icon(AFK_ICON, 25));
		elseif UnitIsDND(targetType) then
			rightIcons = strconcat(rightIcons, Utils.str.icon(DND_ICON, 25));
		end
		-- PVP icon
		if UnitIsPVP(targetType) then -- Icone PVP
			rightIcons = strconcat(rightIcons, Utils.str.icon(PVP_ICON, 25));
		end
		-- Beginner icon / volunteer icon
		if character.XP == 1 then
			rightIcons = strconcat(Utils.str.icon(BEGINNER_ICON, 25), rightIcons);
		elseif character.XP == 3 then
			rightIcons = strconcat(Utils.str.icon(VOLUNTEER_ICON, 25), rightIcons);
		end
	end
	
	if character.RP ~= 1 then
		completeName = completeName .. "|cffff0000 " .. loc("REG_TT_OOC");
	end

	ui_CharacterTT:AddDoubleLine(leftIcons .. " " .. completeName, rightIcons);
	setDoubleLineFont(ui_CharacterTT, lineIndex, getMainLineFontSize());
	_G[strconcat(ui_CharacterTT:GetName(), "TextLeft", lineIndex)]:SetTextColor(classColor.r, classColor.g, classColor.b);
	lineIndex = lineIndex + 1;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showFullTitle() then
		local fullTitle = "";
		if info.characteristics and info.characteristics.FT then
			fullTitle = strconcat("< ", info.characteristics.FT, " >");
		elseif UnitPVPName(targetType) ~= targetName then
			fullTitle = strconcat("< ", UnitPVPName(targetType), " >");
		end
		if fullTitle:len() > 0 then
			ui_CharacterTT:AddLine(fullTitle, 1, 0.50, 0);
			setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- race, class and level
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showRaceClass() then
		local lineLeft = "";
		local lineRight;
		local race = UnitRace(targetType);
		local class = localizedClass;
		if info.characteristics and info.characteristics.RA then
			race = info.characteristics.RA;
		end
		if info.characteristics and info.characteristics.CL then
			class = info.characteristics.CL;
		end
		lineLeft = strconcat("|cffffffff", race, " ", colorCodeFloat(classColor.r, classColor.g, classColor.b), class);

		if UnitLevel(targetType) ~= -1 then
			lineRight = strconcat("|cffffffff(", loc("REG_TT_LEVEL"):format(UnitLevel(targetType)), ")");
		else
			lineRight = strconcat("|cffffffff(", loc("REG_TT_LEVEL"):format("|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Skull:16:16|t"), ")");
		end

		ui_CharacterTT:AddDoubleLine(lineLeft, lineRight);
		setDoubleLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Realm
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local _, realm = UnitName(targetType);
	if showRealm() and realm then
		ui_CharacterTT:AddLine(loc("REG_TT_REALM"):format(realm), 1, 1, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Guild
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local guild, grade = GetGuildInfo(targetType);
	if showGuild() and guild then
		local text = loc("REG_TT_GUILD"):format(grade, guild);
		if info.misc and info.misc.ST then
			if info.misc.ST["6"] == 1 then -- IC guild membership
				text = text .. IC_GUILD;
			elseif info.misc.ST["6"] == 2 then -- OOC guild membership
				text = text .. OOC_GUILD;
			end
		end
		
		ui_CharacterTT:AddLine(text, 1, 1, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	--TODO
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- CURRENTLY
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCurrently() and character.CU and character.CU:len() > 0 then
		ui_CharacterTT:AddLine(loc("REG_PLAYER_CURRENT"), 1, 1, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
		
		local text = character.CU;
		if text:len() > getCurrentMaxSize() then
			text = text:sub(1, getCurrentMaxSize()) .. "...";
		end
		ui_CharacterTT:AddLine("\"" .. text .. "\"", 1, 0.75, 0, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSmallLineFontSize());
		lineIndex = lineIndex + 1;
	end
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Quick peek & new description notifications
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showNotifications() then
		local glance;
		local description;
		if info.misc and info.misc.PE and checkGlanceActivation(info.misc.PE) then
			glance = loc("REG_PLAYER_GLANCE");
		end
		if targetID ~= Globals.player_id and info.about and not info.about.read then
			description = loc("REG_TT_NOTIF");
		end
		if glance or description then
			ui_CharacterTT:AddDoubleLine(glance or " ", description or " ", 1, 1, 1, 0, 1, 0);
			setDoubleLineFont(ui_CharacterTT, lineIndex, getSmallLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Target
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showTarget() and UnitName(targetType .. "target") then
		ui_CharacterTT:AddLine(loc("REG_TT_TARGET"):format(UnitName(targetType .. "target")), 1, 1, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Client
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showClient() then
		local text = "";
		if targetID == Globals.player_id then
			text = strconcat("|cffffffff", Globals.addon_name_alt, " v", Globals.version_display);
		elseif IsUnitIDKnown(targetID) then
			if character.client then
				text = strconcat("|cffffffff", character.client, " v", character.clientVersion);
			end
		end
		if text:len() > 0 then
			ui_CharacterTT:AddDoubleLine(" ", text);
			setDoubleLineFont(ui_CharacterTT, lineIndex, getSmallLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MAIN
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function show(targetType)
	ui_CharacterTT:Hide();
	
	-- If using TRP TT
	if getConfigValue(CONFIG_CHARACT_USE) and (not UnitAffectingCombat("player") or not getConfigValue(CONFIG_CHARACT_COMBAT)) then
		local targetID = getUnitID(targetType);
		-- If we have a target
		if targetID then
			-- Stock all the current text from the GameTooltip
			local originalTexts = getGameTooltipTexts();
	
			ui_CharacterTT:SetOwner(getAnchoredFrame(), getAnchoredPosition());
	
			-- The target is a player
			if UnitIsPlayer(targetType) then
				writeTooltipForCharacter(targetID, originalTexts, targetType);
				ui_CharacterTT.target = targetID;
				ui_CharacterTT.targetType = targetType;
				ui_CharacterTT:Show();
				if shouldHideGameTooltip() then
					GameTooltip:Hide();
				end
			else
				ui_CharacterTT:Hide(); -- As SetOwner shows the tooltip, must hide if eventually nothing to show.
			end
	
			ui_CharacterTT:ClearAllPoints(); -- Prevent to break parent frame fade out if parent is a tooltip.
		end
	end
end

local function onMouseOver()
	show("mouseover");
end

local function refreshIfNeeded(targetID)
	local mouseID = getUnitID("mouseover");
	if mouseID == targetID then
		onMouseOver();
	end
end

local function onUpdate(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed; 	
	if (self.TimeSinceLastUpdate > 0.5) then
		self.TimeSinceLastUpdate = 0;
		if self.target and self.targetType and not self.isFading then
			if self.target ~= getUnitID(self.targetType) then
				self.isFading = true;
				self.target = nil;
				self:FadeOut();
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_TooltipInit()
	-- Listen to the mouse over event
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);

	ui_CharacterTT.TimeSinceLastUpdate = 0;
	ui_CharacterTT:SetScript("OnUpdate", onUpdate);
	
	Events.listenToEvents({Events.REGISTER_EXCHANGE_PROFILE_CHANGED, Events.REGISTER_EXCHANGE_RECEIVED_INFO}, refreshIfNeeded);
	
	IC_GUILD = " |cff00ff00(" .. loc("CM_IC") .. ")";
	OOC_GUILD = " |cffff0000(" .. loc("CM_OOC") .. ")";
	
	-- Config default value
	registerConfigKey(CONFIG_CHARACT_USE, true);
	registerConfigKey(CONFIG_CHARACT_COMBAT, false);
	registerConfigKey(CONFIG_CHARACT_ANCHORED_FRAME, "GameTooltip");
	registerConfigKey(CONFIG_CHARACT_ANCHOR, "ANCHOR_TOPRIGHT");
	registerConfigKey(CONFIG_CHARACT_HIDE_ORIGINAL, false);
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
	registerConfigKey(CONFIG_CHARACT_CLIENT, true);
	registerConfigKey(CONFIG_CHARACT_NOTIF, true);
	registerConfigKey(CONFIG_CHARACT_CURRENT, true);
	registerConfigKey(CONFIG_CHARACT_CURRENT_SIZE, 140);
	
	-- Build configuration page
	local CONFIG_STRUCTURE = {
		id = "main_config_tooltip",
		marginLeft = 10,
		menuText = loc("CO_TOOLTIP"),
		pageText = loc("CO_TOOLTIP"),
		elements = {
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_TOOLTIP_CHARACTER"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_USE"),
				configKey = CONFIG_CHARACT_USE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_COMBAT"),
				configKey = CONFIG_CHARACT_COMBAT,
			},
			{
				inherit = "TRP3_ConfigEditBox",
				title = loc("CO_TOOLTIP_ANCHORED"),
				configKey = CONFIG_CHARACT_ANCHORED_FRAME,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Charact_Anchor",
				title = loc("CO_TOOLTIP_ANCHOR"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_HIDE_ORIGINAL"),
				configKey = CONFIG_CHARACT_HIDE_ORIGINAL,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_TOOLTIP_MAINSIZE"),
				configKey = CONFIG_CHARACT_MAIN_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_TOOLTIP_SUBSIZE"),
				configKey = CONFIG_CHARACT_SUB_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_TOOLTIP_TERSIZE"),
				configKey = CONFIG_CHARACT_TER_SIZE,
				min = 6,
				max = 20,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_ICONS"),
				configKey = CONFIG_CHARACT_ICONS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_TITLE"),
				configKey = CONFIG_CHARACT_TITLE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_FT"),
				configKey = CONFIG_CHARACT_FT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_RACE"),
				configKey = CONFIG_CHARACT_RACECLASS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_REALM"),
				configKey = CONFIG_CHARACT_REALM,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_GUILD"),
				configKey = CONFIG_CHARACT_GUILD,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_TARGET"),
				configKey = CONFIG_CHARACT_TARGET,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_CLIENT"),
				configKey = CONFIG_CHARACT_CLIENT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_NOTIF"),
				configKey = CONFIG_CHARACT_NOTIF,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_CURRENT"),
				configKey = CONFIG_CHARACT_CURRENT,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_TOOLTIP_CURRENT_SIZE"),
				configKey = CONFIG_CHARACT_CURRENT_SIZE,
				min = 40,
				max = 300,
				step = 10,
				integer = true,
			},
		}
	}
	Config.registerConfigurationPage(CONFIG_STRUCTURE);
	
end