--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local TRP3_API = select(2, ...);
local AddOn_TotalRP3 = AddOn_TotalRP3;
local L = TRP3_API.loc;

local function GetOrCreateTable(t, key)
	if t[key] ~= nil then
		return t[key];
	end

	t[key] = {};
	return t[key];
end

local closureGeneration = {
	function(f) return function(...) return f(...); end; end,
	function(f, a) return function(...) return f(a, ...); end; end,
	function(f, a, b) return function(...) return f(a, b, ...); end; end,
	function(f, a, b, c) return function(...) return f(a, b, c, ...); end; end,
	function(f, a, b, c, d) return function(...) return f(a, b, c, d, ...); end; end,
};

local function GenerateClosure(f, ...)
	local count = select("#", ...);
	local generator = closureGeneration[count + 1];

	if generator then
		return generator(f, ...);
	end

	error("Closure generation does not support more than "..(#closureGeneration - 1).." parameters");
end

TRP3_MSP = {};

function TRP3_MSP:OnModuleInitialize()
	self.deferredRequests = {};
	self.scheduledUpdates = {};
	self.scheduledUpdatePending = false;
end

function TRP3_MSP:OnModuleEnable()
	-- Check if another MSP addon has loaded first and kill this module if
	-- so; we'll assume the msp_RPAddOn variable was set to the folder
	-- name of an addon and attempt to show the titular name where possible.

	if msp_RPAddOn ~= nil then
		local addonName = GetAddOnMetadata(msp_RPAddOn, "Title") or tostring(msp_RPAddOn);

		TRP3_API.popup.showAlertPopup(string.format(L.REG_MSP_ALERT, addonName));
		return false, string.format(L.MSP_MODULE_DISABLED_CONFLICT, addonName);
	end

	msp_RPAddOn = TRP3_MSPAddOnID;

	TRP3_MSPUtil.RegisterAddOnVersion(TRP3_MSPAddOnID, TRP3_API.globals.version_display);
	TRP3_MSPUtil.LoadDataForCharacter(TRP3_API.globals.player_id);

	msp:AddFieldsToTooltip(TRP3_MSPTooltipFields);
	msp:Update();

	-- Register callbacks after MSP has been initialized so we don't
	-- needlessly fire things based off our own updates.

	table.insert(msp.callback.dataload, GenerateClosure(self.OnCharacterLoadRequest, self));
	table.insert(msp.callback.updated, GenerateClosure(self.OnCharacterUpdated, self));

	TRP3_API.events.registerCallback("REGISTER_DATA_UPDATED", GenerateClosure(self.OnRegisterDataUpdated, self));
	TRP3_API.events.registerCallback("MOUSE_OVER_CHANGED", GenerateClosure(self.OnMouseoverUnitChanged, self));
end

function TRP3_MSP:SendRequest(characterID, requestType, options)
	if msp_RPAddOn ~= TRP3_MSPAddOnID then
		return false;  -- We're not the reigning MSP addon.
	end

	-- The request type is allowed to be invalid; as we're an API we don't
	-- want to error if someone issues a request we later remove support
	-- for, or is using an older version that lacks support.

	local fields = TRP3_MSPRequestFields[requestType];

	if not fields then
		return false;  -- Unknown or unsupported request type.
	end

	characterID = AddOn_Chomp.NameMergedRealm(characterID);

	if characterID == TRP3_API.globals.player_id then
		return false;  -- Player is requesting their own profile, weirchamp.
	elseif TRP3_API.register.isIDIgnored(characterID) then
		return false;  -- Target of this request is on the naughty list.
	end

	-- If we've not yet probed a character to figure out what RP addon they're
	-- running then we'll send a minimal probe request first for just that
	-- information. This saves on bandwidth as, by default, we'd _usually_
	-- request their full profile even if they're running TRP3.
	--
	-- The current request is deferred and submitted once we've received the
	-- necessary information.

	local sent;

	if not self:HasProbedCharacter(characterID) and (not options or not options.skipProbe) then
		self:DeferRequestForCharacter(characterID, requestType);

		fields = TRP3_MSPRequestFields[AddOn_TotalRP3.MSP.RequestType.Probe];
		sent = msp:Request(characterID, fields);
	else
		sent = msp:Request(characterID, fields);
	end

	return sent;
end

function TRP3_MSP:HasProbedCharacter(characterID)
	local charTable = msp.char[characterID];
	return charTable.supported and charTable.field.VA ~= "";
end

function TRP3_MSP:DeferRequestForCharacter(characterID, requestType)
	local deferredRequests = GetOrCreateTable(self.deferredRequests, characterID);
	deferredRequests[requestType] = true;
end

function TRP3_MSP:SubmitDeferredRequests(characterID)
	local deferredRequests = self.deferredRequests[characterID];

	self:DiscardDeferredRequests(characterID);

	if deferredRequests then
		for requestType in pairs(deferredRequests) do
			self:SendRequest(characterID, requestType);
		end
	end
end

function TRP3_MSP:DiscardDeferredRequests(characterID)
	self.deferredRequests[characterID] = nil;
end

function TRP3_MSP:DeferUpdatesForCharacter(characterID)
	self.scheduledUpdates[characterID] = true;

	if not self.scheduledUpdatePending then
		C_Timer.After(0, GenerateClosure(self.OnScheduledUpdateTimerElapsed, self));
		self.scheduledUpdatePending = true;
	end
end

function TRP3_MSP:SubmitUpdatesForCharacter()
	self.scheduledUpdatePending = false;

	-- Note that the store operations are pcall'd here to ensure that if any
	-- error occurs through programmer incompetence we don't necessarily
	-- prevent other profiles being processed.

	for characterID in pairs(self.scheduledUpdates) do
		self.scheduledUpdates[characterID] = nil;
		xpcall(TRP3_MSPUtil.StoreDataForCharacter, CallErrorHandler, characterID);
	end
end

function TRP3_MSP:OnCharacterUpdated(characterID, field)
	local character = msp.char[characterID];

	-- Determine if we should do any processing for this characters' data;
	-- if we shouldn't then any deferred queries must be dropped so we don't
	-- needlessly keep their tables in memory.

	local shouldProcess;
	local shouldDiscard;

	if TRP3_API.register.isIDIgnored(characterID) then
		shouldProcess = false;  -- Disregard updates for ignored characters.
		shouldDiscard = true;
	elseif characterID == TRP3_API.globals.player_id then
		shouldProcess = false;  -- Disregard updates for the local player.
		shouldDiscard = true;
	elseif character.field.VA == "" then
		shouldProcess = false;  -- We've not yet received the VA field.
		shouldDiscard = false;  -- Don't discard until we know what they're running.
	elseif string.find(character.field.VA, TRP3_MSPAddOnID, 1, true) then
		shouldProcess = false;  -- Disregard updates from TRP3 clients.
		shouldDiscard = true;
	else
		shouldProcess = true;   -- They're running something that isn't TRP3.
		shouldDiscard = false;
	end

	if shouldDiscard then
		self:DiscardDeferredRequests(characterID);
	end

	if not shouldProcess then
		return;
	end

	-- At this point we know the incoming data is for an unignored character
	-- that isn't running TRP3.
	--
	-- If the VA field was updated for this character then send off any
	-- deferred queries as this may be a minimal probe response.

	if field == "VA" then
		self:SubmitDeferredRequests(characterID);
	end

	self:DeferUpdatesForCharacter(characterID);
end

function TRP3_MSP:OnCharacterLoadRequest(characterID, characterData)
	TRP3_MSPUtil.LoadDataForCharacter(characterID, characterData);
end

function TRP3_MSP:OnRegisterDataUpdated(characterID, _, dataType)
	if characterID ~= TRP3_API.globals.player_id then
		return;
	end

	if not dataType or dataType == "about" then
		TRP3_MSPUtil.LoadAboutData(TRP3_API.globals.player_id, msp.my);
	end

	if not dataType or dataType == "characteristics" then
		TRP3_MSPUtil.LoadCharacteristicsData(TRP3_API.globals.player_id, msp.my);
	end

	if not dataType or dataType == "misc" then
		TRP3_MSPUtil.LoadMiscData(TRP3_API.globals.player_id, msp.my);
	end

	if not dataType or dataType == "character" then
		TRP3_MSPUtil.LoadCharacterData(TRP3_API.globals.player_id, msp.my);
	end

	msp:Update();
end

function TRP3_MSP:OnMouseoverUnitChanged(characterID, unitType)
	-- When mousing over another character we request their profile. The
	-- full profile is requested for compatibility with existing code
	-- elsewhere; one day it'd be good to change this.

	if unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		self:SendRequest(characterID, AddOn_TotalRP3.MSP.RequestType.Full);
	end
end

function TRP3_MSP:OnScheduledUpdateTimerElapsed()
	self:SubmitUpdatesForCharacter();
end

TRP3_API.module.registerModule(
	{
		id          = "trp3_msp",
		name        = L.MSP_MODULE_NAME,
		description = L.MSP_MODULE_DESCRIPTION,
		version     = 3,
		onInit      = function() return TRP3_MSP:OnModuleInitialize() end,
		onStart     = function() return TRP3_MSP:OnModuleEnable() end,
	}
);
