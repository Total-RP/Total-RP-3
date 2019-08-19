----------------------------------------------------------------------------------
--- Total RP 3
--- Directory : Ignore API
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

local Ellyb = TRP3_API.Ellyb;

local Events = TRP3_API.events;
local Globals = TRP3_API.globals;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local loc = TRP3_API.loc;
local EMPTY = TRP3_API.globals.empty;
local UnitIsPlayer = UnitIsPlayer;
local get, getPlayerCurrentProfile, hasProfile = TRP3_API.profile.getData, TRP3_API.profile.getPlayerCurrentProfile, TRP3_API.register.hasProfile;
local getProfile, getUnitID = TRP3_API.register.getProfile, TRP3_API.utils.str.getUnitID;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local characters, blackList= {}, {};
local is_classic = Globals.is_classic;

-- These functions gets replaced by the proper TRP3 one once the addon has finished loading
local function getPlayerCompleteName()
	return TRP3_API.globals.player
end
local function getCompleteName()
	return UNKNOWN
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Relation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local RELATIONS = Globals.RELATIONS;
TRP3_API.register.relation = Globals.RELATIONS;

local RELATIONS_TEXTURES = {
	[RELATIONS.UNFRIENDLY] = "Ability_DualWield",
	[RELATIONS.NONE] = "Ability_rogue_disguise",
	[RELATIONS.NEUTRAL] = is_classic and "Ability_Hibernation" or "Achievement_Reputation_05",
	[RELATIONS.BUSINESS] = is_classic and "INV_Misc_Coin_04" or "Achievement_Reputation_08",
	[RELATIONS.FRIEND] = is_classic and "Spell_Holy_PrayerOfHealing" or "Achievement_Reputation_06",
	[RELATIONS.LOVE] = "INV_ValentinesCandy",
	[RELATIONS.FAMILY] = is_classic and "Spell_Holy_SpellWarding" or "Achievement_Reputation_07"
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
	return loc:GetText("REG_RELATION_" .. relation);
end
TRP3_API.register.relation.getRelationText = getRelationText;

local function getRelationTooltipText(profileID, profile)
	return loc:GetText("REG_RELATION_" .. getRelation(profileID) .. "_TT"):format(getPlayerCompleteName(true), getCompleteName(profile.characteristics or EMPTY, UNKNOWN, true));
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

-- TODO Move this somewhere that makes sense. Also, Saelora should have done this a long time ago :P
local NEUTRAL = Ellyb.Color.CreateFromRGBA(0.5, 0.5, 1, 1):Freeze()
local BUSINESS = Ellyb.Color.CreateFromRGBA(1, 1, 0, 1):Freeze()
local LOVE = Ellyb.ColorManager.PINK;
local FAMILY = Ellyb.Color.CreateFromRGBA(1, 0.75, 0, 1):Freeze()
function TRP3_API.register.relation.getColor(relation)
	if relation == RELATIONS.UNFRIENDLY then
		return Ellyb.ColorManager.RED;
	elseif relation == RELATIONS.NEUTRAL then
		return NEUTRAL;
	elseif relation == RELATIONS.BUSINESS then
		return BUSINESS;
	elseif relation == RELATIONS.FRIEND then
		return Ellyb.ColorManager.GREEN;
	elseif relation == RELATIONS.LOVE then
		return LOVE;
	elseif relation == RELATIONS.FAMILY then
		return FAMILY;
	else
		return Ellyb.ColorManager.WHITE;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Ignore list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function isIDIgnored(ID)
	return blackList[ID] ~= nil;
end
TRP3_API.register.isIDIgnored = isIDIgnored;

local function ignoreID(unitID, reason)
	if reason:len() == 0 then
		reason = loc.TF_IGNORE_NO_REASON;
	end
	blackList[unitID] = reason;
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
end
TRP3_API.register.ignoreID = ignoreID;

local function ignoreIDConfirm(unitID)
	showTextInputPopup(loc.TF_IGNORE_CONFIRM:format(unitID), function(text)
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
	for unitID, _ in pairs(blackList) do
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
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, TRP3_API.register.isUnitIDKnown(unitID) and hasProfile(unitID) or nil, nil);
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

local function onTargetButtonClicked(_, _, _, button)
	local values = {};
	tinsert(values, {loc.REG_RELATION, nil});
	tinsert(values, {loc.REG_RELATION_NONE, RELATIONS.NONE});
	tinsert(values, {loc.REG_RELATION_UNFRIENDLY, RELATIONS.UNFRIENDLY});
	tinsert(values, {loc.REG_RELATION_NEUTRAL, RELATIONS.NEUTRAL});
	tinsert(values, {loc.REG_RELATION_BUSINESS, RELATIONS.BUSINESS});
	tinsert(values, {loc.REG_RELATION_FRIEND, RELATIONS.FRIEND});
	tinsert(values, {loc.REG_RELATION_LOVE, RELATIONS.LOVE});
	tinsert(values, {loc.REG_RELATION_FAMILY, RELATIONS.FAMILY});
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
	characters = TRP3_Register.character;
	blackList = TRP3_Register.blackList;
end);

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		-- Ignore button on target frame
		local player_id = TRP3_API.globals.player_id;
		TRP3_API.target.registerButton({
			id = "aa_player_z_ignore",
			configText = loc.TF_IGNORE,
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(_, unitID)
				return UnitIsPlayer("target") and unitID ~= player_id and not isIDIgnored(unitID);
			end,
			onClick = function(unitID)
				ignoreIDConfirm(unitID);
			end,
			tooltipSub = loc.TF_IGNORE_TT,
			tooltip = loc.TF_IGNORE,
			icon = is_classic and "SPELL_HOLY_SILENCE" or "Achievement_BG_interruptX_flagcapture_attempts_1game"
		});

		TRP3_API.target.registerButton({
			id = "aa_player_d_relation",
			configText = loc.REG_RELATION,
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(_, unitID)
				return UnitIsPlayer("target") and unitID ~= player_id and hasProfile(unitID);
			end,
			onClick = onTargetButtonClicked,
			adapter = function(buttonStructure, unitID)
				local profileID = hasProfile(unitID);
				buttonStructure.tooltip = loc.REG_RELATION .. ": " .. getRelationText(profileID);
				buttonStructure.tooltipSub = "|cff00ff00" .. getRelationTooltipText(profileID, getProfile(profileID)) .. "\n" .. loc.REG_RELATION_TARGET;
				buttonStructure.icon = getRelationTexture(profileID);
			end,
		});
	end
end);
