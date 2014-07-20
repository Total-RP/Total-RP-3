--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Pets/mounts managements : Profile list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, loc = TRP3_API.globals, TRP3_API.locale.getText;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.navigation.menu.id.COMPANIONS_PROFILES = "main_21_companions_profiles";
TRP3_API.navigation.page.id.COMPANIONS_PROFILES = "companions_profiles";

local function onPageShow()
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	registerMenu({
		id = TRP3_API.navigation.menu.id.COMPANIONS_PROFILES,
		text = loc("REG_COMPANIONS_LIST"),
		onSelected = function() setPage(TRP3_API.navigation.page.id.COMPANIONS_PROFILES) end,
		isChildOf = TRP3_API.navigation.menu.id.COMPANIONS_MAIN,
	});
	
	registerPage({
		id = TRP3_API.navigation.page.id.COMPANIONS_PROFILES,
		frame = TRP3_CompanionsProfiles,
		onPagePostShow = function(context)
			onPageShow(context);
		end,
	});
	
end);