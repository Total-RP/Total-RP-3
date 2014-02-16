--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local globals = TRP3_GLOBALS;
local log = TRP3_Log;
local loc = TRP3_L;

-- Saved variables references
local profiles, profilesLinks;

local PATH_DELIMITER = "/";
local currentProfile = nil;
local currentProfileId = nil;
local PR_DEFAULT_PROFILE = {};
local SELECT_CALLBACKS = {};

function TRP3_GetDefaultProfile()
	return PR_DEFAULT_PROFILE;
end

function TRP3_Profile_NilSafeDataAccess(fieldPath, ifNilValue)
	return TRP3_Profile_DataGetter(fieldPath) or ifNilValue;
end

function TRP3_Profile_DataGetter(fieldPath, profileRef)
	assert(fieldPath, "Error: Fieldpath is nil.");
	local split = {strsplit(PATH_DELIMITER, fieldPath)};
	local pathPart = #split;
	local ref = profileRef or TRP3_GetProfile();
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
-- For decoupling reasons, the saved variables TRP3_Profiles and TRP3_ProfileLinks should'nt be used outside this file !
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
	local profileID = TRP3_GenerateID();
	profiles[profileID] = {};
	TRP3_DupplicateTab(profiles[profileID], duplicatedProfile);
	profiles[profileID].profileName = profileName;
	TRP3_DisplayMessage(loc("PR_PROFILE_CREATED"):format(TRP3_Color("g")..profileName.."|r"));
	return profileID;
end

-- Creating a new profile using PR_DEFAULT_PROFILE as a template
local function createProfile(profileName)
	return dupplicateProfile(PR_DEFAULT_PROFILE, profileName);
end

-- Just internally switch the current profile structure. That's all.
local function selectProfile(profileID)
	if not profiles[profileID] then
		error("Unknown profile id: "+profileID);
	end
	currentProfile = profiles[profileID];
	currentProfileId = profileID;
	profilesLinks[globals.player_id] = profileID;
	for _, callback in pairs(SELECT_CALLBACKS) do
		callback();
	end
end

function TRP3_RegisterProfileSelectionHandler(callback)
	assert(type(callback) == "function", "Callback must be a function.");
	tinsert(SELECT_CALLBACKS, callback);
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
	TRP3_DisplayMessage(loc("PR_PROFILE_DELETED"):format(TRP3_Color("g")..profileName.."|r"));
end

function TRP3_GetProfileID()
	return currentProfileId;
end

function TRP3_GetProfile()
	return currentProfile;
end

-- This method has to handle everything when the player switch to another profile
function TRP3_LoadProfile()
	TRP3_DisplayMessage(loc("PR_PROFILE_LOADED"):format(TRP3_Color("g")..profiles[profilesLinks[globals.player_id]]["profileName"].."|r"));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateProfileList(widget, id)
	widget.profileID = id;
	local profile = profiles[id];
	local dataTab = TRP3_Profile_DataGetter("player/characteristics", profile);
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

	TRP3_InitIconButton(_G[widget:GetName().."Icon"], dataTab.icon or globals.icons.profile_default);
	_G[widget:GetName().."Name"]:SetText(mainText);
	
	local listText = "";
	local i = 0;
	for character,profileID in pairs(profilesLinks) do
		if profileID == id then
			listText = listText.."- |cff00ff00"..character:sub((character:find("|"))+1).." ( "..character:sub(1,(character:find("|"))-1).." )|r\n";
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
	
	TRP3_SetTooltipForFrame(
		_G[widget:GetName().."Info"], _G[widget:GetName().."Info"], "RIGHT", 0, 0,
		loc("PR_PROFILE"),
		text
	)
end

-- Refresh list display
local function uiInitProfileList()
	TRP3_InitList(TRP3_ProfileManagerList, profiles, TRP3_ProfileManagerSlider);
end

local function uiCheckNameAvailability(profileName)
	if not isProfileNameAvailable(profileName) then
		TRP3_ShowAlertPopup(loc("PR_PROFILEMANAGER_ALREADY_IN_USE"):format(TRP3_Color("g")..profileName.."|r"));
		return false;
	end
	return true;
end

local function uiCreateProfile()
	TRP3_ShowTextInputPopup(loc("PR_PROFILEMANAGER_CREATE_POPUP"),
		function(newName)
			if newName and #newName ~= 0 then
				if not uiCheckNameAvailability(newName) then return end
				createProfile(newName);
				uiInitProfileList();
			end
		end,
		nil,
		loc("PR_NEW_PROFILE")
	);
end

-- Promps profile delete confirmation
local function uiDeleteProfile(profileID)
	TRP3_ShowConfirmPopup(loc("PR_PROFILEMANAGER_DELETE_WARNING"):format(TRP3_Color("g")..profiles[profileID].profileName.."|r"), 
	function()
		deleteProfile(profileID);
		uiInitProfileList();
	end);
end

local function uiEditProfile(profileID)
	TRP3_ShowTextInputPopup(
		loc("PR_PROFILEMANAGER_EDIT_POPUP"):format(TRP3_Color("g")..profiles[profileID].profileName.."|r"),
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
	if profilesLinks[globals.player_id] == profileID then
		return;
	end
	selectProfile(profileID);
	uiInitProfileList();
	TRP3_LoadProfile();
end

local function uiDupplicateProfile(profileID)
	TRP3_ShowTextInputPopup(
		loc("PR_PROFILEMANAGER_DUPP_POPUP"):format(TRP3_Color("g")..profiles[profileID].profileName.."|r"),
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
	TRP3_DisplayDropDown(button, values, onActionSelected, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_InitProfiles()
	-- Saved structures
	if not TRP3_Profiles then
		TRP3_Profiles = {};
	end
	profiles = TRP3_Profiles;
	if not TRP3_ProfileLinks then
		TRP3_ProfileLinks = {};
	end
	profilesLinks = TRP3_ProfileLinks;
	
	-- First time this character is connected with TRP3 or if deleted profile through another character
	-- So we create a new profile named by his pseudo.
	if not profilesLinks[globals.player_id] or not profiles[profilesLinks[globals.player_id]] then
		selectProfile(createProfile(globals.player .. " - " .. globals.player_realm));
	else
		selectProfile(profilesLinks[globals.player_id]);
	end
	
	-- UI
	TRP3_HandleMouseWheel(TRP3_ProfileManagerList, TRP3_ProfileManagerSlider);
	TRP3_ProfileManagerSlider:SetValue(0);
	local widgetTab = {};
	for i=1,5 do
		local widget = _G["TRP3_ProfileManagerLine"..i];
		_G[widget:GetName().."Select"]:SetScript("OnClick", onProfileSelected);
		_G[widget:GetName().."Action"]:SetScript("OnClick", onActionClicked);
		_G[widget:GetName().."Current"]:SetText(loc("PR_PROFILEMANAGER_CURRENT"));
		TRP3_SetTooltipAll(_G[widget:GetName().."Action"], "TOP", 0, 0, loc("PR_PROFILEMANAGER_ACTIONS"));
		table.insert(widgetTab, widget);
		
	end
	TRP3_ProfileManagerList.widgetTab = widgetTab;
	TRP3_ProfileManagerList.decorate = decorateProfileList;
	TRP3_ProfileManagerAdd:SetScript("OnClick", uiCreateProfile);
	
	--Localization
	TRP3_ProfileManagerTitle:SetText(TRP3_Color("w")..loc("PR_PROFILEMANAGER_TITLE"));
	TRP3_ProfileManagerAdd:SetText(loc("PR_CREATE_PROFILE"));
	TRP3_SetTooltipForSameFrame(TRP3_ProfileManagerHelp, "BOTTOM", 0, -15, loc("PR_PROFILE"), loc("PR_PROFILE_HELP"));
	
	TRP3_RegisterPage({
		id = "main_profile",
		templateName = "TRP3_ProfileManager",
		frameName = "TRP3_ProfileManager",
		frame = TRP3_ProfileManager,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground",
		onPagePostShow = function() uiInitProfileList(); end,
	});

	TRP3_RegisterMenu({
		id = "main_80_profile",
		text = loc("PR_PROFILEMANAGER_TITLE"),
		onSelected = function() TRP3_SetPage("main_profile"); end,
	});
end