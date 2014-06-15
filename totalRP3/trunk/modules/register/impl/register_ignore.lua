--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Ignore list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local Events = TRP3_API.events;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local loc = TRP3_API.locale.getText;
local assert, tostring, time, wipe, strconcat, pairs, tinsert = assert, tostring, time, wipe, strconcat, pairs, tinsert;
local EMPTY = TRP3_API.globals.empty;
local UnitIsPlayer = UnitIsPlayer;
local profiles, characters, blackList, whiteList;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Relation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local RELATIONS = {
	UNFRIENDLY = "UNFRIENDLY",
	NONE = "NONE",
	NEUTRAL = "NEUTRAL",
	BUSINESS = "BUSINESS",
	FRIEND = "FRIEND",
	LOVE = "LOVE",
	FAMILY = "FAMILY"
}
TRP3_API.register.relation = RELATIONS;

local function getRelation(profileID)
	return RELATIONS.NONE;
end
TRP3_API.register.relation.getRelation = getRelation;

function TRP3_API.register.relation.getRelationText(profileID)
	local relation = getRelation(profileID);
	if relation == RELATIONS.NONE then
		return "";
	end
	return loc("REG_RELATION_" .. relation);
end

function TRP3_API.register.relation.getRelationTooltipText(profileID)
	return loc("REG_RELATION_" .. getRelation(profileID) .. "_TT");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Ignore list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function isIDIgnored(ID)
	return blackList[ID] ~= nil;
end
TRP3_API.register.isIDIgnored = isIDIgnored;

local function ignoreID(ID)
	showTextInputPopup(loc("TF_IGNORE_CONFIRM"):format(ID), function(text)
		if text:len() == 0 then
			text = loc("TF_IGNORE_NO_REASON");
		end
		blackList[ID] = text;
		Events.fireEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, ID);
	end);
end
TRP3_API.register.ignoreID = ignoreID;

local function getIgnoreReason(unitID)
	return blackList[unitID];
end
TRP3_API.register.getIgnoreReason = getIgnoreReason;

function TRP3_API.register.purgeIgnored(ID)
	local charactersToIgnore = {};
	local profileToIgnore;
	
	-- Determine what to ignore
	if characters[ID] then
		profileToIgnore = characters[ID].profileID;
		if profiles[profileToIgnore] then
			local links = profiles[profileToIgnore].link or EMPTY;
			for unitID, _ in pairs(links) do
				tinsert(charactersToIgnore, unitID);
			end
		end
	end
	-- Ignore and delete all characters !
	for _, unitID in pairs(charactersToIgnore) do
		blackList[unitID] = true;
		if characters[unitID] then
			wipe(characters[unitID]);
			characters[unitID] = nil;
		end
		Events.fireEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, unitID);
	end
	-- Delete related profile
	if profileToIgnore and profiles[profileToIgnore] then
		wipe(profiles[profileToIgnore]);
		profiles[profileToIgnore] = nil;
		Events.fireEvent(Events.REGISTER_PROFILE_DELETED, profileToIgnore);
	end
end

function TRP3_API.register.unignoreID(ID)
	blackList[ID] = nil;
	Events.fireEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, ID);
end

function TRP3_API.register.getIgnoredList()
	return blackList;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Events.listenToEvent(Events.WORKFLOW_ON_LOADED, function()
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
	
	-- Ignore button on target frame
	local player_id = TRP3_API.globals.player_id;
	TRP3_API.target.registerButton({
		id = "z_ignore",
		configText = loc("TF_IGNORE"),
		condition = function(unitID, targetInfo)
			return UnitIsPlayer("target") and unitID ~= player_id and not isIDIgnored(unitID);
		end,
		onClick = function(unitID)
			ignoreID(unitID);
		end,
		tooltipSub = loc("TF_IGNORE_TT"),
		tooltip = loc("TF_IGNORE"),
		icon = "Achievement_BG_interruptX_flagcapture_attempts_1game"
	});
	
--	TRP3_API.target.registerButton({
--		id = "r_relation",
--		configText = loc("TF_IGNORE"),
--		condition = function(unitID, targetInfo)
--			return UnitIsPlayer("target") and unitID ~= player_id and not isIDIgnored(unitID);
--		end,
--		onClick = function(unitID)
--			ignoreID(unitID);
--		end,
--		tooltipSub = loc("TF_IGNORE_TT"),
--		tooltip = loc("TF_IGNORE"),
--		icon = "Achievement_BG_interruptX_flagcapture_attempts_1game"
--	});
end);
