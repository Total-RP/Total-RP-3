--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Pets/mounts managements
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, loc = TRP3_API.globals, TRP3_API.locale.getText;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onPageShow()
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.register.inits.companionInit()

	registerMenu({
		id = "main_20_companions",
		text = loc("REG_COMPANIONS"),
		onSelected = function() selectMenu("main_21_companions_list") end,
	});
	
	registerMenu({
		id = "main_21_companions_list",
		text = loc("REG_COMPANIONS_LIST"),
		onSelected = function() setPage("companions_list") end,
		isChildOf = "main_20_companions",
	});
	
	registerPage({
		id = "companions_list",
		frame = TRP3_RegisterCompanions,
		onPagePostShow = function(context)
			onPageShow(context);
		end,
	});
	
end