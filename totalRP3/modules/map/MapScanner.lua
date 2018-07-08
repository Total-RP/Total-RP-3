----------------------------------------------------------------------------------
--- Total RP 3
---	---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

local assert = assert;
local isType = Ellyb.Assertions.isType;
local isInstanceOf = Ellyb.Assertions.isInstanceOf;
local After = C_Timer.After;

---@class MapScanner : Object
local MapScanner, _private = Ellyb.Class("MapScanner");

MapScanner.scanIcon = "Inv_misc_enggizmos_20";
MapScanner.scanOptionText = UNKNOWN;
MapScanner.scanTitle = UNKNOWN;
MapScanner.duration = 3;
MapScanner.dataProviderTemplate = "TRP3_PlayerMapPinTemplate";

function MapScanner:initialize(scanID)
	assert(isType(scanID, "string", "scanID"));

	_private[self] = {};
	_private[self].scanID = scanID;

	TRP3_API.MapScannersManager.registerScan(self);
end

function MapScanner:GetID()
	return _private[self].scanID;
end

function MapScanner:GetDataProviderTemplate()
	return self.dataProviderTemplate
end

--[[Override]] function MapScanner:Scan()

end

--[[Override]] function MapScanner:OnScanRequestReceived(sender, ...)

end

--[[Override]] function MapScanner:CanScan()
	return true;
end

--[[Override]] function MapScanner:OnScanResultReceived(sender, ...)

end

--[[Override]] function MapScanner:OnScanCompleted()

end

--[[Override]] function MapScanner:DecorateDataProviderPOI(marker, info)

end

--[[Override]] function MapScanner:GetData()
	return {}
end

AddOn_TotalRP3.MapScanner = MapScanner