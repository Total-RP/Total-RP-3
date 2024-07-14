-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- Public accessor
TRP3_API.profile = {};

-- imports
local Globals, Events, Utils = TRP3_API.globals, TRP3_Addon.Events, TRP3_API.utils;
local loc = TRP3_API.loc;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local registerPage = TRP3_API.navigation.page.registerPage;
local displayMessage = TRP3_API.utils.message.displayMessage;
local getPlayerCurrentProfile;
local getConfigValue = TRP3_API.configuration.getValue;

-- Saved variables references
local profiles, character, characters;

local PATH_DELIMITER = "/";
local currentProfile, currentProfileId;
local PR_DEFAULT_PROFILE = {
	player = {},
};

local PROFILEMANAGER_ACTIONS = {
	DELETE = "DELETE",
	RENAME = "RENAME",
	DUPLICATE = "DUPLICATE",
	IMPORT = "IMPORT",
	EXPORT = "EXPORT"
}

-- Return the default profile.
-- Note that this profile is never directly linked to a character, only duplicated !
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

local function getProfiles()
	return profiles;
end
TRP3_API.profile.getProfiles = getProfiles;

function TRP3_API.profile.getProfileByID(profileID)
	assert(profiles[profileID], "Unknown profile ID " .. tostring(profileID));
	return profiles[profileID];
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
-- For decoupling reasons, the saved variables TRP3_Profiles and TRP3_Characters should'nt be used outside this file !
-- You should use all the public methods instead.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Check if the profileName is not already used
local function isProfileNameAvailable(profileName)
	for profileID, profile in pairs(profiles) do
		if profile.profileName == profileName then
			return false, profileID;
		end
	end
	return true;
end
TRP3_API.profile.isProfileNameAvailable = isProfileNameAvailable;

-- Duplicate an existing profile
local function duplicateProfile(duplicatedProfile, profileName, isDefaultProfile)
	assert(duplicatedProfile, "Nil profile");
	assert(isProfileNameAvailable(profileName), "Unavailable profile name: "..tostring(profileName));
	local profileID = Utils.str.id();
	if isDefaultProfile then
		profileID = string.sub(profileID, 1, -2) .. "*";
	end
	profiles[profileID] = {};
	Utils.table.copy(profiles[profileID], duplicatedProfile);
	profiles[profileID].profileName = profileName;
	displayMessage(loc.PR_PROFILE_CREATED:format(Utils.str.color("g")..profileName.."|r"));
	return profileID;
end
TRP3_API.profile.duplicateProfile = duplicateProfile;

-- Creating a new profile using PR_DEFAULT_PROFILE as a template
local function createProfile(profileName, isDefaultProfile)
	return duplicateProfile(PR_DEFAULT_PROFILE, profileName, isDefaultProfile);
end
TRP3_API.profile.createProfile = createProfile;

-- Just internally switch the current profile structure. That's all.
local function selectProfile(profileID)
	if not profiles[profileID] then
		error("Unknown profile id: " + profileID);
	end
	currentProfile = profiles[profileID];
	currentProfileId = profileID;
	character.profileID = profileID;
	displayMessage(loc.PR_PROFILE_LOADED:format(Utils.str.color("g")..profiles[character.profileID]["profileName"].."|r"));
	TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILES_LOADED, currentProfile);
	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, profileID);
end
TRP3_API.profile.selectProfile = selectProfile;

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
	displayMessage(loc.PR_PROFILE_DELETED:format(Utils.str.color("g")..profileName.."|r"));
end

function TRP3_API.profile.getPlayerCurrentProfileID()
	return currentProfileId;
end

function getPlayerCurrentProfile()
	return currentProfile;
end
TRP3_API.profile.getPlayerCurrentProfile = getPlayerCurrentProfile;

local function updateDefaultProfile()
	local profileDefault = profiles[getConfigValue("default_profile_id")];
	-- Updating profile name in case of addon locale change
	profileDefault.profileName = loc.PR_DEFAULT_PROFILE_NAME;

	local profileCharacteristics = profileDefault.player.characteristics;
	profileCharacteristics.v = profileCharacteristics.v + 1;
	profileCharacteristics.RA = Globals.player_race_loc;
	profileCharacteristics.CL = Globals.player_class_loc;
	profileCharacteristics.FN = Globals.player;
	profileCharacteristics.IC = TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player"));
end

function TRP3_API.profile.isDefaultProfile(profileID)
	if not profileID then return false end
	return string.sub(profileID, -1) == "*";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local profileListID = {};

local function decorateProfileList(widget, id)
	widget.profileID = id;
	local profile = profiles[id];
	local dataTab = getData("player/characteristics", profile);
	local mainText = profile.profileName;

	if id == currentProfileId then
		widget:SetBorderColor(TRP3_API.CreateColor(0.1, 0.8, 0.1));
		widget.CurrentText:Show();
	else
		widget:SetBorderColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN);
		widget.CurrentText:Hide();
	end

	widget:SetIcon(dataTab.IC);
	widget:SetNameText(mainText);

	local listText = "";
	local i = 0;
	for characterID, characterInfo in pairs(characters) do
		if characterInfo.profileID == id then
			local charactName, charactRealm = TRP3_API.utils.str.unitIDToInfo(characterID);
			listText = listText.."- |cff00ff00"..charactName.." ( "..charactRealm.." )|r\n";
			i = i + 1;
		end
	end

	if id == getConfigValue("default_profile_id") then
		widget.HelpButton:Hide();
		widget:SetCountText(nil);
		widget.MenuButton:Hide();
	else
		widget.HelpButton:Show();
		widget.MenuButton:Show();

		widget:SetCountText(loc.PR_PROFILEMANAGER_COUNT:format(i));

		local text = "";
		if i > 0 then
			text = text..loc.PR_PROFILE_DETAIL..":\n"..listText;
		else
			text = text..loc.PR_UNUSED_PROFILE;
		end

		setTooltipForSameFrame(widget.HelpButton, "RIGHT", 0, 5, loc.PR_PROFILE, text);
	end
end

local function profileSortingByProfileName(profileID1, profileID2)
	return profiles[profileID1].profileName < profiles[profileID2].profileName;
end

-- Refresh list display
local function uiInitProfileList()
	wipe(profileListID);
	local defaultProfileID = getConfigValue("default_profile_id");
	local profileSearch = Utils.str.emptyToNil(TRP3_ProfileManager.list.SearchBox:GetText());
	for profileID, _ in pairs(profiles) do
		if profileID ~= defaultProfileID and (not profileSearch or string.find(profiles[profileID].profileName:lower(), profileSearch:lower(), 1, true)) then
			tinsert(profileListID, profileID);
		end
	end

	table.sort(profileListID, profileSortingByProfileName);

	local size = #profileListID;
	TRP3_ProfileManager.list.ScrollBox.EmptyText:Hide();
	if profileSearch then
		if size == 0 then
			TRP3_ProfileManager.list.ScrollBox.EmptyText:Show();
		end
	else
		tinsert(profileListID, 1, defaultProfileID);
	end

	local provider = CreateDataProvider(profileListID);
	TRP3_ProfileManager.list.ScrollBox:SetDataProvider(provider, ScrollBoxConstants.RetainScrollPosition);
end

local showTextInputPopup, showConfirmPopup = TRP3_API.popup.showTextInputPopup, TRP3_API.popup.showConfirmPopup;

local function uiCheckNameAvailability(profileName)
	if not isProfileNameAvailable(profileName) then
		TRP3_API.ui.tooltip.toast(loc.PR_PROFILEMANAGER_ALREADY_IN_USE:format(Utils.str.color("r")..profileName.."|r"), 3);
		return false;
	end
	return true;
end

local function uiCreateProfile()
	showTextInputPopup(loc.PR_PROFILEMANAGER_CREATE_POPUP,
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			createProfile(newName);
			uiInitProfileList();
		end
	end,
	nil,
	Globals.player_realm .. " - " .. Globals.player
	);
end

-- Promps profile delete confirmation
local function uiDeleteProfile(profileID)
	showConfirmPopup(loc.PR_PROFILEMANAGER_DELETE_WARNING:format(Utils.str.color("g")..profiles[profileID].profileName.."|r"),
	function()
		deleteProfile(profileID);
		uiInitProfileList();
	end);
end

local function uiEditProfile(profileID)
	showTextInputPopup(
	loc.PR_PROFILEMANAGER_EDIT_POPUP:format(Utils.str.color("g")..profiles[profileID].profileName.."|r"),
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

local function uiDuplicateProfile(profileID)
	showTextInputPopup(
	loc.PR_PROFILEMANAGER_DUPP_POPUP:format(Utils.str.color("g")..profiles[profileID].profileName.."|r"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			duplicateProfile(profiles[profileID], newName);
			uiInitProfileList();
		end
	end,
	nil,
	profiles[profileID].profileName
	);
end

local function onProfileSelected(button)
	local profileID = button.profileID;
	uiSelectProfile(profileID);
end

local function onActionSelected(value, button)
	local profileID = button:GetParent().profileID;

	if value == PROFILEMANAGER_ACTIONS.DELETE then
		uiDeleteProfile(profileID);
	elseif value == PROFILEMANAGER_ACTIONS.RENAME then
		uiEditProfile(profileID);
	elseif value == PROFILEMANAGER_ACTIONS.DUPLICATE then
		uiDuplicateProfile(profileID);
	elseif value == PROFILEMANAGER_ACTIONS.EXPORT then
		local profile = profiles[profileID];
		local serial = Utils.serial.serialize({Globals.version, profileID, profile });
		if serial:len() < 20000 then
			TRP3_ProfileExport.content.scroll.text:SetText(serial);
			TRP3_ProfileExport.content.title:SetText(loc.PR_EXPORT_NAME:format(profile.profileName, serial:len() / 1024));
			TRP3_ProfileExport:Show();
			TRP3_ProfileExport.content.scroll.text:SetFocus();
		else
			Utils.message.displayMessage(loc.PR_EXPORT_TOO_LARGE:format(serial:len() / 1024), 2);
		end
	elseif value == PROFILEMANAGER_ACTIONS.IMPORT then
		TRP3_ProfileImport.profileID = profileID;
		TRP3_ProfileImport:Show();
		TRP3_ProfileImport.content.scroll.text:SetText("");
	end
end

local function onActionClicked(_, button)
	local profileID = button:GetParent().profileID;

	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		description:CreateTitle(loc.PR_PROFILE_MANAGEMENT_TITLE);
		description:CreateButton(loc.PR_PROFILEMANAGER_RENAME, function() onActionSelected(PROFILEMANAGER_ACTIONS.RENAME, button); end);
		description:CreateButton(loc.PR_DUPLICATE_PROFILE, function() onActionSelected(PROFILEMANAGER_ACTIONS.DUPLICATE, button); end);
		if currentProfileId ~= profileID then
			description:CreateButton("|cnRED_FONT_COLOR:" .. loc.PR_DELETE_PROFILE .. "|r", function() onActionSelected(PROFILEMANAGER_ACTIONS.DELETE, button); end);
		else
			description:CreateButton(loc.PR_DELETE_PROFILE):SetEnabled(false);
		end

		description:CreateDivider();

		description:CreateTitle(loc.PR_EXPORT_IMPORT_TITLE);
		if currentProfileId ~= profileID then
			description:CreateButton(loc.PR_IMPORT_PROFILE, function() onActionSelected(PROFILEMANAGER_ACTIONS.EXPORT, button); end);
		else
			description:CreateButton(loc.PR_IMPORT_PROFILE):SetEnabled(false);
		end
		description:CreateButton(loc.PR_EXPORT_PROFILE, function() onActionSelected(PROFILEMANAGER_ACTIONS.EXPORT, button); end);
	end);
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
local TUTORIAL_STRUCTURE;

local function createTutorialStructure()
	TUTORIAL_STRUCTURE = {
		{
			box = {
				allPoints = TRP3_ProfileManagerList
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
	createTutorialStructure();

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
		TRP3_API.configuration.setValue("default_profile_id", createProfile(loc.PR_DEFAULT_PROFILE_NAME, true));
	else
		updateDefaultProfile();
	end

	-- First time this character is connected with TRP3 or if deleted profile through another character
	-- So we select the default profile.
	if not character.profileID or not profiles[character.profileID] then
		selectProfile(getConfigValue("default_profile_id"));
	else
		selectProfile(character.profileID);
	end

	-- UI
	local tabGroup; -- Reference to the tab panel tabs group

	local function OnSearchTextChanged()
		local text = TRP3_ProfileManager.list:GetSearchText();

		uiInitProfileList();

		if text == "" then
			TRP3_ProfileManager.list.ScrollBox:ScrollToElementData(currentProfileId);
		else
			TRP3_ProfileManager.list.ScrollBox:ScrollToBegin();
		end
	end

	local function OnHelpButtonTooltip(_, description)
		TRP3_TooltipTemplates.CreateBasicTooltip(description, loc.PR_EXPORT_IMPORT_TITLE, loc.PR_EXPORT_IMPORT_HELP);
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
		local instructions = {{"CLICK", loc.PR_PROFILEMANAGER_SWITCH}, {"SHIFT-CLICK", loc.CL_TOOLTIP}};

		TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);
	end

	local function OnListElementClick(button)
		if IsShiftKeyDown() then
			TRP3_API.ChatLinks:OpenMakeImportablePrompt(loc.CL_PLAYER_PROFILE, function(canBeImported)
				TRP3_API.ProfilesChatLinkModule:InsertLink(button.profileID, canBeImported);
			end);
		else
			if currentProfileId ~= button.profileID then
				onProfileSelected(button);
				TRP3_API.ui.misc.playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			end
		end
	end

	local function OnListElementInitialize(button, profileID)
		button:SetMenuButtonCallback(onActionClicked);
		button:SetMenuButtonTooltip(OnMenuButtonTooltip);
		button:SetScript("OnClick", OnListElementClick);
		button:SetTooltip(OnListElementTooltip);
		decorateProfileList(button, profileID);
	end

	TRP3_ProfileManager.list:SetElementInitializer("TRP3_ProfileManagerListElement", OnListElementInitialize);
	TRP3_ProfileManager.list:SetCreateCallback(uiCreateProfile);
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
		uiInitProfileList();
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
				uiInitProfileList();  -- Force refresh
			end
		end
	end);

	-- Export/Import
	local exportWarningText = IsMacClient() and loc.PR_EXPORT_WARNING_MAC or loc.PR_EXPORT_WARNING_WINDOWS;
	TRP3_ProfileExport.title:SetText(loc.PR_EXPORT_PROFILE);
	TRP3_ProfileExport.warning:SetText(TRP3_API.Colors.Red(loc.PR_EXPORT_WARNING_TITLE) .. "\n" .. exportWarningText);
	TRP3_ProfileImport.title:SetText(loc.PR_IMPORT_PROFILE);
	TRP3_ProfileImport.content.title:SetText(loc.PR_IMPORT_PROFILE_TT);
	TRP3_ProfileImport.save:SetText(loc.PR_IMPORT);
	TRP3_ProfileImport.save:SetScript("OnClick", function()
		local profileID = TRP3_ProfileImport.profileID;
		local code = TRP3_ProfileImport.content.scroll.text:GetText();
		local object = Utils.serial.safeDeserialize(code);

		if object and type(object) == "table" and #object == 3 then
			local version = object[1];
			local data = object[3];

			local import = function()
				data.profileName = profiles[profileID].profileName;
				wipe(profiles[profileID]);
				profiles[profileID] = data;

				if data then
					-- Converting old music paths to new ID system
					if data.player and data.player.about and data.player.about.MU and type(data.player.about.MU) == "string" then
						profiles[profileID].player.about.MU = Utils.music.convertPathToID(data.player.about.MU);
					end

					-- Misc info ID conversion
					if data.player and data.player.characteristics and data.player.characteristics.MI then
						for _, miscData in ipairs(data.player.characteristics.MI) do
							if not miscData.ID or miscData.ID ~= TRP3_API.MiscInfoType.Custom then
								-- Adding ID from name if ID missing, or setting a preset to custom if renamed
								miscData.ID = TRP3_API.GetMiscInfoTypeByName(miscData.NA);
							end
						end
					end
				end

				TRP3_ProfileImport:Hide();
				uiInitProfileList();
			end

			if version ~= Globals.version then
				showConfirmPopup(loc.PR_PROFILEMANAGER_IMPORT_WARNING_2:format(Utils.str.color("g") .. profiles[profileID].profileName .. "|r"), import);
			else
				showConfirmPopup(loc.PR_PROFILEMANAGER_IMPORT_WARNING:format(Utils.str.color("g") .. profiles[profileID].profileName .. "|r"), import);
			end
		else
			Utils.message.displayMessage(loc.DB_IMPORT_ERROR1, 2);
		end
	end);

	-- Setup edit boxes to handle serialized data using Ellyb's mixin
	Mixin(TRP3_ProfileExport.content.scroll.text, TRP3_API.Ellyb.EditBoxes.SerializedDataEditBoxMixin);
	Mixin(TRP3_ProfileImport.content.scroll.text, TRP3_API.Ellyb.EditBoxes.SerializedDataEditBoxMixin);

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
					selectProfile(profileID);
					return;
				end
			end

			displayMessage(loc.PR_SLASH_NOT_FOUND:format(profileName));
		end
	});
end
