-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0
local Ellyb = TRP3.Ellyb;

local MapScannersManager = {}
local registeredMapScans = {};

---@param scan MapScanner
function MapScannersManager.register(scan)
	Ellyb.Assertions.isInstanceOf(scan, TRP3.MapScanner, "scan");

	registeredMapScans[scan:GetID()] = scan;
end

---@return MapScanner[]
function MapScannersManager.getAllScans()
	return registeredMapScans;
end

---@return MapScanner
function MapScannersManager.getByID(scanID)
	assert(registeredMapScans[scanID], ("Unknown scan id %s"):format(scanID));
	return registeredMapScans[scanID]
end

local displayedMapID;
function MapScannersManager.launch(scanID)
	assert(registeredMapScans[scanID], ("Unknown scan id %s"):format(scanID));
	---@type MapScanner
	local scan = registeredMapScans[scanID];
	TRP3.MapDataProvider:RemoveAllData();

	-- Save the displayed map ID so we can check that we are still on the requested map when the scan ends
	displayedMapID = TRP3.Map.getDisplayedMapID()

	scan:ResetScanData();

	local function OnScanTimerElapsed()
		TRP3_Addon:TriggerEvent(TRP3_Addon.Events.MAP_SCAN_ENDED);

		-- If the displayed map changed
		if displayedMapID ~= TRP3.Map.getDisplayedMapID() then
			return
		end
		scan:OnScanCompleted();
		TRP3.MapDataProvider:OnScan(scan:GetData(), scan:GetDataProviderTemplate())
		TRP3.ui.misc.playSoundKit(43493);
	end


	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.MAP_SCAN_STARTED, scan.duration);
	scan:Scan();
	C_Timer.After(scan.duration, OnScanTimerElapsed);
	TRP3.WorldMapButton.startCooldown(scan.duration);
	TRP3.ui.misc.playSoundKit(40216);
end

TRP3.MapScannersManager = MapScannersManager;
