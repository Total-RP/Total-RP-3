-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local _, TRP3_API = ...;

-- TRP3_API imports.
local L = TRP3_API.loc;
local TRP3_Companions = TRP3_API.companions;
local TRP3_Events = TRP3_API.events;
local TRP3_UI = TRP3_API.ui;
local TRP3_Utils = TRP3_API.utils;

-- AddOn_TotalRP3 imports.
local MSP = AddOn_TotalRP3.MSP;
local Player = AddOn_TotalRP3.Player;

-- Ellyb imports.
local Color = TRP3_API.Ellyb.Color;
local ColorManager = TRP3_API.Ellyb.ColorManager;

-- Maximum width for displayed titles.
local MAX_TITLE_SIZE = 40;

-- Returns true if the given unit token refers to a combat companion pet.
--
-- Returns false if the unit is invalid, refers to a player, or is a
-- battle pet companion.
local function UnitIsCombatPet(unitToken)
	-- Ensure battle pets don't accidentally pass this test, in case one
	-- day they get nameplates added for no reason.
	if UnitIsBattlePetCompanion(unitToken) then
		return false;
	end

	return UnitIsOtherPlayersPet(unitToken) or UnitIsUnit(unitToken, "pet");
end

-- Returns the TRP3 API internal "unit ID" for a given unit token. This will
-- typically be a "name-realm" string for a player, or a "name-realm_pet"
-- for a companion pet.
local function GetRegisterUnitID(unitToken)
	if UnitIsPlayer(unitToken) then
		return TRP3_Utils.str.getUnitID(unitToken);
	elseif UnitIsCombatPet(unitToken) then
		local companionType = TRP3_UI.misc.TYPE_PET;
		return TRP3_UI.misc.getCompanionFullID(unitToken, companionType);
	end
end

-- Returns the player model associated with the given unit token.
--
-- If no valid model can be found, nil is returned.
local function GetPlayerProfile(unitToken)
	local name, realm = UnitName(unitToken)
	if not name or name == "" or name == UNKNOWNOBJECT then
		-- Don't return profiles for invalid/unknown units.
		return nil;
	end

	return Player.CreateFromNameAndRealm(name, realm);
end

-- Returns the (combat) pet companion profile associated with the given
-- unit token.
--
-- If no profile can be found, nil is returned.
local function GetCombatPetProfile(unitToken)
	local companionType = TRP3_UI.misc.TYPE_PET;
	local fullID = TRP3_UI.misc.getCompanionFullID(unitToken, companionType);
	if not fullID then
		return nil;
	end

	local profile = TRP3_Companions.register.getCompanionProfile(fullID);
	if not profile then
		return nil;
	end

	return profile.data;
end

-- Nameplate module table.
local TRP3_NamePlates = {};

-- Handler called when the module is being initialized. This is responsible
-- for setting up the base internal state without actually enabling any
-- behaviours.
function TRP3_NamePlates:OnInitialize()
	self.activeUnitTokens = {};
	self.registerUnitIDMap = {};
	self.unitFrameWidgets = {};

	self.fontStringPool = CreateFontStringPool(UIParent, "ARTWORK", 0, "SystemFont_NamePlate");
end

-- Handler called when the module is started up. This is responsible for
-- fully starting the module, registering events and hooks as needed.
function TRP3_NamePlates:OnEnable()
	-- Register events and script handlers.
	local eventFrame = CreateFrame("Frame");
	eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
	eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
	eventFrame:SetScript("OnEvent", function(_, ...)
		return self:OnEvent(...);
	end);

	-- Register internal events.
	TRP3_Events.registerCallback("MOUSE_OVER_CHANGED", function(...)
		self:OnMouseOverChanged(...);
	end);

	TRP3_Events.registerCallback("REGISTER_DATA_UPDATED", function(...)
		self:OnRegisterDataUpdated(...);
	end);

	-- Install hooks.
	hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		return self:OnUnitFrameNameChanged(frame);
	end);
end

-- Handler dispatched in response to in-game events.
function TRP3_NamePlates:OnEvent(event, ...)
	if event == "NAME_PLATE_UNIT_ADDED" then
		self:OnNamePlateUnitAdded(...);
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		self:OnNamePlateUnitRemoved(...);
	end
end

--- Handler triggered when the player mouses over an in-game unit.
function TRP3_NamePlates:OnMouseOverChanged(targetID)
	-- Try and convert the target ID (a register-internal ID) to that of
	-- a unit token and force-refresh the frame. This can be used as a
	-- get-out-of-jail card if there's some issue updating nameplates.
	local unitToken = self.registerUnitIDMap[targetID];
	if not unitToken then
		return;
	end

	self:UpdateUnitToken(unitToken);
end

-- Handler triggered then the game creates a name plate unit token.
function TRP3_NamePlates:OnNamePlateUnitAdded(unitToken)
	-- Flag the unit as active.
	self.activeUnitTokens[unitToken] = true;

	-- Map the unit token to a register-local unit ID for updates.
	local registerUnitID = GetRegisterUnitID(unitToken);
	if registerUnitID then
		self.registerUnitIDMap[registerUnitID] = unitToken;
	end

	-- Initialize the unit frame.
	local frame = self:GetUnitFrameForUnit(unitToken);
	if frame then
		self:SetUpUnitFrame(frame, unitToken);
	end

	-- Update the unit frame for them immediately. It might not be fully
	-- configured at this point, however our hooks will fire if that's the
	-- case anyway.
	self:UpdateUnitToken(unitToken);

	-- Send out a request for the profile.
	if registerUnitID then
		TRP3_API.r.sendQuery(registerUnitID);

		if UnitIsPlayer(unitToken) then
			msp:Request(registerUnitID, MSP.REQUEST_FIELDS);
		end
	end
end

-- Handler triggered then the game removes a name plate unit token.
function TRP3_NamePlates:OnNamePlateUnitRemoved(unitToken)
	-- Remove additional customizations that might be attached to the frame.
	local frame = self:GetUnitFrameForUnit(unitToken);
	if frame then
		self:TearDownUnitFrame(frame, unitToken);
	end

	-- Remove any mappings from register unit IDs to this unit token.
	for registerUnitID, storedUnitToken in pairs(self.registerUnitIDMap) do
		if unitToken == storedUnitToken then
			self.registerUnitIDMap[registerUnitID] = nil;
		end
	end

	-- Flag the unit as inactive.
	self.activeUnitTokens[unitToken] = nil;
end

-- Handler triggered when TRP updates the registry for a named profile.
function TRP3_NamePlates:OnRegisterDataUpdated(registerUnitID)
	-- Try and get a unit token from the internal unit ID.
	local unitToken = self.registerUnitIDMap[registerUnitID];
	if not unitToken then
		return;
	end

	self:UpdateUnitToken(unitToken);
end

-- Handler triggered when the name on a unit frame is modified by the UI.
function TRP3_NamePlates:OnUnitFrameNameChanged(frame)
	-- Update the name portion of the unit frame.
	self:UpdateUnitFrameName(frame, frame.unit);
end

-- Returns true if the given unit token is actively tracked as belonging
-- to a nameplate.
function TRP3_NamePlates:IsTrackedUnit(unitToken)
	return not not self.activeUnitTokens[unitToken];
end

-- Returns the unit frame on a name plate for the given unit token, or nil
-- if the given token is invalid.
function TRP3_NamePlates:GetUnitFrameForUnit(unitToken)
	local frame = C_NamePlate.GetNamePlateForUnit(unitToken);
	if not frame or not frame.UnitFrame then
		return nil;
	end

	return frame.UnitFrame;
end

-- Returns a named widget for a unit frame, or nil if the widget doesn't
-- exist.
function TRP3_NamePlates:GetUnitFrameWidget(frame, widgetName)
	local widgets = self.unitFrameWidgets[frame];
	if not widgets then
		return nil;
	end

	return widgets[widgetName];
end

-- Acquires a named widget for a unit frame, sourcing it from the given
-- pool and returning it.
--
-- This function will return nil if the given frame is forbidden, and
-- no widget will be acquired.
function TRP3_NamePlates:AcquireUnitFrameWidget(frame, widgetName, pool)
	-- Don't add widgets to locked down frames.
	if not CanAccessObject(frame) then
		return nil;
	end

	-- We'll store widget sets keyed by the frame. Frames themselves are
	-- pooled, so this won't leak anything.
	local widgets = self.unitFrameWidgets[frame] or {};
	self.unitFrameWidgets[frame] = widgets;

	-- There's a few cases where widgets don't get cleaned up if you toggle,
	-- but that's fine. We'll just re-use them even if they weren't put back
	-- into the pool.
	local widget = widgets[widgetName] or pool:Acquire();
	widgets[widgetName] = widget;
	return widget;
end

-- Acquires a font string widget and assigns it to the given frame.
function TRP3_NamePlates:AcquireUnitFrameFontString(frame, widgetName)
	return self:AcquireUnitFrameWidget(frame, widgetName, self.fontStringPool);
end

-- Releases a named widget from a unit frame, placing it back into the
-- given pool.
function TRP3_NamePlates:ReleaseUnitFrameWidget(frame, widgetName, pool)
	-- Don't release widget from to locked down frames. These should never
	-- have had them added in the first place, so this should be fine.
	if not CanAccessObject(frame) then
		return;
	end

	local widgets = self.unitFrameWidgets[frame];
	if not widgets then
		return;
	end

	local widget = widgets[widgetName];
	if not widget then
		return;
	end

	-- Remove the widget from the UI as much as possible.
	pool:Release(widget);
	widgets[widgetName] = nil;
end

-- Releases a named font string widget from a unit frame.
function TRP3_NamePlates:ReleaseUnitFrameFontString(frame, widgetName)
	return self:ReleaseUnitFrameWidget(frame, widgetName, self.fontStringPool);
end

-- Sets up custom widgets and modifications on a unit frame.
function TRP3_NamePlates:SetUpUnitFrame(frame, unitToken)
	self:SetUpUnitFrameTitle(frame, unitToken);
end

-- Updates the given unit frame, applying changes for the profile represented
-- by the given unit token.
function TRP3_NamePlates:UpdateUnitFrame(frame, unitToken)
	-- Update all portions of the unit frame.
	self:UpdateUnitFrameName(frame, unitToken);
	self:UpdateUnitFrameTitle(frame, unitToken);
end

-- Tears down custom widgets and modifications from a unit frame.
function TRP3_NamePlates:TearDownUnitFrame(frame, unitToken)
	self:TearDownUnitFrameTitle(frame, unitToken);
end

-- Updates the name display on a given unit frame, applying changes for the
-- profile represented by the given unit token.
function TRP3_NamePlates:UpdateUnitFrameName(frame, unitToken)
	-- Ignore forbidden frames and bad units.
	if not CanAccessObject(frame) or not self:IsTrackedUnit(unitToken) then
		return;
	end

	-- Ignore frames where the name is hidden. This usually implies they
	-- configured a setting somewhere to prevent the name being shown.
	if not frame.name:IsShown() then
		return;
	end

	-- The name to show in the nameplate, if not nil.
	local nameText;
	-- The color to apply to the name, if not nil.
	local nameColor;

	-- Are we altering a player name plate?
	if UnitIsPlayer(unitToken) then
		-- Get the profile for the player and their preferred options.
		local profile = GetPlayerProfile(unitToken);
		if not profile then
			return;
		end

		nameText = profile:GetRoleplayingName();
		nameColor = profile:GetCustomColorForDisplay();

		-- If there is no color, try class coloring instead.
		if not nameColor then
			local _, class = UnitClass(unitToken);
			nameColor = C_ClassColor.GetClassColor(class);
		end
	elseif UnitIsCombatPet(unitToken) then
		-- Combat pets use companion pet profiles, which aren't as nice.
		local profile = GetCombatPetProfile(unitToken);
		if not profile then
			return;
		end

		nameText = profile.NA;
		nameColor = profile.NH and Color.CreateFromHexa(profile.NH) or nil;
	end

	-- Apply changes where we can.
	if nameText then
		frame.name:SetText(nameText);
	end

	if nameColor then
		-- While SetTextColor might be more obvious, Blizzard instead calls
		-- SetVertexColor. We mirror to ensure things work.
		frame.name:SetVertexColor(nameColor:GetRGBA());
	end
end

-- Initializes the custom RP title widget on a unit frame.
function TRP3_NamePlates:SetUpUnitFrameTitle(frame, unitToken)
	-- Ignore forbidden frames and bad units.
	if not CanAccessObject(frame) or not self:IsTrackedUnit(unitToken) then
		return;
	end

	local title = self:AcquireUnitFrameFontString(frame, "title");
	if not title then
		return;
	end

	-- Set up anchoring and reparent.
	title:ClearAllPoints();
	title:SetParent(frame);
	title:SetPoint("TOP", frame.name, "BOTTOM", 0, -4);
	title:SetVertexColor(ColorManager.ORANGE:GetRGBA());
	title:Show();
end

-- Updates the title display on a name plate.
function TRP3_NamePlates:UpdateUnitFrameTitle(frame, unitToken)
	-- Ignore forbidden frames and bad units.
	if not CanAccessObject(frame) or not self:IsTrackedUnit(unitToken) then
		return;
	end

	-- Get the title widget if one was allocated.
	local titleWidget = self:GetUnitFrameWidget(frame, "title");
	if not titleWidget then
		return;
	end

	local titleText;

	if UnitIsPlayer(unitToken) then
		local profile = GetPlayerProfile(unitToken);
		local characteristics = profile and profile:GetCharacteristics();
		if characteristics then
			titleText = characteristics.FT;
		end
	elseif UnitIsCombatPet(unitToken) then
		local profile = GetCombatPetProfile(unitToken);
		if profile then
			titleText = profile.TI;
		end
	end

	-- If there's no title text, we'll hide it entirely.
	if not titleText or titleText == "" then
		titleWidget:Hide();
		return;
	end

	-- Crop titles and format them appropriately.
	titleText = format("<%s>", TRP3_Utils.str.crop(titleText, MAX_TITLE_SIZE));

	titleWidget:SetText(titleText);
	titleWidget:Show();
end

-- Deinitializes the custom RP title widget on a unit frame.
function TRP3_NamePlates:TearDownUnitFrameTitle(frame, unitToken)
	-- Ignore forbidden frames and bad units.
	if not CanAccessObject(frame) or not self:IsTrackedUnit(unitToken) then
		return;
	end

	self:ReleaseUnitFrameFontString(frame, "title");
end

-- Updates all modified unit frames.
function TRP3_NamePlates:UpdateAllUnitFrames()
	self:UpdateAllUnits();
end

-- Updates the nameplate frame for a given unit token.
function TRP3_NamePlates:UpdateUnitToken(unitToken)
	local frame = self:GetUnitFrameForUnit(unitToken);
	if not frame then
		return;
	end

	self:UpdateUnitFrame(frame, unitToken);
end

-- Updates all nameplate frames for actively tracked unit tokens.
function TRP3_NamePlates:UpdateAllUnitTokens()
	for unitToken, _ in pairs(self.activeUnitTokens) do
		self:UpdateUnit(unitToken);
	end
end

-- Module registration.
TRP3_API.module.registerModule({
	name        = L["NAMEPLATES_MODULE_NAME"],
	description = L["NAMEPLATES_MODULE_DESCRIPTION"],
	version     = 1,
	id          = "TRP3_NamePlates",
	onInit      = function(...) return TRP3_NamePlates:OnInitialize(...); end,
	onStart     = function(...) return TRP3_NamePlates:OnEnable(...); end,
	minVersion  = 70,
});
