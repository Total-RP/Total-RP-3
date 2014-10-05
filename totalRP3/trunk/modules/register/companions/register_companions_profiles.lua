----------------------------------------------------------------------------------
-- Total RP 3
-- Pets/mounts managements : Profile list
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- imports
local Globals, loc, Utils, Events = TRP3_API.globals, TRP3_API.locale.getText, TRP3_API.utils, TRP3_API.events;
local tinsert, _G, pairs, type = tinsert, _G, pairs, type;
local tsize = Utils.table.size;
local unregisterMenu = TRP3_API.navigation.menu.unregisterMenu;
local isMenuRegistered, rebuildMenu = TRP3_API.navigation.menu.isMenuRegistered, TRP3_API.navigation.menu.rebuildMenu;
local registerMenu, selectMenu, openMainFrame = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu, TRP3_API.navigation.openMainFrame;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local showAlertPopup, showTextInputPopup, showConfirmPopup = TRP3_API.popup.showAlertPopup, TRP3_API.popup.showTextInputPopup, TRP3_API.popup.showConfirmPopup;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local initList = TRP3_API.ui.list.initList;
local getProfiles, isProfileNameAvailable = TRP3_API.companions.player.getProfiles, TRP3_API.companions.player.isProfileNameAvailable;
local createProfile, deleteProfile = TRP3_API.companions.player.createProfile, TRP3_API.companions.player.deleteProfile;
local duplicateProfile = TRP3_API.companions.player.duplicateProfile;
local editProfile = TRP3_API.companions.player.editProfile;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local TRP3_CompanionsProfilesList, TRP3_CompanionsProfilesListSlider, TRP3_CompanionsProfilesListEmpty = TRP3_CompanionsProfilesList, TRP3_CompanionsProfilesListSlider, TRP3_CompanionsProfilesListEmpty;
local EMPTY, PetCanBeRenamed = Globals.empty, PetCanBeRenamed;
local getCompanionProfile, getCompanionProfileID = TRP3_API.companions.player.getCompanionProfile, TRP3_API.companions.player.getCompanionProfileID;
local getCompanionRegisterProfile = TRP3_API.companions.register.getCompanionProfile;
local companionIDToInfo = Utils.str.companionIDToInfo;
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
local playUISound = TRP3_API.ui.misc.playUISound;
local isTargetTypeACompanion, companionHasProfile = TRP3_API.ui.misc.isTargetTypeACompanion, TRP3_API.companions.register.companionHasProfile;
local getCompanionProfileID = TRP3_API.companions.player.getCompanionProfileID;
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local uiInitProfileList;

TRP3_API.navigation.menu.id.COMPANIONS_PAGE_PREFIX = "main_21_companions_";
TRP3_API.navigation.page.id.COMPANIONS_PROFILES = "companions_profiles";
local currentlyOpenedProfilePrefix = TRP3_API.navigation.menu.id.COMPANIONS_PAGE_PREFIX;

local function uiCheckNameAvailability(profileName)
	if not isProfileNameAvailable(profileName) then
		showAlertPopup(loc("PR_PROFILEMANAGER_ALREADY_IN_USE"):format(Utils.str.color("g")..profileName.."|r"));
		return false;
	end
	return true;
end

local function openProfile(profileID)
	local profile = getProfiles()[profileID];
	if isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
		-- If the character already has his "tab", simply open it
		selectMenu(currentlyOpenedProfilePrefix .. profileID);
	else
		-- Else, create a new menu entry and open it.
		local tabText = profile.profileName;
		registerMenu({
			id = currentlyOpenedProfilePrefix .. profileID,
			text = tabText,
			onSelected = function() setPage(TRP3_API.navigation.page.id.COMPANIONS_PAGE, {profile = profile, profileID = profileID, isPlayer = true}) end,
			isChildOf = TRP3_API.navigation.menu.id.COMPANIONS_MAIN,
			closeable = true,
		});
		selectMenu(currentlyOpenedProfilePrefix .. profileID);
	end
end
TRP3_API.companions.openPage = openProfile;

local function uiCreateProfile()
	showTextInputPopup(loc("PR_PROFILEMANAGER_CREATE_POPUP"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			local profileID = createProfile(newName);
			openProfile(profileID);
		end
	end,
	nil,
	loc("PR_CO_NEW_PROFILE")
	);
end

local function uiDuplicateProfile(profileID)
	local profile = getProfiles()[profileID];
	showTextInputPopup(
	loc("PR_PROFILEMANAGER_DUPP_POPUP"):format(Utils.str.color("g").. profile.profileName .. "|r"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			local profileID = duplicateProfile(profile, newName);
			openProfile(profileID);
		end
	end,
	nil,
	profile.profileName
	);
end

-- Promps profile delete confirmation
local function uiDeleteProfile(profileID)
	showConfirmPopup(loc("PR_CO_PROFILEMANAGER_DELETE_WARNING"):format(Utils.str.color("g")..getProfiles()[profileID].profileName.."|r"),
	function()
		deleteProfile(profileID);
		uiInitProfileList();
	end);
end

local getMenuItem = TRP3_API.navigation.menu.getMenuItem;

local function uiEditProfile(profileID)
	local profile = getProfiles()[profileID];
	showTextInputPopup(
	loc("PR_CO_PROFILEMANAGER_EDIT_POPUP"):format(Utils.str.color("g") .. profile.profileName .. "|r"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			editProfile(profileID, newName);
			uiInitProfileList();
			if isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
				getMenuItem(currentlyOpenedProfilePrefix .. profileID).text = newName;
				rebuildMenu();
			end
		end
	end,
	nil,
	profile.profileName
	);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getCompanionTypeText(companionType)
	if companionType == TYPE_PET then
		return loc("PR_CO_PET");
	elseif companionType == TYPE_BATTLE_PET then
		return loc("PR_CO_BATTLE");
	end
	return "";
end

local function decorateProfileList(widget, id)
	widget.profileID = id;
	local profile = getProfiles()[id];
	local dataTab = profile.data or {};
	local mainText = profile.profileName;

	setupIconButton(_G[widget:GetName().."Icon"], dataTab.IC or Globals.icons.profile_default);
	_G[widget:GetName().."Name"]:SetText(mainText);

	local listText = "";
	local i = 0;
	for companionID, companionType in pairs(profile.links or EMPTY) do
		listText = listText .. "- |cff00ff00" .. companionID .. "|cffff9900 (" .. getCompanionTypeText(companionType) .. ")|r\n";
		i = i + 1;
	end
	_G[widget:GetName().."Count"]:SetText(loc("PR_CO_COUNT"):format(i));

	local text = "";
	if i > 0 then
		text = text..loc("PR_CO_PROFILE_DETAIL")..":\n"..listText;
	else
		text = text..loc("PR_CO_UNUSED_PROFILE");
	end

	setTooltipForSameFrame(
	_G[widget:GetName().."Info"], "RIGHT", 0, 0,
	loc("PR_PROFILE"),
	text
	)
end

-- Refresh list display
function uiInitProfileList()
	local size = tsize(getProfiles());
	TRP3_CompanionsProfilesListEmpty:Hide();
	if size == 0 then
		TRP3_CompanionsProfilesListEmpty:Show();
	end
	initList(TRP3_CompanionsProfilesList, getProfiles(), TRP3_CompanionsProfilesListSlider);
end

local function onActionSelected(value, button)
	local profileID = button:GetParent().profileID;
	if value == 1 then
		uiDeleteProfile(profileID);
	elseif value == 2 then
		uiEditProfile(profileID);
	elseif value == 3 then
		uiDuplicateProfile(profileID);
	end
end

local function onActionClicked(button)
	local profileID = button:GetParent().profileID;
	local values = {};
	tinsert(values, {loc("PR_DELETE_PROFILE"), 1});
	tinsert(values, {loc("PR_PROFILEMANAGER_RENAME"), 2});
	tinsert(values, {loc("PR_DUPLICATE_PROFILE"), 3});
	displayDropDown(button, values, onActionSelected, 0, true);
end

local function onOpenProfile(button)
	openProfile(button:GetParent().profileID);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Target button
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local displayDropDown, UnitName = TRP3_API.ui.listbox.displayDropDown, UnitName;
local getProfiles, boundPlayerCompanion, unboundPlayerCompanion = TRP3_API.companions.player.getProfiles, TRP3_API.companions.player.boundPlayerCompanion, TRP3_API.companions.player.unboundPlayerCompanion;

local function ui_boundPlayerCompanion(companionID, profileID, targetType)
	if targetType == TYPE_PET and UnitName("pet") == companionID and PetCanBeRenamed() then
		showConfirmPopup(loc("PR_CO_WARNING_RENAME"), function()
			boundPlayerCompanion(companionID, profileID, targetType);
		end);
	else
		boundPlayerCompanion(companionID, profileID, targetType);
	end
end

local function createNewAndBound(companionID, targetType)
	showTextInputPopup(loc("PR_PROFILEMANAGER_CREATE_POPUP"),
	function(newName)
		if newName and #newName ~= 0 then
			if not isProfileNameAvailable(newName) then
				showAlertPopup(loc("PR_PROFILEMANAGER_ALREADY_IN_USE"):format(Utils.str.color("g")..newName.."|r"));
				return;
			end
			local profileID = createProfile(newName);
			ui_boundPlayerCompanion(companionID, profileID, targetType);
		end
	end,
	nil,
	companionID
	);
end

local function onCompanionProfileSelection(value, companionID, targetType)
	if value == 0 then
		openProfile(getCompanionProfileID(companionID));
		openMainFrame();
	elseif value == 1 then
		unboundPlayerCompanion(companionID);
	elseif value == 2 then
		createNewAndBound(companionID, targetType);
	elseif type(value) == "string" then
		ui_boundPlayerCompanion(companionID, value, targetType);
	end
end

local function getPlayerCompanionProfilesAsList(companionID)
	local list = {};
	tinsert(list, {loc("REG_COMPANION_TF_CREATE"), 2});
	for profileID, profile in pairs(getProfiles()) do
		if getCompanionProfileID(companionID) == profileID then
			tinsert(list, {profile.profileName, nil});
		else
			tinsert(list, {profile.profileName, profileID});
		end
	end
	return list;
end

local function getCompanionInfo(owner, companionID, companionFullID)
	local profile;
	if owner == Globals.player_id then
		profile = getCompanionProfile(companionID);
	else
		profile = getCompanionRegisterProfile(companionFullID);
	end
	return profile;
end

local function companionProfileSelectionList(companionFullID, targetType, buttonStructure, button)
	local ownerID, companionID = companionIDToInfo(companionFullID);
	if ownerID == Globals.player_id then
		local list = {};
		if getCompanionProfile(companionID) then
			tinsert(list, {loc("REG_COMPANION_TF_OPEN"), 0});
			tinsert(list, {loc("REG_COMPANION_TF_UNBOUND"), 1});
		end
		tinsert(list, {loc("REG_COMPANION_TF_BOUND_TO"), getPlayerCompanionProfilesAsList(companionID)});

		displayDropDown(button, list, function(value) onCompanionProfileSelection(value, companionID, targetType) end, 0, true);
	else
		if companionHasProfile(companionFullID) then
			TRP3_API.companions.register.openPage(companionHasProfile(companionFullID));
			openMainFrame();
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onPageShow(context)
	uiInitProfileList();
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	Events.listenToEvent(Events.REGISTER_PROFILE_DELETED, function(profileID)
		if isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
			unregisterMenu(currentlyOpenedProfilePrefix .. profileID);
		end
	end);

	local tabGroup; -- Reference to the tab panel tabs group
	registerPage({
		id = TRP3_API.navigation.page.id.COMPANIONS_PROFILES,
		frame = TRP3_CompanionsProfiles,
		onPagePostShow = function(context)
			tabGroup:SelectTab(1);
			onPageShow(context);
		end,
	});

	-- UI
	handleMouseWheel(TRP3_CompanionsProfilesList, TRP3_CompanionsProfilesListSlider);
	TRP3_CompanionsProfilesListSlider:SetValue(0);
	local widgetTab = {};
	for i=1,5 do
		local widget = _G["TRP3_CompanionsProfilesListLine"..i];
		widget:SetScript("OnMouseUp",function (self)
			onOpenProfile(_G[self:GetName().."Select"]);
			playUISound("gsCharacterSelection");
		end);
		_G[widget:GetName().."Select"]:SetScript("OnClick", onOpenProfile);
		_G[widget:GetName().."Select"]:SetText(loc("CM_OPEN"));
		_G[widget:GetName().."Action"]:SetScript("OnClick", onActionClicked);
		setTooltipAll(_G[widget:GetName().."Action"], "TOP", 0, 0, loc("PR_PROFILEMANAGER_ACTIONS"));
		tinsert(widgetTab, widget);
	end
	TRP3_CompanionsProfilesList.widgetTab = widgetTab;
	TRP3_CompanionsProfilesList.decorate = decorateProfileList;
	TRP3_CompanionsProfilesAdd:SetScript("OnClick", uiCreateProfile);

	--Localization
	TRP3_CompanionsProfilesAdd:SetText(loc("PR_CREATE_PROFILE"));
	TRP3_CompanionsProfilesListEmpty:SetText(loc("PR_CO_EMPTY"));
	
	local frame = CreateFrame("Frame", "TRP3_CompanionsProfilesTabBar", TRP3_CompanionsProfiles);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, -5);
	frame:SetFrameLevel(1);

	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
		{
			{loc("PR_PROFILEMANAGER_TITLE"), 1, 175},
--			{loc("PR_IMPORT_PETS_TAB"), 2, 175},
		},
		function(tabWidget, value)
			local list, importer = TRP3_CompanionsProfiles:GetChildren();
			importer:Hide();
			list:Hide();
			if value == 1 then
				list:Show();
			elseif value == 2 then
				importer:Show();
			end
		end
	);
	tabGroup:SelectTab(1);

end);

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		-- Target bar
		TRP3_API.target.registerButton({
			id = "companion_profile",
			configText = loc("REG_COMPANION_TF_PROFILE"),
			condition = function(targetType, unitID)
				if isTargetTypeACompanion(targetType) then
					local ownerID, companionID = companionIDToInfo(unitID);
					return ownerID == Globals.player_id or companionHasProfile(unitID);
				end
			end,
			onClick = companionProfileSelectionList,
			alertIcon = "Interface\\GossipFrame\\AvailableQuestIcon",
			adapter = function(buttonStructure, unitID, targetType)
				local ownerID, companionID = companionIDToInfo(unitID);
				local profile = getCompanionInfo(ownerID, companionID, unitID);
				buttonStructure.alert = nil;
				buttonStructure.tooltip = loc("TF_OPEN_COMPANION");
				buttonStructure.tooltipSub = nil;
				if ownerID == Globals.player_id then
					if profile then
						buttonStructure.tooltip = loc("PR_PROFILE") .. ": |cff00ff00" .. profile.profileName;
						if profile.data and profile.data.IC then
							buttonStructure.icon = profile.data.IC;
						end
					else
						buttonStructure.icon = "icon_petfamily_mechanical";
						buttonStructure.tooltip = loc("REG_COMPANION_TF_NO");
					end
				else
					if profile and profile.data and profile.data.IC then
						buttonStructure.icon = profile.data.IC;
					else
						buttonStructure.icon = Globals.icons.unknown;
					end
					if profile and profile.data and profile.data.read == false then
						buttonStructure.tooltipSub = loc("REG_TT_NOTIF");
						buttonStructure.alert = true;
					end
				end
			end,
		});
	end
end);