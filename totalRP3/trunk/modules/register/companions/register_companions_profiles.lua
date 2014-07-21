--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Pets/mounts managements : Profile list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, loc, Utils, Events = TRP3_API.globals, TRP3_API.locale.getText, TRP3_API.utils, TRP3_API.events;
local tinsert, _G, pairs = tinsert, _G, pairs;
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
local dupplicateProfile = TRP3_API.companions.player.dupplicateProfile;
local editProfile = TRP3_API.companions.player.editProfile;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local TRP3_CompanionsProfilesList, TRP3_CompanionsProfilesListSlider, TRP3_CompanionsProfilesListEmpty = TRP3_CompanionsProfilesList, TRP3_CompanionsProfilesListSlider, TRP3_CompanionsProfilesListEmpty;

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
			onSelected = function() setPage(TRP3_API.navigation.page.id.COMPANIONS_PAGE, {profile = profile, profileID = profileID}) end,
			isChildOf = TRP3_API.navigation.menu.id.COMPANIONS_MAIN,
			closeable = true,
		});
		selectMenu(currentlyOpenedProfilePrefix .. profileID);
	end
end

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

local function uiDupplicateProfile(profileID)
	local profile = getProfiles()[profileID];
	showTextInputPopup(
	loc("PR_PROFILEMANAGER_DUPP_POPUP"):format(Utils.str.color("g").. profile.profileName .. "|r"),
		function(newName)
			if newName and #newName ~= 0 then
				if not uiCheckNameAvailability(newName) then return end
				local profileID = dupplicateProfile(profile, newName);
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

local function decorateProfileList(widget, id)
	widget.profileID = id;
	local profile = getProfiles()[id];
	local dataTab = profile.data or {};
	local mainText = profile.profileName;

	setupIconButton(_G[widget:GetName().."Icon"], dataTab.IC or Globals.icons.profile_default);
	_G[widget:GetName().."Name"]:SetText(mainText);

	local listText = "";
	local i = 0;
--	for characterID, characterInfo in pairs(characters) do
--		if characterInfo.profileID == id then
--			local charactName, charactRealm = unitIDToInfo(characterID);
--			listText = listText.."- |cff00ff00"..charactName.." ( "..charactRealm.." )|r\n";
--			i = i + 1;
--		end
--	end
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
		uiDupplicateProfile(profileID);
	end
end

local function onActionClicked(button)
	local profileID = button:GetParent().profileID;
	local values = {};
	tinsert(values, {loc("PR_DELETE_PROFILE"), 1});
	tinsert(values, {loc("PR_PROFILEMANAGER_RENAME"), 2});
	tinsert(values, {loc("PR_DUPPLICATE_PROFILE"), 3});
	displayDropDown(button, values, onActionSelected, 0, true);
end

local function onOpenProfile(button)
	openProfile(button:GetParent().profileID);
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
	
	registerPage({
		id = TRP3_API.navigation.page.id.COMPANIONS_PROFILES,
		frame = TRP3_CompanionsProfiles,
		onPagePostShow = function(context)
			onPageShow(context);
		end,
	});
	
	-- UI
	handleMouseWheel(TRP3_CompanionsProfilesList, TRP3_CompanionsProfilesListSlider);
	TRP3_CompanionsProfilesListSlider:SetValue(0);
	local widgetTab = {};
	for i=1,5 do
		local widget = _G["TRP3_CompanionsProfilesListLine"..i];
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
	TRP3_CompanionsProfilesTitle:SetText(Utils.str.color("w")..loc("PR_CO_PROFILEMANAGER_TITLE"));
	TRP3_CompanionsProfilesAdd:SetText(loc("PR_CREATE_PROFILE"));
	TRP3_CompanionsProfilesListEmpty:SetText(loc("PR_CO_EMPTY"));
	
end);