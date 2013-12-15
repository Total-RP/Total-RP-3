--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local log = TRP3_Log;
local loc = TRP3_L;

local PATH_DELIMITER = "/";
local currentProfile = nil;
local currentProfileId = nil;
local DEFAULT_PROFILE_ID = "\1default"; -- "\1" so it's first when we sort the list
local PR_DEFAULT_PROFILE = {
};

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
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Check if the profileName is not already used
local function isProfileNameAvailable(profileName)
	for profileID, profile in pairs(TRP3_Profiles) do
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
	TRP3_Profiles[profileID] = {};
	TRP3_DupplicateTab(TRP3_Profiles[profileID], duplicatedProfile);
	TRP3_Profiles[profileID].profileName = profileName;
	TRP3_DisplayMessage(loc("PR_PROFILE_CREATED"):format(TRP3_Color("g")..profileName.."|r"));
	return profileID;
end

-- Creating a new profile using PR_DEFAULT_PROFILE as a template
local function createProfile(profileName)
	return dupplicateProfile(PR_DEFAULT_PROFILE, profileName);
end

-- Just internally switch the current profile structure. That's all.
local function selectProfile(profileID)
	if not TRP3_Profiles[profileID] then
		error("Unknown profile id: "+profileID);
	end
	currentProfile = TRP3_Profiles[profileID];
	currentProfileId = profileID;
	TRP3_ProfileLinks[TRP3_USER_ID] = profileID;
end

-- Edit a profile name
local function editProfile(profileID, newName)
	assert(TRP3_Profiles[profileID], "Unknown profile: "..tostring(profileID));
	assert(isProfileNameAvailable(newName), "Unavailable profile name: "..tostring(newName));
	TRP3_Profiles[profileID]["profileName"] = newName;
end

-- Delete a profile
-- If the deleted profile is the currently selected one, assign the default profile
local function deleteProfile(profileID)
	assert(TRP3_Profiles[profileID], "Unknown profile: "..tostring(profileID));
	assert(currentProfileId ~= profileID, "You can't delete the currently selected profile !");
	local profileName = TRP3_Profiles[profileID]["profileName"];
	wipe(TRP3_Profiles[profileID]);
	TRP3_Profiles[profileID] = nil;
	TRP3_DisplayMessage(loc("PR_PROFILE_DELETED"):format(TRP3_Color("g")..profileName.."|r"));
end

function TRP3_GetProfile()
	return currentProfile;
end

-- This method has to handle everything when the player switch to another profile
function TRP3_LoadProfile()
	TRP3_DisplayMessage(loc("PR_PROFILE_LOADED"):format(TRP3_Color("g")..TRP3_Profiles[TRP3_ProfileLinks[TRP3_USER_ID]]["profileName"].."|r"));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateProfileList(widget, id)
	widget.profileID = id;
	local profile = TRP3_Profiles[id];
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

	TRP3_InitIconButton(_G[widget:GetName().."Icon"], dataTab.icon or TRP3_ICON_PROFILE_DEFAULT);
	_G[widget:GetName().."Name"]:SetText(mainText);
	
	local listText = "";
	local i = 0;
	for character,profileID in pairs(TRP3_ProfileLinks) do
		if profileID == id then
			listText = listText.."- |cff00ff00"..character:sub((character:find("|"))+1).." ( "..character:sub(1,(character:find("|"))-1).." )|r\n";
			i = i + 1;
		end
	end
	_G[widget:GetName().."Count"]:SetText(loc("PR_PROFILEMANAGER_COUNT"):format(i));
	
	local text = "";
	if id == DEFAULT_PROFILE_ID then
		text = text..loc("PR_DEFAULT_PROFILE_HINTE").."\n\n";
	end
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
	TRP3_InitList(TRP3_ProfileManagerList, TRP3_Profiles, TRP3_ProfileManagerSlider);
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
	if DEFAULT_PROFILE_ID == profileID then
		return;
	end
	TRP3_ShowConfirmPopup(loc("PR_PROFILEMANAGER_DELETE_WARNING"):format(TRP3_Color("g")..TRP3_Profiles[profileID].profileName.."|r"), 
	function()
		deleteProfile(profileID);
		uiInitProfileList();
	end);
end

local function uiEditProfile(profileID)
	if DEFAULT_PROFILE_ID == profileID then
		return;
	end
	TRP3_ShowTextInputPopup(
		loc("PR_PROFILEMANAGER_EDIT_POPUP"):format(TRP3_Color("g")..TRP3_Profiles[profileID].profileName.."|r"),
		function(newName)
			if newName and #newName ~= 0 then
				if not uiCheckNameAvailability(newName) then return end
				editProfile(profileID, newName);
				uiInitProfileList();
			end
		end,
		nil,
		TRP3_Profiles[profileID].profileName
	);
end

local function uiSelectProfile(profileID)
	if TRP3_ProfileLinks[TRP3_USER_ID] == profileID then
		return;
	end
	selectProfile(profileID);
	uiInitProfileList();
	TRP3_LoadProfile();
end

local function uiDupplicateProfile(profileID)
	if DEFAULT_PROFILE_ID == profileID then
		return;
	end
	TRP3_ShowTextInputPopup(
		loc("PR_PROFILEMANAGER_DUPP_POPUP"):format(TRP3_Color("g")..TRP3_Profiles[profileID].profileName.."|r"),
		function(newName)
			if newName and #newName ~= 0 then
				if not uiCheckNameAvailability(newName) then return end
				dupplicateProfile(TRP3_Profiles[profileID], newName);
				uiInitProfileList();
			end
		end,
		nil,
		TRP3_Profiles[profileID].profileName
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
	if not TRP3_ProfileLinks then
		TRP3_ProfileLinks = {};
	end
	
	-- Setting the default profile
	TRP3_GetDefaultProfile().profileName = loc("PR_DEFAULT_PROFILE");
	
	-- First time this character is connected with TRP3 or if deleted profile through another character
	-- So we create a new profile named by his pseudo.
	if not TRP3_ProfileLinks[TRP3_USER_ID] or not TRP3_Profiles[TRP3_ProfileLinks[TRP3_USER_ID]] then
		selectProfile(createProfile(TRP3_PLAYER.." - "..TRP3_REALM));
	else
		selectProfile(TRP3_ProfileLinks[TRP3_USER_ID]);
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