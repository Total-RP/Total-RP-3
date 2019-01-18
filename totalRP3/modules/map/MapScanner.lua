----------------------------------------------------------------------------------
--- Total RP 3
--- ---------------------------------------------------------------------------
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
local Ellyb = TRP3_API.Ellyb;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

--- A MapScanner is module that can be used to scan for things on the map.
--- Create a new MapScanner and override the methods to define the behavior for your MapScanner.
---@class MapScanner : Object
local MapScanner, _private = Ellyb.Class("MapScanner");

---@type Icon
MapScanner.scanIcon = Ellyb.Icon("Inv_misc_enggizmos_20");
MapScanner.scanOptionText = UNKNOWN;
MapScanner.scanTitle = UNKNOWN;
MapScanner.duration = 3;
MapScanner.dataProviderTemplate = "TRP3_PlayerMapPinTemplate";

---@private
function MapScanner:initialize(scanID)
	Ellyb.Assertions.isType(scanID, "string", "scanID");

	_private[self] = {};
	_private[self].scanID = scanID;
	_private[self].scanData = {};

	TRP3_API.MapScannersManager.register(self);
end

---@deprecated scanIcon now HAS to be an instance of Ellyb.Icon
function MapScanner:__newindex(key, value)
	if key == "scanIcon" then
		if not value or not value.class or not value.class.name == "Icon" then
			Ellyb.DeprecationWarnings.warn("MapScanner.scanIcon now requires an instance of an Ellyb.Icon");
			value = Ellyb.Icon(value);
		end
	end
	rawset(self, key, value)
end

function MapScanner:GetID()
	return _private[self].scanID;
end

function MapScanner:GetDataProviderTemplate()
	return self.dataProviderTemplate
end

function MapScanner:OnScanDataReceived(sender, x, y, poiInfo)
	local poiInfoCopy = Ellyb.Tables.copy(poiInfo or {});

	poiInfoCopy.sender = sender;
	poiInfoCopy.position = CreateVector2D(x, y);

	tinsert(_private[self].scanData, poiInfoCopy);
end

function MapScanner:ResetScanData()
	_private[self].scanData = {};
end

function MapScanner:GetData()
	return _private[self].scanData;
end

function MapScanner:GetActionString()
	return self.scanIcon:GenerateString(20) .. " " .. self.scanOptionText;
end

-- This function will be called when the scan is being fired by the user.
-- Override to have your behavior be executed for the scan
--[[Override]] function MapScanner:Scan()

end

-- You can disable your scan for specific situation.
-- Override and return true or false to make the scan available or not.
--[[Override]] function MapScanner:CanScan()
	return true;
end

-- This function will be called when the scan has ended.
-- You can override it if you have something to do at that point.
-- NOTE: This is not where you display the map pins yourself, this is all handled by the MapScannersManager
--[[Override]] function MapScanner:OnScanCompleted()

end

AddOn_TotalRP3.MapScanner = MapScanner
