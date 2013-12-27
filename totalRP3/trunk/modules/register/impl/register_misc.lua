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
-- Peek
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GLANCE_NOT_USED_ICON = "INV_Misc_QuestionMark";

local function setupGlanceButton(button, icon, title, text)
	button:SetNormalTexture("Interface\\ICONS\\" .. (icon or TRP3_ICON_DEFAULT));
	button:SetDisabledTexture("Interface\\ICONS\\" .. (icon or TRP3_ICON_DEFAULT));
	button:GetDisabledTexture():SetDesaturated(1);
	TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, title, text);
end

local function showView()
	TRP3_RegisterPeekEdit:Hide();
	TRP3_RegisterPeekView:Show();
	
	local data = get("player/misc");
	assert(type(data) == "table", "Error: Nil peek data or not a table.");
	
	TRP3_RegisterPeekViewCurrentText:SetText(data.CU or "");
	
	for i=1,5 do
		local glanceData = data.PE[tostring(i)];
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

function TRP3_onPlayerPeekShow()
	TRP3_RegisterPeek:Show();
	showView();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_PeekInit()
	TRP3_FieldSet_SetCaption(TRP3_RegisterPeekViewCurrent, loc("REG_PLAYER_CURRENT"), 150);
	TRP3_FieldSet_SetCaption(TRP3_RegisterPeekViewGlance, loc("REG_PLAYER_GLANCE"), 150);
end