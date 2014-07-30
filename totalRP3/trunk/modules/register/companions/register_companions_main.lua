--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Pets/mounts managements
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.companions = {
	player = {},
	register = {}
}

-- imports
local Globals, loc, Utils, Events = TRP3_API.globals, TRP3_API.locale.getText, TRP3_API.utils, TRP3_API.events;
local pairs, assert, tostring, wipe, tinsert, type = pairs, assert, tostring, wipe, tinsert, type;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local showAlertPopup, showTextInputPopup, showConfirmPopup = TRP3_API.popup.showAlertPopup, TRP3_API.popup.showTextInputPopup, TRP3_API.popup.showConfirmPopup;
local displayMessage, openMainFrame = Utils.message.displayMessage, TRP3_API.navigation.openMainFrame;
local companionIDToInfo = Utils.str.companionIDToInfo;
local EMPTY = Globals.empty;
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;

TRP3_API.navigation.menu.id.COMPANIONS_MAIN = "main_20_companions";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Player's companions : API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local playerCompanions;
local PROFILE_DEFAULT_ICON = "INV_Box_PetCarrier_01";
TRP3_API.companions.PROFILE_DEFAULT_ICON = PROFILE_DEFAULT_ICON;
local DEFAULT_PROFILE = {
	data = {
		IC = PROFILE_DEFAULT_ICON,
	}
};

local playerProfileAssociation = {};

local function getCompanionProfileID(companionID)
	return playerProfileAssociation[companionID];
end
TRP3_API.companions.player.getCompanionProfileID = getCompanionProfileID;

local function getCompanionProfile(companionID)
	if playerProfileAssociation[companionID] then
		return playerCompanions[playerProfileAssociation[companionID]];
	end
end
TRP3_API.companions.player.getCompanionProfile = getCompanionProfile;

local function parsePlayerProfiles(profiles)
	for profileID, profile in pairs(profiles) do
		for companionID, _ in pairs(profile.links or EMPTY) do
			playerProfileAssociation[companionID] = profileID;
		end
	end
end

local function boundPlayerCompanion(companionID, profileID, targetType)
	assert(playerCompanions[profileID], "Unknown profile: "..tostring(profileID));
	if not playerCompanions[profileID].links then
		playerCompanions[profileID].links = {};
	end
	playerCompanions[profileID].links[companionID] = targetType;
	-- Unbound from others
	for id, profile in pairs(playerCompanions) do
		if id ~= profileID then
			profile.links[companionID] = nil;
		end
	end
	playerProfileAssociation[companionID] = profileID;
	Events.fireEvent(Events.TARGET_SHOULD_REFRESH);
end
TRP3_API.companions.player.boundPlayerCompanion = boundPlayerCompanion;

local function unboundPlayerCompanion(companionID)
	local profileID = playerProfileAssociation[companionID];
	assert(profileID, "Cannot find any bound for companionID " .. tostring(companionID));
	playerProfileAssociation[companionID] = nil;
	if profileID and playerCompanions[profileID] and playerCompanions[profileID].links then
		playerCompanions[profileID].links[companionID] = nil;
	end
	Events.fireEvent(Events.TARGET_SHOULD_REFRESH);
end
TRP3_API.companions.player.unboundPlayerCompanion = unboundPlayerCompanion;

-- Check if the profileName is not already used
local function isProfileNameAvailable(profileName)
	for profileID, profile in pairs(playerCompanions) do
		if profile.profileName == profileName then
			return false;
		end
	end
	return true;
end
TRP3_API.companions.player.isProfileNameAvailable = isProfileNameAvailable;

-- Duplicate an existing profile
local function dupplicateProfile(duplicatedProfile, profileName)
	assert(duplicatedProfile, "Nil profile");
	assert(isProfileNameAvailable(profileName), "Unavailable profile name: "..tostring(profileName));
	local profileID = Utils.str.id();
	playerCompanions[profileID] = {};
	Utils.table.copy(playerCompanions[profileID], duplicatedProfile);
	playerCompanions[profileID].profileName = profileName;
	displayMessage(loc("PR_PROFILE_CREATED"):format(Utils.str.color("g")..profileName.."|r"));
	return profileID;
end
TRP3_API.companions.player.dupplicateProfile = dupplicateProfile;

-- Creating a new profile using PR_DEFAULT_PROFILE as a template
local function createProfile(profileName)
	local profileID = dupplicateProfile(DEFAULT_PROFILE, profileName);
	playerCompanions[profileID].data.NA = profileName;
	return profileID;
end
TRP3_API.companions.player.createProfile = createProfile;

-- Edit a profile name
local function editProfile(profileID, newName)
	assert(playerCompanions[profileID], "Unknown profile: "..tostring(profileID));
	assert(isProfileNameAvailable(newName), "Unavailable profile name: "..tostring(newName));
	playerCompanions[profileID]["profileName"] = newName;
end
TRP3_API.companions.player.editProfile = editProfile;

-- Delete a profile
-- If the deleted profile is the currently selected one, assign the default profile
local function deleteProfile(profileID)
	assert(playerCompanions[profileID], "Unknown profile: "..tostring(profileID));
	local profileName = playerCompanions[profileID]["profileName"];
	wipe(playerCompanions[profileID]);
	playerCompanions[profileID] = nil;
	displayMessage(loc("PR_PROFILE_DELETED"):format(Utils.str.color("g")..profileName.."|r"));
	Events.fireEvent(Events.REGISTER_PROFILE_DELETED, profileID);
end
TRP3_API.companions.player.deleteProfile = deleteProfile;

local registerCompanions;

function TRP3_API.companions.player.getProfiles()
	return playerCompanions;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Register companions (other players companions)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local registerProfileAssociation = {};

local function parseRegisterProfiles(profiles)
	for profileID, profile in pairs(profiles) do
		for fullID, _ in pairs(profile.links or EMPTY) do
			registerProfileAssociation[fullID] = profileID;
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	if not TRP3_Companions then
		TRP3_Companions = {};
	end

	if not TRP3_Companions.player then
		TRP3_Companions.player = {};
	end
	playerCompanions = TRP3_Companions.player;
	parsePlayerProfiles(playerCompanions);

	if not TRP3_Companions.register then
		TRP3_Companions.register = {};
	end
	registerCompanions = TRP3_Companions.register;
	parseRegisterProfiles(registerCompanions);

	registerMenu({
		id = TRP3_API.navigation.menu.id.COMPANIONS_MAIN,
		text = loc("REG_COMPANIONS"),
		onSelected = function() setPage(TRP3_API.navigation.page.id.COMPANIONS_PROFILES) end,
		closeable = true,
	});

end);