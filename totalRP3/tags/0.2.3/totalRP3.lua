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

-- Called when TRP3 is loaded.
function Globals.addon:OnInitialize()
	
end

-- Called upon PLAYER_LOGIN after all addons are loaded.
function Globals.addon:OnEnable()
	Log.log("OnEnable() START");
	Globals.build(); -- Get info we can't have earlier
	
	 -- Welcome \o/
	TRP3_API.utils.message.displayMessage(TRP3_API.locale.getText("GEN_WELCOME_MESSAGE"):format(Globals.version_display));
	
	TRP3_API.flyway.applyPatches(); -- Adapt saved variables structures between versions
	TRP3_API.module.init();
	TRP3_API.module.initModules(); -- Call the init callback on all modules
	
	-- Inits logic
	TRP3_API.locale.init();
	TRP3_API.communication.init();
	TRP3_API.communication.broadcast.init();
	TRP3_API.profile.init();
	TRP3_API.dashboard.init();
	TRP3_API.navigation.init();
	TRP3_API.register.init();
	TRP3_API.popup.init();
	
	TRP3_API.events.fireEvent(TRP3_API.events.WORKFLOW_ON_LOAD);
	
	TRP3_API.module.startModules(); -- Call module callback for all modules (onStart)
	
	TRP3_API.navigation.menu.selectMenu("main_00_dashboard"); -- Select first menu
	
	TRP3_API.events.fireEvent(TRP3_API.events.WORKFLOW_ON_LOADED);
	TRP3_API.events.fireEvent(TRP3_API.events.WORKFLOW_ON_FINISH);
	
	TRP3_API.configuration.constructConfigPage();
	
	Log.log("OnEnable() DONE");
end