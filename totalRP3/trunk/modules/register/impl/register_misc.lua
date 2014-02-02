--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Peek section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local color = TRP3_Color;
local loc = TRP3_L;
local get = TRP3_Profile_DataGetter;
local tcopy = TRP3_DupplicateTab;
local assert = assert;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--TRP3_GetDefaultProfile().player.misc = {
-- v = 1,
-- PE = {},
--}

-- Mock
TRP3_GetDefaultProfile().player.misc = {
	v = 1,
	CU = "My pretty current ic which is purposely very very long a lot more than 130 characters.",
	PE = {
		["1"] = {
			IC = "SPELL_FIRE_SOULBURN",
			TE = "Plou",
			TI = "Plou",
		},
		["4"] = {
			IC = "SPELL_FIRE_SELFDESTRUCT",
			TE = "Plou",
			TI = "Plou",
		},
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Misc display
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GLANCE_NOT_USED_ICON = "INV_Misc_QuestionMark";

local function setupGlanceButton(button, icon, title, text)
	button:SetNormalTexture("Interface\\ICONS\\" .. (icon or TRP3_ICON_DEFAULT));
	button:SetDisabledTexture("Interface\\ICONS\\" .. (icon or TRP3_ICON_DEFAULT));
	button:GetDisabledTexture():SetDesaturated(1);
	TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, title, text);
end

local function showView(context)
	TRP3_RegisterPeekEdit:Hide();
	TRP3_RegisterPeekView:Show();
	TRP3_RegisterPeekView_Edit:Hide();
	
	local dataTab = nil;
	if context.unitID == TRP3_USER_ID then
		dataTab = get("player/misc");
		TRP3_RegisterPeekView_Edit:Show();
	else
		if TRP3_HasProfile(context.unitID) and TRP3_GetUnitProfile(context.unitID).style then
			dataTab = TRP3_GetUnitProfile(context.unitID).style;
		else
			dataTab = {};
		end
	end
	
	if(dataTab.CO) then
		TRP3_FieldSet_SetCaption(TRP3_RegisterPeekViewCurrent, loc("REG_PLAYER_CURRENTOOC"), 150);
	else
		TRP3_FieldSet_SetCaption(TRP3_RegisterPeekViewCurrent, loc("REG_PLAYER_CURRENT"), 150);
	end
	TRP3_RegisterPeekViewCurrentText:SetText(dataTab.CU or "");
	
	for i=1,5 do
		local glanceData = dataTab.PE[tostring(i)];
		local button = _G["TRP3_RegisterPeekViewGlanceSlot" .. i];
		if glanceData then
			button:Enable();
			setupGlanceButton(button, glanceData.IC, glanceData.TI, glanceData.TE);
			button:SetAlpha(1);
		else
			button:Disable();
			setupGlanceButton(button, GLANCE_NOT_USED_ICON);
			button:SetAlpha(0.1);
		end
		
	end
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Misc Edit
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local draftData = {};

local function showEdit()
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	assert(context.unitID == TRP3_USER_ID, "Trying to show Misc edition for another unitID than me ...");
	
	TRP3_RegisterPeekEdit:Show();
	TRP3_RegisterPeekView:Hide();
	
	-- Copy current values
	local dataTab = get("player/misc");
	assert(type(dataTab) == "table", "Error: Nil misc data or not a table.");
	wipe(draftData);
	tcopy(draftData, dataTab);
	
	TRP3_RegisterPeekEdit_Current_OOC:SetChecked(draftData.CO);
	TRP3_RegisterPeekEdit_Current_TextScrollText:SetText(draftData.CU or "");
end

local function onIconSelected(icon)
	
end

local function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.CO = TRP3_RegisterPeekEdit_Current_OOC:GetChecked();
	draftData.CU = stEtN(TRP3_RegisterPeekEdit_Current_TextScrollText:GetText());
end

local function saveMisc()
	saveInDraft();
	local dataTab = get("player/misc");
	assert(type(dataTab) == "table", "Error: Nil misc data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = TRP3_IncrementVersion(dataTab.v, 2);
	TRP3_onPlayerPeekShow();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Misc logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_onPlayerPeekShow()
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	TRP3_RegisterPeek:Show();
	showView(context);
end

function TRP3_RegisterMiscGetExchangeData()
	return get("player/misc");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_PeekInit()
	TRP3_FieldSet_SetCaption(TRP3_RegisterPeekViewCurrent, loc("REG_PLAYER_CURRENT"), 150);
	TRP3_FieldSet_SetCaption(TRP3_RegisterPeekViewGlance, loc("REG_PLAYER_GLANCE"), 150);
	TRP3_FieldSet_SetCaption(TRP3_RegisterPeekEdit_Current, loc("REG_PLAYER_CURRENT"), 150);
	TRP3_FieldSet_SetCaption(TRP3_RegisterPeekEdit_Glance, loc("REG_PLAYER_GLANCE"), 150);
	TRP3_RegisterPeekEdit_Current_OOCText:SetText(loc("REG_PLAYER_CURRENT_OOC"));
	TRP3_RegisterPeekEdit_Glance_ActiveText:SetText(loc("REG_PLAYER_GLANCE_USE"));
	
	
	TRP3_RegisterPeekView_Edit:SetText(loc("CM_EDIT"));
	TRP3_RegisterPeekView_Edit:SetScript("OnClick", showEdit);
	
	TRP3_RegisterPeekEdit_Save:SetText(loc("CM_SAVE"));
	TRP3_RegisterPeekEdit_Save:SetScript("OnClick", saveMisc);
	
	TRP3_RegisterPeekEdit_Cancel:SetText(loc("CM_CANCEL"));
	TRP3_RegisterPeekEdit_Cancel:SetScript("OnClick", TRP3_onPlayerPeekShow);
	
	TRP3_RegisterPeekEdit_Glance_Icon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onIconSelected) end);
end