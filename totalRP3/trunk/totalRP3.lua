--[[
	Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
	This file stores :
	- Loading sequence & event dispatching
	- Libs management
--]]

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Libs management
-- AceSerializer is used for the communication serialization/dezerialization
-- AceCommand is used for TRP3 console commands handling
-- AceTimer is used for handling some generic timers
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local trp3Addon = LibStub("AceAddon-3.0"):NewAddon(TRP3_ADDON_NAME, "AceSerializer-3.0", "AceConsole-3.0", "AceTimer-3.0");
local log = TRP3_Log;

-- Returns the Ace addon object representing TRP3. All libs calls can be made on this object.
function TRP3_GetAddon()
	return trp3Addon;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOADING SEQUENCE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Called when TRP3 is loaded.
function trp3Addon:OnInitialize()
	
end

-- Called upon PLAYER_LOGIN after all addons are loaded.
function trp3Addon:OnEnable()
	log("OnEnable() START");
	
	TRP3_Flyway_Patches(); -- Adapt saved variables structures between versions
	TRP3_ModuleManagement_Init();
	TRP3_InitModules();
	
	-- Inits impl
	TRP3_InitConfiguration();
	TRP3_InitLocalization(TRP3_GetConfigValue("Locale"));
	TRP3_InitCommunicationProtocol();
	TRP3_InitProfiles();
	TRP3_InitRegister();
	
	-- Inits UI
	TRP3_UI_PlaceMinimapIcon();
	TRP3_UI_InitToolbar();
	TRP3_UI_InitMainPage();
	TRP3_UI_InitConfiguration();
	TRP3_UI_InitRegister();
	TRP3_UI_InitPopups();
	
	TRP3_LoadProfile(); -- Load profile
	TRP3_SelectMenu("main_00_player"); -- Select first menu
	print(TRP3_L("GEN_WELCOME_MESSAGE")); -- Welcome \o/
	-- Version \o/
	print(TRP3_L("GEN_WELCOME_VERSION"):format(TRP3_VERSION_USER));
	TRP3_MainFrameVersionText:SetText(TRP3_L("GEN_VERSION"):format(TRP3_VERSION_USER));
	
	TRP3_StartModules();
	
	-- Must be called after module start.
	TRP3_Configuration_OnModuleLoaded();
	
	log("OnEnable() DONE");
end