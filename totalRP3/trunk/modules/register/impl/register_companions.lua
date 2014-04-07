--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Pets/mounts managements
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, loc = TRP3_GLOBALS, TRP3_L;
local registerMenu = TRP3_NAVIGATION.menu.registerMenu;
local registerPage, setPage = TRP3_NAVIGATION.page.registerPage, TRP3_NAVIGATION.page.setPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onPageShow()
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_REGISTER.initPets = function()

	registerMenu({
		id = "main_10_player_02_companions",
		text = loc("REG_COMPANIONS"),
		onSelected = function() setPage("player_companions") end,
		isChildOf = "main_10_player",
	});
	
	registerPage({
		id = "player_companions",
		frame = TRP3_RegisterCompanions,
		onPagePostShow = function(context)
			onPageShow(context);
		end,
	});
	
end