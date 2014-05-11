--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz & Ellypse(Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Config
local getConfigValue, registerConfigKey, setConfigValue = TRP3_CONFIG.getValue, TRP3_CONFIG.registerConfigKey, TRP3_CONFIG.setValue;
local CONFIG_MINIMAP_POS = "minimap_pos";


-- Reposition the minimap button using the config values
function TRP3_MinimapButton_Reposition()
	TRP3_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(getConfigValue(CONFIG_MINIMAP_POS))),(80*sin(getConfigValue(CONFIG_MINIMAP_POS)))-52)
end

-- Function called when the minimap icon is dragged
function TRP3_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition();
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();

	xpos = xmin-xpos/UIParent:GetScale()+70;
	ypos = ypos/UIParent:GetScale()-ymin-70;

	-- Setting the minimap coordanate
	setConfigValue(CONFIG_MINIMAP_POS,math.deg(math.atan2(ypos,xpos))); 

	TRP3_MinimapButton_Reposition()
end

-- Initialize the minimap icon button
function TRP3_InitMinimapButton(addon)
	registerConfigKey(CONFIG_MINIMAP_POS, 202);
	TRP3_MinimapButton_Reposition();
end


