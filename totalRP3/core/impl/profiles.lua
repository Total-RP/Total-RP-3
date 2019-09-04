----------------------------------------------------------------------------------
--- Total RP 3
--- Player profiles API
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

-- Public accessor
TRP3_API.profile = {};

-- imports
local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local loc = TRP3_API.loc;
local unitIDToInfo = Utils.str.unitIDToInfo;
local strsplit, tinsert, pairs, type, assert, _G, table, tostring, error, wipe = strsplit, tinsert, pairs, type, assert, _G, table, tostring, error, wipe;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local registerPage = TRP3_API.navigation.page.registerPage;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local playUISound = TRP3_API.ui.misc.playUISound;
local playAnimation = TRP3_API.ui.misc.playAnimation;
local tcopy = TRP3_API.utils.table.copy;
local displayMessage = TRP3_API.utils.message.displayMessage;
local getPlayerCurrentProfile;

-- Saved variables references
local profiles, character, characters;

local PATH_DELIMITER = "/";
local currentProfile, currentProfileId;
local PR_DEFAULT_PROFILE = {
	player = {},
};

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
local function duplicateProfile(duplicatedProfile, profileName)
	assert(duplicatedProfile, "Nil profile");
	assert(isProfileNameAvailable(profileName), "Unavailable profile name: "..tostring(profileName));
	local profileID = Utils.str.id();
	profiles[profileID] = {};
	Utils.table.copy(profiles[profileID], duplicatedProfile);
	profiles[profileID].profileName = profileName;
	displayMessage(loc.PR_PROFILE_CREATED:format(Utils.str.color("g")..profileName.."|r"));
	return profileID;
end
TRP3_API.profile.duplicateProfile = duplicateProfile;

-- Creating a new profile using PR_DEFAULT_PROFILE as a template
local function createProfile(profileName)
	return duplicateProfile(PR_DEFAULT_PROFILE, profileName);
end

-- Just internally switch the current profile structure. That's all.
local function selectProfile(profileID)
	if not profiles[profileID] then
		error("Unknown profile id: " + profileID);
	end
	currentProfile = profiles[profileID];
	currentProfileId = profileID;
	character.profileID = profileID;
	displayMessage(loc.PR_PROFILE_LOADED:format(Utils.str.color("g")..profiles[character.profileID]["profileName"].."|r"));
	Events.fireEvent(Events.REGISTER_PROFILES_LOADED, currentProfile);
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, profileID);
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local profileListID = {};

local function decorateProfileList(widget, index)
	local id = profileListID[index];
	widget.profileID = id;
	local profile = profiles[id];
	local dataTab = getData("player/characteristics", profile);
	local mainText = profile.profileName;

	if id == currentProfileId then

		widget:SetBackdropBorderColor(0, 1, 0);
		_G[widget:GetName().."Current"]:Show();
	else
		widget:SetBackdropBorderColor(1, 1, 1);
		_G[widget:GetName().."Current"]:Hide();
	end

	setupIconButton(_G[widget:GetName().."Icon"], dataTab.IC or Globals.icons.profile_default);
	_G[widget:GetName().."Name"]:SetText(mainText);
	Ellyb.Tooltips.getTooltip(widget):SetTitle(mainText);

	local listText = "";
	local i = 0;
	for characterID, characterInfo in pairs(characters) do
		if characterInfo.profileID == id then
			local charactName, charactRealm = unitIDToInfo(characterID);
			listText = listText.."- |cff00ff00"..charactName.." ( "..charactRealm.." )|r\n";
			i = i + 1;
		end
	end
	_G[widget:GetName().."Count"]:SetText(loc.PR_PROFILEMANAGER_COUNT:format(i));

	local text = "";
	if i > 0 then
		text = text..loc.PR_PROFILE_DETAIL..":\n"..listText;
	else
		text = text..loc.PR_UNUSED_PROFILE;
	end

	setTooltipForSameFrame(_G[widget:GetName().."Info"], "RIGHT", 0, 0, loc.PR_PROFILE, text);
end

local function profileSortingByProfileName(profileID1, profileID2)
	return profiles[profileID1].profileName < profiles[profileID2].profileName;
end

-- Refresh list display
local function uiInitProfileList()
	wipe(profileListID);
	for profileID, _ in pairs(profiles) do
		tinsert(profileListID, profileID);
	end
	table.sort(profileListID, profileSortingByProfileName);
	initList(TRP3_ProfileManagerList, profileListID, TRP3_ProfileManagerListSlider);
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
	playAnimation(_G[button:GetName() .. "HighlightAnimate"]);
	playAnimation(_G[button:GetName() .. "Animate"]);
	uiSelectProfile(profileID);
end

local function onActionSelected(value, button)
	local profileID = button:GetParent().profileID;

	if value == 1 then
		uiDeleteProfile(profileID);
	elseif value == 2 then
		uiEditProfile(profileID);
	elseif value == 3 then
		uiDuplicateProfile(profileID);
	elseif value == 4 then
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
	elseif value == 5 then
		TRP3_ProfileImport.profileID = profileID;
		TRP3_ProfileImport:Show();
		TRP3_ProfileExport.content.scroll.text:SetText("");
	end
end

local function onActionClicked(button)
	local profileID = button:GetParent().profileID;
	local values = {};

	tinsert(values, {loc.PR_PROFILE_MANAGEMENT_TITLE});
	tinsert(values, {loc.PR_PROFILEMANAGER_RENAME, 2});
	tinsert(values, {loc.PR_DUPLICATE_PROFILE, 3});
	if currentProfileId ~= profileID then
		tinsert(values, {loc.PR_DELETE_PROFILE, 1});
	else
		tinsert(values, {"|cff999999" .. loc.PR_DELETE_PROFILE, nil});
	end

	tinsert(values, {""});
	tinsert(values, {loc.PR_EXPORT_IMPORT_TITLE});
	if currentProfileId ~= profileID then
		tinsert(values, {loc.PR_IMPORT_PROFILE, 5});
	else
		tinsert(values, {"|cff999999" .. loc.PR_IMPORT_PROFILE, nil});
	end
	tinsert(values, {loc.PR_EXPORT_PROFILE, 4});

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

	-- First time this character is connected with TRP3 or if deleted profile through another character
	-- So we create a new profile named by his pseudo.
	if not character.profileID or not profiles[character.profileID] then
		-- Detect if a profile with name - realm already exists
		local available, profileID = isProfileNameAvailable(Globals.player_realm .. " - " .. Globals.player);
		if not available and profileID then
			selectProfile(profileID);
		else
			selectProfile(createProfile(Globals.player_realm .. " - " .. Globals.player));
		end
	else
		selectProfile(character.profileID);
	end

	-- UI
	local tabGroup; -- Reference to the tab panel tabs group
	handleMouseWheel(TRP3_ProfileManagerList, TRP3_ProfileManagerListSlider);
	TRP3_ProfileManagerListSlider:SetValue(0);
	local widgetTab = {};
	for i=1,5 do
		local widget = _G["TRP3_ProfileManagerListLine"..i];
		widget:SetScript("OnMouseUp",function (self)
			if IsShiftKeyDown() then
				TRP3_API.ChatLinks:OpenMakeImportablePrompt(loc.CL_PLAYER_PROFILE, function(canBeImported)
					TRP3_API.ProfilesChatLinkModule:InsertLink(self.profileID, canBeImported);
				end);
			else
				if currentProfileId ~= self.profileID then
					onProfileSelected(widget);
					playAnimation(_G[self:GetName() .. "HighlightAnimate"]);
					playAnimation(_G[self:GetName() .. "Animate"]);
					playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
				end

			end
		end);
		_G[widget:GetName().."Action"]:SetScript("OnClick", onActionClicked);
		_G[widget:GetName().."Current"]:SetText(loc.PR_PROFILEMANAGER_CURRENT);
		table.insert(widgetTab, widget);

		Ellyb.Tooltips.getTooltip(_G[widget:GetName().."Action"])
			:SetAnchor(Ellyb.Tooltips.ANCHORS.TOP)
			:SetTitle(loc.PR_PROFILEMANAGER_ACTIONS);

		-- Display indications in the tooltip on how to create a chat link
		Ellyb.Tooltips.getTooltip(widget)
			:AddLine(
				Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.CM_OPEN)
			)
			:AddLine(
				Ellyb.Strings.clickInstruction(
						Ellyb.System:FormatKeyboardShortcut(Ellyb.System.MODIFIERS.SHIFT, Ellyb.System.CLICKS.CLICK),
						loc.CL_TOOLTIP
				)
			);

	end
	TRP3_ProfileManagerList.widgetTab = widgetTab;
	TRP3_ProfileManagerList.decorate = decorateProfileList;
	TRP3_ProfileManagerAdd:SetScript("OnClick", uiCreateProfile);

	--Localization
	TRP3_ProfileManagerAdd:SetText(loc.PR_CREATE_PROFILE);

	TRP3_ProfileManagerInfo:Show();
	setTooltipForSameFrame(TRP3_ProfileManagerInfo, "RIGHT", 0, 0, loc.PR_EXPORT_IMPORT_TITLE, loc.PR_EXPORT_IMPORT_HELP);

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

	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, function()
		if getCurrentPageID() == "player_profiles" then
			if tabGroup.current == 1 then
				tabGroup:SelectTab(1); -- Force refresh
			end
		end
	end);

    -- Stash data command
    -- Will move all the user data in a stash variable and reload UI with empty variables,
    -- and then restore the data on the second use.
    -- Used for debugging/testing
    TRP3_API.slash.registerCommand({
        id = "stash",
        handler = function()
            -- The list of our global variables that will be stashed away.
            local globalVariables = {"TRP3_Profiles", "TRP3_Characters", "TRP3_Configuration", "TRP3_Flyway", "TRP3_Presets", "TRP3_Companions", "TRP3_Colors"};
            -- If we already have data stashed, restore the data
            if TRP3_StashedData then
                for _, variable in pairs(globalVariables) do
					-- Copy stashed data into the global variable
                    tcopy(_G[variable], TRP3_StashedData[variable] or _G[variable]);
                end
                -- Empty the stash so we know we can use it again
                TRP3_StashedData = nil;
				ReloadUI();
            else
                -- Ask for confirmation before stashing user data!
                showConfirmPopup(loc.COM_STASH_DATA, function()
                    TRP3_StashedData = {};
                    -- Loop through each global variable we want to stash
                    for _, variable in pairs(globalVariables) do
						TRP3_StashedData[variable] = {}
						-- Store the globale variable data into the stash
                        tcopy(TRP3_StashedData[variable], _G[variable]);
                        -- And empty the variable
                        _G[variable] = nil;
                    end
					ReloadUI();
                end);
            end
        end
    });

	-- Export/Import
	local exportWarningText = TRP3_API.Ellyb.System.IsMac() and loc.PR_EXPORT_WARNING_MAC or loc.PR_EXPORT_WARNING_WINDOWS;
	TRP3_ProfileExport.title:SetText(loc.PR_EXPORT_PROFILE);
	TRP3_ProfileExport.warning:SetText(TRP3_API.Ellyb.ColorManager.RED(loc.PR_EXPORT_WARNING_TITLE) .. "\n" .. exportWarningText);
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

					-- Default preferred locale appropriately.
					if data.character and not data.character.LC then
						data.character.LC = TRP3_API.configuration.getValue("AddonLocale") or GetLocale();
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
