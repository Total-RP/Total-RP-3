--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Peek section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local stEtN = Utils.str.emptyToNil;
local color = Utils.str.color;
local loc = TRP3_L;
local get = TRP3_PROFILE.getData;
local tcopy = Utils.table.copy;
local assert = assert;
local getDefaultProfile = TRP3_PROFILE.getDefaultProfile;
local openIconBrowser = TRP3_POPUPS.openIconBrowser;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

getDefaultProfile().player.misc = {
	v = 1,
	PE = {},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Misc display
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GLANCE_NOT_USED_ICON = "INV_Misc_QuestionMark";

local function setupGlanceButton(button, active, icon, title, text, isMine)
	button:Enable();
	button:SetNormalTexture("Interface\\ICONS\\" .. (icon or GLANCE_NOT_USED_ICON));
	if active then
		button:SetAlpha(1);
		if not isMine then
			TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, title or "...", text);
		else
			TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, title or "...", (text or "...") .. "\n" .. color("y") .. loc("REG_PLAYER_GLANCE_CONFIG"));
		end
	else
		button:SetAlpha(0.1);
		if not isMine then
			button:Disable();
		else
			TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, loc("REG_PLAYER_GLANCE_UNUSED"), color("y") .. loc("REG_PLAYER_GLANCE_CONFIG"));
		end
	end
end

local function showView(context)
	local dataTab = nil;
	if context.unitID == Globals.player_id then
		dataTab = get("player/misc");
	else
		if TRP3_HasProfile(context.unitID) and TRP3_GetUnitProfile(context.unitID).misc then
			dataTab = TRP3_GetUnitProfile(context.unitID).misc;
		else
			dataTab = {};
		end
	end
	
	for i=1,5 do
		local glanceData = (dataTab.PE or {})[tostring(i)] or {};
		local button = _G["TRP3_RegisterPeekViewGlanceSlot" .. i];
		setupGlanceButton(button, glanceData.AC, glanceData.IC, glanceData.TI, glanceData.TX, context.unitID == Globals.player_id);
	end
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Misc Edit
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentSelected;
local draftData = {};

local function onIconSelected(icon)
	icon = icon or Globals.icons.default;
	TRP3_InitIconButton(TRP3_RegisterPeekEdit_Glance_Icon, icon);
	TRP3_RegisterPeekEdit_Glance_Icon.icon = icon;
	TRP3_ShowPopup(TRP3_RegisterGlanceEditor);
end

local function onIconClosed()
	TRP3_ShowPopup(TRP3_RegisterGlanceEditor);
end

local function onSlotClick(button)
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	if context.unitID == Globals.player_id then
		currentSelected = button.index;
		local dataTab = get("player/misc");
		draftData = (dataTab.PE or {})[currentSelected] or {};
		TRP3_RegisterPeekEdit_Glance_Active:SetChecked(draftData.AC);
		TRP3_RegisterPeekEdit_Glance_TextScrollText:SetText(draftData.TX or "");
		TRP3_RegisterPeekEdit_Glance_Title:SetText(draftData.TI or "");
		onIconSelected(draftData.IC);
		TRP3_ShowPopup(TRP3_RegisterGlanceEditor);
	end
end

local function applyPeek()
	assert(currentSelected, "No selection ...");
	local dataTab = get("player/misc");
	if not dataTab.PE then
		dataTab.PE = {};
	end
	if not dataTab.PE[currentSelected] then
		dataTab.PE[currentSelected] = {};
	end
	local peekTab = dataTab.PE[currentSelected];
	peekTab.IC = TRP3_RegisterPeekEdit_Glance_Icon.icon;
	peekTab.AC = TRP3_RegisterPeekEdit_Glance_Active:GetChecked();
	peekTab.TI = stEtN(TRP3_RegisterPeekEdit_Glance_Title:GetText());
	peekTab.TX = stEtN(TRP3_RegisterPeekEdit_Glance_TextScrollText:GetText());
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);
	-- Refresh display
	TRP3_HidePopups();
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
	TRP3_RegisterPeekEdit_Glance_ActiveText:SetText(loc("REG_PLAYER_GLANCE_USE"));
	TRP3_RegisterPeekEdit_Glance_Apply:SetText(loc("CM_APPLY"));
	TRP3_RegisterPeekEdit_Glance_TitleText:SetText(loc("REG_PLAYER_GLANCE_TITLE"));
	TRP3_RegisterGlanceEditorTitle:SetText(loc("REG_PLAYER_GLANCE_EDITOR"));
	
	TRP3_RegisterPeekEdit_Glance_Icon:SetScript("OnClick", function() openIconBrowser(onIconSelected, onIconClosed); end);
	TRP3_RegisterPeekEdit_Glance_Apply:SetScript("OnClick", applyPeek);
	for index=1,5,1 do
		-- DISPLAY
		local button = _G["TRP3_RegisterPeekViewGlanceSlot" .. index];
		button:SetDisabledTexture("Interface\\ICONS\\" .. GLANCE_NOT_USED_ICON);
		button:GetDisabledTexture():SetDesaturated(1);
		button:SetScript("OnClick", onSlotClick);
		button.index = tostring(index);
	end
end