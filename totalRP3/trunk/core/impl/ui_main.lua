--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz & Ellypse(Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Config
local Utils = TRP3_API.utils;
local getConfigValue, registerConfigKey, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.setValue;
local math, GetCursorPosition, Minimap, UIParent, cos, sin, strconcat = math, GetCursorPosition, Minimap, UIParent, cos, sin, strconcat;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local color, loc = TRP3_API.utils.str.color, TRP3_API.locale.getText;
local CONFIG_MINIMAP_POS = "minimap_pos";
local minimapButton;


-- Reposition the minimap button using the config values
local function minimapButton_Reposition()
	minimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(getConfigValue(CONFIG_MINIMAP_POS))),(80*sin(getConfigValue(CONFIG_MINIMAP_POS)))-52)
end

-- Function called when the minimap icon is dragged
local function minimapButton_DraggingFrame_OnUpdate(self)
	if self.isDraging then
		local xpos,ypos = GetCursorPosition();
		local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();
	
		xpos = xmin-xpos/UIParent:GetScale()+70;
		ypos = ypos/UIParent:GetScale()-ymin-70;
	
		-- Setting the minimap coordanate
		setConfigValue(CONFIG_MINIMAP_POS,math.deg(math.atan2(ypos,xpos)));
	
		minimapButton_Reposition();
	end
end

-- Initialize the minimap icon button
function TRP3_API.ui.initMinimapButton()
	local toggleMainPane, toggleToolbar = TRP3_API.navigation.switchMainFrame, TRP3_SwitchToolbar;
	minimapButton = TRP3_MinimapButton;

	registerConfigKey(CONFIG_MINIMAP_POS, 202);

	minimapButton:SetScript("OnUpdate", minimapButton_DraggingFrame_OnUpdate);
	minimapButton:SetScript("OnClick", function(self, button)
			if button == "RightButton" then
				toggleToolbar();
			else
				toggleMainPane();
			end
		end);
	
	minimapButton_Reposition();

	local minimapTooltip = strconcat(color("y"), loc("CM_L_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_MAIN"), "\n",
							color("y"), loc("CM_R_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_SHORTCUT"));
	setTooltipAll(minimapButton, "BOTTOMLEFT", 0, 0, "Total RP 3", minimapTooltip);
end
