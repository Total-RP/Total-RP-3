--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Character list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local color = TRP3_Color;
local loc = TRP3_L;
local get = TRP3_Profile_DataGetter;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ICON_SIZE = 20;
local currentSelection;

local function refreshList()
	TRP3_InitList(TRP3_RegisterList, TRP3_GetCharacterList(), TRP3_RegisterListSlider);
end

local function decorateLine(line, unitID)
	local character = TRP3_GetCharacter(unitID);
	local unitRealm, unitName = TRP3_GetUnitInfo(unitID);
	
	line.unitID = unitID;
	
	local unitTexture = TRP3_ICON_UNKNOWN;
	if character.race and character.gender then
		unitTexture = TRP3_GetUnitTexture(character.race, character.gender);
	end
	
	local classTexture = TRP3_ICON_UNKNOWN;
	if character.class then
		classTexture = TRP3_GetClassTexture(character.class);
	end
	
	local textures = TRP3_Icon(unitTexture, ICON_SIZE) .. " " .. TRP3_Icon(classTexture, ICON_SIZE);
	
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
	local unitRealm, unitName = TRP3_GetUnitInfo(currentSelection);
	
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