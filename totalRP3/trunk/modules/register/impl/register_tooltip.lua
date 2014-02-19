--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : RP Style section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local getUnitID = Utils.str.unitInfoToID;
local colorCodeFloat = Utils.color.colorCodeFloat;
local loc = TRP3_L;

-- ICONS
local AFK_ICON = "Spell_Nature_Sleep";
local DND_ICON = "Ability_Mage_IncantersAbsorbtion";
local ALLIANCE_ICON = "INV_BannerPVP_02";
local HORDE_ICON = "INV_BannerPVP_01";
local PVP_ICON = "Ability_DualWield";
local PEEK_ICON_SIZE = 20;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config getters
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getAnchoredFrame()
	return _G["GameTooltip"] or GameTooltip; --TODO load config
end

local function getAnchoredPosition()
	return "ANCHOR_TOPRIGHT"; --TODO load config
end

local function shouldHideGameTooltip()
	return false; --TODO load config
end

local function getMainLineFontSize()
	return 16; --TODO load config
end

local function getSubLineFontSize()
	return 12; --TODO load config
end

local function getSmallLineFontSize()
	return 10; --TODO load config
end

local function showIcons()
	return true; --TODO load config
end

local function showFullTitle()
	return true; --TODO load config
end

local function showRaceClass()
	return true; --TODO load config
end

local function showRealm()
	return true; --TODO load config
end

local function showGuild()
	return true; --TODO load config
end

local function showTarget()
	return true; --TODO load config
end

local function showTitle()
	return true; --TODO load config
end

local function showClient()
	return true; --TODO load config
end

local function showNotifications()
	return true; --TODO load config
end

local function showCurrently()
	return true; --TODO load config
end

local function getCurrentMaxSize()
	return 140;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTIL METHOD
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getGameTooltipTexts()
	local tab = {};
	for j = 1, GameTooltip:NumLines() do
		tab[j] = _G["GameTooltipTextLeft" ..  j]:GetText();
	end
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
local function getCharacterInfoTab(targetName, realm)
	if targetName == Globals.player then
		return TRP3_Profile_DataGetter("player");
	elseif TRP3_IsUnitIDKnown(getUnitID(targetName, realm)) then
		return TRP3_RegisterGetCurrentProfile(targetName, realm) or {};
	end
	return {};
end

--- The complete character's tooltip writing sequence.
local function writeTooltipForCharacter(targetName, realm, originalTexts, targetType)
	local lineIndex = 1;
	local info = getCharacterInfoTab(targetName, realm);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- icon, complete name, RP/AFK/PVP/Volunteer status
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local localizedClass, englishClass = UnitClass(targetType);
	local classColor = RAID_CLASS_COLORS[englishClass];
	local completeName = TRP3_GetCompleteName(info.characteristics or {}, targetName, not showTitle());
	local rightIcons = "";

	-- TODO: color blocker param

	if showIcons() then
		-- Player icon
		if info.characteristics and info.characteristics.IC then
			completeName = strconcat(Utils.str.icon(info.characteristics.IC, 25), " ", completeName);
		elseif UnitFactionGroup(targetType) == "Alliance" then
			completeName = strconcat(Utils.str.icon(ALLIANCE_ICON, 25), " ", completeName);
		elseif UnitFactionGroup(targetType) == "Horde" then
			completeName = strconcat(Utils.str.icon(HORDE_ICON, 25), " ", completeName);
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
		-- TODO: Beginner icon + volunteer icon
	end

	TRP3_CharacterTooltip:AddDoubleLine(completeName, rightIcons);
	setDoubleLineFont(TRP3_CharacterTooltip, lineIndex, getMainLineFontSize());
	_G[strconcat(TRP3_CharacterTooltip:GetName(), "TextLeft", lineIndex)]:SetTextColor(classColor.r, classColor.g, classColor.b);
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
			TRP3_CharacterTooltip:AddLine(fullTitle, 1, 0.50, 0);
			setLineFont(TRP3_CharacterTooltip, lineIndex, getSubLineFontSize());
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

		TRP3_CharacterTooltip:AddDoubleLine(lineLeft, lineRight);
		setDoubleLineFont(TRP3_CharacterTooltip, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Realm
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local _, realm = UnitName(targetType);
	if showRealm() and realm then
		TRP3_CharacterTooltip:AddLine(loc("REG_TT_REALM"):format(realm), 1, 1, 1);
		setLineFont(TRP3_CharacterTooltip, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Guild
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local guild, grade = GetGuildInfo(targetType);
	if showGuild() and guild then
		TRP3_CharacterTooltip:AddLine(loc("REG_TT_GUILD"):format(grade, guild), 1, 1, 1);
		setLineFont(TRP3_CharacterTooltip, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	--TODO
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- CURRENTLY
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showCurrently() and info.misc and info.misc.CU then
		if info.misc.CO then
			TRP3_CharacterTooltip:AddLine(loc("REG_PLAYER_CURRENTOOC"), 1, 1, 1);
		else
			TRP3_CharacterTooltip:AddLine(loc("REG_PLAYER_CURRENT"), 1, 1, 1);
		end
		setLineFont(TRP3_CharacterTooltip, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
		
		local text = info.misc.CU;
		if text:len() > getCurrentMaxSize() then
			text = text:sub(1, getCurrentMaxSize()) .. "...";
		end
		TRP3_CharacterTooltip:AddLine("\"" .. text .. "\"", 1, 0.75, 0, 1);
		setLineFont(TRP3_CharacterTooltip, lineIndex, getSmallLineFontSize());
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
		if targetName ~= Globals.player and info.about and not info.about.read then
			description = loc("REG_TT_NOTIF");
		end
		if glance or description then
			TRP3_CharacterTooltip:AddDoubleLine(glance or " ", description or " ", 1, 1, 1, 0, 1, 0);
			setDoubleLineFont(TRP3_CharacterTooltip, lineIndex, getSmallLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Target
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showTarget() and UnitName(targetType .. "target") then
		TRP3_CharacterTooltip:AddLine(loc("REG_TT_TARGET"):format(UnitName(targetType .. "target")), 1, 1, 1);
		setLineFont(TRP3_CharacterTooltip, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Client
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if showClient() then
		local text = "";
		if targetName == Globals.player then
			text = strconcat("|cffffffff", Globals.addon_name_alt, " v", Globals.version_display);
		else
		-- TODO: check character client
		end
		if text:len() > 0 then
			TRP3_CharacterTooltip:AddDoubleLine(" ", text);
			setDoubleLineFont(TRP3_CharacterTooltip, lineIndex, getSmallLineFontSize());
			lineIndex = lineIndex + 1;
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MAIN
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function show(targetType)
	TRP3_CharacterTooltip:Hide();

	local targetName, realm = UnitName(targetType);

	-- If we have a target
	if targetName then
		-- Stock all the current text from the GameTooltip
		local originalTexts = getGameTooltipTexts();

		TRP3_CharacterTooltip:SetOwner(getAnchoredFrame(), getAnchoredPosition());

		-- The target is a player
		if UnitIsPlayer(targetType) then
			writeTooltipForCharacter(targetName, realm, originalTexts, targetType);
			TRP3_CharacterTooltip.target = targetName;
			TRP3_CharacterTooltip.targetType = targetType;
			TRP3_CharacterTooltip:Show();
			if shouldHideGameTooltip() then
				GameTooltip:Hide();
			end
		else
			TRP3_CharacterTooltip:Hide(); -- As SetOwner shows the tooltip, must hide if eventually nothing to show.
		end

		TRP3_CharacterTooltip:ClearAllPoints(); -- Prevent to break parent frame fade out if parent is a tooltip.
	end
end

local function onMouseOver()
	show("mouseover");
end

function TRP3_ShouldRefreshTooltip(targetID)
	local mouseID = Utils.str.getFullName("mouseover");
	if mouseID == targetID then
		onMouseOver();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_TooltipInit()
	-- Listen to the mouse over event
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);


-- TODO: declare configuration UI here ?
end