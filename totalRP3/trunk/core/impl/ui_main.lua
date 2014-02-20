--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local getConfigValue = TRP3_GetConfigValue;
local TRP3_MinimapButton = TRP3_MinimapButton;

-- Refresh the minimap icon position
local function placeMinimapIcon()
	local minimap = _G[getConfigValue("MiniMapToUse")];
	if minimap then
		local x = sin(getConfigValue("MiniMapIconDegree"))*getConfigValue("MiniMapIconPosition");
		local y = cos(getConfigValue("MiniMapIconDegree"))*getConfigValue("MiniMapIconPosition");
		TRP3_MinimapButton:SetParent(minimap);
		TRP3_MinimapButton:SetPoint("CENTER", minimap, "CENTER", x, y);
	end
end

-- Init the minimap icon button.
function TRP3_InitMinimapButton()
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