-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- Imports
local Globals = TRP3_API.globals;
local loc = TRP3_API.loc;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOADING SEQUENCE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MAIN_SEQUENCE_ID, MAIN_SEQUENCE_DETAIL = "", "";

-- Called when TRP3 is loaded.
function Globals.addon:OnInitialize()
	TRP3_API.RegisterCallback(TRP3_API.GameEvents, "SAVED_VARIABLES_TOO_LARGE", function(_, ...)
		print(...);
	end);
end

local function loadingSequence()
	TRP3_API.Log("OnEnable() START");

	-- Get info we can't have earlier
	MAIN_SEQUENCE_DETAIL = "Globals.build";
	Globals.build();

	-- Adapt saved variables structures between versions
	MAIN_SEQUENCE_DETAIL = "TRP3_API.flyway.applyPatches";
	TRP3_API.flyway.applyPatches();

	-- Inits locale
	MAIN_SEQUENCE_DETAIL = "TRP3_API.Locale.init";
	TRP3_API.Locale.init();

	MAIN_SEQUENCE_DETAIL = "TRP3_API.module.init";
	TRP3_API.module.init();

	-- Call the init callback on all modules
	MAIN_SEQUENCE_DETAIL = "TRP3_API.module.initModules";
	TRP3_API.module.initModules();

	MAIN_SEQUENCE_DETAIL = "AddOn_TotalRP3.Communications.broadcast.init";
	AddOn_TotalRP3.Communications.broadcast.init();
	MAIN_SEQUENCE_DETAIL = "TRP3_API.profile.init";
	TRP3_API.profile.init();
	MAIN_SEQUENCE_DETAIL = "TRP3_API.dashboard.init";
	TRP3_API.dashboard.init();
	MAIN_SEQUENCE_DETAIL = "TRP3_API.navigation.init";
	TRP3_API.navigation.init();
	MAIN_SEQUENCE_DETAIL = "TRP3_API.register.init";
	TRP3_API.register.init();
	MAIN_SEQUENCE_DETAIL = "TRP3_API.popup.init";
	TRP3_API.popup.init();

	MAIN_SEQUENCE_DETAIL = "TRP3_Addon:TriggerEvent::WORKFLOW_ON_LOAD";
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.WORKFLOW_ON_LOAD);

	-- Call module callback for all modules (onStart)
	MAIN_SEQUENCE_DETAIL = "TRP3_API.module.startModules";
	TRP3_API.module.startModules();

	-- Select first menu
	MAIN_SEQUENCE_DETAIL = "TRP3_API.navigation.menu.selectMenu";
	TRP3_API.navigation.menu.selectMenu("main_00_dashboard");

	MAIN_SEQUENCE_DETAIL = "TRP3_Addon:TriggerEvent::WORKFLOW_ON_LOADED";
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.WORKFLOW_ON_LOADED);
	MAIN_SEQUENCE_DETAIL = "TRP3_Addon:TriggerEvent::WORKFLOW_ON_FINISH";
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.WORKFLOW_ON_FINISH);

	MAIN_SEQUENCE_DETAIL = "TRP3_API.configuration.constructConfigPage";
	TRP3_API.configuration.constructConfigPage();

	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());

	-- Welcome \o/
	MAIN_SEQUENCE_DETAIL = "Welcome message";

	if not TRP3_API.configuration.getValue("disable_welcome_message") then
		TRP3_API.utils.message.displayMessage(loc.GEN_WELCOME_MESSAGE:format(Globals.version_display));
	end

	TRP3_API.Log("OnEnable() DONE");
end

local MAIN_SEQUENCE_ERROR;
-- Called upon PLAYER_LOGIN after all addons are loaded.
function Globals.addon:OnEnable()
	MAIN_SEQUENCE_ID = "Globals.addon:OnEnable";
	if not Globals.DEBUG_MODE then
		local ok, errorMessage = pcall(loadingSequence);
		if not ok then
			MAIN_SEQUENCE_ERROR = errorMessage;
			TRP3_ShowErrorMessage();
			error("Error during TRP3 loading sequence: " .. errorMessage);
		end
	else
		loadingSequence();
	end
end

function TRP3_ShowErrorMessage()
	print(TRP3_API.Colors.Orange(("[TRP3: %s]"):format(TRP3_API.VERSION_DISPLAY)) .. " " .. TRP3_API.Colors.Red("Error during addon loading sequence:"));
	print(TRP3_API.Colors.Orange("Sequence ID: ") .. " " .. MAIN_SEQUENCE_ID);
	print(TRP3_API.Colors.Orange("Sub-sequence ID: ") .. " " .. MAIN_SEQUENCE_DETAIL);
	print(TRP3_API.Colors.Orange("Error message: ") .. " " .. tostring(MAIN_SEQUENCE_ERROR));
end
