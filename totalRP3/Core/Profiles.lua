-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- Public accessor
TRP3_API.profile = {};

-- imports
local Globals, Events, Utils = TRP3_API.globals, TRP3_Addon.Events, TRP3_API.utils;
local loc = TRP3_API.loc;
local setTooltipForSameFrame, setTooltipAll = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_API.ui.tooltip.setTooltipAll;
local registerPage = TRP3_API.navigation.page.registerPage;
local displayMessage = TRP3_API.utils.message.displayMessage;
local GetPlayerCurrentProfile;
local getConfigValue = TRP3_API.configuration.getValue;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;

-- Saved variables references
local profiles, character, characters;

local PATH_DELIMITER = "/";
local currentProfile, currentProfileId, chosenOption, chosenProfileId, chosenProfile, errorOrOldProfileID, forceClose;
local PR_DEFAULT_PROFILE = {
	player = {},
};

local PROFILEMANAGER_ACTIONS = {
	DELETE = "DELETE",
	RENAME = "RENAME",
	DUPLICATE = "DUPLICATE",
	IMPORT = "IMPORT",
	EXPORT = "EXPORT",
	CREATE = "CREATE"
}

--- TRP3_API.profile.getDefaultProfile returns the default profile.
---
--- Note that this profile is never directly linked to a character, only duplicated!
---@return table defaultProfile The default profile.
TRP3_API.profile.getDefaultProfile = function()
	return PR_DEFAULT_PROFILE;
end

--- GetData gets the data from a profile in a XPATH way.
--- Example: "player/misc/PE" is equivalent to currentProfile.player.misc.PE but in a nil safe way.
---@param fieldPath string The XPATH to get data from.
---@param profileRef table|nil Profile to retrieve data from, currentProfile if nil.
---@return table|nil profile Given data on chosen profile's path.
local function GetData(fieldPath, profileRef)
	assert(type(fieldPath) == "string" and fieldPath ~= "", "Error: Invalid fieldPath.");

	local ref = profileRef or GetPlayerCurrentProfile();
	for path in fieldPath:gmatch("[^" .. PATH_DELIMITER .. "]+") do
		if type(ref) ~= "table" then
			return nil;
		end
		ref = ref[path];
	end
	return ref;
end
TRP3_API.profile.getData = GetData;

--- GetDataDefault gets the data from a profile in a XPATH way, with a default fallback.
--- Example: "player/misc/PE" is equivalent to currentProfile.player.misc.PE but in a nil safe way.
---@param fieldPath string The XPATH to get data from.
---@param ifNilValue table The default fallback if no profile data is found.
---@param profileRef table|nil Profile to retrieve data from, currentProfile if nil.
---@return table profile Given data on chosen profile's path.
local function GetDataDefault(fieldPath, ifNilValue, profileRef)
	return GetData(fieldPath, profileRef) or ifNilValue;
end
TRP3_API.profile.getDataDefault = GetDataDefault;

local function GetProfiles()
	return profiles;
end
TRP3_API.profile.getProfiles = GetProfiles;

--- getProfileByID gets profile data by its ID.
---@param profileID string Given profile ID.
---@return table profile The retrieved profile data.
function TRP3_API.profile.getProfileByID(profileID)
	local profile = profiles[profileID];
	assert(profile, "Unknown profile ID " .. tostring(profileID));

	return profile;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
-- For decoupling reasons, the saved variables TRP3_Profiles and TRP3_Characters shouldn't be used outside this file!
-- You should use all the public methods instead.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- IsProfileNameAvailable checks if given profile name is not already in use.
---@param profileName string Given profile name to be checked.
---@return boolean available Whether the profile is available.
---@return table|nil existingProfileID ProfileID of existing profile with name.
local function IsProfileNameAvailable(profileName)
	assert(type(profileName) == "string" and profileName ~= "", "Invalid profile name.");

	for profileID, profile in pairs(profiles) do
		if profile.profileName == profileName then
			return false, profileID;
		end
	end

	return true, nil;
end
TRP3_API.profile.isProfileNameAvailable = IsProfileNameAvailable;

--- DuplicateProfile duplicates an existing profile.
---@param duplicatedProfile table Profile to duplicate.
---@param profileName string Name given to the newly duplicated profile.
---@param isDefaultProfile boolean Whether the duplicated is the default profile.
---@return string profileID ProfileID of the newly duplicated profile.
local function DuplicateProfile(duplicatedProfile, profileName, isDefaultProfile)
	assert(type(duplicatedProfile) == "table", "Invalid profile: expected table.");
	assert(type(profileName) == "string" and profileName ~= "", "Invalid profile name.");
	assert(IsProfileNameAvailable(profileName), "Unavailable profile name: " .. tostring(profileName));

	local profileID = isDefaultProfile and (string.sub(Utils.str.id(), 1, -2) .. "*") or Utils.str.id();

	local newProfile = {};
	Utils.table.copy(newProfile, duplicatedProfile);
	newProfile.profileName = profileName;
	profiles[profileID] = newProfile;

	if duplicatedProfile == PR_DEFAULT_PROFILE then
		displayMessage(loc.PR_PROFILE_CREATED:format("|cnGREEN_FONT_COLOR:" .. profileName .. "|r"));
	else
		displayMessage(loc.PR_PROFILE_DUPLICATED:format("|cnGREEN_FONT_COLOR:" .. duplicatedProfile.profileName .. "|r", "|cnGREEN_FONT_COLOR:" .. profileName .. "|r"));
	end
	return profileID;
end
TRP3_API.profile.duplicateProfile = DuplicateProfile;

--- CreateProfile creates a profile using PR_DEFAULT_PROFILE as a template.
---@param profileName string Name given to the newly created profile.
---@param isDefaultProfile boolean Whether the new profile is the default profile.
---@return string profileID ProfileID of the newly created profile.
local function CreateProfile(profileName, isDefaultProfile)
	return DuplicateProfile(PR_DEFAULT_PROFILE, profileName, isDefaultProfile);
end
TRP3_API.profile.createProfile = CreateProfile;

--- CreateProfileFromImport creates a profile from given name and given data.
---@param profileName string Name given to the newly created profile.
---@param importedData table The profile data that is to be imported.
---@return string profileID ProfileID of the newly created profile.
local function CreateProfileFromImport(profileName, importedData)
	assert(type(profileName) == "string" and profileName ~= "", "Invalid profile name.");
	assert(type(importedData) == "table", "Invalid imported data.");

	-- Prefer re-using the old imported profile ID if is free.
	local profileID = (not profiles[errorOrOldProfileID]) and errorOrOldProfileID or Utils.str.id();
	local newProfile = {};
	Utils.table.copy(newProfile, importedData);
	newProfile.profileName = profileName;
	profiles[profileID] = newProfile;

	-- If we had to generate a new profile ID, we move the profile-specific notes to said profile ID.
	if profileID ~= errorOrOldProfileID and newProfile.notes and newProfile.notes[errorOrOldProfileID] and not newProfile.notes[profileID] then
		newProfile.notes[profileID] = newProfile.notes[errorOrOldProfileID];
		newProfile.notes[errorOrOldProfileID] = nil;
	end

	-- Convert old music paths to the new ID system
	local aboutData = newProfile.player and newProfile.player.about;
	if type(aboutData) == "table" and type(aboutData.MU) == "string" then
		aboutData.MU = Utils.music.convertPathToID(aboutData.MU);
	end

	-- Convert Misc Info IDs
	local characteristics = newProfile.player and newProfile.player.characteristics;
	if type(characteristics) == "table" and type(characteristics.MI) == "table" then
		for _, miscData in ipairs(characteristics.MI) do
			if type(miscData) == "table" and (not miscData.ID or miscData.ID ~= TRP3_API.MiscInfoType.Custom) then
				-- Adding ID from name if ID missing, or setting a preset to custom if renamed
				miscData.ID = TRP3_API.GetMiscInfoTypeByName(miscData.NA);
			end
		end
	end

	displayMessage(loc.PR_PROFILE_IMPORTED:format("|cnGREEN_FONT_COLOR:" .. newProfile.profileName .. "|r"));
	return profileID;
end

--- SelectProfile internally switches the current profile to given profile.
---@param profileID string Given profile ID to select.
local function SelectProfile(profileID)
	local profile = profiles[profileID];
	assert(profile, "Unknown profile id: " .. profileID);

	currentProfile = profile;
	currentProfileId = profileID;
	character.profileID = profileID;

	displayMessage(loc.PR_PROFILE_LOADED:format(Utils.str.color("g") .. profile.profileName .."|r"));
	TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILES_LOADED, currentProfile);
	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, profileID);
end
TRP3_API.profile.selectProfile = SelectProfile;

--- RenameProfile renames a profile with given name.
---@param profileID string Given profile ID to rename.
---@param newName string New name for the profile.
local function RenameProfile(profileID, newName)
	local profile = profiles[profileID];
	assert(profile, "Unknown profile: " .. tostring(profileID));

	local isAvailable, existingProfileID = IsProfileNameAvailable(newName);
	assert(isAvailable or existingProfileID == profileID, "Unavailable profile name: " .. tostring(newName));

	displayMessage(loc.PR_PROFILE_RENAMED:format("|cnGREEN_FONT_COLOR:" .. profile.profileName .. "|r", "|cnGREEN_FONT_COLOR:" .. newName .. "|r"));
	profile.profileName = newName;
end

--- DeleteProfile deletes the chosen profile.
---
--- If chosen profile is current then switch to default profile.
---@param profileID string Given profile ID to delete.
local function DeleteProfile(profileID)
	local profile = profiles[profileID];
	assert(profile, "Unknown profile: " .. tostring(profileID));

	-- If current profile is the one to be deleted, switch to default
	if currentProfileId == profileID then
		local defaultProfileID = getConfigValue("default_profile_id");
		if defaultProfileID then
			SelectProfile(defaultProfileID);
		end
	end

	local profileName = profile.profileName;

	-- Clear profile data and remove from profiles table
	wipe(profile);
	profiles[profileID] = nil;

	displayMessage(loc.PR_PROFILE_DELETED:format(Utils.str.color("g") .. profileName .. "|r"));
end

--- getPlayerCurrentProfileID gets the player's current profile ID.
---@return string currentProfileId ProfileID of the player's current profile.
function TRP3_API.profile.getPlayerCurrentProfileID()
	return currentProfileId;
end

--- getPlayerCurrentProfile gets the player's current profile.
---@return table currentProfile Data of the player's current profile.
function GetPlayerCurrentProfile()
	return currentProfile;
end
TRP3_API.profile.getPlayerCurrentProfile = GetPlayerCurrentProfile;

--- UpdateDefaultProfile updates the default profile based on current character.
local function UpdateDefaultProfile()
	-- We replace the profile ID every login session so multiple characters don't get linked to the same profile ID
	-- The new profileID will automatically get selected during the init process
	local oldProfileID = getConfigValue("default_profile_id");
	local newProfileID = Utils.str.id();
	newProfileID = string.sub(newProfileID, 1, -2) .. "*"; -- Last character swapped with * to be identified as default by other players

	profiles[newProfileID] = profiles[oldProfileID];
	profiles[oldProfileID] = nil;
	TRP3_API.configuration.setValue("default_profile_id", newProfileID);

	local profileDefault = profiles[newProfileID];

	-- Updating profile name in case of addon locale change
	profileDefault.profileName = loc.PR_DEFAULT_PROFILE_NAME;

	local profileCharacteristics = profileDefault.player.characteristics;

	-- Update version and other character attributes
	profileCharacteristics.v = profileCharacteristics.v + 1;
	profileCharacteristics.RA = Globals.player_race_loc;
	profileCharacteristics.CL = Globals.player_class_loc;
	profileCharacteristics.FN = Globals.player;
	profileCharacteristics.IC = TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));
end

--- TRP3_API.profile.isDefaultProfile checks if given profile ID is the default profile.
---@param profileID string Given profile ID to check.
---@return boolean isDefaultProfile Whether this profile ID is the default profile.
function TRP3_API.profile.isDefaultProfile(profileID)
	if not profileID or profileID == "" then return false end
	return string.sub(profileID, -1) == "*";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local profileListID = {};

--- DecorateProfileList decorates chosen widget with given profile ID.
---@param widget button Chosen widget to decorate.
---@param id string Given profile ID to decorate with.
local function DecorateProfileList(widget, id)
	widget.profileID = id;
	local profile = profiles[id];
	if not profile then
		-- If profile does not exist, return early to avoid errors
		return;
	end

	local dataTab = GetData("player/characteristics", profile);
	local mainText = profile.profileName;

	-- Highlight current profile with a different border color
	if id == currentProfileId then
		widget:SetBorderColor(TRP3_API.CreateColor(0.1, 0.8, 0.1));
		widget.CurrentText:Show();
	else
		widget:SetBorderColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN);
		widget.CurrentText:Hide();
	end

	-- Set profile icon
	local icon = dataTab and dataTab.IC or TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));  -- Use a fallback icon if dataTab.IC is missing
	widget:SetIcon(icon);
	widget:SetNameText(mainText);

	-- Prepare character list text
	local listText = {};
	local i = 0;
	for characterID, characterInfo in pairs(characters) do
		if characterInfo.profileID == id then
			local charactName, charactRealm = TRP3_API.utils.str.unitIDToInfo(characterID);
			table.insert(listText, "- |cnGREEN_FONT_COLOR:" .. charactName .. " ( " .. charactRealm .. " )|r");
			i = i + 1;
		end
	end

	-- Handle default profile
	if id == getConfigValue("default_profile_id") then
		widget.HelpButton:Hide();
		widget:SetCountText(nil);
		widget.MenuButton:Hide();
	else
		widget.HelpButton:Show();
		widget.MenuButton:Show();
		widget:SetCountText(loc.PR_PROFILEMANAGER_COUNT:format(i));

		-- Tooltip for profile
		local text = i > 0 and (loc.PR_PROFILE_DETAIL .. ":|n" .. table.concat(listText, "|n")) or loc.PR_UNUSED_PROFILE;
		setTooltipForSameFrame(widget.HelpButton, "RIGHT", 0, 5, loc.PR_PROFILE, text);
	end
end

--- ProfileSortingByProfileName sorts profile order alphabetically by comparing two profile IDs.
---@param profileID1 string First profile ID to compare for alphabetical sorting.
---@param profileID2 string Second profile ID to compare for alphabetical sorting.
---@return boolean comesFirst Whether the first profile ID comes first alphabetically.
local function ProfileSortingByProfileName(profileID1, profileID2)
	return profiles[profileID1].profileName < profiles[profileID2].profileName;
end

--- UiInitProfileList refreshes the profile list display.
local function UiInitProfileList()
	wipe(profileListID);
	local defaultProfileID = getConfigValue("default_profile_id");
	local profileSearch = Utils.str.emptyToNil(TRP3_ProfileManager.list.SearchBox:GetText());
	local searchMode = profileSearch ~= nil;

	-- Build filtered profile list
	for profileID, _ in pairs(profiles) do
		local shouldAdd = profileID ~= defaultProfileID;

		if shouldAdd and searchMode then
			local profileName = profiles[profileID].profileName:lower();
			shouldAdd = string.find(profileName, profileSearch:lower(), 1, true);
		end

		if shouldAdd then
			tinsert(profileListID, profileID);
		end
	end

	-- Sort profiles alphabetically
	table.sort(profileListID, ProfileSortingByProfileName);

	-- Handle empty state display
	local isEmpty = #profileListID == 0;
	TRP3_ProfileManager.list.ScrollBox.EmptyText:SetShown(searchMode and isEmpty);

	-- Add default profile at top when not searching
	if not searchMode then
		tinsert(profileListID, 1, defaultProfileID);
	end

	-- Update scrollbox
	local provider = CreateDataProvider(profileListID);
	TRP3_ProfileManager.list.ScrollBox:SetDataProvider(provider, ScrollBoxConstants.RetainScrollPosition);
end

local showConfirmPopup = TRP3_API.popup.showConfirmPopup;

--- UiDeleteProfile handles the ui prommpt portion of deleting a profile.
---@param profileID string Given profile ID to delete the profile of.
local function UiDeleteProfile(profileID)
	local profile = profiles[profileID];

	showConfirmPopup(loc.PR_PROFILEMANAGER_DELETE_WARNING:format(Utils.str.color("g") .. profile.profileName .. "|r"),
	function()
		DeleteProfile(profileID);
		UiInitProfileList();
	end);
end

--- UiSelectProfile handles the ui portion of selecting a new profile by profile ID.
---@param profileID string Given profile ID of the profile to select.
local function UiSelectProfile(profileID)
	if character.profileID == profileID then
		return;
	end
	SelectProfile(profileID);
	UiInitProfileList();
end

local profileIcon;

--- SetupChoicesFrame prepares the Choices frame from the Profile Create flow.
local function SetupChoicesFrame()
	local frames = TRP3_ProfileCreateDialog.Frames;
	local choicesFrame = frames.ChoicesFrame;

	choicesFrame.Title:SetText(loc.PR_CREATE_PROFILE);
	frames:SetHeight(200);

	forceClose, profileIcon, chosenProfile = false, nil, nil;

	-- Show choices and profile creation frame
	choicesFrame:Show();
	TRP3_ProfileCreateDialog:Show();
end

--- SetupImportFrame prepares the Import frame from the Profile Create flow.
local function SetupImportFrame()
	local frames = TRP3_ProfileCreateDialog.Frames;
	local importFrame = frames.ImportFrame;

	importFrame.Title:SetText(loc.PR_IMPORT_PROFILE);
	frames:SetHeight(400);

	-- Show import and profile creation frame
	importFrame:Show();
	TRP3_ProfileCreateDialog:Show();

	-- Focus the import EditBox for easy pasting.
	importFrame.Content.ImportText:SetFocus();
end

--- SetupExportFrame prepares the Export frame from the Profile Create flow.
---@param profileID string Profile ID to be used for export.
---@param profile table Profile data to be exported from.
local function SetupExportFrame(profileID, profile)
	local frames = TRP3_ProfileCreateDialog.Frames;
	local exportFrame = frames.ExportFrame;
	local serial = TRP3_ProfileUtil.SerializeProfile(Globals.version, profileID, profile);
	local maxSerialSize = 20000;
	forceClose = true;

	-- Check if the profile data is too large
	if serial:len() >= maxSerialSize then
		Utils.message.displayMessage(loc.PR_EXPORT_TOO_LARGE:format(serial:len() / 1000), 2);
		return;
	end

	local exportWarningText = loc.PR_EXPORT_WARNING;
	local copyShortcut = TRP3_API.FormatShortcut("CTRL-C", TRP3_API.ShortcutType.System);
	local pasteShortcut = TRP3_API.FormatShortcut("CTRL-V", TRP3_API.ShortcutType.System);

	exportFrame.Content.Warning:SetText(
		exportWarningText ..
		"|n|n" .. loc.COPY_DROPDOWN_POPUP_TEXT:format(TRP3_API.Colors.Orange(copyShortcut), TRP3_API.Colors.Orange(pasteShortcut)) ..
		"|n|n|cnNORMAL_FONT_COLOR:" .. loc.PR_EXPORT_NAME:format("|cnGREEN_FONT_COLOR:" .. profile.profileName .. "|r", serial:len() / 1000) .. "|r"
	);

	exportFrame.Title:SetText(loc.PR_EXPORT_PROFILE);
	exportFrame.Content.ExportText:SetText(serial);
	frames:SetHeight(400);

	-- Show export and profile creation frame
	exportFrame:Show();
	TRP3_ProfileCreateDialog:Show();

	-- Focus the export EditBox for easy copying.
	exportFrame.Content.ExportText:SetFocus();
end

--- SetupFinalizeFrame prepares the Finalize frame from the Profile Create flow.
---@param creationOption string chosen option (blank, import, duplicate).
---@param profileName string|nil Optional profile name to use instead of default.
local function SetupFinalizeFrame(creationOption, profileName)
	local frames = TRP3_ProfileCreateDialog.Frames;
	local FinalizeFrame = frames.FinalizeFrame;
	local name = profileName or (Globals.player_realm .. " - " .. Globals.player);

	-- Set title based on creation option
	local titles = {
		[PROFILEMANAGER_ACTIONS.DUPLICATE] = loc.PR_DUPLICATE_PROFILE,
		[PROFILEMANAGER_ACTIONS.IMPORT] = loc.PR_IMPORT_PROFILE,
		[PROFILEMANAGER_ACTIONS.RENAME] = loc.PR_PROFILEMANAGER_RENAME
	}
	FinalizeFrame.Title:SetText(titles[creationOption] or loc.PR_FINALIZE_PROFILE);

	-- Handle icon visibility and name position
	local showIcon = creationOption ~= PROFILEMANAGER_ACTIONS.RENAME;
	FinalizeFrame.Icon:SetShown(showIcon);

	if showIcon then
		FinalizeFrame.Name:SetPoint("TOPLEFT", FinalizeFrame.Icon, "TOPRIGHT", 15, -4);
		-- Initialize and set up icon only when needed
		profileIcon = profileIcon or TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));
		setupIconButton(FinalizeFrame.Icon, profileIcon);
		FinalizeFrame.ConfirmButton:SetText(loc.PR_CREATE_PROFILE);
	else
		FinalizeFrame.Name:SetPoint("TOPLEFT", FinalizeFrame.Icon, "TOPLEFT", 0, -4);
		FinalizeFrame.ConfirmButton:SetText(loc.PR_PROFILEMANAGER_RENAME);
	end

	FinalizeFrame.Name:SetText(name);
	frames:SetHeight(150);

	-- Show finalize and profile creation frame
	FinalizeFrame:Show();
	TRP3_ProfileCreateDialog:Show();

	FinalizeFrame.Name:SetFocus();
end

--- OpenProfileFlow allows opening a specific profile flow frame.
---@param frameName string chosen profile flow frame (import, finalize, etc).
---@param creationOption string chosen option (blank, import, duplicate).
---@param profileName string|nil Optional profile name to use instead of default.
local function OpenProfileFlow(frameName, creationOption, profileName)
	local profileActions = {
		[PROFILEMANAGER_ACTIONS.IMPORT] = SetupImportFrame,
		[PROFILEMANAGER_ACTIONS.EXPORT] = function() SetupExportFrame(chosenProfileId, chosenProfile); end,
		[PROFILEMANAGER_ACTIONS.CREATE] = function() SetupFinalizeFrame(creationOption, profileName); end
	};

	(profileActions[frameName] or SetupChoicesFrame)();
end

--- CloseProfileFlow handles closing the profile flow depending on frame visibility.
local function CloseProfileFlow()
	local frames = TRP3_ProfileCreateDialog.Frames;
	PlaySound(TRP3_InterfaceSounds.PopupClose);

	-- Handle different visible frames
	if frames.ExportFrame:IsVisible() then
		-- Just close export and parent
		frames.ExportFrame:Hide();
		TRP3_ProfileCreateDialog:Hide();
	elseif frames.ImportFrame:IsVisible() then
		-- Clean up import frame
		frames.ImportFrame:Hide();
		frames.ImportFrame.Content.ImportText:ClearText();
	elseif frames.FinalizeFrame:IsVisible() then
		-- Clean up finalize frame
		frames.FinalizeFrame:Hide();
	end

	-- If we're on the choices frame, or on forceClose we exit out fully.
	if frames.ChoicesFrame:IsVisible() or forceClose then
		frames.ChoicesFrame:Hide();
		TRP3_ProfileCreateDialog:Hide();
		TRP3_API.popup.hidePopups();
	else
		-- Reopen choices after closing Import/Finalize
		OpenProfileFlow();
	end
end

--- PasteCopiedIcon handles receiving an icon from the right-click menu.
---@param frame Frame The frame the icon belongs to.
local function PasteCopiedIcon(frame)
	local icon = TRP3_API.GetLastCopiedIcon() or TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));
	profileIcon = icon;
	setupIconButton(frame, icon);
end

--- evaluateProfileName checks if given profile name is valid.
---
--- This prevents empty or duplicate profile names.
---@return boolean valid Whether the evaluated profile name is valid.
local function EvaluateProfileName()
	local finalizeFrame = TRP3_ProfileCreateDialog.Frames.FinalizeFrame;
	local profileName = finalizeFrame.Name:GetText();
	local confirmButton = finalizeFrame.ConfirmButton;

	confirmButton:Enable();
	if profileName == "" then
		confirmButton:Disable();
		setTooltipForSameFrame(confirmButton, "RIGHT", 0, 5, loc.PR_CREATE_PROFILE, loc.PR_EMPTYNAME_PROFILE);
		return false;
	end

	if not IsProfileNameAvailable(profileName) then
		confirmButton:Disable();
		setTooltipForSameFrame(confirmButton, "RIGHT", 0, 5, loc.PR_CREATE_PROFILE, loc.PR_DUPLICATE_PROFILE);
		return false;
	end

	setTooltipForSameFrame(confirmButton);
	return true;
end

--- ProcessProfileData readies the given profile data for creation.
---@param data table The imported data to process.
local function ProcessProfileData(data, creationOption)
	chosenProfile = data;

	-- Clean up Import
	TRP3_ProfileCreateDialog.Frames.ImportFrame:Hide();
	TRP3_ProfileCreateDialog.Frames.ImportFrame.Content.ImportText:ClearText();

	-- Build up Finalize
	profileIcon = data.player.characteristics.IC or TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));
	OpenProfileFlow(PROFILEMANAGER_ACTIONS.CREATE, creationOption, data.profileName);
end

--- EvaluateImportData checks if given import data is valid.
---@param forceImport boolean Whether data should be forcefully imported.
---@return boolean valid Whether the evaluated import data is valid.
local function EvaluateImportData(forceImport)
	local importFrame = TRP3_ProfileCreateDialog.Frames.ImportFrame;
	local importButton = importFrame.ImportButton;

	-- Set defaults: Warning icon hidden, confirm button enabled.
	importButton.WarningIcon:Hide();
	setTooltipForSameFrame(importButton.WarningIcon);
	importButton:Enable();

	-- Get import serial code
	local code = importFrame.Content.ImportText:GetInputText();
	if code == "" then
		importButton:Disable();
		setTooltipForSameFrame(importButton, "RIGHT", 0, 5, loc.PR_IMPORT, loc.PR_IMPORT_EMPTY_SERIAL);
		return false;
	end

	-- Deserialize the serial code
	local version, data;
	version, errorOrOldProfileID, data = TRP3_ProfileUtil.DeserializeProfile(string.trim(code));
	if version == nil or not data then
		importButton:Disable();
		setTooltipForSameFrame(importButton, "RIGHT", 0, 5, loc.PR_IMPORT, errorOrOldProfileID);
		return false;
	end

	local valid = true;

	-- Check version compatibility
	if version ~= Globals.version then
		-- Export came from a different TRP version!
		importButton.WarningIcon:Show();
		setTooltipAll(importButton.WarningIcon, "RIGHT", 0, 5, "Warning", loc.PR_PROFILEMANAGER_IMPORT_WARNING_3);
		valid = false;
	end

	-- Set no tooltip if all is well.
	setTooltipForSameFrame(importButton);

	-- Import valid data automatically or if manually forced (button).
	if valid or forceImport then
		ProcessProfileData(data, chosenOption);
	end

	return valid;
end

--- OnProfileSelected handles profile selection when a button is clicked.
---@param button Button The button that was selected.
local function OnProfileSelected(button)
	local profileID = button.profileID;
	UiSelectProfile(profileID);
end

--- OnActionSelected handles actions selected from the profile manager.
---@param value string The selected action from PROFILEMANAGER_ACTIONS
---@param button Button The button that triggered the action.
local function OnActionSelected(value, button)
	local parent = button:GetParent();
	local profileID = parent.profileID;
	local profile = profiles[profileID];
	forceClose = true;

	-- Save chosen data for further use.
	chosenOption, chosenProfileId, chosenProfile = value, profileID, profile;

	if value == PROFILEMANAGER_ACTIONS.DELETE then
		UiDeleteProfile(profileID);
	elseif value == PROFILEMANAGER_ACTIONS.RENAME then
		OpenProfileFlow(PROFILEMANAGER_ACTIONS.CREATE, value, profile.profileName);
	elseif value == PROFILEMANAGER_ACTIONS.DUPLICATE then
		ProcessProfileData(profile, value);
	elseif value == PROFILEMANAGER_ACTIONS.EXPORT then
		OpenProfileFlow(PROFILEMANAGER_ACTIONS.EXPORT);
	end
end

--- onActionClicked handles the action when a profile button is clicked.
---@param _ Frame The list element parent of the button.
---@param button Button The button that was clicked to trigger the menu.
local function OnActionClicked(_, button)
	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		description:CreateTitle(loc.PR_PROFILE_MANAGEMENT_TITLE);
		description:CreateButton(loc.PR_PROFILEMANAGER_RENAME, function() OnActionSelected(PROFILEMANAGER_ACTIONS.RENAME, button); end);
		description:CreateButton(loc.PR_DUPLICATE_PROFILE, function() OnActionSelected(PROFILEMANAGER_ACTIONS.DUPLICATE, button); end);
		description:CreateButton(loc.PR_EXPORT_PROFILE, function() OnActionSelected(PROFILEMANAGER_ACTIONS.EXPORT, button); end);
		description:CreateButton("|cnRED_FONT_COLOR:" .. loc.PR_DELETE_PROFILE .. "|r", function() OnActionSelected(PROFILEMANAGER_ACTIONS.DELETE, button); end);
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Character
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- getPlayerCharacter gets the current player character.
---@return table character The current player character's data.
function TRP3_API.profile.getPlayerCharacter()
	return character;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Tutorial
local TUTORIAL_STRUCTURE;

local function CreateTutorialStructure()
	TUTORIAL_STRUCTURE = {
		{
			box = {
				allPoints = TRP3_ProfileManager.list
			},
			button = {
				x = 0, y = -110, anchor = "CENTER",
				text = loc.PR_PROFILE_HELP,
				textWidth = 400,
				arrow = "UP"
			}
		}
	}
end

function TRP3_API.profile.init()
	CreateTutorialStructure();

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

	TRP3_API.configuration.registerConfigKey("default_profile_id", "");
	TRP3_API.configuration.registerConfigKey("roleplay_experience", AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.CASUAL);

	-- Creating the default profile
	if getConfigValue("default_profile_id") == "" or not profiles[getConfigValue("default_profile_id")] then
		-- Clearing a previous default profile if it existed (shouldn't happen unless you reset configuration)
		for profileID, profile in pairs(profiles) do
			if profile.profileName == loc.PR_DEFAULT_PROFILE_NAME then
				profiles[profileID] = nil;
				break;
			end
		end
		TRP3_API.configuration.setValue("default_profile_id", CreateProfile(loc.PR_DEFAULT_PROFILE_NAME, true));
	else
		UpdateDefaultProfile();
	end

	-- First time this character is connected with TRP3 or if deleted profile through another character
	-- So we select the default profile.
	if not character.profileID or not profiles[character.profileID] then
		SelectProfile(getConfigValue("default_profile_id"));
	else
		SelectProfile(character.profileID);
	end

	-- UI
	local tabGroup; -- Reference to the tab panel tabs group

	local function OnSearchTextChanged()
		local text = TRP3_ProfileManager.list:GetSearchText();

		UiInitProfileList();

		if text == "" then
			TRP3_ProfileManager.list.ScrollBox:ScrollToElementData(currentProfileId);
		else
			TRP3_ProfileManager.list.ScrollBox:ScrollToBegin();
		end
	end

	local function OnHelpButtonTooltip(_, description)
		TRP3_TooltipTemplates.CreateBasicTooltip(description, loc.PR_PROFILE_OPTIONS, loc.PR_PROFILE_OPTIONS_HELP:format(TRP3_API.Colors.Orange(TRP3_API.FormatShortcut("CTRL-C", TRP3_API.ShortcutType.System))));
	end

	local function OnMenuButtonTooltip(_, description)
		local title = loc.CM_OPTIONS;
		local text = nil;
		local instructions = {{"CLICK", loc.CM_OPTIONS_ADDITIONAL}};

		TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);
	end

	local function OnListElementTooltip(_, description)
		local button = description:GetOwner();
		local title = button.NameText:GetText();
		local text = nil;
		local instructions = {{"LCLICK", loc.PR_PROFILEMANAGER_SWITCH}, {"SHIFT-CLICK", loc.CL_TOOLTIP}};

		TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);
	end

	local function OnListElementClick(button)
		if IsShiftKeyDown() then
			TRP3_API.ChatLinks:OpenMakeImportablePrompt(loc.CL_PLAYER_PROFILE, function(canBeImported)
				TRP3_API.ProfilesChatLinkModule:InsertLink(button.profileID, canBeImported);
			end);
		else
			if currentProfileId ~= button.profileID then
				OnProfileSelected(button);
				PlaySound(TRP3_InterfaceSounds.ButtonClick);
			end
		end
	end

	local function OnListElementInitialize(button, profileID)
		button:SetMenuButtonCallback(OnActionClicked);
		button:SetMenuButtonTooltip(OnMenuButtonTooltip);
		button:SetScript("OnClick", OnListElementClick);
		button:SetTooltip(OnListElementTooltip);
		DecorateProfileList(button, profileID);
	end

	TRP3_ProfileManager.list:SetElementInitializer("TRP3_ProfileManagerListElement", OnListElementInitialize);

	-- INIT PROFILE FLOW

	-- Handle escaping during the profile flow.
	TRP3_ProfileCreateDialog:SetScript("OnKeyDown", function(_, key)
		-- Do not steal input if we're in combat.
		if InCombatLockdown() then return; end

		if key == "ESCAPE" then
			TRP3_ProfileCreateDialog:SetPropagateKeyboardInput(false);
			CloseProfileFlow();
		else
			TRP3_ProfileCreateDialog:SetPropagateKeyboardInput(true);
		end
	end);
	-- Handle clicking the close button during the profile flow.
	TRP3_ProfileCreateDialog.Frames.CloseButton:SetScript("OnClick", function()
		CloseProfileFlow();
	end);

	-- Init choices frame elements.
	local blankIcon = TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));
	TRP3_ProfileCreateDialog.Frames.ChoicesFrame.Title:SetText(loc.PR_CREATE_PROFILE);

	-- Blank profile card.
	local blankProfileChoice = TRP3_ProfileCreateDialog.Frames.ChoicesFrame.BlankProfile;
	blankProfileChoice.Icon:SetIconTexture(blankIcon);
	blankProfileChoice.Text:SetText(loc.PR_CREATE_PROFILE_CHOICE);
	setTooltipAll(blankProfileChoice, "RIGHT", 0, 5, loc.PR_CREATE_PROFILE_CHOICE, loc.PR_CREATE_PROFILE_CHOICE_TT);
	blankProfileChoice.Border:SetVertexColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN:GetRGB());

	blankProfileChoice:SetScript("OnClick", function()
		TRP3_ProfileCreateDialog.Frames.ChoicesFrame:Hide();
		chosenOption = PROFILEMANAGER_ACTIONS.CREATE;
		OpenProfileFlow(PROFILEMANAGER_ACTIONS.CREATE);
	end);

	-- Import profile card.
	local importProfileChoice = TRP3_ProfileCreateDialog.Frames.ChoicesFrame.ImportProfile;
	importProfileChoice.Text:SetText(loc.PR_IMPORT_PROFILE);
	setTooltipAll(importProfileChoice, "RIGHT", 0, 5, loc.PR_IMPORT_PROFILE, loc.PR_IMPORT_PROFILE_CHOICE_TT);
	importProfileChoice.Border:SetVertexColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN:GetRGB());

	importProfileChoice:SetScript("OnClick", function()
		TRP3_ProfileCreateDialog.Frames.ChoicesFrame:Hide();
		chosenOption = PROFILEMANAGER_ACTIONS.IMPORT;
		OpenProfileFlow(PROFILEMANAGER_ACTIONS.IMPORT);
	end);

	-- Init create profile callback for profile manager list.
	TRP3_ProfileManager.list:SetCreateCallback(OpenProfileFlow);
	setTooltipAll(TRP3_ProfileManager.list.CreateButton, "RIGHT", 0, 5, loc.PR_CREATE_PROFILE, loc.PR_CREATE_PROFILE_TT);

	-- Init import frame elements.
	local importOption = TRP3_ProfileCreateDialog.Frames.ImportFrame.Content;
	importOption.Text:SetText(loc.PR_IMPORT_PROFILE_TT:format(TRP3_API.Colors.Orange(TRP3_API.FormatShortcut("CTRL-V", TRP3_API.ShortcutType.System))));
	TRP3_ProfileCreateDialog.Frames.ImportFrame.ImportButton:SetText(loc.PR_IMPORT);

	-- Evaluate the import data whenever it is written through evaluateImport.
	importOption.ImportText:SetEscapeSanitized(true);
	importOption.ImportText:RegisterCallback("OnTextChanged", EvaluateImportData, false);
	importOption.ImportText:RegisterCallback("OnEditFocusGained", EvaluateImportData, false);

	-- Allow people to CTRL+V into the import editbox, handle it after.
	importOption.ImportText:GetEditBox():SetScript("OnKeyDown", function(_, key)
		-- Do not steal input if we're in combat.
		if InCombatLockdown() then return; end

		if key == "V" and IsControlKeyDown() then
			importOption.ImportText:SetPropagateKeyboardInput(false);

			local systemInfo = ChatTypeInfo["SYSTEM"];
			UIErrorsFrame:AddMessage(TRP3_API.loc.PASTE_SYSTEM_MESSAGE, systemInfo.r, systemInfo.g, systemInfo.b);

			EvaluateImportData(false);

			PlaySound(TRP3_InterfaceSounds.PopupClose);
		else
			importOption.ImportText:SetPropagateKeyboardInput(true);
		end
	end);

	TRP3_ProfileCreateDialog.Frames.ImportFrame.ImportButton:SetScript("OnClick", function()
		-- canImport == true will evaluate and import the data after.
		EvaluateImportData(true);
	end);

	-- Init finalize frame elements.
	local finalizeOption = TRP3_ProfileCreateDialog.Frames.FinalizeFrame;
	finalizeOption.Name.title:SetText(loc.CM_NAME);
	finalizeOption.ConfirmButton:SetText(loc.PR_CREATE_PROFILE);

	-- Evaluate the profile name on text change to prevent empty or duplicates.
	finalizeOption.Name:SetScript("OnTextChanged", EvaluateProfileName);
	finalizeOption.Name:SetScript("OnEditFocusGained", EvaluateProfileName);

	-- Setup the profile icon button.
	setTooltipAll(finalizeOption.Icon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
	profileIcon = TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));

	setupIconButton(finalizeOption.Icon, profileIcon);
	finalizeOption.Icon:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {function(icon)
				profileIcon = icon;
				setupIconButton(finalizeOption.Icon, icon or TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player")));
			end, nil, nil, profileIcon});
		elseif button == "RightButton" then
			profileIcon = profileIcon or TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));
			TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
				description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, profileIcon);
				description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({profileIcon}); end);
				description:CreateButton(loc.UI_ICON_PASTE, function() PasteCopiedIcon(finalizeOption.Icon); end);
			end);
		end
	end);

	-- Handle profile creation, either through import or blank.
	finalizeOption.ConfirmButton:SetScript("OnClick", function()
		local profileID = chosenProfileId;
		local name = finalizeOption.Name:GetText();

		-- Handle different profile actions
		if chosenOption == PROFILEMANAGER_ACTIONS.RENAME then
			RenameProfile(profileID, name);
		else
			if chosenOption == PROFILEMANAGER_ACTIONS.DUPLICATE then
				profileID = DuplicateProfile(chosenProfile, name);
			elseif chosenOption == PROFILEMANAGER_ACTIONS.IMPORT then
				profileID = CreateProfileFromImport(name, chosenProfile);
			else -- Blank profile creation
				profileID = CreateProfile(name);
			end
		end

		-- Honor the changed profile icon.
		if profileID and profiles[profileID] and chosenOption ~= PROFILEMANAGER_ACTIONS.RENAME then
			profiles[profileID].player.characteristics.IC = profileIcon;
		end

		-- Cleanup and refresh UI
		finalizeOption:Hide();
		TRP3_ProfileCreateDialog:Hide();
		UiInitProfileList();
	end);

	-- Init export frame.
	local exportFrame = TRP3_ProfileCreateDialog.Frames.ExportFrame.Content;
	exportFrame.ExportText:SetReadOnly(true)
	exportFrame.ExportText:SetHighlightOnFocus(true);
	exportFrame.ExportText:SetEscapeSanitized(true);

	exportFrame.ExportText:GetEditBox():SetScript("OnKeyDown", function(_, key)
		if key == "C" and IsControlKeyDown() then
			local systemInfo = ChatTypeInfo["SYSTEM"];
			UIErrorsFrame:AddMessage(TRP3_API.loc.COPY_SYSTEM_MESSAGE, systemInfo.r, systemInfo.g, systemInfo.b);
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

			-- Close on next frame, otherwise copy operation will fail.
			RunNextFrame(CloseProfileFlow);
		end
	end);

	TRP3_ProfileManager.list:SetHelpCallback(OnHelpButtonTooltip);
	TRP3_ProfileManager.list:SetSearchCallback(TRP3_FunctionUtil.Debounce(0.25, OnSearchTextChanged));

	registerPage({
		id = "player_profiles",
		frame = TRP3_ProfileManager,
		onPagePostShow = function()
			tabGroup:SelectTab(1);
			if TRP3_API.importer.charactersProfilesAvailable() then
				tabGroup:SetTabVisible(2, true);
			else
				tabGroup:SetTabVisible(2, false);
			end
		end,
		tutorialProvider = function() return TUTORIAL_STRUCTURE; end,
	});

	TRP3_ProfileManager.list.onTab = function()
		UiInitProfileList();
		TRP3_ProfileManager.list.ScrollBox:ScrollToElementData(currentProfileId);
	end

	local frame = CreateFrame("Frame", "TRP3_ProfileManagerTabBar", TRP3_ProfileManager);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, 0);
	frame:SetFrameLevel(1);

	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
		{
			{loc.PR_PROFILEMANAGER_TITLE, "list", 175},
			{loc.PR_IMPORT_CHAR_TAB, "characterImporter", 175},
		},
		function(_, value)
			for _, child in pairs({TRP3_ProfileManager:GetChildren()}) do
				if frame ~= child then
					child:Hide();
				end
			end
			if value and TRP3_ProfileManager[value] then
				TRP3_ProfileManager[value]:Show();
				if TRP3_ProfileManager[value].onTab then
					TRP3_ProfileManager[value].onTab();
				end
			end
		end
	);
	tabGroup:SelectTab(1);

	local getCurrentPageID = TRP3_API.navigation.page.getCurrentPageID;

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_PROFILES_LOADED, function()
		if getCurrentPageID() == "player_profiles" then
			if tabGroup.current == 1 then
				UiInitProfileList();  -- Force refresh
			end
		end
	end);

	TRP3_API.slash.registerCommand({
		id = "profile",
		helpLine = " " .. loc.PR_SLASH_SWITCH_HELP,
		handler = function(...)
			local args = {...};

			if #args < 1 then
				displayMessage(loc.PR_SLASH_EXAMPLE);
				return
			end

			local profileName = table.concat(args, " ");

			if string.sub(profileName, 1, 1) == "[" then
				profileName = TRP3_AutomationUtil.ParseMacroOption(profileName);
			end

			for profileID, profile in pairs(profiles) do
				if profile.profileName == profileName then
					SelectProfile(profileID);
					return;
				end
			end

			displayMessage(loc.PR_SLASH_NOT_FOUND:format(profileName));
		end
	});
end
