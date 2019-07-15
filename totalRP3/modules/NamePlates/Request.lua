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
local TRP3_Register = TRP3_API.register;
local TRP3_Utils = TRP3_API.utils;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- NamePlates module imports.
local PROFILE_TYPE_CHARACTER = NamePlates.PROFILE_TYPE_CHARACTER;
local PROFILE_TYPE_PET = NamePlates.PROFILE_TYPE_PET;
local REQUEST_COOLDOWN = NamePlates.REQUEST_COOLDOWN;

-- Mapping of register IDs ("unit IDs") to request cooldowns.
NamePlates.requestCooldowns = {};

-- Requests a profile for the given unit token.
--
-- Returns true if a request was issued, or false if no request was issued.
--[[private]] function NamePlates.RequestUnitProfile(unitToken)
	-- Get the register ID for this unit token, if available.
	local registerID = NamePlates.GetRegisterIDForUnit(unitToken);
	if not registerID then
		return false;
	end

	-- Issue requests via both TRP and MSP protocols. MSP is limited to
	-- players only, so don't send anything for pets out.
	local profileType = NamePlates.GetUnitProfileType(unitToken);
	if profileType == PROFILE_TYPE_CHARACTER then
		TRP3_API.r.sendQuery(registerID);
		TRP3_API.r.sendMSPQueryIfAppropriate(registerID);
	elseif profileType == PROFILE_TYPE_PET then
		-- Queries for companions take a little bit extra effort.
		local ownerID = TRP3_Utils.str.companionIDToInfo(registerID);
		if TRP3_Register.isUnitIDKnown(ownerID) then
			TRP3_API.r.sendQuery(ownerID);
		end
	else
		-- Unknown profile type.
		return false;
	end

	-- Apply a default cooldown for future requests to this person.
	NamePlates.SetUnitRequestCooldown(unitToken, REQUEST_COOLDOWN);
	return true;
end

-- Attempts to issue requests for all displayed nameplates that have units
-- assigned to them.
--
-- Requests will only be issued for units that require them, as determined
-- by the return of ShouldRequestUnitProfile.
--[[private]] function NamePlates.RequestAllUnitProfiles()
	-- Go over the nameplates and request ones that have units.
	for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
		local unitToken = nameplate.namePlateUnitToken;

		if NamePlates.IsUnitValid(unitToken)
		and NamePlates.ShouldRequestUnitProfile(unitToken) then
			-- Issue the request.
			NamePlates.RequestUnitProfile(unitToken);
		end
	end
end

-- Returns true if a request for the given unit token can be issued.
--
-- This will return false if requests are disabled, or if there is already
-- valid profile data for the unit present.
--[[private]] function NamePlates.ShouldRequestUnitProfile(unitToken)
	-- Don't allow requests if customizations are turned off, or if
	-- actively querying for profiles is itself disabled.
	if not NamePlates.IsCustomizationEnabled()
	or not NamePlates.ShouldActivelyQueryProfiles() then
		return false;
	end

	-- Get the register ID for this unit.
	local registerID = NamePlates.GetRegisterIDForUnit(unitToken);
	if not registerID then
		return false;
	end

	-- If the unit already has a profile, we won't re-issue a request.
	if TRP3_Register.isUnitIDKnown(registerID)
	and TRP3_Register.hasProfile(registerID) then
		return false;
	end

	-- Otherwise, check if we've sent a request too recently.
	if NamePlates.IsUnitRequestOnCooldown(unitToken) then
		return false;
	end

	-- Otherwise, allow requests to occur.
	return true;
end

-- Returns true if a request cooldown is currently active for the given
-- unit token.
--[[private]] function NamePlates.IsUnitRequestOnCooldown(unitToken)
	local expiry = NamePlates.GetUnitRequestCooldown(unitToken);
	return expiry and (GetTime() < expiry);
end

-- Returns the cooldown for requests for a given unit token, or nil if
-- no cooldown is set.
--[[private]] function NamePlates.GetUnitRequestCooldown(unitToken)
	local registerID = NamePlates.GetRegisterIDForUnit(unitToken);
	if registerID then
		return NamePlates.requestCooldowns[registerID];
	end

	return nil;
end

-- Sets the cooldown for future requests for a given unit token.
--
-- If the given expiry value is 0 or nil, the cooldown is unset.
--[[private]] function NamePlates.SetUnitRequestCooldown(unitToken, expiry)
	-- Zero expiry should mean unset the cooldown.
	if expiry == 0 then
		expiry = nil;
	end

	-- Set the expiration time for the register ID pointed to by the unit.
	local registerID = NamePlates.GetRegisterIDForUnit(unitToken);
	if registerID then
		NamePlates.requestCooldowns[registerID] = expiry;
	end
end

-- Prunes the table of cooldowns for requests, removing all expired request
-- cooldowns.
--[[private]] function NamePlates.PruneUnitRequestCooldowns()
	-- This table can get fairly large, so we'll not do any pruning if
	-- the player is in combat.
	if InCombatLockdown() then
		return;
	end

	-- Search the state for expired cooldowns and unset them,
	for registerID, expiry in pairs(NamePlates.requestCooldowns) do
		if GetTime() >= expiry then
			NamePlates.requestCooldowns[registerID] = nil;
		end
	end
end
