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
local tsize = Utils.table.size;
local getConfigValue = TRP3_API.configuration.getValue;

local CONFIG_UI_ANIMATIONS = "ui_animations";

local TRP3_ScanLoaderFramePercent, TRP3_ScanLoaderFrame = TRP3_ScanLoaderFramePercent, TRP3_ScanLoaderFrame;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GetPlayerMapPosition = GetPlayerMapPosition;
local GetCurrentMapAreaID = GetCurrentMapAreaID;

function TRP3_API.map.getCurrentCoordinates()
	local mapID = GetCurrentMapAreaID();
	local x, y = GetPlayerMapPosition("player");
	return mapID, x, y;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Marker logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local WorldMapTooltip, WorldMapPOIFrame = WorldMapTooltip, WorldMapPOIFrame;
local MARKER_NAME_PREFIX = "TRP3_WordMapMarker";

local MAX_DISTANCE_MARKER = math.sqrt(0.5 * 0.5 + 0.5 * 0.5);

local function hideAllMarkers()
	local i = 1;
	while(_G[MARKER_NAME_PREFIX .. i]) do
		local marker = _G[MARKER_NAME_PREFIX .. i];
		marker:Hide();
		marker.scanLine = nil;
		i = i + 1;
	end
end

local function getMarker(i, tooltip)
	local marker = _G[MARKER_NAME_PREFIX .. i];
	if not marker then
		marker = CreateFrame("Frame", MARKER_NAME_PREFIX .. i, WorldMapButton, "TRP3_WorldMapUnit");
		marker:SetScript("OnEnter", function(self)
			WorldMapPOIFrame.allowBlobTooltip = false;
			WorldMapTooltip:Hide();
			WorldMapTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
			WorldMapTooltip:AddLine(self.tooltip, 1, 1, 1, true);
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
	marker.tooltip = "|cffff9900" .. (tooltip or "");
	return marker;
end

local function placeMarker(marker, x, y)
	local x = (x or 0) * WorldMapDetailFrame:GetWidth();
	local y = - (y or 0) * WorldMapDetailFrame:GetHeight();
	marker:ClearAllPoints();
	marker:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", x, y);
end

local function animateMarker(marker, x, y, directAnimation)
	if getConfigValue(CONFIG_UI_ANIMATIONS) then

		local distanceX = 0.5 - x;
		local distanceY = 0.5 - y;
		local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY);
		local factor = distance/MAX_DISTANCE_MARKER;

		if not directAnimation then
			after(4 * factor, function()
				marker:Show();
				marker:SetAlpha(0);
				playAnimation(marker.Bounce);
			end);
		else
			marker:Show();
			marker:SetAlpha(0);
			playAnimation(marker.Bounce);
		end
	else
		marker:Show();
	end
end

local DECORATION_TYPES = {
	HOUSE = "house",
	CHARACTER = "character"
}
TRP3_API.map.DECORATION_TYPES = DECORATION_TYPES;

local function decorateMarker(marker, decorationType)
	if not decorationType or decorationType == DECORATION_TYPES.CHARACTER then
		marker.Icon:SetTexture("Interface\\Minimap\\OBJECTICONS");
		marker.Icon:SetTexCoord(0, 0.125, 0, 0.125);
	elseif decorationType == DECORATION_TYPES.HOUSE then
		marker.Icon:SetTexture("Interface\\Minimap\\POIICONS");
		marker.Icon:SetTexCoord(0.357143, 0.422, 0, 0.036);
	end
end

local function displayMarkers(structure)
	if not WorldMapFrame:IsVisible() then
		return;
	end

	local count = tsize(structure.saveStructure);
	local i = 1;
	for key, entry in pairs(structure.saveStructure) do
		local marker = getMarker(i, structure.scanTitle);
		placeMarker(marker, entry.x, entry.y);

		decorateMarker(marker, DECORATION_TYPES.CHARACTER);

		-- Implementation can be adapted by decorator
		if structure.scanMarkerDecorator then
			structure.scanMarkerDecorator(key, entry, marker);
		end

		animateMarker(marker, entry.x, entry.y, structure.noAnim);

		i = i + 1;
	end
end

function TRP3_API.map.placeSingleMarker(x, y, tooltip, decorationType)
	hideAllMarkers();
	local marker = getMarker(1, tooltip);
	placeMarker(marker, x, y);
	animateMarker(marker, x, y, true);
	decorateMarker(marker, decorationType);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Scan logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local SCAN_STRUCTURES = {};
local currentMapID;
local launchScan;
local currentlyScanning = false;
local UIDropDownMenu_AddButton, UIDropDownMenu_CreateInfo, UIDropDownMenu_Initialize, UIDropDownMenu_AddSeparator = UIDropDownMenu_AddButton, UIDropDownMenu_CreateInfo, UIDropDownMenu_Initialize, UIDropDownMenu_AddSeparator;

local function insertScansInDropdown(_, level)
	if level==1 then
		local info = UIDropDownMenu_CreateInfo();

		UIDropDownMenu_AddSeparator(info);

		info = UIDropDownMenu_CreateInfo();

		info.isTitle = true;
		info.notCheckable = true;
		info.text = TRP3_API.globals.addon_name;
		UIDropDownMenu_AddButton(info);

		info.isTitle = nil;

		info.func = launchScan;

		if Utils.table.size(SCAN_STRUCTURES) < 1 then
			info.text = loc("MAP_BUTTON_NO_SCAN");
			info.disabled = true;
			UIDropDownMenu_AddButton(info);
		else
			for _, scanStructure in pairs(SCAN_STRUCTURES) do
				info.text = scanStructure.buttonText;
				info.disabled = scanStructure.canScan and scanStructure.canScan(currentlyScanning) ~= true;
				info.value = scanStructure.id;
				UIDropDownMenu_AddButton(info);
			end
		end
	end
end

-- Dirty bug fix for Blizzard's own code...
-- Currently (7.1) the world map filter dropdown is randomly hidden by WORLD_MAP_UPDATE events (constantly fired on the Broken Isles)
-- WorldMapLevelDropDown_Update is being called supposedly to show/hide the dungeon levels dropdown frame,
-- yet when it initializes the dungeon levels dropdown it hides any currently visible dropdown.
-- To workaround that we check if a dropdown is visible before initializing the dungeon level dropdown.
-- Yes, that's dirty, but it's better than what we have now.
local oldWorldMapLevelDropDown_Update = WorldMapLevelDropDown_Update
function WorldMapLevelDropDown_Update()
	if not DropDownList1:IsVisible() then
		oldWorldMapLevelDropDown_Update();
	end
end

local function registerScan(structure)
	assert(structure and structure.id, "Must have a structure and a structure.id!");
	SCAN_STRUCTURES[structure.id] = structure;
	if structure.scanResponder and structure.scanCommand then
		Comm.broadcast.registerCommand(structure.scanCommand, structure.scanResponder);
	end
	if not structure.saveStructure then
		structure.saveStructure = {};
	end
	if structure.scanAssembler and structure.scanCommand then
		Comm.broadcast.registerP2PCommand(structure.scanCommand, function(...)
			structure.scanAssembler(structure.saveStructure, ...);
		end)
	end
end
TRP3_API.map.registerScan = registerScan;

function launchScan(info)
	local scanID = info.value;
	assert(SCAN_STRUCTURES[scanID], ("Unknown scan id %s"):format(scanID));
	local structure = SCAN_STRUCTURES[scanID];
	if structure.scan then
		hideAllMarkers();
		wipe(structure.saveStructure);
		structure.scan(structure.saveStructure);
		if structure.scanDuration then
			local mapID = GetCurrentMapAreaID();
			currentMapID = mapID;
			TRP3_ScanLoaderFrame.time = structure.scanDuration;
			TRP3_ScanLoaderFrame:Show();
			TRP3_ScanLoaderAnimationRotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderGlowRotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderBackAnimation1Rotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderBackAnimation2Rotation:SetDuration(structure.scanDuration);
			playAnimation(TRP3_ScanLoaderAnimation);
			playAnimation(TRP3_ScanFadeIn);
			playAnimation(TRP3_ScanLoaderGlow);
			playAnimation(TRP3_ScanLoaderBackAnimation1);
			playAnimation(TRP3_ScanLoaderBackAnimation2);
			TRP3_API.ui.misc.playSoundKit(40216);
			currentlyScanning = true;
			after(structure.scanDuration, function()
				currentlyScanning = false;
				if mapID == GetCurrentMapAreaID() then
					if structure.scanComplete then
						structure.scanComplete(structure.saveStructure);
					end
					displayMarkers(structure);
					TRP3_API.ui.misc.playSoundKit(43493);
				end
				playAnimation(TRP3_ScanLoaderBackAnimationGrow1);
				playAnimation(TRP3_ScanLoaderBackAnimationGrow2);
				playAnimation(TRP3_ScanFadeOut);
				if getConfigValue(CONFIG_UI_ANIMATIONS) then
					after(1, function()
						TRP3_ScanLoaderFrame:Hide();
						TRP3_ScanLoaderFrame:SetAlpha(1);
					end);
				else
					TRP3_ScanLoaderFrame:Hide();
				end
			end);
		else
			if structure.scanComplete then
				structure.scanComplete(structure.saveStructure);
			end
			displayMarkers(structure);
			TRP3_API.ui.misc.playSoundKit(43493);
		end
	end
end
TRP3_API.map.launchScan = launchScan;

local function onWorldMapUpdate()
	local mapID = GetCurrentMapAreaID();
	if currentMapID ~= mapID then
		currentMapID = mapID;
		hideAllMarkers();
	end
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	TRP3_ScanLoaderFrameScanning:SetText(loc("MAP_BUTTON_SCANNING"));

	TRP3_ScanLoaderFrame:SetScript("OnShow", function(self)
		self.refreshTimer = 0;
	end);
	TRP3_ScanLoaderFrame:SetScript("OnUpdate", function(self, elapsed)
		self.refreshTimer = self.refreshTimer + elapsed;
	end);

	Utils.event.registerHandler("WORLD_MAP_UPDATE", onWorldMapUpdate);
end);

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	-- Hook the WorldMapTrackingOptionsDropDown_Initialize to add our own options inside the dropdown menu securely
	hooksecurefunc("WorldMapTrackingOptionsDropDown_Initialize", insertScansInDropdown);
	UIDropDownMenu_Initialize(WorldMapFrameDropDown, WorldMapTrackingOptionsDropDown_Initialize, "MENU");

	after(5, function()

		-- If the PetTracker add-on is installed it will mess with the world map filter dropdown by overriding it
		-- removing all the options added by other add-ons... (╯°□°）╯︵ ┻━┻
		-- Bad PetTracker, no cookie for you ☜(`o´)
		-- So let's fix that shit, shall we? ٩(^ᴗ^)۶
		if PetTracker then

			-- First we restore the OnClick script of the filter button ┬─┬ノ( º _ ºノ)
			WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button:SetScript('OnClick', function(self)
				local parent = self:GetParent();
				ToggleDropDownMenu(1, nil, parent.DropDown, parent, 0, -5);
				PlaySound("igMainMenuOptionCheckBoxOn");
			end)

			-- Now, because we are nice (sort of),
			-- we will insert PetTracker's options inside the dropdown the right way (✿°◡°)
			hooksecurefunc("WorldMapTrackingOptionsDropDown_Initialize", function(self, level, ...)
				if level==1 then
					local info = UIDropDownMenu_CreateInfo()

					UIDropDownMenu_AddSeparator(info);

					info = UIDropDownMenu_CreateInfo();

					-- Insert a nice header for PetTracker
					info.isTitle = true;
					info.notCheckable = true;
					info.text = "PetTracker";
					UIDropDownMenu_AddButton(info);

					info = UIDropDownMenu_CreateInfo();

					-- Toggle pets blips
					info.text = PETS
					info.func = function() PetTracker.WorldMap:Toggle('Species') end
					info.checked = PetTracker.WorldMap:Active('Species')
					info.isNotRadio = true
					info.keepShownOnClick = true
					UIDropDownMenu_AddButton(info)

					-- Toggle stable blips
					info.text = STABLES
					info.func = function() PetTracker.WorldMap:Toggle('Stables') end
					info.checked = PetTracker.WorldMap:Active('Stables')
					info.isNotRadio = true
					info.keepShownOnClick = true
					UIDropDownMenu_AddButton(info)
				end
			end)
			UIDropDownMenu_Initialize(WorldMapFrameDropDown, WorldMapTrackingOptionsDropDown_Initialize, "MENU")
		end
	end)
end);