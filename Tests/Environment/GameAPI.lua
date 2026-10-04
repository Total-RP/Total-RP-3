-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

function GetLocale()
	return "enUS";
end

function GetNormalizedRealmName()
	return "ArgentDawn";
end

function GetRealmName()
	return "Argent Dawn";
end

function IsTrialAccount()
	return false;
end

function IsVeteranTrialAccount()
	return false;
end

function UnitClass(_unitToken)
	return "Warrior", "WARRIOR", 1;
end

function UnitFactionGroup(_unitToken)
	return "Alliance", "Alliance";
end

function UnitNameUnmodified(_unitToken)
	return "Johnstormwind", "ArgentDawn";
end

function UnitRace(_unitToken)
	return "Human", "Human", 1;
end

function CreateFromMixins(...)
	return Mixin({}, ...);
end

function Mixin(object, ...)
	for index = 1, select("#", ...) do
		for key, value in pairs(select(index, ...)) do
			object[key] = value;
		end
	end

	return object;
end

C_ColorUtil = {};

function C_ColorUtil.WrapTextInColor(text, color)
	return string.format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, text);
end

C_EncodingUtil = {};

function C_EncodingUtil.DecompressString(data, _method)
	return data;
end

function C_EncodingUtil.DeserializeCBOR(data)
	return data;
end

C_GameRules = {};

function C_GameRules.IsGameRuleActive(_rule)
	return false;
end

C_Intl = {};

function C_Intl.ToUpper(value)
	return string.upper(value);
end

C_Item = {};

function C_Item.RequestLoadItemDataByID(_itemID)
end

C_Spell = {};

function C_Spell.RequestLoadSpellData(_spellID)
end

C_Texture = {};

function C_Texture.GetAtlasInfo(_atlasName)
	return { width = 16, height = 16 };
end

local Frame = {};
Frame.__index = Frame;

function Frame:SetScript(_scriptType, _handler)
end

function Frame:RegisterEvent(_event)
end

function Frame:RegisterUnitEvent(_event, _unitToken)
end

function Frame:UnregisterEvent(_event)
end

function CreateFrame(_frameType, _name, _parent, _template)
	return setmetatable({}, Frame);
end
