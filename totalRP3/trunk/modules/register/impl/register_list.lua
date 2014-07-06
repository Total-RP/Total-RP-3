--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Character list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, Events = TRP3_API.globals, TRP3_API.events;
local Utils = TRP3_API.utils;
local stEtN = Utils.str.emptyToNil;
local loc = TRP3_API.locale.getText;
local get = TRP3_API.profile.getData;
local assert, table, _G, date, pairs, error, tinsert, wipe, time = assert, table, _G, date, pairs, error, tinsert, wipe, time;
local isUnitIDKnown, getCharacterList = TRP3_API.register.isUnitIDKnown, TRP3_API.register.getCharacterList;
local unitIDToInfo, tsize = Utils.str.unitIDToInfo, Utils.table.size;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local getUnitTexture = TRP3_API.ui.misc.getUnitTexture;
local getClassTexture = TRP3_API.ui.misc.getClassTexture;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local isMenuRegistered = TRP3_API.navigation.menu.isMenuRegistered;
local registerMenu, selectMenu, openMainFrame = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu, TRP3_API.navigation.openMainFrame;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local getUnitIDCharacter = TRP3_API.register.getUnitIDCharacter;
local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
local hasProfile = TRP3_API.register.hasProfile;
local getCompleteName, getPlayerCompleteName = TRP3_API.register.getCompleteName, TRP3_API.register.getPlayerCompleteName;
local TRP3_RegisterListEmpty = TRP3_RegisterListEmpty;
local getProfile, getProfileList = TRP3_API.register.getProfile, TRP3_API.register.getProfileList;
local getIgnoredList, unignoreID, isIDIgnored = TRP3_API.register.getIgnoredList, TRP3_API.register.unignoreID, TRP3_API.register.isIDIgnored;
local getRelationText, getRelationTooltipText = TRP3_API.register.relation.getRelationText, TRP3_API.register.relation.getRelationTooltipText;
local unregisterMenu = TRP3_API.navigation.menu.unregisterMenu;
local displayDropDown, showAlertPopup, showConfirmPopup = TRP3_API.ui.listbox.displayDropDown, TRP3_API.popup.showAlertPopup, TRP3_API.popup.showConfirmPopup;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local deleteProfile, deleteCharacter, getProfileList = TRP3_API.register.deleteProfile, TRP3_API.register.deleteCharacter, TRP3_API.register.getProfileList;
local toast = TRP3_API.ui.tooltip.toast;
local ignoreID = TRP3_API.register.ignoreID;
local refreshList;
local NOTIFICATION_ID_NEW_CHARACTER = TRP3_API.register.NOTIFICATION_ID_NEW_CHARACTER;
local getCurrentPageID = TRP3_API.navigation.page.getCurrentPageID;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTER_LIST_PAGEID = "register_list";
local playerMenu = "main_10_player";
local currentlyOpenedProfilePrefix = TRP3_API.register.MENU_LIST_ID_TAB;
local REGISTER_PAGE = TRP3_API.register.MENU_LIST_ID;

local function openPage(profileID)
	local profile = getProfile(profileID);
	if isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
		-- If the character already has his "tab", simply open it
		selectMenu(currentlyOpenedProfilePrefix .. profileID);
	else
		-- Else, create a new menu entry and open it.
		local tabText = UNKNOWN;
		if profile.characteristics and profile.characteristics.FN then
			tabText = profile.characteristics.FN;
		end
		registerMenu({
			id = currentlyOpenedProfilePrefix .. profileID,
			text = tabText,
			onSelected = function() setPage("player_main", {profile = profile, profileID = profileID}) end,
			isChildOf = REGISTER_PAGE,
			closeable = true,
		});
		selectMenu(currentlyOpenedProfilePrefix .. profileID);
	end
end

local function openPageByUnitID(unitID)
	if unitID == Globals.player_id then
		selectMenu(playerMenu);
	elseif isUnitIDKnown(unitID) and hasProfile(unitID) then
		openPage(hasProfile(unitID));
	end
end


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MODE_CHARACTER, MODE_PETS, MODE_IGNORE = 1, 2, 3;
local selectedIDs = {};
local ICON_SIZE = 30;
local currentMode = 1;
local DATE_FORMAT = "%d/%m/%y %H:%M";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : CHARACTERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateCharacterLine(line, profileID)
	local profile = getProfile(profileID);
	line.id = profileID;

	local name = getCompleteName(profile.characteristics or {}, UNKNOWN, true);
	local tooltip, secondLine = name, "";

	_G[line:GetName().."Name"]:SetText(name);
	if profile.characteristics and profile.characteristics.IC then
		tooltip = Utils.str.icon(profile.characteristics.IC, ICON_SIZE) .. " " .. name;
	end

	_G[line:GetName().."Info2"]:SetText("");
	if profile.link and tsize(profile.link) > 0 then
		secondLine = secondLine .. loc("REG_LIST_CHAR_TT_CHAR");
		local atLeastOneIgnored = false;
		for unitID, _ in pairs(profile.link) do
			local unitName, unitRealm = unitIDToInfo(unitID);
			if isIDIgnored(unitID) then
				secondLine = secondLine .. "\n|cffff0000 - " .. unitName .. " ( " .. unitRealm .. " ) - " .. loc("REG_LIST_CHAR_IGNORED");
				atLeastOneIgnored = true;
			else
				secondLine = secondLine .. "\n|cff00ff00 - " .. unitName .. " ( " .. unitRealm .. " )";
			end
		end
		if atLeastOneIgnored then
			_G[line:GetName().."Info2"]:SetText("|cffff0000" .. loc("REG_LIST_CHAR_IGNORED"));
		end
	else
		secondLine = secondLine .. "|cffffff00" .. loc("REG_LIST_CHAR_TT_CHAR_NO");
	end

	if profile.time and profile.zone then
		local formatDate = date(DATE_FORMAT, profile.time);
		secondLine = secondLine .. "\n|r" .. loc("REG_LIST_CHAR_TT_DATE"):format(formatDate, profile.zone);
	end

	secondLine = secondLine .. "\n\n|r" .. loc("REG_LIST_CHAR_TT_RELATION"):format(getRelationTooltipText(profileID, profile));

	setTooltipForSameFrame(_G[line:GetName().."Click"], "TOPLEFT", 0, 5, tooltip, loc("REG_LIST_CHAR_TT"):format(secondLine));

	_G[line:GetName().."Select"]:SetChecked(selectedIDs[profileID]);
	_G[line:GetName().."Select"]:Show();

	local relation = getRelationText(profileID);
	_G[line:GetName().."Info"]:SetText(relation);

end

local function getCharacterLines()
	local nameSearch = TRP3_RegisterListFilterCharactName:GetText():lower();
	local guildSearch = TRP3_RegisterListFilterCharactGuild:GetText():lower();
	local realmOnly = TRP3_RegisterListFilterCharactRealm:GetChecked();
	local fullSize = tsize(getProfileList());
	local lines = {};

	for profileID, profile in pairs(getProfileList()) do
		local nameIsConform, guildIsConform, realmIsConform = false, false, false;

		-- Defines if at least one character is conform to the search criteria
		for unitID, _ in pairs(profile.link) do
			local unitName, unitRealm = unitIDToInfo(unitID);
			if unitName:lower():find(nameSearch) then
				nameIsConform = true;
			end
			if unitRealm == Globals.player_realm_id then
				realmIsConform = true;
			end
			local character = getUnitIDCharacter(unitID);
			if character.guild and character.guild:lower():find(guildSearch) then
				guildIsConform = true;
			end
		end
		if not nameIsConform and (getCompleteName(profile.characteristics or {}, "", true):lower():find(nameSearch)) then
			nameIsConform = true;
		end

		nameIsConform = nameIsConform or nameSearch:len() == 0;
		guildIsConform = guildIsConform or guildSearch:len() == 0;
		realmIsConform = realmIsConform or not realmOnly;

		if nameIsConform and guildIsConform and realmIsConform then
			lines[profileID] = profile;
		end
	end

	local lineSize = tsize(lines);
	if lineSize == 0 then
		if fullSize == 0 then
			TRP3_RegisterListEmpty:SetText(loc("REG_LIST_CHAR_EMPTY"));
		else
			TRP3_RegisterListEmpty:SetText(loc("REG_LIST_CHAR_EMPTY2"));
		end
	end
	setupFieldSet(TRP3_RegisterListCharactFilter, loc("REG_LIST_CHAR_FILTER"):format(lineSize, fullSize), 200);
	
	TRP3_RegisterListHeaderName:SetText(loc("REG_PLAYER"));
	TRP3_RegisterListHeaderInfo:SetText(loc("REG_RELATION"));
	TRP3_RegisterListHeaderInfo2:SetText(loc("REG_LIST_FLAGS"));
	TRP3_RegisterListHeaderActions:Show();

	return lines;
end

local MONTH_IN_SECONDS = 2592000;

local function onActionSelected(value, button)
	-- PURGES
	if value == "purge_time" then
		local profiles = getProfileList();
		local profilesToPurge = {};
		for profileID, profile in pairs(profiles) do
			if profile.time and time() - profile.time > MONTH_IN_SECONDS then
				tinsert(profilesToPurge, profileID);
			end
		end
		if #profilesToPurge == 0 then
			showAlertPopup(loc("REG_LIST_ACTIONS_PURGE_TIME_C"):format(loc("REG_LIST_ACTIONS_PURGE_EMPTY")));
		else
			showConfirmPopup(loc("REG_LIST_ACTIONS_PURGE_TIME_C"):format(loc("REG_LIST_ACTIONS_PURGE_COUNT"):format(#profilesToPurge)), function()
				for _, profileID in pairs(profilesToPurge) do
					deleteProfile(profileID);
				end
				refreshList();
			end);
		end
	elseif value == "purge_unlinked" then
		local profiles = getProfileList();
		local profilesToPurge = {};
		for profileID, profile in pairs(profiles) do
			if not profile.link or tsize(profile.link) == 0 then
				tinsert(profilesToPurge, profileID);
			end
		end
		if #profilesToPurge == 0 then
			showAlertPopup(loc("REG_LIST_ACTIONS_PURGE_UNLINKED_C"):format(loc("REG_LIST_ACTIONS_PURGE_EMPTY")));
		else
			showConfirmPopup(loc("REG_LIST_ACTIONS_PURGE_UNLINKED_C"):format(loc("REG_LIST_ACTIONS_PURGE_COUNT"):format(#profilesToPurge)), function()
				for _, profileID in pairs(profilesToPurge) do
					deleteProfile(profileID);
				end
				refreshList();
			end);
		end
	elseif value == "purge_ignore" then
		local profilesToPurge, characterToPurge = TRP3_API.register.getIDsToPurge();
		if #profilesToPurge + #characterToPurge == 0 then
			showAlertPopup(loc("REG_LIST_ACTIONS_PURGE_IGNORE_C"):format(loc("REG_LIST_ACTIONS_PURGE_EMPTY")));
		else
			showConfirmPopup(loc("REG_LIST_ACTIONS_PURGE_IGNORE_C"):format(loc("REG_LIST_ACTIONS_PURGE_COUNT"):format(#profilesToPurge + #characterToPurge)), function()
				for _, profileID in pairs(profilesToPurge) do
					deleteProfile(profileID);
				end
				for _, unitID in pairs(characterToPurge) do
					deleteCharacter(unitID);
				end
				refreshList();
			end);
		end
	-- Mass actions
	elseif value == "actions_delete" then
		showConfirmPopup(loc("REG_LIST_ACTIONS_MASS_REMOVE_C"):format(tsize(selectedIDs)), function()
			for profileID, _ in pairs(selectedIDs) do
				deleteProfile(profileID);
			end
			refreshList();
		end);
	elseif value == "actions_ignore" then
		local charactToIgnore = {};
		for profileID, _ in pairs(selectedIDs) do
			for unitID, _ in pairs(getProfile(profileID).link or Globals.empty) do
				charactToIgnore[unitID] = true;
			end
		end
		showTextInputPopup(loc("REG_LIST_ACTIONS_MASS_IGNORE_C"):format(tsize(charactToIgnore)), function(text)
			for unitID, _ in pairs(charactToIgnore) do
				ignoreID(unitID, text);
			end
			refreshList();
		end);
	end
end

local function onActions(self)
	local values = {};
	tinsert(values, {loc("REG_LIST_ACTIONS_PURGE"), {
		{loc("REG_LIST_ACTIONS_PURGE_TIME"), "purge_time"},
		{loc("REG_LIST_ACTIONS_PURGE_UNLINKED"), "purge_unlinked"},
		{loc("REG_LIST_ACTIONS_PURGE_IGNORE"), "purge_ignore"},
	}});
	if tsize(selectedIDs) > 0 then
		tinsert(values, {loc("REG_LIST_ACTIONS_MASS"):format(tsize(selectedIDs)), {
			{loc("REG_LIST_ACTIONS_MASS_REMOVE"), "actions_delete"},
			{loc("REG_LIST_ACTIONS_MASS_IGNORE"), "actions_ignore"},
		}});
	end
	displayDropDown(self, values, onActionSelected, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : COMPANIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateCompanionLine(line, profileID)
	_G[line:GetName().."Select"]:Show();
end

local function getCompanionLines()
	TRP3_RegisterListEmpty:SetText(loc("REG_LIST_PETS_EMPTY"));
	TRP3_RegisterListHeaderName:SetText(loc("REG_COMPANION"));
	TRP3_RegisterListHeaderInfo:SetText("");
	TRP3_RegisterListHeaderInfo2:SetText("");
	
	return {};
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : IGNORED
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateIgnoredLine(line, unitID)
	line.id = unitID;
	_G[line:GetName().."Name"]:SetText(unitID);
	_G[line:GetName().."Info"]:SetText("");
	_G[line:GetName().."Info2"]:SetText("");
	_G[line:GetName().."Select"]:Hide();
	setTooltipForSameFrame(_G[line:GetName().."Click"], "TOPLEFT", 0, 5, unitID, loc("REG_LIST_IGNORE_TT"):format(getIgnoredList()[unitID]));
end

local function getIgnoredLines()
	if tsize(getIgnoredList()) == 0 then
		TRP3_RegisterListEmpty:SetText(loc("REG_LIST_IGNORE_EMPTY"));
	end
	TRP3_RegisterListHeaderName:SetText(loc("REG_PLAYER"));
	TRP3_RegisterListHeaderInfo:SetText("");
	TRP3_RegisterListHeaderInfo2:SetText("");
	
	return getIgnoredList();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : LIST
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function refreshList()
	local lines;
	TRP3_RegisterListEmpty:Hide();
	TRP3_RegisterListHeaderActions:Hide();

	if currentMode == MODE_CHARACTER then
		lines = getCharacterLines();
		TRP3_RegisterList.decorate = decorateCharacterLine;
	elseif currentMode == MODE_PETS then
		lines = getCompanionLines();
		TRP3_RegisterList.decorate = decorateCompanionLine;
	elseif currentMode == MODE_IGNORE then
		lines = getIgnoredLines();
		TRP3_RegisterList.decorate = decorateIgnoredLine;
	end

	if tsize(lines) == 0 then
		TRP3_RegisterListEmpty:Show();
	end
	initList(TRP3_RegisterList, lines, TRP3_RegisterListSlider);
end

local function onLineDClicked(self, button)
	if currentMode == MODE_CHARACTER then
		assert(self:GetParent().id, "No profileID on line.");
		openPage(self:GetParent().id);
	elseif currentMode == MODE_IGNORE then
		assert(self:GetParent().id, "No unitID on line.");
		unignoreID(self:GetParent().id);
		refreshList();
	end
end

local function onLineSelected(self, button)
	assert(self:GetParent().id, "No id on line.");
	selectedIDs[self:GetParent().id] = self:GetChecked();
end

local function changeMode(tabWidget, value)
	currentMode = value;
	wipe(selectedIDs);
	TRP3_RegisterListCharactFilter:Hide();
	if currentMode == MODE_CHARACTER then
		TRP3_RegisterListCharactFilter:Show();
	end
	refreshList();
	Events.fireEvent(Events.NAVIGATION_TUTORIAL_REFRESH, REGISTER_LIST_PAGEID);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabGroup;

local function createTabBar()
	local frame = CreateFrame("Frame", "TRP3_RegisterMainTabBar", TRP3_RegisterList);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, -5);
	frame:SetFrameLevel(1);
	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
	{
		{loc("REG_LIST_CHAR_TITLE"), 1, 150},
		{loc("REG_LIST_PETS_TITLE"), 2, 150},
		{loc("REG_LIST_IGNORE_TITLE"), 3, 150},
	},
	changeMode
	);
	tabGroup:SelectTab(1);
end

local TUTORIAL_CHARACTER = {
	{
		box = {
			x = 20, y = -45, anchor = "TOPLEFT", width = 28, height = 340
		},
		button = {
			x = 0, y = 0, anchor = "CENTER",
			text = loc("REG_LIST_CHAR_TUTO_ACTIONS"),
			arrow = "LEFT"
		}
	},
	{
		box = {
			x = 50, y = -45, anchor = "TOPLEFT", width = 470, height = 340
		},
		button = {
			x = 0, y = 0, anchor = "CENTER",
			text = loc("REG_LIST_CHAR_TUTO_LIST"),
			textWidth = 400,
			arrow = "DOWN"
		}
	},
	{
		box = {
			x = 20, y = -387, anchor = "TOPLEFT", width = 500, height = 60
		},
		button = {
			x = 0, y = 10, anchor = "CENTER",
			text = loc("REG_LIST_CHAR_TUTO_FILTER"),
			textWidth = 400,
			arrow = "UP"
		}
	},
}

local function tutorialProvider()
	if currentMode == MODE_CHARACTER then
		return TUTORIAL_CHARACTER;
	end
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	-- Notification
	TRP3_API.dashboard.registerNotificationType({
		id = NOTIFICATION_ID_NEW_CHARACTER,
		callback = function(profileID)
			if getProfileList()[profileID] then
				openPage(profileID);
			else
				toast(loc("REG_LIST_NOTIF_ADD_NOT"));
			end
		end,
		removeOnShown = true,
		configText = loc("REG_LIST_NOTIF_ADD_CONFIG"),
	});
	
	-- To try, but I'm afraid for performances ...
	TRP3_API.events.listenToEvent(Events.REGISTER_DATA_CHANGED, function()
		if getCurrentPageID() == REGISTER_LIST_PAGEID then
			refreshList();
		end
	end);

	registerMenu({
		id = REGISTER_PAGE,
		text = loc("REG_REGISTER"),
		onSelected = function() setPage(REGISTER_LIST_PAGEID); end,
	});

	registerPage({
		id = REGISTER_LIST_PAGEID,
		templateName = "TRP3_RegisterList",
		frameName = "TRP3_RegisterList",
		frame = TRP3_RegisterList,
		onPagePostShow = function() tabGroup:SelectTab(1); end,
		tutorialProvider = tutorialProvider,
	});

	TRP3_API.target.registerButton({
		id = "aa_page_player",
		configText = loc("TF_OPEN_CHARACTER"),
		condition = function(unitID, targetInfo)
			return unitID == Globals.player_id or (isUnitIDKnown(unitID) and hasProfile(unitID));
		end,
		onClick = function(unitID)
			openMainFrame();
			openPageByUnitID(unitID);
		end,
		adapter = function(buttonStructure, unitID, targetInfo)
			buttonStructure.tooltip = loc("TF_OPEN_CHARACTER");
			buttonStructure.tooltipSub = nil;
			buttonStructure.alert = nil;
			if unitID ~= Globals.player_id and hasProfile(unitID) then
				local profile = getUnitIDProfile(unitID);
				if profile.about and not profile.about.read then
					buttonStructure.tooltipSub = loc("REG_TT_NOTIF");
					buttonStructure.alert = true;
				end
			end
		end,
		alertIcon = "Interface\\GossipFrame\\AvailableQuestIcon",
		icon = "inv_inscription_scroll"
	});

	TRP3_RegisterListSlider:SetValue(0);
	handleMouseWheel(TRP3_RegisterListContainer, TRP3_RegisterListSlider);
	local widgetTab = {};
	for i=1,14 do
		local widget = _G["TRP3_RegisterListLine"..i];
		local widgetClick = _G["TRP3_RegisterListLine"..i.."Click"];
		local widgetSelect = _G["TRP3_RegisterListLine"..i.."Select"];
		widgetSelect:SetScript("OnClick", onLineSelected);
		widgetClick:SetScript("OnClick", onLineDClicked);
		widgetClick:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue");
		widgetClick:SetAlpha(0.75);
		table.insert(widgetTab, widget);
	end
	TRP3_RegisterList.widgetTab = widgetTab;
	TRP3_RegisterListFilterCharactName:SetScript("OnTextChanged", refreshList);
	TRP3_RegisterListFilterCharactGuild:SetScript("OnTextChanged", refreshList);
	TRP3_RegisterListFilterCharactRealm:SetScript("OnClick", refreshList);

	TRP3_RegisterListFilterCharactNameText:SetText(loc("REG_LIST_NAME"));
	TRP3_RegisterListFilterCharactGuildText:SetText(loc("REG_LIST_GUILD"));
	TRP3_RegisterListFilterCharactRealmText:SetText(loc("REG_LIST_REALMONLY"));

	setTooltipForSameFrame(TRP3_RegisterListHeaderActions, "TOP", 0, 0, loc("CM_ACTIONS"));
	TRP3_RegisterListHeaderActions:SetScript("OnClick", onActions);

	Events.listenToEvent(Events.REGISTER_PROFILE_DELETED, function(profileID)
		selectedIDs[profileID] = nil;
		if isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
			unregisterMenu(currentlyOpenedProfilePrefix .. profileID);
		end
		if getCurrentPageID() == REGISTER_LIST_PAGEID then
			refreshList();
		end
	end);

	createTabBar();

end);