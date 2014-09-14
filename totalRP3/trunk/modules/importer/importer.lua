----------------------------------------------------------------------------------
-- Total RP 3
-- TRP2 / MRP / XRP profiles importer
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--	Copyright 2014 Renaud Parize (renaudparize@gmail.com)
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	-- Public access
	TRP3_API.importer = {};

	-- imports
	local Globals, loc = TRP3_API.globals, TRP3_API.locale.getText;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOGIC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- UI
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	local function refreshDisplay()
		print("refreshDisplay !");
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- INIT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	TRP3_CharacterImporter:SetScript("OnShow", refreshDisplay);

end);