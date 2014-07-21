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
local pairs, assert, tostring, wipe = pairs, assert, tostring, wipe;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local displayMessage = Utils.message.displayMessage;

TRP3_API.navigation.menu.id.COMPANIONS_MAIN = "main_20_companions";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Player's companions
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local playerCompanions;
local DEFAULT_PROFILE = {
	data = {
		IC = "INV_Box_PetCarrier_01",
	}
};

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
	return dupplicateProfile(DEFAULT_PROFILE, profileName);
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
	
	if not TRP3_Companions.register then
		TRP3_Companions.register = {};
	end
	registerCompanions = TRP3_Companions.register;

	registerMenu({
		id = TRP3_API.navigation.menu.id.COMPANIONS_MAIN,
		text = loc("REG_COMPANIONS"),
		onSelected = function() setPage(TRP3_API.navigation.page.id.COMPANIONS_PROFILES) end,
		closeable = true,
	});

end);