--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_API.profile = {};

-- imports
local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local loc = TRP3_API.locale.getText;
local unitIDToInfo = Utils.str.unitIDToInfo;
local strsplit, tinsert, pairs, type, assert, _G, table, tostring, error, wipe = strsplit, tinsert, pairs, type, assert, _G, table, tostring, error, wipe;
local displayMessage = Utils.message.displayMessage;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local getPlayerCurrentProfile;

-- Saved variables references
local profiles, character, characters;

local PATH_DELIMITER = "/";
local currentProfile = nil;
local currentProfileId = nil;
local PR_DEFAULT_PROFILE = {
	player = {},
};

-- Return the default profile.
-- Note that this profile is never directly linked to a character, only dupplicated !
TRP3_API.profile.getDefaultProfile = function()
	return PR_DEFAULT_PROFILE;
end

-- Get data from a profile in a XPATH way.
-- Example : "player/misc/PE" is equivalent to currentProfile.player.misc.PE but in a nil safe way.
-- Use currentProfile if profileRef is nil
local function getData(fieldPath, profileRef)
	assert(fieldPath, "Error: Fieldpath is nil.");
	local split = {strsplit(PATH_DELIMITER, fieldPath)};
	local pathPart = #split;
	local ref = profileRef or getPlayerCurrentProfile();
	for index, path in pairs(split) do
		if index == pathPart then -- Last
			return ref[path];
		end
		ref = ref[path];
		if type(ref) ~= "table" then
			return nil;
		end
	end
end
TRP3_API.profile.getData = getData;

-- Get data from a profile in a XPATH way.
-- Example : "player/misc/PE" is equivalent to currentProfile.player.misc.PE but in a nil safe way.
-- Use currentProfile. If value is nil, return the ifNilValue.
local function getDataDefault(fieldPath, ifNilValue, profileRef)
	return getData(fieldPath, profileRef) or ifNilValue;
end
TRP3_API.profile.getDataDefault = getDataDefault;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
-- For decoupling reasons, the saved variables TRP3_Profiles and TRP3_Characters should'nt be used outside this file !
-- You should use all the public methods instead.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Check if the profileName is not already used
local function isProfileNameAvailable(profileName)
	for profileID, profile in pairs(profiles) do
		if profile.profileName == profileName then
			return false;
		end
	end
	return true;
end

-- Duplicate an existing profile
local function dupplicateProfile(duplicatedProfile, profileName)
	assert(duplicatedProfile, "Nil profile");
	assert(isProfileNameAvailable(profileName), "Unavailable profile name: "..tostring(profileName));
	local profileID = Utils.str.id();
	profiles[profileID] = {};
	Utils.table.copy(profiles[profileID], duplicatedProfile);
	profiles[profileID].profileName = profileName;
	displayMessage(loc("PR_PROFILE_CREATED"):format(Utils.str.color("g")..profileName.."|r"));
	return profileID;
end

-- Creating a new profile using PR_DEFAULT_PROFILE as a template
local function createProfile(profileName)
	return dupplicateProfile(PR_DEFAULT_PROFILE, profileName);
end

-- Just internally switch the current profile structure. That's all.
local function selectProfile(profileID)
	if not profiles[profileID] then
		error("Unknown profile id: " + profileID);
	end
	currentProfile = profiles[profileID];
	currentProfileId = profileID;
	character.profileID = profileID;
	displayMessage(loc("PR_PROFILE_LOADED"):format(Utils.str.color("g")..profiles[character.profileID]["profileName"].."|r"));
	Events.fireEvent(Events.REGISTER_PROFILES_LOADED, currentProfile);
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, profileID);
end

-- Edit a profile name
local function editProfile(profileID, newName)
	assert(profiles[profileID], "Unknown profile: "..tostring(profileID));
	assert(isProfileNameAvailable(newName), "Unavailable profile name: "..tostring(newName));
	profiles[profileID]["profileName"] = newName;
end

-- Delete a profile
-- If the deleted profile is the currently selected one, assign the default profile
local function deleteProfile(profileID)
	assert(profiles[profileID], "Unknown profile: "..tostring(profileID));
	assert(currentProfileId ~= profileID, "You can't delete the currently selected profile !");
	local profileName = profiles[profileID]["profileName"];
	wipe(profiles[profileID]);
	profiles[profileID] = nil;
	displayMessage(loc("PR_PROFILE_DELETED"):format(Utils.str.color("g")..profileName.."|r"));
end

function TRP3_API.profile.getPlayerCurrentProfileID()
	return currentProfileId;
end

function getPlayerCurrentProfile()
	return currentProfile;
end
TRP3_API.profile.getPlayerCurrentProfile = getPlayerCurrentProfile;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateProfileList(widget, id)
	widget.profileID = id;
	local profile = profiles[id];
	local dataTab = getData("player/characteristics", profile);
	local mainText = profile.profileName;

	if id == currentProfileId then

		widget:SetBackdropBorderColor(0, 1, 0);
		_G[widget:GetName().."Current"]:Show();
		_G[widget:GetName().."Select"]:Disable();
	else
		widget:SetBackdropBorderColor(1, 1, 1);
		_G[widget:GetName().."Current"]:Hide();
		_G[widget:GetName().."Select"]:Enable();
	end

	setupIconButton(_G[widget:GetName().."Icon"], dataTab.IC or Globals.icons.profile_default);
	_G[widget:GetName().."Name"]:SetText(mainText);

	local listText = "";
	local i = 0;
	for characterID, characterInfo in pairs(characters) do
		if characterInfo.profileID == id then
			local charactName, charactRealm = unitIDToInfo(characterID);
			listText = listText.."- |cff00ff00"..charactName.." ( "..charactRealm.." )|r\n";
			i = i + 1;
		end
	end
	_G[widget:GetName().."Count"]:SetText(loc("PR_PROFILEMANAGER_COUNT"):format(i));

	local text = "";
	if i > 0 then
		text = text..loc("PR_PROFILE_DETAIL")..":\n"..listText;
	else
		text = text..loc("PR_UNUSED_PROFILE");
	end

	setTooltipForSameFrame(
	_G[widget:GetName().."Info"], "RIGHT", 0, 0,
	loc("PR_PROFILE"),
	text
	)
end

-- Refresh list display
local function uiInitProfileList()
	initList(TRP3_ProfileManagerList, profiles, TRP3_ProfileManagerListSlider);
end

local showAlertPopup, showTextInputPopup, showConfirmPopup = TRP3_API.popup.showAlertPopup, TRP3_API.popup.showTextInputPopup, TRP3_API.popup.showConfirmPopup;

local function uiCheckNameAvailability(profileName)
	if not isProfileNameAvailable(profileName) then
		showAlertPopup(loc("PR_PROFILEMANAGER_ALREADY_IN_USE"):format(Utils.str.color("g")..profileName.."|r"));
		return false;
	end
	return true;
end

local function uiCreateProfile()
	showTextInputPopup(loc("PR_PROFILEMANAGER_CREATE_POPUP"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			createProfile(newName);
			uiInitProfileList();
		end
	end,
	nil,
	Globals.player
	);
end

-- Promps profile delete confirmation
local function uiDeleteProfile(profileID)
	showConfirmPopup(loc("PR_PROFILEMANAGER_DELETE_WARNING"):format(Utils.str.color("g")..profiles[profileID].profileName.."|r"),
	function()
		deleteProfile(profileID);
		uiInitProfileList();
	end);
end

local function uiEditProfile(profileID)
	showTextInputPopup(
	loc("PR_PROFILEMANAGER_EDIT_POPUP"):format(Utils.str.color("g")..profiles[profileID].profileName.."|r"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			editProfile(profileID, newName);
			uiInitProfileList();
		end
	end,
	nil,
	profiles[profileID].profileName
	);
end

local function uiSelectProfile(profileID)
	if character.profileID == profileID then
		return;
	end
	selectProfile(profileID);
	uiInitProfileList();
end

local function uiDupplicateProfile(profileID)
	showTextInputPopup(
	loc("PR_PROFILEMANAGER_DUPP_POPUP"):format(Utils.str.color("g")..profiles[profileID].profileName.."|r"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			dupplicateProfile(profiles[profileID], newName);
			uiInitProfileList();
		end
	end,
	nil,
	profiles[profileID].profileName
	);
end

local function onProfileSelected(button)
	local profileID = button:GetParent().profileID;
	uiSelectProfile(profileID);
end

local function onActionSelected(value, button)
	local profileID = button:GetParent().profileID;

	if value == 1 then
		uiDeleteProfile(profileID);
	elseif value == 2 then
		uiEditProfile(profileID);
	elseif value == 3 then
		uiDupplicateProfile(profileID);
	end
end

local function onActionClicked(button)
	local profileID = button:GetParent().profileID;
	local values = {};
	if currentProfileId ~= profileID then
		tinsert(values, {loc("PR_DELETE_PROFILE"), 1});
	end
	tinsert(values, {loc("PR_PROFILEMANAGER_RENAME"), 2});
	tinsert(values, {loc("PR_DUPPLICATE_PROFILE"), 3});
	displayDropDown(button, values, onActionSelected, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Character
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.profile.getPlayerCharacter()
	return character;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Tutorial
local TUTORIAL_STRUCTURE = {
	{
		box = {
			allPoints = TRP3_ProfileManagerList
		},
		button = {
			x = 0, y = -110, anchor = "CENTER",
			text = loc("PR_PROFILE_HELP"),
			textWidth = 400,
			arrow = "UP"
		}
	}
}

function TRP3_API.profile.init()
	-- Saved structures
	if not TRP3_Profiles then
		TRP3_Profiles = {};
	end
	profiles = TRP3_Profiles;
	if not TRP3_Characters then
		TRP3_Characters = {};
	end
	characters = TRP3_Characters;

	if not characters[Globals.player_id] then
		characters[Globals.player_id] = {};
	end
	character = characters[Globals.player_id];

	-- First time this character is connected with TRP3 or if deleted profile through another character
	-- So we create a new profile named by his pseudo.
	if not character.profileID or not profiles[character.profileID] then
		selectProfile(createProfile(Globals.player .. " - " .. Globals.player_realm));
	else
		selectProfile(character.profileID);
	end

	-- UI
	handleMouseWheel(TRP3_ProfileManagerList, TRP3_ProfileManagerListSlider);
	TRP3_ProfileManagerListSlider:SetValue(0);
	local widgetTab = {};
	for i=1,5 do
		local widget = _G["TRP3_ProfileManagerListLine"..i];
		widget:SetScript("OnMouseUp",function (self)
			onProfileSelected(_G[self:GetName().."Select"]);
		end);
		_G[widget:GetName().."Select"]:SetScript("OnClick", onProfileSelected);
		_G[widget:GetName().."Select"]:SetText(loc("CM_SELECT"));
		_G[widget:GetName().."Action"]:SetScript("OnClick", onActionClicked);
		_G[widget:GetName().."Current"]:SetText(loc("PR_PROFILEMANAGER_CURRENT"));
		setTooltipAll(_G[widget:GetName().."Action"], "TOP", 0, 0, loc("PR_PROFILEMANAGER_ACTIONS"));
		table.insert(widgetTab, widget);

	end
	TRP3_ProfileManagerList.widgetTab = widgetTab;
	TRP3_ProfileManagerList.decorate = decorateProfileList;
	TRP3_ProfileManagerAdd:SetScript("OnClick", uiCreateProfile);

	--Localization
	TRP3_ProfileManagerTitle:SetText(Utils.str.color("w")..loc("PR_PROFILEMANAGER_TITLE"));
	TRP3_ProfileManagerAdd:SetText(loc("PR_CREATE_PROFILE"));

	registerPage({
		id = "player_profiles",
		frame = TRP3_ProfileManager,
		onPagePostShow = function() uiInitProfileList(); end,
		tutorialProvider = function() return TUTORIAL_STRUCTURE; end,
	});
end