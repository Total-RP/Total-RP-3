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
local color, loc, tinsert, _G = TRP3_API.utils.str.color, TRP3_API.locale.getText, tinsert, _G;
local CONFIG_MINIMAP_FRAME, CONFIG_MINIMAP_X, CONFIG_MINIMAP_Y, CONFIG_MINIMAP_LOCK = "minimap_frame", "minimap_x", "minimap_y", "minimap_lock";
local minimapButton;

local function getParentFrame()
	return _G[getConfigValue(CONFIG_MINIMAP_FRAME)] or Minimap;
end

-- Reposition the minimap button using the config values
local function minimapButton_Reposition()
	minimapButton:SetParent(getParentFrame());
	minimapButton:ClearAllPoints();
	minimapButton:SetPoint("TOPLEFT", getConfigValue(CONFIG_MINIMAP_X), getConfigValue(CONFIG_MINIMAP_Y));
end

local OFFSET_CORRECTION_Y = -130;
local OFFSET_CORRECTION_X = -10;

-- Function called when the minimap icon is dragged
local function minimapButton_DraggingFrame_OnUpdate(self)
	if not getConfigValue(CONFIG_MINIMAP_LOCK) and self.isDraging then
		local xpos, ypos = GetCursorPosition();
		local xmin, ymin = getParentFrame():GetLeft(), getParentFrame():GetBottom();

		xpos = xpos / UIParent:GetScale() - xmin + OFFSET_CORRECTION_X;
		ypos = ypos / UIParent:GetScale() - ymin + OFFSET_CORRECTION_Y;

		-- Setting the minimap coordanate
		setConfigValue(CONFIG_MINIMAP_X, xpos);
		setConfigValue(CONFIG_MINIMAP_Y, ypos);

		minimapButton_Reposition();
	end
end

-- Initialize the minimap icon button
TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	local toggleMainPane, toggleToolbar = TRP3_API.navigation.switchMainFrame, TRP3_SwitchToolbar;
	minimapButton = TRP3_MinimapButton;

	registerConfigKey(CONFIG_MINIMAP_FRAME, "Minimap");
	registerConfigKey(CONFIG_MINIMAP_LOCK, false);
	registerConfigKey(CONFIG_MINIMAP_X, 10);
	registerConfigKey(CONFIG_MINIMAP_Y, -120);

	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc("CO_MINIMAP_BUTTON"),
	});
	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigEditBox",
		title = loc("CO_MINIMAP_BUTTON_FRAME"),
		help = loc("CO_MINIMAP_BUTTON_FRAME_TT"),
		configKey = CONFIG_MINIMAP_FRAME,
	});
	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc("CO_MINIMAP_BUTTON_LOCK"),
		help = loc("CO_MINIMAP_BUTTON_LOCK_TT"),
		configKey = CONFIG_MINIMAP_LOCK,
	});

	minimapButton:SetScript("OnUpdate", minimapButton_DraggingFrame_OnUpdate);
	minimapButton:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			toggleToolbar();
		else
			toggleMainPane();
		end
	end);

	minimapButton_Reposition();

	local minimapTooltip = strconcat(
		color("y"), loc("CM_L_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_MAIN"),
		"\n", color("y"), loc("CM_R_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_SHORTCUT"),
		"\n", color("y"), loc("CM_DRAGDROP"), ": ", color("w"), loc("MM_SHOW_HIDE_MOVE")
	);
	setTooltipAll(minimapButton, "BOTTOMLEFT", 0, 0, "Total RP 3", minimapTooltip);
end);
