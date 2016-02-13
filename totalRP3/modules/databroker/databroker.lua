----------------------------------------------------------------------------------
-- Total RP 3
-- Databroker plugins module
--	---------------------------------------------------------------------------
--	Copyright 2014 Renaud Parize (Ellypse) (renaud@parize.me)
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

-- IMPORTS :

-- Lua
local pairs = pairs;

-- LDB
local LDB = LibStub:GetLibrary("LibDataBroker-1.1");

local registeredButtons = {};
local LDBObjects = {};

TRP3_API.databroker = {};

function TRP3_API.databroker.registerButton(name, button)
	registeredButtons[name] = button;
end

local function updateButtons(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
	if (self.TimeSinceLastUpdate > 0.2) then
		self.TimeSinceLastUpdate = 0;
		for name, data in pairs(registeredButtons) do
			if data.OnUpdate then
				data.OnUpdate(LDBObjects[name]);
			end
		end
	end
end
	
local function onStart()
	for name, data in pairs(registeredButtons) do
		local LDBObject = LDB:NewDataObject(name, {
			type= "launcher",
			icon = "Interface\\ICONS\\"..data.icon,
			OnClick = data.OnClick,
			OnTooltipShow = data.OnTooltipShow
		});
		LDBObjects[name] = LDBObject;
	end

	local frame = CreateFrame("FRAME", "TRP3_databroker");
	frame.TimeSinceLastUpdate = 0;
	frame:SetScript("OnUpdate", updateButtons);
	
end

local MODULE_STRUCTURE = {
	["name"] = "Databroker plugins",
	["description"] = "Add several handy actions as plugins for DataBroker add-ons (FuBar, Titan, Bazooka) !",
	["version"] = 1.000,
	["id"] = "trp3_databroker",
	["onStart"] = onStart,
	["minVersion"] = 9,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
