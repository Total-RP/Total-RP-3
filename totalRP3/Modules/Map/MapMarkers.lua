-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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
