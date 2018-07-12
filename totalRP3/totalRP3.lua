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

---@type TRP3_API
local _, TRP3_API = ...;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- Ellyb imports
local COLORS = TRP3_API.Ellyb.ColorManager;

-- Imports
local Globals = TRP3_API.globals;
local Log = TRP3_API.utils.log;
local loc = TRP3_API.loc;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOADING SEQUENCE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MAIN_SEQUENCE_ID, MAIN_SEQUENCE_DETAIL = "", "";

-- Called when TRP3 is loaded.
function Globals.addon:OnInitialize()
	TRP3_API.utils.event.registerHandler("SAVED_VARIABLES_TOO_LARGE", function(...)
		print(...);
	end);
end

local function loadingSequence()
	Log.log("OnEnable() START");

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
	
	-- Welcome \o/
	MAIN_SEQUENCE_DETAIL = "Welcome message";
	TRP3_API.utils.message.displayMessage(loc.GEN_WELCOME_MESSAGE:format(Globals.version_display));

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

	TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());

	Log.log("OnEnable() DONE");
end

local MAIN_SEQUENCE_ERROR;
-- Called upon PLAYER_LOGIN after all addons are loaded.
function Globals.addon:OnEnable()
	MAIN_SEQUENCE_ID = "OnEnable"
	MAIN_SEQUENCE_DETAIL = "Globals.addon:OnEnable"
	local ticker;
	ticker = C_Timer.NewTicker(0.1, function(self)
		local _, realm = UnitFullName("player")

		if realm then
			-- We finally have realm info, we can cancel the ticket and initialize the addon.
			ticker:Cancel()
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

		if ticker._remainingIterations == 1 then
			MAIN_SEQUENCE_ERROR = "Cannot retrieve realm info from Blizzard's API. Either you are trying to use the add-on on a private server that does not implement Blizzard's functions correctly or there is an issue with the game client."
			TRP3_ShowErrorMessage()
			error("Error during TRP3 loading sequence: " .. MAIN_SEQUENCE_ERROR);
		end
	end, 25);
end

function TRP3_ShowErrorMessage()
	print(COLORS.ORANGE("[TRP3]") .. " " .. COLORS.RED("Error during addon loading sequence:"));
	print(COLORS.ORANGE("Sequence ID: ") .. " " .. MAIN_SEQUENCE_ID);
	print(COLORS.ORANGE("Sub-sequence ID: ") .. " " .. MAIN_SEQUENCE_DETAIL);
	print(COLORS.ORANGE("Error message: ") .. " " .. tostring(MAIN_SEQUENCE_ERROR));
	print(COLORS.ITEM_ARTIFACT("Note: If you just recently updated the add-on, remember that you need to fully relaunch the add-on. Updating while the game client is open will not load new files."));
end
