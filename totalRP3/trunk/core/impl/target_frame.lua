--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_TARGET_FRAME = {};
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local loc = TRP3_L;
local ui_TargetFrame = TRP3_TargetFrame;
local ui_TargetFrameModel = TRP3_TargetFramePortraitModel;
local UnitName = UnitName;
local EMPTY = Globals.empty;
local getMiscData;
local isUnitIDKnown;
local _G = _G;
local tostring = tostring;
local getUnitID = Utils.str.getUnitID;
local setTooltipForSameFrame = TRP3_UI_UTILS.setTooltipForSameFrame;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Business logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onTargetChanged(...)
	local unitID = getUnitID("target");
	if unitID then
		ui_TargetFrame:Show();
		ui_TargetFrameModel:SetUnit("target");
		ui_TargetFrameModel:SetCamera(0);
		local peekTab = EMPTY;
		if isUnitIDKnown(unitID) then
			peekTab = getMiscData(unitID).PE or EMPTY;
		end
		for i=1,5,1 do
			local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
			local peek = peekTab[tostring(i)];
			if peek and peek.AC then
				slot:Show();
				local iconTag = Utils.str.icon(peek.IC or Globals.icons.default, 30);
				setTooltipForSameFrame(slot, "TOP_LEFT", 0, 0, iconTag .. " " .. (peek.TI or "..."), peek.TX);
				Utils.texture.applyRoundTexture("TRP3_TargetFrameGlanceSlot"..i.."Image", "Interface\\ICONS\\" .. (peek.IC or ""), "Interface\\ICONS\\" .. Globals.icons.default);
			else
				slot:Hide();
			end
		end
	else
		ui_TargetFrame:Hide();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_TARGET_FRAME.init = function()
	getMiscData = TRP3_REGISTER.getMiscData;
	isUnitIDKnown = TRP3_REGISTER.isUnitIDKnown;
	
	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
end