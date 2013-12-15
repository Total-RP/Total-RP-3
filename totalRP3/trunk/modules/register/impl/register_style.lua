--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : RP Style section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local color = TRP3_Color;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--TRP3_GetDefaultProfile().player.style = {
--	vernum = 1,
--}

-- Mock
TRP3_GetDefaultProfile().player.style = {
	vernum = 1,
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Roleplay style
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_StyleInit()
	TRP3_RegisterMenu({
		id = "main_03_player_style",
		text = TRP3_L("REG_PLAYER_STYLE"),
		isChildOf = "main_00_player",
		onSelected = function()  end,
	});
end