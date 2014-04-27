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
local assert, table, _G = assert, table, _G;
local isUnitIDKnown = TRP3_REGISTER.isUnitIDKnown;
local unitIDToInfo = Utils.str.unitIDToInfo;
local handleMouseWheel = TRP3_UI_UTILS.list.handleMouseWheel;
local initList = TRP3_UI_UTILS.list.initList;
local getUnitTexture = TRP3_UI_UTILS.misc.getUnitTexture;
local getClassTexture = TRP3_UI_UTILS.misc.getClassTexture;
local registerMenu, selectMenu, openMainFrame = TRP3_NAVIGATION.menu.registerMenu, TRP3_NAVIGATION.menu.selectMenu, TRP3_NAVIGATION.openMainFrame;
local registerPage, setPage = TRP3_NAVIGATION.page.registerPage, TRP3_NAVIGATION.page.setPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentlyOpenedCharacterPrefix = "main_21_";
local currentlyOpenedCharacter = {};

local function openPage(unitID)
	if unitID == Globals.player_id then
		-- If the selected is player, simply oen his sheet.
		selectMenu("main_10_player");
	else
		if currentlyOpenedCharacter[unitID] then
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
			});
			currentlyOpenedCharacter[unitID] = true;
			selectMenu(currentlyOpenedCharacterPrefix .. unitID);
		end
	end
end


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ICON_SIZE = 20;
local currentSelection;

local function refreshList()
	initList(TRP3_RegisterList, TRP3_GetCharacterList(), TRP3_RegisterListSlider);
end

local function decorateLine(line, unitID)
	local character = TRP3_GetCharacter(unitID);
	local unitName, unitRealm = unitIDToInfo(unitID);
	
	line.unitID = unitID;
	
	local unitTexture = Globals.icons.unknown;
	if character.race and character.gender then
		unitTexture = getUnitTexture(character.race, character.gender);
	end
	
	local classTexture = Globals.icons.unknown;
	if character.class then
		classTexture = getClassTexture(character.class);
	end
	
	local textures = Utils.str.icon(unitTexture, ICON_SIZE) .. " " .. Utils.str.icon(classTexture, ICON_SIZE);
	
	if TRP3_HasProfile(unitID) then
		local profile = TRP3_GetUnitProfile(unitID);
		_G[line:GetName().."Name"]:SetText(textures .. " " .. TRP3_GetCompleteName(profile.characteristics or {}, unitName, true));
	else
		_G[line:GetName().."Name"]:SetText(textures .. " " .. unitName);
	end
	if character.guild and character.guild:len() > 0 then
		_G[line:GetName().."Guild"]:SetText(character.guild);
	else
		_G[line:GetName().."Guild"]:SetText("");
	end
	_G[line:GetName().."Realm"]:SetText(unitRealm);
	
	local clickButton = _G[line:GetName().."Click"];
	if currentSelection == unitID then
		clickButton:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue");
		clickButton:SetAlpha(0.7);
		clickButton:LockHighlight();
	else
		clickButton:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar");
		clickButton:SetAlpha(0.25);
		clickButton:UnlockHighlight();
	end
end

local function decorateSelectionFrame()
	local character = TRP3_GetCharacter(currentSelection);
	local unitName, unitRealm = Utils.str.unitIDToInfo(currentSelection);
	
	if TRP3_HasProfile(currentSelection) then
		local profile = TRP3_GetUnitProfile(currentSelection);
		TRP3_RegisterListSelectionName:SetText(TRP3_GetCompleteName(profile.characteristics or {}, unitName, true));
	else
		TRP3_RegisterListSelectionName:SetText(unitName);
	end
end

local function onLineClicked(self, button)
	assert(self:GetParent().unitID, "No unit ID on line.");
	currentSelection = self:GetParent().unitID;
	decorateSelectionFrame();
	refreshList();
end

local function onLineDClicked(self, button)
	assert(self:GetParent().unitID, "No unit ID on line.");
	openPage(self:GetParent().unitID);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

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
		onPagePostShow = refreshList,
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
	for i=1,10 do
		local widget = _G["TRP3_RegisterListLine"..i];
		local widgetClick = _G["TRP3_RegisterListLine"..i.."Click"];
		widgetClick:SetScript("OnClick", onLineClicked);
		widgetClick:SetScript("OnDoubleClick", onLineDClicked);
		table.insert(widgetTab, widget);
	end
	TRP3_RegisterList.widgetTab = widgetTab;
	TRP3_RegisterList.decorate = decorateLine;
	
	TRP3_RegisterListTitle:SetText(loc("REG_LIST_TITLE"));
	TRP3_RegisterListFilter:SetText(loc("REG_LIST_FILTERS"));
	TRP3_RegisterListFilterNameText:SetText(loc("REG_LIST_NAME"));
	TRP3_RegisterListFilterGuildText:SetText(loc("REG_LIST_GUILD"));
	TRP3_RegisterListFilterRealmText:SetText(loc("REG_LIST_REALMONLY"));
	
end