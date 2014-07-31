--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : RP Style section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local colorCode = Utils.color.colorCode;
local loc = TRP3_API.locale.getText;
local getUnitIDCurrentProfile, isIDIgnored = TRP3_API.register.getUnitIDCurrentProfile, TRP3_API.register.isIDIgnored;
local getIgnoreReason = TRP3_API.register.getIgnoreReason;
local ui_CharacterTT = TRP3_CharacterTooltip;
local getCharacterUnitID = Utils.str.getUnitID;
local get = TRP3_API.profile.getData;
local Config = TRP3_API.configuration;
local getConfigValue = TRP3_API.configuration.getValue;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local strconcat = strconcat;
local getCompleteName = TRP3_API.register.getCompleteName;
local getOtherCharacter = TRP3_API.register.getUnitIDCharacter;
local getYourCharacter = TRP3_API.profile.getPlayerCharacter;
local IsUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local UnitAffectingCombat = UnitAffectingCombat;
local Events = TRP3_API.events;
local GameTooltip, _G, pairs = GameTooltip, _G, pairs;
local UnitName, UnitPVPName, UnitFactionGroup, UnitIsAFK, UnitIsDND = UnitName, UnitPVPName, UnitFactionGroup, UnitIsAFK, UnitIsDND;
local UnitIsPVP, UnitRace, UnitLevel, GetGuildInfo, UnitIsPlayer, UnitClass = UnitIsPVP, UnitRace, UnitLevel, GetGuildInfo, UnitIsPlayer, UnitClass;
local hasProfile, getRelationColors = TRP3_API.register.hasProfile, TRP3_API.register.relation.getRelationColors;
local checkGlanceActivation = TRP3_API.register.checkGlanceActivation;
local IC_GUILD, OOC_GUILD;
local originalGetTargetType, getCompanionFullID, getCompanionProfile = TRP3_API.ui.misc.getTargetType, TRP3_API.ui.misc.getCompanionFullID;
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
local EMPTY = Globals.empty;
local unitIDToInfo = Utils.str.unitIDToInfo;

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
local CONFIG_CHARACT_NOTIF = "tooltip_char_notif";
local CONFIG_CHARACT_CURRENT = "tooltip_char_current";
local CONFIG_CHARACT_CURRENT_SIZE = "tooltip_char_current_size";
local CONFIG_CHARACT_RELATION = "tooltip_char_relation";

local ANCHOR_TAB;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config getters
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getAnchoredFrame()
	return _G[getConfigValue(CONFIG_CHARACT_ANCHORED_FRAME)] or GameTooltip or error("Can't find any frame to anchor.");
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

local localeFont;

local function getGameTooltipTexts()
	local tab = {};
	for j = 1, GameTooltip:NumLines() do
		tab[j] = _G["GameTooltipTextLeft" ..  j]:GetText();
	end
	return tab;
end

local function setLineFont(tooltip, lineIndex, fontSize)
	_G[strconcat(tooltip:GetName(), "TextLeft", lineIndex)]:SetFont(localeFont, fontSize);
end

local function setDoubleLineFont(tooltip, lineIndex, fontSize)
	setLineFont(tooltip, lineIndex, fontSize);
	_G[strconcat(tooltip:GetName(), "TextRight", lineIndex)]:SetFont(localeFont, fontSize);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTER TOOLTIP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

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
	local lineIndex = 1;
	local info = getCharacterInfoTab(targetID);
	local character = getCharacter(targetID);
	local targetName = UnitName(targetType);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if isIDIgnored(targetID) then
		ui_CharacterTT:AddLine(loc("REG_TT_IGNORED"), 1, 0, 0);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
		ui_CharacterTT:AddLine("\"" .. getIgnoreReason(targetID) .. "\"", 1, 0.75, 0, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSmallLineFontSize());
		lineIndex = lineIndex + 1;
		return;
	end
	
	

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- icon, complete name, RP/AFK/PVP/Volunteer status
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local localizedClass, englishClass = UnitClass(targetType);
	local classColor = RAID_CLASS_COLORS[englishClass];
	local rightIcons = "";
	local leftIcons = "";
	local characterColorCode = colorCode(classColor.r * 255, classColor.g * 255, classColor.b * 255);
	if info.characteristics and info.characteristics.CH then
		characterColorCode = "|cff" .. info.characteristics.CH;
	end
	local completeName = characterColorCode .. getCompleteName(info.characteristics or {}, targetName, not showTitle());

	if showIcons() then
		-- Player icon
		if info.characteristics and info.characteristics.IC then
			leftIcons = strconcat(Utils.str.icon(info.characteristics.IC, 25), leftIcons, " ");
		end
		-- OOC
		if character.RP ~= 1 then
			rightIcons = strconcat(rightIcons, OOC_ICON);
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
		if character.XP == 1 then
			rightIcons = strconcat(rightIcons, BEGINNER_ICON);
		elseif character.XP == 3 then
			rightIcons = strconcat(rightIcons, VOLUNTEER_ICON);
		end
	end

	ui_CharacterTT:AddDoubleLine(leftIcons .. completeName, rightIcons);
	setDoubleLineFont(ui_CharacterTT, lineIndex, getMainLineFontSize());
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
	-- race, class, level and faction
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
		lineLeft = strconcat("|cffffffff", race, " ", characterColorCode, class);
		lineRight = strconcat("|cffffffff", loc("REG_TT_LEVEL"):format(getLevelIconOrText(targetType), getFactionIcon(targetType)));

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
	-- Target
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showTarget() and UnitName(targetType .. "target") then
		ui_CharacterTT:AddLine(loc("REG_TT_TARGET"):format(UnitName(targetType .. "target")), 1, 1, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
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
			clientText = strconcat("|cffffffff", Globals.addon_name_alt, " v", Globals.version_display);
		elseif IsUnitIDKnown(targetID) then
			if character.client then
				clientText = strconcat("|cffffffff", character.client, " v", character.clientVersion);
			end
		end
		if notifText:len() > 0 or clientText:len() > 0 then
			if notifText:len() == 0 then
				notifText = " "; -- Prevent bad right line height
			end
			ui_CharacterTT:AddDoubleLine(notifText, clientText, 1, 1, 1, 0, 1, 0);
			setDoubleLineFont(ui_CharacterTT, lineIndex, getSmallLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPANION TOOLTIP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local UnitBattlePetType, UnitBattlePetLevel = UnitBattlePetType, UnitBattlePetLevel;
local companionIDToInfo = Utils.str.companionIDToInfo;
local getCompanionProfile;

local function showCompanionIcons()
	return true; -- TODO config
end

local function showCompanionFullTitle()
	return true; -- TODO config
end

local function showCompanionOwner()
	return true; -- TODO config
end

local function showCompanionNotifications()
	return true; -- TODO config
end

local function showCompanionWoWInfo()
	return true; -- TODO config
end

local function getCompanionInfo(owner, name)
	local profile;
	if owner == Globals.player_id then
		profile = getCompanionProfile(name) or EMPTY;
	else
		profile = EMPTY;
	end
	return profile.data or EMPTY;
end

local function writeCompanionTooltip(companionFullID, originalTexts, targetType, targetMode)
	local lineIndex = 1;
	local ownerID, companionID = companionIDToInfo(companionFullID);
	local info = getCompanionInfo(ownerID, companionID);
	local targetName = UnitName(targetType);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Icon and name
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local leftIcons = "";

	if showCompanionIcons() then
		-- Player icon
		if info.IC then
			leftIcons = strconcat(Utils.str.icon(info.IC, 25), leftIcons, " ");
		end
	end

	ui_CharacterTT:AddLine(leftIcons .. "|cff" .. (info.NH or "ffffff") .. (info.NA or companionID));
	setLineFont(ui_CharacterTT, lineIndex, getMainLineFontSize());
	lineIndex = lineIndex + 1;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- full title
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionFullTitle() then
		local fullTitle = "";
		if info.TI then
			fullTitle = strconcat("< ", info.TI, " >");
		end
		if fullTitle:len() > 0 then
			ui_CharacterTT:AddLine(fullTitle, 1, 0.50, 0);
			setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Owner
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionOwner() then
		local ownerName, ownerRealm = unitIDToInfo(ownerID);
		local ownerFinalName, ownerColor = ownerName, "";
		if ownerID == Globals.player_id or (IsUnitIDKnown(ownerID) and hasProfile(ownerID)) then
			local ownerInfo = getCharacterInfoTab(ownerID);
			if ownerInfo.characteristics then
				if ownerInfo.characteristics.FN then
					ownerFinalName = ownerInfo.characteristics.FN;
				end
				if ownerInfo.characteristics.CH then
					ownerColor = "|cff" .. ownerInfo.characteristics.CH;
				end
			end
		else
			if ownerRealm ~= Globals.player_realm_id then
				ownerFinalName = ownerID;
			end
		end

		ownerFinalName = ownerColor .. ownerFinalName .. "|r";
		if targetMode == TYPE_PET then
			ownerFinalName = UNITNAME_TITLE_PET:format(ownerFinalName);
		elseif targetMode == TYPE_BATTLE_PET then
			ownerFinalName = UNITNAME_TITLE_COMPANION:format(ownerFinalName);
		end

		ui_CharacterTT:AddLine(ownerFinalName, 1, 1, 1);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Wow info
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionWoWInfo() then
		local text;
		if targetMode == TYPE_PET then
			local creatureType = UnitCreatureType(targetType);
			text = TOOLTIP_WILDBATTLEPET_LEVEL_CLASS:format(UnitLevel(targetType) or "??", creatureType);
		elseif targetMode == TYPE_BATTLE_PET then
			local type = UnitBattlePetType(targetType);
			local type = _G["BATTLE_PET_DAMAGE_NAME_" .. type];
			text = TOOLTIP_WILDBATTLEPET_LEVEL_CLASS:format(UnitBattlePetLevel(targetType) or "??", type);
		end
		ui_CharacterTT:AddLine(text, 1, 1, 1, 0, 1, 0);
		setLineFont(ui_CharacterTT, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Quick peek & new description notifications
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCompanionNotifications() then
		local notifText = "";
		if info.PE and checkGlanceActivation(info.PE) then
			notifText = GLANCE_ICON;
		end
		if ownerID ~= Globals.player_id and info.read == false then
			notifText = notifText .. " " .. NEW_ABOUT_ICON;
		end
		if notifText:len() > 0 then
			ui_CharacterTT:AddLine(notifText, 1, 1, 1, 0, 1, 0);
			setLineFont(ui_CharacterTT, lineIndex, getSmallLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MAIN
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getUnitID(targetType)
	local currentTargetType, isCurrentMine = originalGetTargetType(targetType);
	if currentTargetType == TYPE_CHARACTER then
		return getCharacterUnitID(targetType), currentTargetType;
	elseif currentTargetType == TYPE_BATTLE_PET or currentTargetType == TYPE_PET then
		return getCompanionFullID(targetType, currentTargetType), currentTargetType;
	end
end

local function show(targetType)
	ui_CharacterTT:Hide();

	-- If using TRP TT
	if getConfigValue(CONFIG_CHARACT_USE) and (not UnitAffectingCombat("player") or not getConfigValue(CONFIG_CHARACT_COMBAT)) then
		local targetID, targetMode = getUnitID(targetType);
		-- If we have a target
		if targetID then
			-- Stock all the current text from the GameTooltip
			local originalTexts = getGameTooltipTexts();

			ui_CharacterTT:SetOwner(getAnchoredFrame(), getAnchoredPosition());

			-- The target is a player
			if targetMode then
				ui_CharacterTT.target = targetID;
				ui_CharacterTT.targetType = targetType;
				ui_CharacterTT.targetMode = targetMode;

				ui_CharacterTT:SetBackdropBorderColor(1, 1, 1);
				if targetMode == TYPE_CHARACTER then
					writeTooltipForCharacter(targetID, originalTexts, targetType);
					if showRelationColor() and targetID ~= Globals.player_id and IsUnitIDKnown(targetID) and hasProfile(targetID) then
						ui_CharacterTT:SetBackdropBorderColor(getRelationColors(hasProfile(targetID)));
					end
					if shouldHideGameTooltip() and not isIDIgnored(targetID) then
						GameTooltip:Hide();
					end
				elseif targetMode == TYPE_BATTLE_PET or targetMode == TYPE_PET then
					writeCompanionTooltip(targetID, originalTexts, targetType, targetMode);
					if shouldHideGameTooltip() then
						GameTooltip:Hide();
					end
				end

				ui_CharacterTT:Show();
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

local function refreshIfNeeded(unitID)
	local mouseID = getUnitID("mouseover");
	if mouseID == unitID then
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

function TRP3_API.register.inits.tooltipInit()
	localeFont = TRP3_API.locale.getLocaleFont();
	getCompanionProfile = TRP3_API.companions.player.getCompanionProfile;

	-- Listen to the mouse over event
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);

	ui_CharacterTT.TimeSinceLastUpdate = 0;
	ui_CharacterTT:SetScript("OnUpdate", onUpdate);

	Events.listenToEvent(Events.REGISTER_DATA_CHANGED, refreshIfNeeded);

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
	registerConfigKey(CONFIG_CHARACT_NOTIF, true);
	registerConfigKey(CONFIG_CHARACT_CURRENT, true);
	registerConfigKey(CONFIG_CHARACT_CURRENT_SIZE, 140);
	registerConfigKey(CONFIG_CHARACT_RELATION, true);

	ANCHOR_TAB = {
		{loc("CO_ANCHOR_TOP_LEFT"), "ANCHOR_TOPLEFT"},
		{loc("CO_ANCHOR_TOP"), "ANCHOR_TOP"},
		{loc("CO_ANCHOR_TOP_RIGHT"), "ANCHOR_TOPRIGHT"},
		{loc("CO_ANCHOR_RIGHT"), "ANCHOR_RIGHT"},
		{loc("CO_ANCHOR_BOTTOM_RIGHT"), "ANCHOR_BOTTOMRIGHT"},
		{loc("CO_ANCHOR_BOTTOM"), "ANCHOR_BOTTOM"},
		{loc("CO_ANCHOR_BOTTOM_LEFT"), "ANCHOR_BOTTOMLEFT"},
		{loc("CO_ANCHOR_LEFT"), "ANCHOR_LEFT"}
	};

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
				listContent = ANCHOR_TAB,
				configKey = CONFIG_CHARACT_ANCHOR,
				listWidth = nil,
				listCancel = true,
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
				title = loc("CO_TOOLTIP_CURRENT"),
				configKey = CONFIG_CHARACT_CURRENT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_NOTIF"),
				configKey = CONFIG_CHARACT_NOTIF,
				help = loc("CO_TOOLTIP_NOTIF_TT"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLTIP_RELATION"),
				help = loc("CO_TOOLTIP_RELATION_TT"),
				configKey = CONFIG_CHARACT_RELATION,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_TOOLTIP_CURRENT_SIZE"),
				configKey = CONFIG_CHARACT_CURRENT_SIZE,
				min = 40,
				max = 200,
				step = 10,
				integer = true,
			},
		}
	}
	Config.registerConfigurationPage(CONFIG_STRUCTURE);
end