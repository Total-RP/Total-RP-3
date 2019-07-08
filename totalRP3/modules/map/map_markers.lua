----------------------------------------------------------------------------------
--- Total RP 3
--- Map marker and coordinates system
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

TRP3_API.map = {};

local loc = TRP3_API.loc;

-- TODO Assert if this is still needed
TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	TRP3_ScanLoaderFrameScanning:SetText(loc.MAP_BUTTON_SCANNING);

	TRP3_ScanLoaderFrame:SetParent(WorldMapFrame.BorderFrame);
	TRP3_ScanLoaderFrame:ClearAllPoints();
	TRP3_ScanLoaderFrame:SetPoint("CENTER", WorldMapFrame.ScrollContainer, "CENTER");
	TRP3_ScanLoaderFrame:SetScript("OnShow", function(self)
		self.refreshTimer = 0;
	end);
	TRP3_ScanLoaderFrame:SetScript("OnUpdate", function(self, elapsed)
		self.refreshTimer = self.refreshTimer + elapsed;
	end);
end);
