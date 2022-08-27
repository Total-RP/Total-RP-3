-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

local after = C_Timer.After;
local bind = Ellyb.Functions.bind;

local MapScannersManager = {}
local registeredMapScans = {};

--region Total RP 3 imports
local Events = TRP3_API.Events;
--endregion

Events.MAP_SCAN_STARTED = "MAP_SCAN_STARTED"
Events.MAP_SCAN_ENDED = "MAP_SCAN_ENDED"


---@param scan MapScanner
function MapScannersManager.register(scan)
	Ellyb.Assertions.isInstanceOf(scan, AddOn_TotalRP3.MapScanner, "scan");

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
	TRP3_API.MapDataProvider:RemoveAllData();

	-- Save the displayed map ID so we can check that we are still on the requested map when the scan ends
	displayedMapID = AddOn_TotalRP3.Map.getDisplayedMapID()

	scan:ResetScanData();

	local promise = Ellyb.Promise();
	promise:Always(function()
		Events.fireEvent(Events.MAP_SCAN_ENDED)
	end)

	Events.fireEvent(Events.MAP_SCAN_STARTED, scan.duration);
	scan:Scan();

	if scan.duration > 0 then
		-- Resolve the promise after the scan duration
		after(scan.duration, bind(promise.Resolve, promise));
		TRP3_API.WorldMapButton.startCooldown(scan.duration);
		TRP3_API.ui.misc.playSoundKit(40216);
	else
		promise:Resolve();
	end

	promise:Success(function()
		-- If the displayed map changed
		if displayedMapID ~= AddOn_TotalRP3.Map.getDisplayedMapID() then
			return
		end
		scan:OnScanCompleted();
		TRP3_API.MapDataProvider:OnScan(scan:GetData(), scan:GetDataProviderTemplate())
		TRP3_API.ui.misc.playSoundKit(43493);
	end)

	return promise;
end

TRP3_API.MapScannersManager = MapScannersManager;
