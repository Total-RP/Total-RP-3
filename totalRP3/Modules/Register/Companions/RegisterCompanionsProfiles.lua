-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

-- imports
local Globals, loc, Utils, Events = TRP3_API.globals, TRP3_API.loc, TRP3_API.utils, TRP3_Addon.Events;
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
local EMPTY = Globals.empty;
local getCompanionProfile, getCompanionProfileID = TRP3_API.companions.player.getCompanionProfile, TRP3_API.companions.player.getCompanionProfileID;
local getCompanionProfiles = TRP3_API.companions.player.getProfiles;
local getCompanionRegisterProfile = TRP3_API.companions.register.getCompanionProfile;
local companionIDToInfo = Utils.str.companionIDToInfo;
local playUISound = TRP3_API.ui.misc.playUISound;
local isTargetTypeACompanion, companionHasProfile = TRP3_API.ui.misc.isTargetTypeACompanion, TRP3_API.companions.register.companionHasProfile;
local getCompanionNameFromSpellID = TRP3_API.companions.getCompanionNameFromSpellID;
local getCurrentMountSpellID, getCurrentMountProfile = TRP3_API.companions.player.getCurrentMountSpellID, TRP3_API.companions.player.getCurrentMountProfile;
local TRP3_Enums = AddOn_TotalRP3.Enums;

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
	if (targetType == TRP3_Enums.UNIT_TYPE.BATTLE_PET or targetType == TRP3_Enums.UNIT_TYPE.PET) and isMine then
		local companionFullID = TRP3_API.ui.misc.getCompanionFullID("target", targetType);
		local companionID = TRP3_API.ui.misc.getCompanionShortID("target", targetType);
		if companionFullID then
			ui_boundPlayerCompanion(companionID, profileID, targetType);
			return;
		end
	end
	TRP3_API.ui.tooltip.toast("|cffff0000" .. loc.REG_COMPANION_TARGET_NO, 4);
end

local function uiBindPetProfile(profileID)
	TRP3_API.popup.showPetBrowser(profileID, function(petInfo)
		ui_boundPlayerCompanion(petInfo.name, profileID, TRP3_Enums.UNIT_TYPE.PET);
	end);
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
	if companionType == TRP3_Enums.UNIT_TYPE.PET then
		return loc.PR_CO_PET;
	elseif companionType == TRP3_Enums.UNIT_TYPE.BATTLE_PET then
		return loc.PR_CO_BATTLE;
	elseif companionType == TRP3_Enums.UNIT_TYPE.MOUNT then
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

	setupIconButton(_G[widget:GetName().."Icon"], dataTab.IC or TRP3_InterfaceIcons.ProfileDefault);
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
	wipe(profileListID);
	local profiles = getProfiles();
	local profileSearch = Utils.str.emptyToNil(TRP3_CompanionsProfilesSearch:GetText());
	for profileID, _ in pairs(profiles) do
		if not profileSearch or string.find(profiles[profileID].profileName:lower(), profileSearch:lower(), 1, true) then
			tinsert(profileListID, profileID);
		end
	end

	local size = #profileListID;
	TRP3_CompanionsProfilesListEmpty:Hide();
	if size == 0 then
		if not profileSearch then
			TRP3_CompanionsProfilesListEmpty:SetText(loc.PR_CO_EMPTY);
		else
			TRP3_CompanionsProfilesListEmpty:SetText(loc.PR_PROFILEMANAGER_EMPTY);
		end
		TRP3_CompanionsProfilesListEmpty:Show();
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
		uiBoundProfile(profileID, TRP3_Enums.UNIT_TYPE.BATTLE_PET);
	elseif value == 5 then
		uiBoundProfile(profileID, TRP3_Enums.UNIT_TYPE.MOUNT);
	elseif value == 6 then
		uiBoundTargetProfile(profileID);
	elseif value == 7 then
		uiBindPetProfile(profileID);
	elseif value then
		uiUnboundTargetProfile(profileID, value);
	end
end

local function onBoundClicked(button)
	local profileID = button:GetParent().profileID;
	local profile = getCompanionProfiles()[profileID];

	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		local boundTab = description:CreateButton(loc.REG_COMPANION_BOUND_TO);
		if AddOn_TotalRP3.Ui.IsPetBrowserEnabled() then
			boundTab:CreateButton(loc.REG_COMPANION_BIND_TO_PET, function() onActionSelected(7, button); end);
		end
		boundTab:CreateButton(loc.PR_CO_BATTLE, function() onActionSelected(4, button); end);
		boundTab:CreateButton(loc.PR_CO_MOUNT, function() onActionSelected(5, button); end);
		boundTab:CreateButton(loc.REG_COMPANION_BOUND_TO_TARGET, function() onActionSelected(6, button); end);

		if profile.links and tsize(profile.links) > 0 then
			local linksTab = description:CreateButton(loc.REG_COMPANION_UNBOUND);
			for companionID, companionType in pairs(profile.links) do
				linksTab:CreateButton(getCompanionNameFromSpellID(companionID), function() onActionSelected(companionID .. "|" .. companionType, button); end);
			end
		end
	end);
end

local function onActionClicked(button)
	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		description:CreateButton(loc.PR_PROFILEMANAGER_RENAME, function() onActionSelected(2, button); end);
		description:CreateButton(loc.PR_DUPLICATE_PROFILE, function() onActionSelected(3, button); end);
		description:CreateButton("|cnRED_FONT_COLOR:" .. loc.PR_DELETE_PROFILE .. "|r", function() onActionSelected(1, button); end);
	end);
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
	if targetType == TRP3_Enums.UNIT_TYPE.PET and UnitName("pet") == companionID and PetCanBeAbandoned() then
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
	if targetType == TRP3_Enums.UNIT_TYPE.CHARACTER then
		targetType = TRP3_Enums.UNIT_TYPE.MOUNT;
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
	for profileID, profile in pairs(getProfiles()) do
		if getCompanionProfileID(companionID) == profileID then
			tinsert(list, {profile.profileName, nil});
		else
			tinsert(list, {profile.profileName, profileID});
		end
	end
	table.sort(list, function(a,b) return string.lower(a[1]) < string.lower(b[1]) end);
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

local function companionProfileSelectionList(unitID, targetType, buttonClick, button)
	local ownerID, companionID, companionFullID;

	if targetType == TRP3_Enums.UNIT_TYPE.CHARACTER then
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
		if buttonClick == "LeftButton" then
			if getCompanionProfile(companionID) then
				openProfile(getCompanionProfileID(companionID));
				openMainFrame();
			else
				createNewAndBound(companionID, targetType);
			end
		elseif buttonClick == "RightButton" then

			TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
				description:CreateTitle(loc.TB_SWITCH_PROFILE);

				if getCompanionProfile(companionID) then
					description:CreateButton(loc.REG_COMPANION_TF_OPEN, function() onCompanionProfileSelection(0, companionID, targetType); end);
					description:CreateButton(loc.REG_COMPANION_TF_UNBOUND, function() onCompanionProfileSelection(1, companionID, targetType); end);
				end
				description:CreateButton("|cnGREEN_FONT_COLOR:" .. loc.REG_COMPANION_TF_CREATE .. "|r", function() onCompanionProfileSelection(2, companionID, targetType); end);
				local profileList = getPlayerCompanionProfilesAsList(companionID);
				local profileButton = description:CreateButton( loc.REG_COMPANION_TF_BOUND_TO);
				for _, profile in ipairs(profileList) do
					-- Current profile has nil profileID (profile[2])
					if profile[2] then
						profileButton:CreateButton(profile[1], function() onCompanionProfileSelection(profile[2], companionID, targetType); end);
					else
						profileButton:CreateButton("|cnGREEN_FONT_COLOR:" .. profile[1] .. "|r"):SetEnabled(false);
					end
				end
			end);
		end
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

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOAD, function()
	constructTutorialStructure();

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_PROFILE_DELETED, function(_, profileID)
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
		_G[widget:GetName().."Action"]:SetScript("OnMouseDown", onActionClicked);
		_G[widget:GetName().."Bound"]:SetText(loc.REG_COMPANION_BOUNDS);
		_G[widget:GetName().."Bound"]:Show();
		_G[widget:GetName().."Bound"]:SetScript("OnMouseDown", onBoundClicked);
		tinsert(widgetTab, widget);


		setTooltipForSameFrame(_G[widget:GetName().."Action"], "TOP", 0, 5, loc.CM_OPTIONS, TRP3_API.FormatShortcutWithInstruction("CLICK", loc.CM_OPTIONS_ADDITIONAL));

		-- Display indications in the tooltip on how to create a chat link
		Ellyb.Tooltips.getTooltip(widget)
			:AddLine(TRP3_API.FormatShortcutWithInstruction("CLICK", loc.CM_OPEN))
			:AddLine(TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.CL_TOOLTIP));
	end
	TRP3_CompanionsProfilesList.widgetTab = widgetTab;
	TRP3_CompanionsProfilesList.decorate = decorateProfileList;
	TRP3_CompanionsProfilesAdd:SetScript("OnClick", uiCreateProfile);

	--Localization
	TRP3_CompanionsProfilesAdd:SetText(loc.PR_CREATE_PROFILE);
	TRP3_CompanionsProfilesListEmpty:SetText(loc.PR_CO_EMPTY);

	TRP3_CompanionsProfilesSearch:SetScript("OnEnterPressed", uiInitProfileList);
	TRP3_CompanionsProfilesSearchText:SetText(loc.PR_PROFILEMANAGER_SEARCH_PROFILE);

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

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()

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
			onMouseDown = companionProfileSelectionList,
			alertIcon = "Interface\\GossipFrame\\AvailableQuestIcon",
			adapter = function(buttonStructure, unitID)
				-- Initialize the buttonStructure parts.
				buttonStructure.alert = false;
				buttonStructure.icon = TRP3_InterfaceIcons.TargetOpenCompanion;
				buttonStructure.tooltip = loc.REG_COMPANION;
				buttonStructure.tooltipSub = loc.REG_COMPANION_TF_NO;

				local ownerID, companionID = companionIDToInfo(unitID);
				local profile = getCompanionInfo(ownerID, companionID, unitID);

				-- Check if the pet has a profile first.
				if profile and profile.data then
					-- Retrieve profile name.
					local name = profile.data.NA or "";

					-- Handle if player is the owner of this pet.
					if ownerID == Globals.player_id then
						buttonStructure.tooltipSub = name .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.TF_OPEN_COMPANION) .. "\n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.TF_MORE_OPTIONS);
					else
						-- If pet data is unread, add alert.
						if not profile.data.read then
							buttonStructure.tooltipSub = name .. "\n\n" .. TRP3_MarkupUtil.GenerateAtlasMarkup("QuestNormal", { size = 16 }) .. "|cnGREEN_FONT_COLOR:" .. loc.REG_TT_NOTIF .. "|r\n\n" .. TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_COMPANION) .. "|r";
							buttonStructure.alert = true;
						else
							buttonStructure.tooltipSub = name .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_COMPANION);
						end
					end
				else
					-- Handle if player is the owner of this pet.
					if ownerID == Globals.player_id then
						buttonStructure.tooltipSub = buttonStructure.tooltipSub .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_COMPANION_TF_CREATE) .. "\n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.TF_MORE_OPTIONS);
					end
				end
			end,
		});

		TRP3_API.target.registerButton({
			id = "bb_companion_profile_speech",
			configText = loc.REG_COMPANION_TF_PROFILE_SPEECH,
			icon = TRP3_InterfaceIcons.ToolbarNPCTalk;
			condition = function(targetType, unitID)
				if isTargetTypeACompanion(targetType) then
					local ownerID, companionID = companionIDToInfo(unitID);
					return ownerID == Globals.player_id and getCompanionInfo(ownerID, companionID, unitID);
				end
			end,
			tooltip = loc.REG_COMPANION_TF_PROFILE_SPEECH,
			tooltipSub = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.REG_COMPANION_TF_PROFILE_SPEECH_TT),
			onClick = function(unitID)
				local ownerID, companionID = companionIDToInfo(unitID);
				local profile = getCompanionInfo(ownerID, companionID, unitID);

				-- Check if the pet has a profile first (always true here).
				if profile and profile.data then
					-- Retrieve profile name.
					local name = profile.data.NA;
					TRP3_API.r.toggleNPCTalkFrame(name);
				end
			end,
		});

		-- Target bar button for mounts
		TRP3_API.target.registerButton({
			id = "bb_companion_profile_mount",
			configText = loc.REG_COMPANION_TF_PROFILE_MOUNT,
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, unitID)
				if unitID == Globals.player_id then
					return getCurrentMountSpellID() ~= nil;
				end
				local _, profileID = TRP3_API.companions.register.getUnitMount(unitID, "target");
				return profileID ~= nil;
			end,
			onMouseDown = companionProfileSelectionList,
			alertIcon = "Interface\\GossipFrame\\AvailableQuestIcon",
			adapter = function(buttonStructure, unitID)
				-- Initialize the buttonStructure parts.
				buttonStructure.alert = false;
				buttonStructure.icon = TRP3_InterfaceIcons.TargetOpenMount;
				buttonStructure.tooltip = loc.PR_CO_MOUNT;
				buttonStructure.tooltipSub = loc.REG_COMPANION_TF_NO;

				-- Retrieve the mount profile first.
				local profile;
				if unitID == Globals.player_id then
					profile = getCurrentMountProfile();
				else
					local companionFullID = TRP3_API.companions.register.getUnitMount(unitID, "target");
					profile = getCompanionRegisterProfile(companionFullID);
				end

				-- Check if the mount has a profile first.
				if profile and profile.data then
					-- Retrieve profile name.
					local name = profile.data.NA or "";

					-- Handle if player is the owner of this mount.
					if unitID == Globals.player_id then
						buttonStructure.tooltipSub = name .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.TF_OPEN_MOUNT) .. "\n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.TF_MORE_OPTIONS);
					else
						-- If mount data is unread, add alert.
						if not profile.data.read then
							buttonStructure.tooltipSub = name .. "\n\n" .. TRP3_MarkupUtil.GenerateAtlasMarkup("QuestNormal", { size = 16 }) .. "|cnGREEN_FONT_COLOR:" .. loc.REG_TT_NOTIF .. "|r\n\n" .. TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_MOUNT) .. "|r";
							buttonStructure.alert = true;
						else
							buttonStructure.tooltipSub = name .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_MOUNT);
						end
					end
				else
					-- Handle if player is the owner of this mount.
					if unitID == Globals.player_id then
						buttonStructure.tooltipSub = buttonStructure.tooltipSub .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_COMPANION_TF_CREATE) .. "\n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.TF_MORE_OPTIONS);
					end
				end
			end,
		});
	end
end);
