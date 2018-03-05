----------------------------------------------------------------------------------
-- Total RP 3
-- Directory : Ignore API
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

local Events = TRP3_API.events;
local Globals = TRP3_API.globals;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local loc = TRP3_API.locale.getText;
local assert, tostring, time, wipe, strconcat, pairs, tinsert = assert, tostring, time, wipe, strconcat, pairs, tinsert;
local EMPTY = TRP3_API.globals.empty;
local UnitIsPlayer = UnitIsPlayer;
local get, getPlayerCurrentProfile, hasProfile = TRP3_API.profile.getData, TRP3_API.profile.getPlayerCurrentProfile, TRP3_API.register.hasProfile;
local getProfile, getUnitID, deleteProfile = TRP3_API.register.getProfile, TRP3_API.utils.str.getUnitID, TRP3_API.register.deleteProfile;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local registerInfoTypes = TRP3_API.register.registerInfoTypes;
local getCompleteName, getPlayerCompleteName;
local profiles, characters, blackList, whiteList;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Relation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local RELATIONS = Globals.RELATIONS;
TRP3_API.register.relation = Globals.RELATIONS;

local RELATIONS_TEXTURES = {
	[RELATIONS.UNFRIENDLY] = "Ability_DualWield",
	[RELATIONS.NONE] = "Ability_rogue_disguise",
	[RELATIONS.NEUTRAL] = "Achievement_Reputation_05",
	[RELATIONS.BUSINESS] = "Achievement_Reputation_08",
	[RELATIONS.FRIEND] = "Achievement_Reputation_06",
	[RELATIONS.LOVE] = "INV_ValentinesCandy",
	[RELATIONS.FAMILY] = "Achievement_Reputation_07"
}

local function setRelation(profileID, relation)
	local profile = getPlayerCurrentProfile();
	if not profile.relation then
		profile.relation = {};
	end
	profile.relation[profileID] = relation;
end
TRP3_API.register.relation.setRelation = setRelation;

local function getRelation(profileID)
	local relationTab = get("relation") or EMPTY;
	return relationTab[profileID] or RELATIONS.NONE;
end
TRP3_API.register.relation.getRelation = getRelation;

local function getRelationText(profileID)
	local relation = getRelation(profileID);
	if relation == RELATIONS.NONE then
		return "";
	end
	return loc("REG_RELATION_" .. relation);
end
TRP3_API.register.relation.getRelationText = getRelationText;

local function getRelationTooltipText(profileID, profile)
	return loc("REG_RELATION_" .. getRelation(profileID) .. "_TT"):format(getPlayerCompleteName(true), getCompleteName(profile.characteristics or EMPTY, UNKNOWN, true));
end
TRP3_API.register.relation.getRelationTooltipText = getRelationTooltipText;

local function getRelationTexture(profileID)
	return RELATIONS_TEXTURES[getRelation(profileID)];
end
TRP3_API.register.relation.getRelationTexture = getRelationTexture;

local function getRelationColors(profileID)
	local relation = getRelation(profileID);
	if relation == RELATIONS.NONE then
		return 1, 1, 1;
	elseif relation == RELATIONS.UNFRIENDLY then
		return 1, 0, 0;
	elseif relation == RELATIONS.NEUTRAL then
		return 0.5, 0.5, 1;
	elseif relation == RELATIONS.BUSINESS then
		return 1, 1, 0;
	elseif relation == RELATIONS.FRIEND then
		return 0, 1, 0;
	elseif relation == RELATIONS.LOVE then
		return 1, 0.5, 1;
	elseif relation == RELATIONS.FAMILY then
		return 1, 0.75, 0;
	end
end
TRP3_API.register.relation.getRelationColors = getRelationColors;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Ignore list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function isIDIgnored(ID)
	return blackList[ID] ~= nil;
end
TRP3_API.register.isIDIgnored = isIDIgnored;

local function ignoreID(unitID, reason)
	if reason:len() == 0 then
		reason = loc("TF_IGNORE_NO_REASON");
	end
	blackList[unitID] = reason;
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
end
TRP3_API.register.ignoreID = ignoreID;

local function ignoreIDConfirm(unitID)
	showTextInputPopup(loc("TF_IGNORE_CONFIRM"):format(unitID), function(text)
		ignoreID(unitID, text);
	end);
end
TRP3_API.register.ignoreIDConfirm = ignoreIDConfirm;

local function getIgnoreReason(unitID)
	return blackList[unitID];
end
TRP3_API.register.getIgnoreReason = getIgnoreReason;

function TRP3_API.register.getIDsToPurge()
	local profileToPurge = {};
	local characterToPurge = {};
	for unitID, reason in pairs(blackList) do
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
	blackList[unitID] = nil;
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
end

function TRP3_API.register.getIgnoredList()
	return blackList;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onRelationSelected(value)
	local unitID = getUnitID("target");
	if hasProfile(unitID) then
		setRelation(hasProfile(unitID), value);
		Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), "characteristics");
	end
end

local function onTargetButtonClicked(unitID, _, _, button)
	local profileID = hasProfile(unitID);
	local values = {};
	tinsert(values, {loc("REG_RELATION"), nil});
	tinsert(values, {loc("REG_RELATION_NONE"), RELATIONS.NONE});
	tinsert(values, {loc("REG_RELATION_UNFRIENDLY"), RELATIONS.UNFRIENDLY});
	tinsert(values, {loc("REG_RELATION_NEUTRAL"), RELATIONS.NEUTRAL});
	tinsert(values, {loc("REG_RELATION_BUSINESS"), RELATIONS.BUSINESS});
	tinsert(values, {loc("REG_RELATION_FRIEND"), RELATIONS.FRIEND});
	tinsert(values, {loc("REG_RELATION_LOVE"), RELATIONS.LOVE});
	tinsert(values, {loc("REG_RELATION_FAMILY"), RELATIONS.FAMILY});
	displayDropDown(button, values, onRelationSelected, 0, true);
end

Events.listenToEvent(Events.WORKFLOW_ON_LOAD, function()
	getCompleteName, getPlayerCompleteName = TRP3_API.register.getCompleteName, TRP3_API.register.getPlayerCompleteName;

	if not TRP3_Register.blackList then
		TRP3_Register.blackList = {};
	end
	if not TRP3_Register.whiteList then
		TRP3_Register.whiteList = {};
	end
	profiles = TRP3_Register.profiles;
	characters = TRP3_Register.character;
	blackList = TRP3_Register.blackList;
	whiteList = TRP3_Register.whiteList;
end);

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		-- Ignore button on target frame
		local player_id = TRP3_API.globals.player_id;
		TRP3_API.target.registerButton({
			id = "aa_player_z_ignore",
			configText = loc("TF_IGNORE"),
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(targetType, unitID)
				return UnitIsPlayer("target") and unitID ~= player_id and not isIDIgnored(unitID);
			end,
			onClick = function(unitID)
				ignoreIDConfirm(unitID);
			end,
			tooltipSub = loc("TF_IGNORE_TT"),
			tooltip = loc("TF_IGNORE"),
			icon = "Achievement_BG_interruptX_flagcapture_attempts_1game"
		});

		TRP3_API.target.registerButton({
			id = "aa_player_d_relation",
			configText = loc("REG_RELATION"),
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(targetType, unitID)
				return UnitIsPlayer("target") and unitID ~= player_id and hasProfile(unitID);
			end,
			onClick = onTargetButtonClicked,
			adapter = function(buttonStructure, unitID)
				local profileID = hasProfile(unitID);
				buttonStructure.tooltip = loc("REG_RELATION") .. ": " .. getRelationText(profileID);
				buttonStructure.tooltipSub = "|cff00ff00" .. getRelationTooltipText(profileID, getProfile(profileID)) .. "\n" .. loc("REG_RELATION_TARGET");
				buttonStructure.icon = getRelationTexture(profileID);
			end,
		});
	end
end);
