--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local getConfigValue = TRP3_CONFIG.getValue;
local setConfigValue = TRP3_CONFIG.setValue;
local registerConfigKey = TRP3_CONFIG.registerConfigKey;
local TRP3_MinimapButton = TRP3_MinimapButton;
local _G = _G;
local sin = sin;
local cos = cos;

-- Refresh the minimap icon position
local function placeMinimapIcon()
	local minimap = _G[getConfigValue("MiniMapToUse")];
	if minimap then
		local x = sin(getConfigValue("MiniMapIconDegree"))*getConfigValue("MiniMapIconPosition");
		local y = cos(getConfigValue("MiniMapIconDegree"))*getConfigValue("MiniMapIconPosition");
		TRP3_MinimapButton:SetParent(minimap);
		TRP3_MinimapButton:SetPoint("CENTER", minimap, "CENTER", x, y);
	elseif Minimap then
		setConfigValue("MiniMapToUse", "Minimap");
		placeMinimapIcon();
	end
end

-- Init the minimap icon button.
function TRP3_InitMinimapButton()
	registerConfigKey("MiniMapToUse", "Minimap");
	registerConfigKey("MiniMapIconDegree", 210);
	registerConfigKey("MiniMapIconPosition", 80);
	placeMinimapIcon();
	TRP3_MinimapButton:RegisterForClicks("LeftButtonUp","RightButtonUp");
	TRP3_MinimapButton:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			TRP3_SwitchToolbar();
		else
			TRP3_SwitchMainFrame();
		end
	end);
end