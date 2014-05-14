--[[
	Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--]]

-- Imports
local Globals = TRP3_GLOBALS;
local Log = TRP3_UTILS.log;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOADING SEQUENCE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Called when TRP3 is loaded.
function Globals.addon:OnInitialize()
	
end

-- Called upon PLAYER_LOGIN after all addons are loaded.
function Globals.addon:OnEnable()
	Log.log("OnEnable() START");
	Globals.build(); -- Get info we can't have earlier
	
	TRP3_Flyway_Patches(); -- Adapt saved variables structures between versions
	TRP3_MODULE.init();
	TRP3_MODULE.initModules();
	
	-- Inits logic
	TRP3_LOCALE.init();
	TRP3_COMM.init();
	TRP3_COMM.broadcast.init();
	TRP3_InitProfiles();
	TRP3_InitRegister();
	TRP3_TOOLBAR.init();
	TRP3_DASHBOARD.init();
	TRP3_TARGET_FRAME.init();
	TRP3_InitMinimapButton();
	TRP3_NAVIGATION.Init();
	TRP3_UI_InitRegister();
	TRP3_UI_InitPopups();
	TRP3_UI_InitConfiguration();
	
	TRP3_LoadProfile(); -- Load profile
	print(TRP3_L("GEN_WELCOME_MESSAGE")); -- Welcome \o/
	-- Version \o/
	print(TRP3_L("GEN_WELCOME_VERSION"):format(Globals.version_display));
	TRP3_MainFrameVersionText:SetText(TRP3_L("GEN_VERSION"):format(Globals.version_display));
	
	TRP3_MODULE.startModules();
	
	-- Must be called after module start.
	TRP3_MODULE.onModuleStarted();
	
	TRP3_NAVIGATION.menu.selectMenu("main_00_dashboard"); -- Select first menu
	
	Log.log("OnEnable() DONE");
end