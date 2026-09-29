---@meta

--- Character name, eg. "Zugzug" or "John Stormwind". Does not include
--- a realm component.
---@alias TRP3.CharacterName string

--- Realm name, eg. "Tichondrius". Can be nil on clients that use regional
--- character identifiers.
---@alias TRP3.RealmName string?

--- Fully qualified character name, eg. "Zugzug-Tichondrius" or
--- "John Stormwind".
---@alias TRP3.QualifiedName string

---@class TRP3.NameUtil.Implementation
local NameUtilImplementation = {};

--- Normalize raw name values into a character name and realm.
---@param name string? Character name or given name.
---@param qualifier string? Realm name or family name.
---@return TRP3.CharacterName? normalizedName Character name.
---@return TRP3.RealmName normalizedRealm Realm name.
function NameUtilImplementation.NormalizeUnitName(name, qualifier) end

--- Compose a qualified character name from a name and realm.
---@param name TRP3.CharacterName? Character name.
---@param realm TRP3.RealmName Realm name.
---@return TRP3.QualifiedName? qualifiedName Qualified name.
function NameUtilImplementation.ComposeQualifiedName(name, realm) end

--- Decompose a qualified character name into its name and realm.
---@param qualifiedName TRP3.QualifiedName Qualified name.
---@return TRP3.CharacterName? name Character name.
---@return TRP3.RealmName realm Realm name.
function NameUtilImplementation.DecomposeQualifiedName(qualifiedName) end

--- Get a qualified character name from a combined name string.
---@param qualifiedName string Combined name.
---@return TRP3.QualifiedName? qualifiedName Qualified name.
function NameUtilImplementation.GetQualifiedNameFromString(qualifiedName) end

--- Whether realm names should be included in display text.
---@return boolean shouldDisplay
function NameUtilImplementation.ShouldDisplayRealmNames() end
