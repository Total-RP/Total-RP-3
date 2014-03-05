--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Main section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_REGISTER = {};

-- functions
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local unitID = Utils.str.unitInfoToID;
local stEtN = Utils.str.emptyToNil;
local loc = TRP3_L;
local log = Utils.log.log;
local getZoneText = GetZoneText;
local getSubZoneText = GetSubZoneText;
local wipe = wipe;
local strconcat = strconcat;
local getUnitID = Utils.str.getUnitID;
local UnitRace = UnitRace;
local UnitClass = UnitClass;
local UnitFactionGroup = UnitFactionGroup;
local UnitSex = UnitSex;
local time = time;
local GetGuildInfo = GetGuildInfo;
local getDefaultProfile = TRP3_PROFILE.getDefaultProfile;

-- Saved variables references
local profiles;
local characters;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_RegisterInfoTypes = {
	CHARACTERISTICS = "characteristics",
	ABOUT = "about",
	STYLE = "style",
	MISC = "misc"
}

getDefaultProfile().player = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function isUnitIDKnown(unitID)
	assert(unitID, "Nil unitID");
	return characters[unitID] ~= nil;
end
TRP3_REGISTER.isUnitIDKnown = isUnitIDKnown;

local function hasProfile(unitID)
	assert(isUnitIDKnown(unitID), "Unknown character: " .. tostring(unitID));
	return characters[unitID].profileID;
end

local function profileExists(unitID)
	return hasProfile(unitID) and profiles[characters[unitID].profileID];
end

local function getProfile(unitID, create)
	if create then
		if hasProfile(unitID) and not profileExists(unitID) then
			profiles[characters[unitID].profileID] = {};
		end
	end
	assert(profileExists(unitID), "No profile for character: " .. tostring(unitID));
	return profiles[characters[unitID].profileID];
end

local function getCharacter(unitID)
	assert(isUnitIDKnown(unitID), "Unknown character: " .. tostring(unitID));
	return characters[unitID];
end
TRP3_REGISTER.getCharacter = getCharacter;

local function isUnitKnown(unitName)
	return isUnitIDKnown(getUnitID(unitName));
end

function TRP3_IsPlayerIgnored(unitID)
	return characters[unitID] and characters[unitID].ignored == true;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Main data management
-- For decoupling reasons, the saved variable TRP3_Register shouln'd be used outside this file !
-- Please use all these public method instead.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- SETTERS

--- Raises error if unknown unitName
function TRP3_RegisterSetCurrentProfile(unitID, currentProfileID)
	local character = getCharacter(unitID);
	local oldProfileID = character.profileID;
	character.profileID = currentProfileID;
	if oldProfileID ~= currentProfileID then
		TRP3_ShouldRefreshTooltip(unitID);
	end
	getProfile(unitID, true); -- Already create the profile if missing
end

--- Raises error if unknown unitName
function TRP3_RegisterSetClient(unitID, client, clientVersion)
	local character = getCharacter(unitID);
	character.client = client;
	character.clientVersion = clientVersion;
end

--- Raises error if unknown unitName
local function setMainInfo(unitID, race, class, gender, faction, time, zone, guild)
	local character = getCharacter(unitID);
	character.class = class;
	character.race = race;
	character.gender = gender;
	character.faction = faction;
	character.time = time;
	character.zone = zone;
	character.guild = guild;
end
TRP3_REGISTER.setMainInfo = setMainInfo;

--- Raises error if unknown unitID or unit hasn't profile ID
function TRP3_RegisterSetInforType(unitID, informationType, data)
	local profile = getProfile(unitID, true);
	if profile[informationType] then
		wipe(profile[informationType]);
	end
	profile[informationType] = data;
end

--- Raises error if KNOWN unitID
function TRP3_RegisterAddCharacter(unitID)
	assert(not isUnitIDKnown(unitID), "Already known character: " .. tostring(unitID));
	characters[unitID] = {};
	log("Added to the register: " .. unitID);
end

-- GETTERS

--- Raises error if unknown unitName
local function getCurrentProfile(unitID)
	assert(isUnitIDKnown(unitID), "Unknown character: " .. tostring(unitID));
	if hasProfile(unitID) then
		return getProfile(unitID, true);
	end
end
TRP3_REGISTER.getCurrentProfile = getCurrentProfile;

--- Raises error if unknown unitID or unit hasn't profile ID or no profile exists
function TRP3_RegisterShouldUpdateInfo(unitID, infoType, version)
	local character = getCharacter(unitID);
	local profile = getProfile(unitID);
	return not profile[infoType] or not profile[infoType].v or profile[infoType].v ~= version;
end

function TRP3_GetCharacterList()
	return characters;
end

--- Raises error if unknown unitID
function TRP3_GetCharacter(unitID)
	if unitID == Globals.player_id then
		return Globals.player_character;
	end
	assert(characters[unitID], "Unknown character ID: " .. tostring(unitID));
	return characters[unitID];
end

function TRP3_GetProfileList()
	return profiles;
end

--- Raises error if unknown unitID
local function getMiscData(unitID)
	local profile = getCurrentProfile(unitID);
	if not profile or not profile.misc then
		return {};
	end
	return profile.misc;
end
TRP3_REGISTER.getMiscData = getMiscData;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function buildZoneText()
	local text = getZoneText(); -- assuming that there is ALWAYS a zone text. Don't know if it's true.
	if getSubZoneText():len() > 0 then
		text = strconcat(text, "-", getSubZoneText());
	end
	return text;
end

local function onMouseOver(...)
	local unitID, unitRealm = getUnitID("mouseover");
	if unitID and isUnitIDKnown(unitID) then
		local _, race = UnitRace("mouseover");
		local _, class, _ = UnitClass("mouseover");
		local englishFaction = UnitFactionGroup("mouseover");
		setMainInfo(unitID, race, class, UnitSex("mouseover"), englishFaction, time(), buildZoneText(), GetGuildInfo("mouseover"));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI: TAB MANAGEMENT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabGroup;

local function createTabBar()
	local frame = CreateFrame("Frame", "TRP3_RegisterMainTabBar", TRP3_RegisterMain);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, -5);
	frame:SetFrameLevel(1);
	tabGroup = TRP3_TabBar_Create(frame,
	{
		{loc("REG_PLAYER_CARACT"), 1, 150},
		{loc("REG_PLAYER_ABOUT"), 2, 110},
		{loc("REG_PLAYER_STYLE_RPSTYLE_SHORT"), 3, 105},
		{loc("REG_PLAYER_PEEK"), 4, 130}
	},
	function(tabWidget, value)
		-- Clear all
		TRP3_RegisterCharact:Hide();
		TRP3_RegisterAbout:Hide();
		TRP3_RegisterRPStyle:Hide();
		TRP3_RegisterPeek:Hide();
		if value == 1 then
			TRP3_onCharacteristicsShown();
		elseif value == 2 then
			TRP3_onPlayerAboutShow();
		elseif value == 3 then
			TRP3_onPlayerRPStyleShow();
		elseif value == 4 then
			TRP3_onPlayerPeekShow();
		end
	end
	);
end

local function showTabs(context)
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	local isSelf = context.unitID == Globals.player_id;
	
	tabGroup:SetTabVisible(2, isSelf or hasProfile(context.unitID));
	tabGroup:SetTabVisible(3, isSelf or hasProfile(context.unitID));
	tabGroup:SetTabVisible(4, isSelf or hasProfile(context.unitID));
	tabGroup:SelectTab(1);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- API declaration
TRP3_IsUnitIDKnown = isUnitIDKnown;
TRP3_IsUnitKnown = isUnitKnown;
TRP3_GetUnitProfile = getProfile;
TRP3_HasProfile = hasProfile;

function TRP3_InitRegister()
	if not TRP3_Register then
		TRP3_Register = {};
	end
	if not TRP3_Register.character then
		TRP3_Register.character = {};
	end
	if not TRP3_Register.profiles then
		TRP3_Register.profiles = {};
	end
	profiles = TRP3_Register.profiles;
	characters = TRP3_Register.character;
	
	-- Listen to the mouse over event
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);
end

function TRP3_UI_InitRegister()
	TRP3_RegisterMenu({
		id = "main_00_player",
		text = Globals.player,
		onSelected = function() TRP3_SetPage("player_main", {unitID = Globals.player_id}); end,
	});

	TRP3_RegisterPage({
		id = "player_main",
		templateName = "TRP3_RegisterMain",
		frameName = "TRP3_RegisterMain",
		frame = TRP3_RegisterMain,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated",
		onPagePostShow = function(context)
			showTabs(context);
		end,
	});

	TRP3_Register_CharInit();
	TRP3_Register_AboutInit();
	TRP3_Register_StyleInit();
	TRP3_Register_PeekInit();
	TRP3_Register_DataExchangeInit();
	TRP3_Register_TooltipInit();
	TRP3_Register_ListInit();

	createTabBar();
end