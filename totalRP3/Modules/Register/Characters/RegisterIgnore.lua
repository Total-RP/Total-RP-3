-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Events = TRP3_Addon.Events;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local loc = TRP3_API.loc;
local hasProfile = TRP3_API.register.hasProfile;
local getProfile, getUnitID = TRP3_API.register.getProfile, TRP3_API.utils.str.getUnitID;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
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
	showTextInputPopup(loc.TF_IGNORE_CONFIRM:format(unitID), function(text)
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

local function onRelationSelected(value)
	local unitID = getUnitID("target");
	if hasProfile(unitID) then
		TRP3_API.register.relation.setRelation(hasProfile(unitID), value);
		TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), "characteristics");
	end
end

local function onTargetButtonClicked(_, _, _, button)
	local values = {};
	local relations = TRP3_API.register.relation.getRelationList(true);
	for _, thisRelation in ipairs(relations) do
		tinsert(values, {thisRelation.name or loc["REG_RELATION_" .. thisRelation.id], thisRelation.id})
	end

	displayDropDown(button, values, onRelationSelected, 0, true);
end

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
		local player_id = TRP3_API.globals.player_id;
		TRP3_API.target.registerButton({
			id = "aa_player_z_ignore",
			configText = loc.TF_IGNORE,
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, unitID)
				return UnitIsPlayer("target") and unitID ~= player_id and not isIDIgnored(unitID);
			end,
			onClick = function(unitID)
				ignoreIDConfirm(unitID);
			end,
			tooltipSub = loc.TF_IGNORE_TT,
			tooltip = loc.TF_IGNORE,
			icon = TRP3_InterfaceIcons.TargetIgnoreCharacter,
		});

		TRP3_API.target.registerButton({
			id = "aa_player_d_relation",
			configText = loc.REG_RELATION,
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, unitID)
				return UnitIsPlayer("target") and unitID ~= player_id and hasProfile(unitID);
			end,
			onClick = onTargetButtonClicked,
			adapter = function(buttonStructure, unitID)
				local profileID = hasProfile(unitID);
				buttonStructure.tooltip = loc.REG_RELATION .. ": " .. TRP3_API.register.relation.getRelationText(profileID);
				buttonStructure.tooltipSub = "|cff00ff00" .. TRP3_API.register.relation.getRelationTooltipText(profileID, getProfile(profileID)) .. "\n" .. loc.REG_RELATION_TARGET;
				buttonStructure.icon = TRP3_API.register.relation.getRelationTexture(profileID);
			end,
		});
	end
end);
