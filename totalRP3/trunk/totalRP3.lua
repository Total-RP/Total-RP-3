----------------------------------------------------------------------------------
-- Total RP 3
-- This file contains the addon main loading sequence.
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- Imports
local Globals = TRP3_API.globals;
local Log = TRP3_API.utils.log;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOADING SEQUENCE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MAIN_SEQUENCE_ID, MAIN_SEQUENCE_DETAIL = "", "";

-- Called when TRP3 is loaded.
function Globals.addon:OnInitialize()

end

local function loadingSequence()
	Log.log("OnEnable() START");

	-- Get info we can't have earlier
	MAIN_SEQUENCE_DETAIL = "Globals.build";
	Globals.build();

	-- Welcome \o/
	MAIN_SEQUENCE_DETAIL = "Welcome message";
	TRP3_API.utils.message.displayMessage(TRP3_API.locale.getText("GEN_WELCOME_MESSAGE"):format(Globals.version_display));

	-- Adapt saved variables structures between versions
	MAIN_SEQUENCE_DETAIL = "TRP3_API.flyway.applyPatches";
	TRP3_API.flyway.applyPatches();

	MAIN_SEQUENCE_DETAIL = "TRP3_API.module.init";
	TRP3_API.module.init();

	-- Call the init callback on all modules
	MAIN_SEQUENCE_DETAIL = "TRP3_API.module.initModules";
	TRP3_API.module.initModules();

	-- Inits logic
	MAIN_SEQUENCE_DETAIL = "TRP3_API.locale.init";
	TRP3_API.locale.init();
	MAIN_SEQUENCE_DETAIL = "TRP3_API.communication.init";
	TRP3_API.communication.init();
	MAIN_SEQUENCE_DETAIL = "TRP3_API.communication.broadcast.init";
	TRP3_API.communication.broadcast.init();
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

	MAIN_SEQUENCE_DETAIL = "TRP3_API.events.fireEvent::WORKFLOW_ON_LOAD";
	TRP3_API.events.fireEvent(TRP3_API.events.WORKFLOW_ON_LOAD);

	-- Call module callback for all modules (onStart)
	MAIN_SEQUENCE_DETAIL = "TRP3_API.module.startModules";
	TRP3_API.module.startModules();

	-- Select first menu
	MAIN_SEQUENCE_DETAIL = "TRP3_API.navigation.menu.selectMenu";
	TRP3_API.navigation.menu.selectMenu("main_00_dashboard");

	MAIN_SEQUENCE_DETAIL = "TRP3_API.events.fireEvent::WORKFLOW_ON_LOADED";
	TRP3_API.events.fireEvent(TRP3_API.events.WORKFLOW_ON_LOADED);
	MAIN_SEQUENCE_DETAIL = "TRP3_API.events.fireEvent::WORKFLOW_ON_FINISH";
	TRP3_API.events.fireEvent(TRP3_API.events.WORKFLOW_ON_FINISH);

	MAIN_SEQUENCE_DETAIL = "TRP3_API.configuration.constructConfigPage";
	TRP3_API.configuration.constructConfigPage();

	Log.log("OnEnable() DONE");
end

-- Called upon PLAYER_LOGIN after all addons are loaded.
function Globals.addon:OnEnable()
	MAIN_SEQUENCE_ID = "Globals.addon:OnEnable";
	local ok, errorMessage = pcall(loadingSequence);
	if not ok then
		MAIN_SEQUENCE_ERROR = errorMessage;
		TRP3_ShowErrorMessage();
		error("Error during TRP3 loading sequence: " .. errorMessage);
	end
end

function TRP3_ShowErrorMessage()
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(("[|cffffaa00TRP3|r] |cffff0000Error during addon loading sequence:\n|cffff7700Sequence ID: |r%s\n|cffff7700Sub-sequence ID: |r%s\n|cffff7700Error message: |r%s"):format(MAIN_SEQUENCE_ID, MAIN_SEQUENCE_DETAIL, tostring(MAIN_SEQUENCE_ERROR)), 1, 1, 1);
	end
end