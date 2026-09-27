-- luacheck: ignore

local SpecHelper = require("SpecHelper");

local function LoadNameUtil()
	SpecHelper.LoadFile("totalRP3/Core/NameUtil.lua");
	SpecHelper.LoadFile("totalRP3/Core/StringUtil.lua");
end

insulate("mode selection", function()
	setup(function()
		LoadNameUtil();
	end);

	it("selects realm-qualified mode when regional names are disabled", function()
		stub(_G, "RegionalUniqueNamesEnabled", false);
		assert.are.equal(TRP3_NameUtil.Mode.RealmQualified, TRP3_NameUtil.GetCurrentMode());
	end);

	it("selects regional unique mode when regional names are enabled", function()
		stub(_G, "RegionalUniqueNamesEnabled", true);
		assert.are.equal(TRP3_NameUtil.Mode.RegionalUnique, TRP3_NameUtil.GetCurrentMode());
	end);
end);

insulate("mode-independent names", function()
	setup(function()
		LoadNameUtil();
	end);

	it("joins given and family names", function()
		assert.are.equal("John Stormwind", TRP3_NameUtil.ComposeFullName("John", "Stormwind"));
	end);

	it("returns the available name when one part is absent", function()
		assert.are.equal("John", TRP3_NameUtil.ComposeFullName("John", nil));
		assert.is_nil(TRP3_NameUtil.ComposeFullName(nil, nil));
		assert.is_nil(TRP3_NameUtil.ComposeFullName(nil, "Stormwind"));
	end);

	it("decomposes a full name", function()
		local givenName, familyName = TRP3_NameUtil.DecomposeFullName("John Stormwind");
		assert.are.equal("John", givenName);
		assert.are.equal("Stormwind", familyName);
	end);

	it("preserves the remaining words in a family name", function()
		local givenName, familyName = TRP3_NameUtil.DecomposeFullName("John Stormwind McStormyface");
		assert.are.equal("John", givenName);
		assert.are.equal("Stormwind McStormyface", familyName);
	end);

	it("decomposes a full name without a family name", function()
		local givenName, familyName = TRP3_NameUtil.DecomposeFullName("John");
		assert.are.equal("John", givenName);
		assert.is_nil(familyName);
	end);

	it("extracts given and family names", function()
		assert.are.equal("John", TRP3_NameUtil.ExtractGivenName("John Stormwind"));
		assert.are.equal("Stormwind", TRP3_NameUtil.ExtractFamilyName("John Stormwind"));
	end);

	it("returns nil when extracting names from nil or empty input", function()
		assert.is_nil(TRP3_NameUtil.ExtractGivenName(nil));
		assert.is_nil(TRP3_NameUtil.ExtractFamilyName(nil));
		assert.is_nil(TRP3_NameUtil.ExtractGivenName(""));
		assert.is_nil(TRP3_NameUtil.ExtractFamilyName(""));
	end);

	it("returns nil for a missing or empty qualified name string", function()
		assert.is_nil(TRP3_NameUtil.GetQualifiedNameFromString(nil));
		assert.is_nil(TRP3_NameUtil.GetQualifiedNameFromString(""));
	end);

	it("normalizes realm names", function()
		assert.are.equal("StormWind", TRP3_NameUtil.NormalizeRealmName("Storm-Wind"));
		assert.are.equal("StormWind", TRP3_NameUtil.NormalizeRealmName("Storm Wind"));
		assert.are.equal("StormWind", TRP3_NameUtil.NormalizeRealmName("Storm.Wind"));
	end);

	it("returns nil for an empty realm name", function()
		assert.is_nil(TRP3_NameUtil.NormalizeRealmName(""));
		assert.is_nil(TRP3_NameUtil.NormalizeRealmName(nil));
	end);
end);

insulate("realm-qualified names", function()
	setup(function()
		stub(_G, "RegionalUniqueNamesEnabled", false);
		LoadNameUtil();
	end);

	it("displays realm names", function()
		assert.is_true(TRP3_NameUtil.ShouldDisplayRealmNames());
	end);

	it("uses the given name as the full name", function()
		stub(_G, "UnitName", function() return "John", "Stormwind" end);
		assert.are.equal("John", TRP3_NameUtil.GetDisplayName("target"));
	end);

	it("returns nil for an unknown display name", function()
		stub(_G, "UnitName", function() return UNKNOWNOBJECT, "Stormwind" end);
		assert.is_nil(TRP3_NameUtil.GetDisplayName("target"));
	end);

	it("gets an unmodified full name from a unit", function()
		stub(_G, "UnitNameUnmodified", function() return "John", "Stormwind" end);
		assert.are.equal("John", TRP3_NameUtil.GetUnmodifiedName("target"));
	end);

	it("joins a unit name to its realm", function()
		stub(_G, "UnitNameUnmodified", function() return "John", "Stormwind" end);
		assert.are.equal("John-Stormwind", TRP3_NameUtil.GetQualifiedName("target"));
	end);

	it("joins name parts to their realm", function()
		assert.are.equal("John-Stormwind", TRP3_NameUtil.ComposeQualifiedName("John", "Stormwind"));
	end);

	it("returns nil for a missing unit name", function()
		stub(_G, "UnitNameUnmodified", function() return nil, nil end);
		assert.is_nil(TRP3_NameUtil.GetQualifiedName("target"));
	end);

	it("gets a qualified name from a name string", function()
		stub(_G, "GetNormalizedRealmName", function() return "Stormwind" end);
		assert.are.equal("John-Stormwind", TRP3_NameUtil.GetQualifiedNameFromString("John"));
		assert.are.equal("John-OtherRealm", TRP3_NameUtil.GetQualifiedNameFromString("John-OtherRealm"));
	end);

	it("applies case conversion to qualified name strings", function()
		assert.are.equal("John-Stormwind", TRP3_NameUtil.GetQualifiedNameFromString("john-stormwind"));
	end);

	it("normalizes realm punctuation", function()
		assert.are.equal("John-StormWind", TRP3_NameUtil.ComposeQualifiedName("John", "Storm-Wind"));
	end);

	it("preserves an unknown realm name", function()
		assert.are.equal("John-Unknown", TRP3_NameUtil.ComposeQualifiedName("John", UNKNOWNOBJECT));
	end);

	it("decomposes a qualified name", function()
		local name, realm = TRP3_NameUtil.DecomposeQualifiedName("John-Stormwind");
		assert.are.equal("John", name);
		assert.are.equal("Stormwind", realm);
	end);

	it("decomposes a qualified name without a realm", function()
		stub(_G, "GetNormalizedRealmName", function() return "Stormwind" end);
		local name, realm = TRP3_NameUtil.DecomposeQualifiedName("John");
		assert.are.equal("John", name);
		assert.are.equal("Stormwind", realm);
	end);

	it("normalizes spaces in a multi-word realm qualifier", function()
		local name, realm = TRP3_NameUtil.DecomposeQualifiedName("John-Stormwind McStormyface");
		assert.are.equal("John", name);
		assert.are.equal("StormwindMcStormyface", realm);
	end);

	it("returns nil for inaccessible qualified name parts", function()
		stub(_G, "canaccessvalue", function(value) return value ~= "secret" end);
		assert.is_nil(TRP3_NameUtil.ComposeQualifiedName("secret", "Stormwind"));
	end);

	it("rejects a qualified name when any part is inaccessible", function()
		stub(_G, "canaccessvalue", function(value) return value ~= "secret" end);
		assert.is_nil(TRP3_NameUtil.ComposeQualifiedName("John", "secret"));
	end);

	it("returns nil for missing, empty, or unknown character names", function()
		assert.is_nil(TRP3_NameUtil.ComposeQualifiedName(nil, "Stormwind"));
		assert.is_nil(TRP3_NameUtil.ComposeQualifiedName("", "Stormwind"));
		assert.is_nil(TRP3_NameUtil.ComposeQualifiedName(UNKNOWNOBJECT, "Stormwind"));
	end);

	it("uses the current realm when a unit has no realm", function()
		stub(_G, "UnitNameUnmodified", function() return "John", "" end);
		stub(_G, "GetNormalizedRealmName", function() return "Stormwind" end);
		assert.are.equal("John-Stormwind", TRP3_NameUtil.GetQualifiedName("target"));
	end);

	it("gets a name from a player GUID", function()
		stub(_G, "GetPlayerInfoByGUID", function()
			return nil, nil, nil, nil, nil, "John", "Stormwind", nil;
		end);
		assert.are.equal("John-Stormwind", TRP3_NameUtil.GetQualifiedNameByGUID("guid"));
	end);
end);

insulate("regional unique names", function()
	setup(function()
		stub(_G, "RegionalUniqueNamesEnabled", true);
		LoadNameUtil();
	end);

	it("does not display realm names", function()
		assert.is_false(TRP3_NameUtil.ShouldDisplayRealmNames());
	end);

	it("joins separate unit name parts", function()
		stub(_G, "UnitName", function() return "John", "Stormwind" end);
		assert.are.equal("John Stormwind", TRP3_NameUtil.GetDisplayName("target"));
	end);

	it("gets the unmodified regional name from a unit", function()
		stub(_G, "UnitNameUnmodified", function() return "John", "Stormwind" end);
		assert.are.equal("John Stormwind", TRP3_NameUtil.GetUnmodifiedName("target"));
	end);

	it("gets a regional qualified name from a unit", function()
		stub(_G, "UnitNameUnmodified", function() return "John", "Stormwind" end);
		assert.are.equal("John Stormwind", TRP3_NameUtil.GetQualifiedName("target"));
	end);

	it("joins name parts into a regional unique name", function()
		assert.are.equal("John Stormwind", TRP3_NameUtil.ComposeQualifiedName("John", "Stormwind"));
		assert.are.equal("John Stormwind", TRP3_NameUtil.ComposeQualifiedName("John Stormwind", nil));
	end);

	it("preserves the family name when parsing a regional name", function()
		assert.are.equal("John Stormwind", TRP3_NameUtil.GetQualifiedNameFromString("john stormwind"));
	end);

	it("requires a family name when parsing a regional name", function()
		assert.is_nil(TRP3_NameUtil.GetQualifiedNameFromString("John"));
	end);

	it("returns nil when parsing an unknown name", function()
		assert.is_nil(TRP3_NameUtil.GetQualifiedNameFromString(UNKNOWNOBJECT));
	end);

	it("returns nil when parsing an inaccessible name", function()
		stub(_G, "canaccessvalue", function(value) return value ~= "secret family" end);
		assert.is_nil(TRP3_NameUtil.GetQualifiedNameFromString("secret family"));
	end);

	it("decomposes a regional unique name", function()
		local name, realm = TRP3_NameUtil.DecomposeQualifiedName("John Stormwind");
		assert.are.equal("John Stormwind", name);
		assert.is_nil(realm);
	end);

	it("decomposes a full name without a family name", function()
		local name, realm = TRP3_NameUtil.DecomposeQualifiedName("John");
		assert.are.equal("John", name);
		assert.is_nil(realm);
	end);

	it("preserves the remaining words in a family name", function()
		local name, realm = TRP3_NameUtil.DecomposeQualifiedName("John Stormwind McStormyface");
		assert.are.equal("John Stormwind McStormyface", name);
		assert.is_nil(realm);
	end);

	it("returns nil for inaccessible non-qualified name parts", function()
		stub(_G, "canaccessvalue", function(value) return value ~= "secret" end);
		stub(_G, "UnitName", function() return "secret", "Stormwind" end);
		assert.is_nil(TRP3_NameUtil.GetDisplayName("target"));
	end);

	it("does not append a conflicting second value to a full name", function()
		stub(_G, "UnitNameUnmodified", function() return "John Stormwind", "Foo" end);
		assert.are.equal("John Stormwind", TRP3_NameUtil.GetQualifiedName("target"));
	end);

	it("gets a regional name from a GUID", function()
		stub(_G, "GetPlayerInfoByGUID", function()
			return nil, nil, nil, nil, nil, "John", "Stormwind", nil;
		end);
		assert.are.equal("John Stormwind", TRP3_NameUtil.GetQualifiedNameByGUID("guid"));
	end);

	it("returns nil when player info has no name", function()
		stub(_G, "GetPlayerInfoByGUID", function()
			return nil, nil, nil, nil, nil, nil, nil, nil;
		end);
		assert.is_nil(TRP3_NameUtil.GetQualifiedNameByGUID("guid"));
	end);
end);
