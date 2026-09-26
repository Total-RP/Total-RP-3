-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_NameUtil = {};

---@enum TRP3.NameUtil.Mode
TRP3_NameUtil.Mode = {
	RealmQualified = 0;
	RegionalUnique = 1;
};

local REALM_SEPARATOR = Constants.CharacterNameSeparatorConsts and Constants.CharacterNameSeparatorConsts.CHARACTERNAME_REALMNAME_SEPARATOR or "-";
local REALM_NORMALIZATION_PATTERN = "[%s%.%-]";
local SURNAME_SEPARATOR = Constants.CharacterNameSeparatorConsts and Constants.CharacterNameSeparatorConsts.CHARACTERNAME_SURNAME_SEPARATOR or " ";

local function NormalizeUnitName(name, qualifier)
	if not canaccessallvalues(name, qualifier) then
		name, qualifier = nil, nil;
	end

	name = (name ~= "" and name ~= UNKNOWNOBJECT) and name or nil;
	qualifier = (qualifier ~= "") and qualifier or nil;

	if name then
		qualifier = TRP3_NameUtil.NormalizeRealmName(qualifier);
	end

	return name, qualifier;
end

---@param unitGUID WOWGUID
---@return string? name
---@return string? qualifier
local function GetPlayerNameByGUID(unitGUID)
	local _className, _classFile, _raceName, _raceFile, _sex, name, qualifier, _level = GetPlayerInfoByGUID(unitGUID);
	return name, qualifier;
end

---@class TRP3.NameUtil.RealmQualifiedNameImpl : TRP3.NameUtil.Implementation
local RealmQualifiedNameImpl = {};

function RealmQualifiedNameImpl.NormalizeUnitName(name, realm)
	return NormalizeUnitName(name, realm);
end

function RealmQualifiedNameImpl.ComposeQualifiedName(name, realm)
	local qualifiedName = nil;

	name, realm = RealmQualifiedNameImpl.NormalizeUnitName(name, realm);

	if name then
		qualifiedName = string.join(REALM_SEPARATOR, name, realm or GetNormalizedRealmName());
	end

	return qualifiedName;
end

function RealmQualifiedNameImpl.DecomposeQualifiedName(qualifiedName)
	local name, realm = RealmQualifiedNameImpl.NormalizeUnitName(string.split(REALM_SEPARATOR, qualifiedName, 2));

	if name and not realm then
		realm = GetNormalizedRealmName();
	end

	return name, realm;
end

function RealmQualifiedNameImpl.GetQualifiedNameFromString(qualifiedName)
	local name, realm = RealmQualifiedNameImpl.DecomposeQualifiedName(qualifiedName);
	name = name and TRP3_StringUtil.CapitalizeWords(name) or nil;
	realm = realm and TRP3_StringUtil.CapitalizeWords(realm) or nil;
	return RealmQualifiedNameImpl.ComposeQualifiedName(name, realm);
end

function RealmQualifiedNameImpl.ShouldDisplayRealmNames()
	return true;
end

---@class TRP3.NameUtil.RegionalUniqueNameImpl : TRP3.NameUtil.Implementation
local RegionalUniqueNameImpl = {};

function RegionalUniqueNameImpl.NormalizeUnitName(givenName, familyName)
	if not canaccessallvalues(givenName, familyName) then
		givenName, familyName = nil, nil;
	end

	if givenName then
		local plain = true;
		local familyNameOffset = string.find(givenName, SURNAME_SEPARATOR, 1, plain);

		if familyNameOffset then
			familyName = string.sub(givenName, familyNameOffset + 1);
			givenName = string.sub(givenName, 1, familyNameOffset - 1);
		end
	end

	return NormalizeUnitName(TRP3_NameUtil.ComposeFullName(givenName, familyName));
end

function RegionalUniqueNameImpl.ComposeQualifiedName(givenName, familyName)
	return RegionalUniqueNameImpl.NormalizeUnitName(givenName, familyName);
end

function RegionalUniqueNameImpl.DecomposeQualifiedName(qualifiedName)
	return NormalizeUnitName(qualifiedName);
end

function RegionalUniqueNameImpl.GetQualifiedNameFromString(qualifiedName)
	local fullName = RegionalUniqueNameImpl.DecomposeQualifiedName(qualifiedName);

	if not fullName then
		return nil;
	end

	local givenName, familyName = TRP3_NameUtil.DecomposeFullName(fullName);

	if not givenName or not familyName then
		return nil;
	end

	givenName = TRP3_StringUtil.CapitalizeWords(givenName);
	familyName = TRP3_StringUtil.CapitalizeWords(familyName);
	fullName = TRP3_NameUtil.ComposeFullName(givenName, familyName);

	return RegionalUniqueNameImpl.ComposeQualifiedName(fullName);
end

function RegionalUniqueNameImpl.ShouldDisplayRealmNames()
	return false;
end

---@type TRP3.NameUtil.Implementation
local Impl;

--- Get the display name for a unit token.
---@param unitToken UnitToken
---@return string? fullName Full name, e.g. "John Stormwind".
function TRP3_NameUtil.GetDisplayName(unitToken)
	local name = Impl.NormalizeUnitName(UnitName(unitToken));
	return name;
end

--- Get the unmodified full character name for a unit token.
---@param unitToken UnitToken
---@return TRP3.CharacterName? fullName Full name, e.g. "John Stormwind".
function TRP3_NameUtil.GetUnmodifiedName(unitToken)
	local name = Impl.NormalizeUnitName(UnitNameUnmodified(unitToken));
	return name;
end

--- Extract the given name from a full name.
---@param fullName string? Full name, e.g. "John Stormwind".
---@return string? name Given name, e.g. "John".
function TRP3_NameUtil.ExtractGivenName(fullName)
	if fullName then
		local givenName, _familyName = TRP3_NameUtil.DecomposeFullName(fullName);
		return givenName;
	end
end

--- Extract the family name from a full name.
---@param fullName string? Full name, e.g. "John Stormwind".
---@return string? familyName Family name, e.g. "Stormwind".
function TRP3_NameUtil.ExtractFamilyName(fullName)
	if fullName then
		local _givenName, familyName = TRP3_NameUtil.DecomposeFullName(fullName);
		return familyName;
	end
end

--- Compose a full name from given and family name parts.
---@param givenName string? Given name, e.g. "John".
---@param familyName string? Family name, e.g. "Stormwind".
---@return string? fullName Full name, e.g. "John Stormwind".
function TRP3_NameUtil.ComposeFullName(givenName, familyName)
	givenName = (givenName ~= "") and givenName or nil;
	familyName = (familyName ~= "") and familyName or nil;

	if givenName and familyName then
		return string.join(SURNAME_SEPARATOR, givenName, familyName);
	else
		return givenName;
	end
end

--- Decompose a full name into given and family name parts.
---@param fullName string Full name, e.g. "John Stormwind".
---@return string? givenName Given name, e.g. "John".
---@return string? familyName Family name, e.g. "Stormwind".
function TRP3_NameUtil.DecomposeFullName(fullName)
	local givenName, familyName = string.split(SURNAME_SEPARATOR, fullName, 2);
	givenName = (givenName ~= "") and givenName or nil;
	familyName = (familyName ~= "") and familyName or nil;
	return givenName, familyName;
end

--- Get the qualified character name for a unit token.
---@param unitToken UnitToken
---@return string? qualifiedName Qualified name, e.g. "Zugzug-AzjolNerub".
function TRP3_NameUtil.GetQualifiedName(unitToken)
	local name, realm = Impl.NormalizeUnitName(UnitNameUnmodified(unitToken));
	return Impl.ComposeQualifiedName(name, realm);
end

--- Get the qualified character name for a player GUID.
---@param unitGUID WOWGUID
---@return string? qualifiedName Qualified name, e.g. "Zugzug-AzjolNerub".
function TRP3_NameUtil.GetQualifiedNameByGUID(unitGUID)
	local name, realm = Impl.NormalizeUnitName(GetPlayerNameByGUID(unitGUID));
	return Impl.ComposeQualifiedName(name, realm);
end

--- Get a qualified character name from a combined name string.
--- In realm-qualified mode, a missing realm is completed with the current realm.
--- In regional-unique mode, the input must include both given and family names.
---@param qualifiedName string Combined name, e.g. "John-Stormwind" or "John Stormwind".
---@return string? qualifiedName Qualified character name for the current naming mode.
function TRP3_NameUtil.GetQualifiedNameFromString(qualifiedName)
	if not qualifiedName or qualifiedName == "" then
		return nil;
	end

	return Impl.GetQualifiedNameFromString(qualifiedName);
end

--- Compose a qualified character name from a name and qualifier.
---@param name string? Name, e.g. "Zugzug".
---@param qualifier string? Realm or family name, e.g. "AzjolNerub".
---@return string? qualifiedName Qualified name, e.g. "Zugzug-AzjolNerub".
function TRP3_NameUtil.ComposeQualifiedName(name, qualifier)
	return Impl.ComposeQualifiedName(name, qualifier);
end

--- Decompose a qualified character name into its name and qualifier.
---@param qualifiedName string Qualified name, e.g. "Zugzug-AzjolNerub".
---@return string? name Name, e.g. "Zugzug".
---@return string? qualifier Realm or family name, e.g. "AzjolNerub".
function TRP3_NameUtil.DecomposeQualifiedName(qualifiedName)
	return Impl.DecomposeQualifiedName(qualifiedName);
end

--- Normalize a realm name for use in a qualified character name.
---@param realm string? Realm name, e.g. "Storm-Wind".
---@return string? normalizedRealm Normalized realm name, e.g. "StormWind".
function TRP3_NameUtil.NormalizeRealmName(realm)
	if realm and realm ~= "" then
		realm = string.gsub(realm, REALM_NORMALIZATION_PATTERN, "");
	end

	if realm == "" then
		realm = nil;
	end

	return realm;
end

--- Whether realm names should be included in display text.
---@return boolean shouldDisplay
function TRP3_NameUtil.ShouldDisplayRealmNames()
	return Impl.ShouldDisplayRealmNames();
end

---@return TRP3.NameUtil.Mode
function TRP3_NameUtil.GetCurrentMode()
	if RegionalUniqueNamesEnabled and RegionalUniqueNamesEnabled() then
		return TRP3_NameUtil.Mode.RegionalUnique;
	else
		return TRP3_NameUtil.Mode.RealmQualified;
	end
end

---@param mode TRP3.NameUtil.Mode
---@return TRP3.NameUtil.Implementation
local function GetImplementation(mode)
	if mode == TRP3_NameUtil.Mode.RealmQualified then
		return RealmQualifiedNameImpl;
	elseif mode == TRP3_NameUtil.Mode.RegionalUnique then
		return RegionalUniqueNameImpl;
	end

	assertsafe(false,  "Unable to determine name implementation for this client");
	return RealmQualifiedNameImpl;
end

Impl = GetImplementation(TRP3_NameUtil.GetCurrentMode());
return TRP3_NameUtil;
