----------------------------------------------------------------------------------
--- Total RP 3
--- Pets/mounts managements : Profile list
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

-- imports
local Globals, loc, Utils, Events = TRP3_API.globals, TRP3_API.loc, TRP3_API.utils, TRP3_API.events;
local tinsert, _G, pairs, type, tostring = tinsert, _G, pairs, type, tostring;
local tsize = Utils.table.size;
local unregisterMenu = TRP3_API.navigation.menu.unregisterMenu;
local isMenuRegistered, rebuildMenu = TRP3_API.navigation.menu.isMenuRegistered, TRP3_API.navigation.menu.rebuildMenu;
local registerMenu, selectMenu, openMainFrame = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu, TRP3_API.navigation.openMainFrame;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local showAlertPopup, showTextInputPopup, showConfirmPopup = TRP3_API.popup.showAlertPopup, TRP3_API.popup.showTextInputPopup, TRP3_API.popup.showConfirmPopup;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
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
local getCompanionProfiles = TRP3_API.companions.player.getProfiles;
local getCompanionRegisterProfile = TRP3_API.companions.register.getCompanionProfile;
local companionIDToInfo = Utils.str.companionIDToInfo;
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
local TYPE_MOUNT = TRP3_API.ui.misc.TYPE_MOUNT;
local playUISound = TRP3_API.ui.misc.playUISound;
local isTargetTypeACompanion, companionHasProfile = TRP3_API.ui.misc.isTargetTypeACompanion, TRP3_API.companions.register.companionHasProfile;
local getCompanionNameFromSpellID = TRP3_API.companions.getCompanionNameFromSpellID;
local getCurrentMountSpellID, getCurrentMountProfile = TRP3_API.companions.player.getCurrentMountSpellID, TRP3_API.companions.player.getCurrentMountProfile;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local uiInitProfileList, ui_boundPlayerCompanion;

TRP3_API.navigation.menu.id.COMPANIONS_PAGE_PREFIX = "main_21_companions_";
TRP3_API.navigation.page.id.COMPANIONS_PROFILES = "companions_profiles";
local currentlyOpenedProfilePrefix = TRP3_API.navigation.menu.id.COMPANIONS_PAGE_PREFIX;

local function uiCheckNameAvailability(profileName)
	if not isProfileNameAvailable(profileName) then
		showAlertPopup(loc.PR_PROFILEMANAGER_ALREADY_IN_USE:format(Utils.str.color("g")..profileName.."|r"));
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
	showTextInputPopup(loc.PR_PROFILEMANAGER_CREATE_POPUP,
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			local profileID = createProfile(newName);
			openProfile(profileID);
		end
	end,
	nil,
	loc.PR_CO_NEW_PROFILE
	);
end

local function uiDuplicateProfile(profileID)
	local profile = getProfiles()[profileID];
	showTextInputPopup(
	loc.PR_PROFILEMANAGER_DUPP_POPUP:format(Utils.str.color("g").. profile.profileName .. "|r"),
	function(newName)
		if newName and #newName ~= 0 then
			if not uiCheckNameAvailability(newName) then return end
			local newProfileId = duplicateProfile(profile, newName);
			openProfile(newProfileId);
		end
	end,
	nil,
	profile.profileName
	);
end

-- Promps profile delete confirmation
local function uiDeleteProfile(profileID)
	showConfirmPopup(loc.PR_CO_PROFILEMANAGER_DELETE_WARNING:format(Utils.str.color("g")..getProfiles()[profileID].profileName.."|r"),
	function()
		deleteProfile(profileID);
		uiInitProfileList();
	end);
end

local getMenuItem = TRP3_API.navigation.menu.getMenuItem;

local function uiEditProfile(profileID)
	local profile = getProfiles()[profileID];
	showTextInputPopup(
	loc.PR_CO_PROFILEMANAGER_EDIT_POPUP:format(Utils.str.color("g") .. profile.profileName .. "|r"),
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

local function uiBoundProfile(profileID, companionType)
	TRP3_API.popup.showCompanionBrowser(function(companionInfo)
		ui_boundPlayerCompanion(companionInfo[5] and tostring(companionInfo[5]) or companionInfo[1], profileID, companionType);
	end, nil, companionType);
end

local function uiBoundTargetProfile(profileID)
	local targetType, isMine = TRP3_API.ui.misc.getTargetType("target");
	if (targetType == TYPE_BATTLE_PET or targetType == TYPE_PET) and isMine then
		local companionFullID = TRP3_API.ui.misc.getCompanionFullID("target", targetType);
		local companionID = UnitName("target");
		if companionFullID then
			ui_boundPlayerCompanion(companionID, profileID, targetType);
			return;
		end
	end
	TRP3_API.ui.tooltip.toast("|cffff0000" .. loc.REG_COMPANION_TARGET_NO, 4);
end

local unboundPlayerCompanion = TRP3_API.companions.player.unboundPlayerCompanion;
local function uiUnboundTargetProfile(_, companionInfo)
	local companionID, companionType = companionInfo:sub(1, companionInfo:find("|") - 1), companionInfo:sub(companionInfo:find("|") + 1);
	unboundPlayerCompanion(companionID, companionType);
	TRP3_API.ui.tooltip.toast(loc.REG_COMPANION_LINKED_NO:format("|cff00ff00" .. getCompanionNameFromSpellID(companionID) .. "|r"), 4);
	uiInitProfileList();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local profileListID = {};
local wipe, table = wipe, table;

local function getCompanionTypeText(companionType)
	if companionType == TYPE_PET then
		return loc.PR_CO_PET;
	elseif companionType == TYPE_BATTLE_PET then
		return loc.PR_CO_BATTLE;
	elseif companionType == TYPE_MOUNT then
		return loc.PR_CO_MOUNT;
	end
	return "";
end

local function decorateProfileList(widget, index)
	local id = profileListID[index];
	widget.profileID = id;
	local profile = getProfiles()[id];
	local dataTab = profile.data or {};
	local mainText = profile.profileName;

	setupIconButton(_G[widget:GetName().."Icon"], dataTab.IC or Globals.icons.profile_default);
	_G[widget:GetName().."Name"]:SetText(mainText);

	local listText = "";
	local i = 0;
	for companionID, companionType in pairs(profile.links or EMPTY) do
		listText = listText .. "- |cff00ff00" .. getCompanionNameFromSpellID(companionID)
				.. "|cffff9900 (" .. getCompanionTypeText(companionType) .. ")|r\n";
		i = i + 1;
	end
	_G[widget:GetName().."Count"]:SetText(loc.PR_CO_COUNT:format(i));

	local text = "";
	if i > 0 then
		text = text..loc.PR_CO_PROFILE_DETAIL..":\n"..listText;
	else
		text = text..loc.PR_CO_UNUSED_PROFILE;
	end

	setTooltipForSameFrame(
	_G[widget:GetName().."Info"], "RIGHT", 0, 0,
	loc.PR_PROFILE,
	text
	)

	Ellyb.Tooltips.getTooltip(widget):SetTitle(mainText)
end

local function profileSortingByProfileName(profileID1, profileID2)
	local profiles = getProfiles();
	return profiles[profileID1].profileName < profiles[profileID2].profileName;
end

-- Refresh list display
function uiInitProfileList()
	local size = tsize(getProfiles());
	TRP3_CompanionsProfilesListEmpty:Hide();
	if size == 0 then
		TRP3_CompanionsProfilesListEmpty:Show();
	end

	wipe(profileListID);
	for profileID, _ in pairs(getProfiles()) do
		tinsert(profileListID, profileID);
	end
	table.sort(profileListID, profileSortingByProfileName);

	initList(TRP3_CompanionsProfilesList, profileListID, TRP3_CompanionsProfilesListSlider);
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
		uiBoundProfile(profileID, TYPE_BATTLE_PET);
	elseif value == 5 then
		uiBoundProfile(profileID, TYPE_MOUNT);
	elseif value == 6 then
		uiBoundTargetProfile(profileID);
	elseif value then
		uiUnboundTargetProfile(profileID, value);
	end
end

local function onBoundClicked(button)
	local profileID = button:GetParent().profileID;
	local profile = getCompanionProfiles()[profileID];
	local values = {};
	tinsert(values, {loc.REG_COMPANION_BOUND_TO,
		{
			{loc.PR_CO_BATTLE, 4},
			{loc.PR_CO_MOUNT, 5},
			{loc.REG_COMPANION_BOUND_TO_TARGET, 6},
		}
	});
	if profile.links and tsize(profile.links) > 0 then
		local linksTab = {};
		for companionID, companionType in pairs(profile.links) do
			tinsert(linksTab, {getCompanionNameFromSpellID(companionID), companionID .. "|" .. companionType});
		end
		tinsert(values, {loc.REG_COMPANION_UNBOUND, linksTab});
	end

	displayDropDown(button, values, onActionSelected, 0, true);
end

local function onActionClicked(button)
	local values = {};
	tinsert(values, {loc.PR_DELETE_PROFILE, 1});
	tinsert(values, {loc.PR_PROFILEMANAGER_RENAME, 2});
	tinsert(values, {loc.PR_DUPLICATE_PROFILE, 3});
	displayDropDown(button, values, onActionSelected, 0, true);
end

local function onOpenProfile(button)
	openProfile(button.profileID);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Target button
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local boundPlayerCompanion = TRP3_API.companions.player.boundPlayerCompanion;
local displayMessage = Utils.message.displayMessage;
local getCurrentPageID = TRP3_API.navigation.page.getCurrentPageID;

ui_boundPlayerCompanion = function (companionID, profileID, targetType)
	if targetType == TYPE_PET and UnitName("pet") == companionID and PetCanBeRenamed() then
		showConfirmPopup(loc.PR_CO_WARNING_RENAME, function()
			boundPlayerCompanion(companionID, profileID, targetType);
		end);
	else
		boundPlayerCompanion(companionID, profileID, targetType);
	end
	local profile = getProfiles()[profileID];
	local companionName = getCompanionNameFromSpellID(companionID);
	displayMessage(loc.REG_COMPANION_LINKED:format("|cff00ff00" .. companionName .. "|r", "|cff00ff00" .. profile.profileName .. "|r"));
	if getCurrentPageID() == TRP3_API.navigation.page.id.COMPANIONS_PROFILES then
		uiInitProfileList();
	end
end

local function createNewAndBound(companionID, targetType)
	showTextInputPopup(loc.PR_PROFILEMANAGER_CREATE_POPUP,
	function(newName)
		if newName and #newName ~= 0 then
			if not isProfileNameAvailable(newName) then
				showAlertPopup(loc.PR_PROFILEMANAGER_ALREADY_IN_USE:format(Utils.str.color("g")..newName.."|r"));
				return;
			end
			local profileID = createProfile(newName);
			ui_boundPlayerCompanion(companionID, profileID, targetType);
		end
	end,
	nil,
	getCompanionNameFromSpellID(companionID)
	);
end

local function onCompanionProfileSelection(value, companionID, targetType)
	if targetType == TYPE_CHARACTER then
		targetType = TYPE_MOUNT;
	end
	if value == 0 then
		openProfile(getCompanionProfileID(companionID));
		openMainFrame();
	elseif value == 1 then
		unboundPlayerCompanion(companionID, targetType);
		if getCurrentPageID() == TRP3_API.navigation.page.id.COMPANIONS_PROFILES then
			uiInitProfileList();
		end
		displayMessage(loc.REG_COMPANION_LINKED_NO:format("|cff00ff00" .. getCompanionNameFromSpellID(companionID) .. "|r"));
	elseif value == 2 then
		createNewAndBound(companionID, targetType);
	elseif type(value) == "string" then
		ui_boundPlayerCompanion(companionID, value, targetType);
	end
end

local function getPlayerCompanionProfilesAsList(companionID)
	local list = {};
	tinsert(list, {loc.REG_COMPANION_TF_CREATE, 2});
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

local function companionProfileSelectionList(unitID, targetType, _, button)
	local ownerID, companionID, companionFullID;

	if targetType == TYPE_CHARACTER then
		ownerID = unitID;
		if ownerID == Globals.player_id then
			companionID = tostring(getCurrentMountSpellID());
		else
			companionFullID = TRP3_API.companions.register.getUnitMount(unitID, "target");
		end
	else
		companionFullID = unitID;
		ownerID, companionID = companionIDToInfo(companionFullID);
	end

	if ownerID == Globals.player_id then
		local list = {};
		if getCompanionProfile(companionID) then
			tinsert(list, {loc.REG_COMPANION_TF_OPEN, 0});
			tinsert(list, {loc.REG_COMPANION_TF_UNBOUND, 1});
		end
		tinsert(list, {loc.REG_COMPANION_TF_BOUND_TO, getPlayerCompanionProfilesAsList(companionID)});

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

local function onPageShow()
	uiInitProfileList();
end

-- Tutorial
local TUTORIAL_STRUCTURE;

local function constructTutorialStructure()
	TUTORIAL_STRUCTURE = {
		{
			box = {
				allPoints = TRP3_CompanionsProfilesList
			},
			button = {
				x = 0, y = -150, anchor = "CENTER",
				text = loc.PR_CO_PROFILE_HELP,
				textWidth = 400,
				arrow = "UP"
			},
		},
		{
			box = {
				allPoints = TRP3_CompanionsProfilesAdd
			},
			button = {
				x = 0, y = 15, anchor = "CENTER",
				text = loc.PR_CO_PROFILE_HELP2,
				textWidth = 400,
				arrow = "DOWN"
			},
		}
	};
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	constructTutorialStructure();

	Events.listenToEvent(Events.REGISTER_PROFILE_DELETED, function(profileID)
		if profileID and isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
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
		tutorialProvider = function() return TUTORIAL_STRUCTURE; end,
	});

	-- UI
	handleMouseWheel(TRP3_CompanionsProfilesList, TRP3_CompanionsProfilesListSlider);
	TRP3_CompanionsProfilesListSlider:SetValue(0);
	local widgetTab = {};
	for i=1,5 do
		local widget = _G["TRP3_CompanionsProfilesListLine"..i];
		widget:SetScript("OnMouseUp",function ()
			if IsShiftKeyDown() then
				TRP3_API.ChatLinks:OpenMakeImportablePrompt(loc.CL_COMPANION_PROFILE, function(canBeImported)
					TRP3_API.CompanionProfileChatLinksModule:InsertLink(widget.profileID, canBeImported)
				end);
			else
				onOpenProfile(widget);
				playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			end
		end);
		_G[widget:GetName().."Action"]:SetScript("OnClick", onActionClicked);
		_G[widget:GetName().."Bound"]:SetText(loc.REG_COMPANION_BOUNDS);
		_G[widget:GetName().."Bound"]:Show();
		_G[widget:GetName().."Bound"]:SetScript("OnClick", onBoundClicked);
		tinsert(widgetTab, widget);


		Ellyb.Tooltips.getTooltip(_G[widget:GetName().."Action"])
			:SetAnchor(Ellyb.Tooltips.ANCHORS.TOP)
			:SetTitle(loc.PR_PROFILEMANAGER_ACTIONS);

		-- Display indications in the tooltip on how to create a chat link
		Ellyb.Tooltips.getTooltip(widget)
			:AddLine(Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.CM_OPEN))
			:AddLine(
				Ellyb.Strings.clickInstruction(
						Ellyb.System:FormatKeyboardShortcut(Ellyb.System.MODIFIERS.SHIFT, Ellyb.System.CLICKS.CLICK),
						loc.CL_TOOLTIP
				)
		)
	end
	TRP3_CompanionsProfilesList.widgetTab = widgetTab;
	TRP3_CompanionsProfilesList.decorate = decorateProfileList;
	TRP3_CompanionsProfilesAdd:SetScript("OnClick", uiCreateProfile);

	--Localization
	TRP3_CompanionsProfilesAdd:SetText(loc.PR_CREATE_PROFILE);
	TRP3_CompanionsProfilesListEmpty:SetText(loc.PR_CO_EMPTY);

	local frame = CreateFrame("Frame", "TRP3_CompanionsProfilesTabBar", TRP3_CompanionsProfiles);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, 0);
	frame:SetFrameLevel(1);

	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
		{
			{loc.PR_CO_PROFILEMANAGER_TITLE, 1, 175},
		},
		function(_, value)
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
		-- Target bar button for pets
		TRP3_API.target.registerButton({
			id = "bb_companion_profile",
			configText = loc.REG_COMPANION_TF_PROFILE,
			condition = function(targetType, unitID)
				if isTargetTypeACompanion(targetType) then
					local ownerID = companionIDToInfo(unitID);
					return ownerID == Globals.player_id or companionHasProfile(unitID);
				end
			end,
			onClick = companionProfileSelectionList,
			alertIcon = "Interface\\GossipFrame\\AvailableQuestIcon",
			adapter = function(buttonStructure, unitID)
				local ownerID, companionID = companionIDToInfo(unitID);
				local profile = getCompanionInfo(ownerID, companionID, unitID);
				buttonStructure.alert = nil;
				buttonStructure.tooltip = loc.TF_OPEN_COMPANION;
				buttonStructure.tooltipSub = nil;
				if ownerID == Globals.player_id then
					if profile then
						buttonStructure.tooltip = loc.PR_PROFILE .. ": |cff00ff00" .. profile.profileName;
						if profile.data and profile.data.IC then
							buttonStructure.icon = profile.data.IC;
						end
					else
						buttonStructure.icon = Globals.is_classic and "INV_Misc_Gear_01" or "icon_petfamily_mechanical";
						buttonStructure.tooltip = loc.REG_COMPANION_TF_NO;
					end
				else
					if profile and profile.data and profile.data.IC then
						buttonStructure.icon = profile.data.IC;
					else
						buttonStructure.icon = Globals.icons.unknown;
					end
					if profile and profile.data and profile.data.read == false then
						buttonStructure.tooltipSub = loc.REG_TT_NOTIF;
						buttonStructure.alert = true;
					end
				end
			end,
		});

		-- Target bar button for mounts
		TRP3_API.target.registerButton({
			id = "bb_companion_profile_mount",
			configText = loc.REG_COMPANION_TF_PROFILE_MOUNT,
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(_, unitID)
				if unitID == Globals.player_id then
					return getCurrentMountSpellID() ~= nil;
				end
				local _, profileID = TRP3_API.companions.register.getUnitMount(unitID, "target");
				return profileID ~= nil;
			end,
			onClick = companionProfileSelectionList,
			alertIcon = "Interface\\GossipFrame\\AvailableQuestIcon",
			adapter = function(buttonStructure, unitID)
				buttonStructure.tooltip = loc.TF_OPEN_MOUNT;
				buttonStructure.alert = nil;
				buttonStructure.tooltipSub = nil;
				if unitID == Globals.player_id then
					local profile = getCurrentMountProfile();
					buttonStructure.tooltipSub = "|cffffff00" .. loc.CM_CLICK .. ": |r" .. loc.PR_PROFILEMANAGER_ACTIONS;
					if profile then
						if profile and profile.data and profile.data.NA then
							buttonStructure.tooltip = loc.PR_CO_MOUNT .. ": |cff00ff00" .. profile.data.NA;
						else
							buttonStructure.tooltip = loc.PR_CO_MOUNT .. ": |cff00ff00" .. profile.profileName;
						end
						if profile and profile.data and profile.data.IC then
							buttonStructure.icon = profile.data.IC;
						else
							buttonStructure.icon = Globals.icons.unknown;
						end
					else
						buttonStructure.icon = "ability_mount_charger";
						buttonStructure.tooltipSub = "|cffffff00" .. loc.CM_CLICK .. ": |r" .. loc.REG_COMPANION_TF_BOUND_TO;
						buttonStructure.tooltip = loc.PR_CO_MOUNT;
					end
				else
					local companionFullID = TRP3_API.companions.register.getUnitMount(unitID, "target");
					local profile = getCompanionRegisterProfile(companionFullID);
					buttonStructure.tooltipSub = "|cffffff00" .. loc.CM_CLICK .. ": |r" .. loc.TF_OPEN_MOUNT;
					if profile and profile.data and profile.data.NA then
						buttonStructure.tooltip = loc.PR_CO_MOUNT .. ": |cff00ff00" .. profile.data.NA;
					else
						buttonStructure.tooltip = loc.PR_CO_MOUNT;
					end
					if profile and profile.data and profile.data.IC then
						buttonStructure.icon = profile.data.IC;
					else
						buttonStructure.icon = Globals.icons.unknown;
					end
					if profile and profile.data and profile.data.read == false then
						buttonStructure.tooltipSub = "|cff00ff00" .. loc.REG_TT_NOTIF .. "\n" .. buttonStructure.tooltipSub;
						buttonStructure.alert = true;
					end
				end
			end,
		});
	end
end);
