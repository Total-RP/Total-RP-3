--
-- Created by IntelliJ IDEA.
-- User: Renaud
-- Date: 24/11/14
-- Time: 16:10
-- To change this template use File | Settings | File Templates.
--

-- Local import
local CONFIG_MINIMAP_SHOW = "minimap_show";
local getConfigValue, registerConfigKey = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey;
local color, loc, strconcat = TRP3_API.utils.str.color, TRP3_API.locale.getText, strconcat;

-- Minimap button API initialization
TRP3_API.navigation.minimapicon = {};

local LDBObject;
local icon;

-- Initialize LDBIcon and display the minimap button
local showMinimapButton = function()
	icon:Show("Total RP 3");
end
TRP3_API.navigation.minimapicon.show = showMinimapButton;

-- Hide the minimap button and release LDBIcon from the memory
local hideMinimapButton = function()
	icon:Hide("Total RP 3");
end
TRP3_API.navigation.minimapicon.hide = hideMinimapButton;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	registerConfigKey(CONFIG_MINIMAP_SHOW, true);

	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = "Show minimap button",
		help = "If you are using an other add-on to display Total RP 3's minimap button (FuBar, Titan, Bazooka) you can remove the button from the minimap.\n\n|cff00ff00Reminder : You can open Total RP 3 using /trp3 switch main|r",
		configKey = CONFIG_MINIMAP_SHOW,
	});

	TRP3_API.configuration.registerHandler(CONFIG_MINIMAP_SHOW, function()
		if getConfigValue(CONFIG_MINIMAP_SHOW) then
			showMinimapButton();
		else
			hideMinimapButton();
		end
	end);

	local minimapTooltip = strconcat(color("y"), loc("CM_L_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_MAIN"));
	if TRP3_API.toolbar then
		minimapTooltip = strconcat(minimapTooltip, "\n", color("y"), loc("CM_R_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_SHORTCUT"));
	end
	minimapTooltip = strconcat(minimapTooltip, "\n", color("y"), loc("CM_DRAGDROP"), ": ", color("w"), loc("MM_SHOW_HIDE_MOVE"));

	LDBObject = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Total RP 3", {
		type = "launcher",
		icon = "Interface\\AddOns\\totalRP3\\resources\\trp3minimap.tga",
		tocname = "totalRP3",
		OnClick = function(clickedframe, button)
			if button == "RightButton" and TRP3_API.toolbar then
				TRP3_API.toolbar.switch();
			else
				TRP3_API.navigation.switchMainFrame();
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine("Total RP 3");
			tooltip:AddLine(minimapTooltip);
		end,
	})

	icon = LibStub("LibDBIcon-1.0");
	icon:Register("Total RP 3", LDBObject, TRP3_Configuration.minimap_icon_position)

	if getConfigValue(CONFIG_MINIMAP_SHOW) then
		showMinimapButton();
	end

end);

-- TODO Setting to hide minimap button -> use TRP3_API.navigation.minimapicon.hide() + TRP3_API.configuration.setValue(CONFIG_MINIMAP_SHOW,true/false)

