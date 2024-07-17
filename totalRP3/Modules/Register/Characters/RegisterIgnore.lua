-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Events = TRP3_Addon.Events;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local loc = TRP3_API.loc;
local hasProfile = TRP3_API.register.hasProfile;
local characters, blockList = {}, {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Ignore list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function isIDIgnored(ID)
	return blockList[ID] ~= nil;
end
TRP3_API.register.isIDIgnored = isIDIgnored;

local function ignoreID(unitID, reason)
	if reason:len() == 0 then
		reason = loc.TF_IGNORE_NO_REASON;
	end
	blockList[unitID] = reason;
	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
end
TRP3_API.register.ignoreID = ignoreID;

local function ignoreIDConfirm(unitID)
	showTextInputPopup(loc.REG_PLAYER_IGNORE_WARNING:format(unitID), function(text)
		ignoreID(unitID, text);
	end);
end
TRP3_API.register.ignoreIDConfirm = ignoreIDConfirm;

local function getIgnoreReason(unitID)
	return blockList[unitID];
end
TRP3_API.register.getIgnoreReason = getIgnoreReason;

function TRP3_API.register.getIDsToPurge()
	local profileToPurge = {};
	local characterToPurge = {};
	for unitID, _ in pairs(blockList) do
		if characters[unitID] then
			tinsert(characterToPurge, unitID);
			if characters[unitID].profileID then
				tinsert(profileToPurge, characters[unitID].profileID);
			end
		end
	end
	return profileToPurge, characterToPurge;
end

function TRP3_API.register.unignoreID(unitID)
	blockList[unitID] = nil;
	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, unitID, TRP3_API.register.isUnitIDKnown(unitID) and hasProfile(unitID) or nil, nil);
end

function TRP3_API.register.getIgnoredList()
	return blockList;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.RegisterCallback(TRP3_Addon, Events.WORKFLOW_ON_LOAD, function()
	if not TRP3_Register.blockList then
		TRP3_Register.blockList = {};
	end
	characters = TRP3_Register.character;
	blockList = TRP3_Register.blockList;
end);

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		-- Ignore button on target frame
		TRP3_API.target.registerButton({
			id = "aa_player_z_ignore",
			configText = loc.TF_IGNORE,
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, unitID)
				return UnitIsPlayer("target") and unitID ~= TRP3_API.globals.player_id and not isIDIgnored(unitID);
			end,
			onClick = function(unitID)
				ignoreIDConfirm(unitID);
			end,
			tooltipSub = loc.TF_IGNORE_TT .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_IGNORE),
			tooltip = loc.TF_IGNORE,
			iconAtlas = TRP3_InterfaceAtlases.TargetIgnoreCharacter,
		});
	end
end);
