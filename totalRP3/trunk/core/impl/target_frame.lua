--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_TARGET_FRAME = {};

-- imports
local Utils, Events, Globals = TRP3_UTILS, TRP3_EVENTS, TRP3_GLOBALS;
local loc = TRP3_L;
local ui_TargetFrame = TRP3_TargetFrame;
local ui_TargetFrameModel = TRP3_TargetFramePortraitModel;
local UnitName = UnitName;
local EMPTY = Globals.empty;
local getMiscData;
local isUnitIDKnown;
local _G, assert, tostring = _G, assert, tostring;
local getUnitID = Utils.str.getUnitID;
local setTooltipForSameFrame = TRP3_UI_UTILS.tooltip.setTooltipForSameFrame;
local get = TRP3_PROFILE.getData;
local displayDropDown = TRP3_UI_UTILS.listbox.displayDropDown;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Buttons logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local targetButtons = {};

local function registerButton(targetButton)
	assert(targetButton and targetButton.id, "Usage: button structure containing 'id' field");
	assert(not targetButtons[targetButton.id], "Already registered button id: " .. targetButton.id);
	targetButtons[targetButton.id] = targetButton;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Display logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentTarget = nil;

local function onPeekSelection(value, button)
	if value then
		TRP3_RegisterMiscSetPeek(button.slot, value);
	end
end

local function onPeekClickMine(button)
	displayDropDown(button, TRP3_RegisterMiscGetPeekPresetStructure(), function(value) onPeekSelection(value, button) end, 0, true);
end

local function displayPeekSlots(unitID, targetInfo)
	for i=1,5,1 do
		local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
		slot:Hide();
	end
	
	if UnitIsPlayer("target") then
		local peekTab;
		if unitID == Globals.player_id then
			peekTab = get("player/misc").PE or EMPTY;
		elseif isUnitIDKnown(unitID) then
			peekTab = getMiscData(unitID).PE or EMPTY;
		end
		for i=1,5,1 do
			local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
			local peek = peekTab[tostring(i)];
			if peek and peek.AC then
				slot:Show();
				local iconTag = Utils.str.icon(peek.IC or Globals.icons.default, 30);
				setTooltipForSameFrame(slot, "TOP_LEFT", 0, 0, iconTag .. " " .. (peek.TI or "..."), peek.TX);
				Utils.texture.applyRoundTexture("TRP3_TargetFrameGlanceSlot"..i.."Image", "Interface\\ICONS\\" .. (peek.IC or ""), "Interface\\ICONS\\" .. Globals.icons.default);
				if unitID == Globals.player_id then
					slot:SetScript("OnClick", onPeekClickMine);
				else
					slot:SetScript("OnClick", nil);
				end
			else
				slot:Hide();
			end
		end
	end
end

local function displayTargetFrame(unitID, targetInfo)
	ui_TargetFrame:Show();
	ui_TargetFrameModel:SetUnit("target");
	ui_TargetFrameModel:SetCamera(0);
	
	displayPeekSlots(unitID, targetInfo);
end

local function getTargetInformation(unitID)
	return EMPTY;
end

local function onTargetChanged(...)
	local unitID = getUnitID("target");
	currentTarget = unitID;
	ui_TargetFrame:Hide();
	if unitID then
		local targetInfo = getTargetInformation(unitID);
		if targetInfo then
			displayTargetFrame(unitID, targetInfo);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_TARGET_FRAME.init = function()
	getMiscData = TRP3_REGISTER.getMiscData;
	isUnitIDKnown = TRP3_REGISTER.isUnitIDKnown;

	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);

	Events.listenToEvent(Events.REGISTER_MISC_SAVED, function()
		if currentTarget == Globals.player_id then
			onTargetChanged();
		end
	end);
	
	for i=1,5,1 do
		local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
		slot.slot = tostring(i);
	end
end