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
local TRP3_Companions = TRP3_API.companions;
local TRP3_UI = TRP3_API.ui;
local TRP3_Utils = TRP3_API.utils;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;
local Player = AddOn_TotalRP3.Player;

-- Returns true if the given unit token refers to a valid, existing unit.
--
-- This function can return true even if the given unit token does not
-- belong to a nameplate.
--[[private]] function NamePlates.IsUnitValid(unitToken)
	-- Invalid unit tokens are of course, invalid.
	if not unitToken or unitToken == "" then
		return false;
	end

	-- Units that don't exist? Get outta here!
	if not UnitExists(unitToken) then
		return false;
	end

	return true;
end

-- Returns the profile type used by the given unit token.
--
-- If no supported profile type can be found for this unit, nil is returned.
--[[private]] function NamePlates.GetUnitProfileType(unitToken)
	-- Discard invalid units outright.
	if not NamePlates.IsUnitValid(unitToken) then
		return;
	end

	-- Get the type and map it to our subset of constants.
	local unitType = TRP3_UI.misc.getTargetType(unitToken);
	if unitType == TRP3_UI.misc.TYPE_CHARACTER then
		return NamePlates.PROFILE_TYPE_CHARACTER;
	elseif unitType == TRP3_UI.misc.TYPE_PET then
		return NamePlates.PROFILE_TYPE_PET;
	end

	-- Unknown or unsupported profile type.
	return nil;
end

-- Returns the Player model object associated with the given unit token.
--
-- If no valid model can be found, nil is returned.
--[[private]] function NamePlates.GetUnitCharacterProfile(unitToken)
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
--[[private]] function NamePlates.GetUnitPetProfile(unitToken)
	-- Grab the internal ID for this companion based off the unit token.
	local companionType = TRP3_UI.misc.TYPE_PET;
	local fullID = TRP3_UI.misc.getCompanionFullID(unitToken, companionType);
	if not fullID then
		return nil;
	end

	-- Them from that we can obtain the profile.
	local profile = TRP3_Companions.register.getCompanionProfile(fullID);
	if not profile then
		return nil;
	end

	-- We'll only return the data subset of the profile; this can be revisited
	-- later if ever needed.
	return profile.data;
end

-- Returns the nameplate unit ID that belongs to a given TRP3-internal
-- register ID.
--
-- This function does a full scan of all active nameplates, so should be
-- used sparingly.
--
-- If no matching unit can be found, nil is returned.
--[[private]] function NamePlates.GetUnitForRegisterID(registerID)
	-- Iterate over all the active nameplate frames and check for a unit that
	-- maps to the same register ID.
	for _, frame in pairs(C_NamePlate.GetNamePlates()) do
		local frameUnitToken = frame.namePlateUnitToken;
		local frameRegisterID = NamePlates.GetRegisterIDForUnit(frameUnitToken);

		if registerID == frameRegisterID then
			return frameUnitToken;
		end
	end

	-- No matching nameplates.
	return nil;
end

-- Returns the TRP3-internal "unit ID" for a given unit token. This will
-- typically be a "name-realm" string for a player, or a "name-realm_pet"
-- for a companion pet.
--
-- Due to the similarity of unit tokens ("player", "target", ...) and the
-- internal "unit ID" moniker, the nameplate module refers to these as
-- register IDs.
--[[private]] function NamePlates.GetRegisterIDForUnit(unitToken)
	-- Dispatch based off the profile type.
	local profileType = NamePlates.GetUnitProfileType(unitToken);
	if profileType == NamePlates.PROFILE_TYPE_CHARACTER then
		return TRP3_Utils.str.getUnitID(unitToken);
	elseif profileType == NamePlates.PROFILE_TYPE_PET then
		local companionType = TRP3_UI.misc.TYPE_PET;
		return TRP3_UI.misc.getCompanionFullID(unitToken, companionType);
	end

	-- Unknown or unsupported profile type.
	return nil;
end
