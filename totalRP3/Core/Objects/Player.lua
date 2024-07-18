-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Player = {};

function Player:__init(name, realm)
	self.name = (name ~= "") and name or UNKNOWNOBJECT;
	self.realm = (realm ~= "") and realm or GetNormalizedRealmName();
end

function Player:IsValid()
	return self.name ~= UNKNOWNOBJECT;
end

function Player:GetID()
	-- Note that the ID of a player should be considered an opaque string
	-- that may not always be "name-realm". Use GetFullName instead if the
	-- format is important.

	return string.join("-", self.name, self.realm);
end

function Player:GetName()
	return self.name;
end

function Player:GetRealm()
	return self.realm;
end

function Player:GetFullName()
	return string.join("-", self.name, self.realm);
end

function Player:GetAmbiguatedName(context)
	return Ambiguate(self:GetFullName(), context);
end

function Player:IsCurrentUser()
	return self.name == UnitNameUnmodified("player") and self.realm == GetNormalizedRealmName();
end

local function CreatePlayer(name, realm)
	return TRP3_API.CreateObject(Player, name, realm);
end

function TRP3_API.GetPlayerByID(playerID)
	local name, realm = string.split("-", playerID, 2);
	return CreatePlayer(name, realm);
end

function TRP3_API.GetPlayerByName(name, realm)
	return CreatePlayer(name, realm);
end

function TRP3_API.GetPlayerByFullName(fullName)
	local name, realm = string.split("-", fullName, 2);
	return CreatePlayer(name, realm);
end

function TRP3_API.GetPlayerByGUID(playerGUID)
	local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(playerGUID);
	return CreatePlayer(name, realm);
end

function TRP3_API.GetPlayerByUnit(unitToken)
	local name, realm;

	if UnitIsPlayer(unitToken) then
		name, realm = UnitNameUnmodified(unitToken)
	end

	return CreatePlayer(name, realm);
end
