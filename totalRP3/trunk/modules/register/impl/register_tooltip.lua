--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : RP Style section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local log = TRP3_Log;
local loc = TRP3_L;
local color = TRP3_Color;

-- ICONS
local AFK_ICON = "Spell_Nature_Sleep";
local DND_ICON = "Ability_Mage_IncantersAbsorbtion";
local ALLIANCE_ICON = "INV_BannerPVP_02";
local HORDE_ICON = "INV_BannerPVP_01";
local PVP_ICON = "Ability_DualWield";

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
	return 8; --TODO load config
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTER TOOLTIP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Returns a not nil table containing the character information.
-- The returned table is not nil, but could be empty.
local function getCharacterInfoTab(targetName, realm)
	if targetName == TRP3_PLAYER then
		return TRP3_Profile_DataGetter("player");
	else
		return TRP3_RegisterGetCurrentProfile(targetName, realm) or {};
	end
end

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
			completeName = strconcat(TRP3_Icon(info.characteristics.IC, 25), " ", completeName);
		elseif UnitFactionGroup(targetType) == "Alliance" then
			completeName = strconcat(TRP3_Icon(ALLIANCE_ICON, 25), " ", completeName);
		elseif UnitFactionGroup(targetType) == "Horde" then
			completeName = strconcat(TRP3_Icon(HORDE_ICON, 25), " ", completeName);
		end
		-- AFK / DND status
		if UnitIsAFK(targetType) then
			rightIcons = strconcat(rightIcons, TRP3_Icon(AFK_ICON, 25));
		elseif UnitIsDND(targetType) then
			rightIcons = strconcat(rightIcons, TRP3_Icon(DND_ICON, 25));
		end
		-- PVP icon
		if UnitIsPVP(targetType) then -- Icone PVP
			rightIcons = strconcat(rightIcons, TRP3_Icon(PVP_ICON, 25));
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
		lineLeft = strconcat("|cffffffff", race, " ", TRP3_ColorCodeFloat(classColor.r, classColor.g, classColor.b), class);
		
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
	-- Target
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	if showTarget() and UnitName(targetType .. "target") then
		TRP3_CharacterTooltip:AddLine(loc("REG_TT_TARGET"):format(UnitName(targetType .. "target")), 1, 1, 1);
		setLineFont(TRP3_CharacterTooltip, lineIndex, getSubLineFontSize());
		lineIndex = lineIndex + 1;
	end
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- BLOCKED
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	--TODO
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Quick peek
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	--TODO
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Notifications
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	--TODO
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Client
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	if showClient() then
		local text = "";
		if targetName == TRP3_PLAYER then
			text = strconcat("|cffffffff", TRP3_ADDON_NAME_ALT, " v", TRP3_VERSION_USER);
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

function TRP3_ShouldRefreshTooltip(targetName)
	if UnitName("mouseover") == targetName then
		onMouseOver();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_TooltipInit()
	-- Listen to the mouse over event
	TRP3_RegisterToEvent("UPDATE_MOUSEOVER_UNIT", onMouseOver);
	

	-- TODO: declare configuration UI here ?
end