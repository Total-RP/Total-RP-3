--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Character list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local stEtN = Utils.str.emptyToNil;
local loc = TRP3_L;
local get = TRP3_PROFILE.getData;
local assert, table, _G, date = assert, table, _G, date;
local isUnitIDKnown = TRP3_REGISTER.isUnitIDKnown;
local unitIDToInfo, tsize = Utils.str.unitIDToInfo, Utils.table.size;
local handleMouseWheel = TRP3_UI_UTILS.list.handleMouseWheel;
local initList = TRP3_UI_UTILS.list.initList;
local getUnitTexture = TRP3_UI_UTILS.misc.getUnitTexture;
local getClassTexture = TRP3_UI_UTILS.misc.getClassTexture;
local setTooltipForSameFrame = TRP3_UI_UTILS.tooltip.setTooltipForSameFrame;
local isMenuRegistered = TRP3_NAVIGATION.menu.isMenuRegistered;
local registerMenu, selectMenu, openMainFrame = TRP3_NAVIGATION.menu.registerMenu, TRP3_NAVIGATION.menu.selectMenu, TRP3_NAVIGATION.openMainFrame;
local registerPage, setPage = TRP3_NAVIGATION.page.registerPage, TRP3_NAVIGATION.page.setPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentlyOpenedCharacterPrefix = "main_21_";

local function openPage(unitID)
	if unitID == Globals.player_id then
		-- If the selected is player, simply oen his sheet.
		selectMenu("main_10_player");
	else
		if isMenuRegistered(currentlyOpenedCharacterPrefix .. unitID) then
			-- If the character already has his "tab", simply open it
			selectMenu(currentlyOpenedCharacterPrefix .. unitID);
		else
			-- Else, create a new menu entry and open it.
			local unitName, unitRealm = unitIDToInfo(unitID);
			local tabText = unitName;
			if TRP3_HasProfile(unitID) then
				local profile = TRP3_GetUnitProfile(unitID);
				if profile.characteristics then
					tabText = profile.characteristics.FN or unitName;
				end
			end
			registerMenu({
				id = currentlyOpenedCharacterPrefix .. unitID,
				text = tabText,
				onSelected = function() setPage("player_main", {unitID = unitID}) end,
				isChildOf = "main_20_register",
				closeable = true,
			});
			selectMenu(currentlyOpenedCharacterPrefix .. unitID);
		end
	end
end


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MODE_CHARACTER = 1;
local MODE_PETS = 2;

local ICON_SIZE = 30;
local currentMode = "characters";
local DATE_FORMAT = "%d/%m/%y %H:%M";

local function decorateLine(line, unitID)
	local character = TRP3_GetCharacter(unitID);
	local unitName, unitRealm = unitIDToInfo(unitID);
	
	line.unitID = unitID;
	
	local name = unitName;
	if TRP3_HasProfile(unitID) then
		local profile = TRP3_GetUnitProfile(unitID);
		name = TRP3_GetCompleteName(profile.characteristics or {}, unitName, true);
		_G[line:GetName().."Name"]:SetText(name);
		if profile.characteristics and profile.characteristics.IC then
			name = Utils.str.icon(profile.characteristics.IC, ICON_SIZE) .. " " .. name;
		end
	else
		_G[line:GetName().."Name"]:SetText(unitName);
	end
	if character.guild and character.guild:len() > 0 then
		_G[line:GetName().."Guild"]:SetText(character.guild);
	else
		_G[line:GetName().."Guild"]:SetText("");
	end
	
	local clickButton = _G[line:GetName().."Click"];
	
	local secondLine = "";
	if character.time and character.zone then
		local formatDate = date(DATE_FORMAT, character.time);
		secondLine = secondLine .. loc("REG_LIST_CHAR_TT_DATE"):format(formatDate, character.zone, unitRealm) .. "\n";
	end
	
	setTooltipForSameFrame(clickButton, "TOPLEFT", 0, 5, name, loc("REG_LIST_CHAR_TT"):format(secondLine));
end

local function refreshCharacters()
	local nameSearch = TRP3_RegisterListFilterCharactName:GetText():lower();
	local guildSearch = TRP3_RegisterListFilterCharactGuild:GetText():lower();
	local realmOnly = TRP3_RegisterListFilterCharactRealm:GetChecked();
	local fullSize = tsize(TRP3_GetCharacterList());
	local lines = {};
	
	for unitID, character in pairs(TRP3_GetCharacterList()) do
		local name, realm = unitIDToInfo(unitID);
		local guild = character.guild or "";
		if (nameSearch:len() == 0 or name:lower():find(nameSearch))
			and (guildSearch:len() == 0 or guild:lower():find(guildSearch))
			and (not realmOnly or realm == Globals.player_realm_id)
		then
			lines[unitID] = character;
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
	TRP3_FieldSet_SetCaption(TRP3_RegisterListCharactFilter, loc("REG_LIST_CHAR_FILTER"):format(lineSize, fullSize), 200);
	
	return lines;
end

local function refreshList()
	local lines;
	TRP3_RegisterListEmpty:Hide();
	
	if currentMode == MODE_CHARACTER then
		lines = refreshCharacters();
	else
		lines = {};
	end
	
	if tsize(lines) == 0 then
		TRP3_RegisterListEmpty:Show();
	end
	initList(TRP3_RegisterList, lines, TRP3_RegisterListSlider);
end

local function onLineDClicked(self, button)
	assert(self:GetParent().unitID, "No unit ID on line.");
	openPage(self:GetParent().unitID);
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
	tabGroup = TRP3_TabBar_Create(frame,
		{
			{loc("REG_LIST_CHAR_TITLE"), 1, 150},
			{loc("REG_LIST_PETS_TITLE"), 2, 150},
		},
		changeMode
	);
	tabGroup:SelectTab(1);
end

function TRP3_Register_ListInit()

	registerMenu({
		id = "main_20_register",
		text = loc("REG_REGISTER"),
		onSelected = function() setPage("register_list"); end,
	});
	
	registerPage({
		id = "register_list",
		templateName = "TRP3_RegisterList",
		frameName = "TRP3_RegisterList",
		frame = TRP3_RegisterList,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated",
		onPagePostShow = function() tabGroup:SelectTab(1); end,
	});
	
	TRP3_TARGET_FRAME.registerButton({
		id = "aa_page_player",
		condition = function(unitID, targetInfo)
			return unitID == Globals.player_id or isUnitIDKnown(unitID);
		end,
		onClick = function(unitID)
			openMainFrame();
			openPage(unitID);
		end,
		getTooltip = function() return loc("TF_OPEN_CHARACTER") end,
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
	TRP3_RegisterList.decorate = decorateLine;
	TRP3_RegisterListFilterCharactName:SetScript("OnTextChanged", refreshList);
	TRP3_RegisterListFilterCharactGuild:SetScript("OnTextChanged", refreshList);
	TRP3_RegisterListFilterCharactRealm:SetScript("OnClick", refreshList);

	TRP3_RegisterListFilterCharactNameText:SetText(loc("REG_LIST_NAME"));
	TRP3_RegisterListFilterCharactGuildText:SetText(loc("REG_LIST_GUILD"));
	TRP3_RegisterListFilterCharactRealmText:SetText(loc("REG_LIST_REALMONLY"));
	
	createTabBar();
	
end