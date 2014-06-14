--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Character list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local stEtN = Utils.str.emptyToNil;
local loc = TRP3_API.locale.getText;
local get = TRP3_API.profile.getData;
local assert, table, _G, date, pairs, error, tinsert = assert, table, _G, date, pairs, error, tinsert;
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
local getCompleteName = TRP3_API.register.getCompleteName;
local TRP3_RegisterListEmpty = TRP3_RegisterListEmpty;
local getProfile, getProfileList = TRP3_API.register.getProfile, TRP3_API.register.getProfileList;
local getIgnoredList, unignoreID = TRP3_API.register.getIgnoredList, TRP3_API.register.unignoreID;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local playerMenu = "main_10_player";
local currentlyOpenedProfilePrefix = "main_31_";
local REGISTER_PAGE = "main_30_register";

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
			onSelected = function() setPage("player_main", {profile = profile}) end,
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

local ICON_SIZE = 30;
local currentMode = 1;
local DATE_FORMAT = "%d/%m/%y %H:%M";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : CHARACTERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateCharacterLine(line, profileID)
	local profile = getProfile(profileID);
	line.profileID = profileID;

	local name = getCompleteName(profile.characteristics or {}, UNKNOWN, true);
	local tooltip, secondLine = name, "";

	_G[line:GetName().."Name"]:SetText(name);
	if profile.characteristics and profile.characteristics.IC then
		tooltip = Utils.str.icon(profile.characteristics.IC, ICON_SIZE) .. " " .. name;
	end
	
	if profile.link and tsize(profile.link) > 0 then
		secondLine = secondLine .. loc("REG_LIST_CHAR_TT_CHAR") .. "|cff00ff00";
		for unitID, _ in pairs(profile.link) do
			local unitName, unitRealm = unitIDToInfo(unitID);
			secondLine = secondLine .. "\n - " .. unitName .. " ( " .. unitRealm .. " )";
		end
	else
		secondLine = secondLine .. "|cffffff00" .. loc("REG_LIST_CHAR_TT_CHAR_NO");
	end

	if profile.time and profile.zone then
		local formatDate = date(DATE_FORMAT, profile.time);
		secondLine = secondLine .. "\n|r" .. loc("REG_LIST_CHAR_TT_DATE"):format(formatDate, profile.zone);
	end

	setTooltipForSameFrame(_G[line:GetName().."Click"], "TOPLEFT", 0, 5, tooltip, loc("REG_LIST_CHAR_TT"):format(secondLine));
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

	return lines;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : COMPANIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateCompanionLine(line, profileID)
	
end

local function getCompanionLines()
	TRP3_RegisterListEmpty:SetText(loc("REG_LIST_PETS_EMPTY"));
	return {};
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : IGNORED
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateIgnoredLine(line, unitID)
	line.unitID = unitID;
	_G[line:GetName().."Name"]:SetText(unitID);
	_G[line:GetName().."Info"]:SetText("");
	_G[line:GetName().."Info2"]:SetText("");
	setTooltipForSameFrame(_G[line:GetName().."Click"], "TOPLEFT", 0, 5, unitID, loc("REG_LIST_IGNORE_TT"):format(getIgnoredList()[unitID]));
end

local function getIgnoredLines()
	if tsize(getIgnoredList()) == 0 then
		TRP3_RegisterListEmpty:SetText(loc("REG_LIST_IGNORE_EMPTY"));
	end
	return getIgnoredList();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : LIST
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function refreshList()
	local lines;
	TRP3_RegisterListEmpty:Hide();

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
		assert(self:GetParent().profileID, "No profileID on line.");
		openPage(self:GetParent().profileID);
	elseif currentMode == MODE_IGNORE then
		assert(self:GetParent().unitID, "No unitID on line.");
		unignoreID(self:GetParent().unitID);
		refreshList();
	end
end

local function changeMode(tabWidget, value)
	currentMode = value;
	TRP3_RegisterListCharactFilter:Hide();
	if currentMode == MODE_CHARACTER then
		TRP3_RegisterListCharactFilter:Show();
	end
	refreshList();
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

function TRP3_API.register.inits.directoryInit()

	registerMenu({
		id = REGISTER_PAGE,
		text = loc("REG_REGISTER"),
		onSelected = function() setPage("register_list"); end,
	});

	registerPage({
		id = "register_list",
		templateName = "TRP3_RegisterList",
		frameName = "TRP3_RegisterList",
		frame = TRP3_RegisterList,
		onPagePostShow = function() tabGroup:SelectTab(1); end,
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
	for i=1,15 do
		local widget = _G["TRP3_RegisterListLine"..i];
		local widgetClick = _G["TRP3_RegisterListLine"..i.."Click"];
		widgetClick:SetScript("OnDoubleClick", onLineDClicked);
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

	createTabBar();

end