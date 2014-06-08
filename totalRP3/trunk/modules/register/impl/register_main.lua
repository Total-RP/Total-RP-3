--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Main section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_API.register = {
	inits = {},
	player = {},
	ui = {},
};

-- imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local unitID = Utils.str.unitInfoToID;
local stEtN = Utils.str.emptyToNil;
local loc = TRP3_API.locale.getText;
local log = Utils.log.log;
local getZoneText = GetZoneText;
local getSubZoneText = GetSubZoneText;
local getUnitID = Utils.str.getUnitID;
local UnitRace = UnitRace;
local UnitClass = UnitClass;
local UnitFactionGroup = UnitFactionGroup;
local UnitSex = UnitSex;
local GetGuildInfo = GetGuildInfo;
local getDefaultProfile, get = TRP3_API.profile.getDefaultProfile, TRP3_API.profile.getData;
local getPlayerCharacter = TRP3_API.profile.getPlayerCharacter;
local Config = TRP3_API.configuration;
local registerConfigKey = Config.registerConfigKey;
local Events = TRP3_API.events;
local assert, tostring, time, wipe, strconcat, pairs = assert, tostring, time, wipe, strconcat, pairs;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local showCharacteristicsTab, showAboutTab, showMiscTab;

-- Saved variables references
local profiles;
local characters;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.register.registerInfoTypes = {
	CHARACTERISTICS = "characteristics",
	ABOUT = "about",
	MISC = "misc",
	CHARACTER = "character",
}

local registerInfoTypes = TRP3_API.register.registerInfoTypes;
getDefaultProfile().player = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getProfile(profileID)
	assert(profiles[profileID], "Unknown profile ID: " .. tostring(profileID));
	return profiles[profileID];
end
TRP3_API.register.getProfile = getProfile;

local function isUnitIDKnown(unitID)
	assert(unitID, "Nil unitID");
	return characters[unitID] ~= nil;
end
TRP3_API.register.isUnitIDKnown = isUnitIDKnown;

local function hasProfile(unitID)
	assert(isUnitIDKnown(unitID), "Unknown character: " .. tostring(unitID));
	return characters[unitID].profileID;
end
TRP3_API.register.hasProfile = hasProfile;

local function profileExists(unitID)
	return hasProfile(unitID) and profiles[characters[unitID].profileID];
end

local function createUnitIDProfile(unitID)
	assert(characters[unitID].profileID, "UnitID don't have a profileID: " .. unitID);
	assert(not profiles[characters[unitID].profileID], "Profile already exist: " .. characters[unitID].profileID);
	profiles[characters[unitID].profileID] = {};
	profiles[characters[unitID].profileID].link = {};
	return profiles[characters[unitID].profileID];
end

local function getUnitIDProfile(unitID)
	assert(profileExists(unitID), "No profile for character: " .. tostring(unitID));
	return profiles[characters[unitID].profileID];
end
TRP3_API.register.getUnitIDProfile = getUnitIDProfile;

local function getUnitIDCharacter(unitID)
	assert(isUnitIDKnown(unitID), "Unknown character: " .. tostring(unitID));
	return characters[unitID];
end
TRP3_API.register.getUnitIDCharacter = getUnitIDCharacter;

function TRP3_API.register.isUnitKnown(targetType)
	return isUnitIDKnown(getUnitID(targetType));
end

function TRP3_API.register.isUnitIDIgnored(unitID)
	-- TODO: to change, as it's the profile which is ignored, not the character ?
	return characters[unitID] and characters[unitID].ignored == true;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Main data management
-- For decoupling reasons, the saved variable TRP3_Register shouln'd be used outside this file !
-- Please use all these public method instead.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- SETTERS

--- Raises error if unknown unitName
-- Link a unitID to a profileID. This link is bidirectional.
function TRP3_API.register.saveCurrentProfileID(unitID, currentProfileID)
	local character = getUnitIDCharacter(unitID);
	local oldProfileID = character.profileID;
	character.profileID = currentProfileID;
	-- Search if this character was bounded to another profile
	for profileID, profile in pairs(profiles) do
		if profile.link and profile.link[unitID] then
			profile.link[unitID] = nil; -- unbound
		end
	end
	if not profileExists(unitID) then
		createUnitIDProfile(unitID);
	end
	local profile = getProfile(currentProfileID);
	profile.link[unitID] = 1; -- bound
	
	if oldProfileID ~= currentProfileID then
		Events.fireEvent(Events.REGISTER_EXCHANGE_PROFILE_CHANGED, unitID, currentProfileID);
	end
end

--- Raises error if unknown unitName
function TRP3_API.register.saveClientInformation(unitID, client, clientVersion, msp)
	local character = getUnitIDCharacter(unitID);
	character.client = client;
	character.clientVersion = clientVersion;
	character.msp = msp;
end

--- Raises error if unknown unitName
local function saveCharacterInformation(unitID, race, class, gender, faction, time, zone, guild)
	local character = getUnitIDCharacter(unitID);
	character.class = class;
	character.race = race;
	character.gender = gender;
	character.faction = faction;
	character.guild = guild;
	if hasProfile(unitID) then
		local profile = getProfile(character.profileID);
		profile.time = time;
		profile.zone = zone;
	end
end
TRP3_API.register.saveCharacterInformation = saveCharacterInformation;

--- Raises error if unknown unitID or unit hasn't profile ID
function TRP3_API.register.saveInformation(unitID, informationType, data)
	if informationType == registerInfoTypes.CHARACTER then
		local character = getUnitIDCharacter(unitID);
		character.v = data.v or 1;
		character.CU = data.CU;
		character.RP = data.RP;
		character.XP = data.XP;
	else
		local profile = getUnitIDProfile(unitID);
		if profile[informationType] then
			wipe(profile[informationType]);
		end
		profile[informationType] = data;
	end
	Events.fireEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, unitID, informationType);
end

--- Raises error if KNOWN unitID
function TRP3_API.register.addCharacter(unitID)
	assert(not isUnitIDKnown(unitID), "Already known character: " .. tostring(unitID));
	characters[unitID] = {};
	log("Added to the register: " .. unitID);
end

-- GETTERS

--- Raises error if unknown unitName
local function getUnitIDCurrentProfile(unitID)
	assert(isUnitIDKnown(unitID), "Unknown character: " .. tostring(unitID));
	if hasProfile(unitID) then
		return getUnitIDProfile(unitID);
	end
end
TRP3_API.register.getUnitIDCurrentProfile = getUnitIDCurrentProfile;

--- Raises error if unknown unitID
function TRP3_API.register.shouldUpdateInformation(unitID, infoType, version)
	if infoType == registerInfoTypes.CHARACTER then
		local character = getUnitIDCharacter(unitID);
		return not character.v or character.v ~= version;
	else
		--- Raises error if unit hasn't profile ID or no profile exists
		local profile = getUnitIDProfile(unitID);
		return not profile[infoType] or not profile[infoType].v or profile[infoType].v ~= version;
	end
end

function TRP3_API.register.getCharacterList()
	return characters;
end

--- Raises error if unknown unitID
function TRP3_API.register.getUnitIDCharacter(unitID)
	if unitID == Globals.player_id then
		return Globals.player_character;
	end
	assert(characters[unitID], "Unknown character ID: " .. tostring(unitID));
	return characters[unitID];
end

function TRP3_API.register.getProfileList()
	return profiles;
end

TRP3_API.register.getCharacterExchangeData = function()
	return getPlayerCharacter();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabGroup; -- Reference to the tab panel tabs group

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
		saveCharacterInformation(unitID, race, class, UnitSex("mouseover"), englishFaction, time(), buildZoneText(), GetGuildInfo("mouseover"));
	end
end

local function onReceivedInfo(unitID, infoType)
	if getCurrentPageID() == "player_main" then
		local context = getCurrentContext();
		assert(context, "No context for page player_main !");
		if unitID == context.unitID then
			if infoType == registerInfoTypes.ABOUT and tabGroup.current == 2 then
				showAboutTab();
			elseif  infoType == registerInfoTypes.CHARACTERISTICS and tabGroup.current == 1 then
				showCharacteristicsTab();
			elseif  infoType == registerInfoTypes.MISC and tabGroup.current == 3 then
				showMiscTab();
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI: TAB MANAGEMENT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function createTabBar()
	local frame = CreateFrame("Frame", "TRP3_RegisterMainTabBar", TRP3_RegisterMain);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, -5);
	frame:SetFrameLevel(1);
	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
	{
		{loc("REG_PLAYER_CARACT"), 1, 150},
		{loc("REG_PLAYER_ABOUT"), 2, 110},
		{loc("REG_PLAYER_PEEK"), 3, 130}
	},
	function(tabWidget, value)
		-- Clear all
		TRP3_RegisterCharact:Hide();
		TRP3_RegisterAbout:Hide();
		TRP3_RegisterMisc:Hide();
		if value == 1 then
			showCharacteristicsTab();
		elseif value == 2 then
			showAboutTab();
		elseif value == 3 then
			showMiscTab();
		end
	end
	);
end

local function showTabs(context)
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	tabGroup:SelectTab(1);
end

function TRP3_API.register.ui.getSelectedTabIndex()
	return tabGroup.current;
end

function TRP3_API.register.ui.isTabSelected(infoType)
	return (infoType == registerInfoTypes.CHARACTERISTICS and tabGroup.current == 1)
		or (infoType == registerInfoTypes.ABOUT and tabGroup.current == 2)
		or (infoType == registerInfoTypes.MISC and tabGroup.current == 3);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.register.init()
	showCharacteristicsTab = TRP3_API.register.ui.showCharacteristicsTab;
	showAboutTab = TRP3_API.register.ui.showAboutTab;
	showMiscTab = TRP3_API.register.ui.showMiscTab;

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
	
	Events.listenToEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, onReceivedInfo);

	local refreshMenu = TRP3_API.navigation.menu.rebuildMenu;
	local playerMenu = {
		id = "main_10_player",
		text = get("player/characteristics/FN") or Globals.player,
		onSelected = function() selectMenu("main_12_player_character") end,
	}
	registerMenu(playerMenu);
	Events.listenToEvents({Events.REGISTER_CHARACTERISTICS_SAVED, Events.REGISTER_PROFILES_LOADED}, function()
		playerMenu.text = get("player/characteristics/FN") or Globals.player;
		refreshMenu();
	end);

	registerMenu({
		id = "main_11_profiles",
		text = loc("PR_PROFILEMANAGER_TITLE"),
		onSelected = function() setPage("player_profiles"); end,
		isChildOf = "main_10_player",
	});

	registerMenu({
		id = "main_12_player_character",
		text = loc("REG_PLAYER"),
		onSelected = function()
			setPage("player_main", {
				unitID = Globals.player_id,
				profile = get("player"),
				isPlayer = true,
			});
		end,
		isChildOf = "main_10_player",
	});

	registerPage({
		id = "player_main",
		templateName = "TRP3_RegisterMain",
		frameName = "TRP3_RegisterMain",
		frame = TRP3_RegisterMain,
		onPagePostShow = function(context)
			showTabs(context);
		end,
	});

	registerConfigKey("register_about_use_vote", true);

	-- Build configuration page
	local CONFIG_STRUCTURE = {
		id = "main_config_register",
		marginLeft = 10,
		menuText = loc("CO_REGISTER"),
		pageText = loc("CO_REGISTER"),
		elements = {
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_REGISTER_ABOUT_VOTE"),
				configKey = "register_about_use_vote",
			},
		}
	};
	Config.registerConfigurationPage(CONFIG_STRUCTURE);

	-- Initialization
	TRP3_API.register.inits.characteristicsInit();
	TRP3_API.register.inits.aboutInit();
	TRP3_API.register.inits.miscInit();
	TRP3_API.register.inits.dataExchangeInit();
	TRP3_API.register.inits.tooltipInit();
	TRP3_API.register.inits.directoryInit();
	TRP3_API.register.inits.companionInit();
	wipe(TRP3_API.register.inits);
	TRP3_API.register.inits = nil; -- Prevent init function to be called again, and free them from memory

	createTabBar();
end