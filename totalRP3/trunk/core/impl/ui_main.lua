--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz & Ellypse(Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz & Ellypse (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local loc = TRP3_L;

-- Loading LDBIcon library
local libDBIcon = LibStub("LibDBIcon-1.0")


-- Initialize the minimap icon button
function TRP3_InitMinimapButton(addon)

	-- Create the minimap button, a LibDB object
	local TRP3_MinimapButton = LibStub("LibDataBroker-1.1"):NewDataObject("TRP3_MinimapButton", {
		type = "launcher", 	-- Indicates that this object is a launcher data source and does not provide any data to be rendered in an always-up frame
		tocname = "totalRP3", -- The name of the addon providing the launcher. Used by displays to get TOC metadata about the addon
		icon = "Interface\\AddOns\\totalRP3\\resources\\trp3minimap.tga",
		OnClick = function(clickedframe, button)			
			if button == "RightButton" then
				TRP3_SwitchToolbar();
			else
				TRP3_SwitchMainFrame();
			end
		end,
		OnLoad = function() self:RegisterForClicks("LeftButtonUp","RightButtonUp"); end,
		OnTooltipShow = function(tooltip)
		-- Function called by the object to display its tooltip.
		-- The display will manage positioning, clearing and showing the tooltip, 
		-- all this handler needs to do is populate the tooltip using :AddLine or similar. 
	    TRP3_MinimapTooltip(tooltip)
	    end,
	});

	-- Create a saved variable for the minimap object
	-- Using profile means every character can have the minimap button
	-- in a different place
	addon.db = LibStub("AceDB-3.0"):New("TRP3_Configuration", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	});
	libDBIcon:Register("TRP3_MinimapButton", TRP3_MinimapButton, addon.db.profile.minimap)
end

-- Populates the LDB tooltip
function TRP3_MinimapTooltip(tooltip)
	tooltip:AddLine("Total RP 3")
    tooltip:AddLine(loc("CM_R_CLICK").." : "..loc("MM_SHOW_HIDE_MAIN"));
    tooltip:AddLine(loc("CM_L_CLICK").." : "..loc("MM_SHOW_HIDE_SHORTCUT"));
end

