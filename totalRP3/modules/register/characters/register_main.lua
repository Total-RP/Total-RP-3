----------------------------------------------------------------------------------
--- Total RP 3
--- Directory : main API
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local Directory = {};
AddOn_TotalRP3.Directory = Directory;

-- Public accessor
TRP3_API.register = {
	inits = {},
	player = {},
	ui = {},
	companion = {},
	NOTIFICATION_ID_NEW_CHARACTER = "add_character",
};

TRP3_API.register.MENU_LIST_ID = "main_30_register";
TRP3_API.register.MENU_LIST_ID_TAB = "main_31_";

-- imports
local Ellyb = TRP3_API.Ellyb;
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local loc = TRP3_API.loc;
local log = Utils.log.log;
local buildZoneText = Utils.str.buildZoneText;
local getUnitID = Utils.str.getUnitID;
local Config = TRP3_API.configuration;
local registerConfigKey = Config.registerConfigKey;
local getConfigValue = Config.getValue;
local Events = TRP3_API.events;
local assert, tostring, wipe, pairs, tinsert = assert, tostring, wipe, pairs, tinsert;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local showCharacteristicsTab, showAboutTab, showMiscTab, showNotesTab;
local get = TRP3_API.profile.getData;
local type = type;
local showAlertPopup = TRP3_API.popup.showAlertPopup;

-- Saved variables references
local profiles, characters;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.register.registerInfoTypes = {
	CHARACTERISTICS = "characteristics",
	ABOUT = "about",
	MISC = "misc",
	NOTES = "notes",
	CHARACTER = "character",
}

local registerInfoTypes = TRP3_API.register.registerInfoTypes;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getProfileOrNil(profileID)
	return profiles[profileID];
end
TRP3_API.register.getProfileOrNil = getProfileOrNil;

local function getProfile(profileID)
	assert(profiles[profileID], "Unknown profile ID: " .. tostring(profileID));
	return getProfileOrNil(profileID);
end
TRP3_API.register.getProfile = getProfile;

local function deleteProfile(profileID, dontFireEvents)
	assert(profiles[profileID], "Unknown profile ID: " .. tostring(profileID));
	-- Unbound characters from this profile
	if profiles[profileID].link then
		for characterID, _ in pairs(profiles[profileID].link) do
			if characters[characterID] and characters[characterID].profileID == profileID then
				characters[characterID].profileID = nil;
			end
		end
	end

	-- Deleting a profile should clear the local MSP knowledge of it,
	-- otherwise things get out of sync if the profile comes through again
	-- after deletion. For compatibility we'll still emit the table of owners.
	local mspOwners;
	if profiles[profileID].msp then
		for ownerID, _ in pairs(profiles[profileID].link) do
			msp.char[ownerID] = nil;

			-- No need to build the owner table if we ain't gonna emit it.
			if not dontFireEvents then
				mspOwners = mspOwners or {};
				tinsert(mspOwners, ownerID);
			end
		end
	end

	wipe(profiles[profileID]);
	profiles[profileID] = nil;
	if not dontFireEvents then
		Events.fireEvent(Events.REGISTER_DATA_UPDATED, nil, profileID, nil);
		Events.fireEvent(Events.REGISTER_PROFILE_DELETED, profileID, mspOwners);
	end
end

TRP3_API.register.deleteProfile = deleteProfile;

local function deleteCharacter(unitID)
	assert(characters[unitID], "Unknown unitID: " .. tostring(unitID));
	if characters[unitID].profileID and profiles[characters[unitID].profileID] and profiles[characters[unitID].profileID].link then
		profiles[characters[unitID].profileID].link[unitID] = nil;
	end
	wipe(characters[unitID]);
	characters[unitID] = nil;
end

TRP3_API.register.deleteCharacter = deleteCharacter;

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

TRP3_API.register.profileExists = profileExists;

local function createUnitIDProfile(unitID)
	assert(characters[unitID].profileID, "UnitID don't have a profileID: " .. unitID);
	assert(not profiles[characters[unitID].profileID], "Profile already exist: " .. characters[unitID].profileID);
	profiles[characters[unitID].profileID] = {};
	profiles[characters[unitID].profileID].link = {};
	return profiles[characters[unitID].profileID];
end

TRP3_API.register.createUnitIDProfile = createUnitIDProfile;

local function getUnitIDProfile(unitID)
	assert(profileExists(unitID), "No profile for character: " .. tostring(unitID));
	return profiles[characters[unitID].profileID], characters[unitID].profileID;
end

TRP3_API.register.getUnitIDProfile = getUnitIDProfile;

local function getUnitIDProfileID(unitID)
	return characters[unitID] and characters[unitID].profileID;
end
TRP3_API.register.getUnitIDProfileID = getUnitIDProfileID;

local function getUnitIDCharacter(unitID)
	assert(isUnitIDKnown(unitID), "Unknown character: " .. tostring(unitID));
	return characters[unitID];
end

TRP3_API.register.getUnitIDCharacter = getUnitIDCharacter;

function TRP3_API.register.isUnitKnown(targetType)
	return isUnitIDKnown(getUnitID(targetType));
end

---
-- Check if the content of a unit ID should be filtered because it contains mature content
-- @param unitID Unit ID of the player to test
--
local function unitIDIsFilteredForMatureContent(unitID)
	if not TRP3_API.register.mature_filter or not unitID or unitID == Globals.player_id or not isUnitIDKnown(unitID) or not profileExists(unitID) then return false end ;
	local profile = getUnitIDProfile(unitID);
	local profileID = getUnitIDProfileID(unitID);
	-- Check if the profile has been flagged as containing mature content, that the option to filter such content is enabled
	-- and that the profile is not in the pink list.
	return profile.hasMatureContent and getConfigValue("register_mature_filter") and not (TRP3_API.register.mature_filter.isProfileWhitelisted(profileID))
end

TRP3_API.register.unitIDIsFilteredForMatureContent = unitIDIsFilteredForMatureContent;

local function profileIDISFilteredForMatureContent (profileID)
	if not TRP3_API.register.mature_filter then return false end ;

	local profile = getProfileOrNil(profileID);

	return profile and profile.hasMatureContent and not TRP3_API.register.mature_filter.isProfileWhitelisted(profileID);
end

TRP3_API.register.profileIDISFilteredForMatureContent = profileIDISFilteredForMatureContent;

---
-- Check if the content of the profile of the unit ID is flagged as containing mature content
-- @param unitID Unit ID of the player to test
--
local function unitIDIsFlaggedForMatureContent(unitID)
	if not TRP3_API.register.mature_filter or not unitID or unitID == Globals.player_id or not isUnitIDKnown(unitID) or not profileExists(unitID) then return false end ;
	local profile = getUnitIDProfile(unitID);
	-- Check if the profile has been flagged as containing mature content, that the option to filter such content is enabled
	-- and that the profile is not in the pink list.
	return profile.hasMatureContent
end

TRP3_API.register.unitIDIsFlaggedForMatureContent = unitIDIsFlaggedForMatureContent;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Main data management
-- For decoupling reasons, the saved variable TRP3_Register shouln'd be used outside this file !
-- Please use all these public method instead.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- SETTERS

--- Raises error if unknown unitName
-- Link a unitID to a profileID. This link is bidirectional.
function TRP3_API.register.saveCurrentProfileID(unitID, currentProfileID, isMSP)
	local character = getUnitIDCharacter(unitID);
	local oldProfileID = character.profileID;
	character.profileID = currentProfileID;
	-- Search if this character was bounded to another profile
	for profileID, profile in pairs(profiles) do
		if profile.link and profile.link[unitID] then
			profile.link[unitID] = nil; -- unbound
			if profile.msp then
				profiles[profileID] = nil;
			end
		end
	end
	if not profileExists(unitID) then
		createUnitIDProfile(unitID);
	end
	local profile = getProfile(currentProfileID);
	profile.link[unitID] = 1; -- bound
	profile.msp = isMSP;
	profile.time = time()

	if oldProfileID ~= currentProfileID then
		Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, currentProfileID, nil);
	end
end

--- Raises error if unknown unitName
function TRP3_API.register.saveClientInformation(unitID, client, clientVersion, msp, extended, trialAccount, extendedVersion)
	local character = getUnitIDCharacter(unitID);
	character.client = client;
	character.clientVersion = clientVersion;
	character.msp = msp;
	character.extended = extended;
	character.isTrial = trialAccount;
	character.extendedVersion = extendedVersion
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

local function sanitizeFullProfile(data)
	if not data or not data.player then return false end
	local somethingWasSanitizedInsideProfile = false;
	if data.player.characteristics and TRP3_API.register.sanitizeProfile(registerInfoTypes.CHARACTERISTICS, data.player.characteristics) then
		somethingWasSanitizedInsideProfile = true;
	end
	if data.player.character and TRP3_API.register.sanitizeProfile(registerInfoTypes.CHARACTER, data.player.character) then
		somethingWasSanitizedInsideProfile = true;
	end
	if data.player.misc and TRP3_API.register.sanitizeProfile(registerInfoTypes.MISC, data.player.misc) then
		somethingWasSanitizedInsideProfile = true;
	end
	return somethingWasSanitizedInsideProfile;
end
TRP3_API.register.sanitizeFullProfile = sanitizeFullProfile;

function TRP3_API.register.sanitizeProfile(informationType, data)
	local somethingWasSanitizedInsideProfile = false;
	if informationType == registerInfoTypes.CHARACTERISTICS then
		if TRP3_API.register.ui.sanitizeCharacteristics(data) then
			somethingWasSanitizedInsideProfile = true;
		end
	elseif informationType == registerInfoTypes.CHARACTER then
		if TRP3_API.dashboard.sanitizeCharacter(data) then
			somethingWasSanitizedInsideProfile = true;
		end
	elseif informationType == registerInfoTypes.MISC then
		if TRP3_API.register.ui.sanitizeMisc(data) then
			somethingWasSanitizedInsideProfile = true;
		end
	end
	return somethingWasSanitizedInsideProfile;
end

--- Raises error if unknown unitID or unit hasn't profile ID
function TRP3_API.register.saveInformation(unitID, informationType, data)
	local profile = getUnitIDProfile(unitID);
	if profile[informationType] then
		wipe(profile[informationType]);
	end

	if getConfigValue(TRP3_API.ADVANCED_SETTINGS_KEYS.PROFILE_SANITIZATION) == true then
		TRP3_API.register.sanitizeProfile(informationType, data);
	end
	profile[informationType] = data;
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), informationType);
end

--- Raises error if KNOWN unitID
function TRP3_API.register.addCharacter(unitID)
	assert(unitID and unitID:find('-'), "Malformed unitID");
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

local function getCharacterInfoTab(unitID)
	if unitID == Globals.player_id then
		return get("player");
	elseif isUnitIDKnown(unitID) then
		return getUnitIDCurrentProfile(unitID) or {};
	end
	return {};
end
TRP3_API.register.getUnitIDCurrentProfileSafe = getCharacterInfoTab;

--- Raises error if unknown unitID
function TRP3_API.register.shouldUpdateInformation(unitID, infoType, version)
	--- Raises error if unit hasn't profile ID or no profile exists
	local profile = getUnitIDProfile(unitID);
	return not profile[infoType] or not profile[infoType].v or profile[infoType].v ~= version;
end

function TRP3_API.register.getCharacterList()
	return characters;
end

--- Fetch character specific data for the given character ID.
---@param characterID string The character ID (PlayerName-RealmName) that we want to query
---@return table|nil Either the character data or nil if the character was not found.
function Directory.getCharacterDataForCharacterId(characterID)
	return characters[characterID]
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

function TRP3_API.register.insertProfile(profileID, profileData)
	profiles[profileID] = profileData;
end

local function getUnitRPNameWithID(unitID, unitName)
	unitName = unitName or unitID;
	if unitID then
		if unitID == Globals.player_id then
			unitName = TRP3_API.register.getPlayerCompleteName(true);
		elseif isUnitIDKnown(unitID) and profileExists(unitID) then
			local profile = getUnitIDProfile(unitID);
			if profile.characteristics then
				unitName = TRP3_API.register.getCompleteName(profile.characteristics, unitName, true);
			end
		end
	end
	return unitName;
end
TRP3_API.register.getUnitRPNameWithID = getUnitRPNameWithID;

function TRP3_API.register.getUnitRPName(targetType)
	local unitName = UnitName(targetType);
	local unitID = getUnitID(targetType);
	return getUnitRPNameWithID(unitID, unitName);
end

TRP3_API.r.name = TRP3_API.register.getUnitRPName;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabGroup; -- Reference to the tab panel tabs group

local function onMouseOver()
	local unitID = getUnitID("mouseover");
	if unitID and isUnitIDKnown(unitID) then
		local _, race = UnitRace("mouseover");
		local _, class, _ = UnitClass("mouseover");
		local englishFaction = UnitFactionGroup("mouseover");
		saveCharacterInformation(unitID, race, class, UnitSex("mouseover"), englishFaction, time(), buildZoneText(), GetGuildInfo("mouseover"));
	end
end

local function onInformationUpdated(profileID, infoType)
	if getCurrentPageID() == "player_main" then
		local context = getCurrentContext();
		assert(context, "No context for page player_main !");
		if not context.isPlayer and profileID == context.profileID then
			if infoType == registerInfoTypes.ABOUT and tabGroup.current == 2 then
				showAboutTab();
			elseif (infoType == registerInfoTypes.CHARACTERISTICS or infoType == registerInfoTypes.CHARACTER) and tabGroup.current == 1 then
				showCharacteristicsTab();
			elseif infoType == registerInfoTypes.MISC and tabGroup.current == 3 then
				showMiscTab();
			elseif infoType == registerInfoTypes.NOTES and tabGroup.current == 4 then
				showNotesTab();
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI: TAB MANAGEMENT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function tutorialProvider()
	if tabGroup then
		if tabGroup.current == 2 then
			return TRP3_API.register.ui.aboutTutorialProvider();
		elseif tabGroup.current == 3 then
			return TRP3_API.register.ui.miscTutorialProvider();
		end
	end
end

local function createTabBar()
	local frame = CreateFrame("Frame", "TRP3_RegisterMainTabBar", TRP3_RegisterMain);
	frame:SetSize(485, 30);
	frame:SetPoint("TOPLEFT", 17, 0);
	frame:SetFrameLevel(1);
	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
		{
			{ loc.REG_PLAYER_CARACT, 1, 150 },
			{ loc.REG_PLAYER_ABOUT, 2, 110 },
			{ loc.REG_PLAYER_PEEK, 3, 130 },
			{ loc.REG_PLAYER_NOTES, 4, 85 }
		},
		function(_, value)
			-- Clear all
			TRP3_RegisterCharact:Hide();
			TRP3_RegisterAbout:Hide();
			TRP3_RegisterMisc:Hide();
			TRP3_RegisterNotes:Hide();
			if value == 1 then
				showCharacteristicsTab();
			elseif value == 2 then
				showAboutTab();
			elseif value == 3 then
				showMiscTab();
			elseif value == 4 then
				showNotesTab();
			end
			TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_TUTORIAL_REFRESH, "player_main");
		end,
	-- Confirmation callback
		function(callback)
			if getCurrentContext() and getCurrentContext().isEditMode then
				TRP3_API.popup.showConfirmPopup(loc.REG_PLAYER_CHANGE_CONFIRM,
					function()
						callback();
					end);
			else
				callback();
			end
		end);
	TRP3_API.register.player.tabGroup = tabGroup;
end

local function showTabs()
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
		or (infoType == registerInfoTypes.MISC and tabGroup.current == 3)
		or (infoType == registerInfoTypes.NOTES and tabGroup.current == 4);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CLEANUP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tsize = Utils.table.size;

-- Unbound character from missing profiles
local function cleanupCharacters()
	for unitID, character in pairs(characters) do
		if character.profileID and (not profiles[character.profileID] or not profiles[character.profileID].link or not profiles[character.profileID].link[unitID]) then
			character.profileID = nil;
		end
	end
	for unitID, character in pairs(characters) do
		if not character.profileID and not TRP3_API.register.isIDIgnored(unitID) then
			wipe(character)
			characters[unitID] = nil
		end
	end
end

local function cleanupCompanions()
	local companionIDToInfo = TRP3_API.utils.str.companionIDToInfo;
	local deleteCompanionProfile = TRP3_API.companions.register.deleteProfile;

	local companionProfiles = TRP3_API.companions.register.getProfiles();

	for companionProfileID, companionProfile in pairs(companionProfiles) do
		for companionFullID, _ in pairs(companionProfile.links) do
			local ownerID, _ = companionIDToInfo(companionFullID);
			if not isUnitIDKnown(ownerID) or not profileExists(ownerID) then
				companionProfile.links[companionFullID] = nil;
			end
		end
		if tsize(companionProfile.links) < 1 then
			log("Purging companion " .. companionProfileID .. ", no more characters linked to it.");
			deleteCompanionProfile(companionProfileID, true);
		end
	end
end

local function cleanupPlayerRelations()
	for _, myProfile in pairs(TRP3_API.profile.getProfiles()) do
		for profileID, _ in pairs(myProfile.relation or {}) do
			if not profiles[profileID] then
				myProfile.relation[profileID] = nil;
			end
		end
	end
end

local function cleanupProfiles()

	-- Make sure profiles are always correctly formatted
	if TRP3_Register and TRP3_Register.profiles then
		for _, profile in pairs(TRP3_Register.profiles) do
			if not profile.link then
				profile.link = {};
			end
		end
	end

	log("Purging profiles with no data")
	for profileID, profile in pairs(profiles) do
		if not profile.characteristics or Ellyb.Tables.isEmpty(profile.characteristics) then
			deleteProfile(profileID, true);
		end
	end

	log("Purging unbound MSP profiles")
	for profileID, profile in pairs(profiles) do
		if profile.msp and Ellyb.Tables.isEmpty(profile.link) then
			deleteProfile(profileID, true);
		end
	end

	if type(getConfigValue("register_auto_purge_mode")) ~= "number" then
		return ;
	end
	log(("Purging profiles older than %s day(s)"):format(getConfigValue("register_auto_purge_mode") / 86400));
	-- First, get a tab with all profileID with which we have a relation or on which we have notes
	local protectedProfileIDs = {};
	for _, profile in pairs(TRP3_API.profile.getProfiles()) do
		for profileID, _ in pairs(profile.relation or {}) do
			protectedProfileIDs[profileID] = true;
		end
		for profileID, _ in pairs(profile.notes or {}) do
			protectedProfileIDs[profileID] = true;
		end
	end
	log("Protected profiles: " .. tsize(protectedProfileIDs));
	local profilesToPurge = {};
	for profileID, profile in pairs(profiles) do
		if not protectedProfileIDs[profileID] and (not profile.time or time() - profile.time > getConfigValue("register_auto_purge_mode")) then
			tinsert(profilesToPurge, profileID);
		end
	end
	log("Profiles to purge: " .. tsize(profilesToPurge));
	for _, profileID in pairs(profilesToPurge) do
		deleteProfile(profileID, true);
	end
end

local function cleanupMyProfiles()
	local atLeastOneProfileWasSanitized = false;
	-- Get the player's profiles and sanitize them, removing all invalid codes manually inserted
	for _, profile in pairs(TRP3_API.profile.getProfiles()) do
		if sanitizeFullProfile(profile) then
			atLeastOneProfileWasSanitized = true;
		end
	end
	if atLeastOneProfileWasSanitized then
		-- Yell at the user about their mischieves
		showAlertPopup(loc.REG_CODE_INSERTION_WARNING);
	end
end

local function getFirstCharacterIDFromProfile(profile)
	if type(profile.link) == "table" then
		return next(profile.link)
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.register.init()
	showCharacteristicsTab = TRP3_API.register.ui.showCharacteristicsTab;
	showAboutTab = TRP3_API.register.ui.showAboutTab;
	showMiscTab = TRP3_API.register.ui.showMiscTab;
	showNotesTab = TRP3_API.register.ui.showNotesTab;

	-- Init save variables
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

	registerMenu({
		id = "main_10_player",
		text = loc.REG_PLAYER,
		onSelected = function() selectMenu("main_12_player_character") end,
	});

	registerMenu({
		id = "main_11_profiles",
		text = loc.PR_PROFILES,
		onSelected = function() setPage("player_profiles"); end,
		isChildOf = "main_10_player",
	});

	local currentPlayerMenu = {
		id = "main_12_player_character",
		text = get("player/characteristics/FN") or Globals.player,
		onSelected = function()
			setPage("player_main", {
				source = "player",
				profile = get("player"),
				isPlayer = true,
			});
		end,
		isChildOf = "main_10_player",
	};
	registerMenu(currentPlayerMenu);
	local refreshMenu = TRP3_API.navigation.menu.rebuildMenu;
	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, profileID, dataType)
		onInformationUpdated(profileID, dataType);
		if unitID == Globals.player_id and (not dataType or dataType == "characteristics") then
			currentPlayerMenu.text = get("player/characteristics/FN") or Globals.player;
			refreshMenu();
		end
	end);

	registerPage({
		id = "player_main",
		templateName = "TRP3_RegisterMain",
		frameName = "TRP3_RegisterMain",
		frame = TRP3_RegisterMain,
		onPagePostShow = function(context)
			showTabs(context);
		end,
		tutorialProvider = tutorialProvider
	});

	registerConfigKey("register_auto_purge_mode", 864000);

	local AUTO_PURGE_VALUES = {
		{ loc.CO_REGISTER_AUTO_PURGE_0, false },
		{ loc.CO_REGISTER_AUTO_PURGE_1:format(1), 86400 },
		{ loc.CO_REGISTER_AUTO_PURGE_1:format(2), 86400 * 2 },
		{ loc.CO_REGISTER_AUTO_PURGE_1:format(5), 86400 * 5 },
		{ loc.CO_REGISTER_AUTO_PURGE_1:format(10), 86400 * 10 },
		{ loc.CO_REGISTER_AUTO_PURGE_1:format(30), 86400 * 30 },
	}

	-- Build configuration page
	TRP3_API.register.CONFIG_STRUCTURE = {
		id = "main_config_register",
		menuText = loc.CO_REGISTER,
		pageText = loc.CO_REGISTER,
		elements = {
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationRegister_AutoPurge",
				title = loc.CO_REGISTER_AUTO_PURGE,
				help = loc.CO_REGISTER_AUTO_PURGE_TT,
				listContent = AUTO_PURGE_VALUES,
				configKey = "register_auto_purge_mode",
				listCancel = true,
			}
		}
	};
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_FINISH, function()
		cleanupPlayerRelations();
		cleanupProfiles();
		cleanupCharacters();
		cleanupCompanions();
		cleanupMyProfiles();
		Config.registerConfigurationPage(TRP3_API.register.CONFIG_STRUCTURE);
	end);

	-- Initialization
	TRP3_API.register.inits.characteristicsInit();
	TRP3_API.register.inits.aboutInit();
	TRP3_API.register.inits.glanceInit();
	TRP3_API.register.inits.miscInit();
	TRP3_API.register.inits.notesInit();

	TRP3_API.register.inits.dataExchangeInit();
	wipe(TRP3_API.register.inits);
	TRP3_API.register.inits = nil; -- Prevent init function to be called again, and free them from memory

	TRP3_ProfileReportButton:SetScript("OnClick", function()
		local context = TRP3_API.navigation.page.getCurrentContext();
		local characterID = getFirstCharacterIDFromProfile(context.profile) or UNKNOWN;
		local reportText = loc.REG_REPORT_PLAYER_OPEN_URL_160:format(characterID);
		if context.profile.time then
			local DATE_FORMAT = "%Y-%m-%d around %H:%M";
			reportText = reportText .. "\n\n" .. loc.REG_REPORT_PLAYER_TEMPLATE_DATE:format(date(DATE_FORMAT, context.profile.time));
		end
		Ellyb.Popups:OpenURL("https://battle.net/support/help/product/wow/197/1501/solution", reportText);
	end)

	Ellyb.Tooltips.getTooltip(TRP3_ProfileReportButton):SetTitle(loc.REG_REPORT_PLAYER_PROFILE)

	createTabBar();
end
