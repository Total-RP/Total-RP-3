--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_TARGET_FRAME = {};
local Utils = TRP3_UTILS;
local loc = TRP3_L;
local ui_TargetFrame = TRP3_TargetFrame;
local ui_TargetFrameModel = TRP3_TargetFramePortraitModel;
local UnitName = UnitName;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Business logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onTargetChanged(...)
	local targetName = UnitName("target");
	if targetName then
		ui_TargetFrame:Show();
		ui_TargetFrameModel:SetUnit("target");
		ui_TargetFrameModel:SetCamera(0);
	else
		ui_TargetFrame:Hide();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_TARGET_FRAME.init = function()
	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
end