--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : About section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local color = TRP3_Color;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_GetDefaultProfile().player = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MAIN
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_InitRegister()
	
end

function TRP3_UI_InitRegister()
	TRP3_RegisterMenu({
		id = "main_00_player",
		text = TRP3_PLAYER,
		onSelected = function() TRP3_SelectMenu("main_01_player_caract"); end,
	});
	
	TRP3_Register_CharInit();
	TRP3_Register_AboutInit();
	TRP3_Register_StyleInit();
	TRP3_Register_CurrentInit();
end