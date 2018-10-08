----------------------------------------------------------------------------------
--- Total RP 3
---
--- Player model
--- ---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---  http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local Ellyb = Ellyb(...);

---@class Player : Object
local Player, _private = Ellyb.Class("Player")
---@type Player
local currentUser;

---@private
function Player:initialize()
	_private[self] = {};
end

---@return string|nil characterID
function Player:GetCharacterID()
	return _private[self].characterID;
end

---@return string|nil playerName
function Player:GetName()
	if self:GetCharacterID() then
		local name = strsplit("-", self:GetCharacterID());
		return name
	end
end

---@return {characteristics: {FN: string, LN: string}}|nil profile
function Player:GetProfile()
	local characterInfo = TRP3_Register.character[self:GetCharacterID()]
	if characterInfo then
		return TRP3_Register.profiles[characterInfo.profileID];
	end
end

---@return {FN: string, LN: string, CH:string, IC:string}|nil characteristics
function Player:GetCharacteristics()
	local profile = self:GetProfile();
	if profile then
		return profile.characteristics;
	end
end

---@return string|nil firstName
function Player:GetFirstName()
	local characteristics = self:GetCharacteristics();
	if characteristics  then
		return characteristics.FN;
	end
end

---@return string|nil lastName
function Player:GetLastName()
	local characteristics = self:GetCharacteristics();
	if characteristics then
		return characteristics.LN
	end
end

--- Get the roleplaying name of the player.
---@return string|nil playerRoleplayingName @ Will only be nil if the player is not valid, otherwise the game name is used
function Player:GetRoleplayingName()
	local name = self:GetFirstName() or self:GetName();

	if self:GetLastName() then
		name = name .. " " .. self:GetLastName();
	end

	return name
end

---@return string relationship
function Player:GetRelationshipWithPlayer()
	return TRP3_API.register.relation.getRelation(TRP3_API.register.getUnitIDProfileID(self:GetCharacterID()));
end

---@return Color|nil customColor
function Player:GetCustomColor()
	local characteristics = self:GetCharacteristics();
	if characteristics and characteristics.CH then
		return Ellyb.Color.CreateFromHexa(characteristics.CH);
	end
end

---@return string|nil
function Player:GetCustomIcon()
	local characteristics = self:GetCharacteristics();
	if characteristics then
		return characteristics.IC
	end
end

function Player:IsCurrentUser()
	return self:GetCharacterID() == currentUser:GetCharacterID();
end

function Player:IsInCharacter()
	return self:GetInfo("player/character/RP") ~= 2
end

function Player:GetInfo(path)
	return TRP3_API.profile.getData(path, self:GetProfile())
end

---@return Player player
--[[ static ]] function Player.CreateFromCharacterID(characterID)
	assert(Ellyb.Assertions.isType(characterID, "string", "characterID"));

	if characterID == currentUser:GetCharacterID() then
		return Player.GetCurrentUser();
	end

	local player = Player();

	_private[player].characterID = characterID;

	return player;
end

--{{{ Current user
currentUser = Player();

function currentUser:GetProfile()
	return TRP3_API.profile.getPlayerCurrentProfile().player;
end

function currentUser:GetCharacterID()
	return TRP3_API.globals.player_id;
end

function currentUser:GetRelationshipWithPlayer()
	return TRP3_API.globals.RELATIONS.NONE;
end

--- Returns a reference to the current user as a Player model.
--- The current user has some specific behavior due to data not being stored in the same places.
---@return Player currentUser
--[[ static ]] function Player.GetCurrentUser()
	return currentUser;
end
--}}}

AddOn_TotalRP3.Player = Player
