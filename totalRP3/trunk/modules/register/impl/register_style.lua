--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : RP Style section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local stEtN = Utils.str.emptyToNil;
local get = TRP3_Profile_DataGetter;
local loc = TRP3_L;
local tcopy = Utils.table.copy;
local assert = assert;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_GetDefaultProfile().player.style = {
	v = 1,
	VA = {},
}

local STYLE_FIELDS;
local function buildStructure()
	STYLE_FIELDS = {
		{
			id = "1",
			name = loc("REG_PLAYER_STYLE_RPXP"),
			values = {
				{loc("REG_PLAYER_STYLE_BEGINNER"), 1},
				{loc("REG_PLAYER_STYLE_XP"), 2},
				{loc("REG_PLAYER_STYLE_VET"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "2",
			name = loc("REG_PLAYER_STYLE_WOWXP"),
			values = {
				{loc("REG_PLAYER_STYLE_BEGINNER"), 1},
				{loc("REG_PLAYER_STYLE_XP"), 2},
				{loc("REG_PLAYER_STYLE_VET"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "3",
			name = loc("REG_PLAYER_STYLE_FREQ"),
			values = {
				{loc("REG_PLAYER_STYLE_FREQ_1"), 1},
				{loc("REG_PLAYER_STYLE_FREQ_2"), 2},
				{loc("REG_PLAYER_STYLE_FREQ_3"), 3},
				{loc("REG_PLAYER_STYLE_FREQ_4"), 4},
				{loc("REG_PLAYER_STYLE_FREQ_5"), 5},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "4",
			name = loc("REG_PLAYER_STYLE_ASSIST"),
			values = {
				{YES, 1},
				{NO, 2},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "5",
			name = loc("REG_PLAYER_STYLE_INJURY"),
			values = {
				{YES, 1},
				{NO, 2},
				{loc("REG_PLAYER_STYLE_PERMI"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "6",
			name = loc("REG_PLAYER_STYLE_DEATH"),
			values = {
				{YES, 1},
				{"No", 2},
				{loc("REG_PLAYER_STYLE_PERMI"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "7",
			name = loc("REG_PLAYER_STYLE_ROMANCE"),
			values = {
				{YES, 1},
				{NO, 2},
				{loc("REG_PLAYER_STYLE_PERMI"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "8",
			name = loc("REG_PLAYER_STYLE_BATTLE"),
			values = {
				{loc("REG_PLAYER_STYLE_BATTLE_1"), 1},
				{loc("REG_PLAYER_STYLE_BATTLE_2"), 2},
				{loc("REG_PLAYER_STYLE_BATTLE_3"), 3},
				{loc("REG_PLAYER_STYLE_BATTLE_4"), 4},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
	}
end


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Roleplay style
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local consultLines = {};

local function showConsult(context)
	TRP3_RegisterRPStyleMain_Display:Show();
	TRP3_RegisterRPStyleMain_Edit:Hide();
	TRP3_RegisterRPStyleMain_Display_Edit:Hide();
	
	
	local dataTab = nil;
	if context.unitID == Globals.player_id then
		dataTab = get("player/style");
		TRP3_RegisterRPStyleMain_Display_Edit:Show();
	else
		if TRP3_HasProfile(context.unitID) and TRP3_GetUnitProfile(context.unitID).style then
			dataTab = TRP3_GetUnitProfile(context.unitID).style;
		else
			dataTab = {};
		end
	end
	
	-- Hide all
	for _, frame in pairs(consultLines) do
		frame:Hide();
	end

	local previous = nil;
	local index = 1;
	if type(dataTab.VA) == "table" then
		for _, fieldData in pairs(STYLE_FIELDS) do
			local selectedValue = dataTab.VA[fieldData.id] or 0;
			if selectedValue ~= 0 then
				local frame = consultLines[index];
				if frame == nil then
					frame = CreateFrame("Frame", "TRP3_RegisterRPStyleMain_Display_Line"..index, TRP3_RegisterRPStyleMain_Display, "TRP3_RegisterRPStyleMain_Display_Line");
					tinsert(consultLines, frame);
				end
				-- Position
				frame:ClearAllPoints();
				if previous == nil then
					frame:SetPoint("TOPLEFT", TRP3_RegisterRPStyleMain_Display, "TOPLEFT", -5, -30);
				else
					frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
				end
				frame:SetPoint("LEFT", 0, 0);
				frame:SetPoint("RIGHT", 0, 0);
				
				-- Value
				_G[frame:GetName().."FieldName"]:SetText(fieldData.name);
				_G[frame:GetName().."FieldValue"]:SetText(fieldData.values[selectedValue][1]);
				
				frame:Show();
				previous = frame;
				index = index + 1;
			end
		end
	end
	if index == 1 then
		-- TODO: is empty, place a text
	end
end

local editLines = {};
local draftData = {};

local function onEditSelection(choice, frame)
	frame = frame:GetParent();
	assert(frame.fieldData, "No data in frame !");
	draftData.VA[frame.fieldData.id] = choice;
end

local function showEdit()
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	assert(context.unitID == Globals.player_id, "Trying to show Style edition for another unitID than me ...");

	TRP3_RegisterRPStyleMain_Display:Hide();
	TRP3_RegisterRPStyleMain_Edit:Show();
	
	-- Copy current values
	local dataTab = get("player/style");
	assert(type(dataTab) == "table", "Error: Nil style data or not a table.");
	wipe(draftData);
	tcopy(draftData, dataTab);
	
	if not draftData.VA then
		draftData.VA = {};
	end
	
	-- Hide all
	for _, frame in pairs(editLines) do
		frame:Hide();
	end

	local previous = nil;
	for index, fieldData in pairs(STYLE_FIELDS) do
		local frame = editLines[index];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterRPStyleMain_Edit_Line"..index, TRP3_RegisterRPStyleMain_Edit, "TRP3_RegisterRPStyleMain_Edit_Line");
			TRP3_ListBox_Setup(_G[frame:GetName().."Values"], fieldData.values, onEditSelection, nil, 180, true);
			frame.fieldData = fieldData;
			tinsert(editLines, frame);
		end
		-- Position
		frame:ClearAllPoints();
		if previous == nil then
			frame:SetPoint("TOPLEFT", TRP3_RegisterRPStyleMain_Display, "TOPLEFT", -5, -60);
		else
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
		end
		frame:SetPoint("LEFT", 0, 0);
		frame:SetPoint("RIGHT", 0, 0);
		
		-- Value
		local selectedValue = draftData.VA[fieldData.id] or 0;
		_G[frame:GetName().."FieldName"]:SetText(fieldData.name);
		_G[frame:GetName().."Values"]:SetSelectedValue(selectedValue);
		
		frame:Show();
		previous = frame;
	end
end

local function saveRPStyle()
	local dataTab = get("player/style");
	assert(type(dataTab) == "table", "Error: Nil style data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);
	
	TRP3_onPlayerRPStyleShow();
end

function TRP3_onPlayerRPStyleShow()
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	TRP3_RegisterRPStyle:Show();
	showConsult(context);
end

function TRP3_RegisterRPStyleGetExchangeData()
	return get("player/style");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_StyleInit()
	buildStructure();
	
	TRP3_FieldSet_SetCaption(TRP3_RegisterRPStyleMain, loc("REG_PLAYER_STYLE_RPSTYLE"), 150);
	
	TRP3_RegisterRPStyleMain_Display_Edit:SetScript("OnClick", showEdit);
	TRP3_RegisterRPStyleMain_Display_Edit:SetText(loc("CM_EDIT"));
	
	TRP3_RegisterRPStyleMain_Edit_Cancel:SetScript("OnClick", TRP3_onPlayerRPStyleShow);
	TRP3_RegisterRPStyleMain_Edit_Cancel:SetText(loc("CM_CANCEL"));
	
	TRP3_RegisterRPStyleMain_Edit_Save:SetScript("OnClick", saveRPStyle);
	TRP3_RegisterRPStyleMain_Edit_Save:SetText(loc("CM_SAVE"));
end