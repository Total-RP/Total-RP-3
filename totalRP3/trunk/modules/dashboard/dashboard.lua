--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Telkostrasz & Ellypse
-- Dashboard page
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_DASHBOARD = {};
local loc = TRP3_L;

local function onStatusChange(status)

end

local function onShow(context)
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_DASHBOARD.init = function()

	TRP3_RegisterMenu({
		id = "main_00_dashboard",
		text = TRP3_GLOBALS.addon_name,
		onSelected = function() TRP3_SetPage("dashboard"); end,
	});
	
	TRP3_RegisterPage({
		id = "dashboard",
		frame = TRP3_Dashboard,
		onPagePostShow = onShow,
	});
	
	TRP3_FieldSet_SetCaption(TRP3_DashboardStatus, loc("DB_STATUS"), 150);
	TRP3_DashboardStatus_CurrentlyText:SetText(loc("DB_STATUS_CURRENTLY"));
	TRP3_SetTooltipForSameFrame(TRP3_DashboardStatus_CurrentlyHelp, "LEFT", 0, 5, loc("DB_STATUS_CURRENTLY"), loc("DB_STATUS_CURRENTLY_TT"));
	TRP3_DashboardStatus_CharactStatus:SetText(loc("DB_STATUS_RP"));
	
	local statusTab = {
		{loc("DB_STATUS_RP_IC"), TRP3_GLOBALS.status.ic},
		{loc("DB_STATUS_RP_OOC"), TRP3_GLOBALS.status.ooc},
	};
	TRP3_ListBox_Setup(TRP3_DashboardStatus_CharactStatusList, statusTab, onStatusChange, nil, 120, true);
	
end