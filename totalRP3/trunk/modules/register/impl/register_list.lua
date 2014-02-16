--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Character list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local stEtN = Utils.str.emptyToNil;
local loc = TRP3_L;
local get = TRP3_Profile_DataGetter;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentlyOpenedCharacterPrefix = "main_11_";
local currentlyOpenedCharacter = {};

local function openPage(unitID)
	if unitID == Globals.player_id then
		-- If the selected is player, simply oen his sheet.
		TRP3_SelectMenu("main_00_player");
	else
		if currentlyOpenedCharacter[unitID] then
			-- If the character already has his "tab", simply open it
			TRP3_SelectMenu(currentlyOpenedCharacterPrefix .. unitID);
		else
			-- Else, create a new menu entry and open it.
			local unitRealm, unitName = Utils.str.unitIDToInfo(unitID);
			local tabText = unitName;
			if TRP3_HasProfile(unitID) then
				local profile = TRP3_GetUnitProfile(unitID);
				if profile.characteristics then
					tabText = profile.characteristics.FN or unitName;
				end
			end
			TRP3_RegisterMenu({
				id = currentlyOpenedCharacterPrefix .. unitID,
				text = tabText,
				onSelected = function() TRP3_SetPage("player_main", {unitID = unitID}) end,
				isChildOf = "main_10_register",
			});
			currentlyOpenedCharacter[unitID] = true;
			TRP3_SelectMenu(currentlyOpenedCharacterPrefix .. unitID);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ICON_SIZE = 20;
local currentSelection;

local function refreshList()
	TRP3_InitList(TRP3_RegisterList, TRP3_GetCharacterList(), TRP3_RegisterListSlider);
end

local function decorateLine(line, unitID)
	local character = TRP3_GetCharacter(unitID);
	local unitRealm, unitName = Utils.str.unitIDToInfo(unitID);
	
	line.unitID = unitID;
	
	local unitTexture = Globals.icons.unknown;
	if character.race and character.gender then
		unitTexture = TRP3_GetUnitTexture(character.race, character.gender);
	end
	
	local classTexture = Globals.icons.unknown;
	if character.class then
		classTexture = TRP3_GetClassTexture(character.class);
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
	local unitRealm, unitName = Utils.str.unitIDToInfo(currentSelection);
	
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

	TRP3_RegisterMenu({
		id = "main_10_register",
		text = loc("REG_REGISTER"),
		onSelected = function() TRP3_SetPage("register_list"); end,
	});
	
	TRP3_RegisterPage({
		id = "register_list",
		templateName = "TRP3_RegisterList",
		frameName = "TRP3_RegisterList",
		frame = TRP3_RegisterList,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated",
		onPagePostShow = refreshList,
	});
	
	TRP3_RegisterListSlider:SetValue(0);
	TRP3_HandleMouseWheel(TRP3_RegisterListContainer, TRP3_RegisterListSlider);
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