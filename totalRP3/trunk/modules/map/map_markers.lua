----------------------------------------------------------------------------------
-- Total RP 3
-- Map marker and coordinates system
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

TRP3_API.map = {};

local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local Comm = TRP3_API.communication;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local loc = TRP3_API.locale.getText;
local tinsert, assert, tonumber, pairs, _G, wipe = tinsert, assert, tonumber, pairs, _G, wipe;
local CreateFrame = CreateFrame;
local after = C_Timer.After;
local playAnimation = TRP3_API.ui.misc.playAnimation;

local TRP3_ScanLoaderFramePercent, TRP3_ScanLoaderFrame = TRP3_ScanLoaderFramePercent, TRP3_ScanLoaderFrame;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local SCAN_STRUCTURES = {};

local function registerScan(structure)
	assert(structure and structure.id, "Must have a structure and a structure.id!");
	SCAN_STRUCTURES[structure.id] = structure;
	if structure.scanResponder and structure.scanCommand then
		Comm.broadcast.registerCommand(structure.scanCommand, structure.scanResponder);
	end
	if structure.scanAssembler and structure.scanCommand then
		if not structure.saveStructure then
			structure.saveStructure = {};
		end
		Comm.broadcast.registerP2PCommand(structure.scanCommand, function(...)
			structure.scanAssembler(structure.saveStructure, ...);
		end)
	end

end
TRP3_API.map.registerScan = registerScan;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Display
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local WorldMapTooltip, WorldMapPOIFrame = WorldMapTooltip, WorldMapPOIFrame;
local MARKER_NAME_PREFIX = "TRP3_WordMapMarker";

local function hideAllMarkers()
	local i = 1;
	while(_G[MARKER_NAME_PREFIX .. i]) do
		_G[MARKER_NAME_PREFIX .. i]:Hide();
		i = i + 1;
	end
end

local function displayMarkers(structure)
	if not WorldMapFrame:IsVisible() then
		return;
	end

	local i = 1;
	for key, entry in pairs(structure.saveStructure) do
		local marker = _G[MARKER_NAME_PREFIX .. i];
		if not marker then
			marker = CreateFrame("Frame", MARKER_NAME_PREFIX .. i, WorldMapButton, "WorldMapRaidUnitTemplate");
			marker:SetScript("OnEnter", function(self)
				WorldMapPOIFrame.allowBlobTooltip = false;
				WorldMapTooltip:Hide();
				WorldMapTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
				WorldMapTooltip:AddLine(structure.scanTitle, 1, 1, 1, true);
				local j = 1;
				while(_G[MARKER_NAME_PREFIX .. j]) do
					local markerWidget = _G[MARKER_NAME_PREFIX .. j];
					if markerWidget:IsVisible() and markerWidget:IsMouseOver() then
						local scanLine = markerWidget.scanLine;
						if scanLine then
							WorldMapTooltip:AddLine(scanLine, 1, 1, 1, true);
						end
					end
					j = j + 1;
				end
				WorldMapTooltip:Show();
			end);
			marker:SetScript("OnLeave", function()
				WorldMapPOIFrame.allowBlobTooltip = true;
				WorldMapTooltip:Hide();
			end);
		end

		-- Default implementation
		local x = (entry.x or 0) * WorldMapDetailFrame:GetWidth();
		local y = - (entry.y or 0) * WorldMapDetailFrame:GetHeight();
		marker:ClearAllPoints();
		marker:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", x, y);
		_G[marker:GetName() .. "Icon"]:SetTexture("Interface\\Minimap\\OBJECTICONS");
		_G[marker:GetName() .. "Icon"]:SetTexCoord(0, 0.125, 0, 0.125);

		-- Implementation can be adapted by decorator
		if structure.scanMarkerDecorator then
			structure.scanMarkerDecorator(key, entry, marker);
		end

		marker:Show();
		i = i + 1;
	end
end

local function onActionSelected(scanID)
	assert(SCAN_STRUCTURES[scanID], ("Unknown scan id %s"):format(scanID));
	local structure = SCAN_STRUCTURES[scanID];
	if structure.scan then
		hideAllMarkers();
		wipe(structure.saveStructure);
		structure.scan();
		if structure.scanDuration and structure.scanComplete then
			local mapID = GetCurrentMapAreaID();
			TRP3_WorldMapButton:Disable();
			setupIconButton(TRP3_WorldMapButton, "ability_mage_timewarp");
			TRP3_ScanLoaderFrame.time = structure.scanDuration;
			TRP3_ScanLoaderFrame:Show();
			TRP3_ScanLoaderAnimationRotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderGlowRotation:SetDuration(structure.scanDuration);
			playAnimation(TRP3_ScanLoaderAnimation);
			playAnimation(TRP3_ScanFadeIn);
			playAnimation(TRP3_ScanLoaderGlow);
			after(structure.scanDuration, function()
				TRP3_ScanLoaderAnimation:Stop();
				TRP3_WorldMapButton:Enable();
				setupIconButton(TRP3_WorldMapButton, "icon_treasuremap");
				if mapID == GetCurrentMapAreaID() then
					structure.scanComplete(structure.saveStructure);
					displayMarkers(structure);
				end
				playAnimation(TRP3_ScanFadeOut);
				after(0.2, function()
					TRP3_ScanLoaderFrame:Hide();
				end);
			end);
		end
	end
end

local function onButtonClicked(self)
	local structure = {};
	for scanID, scanStructure in pairs(SCAN_STRUCTURES) do
		if not scanStructure.canScan or scanStructure.canScan() == true then
			tinsert(structure, { Utils.str.icon(scanStructure.buttonIcon or "Inv_misc_enggizmos_20", 25) .. " " .. (scanStructure.buttonText or scanID), scanID});
		end
	end
	if #structure == 0 then
		tinsert(structure, {loc("MAP_BUTTON_NO_SCAN"), nil});
	end
	displayDropDown(self, structure, onActionSelected, 0, true);
end

local currentMapID;

local function onWorldMapUpdate()
	local mapID = GetCurrentMapAreaID();
	if currentMapID ~= mapID and not TRP3_WorldMapButton.doNotHide then
		currentMapID = mapID;
		hideAllMarkers();
	end
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	setupIconButton(TRP3_WorldMapButton, "icon_treasuremap");
	TRP3_WorldMapButton.title = loc("MAP_BUTTON_TITLE");
	TRP3_WorldMapButton.subtitle = "|cffff9900" .. loc("MAP_BUTTON_SUBTITLE");
	TRP3_WorldMapButton:SetScript("OnClick", onButtonClicked);
	TRP3_ScanLoaderFrameScanning:SetText(loc("MAP_BUTTON_SCANNING"));

	TRP3_ScanLoaderFrame:SetScript("OnShow", function(self)
		self.refreshTimer = 0;
	end);
	TRP3_ScanLoaderFrame:SetScript("OnUpdate", function(self, elapsed)
		self.refreshTimer = self.refreshTimer + elapsed;
		local percent = math.ceil((self.refreshTimer / self.time) * 100);
		-- TRP3_ScanLoaderFramePercent:SetText(percent .. "%");
	end);

	Utils.event.registerHandler("WORLD_MAP_UPDATE", onWorldMapUpdate);
end);