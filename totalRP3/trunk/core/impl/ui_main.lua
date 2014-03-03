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
local error = error;
local Minimap = Minimap;
local registerHandler = TRP3_CONFIG.registerHandler;

-- Refresh the minimap icon position
local function placeMinimapIcon()
	local minimap = _G[getConfigValue("MiniMapToUse")];
	minimap = minimap or Minimap or error("No MiniMap to anchor button.");
	
	local x = sin(getConfigValue("MiniMapIconDegree"))*getConfigValue("MiniMapIconPosition");
	local y = cos(getConfigValue("MiniMapIconDegree"))*getConfigValue("MiniMapIconPosition");
	TRP3_MinimapButton:SetParent(minimap);
	TRP3_MinimapButton:SetPoint("CENTER", minimap, "CENTER", x, y);

end

local function onConfigChanged()
	placeMinimapIcon();
end

-- Init the minimap icon button.
function TRP3_InitMinimapButton()
	registerConfigKey("MiniMapToUse", "Minimap");
	registerConfigKey("MiniMapIconDegree", 210);
	registerConfigKey("MiniMapIconPosition", 80);
	registerHandler("MiniMapToUse", onConfigChanged);
	registerHandler("MiniMapIconDegree", onConfigChanged);
	registerHandler("MiniMapIconPosition", onConfigChanged);
	
	TRP3_MinimapButton:RegisterForClicks("LeftButtonUp","RightButtonUp");
	TRP3_MinimapButton:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			TRP3_SwitchToolbar();
		else
			TRP3_SwitchMainFrame();
		end
	end);
	placeMinimapIcon();
end