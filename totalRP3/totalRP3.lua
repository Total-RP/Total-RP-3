-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- Imports
local Globals = TRP3.globals;
local loc = TRP3.loc;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOADING SEQUENCE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MAIN_SEQUENCE_ID, MAIN_SEQUENCE_DETAIL = "", "";

-- Called when TRP3 is loaded.
function Globals.addon:OnInitialize()
	TRP3.RegisterCallback(TRP3.GameEvents, "SAVED_VARIABLES_TOO_LARGE", function(_, ...)
		print(...);
	end);
end

local function loadingSequence()
	TRP3.Log("OnEnable() START");

	-- Get info we can't have earlier
	MAIN_SEQUENCE_DETAIL = "Globals.build";
	Globals.build();

	-- Adapt saved variables structures between versions
	MAIN_SEQUENCE_DETAIL = "TRP3.flyway.applyPatches";
	TRP3.flyway.applyPatches();

	MAIN_SEQUENCE_DETAIL = "TRP3.module.init";
	TRP3.module.init();

	-- Call the init callback on all modules
	MAIN_SEQUENCE_DETAIL = "TRP3.module.initModules";
	TRP3.module.initModules();

	MAIN_SEQUENCE_DETAIL = "TRP3.Communications.broadcast.init";
	TRP3.Communications.broadcast.init();
	MAIN_SEQUENCE_DETAIL = "TRP3.profile.init";
	TRP3.profile.init();
	MAIN_SEQUENCE_DETAIL = "TRP3.dashboard.init";
	TRP3.dashboard.init();
	MAIN_SEQUENCE_DETAIL = "TRP3.navigation.init";
	TRP3.navigation.init();
	MAIN_SEQUENCE_DETAIL = "TRP3.register.init";
	TRP3.register.init();
	MAIN_SEQUENCE_DETAIL = "TRP3.popup.init";
	TRP3.popup.init();

	MAIN_SEQUENCE_DETAIL = "TRP3_Addon:TriggerEvent::WORKFLOW_ON_LOAD";
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.WORKFLOW_ON_LOAD);

	-- Call module callback for all modules (onStart)
	MAIN_SEQUENCE_DETAIL = "TRP3.module.startModules";
	TRP3.module.startModules();

	-- Select first menu
	MAIN_SEQUENCE_DETAIL = "TRP3.navigation.menu.selectMenu";
	TRP3.navigation.menu.selectMenu("main_00_dashboard");

	MAIN_SEQUENCE_DETAIL = "TRP3_Addon:TriggerEvent::WORKFLOW_ON_LOADED";
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.WORKFLOW_ON_LOADED);
	MAIN_SEQUENCE_DETAIL = "TRP3_Addon:TriggerEvent::WORKFLOW_ON_FINISH";
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.WORKFLOW_ON_FINISH);

	MAIN_SEQUENCE_DETAIL = "TRP3.configuration.constructConfigPage";
	TRP3.configuration.constructConfigPage();

	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());

	-- Welcome \o/
	MAIN_SEQUENCE_DETAIL = "Welcome message";

	if not TRP3.configuration.getValue("disable_welcome_message") then
		TRP3.utils.message.displayMessage(loc.GEN_WELCOME_MESSAGE:format(Globals.version_display));
	end

	local CHAT_DISABLED_WARNING = "|cnWARNING_FONT_COLOR:" .. loc.GEN_WARNING_CHAT_DISABLED .. "|r";

	TRP3.RegisterCallback(TRP3.GameEvents, "CHAT_DISABLED_CHANGED", function(_, disabled)
		if disabled then
			TRP3.utils.message.displayMessage(CHAT_DISABLED_WARNING);
		end
	end);

	if C_SocialRestrictions.IsChatDisabled() then
		TRP3.utils.message.displayMessage(CHAT_DISABLED_WARNING);
	end

	TRP3.Log("OnEnable() DONE");
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
	print(TRP3.Colors.Orange(("[TRP3: %s]"):format(TRP3.VERSION_DISPLAY)) .. " " .. TRP3.Colors.Red("Error during addon loading sequence:"));
	print(TRP3.Colors.Orange("Sequence ID: ") .. " " .. MAIN_SEQUENCE_ID);
	print(TRP3.Colors.Orange("Sub-sequence ID: ") .. " " .. MAIN_SEQUENCE_DETAIL);
	print(TRP3.Colors.Orange("Error message: ") .. " " .. tostring(MAIN_SEQUENCE_ERROR));
end
