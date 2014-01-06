--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Character list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local color = TRP3_Color;
local loc = TRP3_L;
local get = TRP3_Profile_DataGetter;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function refreshList()
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_ListInit()

	TRP3_RegisterMenu({
		id = "main_10_register",
		text = loc("REG_REGISTER"),
		onSelected = function() TRP3_SetPage("register_list"); end,
	});
	
	TRP3_RegisterPage({
		id = "register_list",
		templateName = "TRP3_RegisterList",
		frameName = "TRP3_RegisterList",
		frame = TRP3_RegisterList,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated",
		onPagePostShow = refreshList,
	});
	
	TRP3_HandleMouseWheel(TRP3_RegisterListContainer, TRP3_RegisterListSlider);
	
end