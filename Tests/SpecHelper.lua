-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: allow defined
-- luacheck: ignore 131

UNKNOWNOBJECT = "Unknown";

Constants = {};

Constants.CharacterNameSeparatorConsts = {
	CHARACTERNAME_REALMNAME_SEPARATOR = "-",
	CHARACTERNAME_SURNAME_SEPARATOR = " ",
};

-- luacheck: ignore
function string.contains(value, substring)
	return string.find(value, substring, 1, true) ~= nil;
end

-- luacheck: ignore
function string.split(separator, value, _limit)
	local separatorStart, separatorEnd = string.find(value, separator, 1, true);
	if not separatorStart then
		return value;
	end
	return value:sub(1, separatorStart - 1), value:sub(separatorEnd + 1);
end

-- luacheck: ignore
function string.join(separator, ...)
	return table.concat({...}, separator);
end

function canaccessvalue(_value)
	return true;
end

function canaccessallvalues(...)
	for index = 1, select("#", ...) do
		if not canaccessvalue(select(index, ...)) then
			return false;
		end
	end
	return true;
end

function scrubsecretvalues(...)
	local values = { n = select("#", ...), ... };

	for index = 1, values.n do
		if not canaccessvalue(values[index]) then
			values[index] = nil;
		end
	end

	return unpack(values, 1, values.n);
end

function RegionalUniqueNamesEnabled()
	return false;
end

local SOURCE = debug.getinfo(1, "S").source:sub(2);
local TESTS_DIRECTORY = SOURCE:match("^(.*[/\\])") or "./";
local ROOT_DIRECTORY = TESTS_DIRECTORY:gsub("Tests[/\\]$", "");

local function LoadFile(path, ...)
	local chunk = assert(loadfile(ROOT_DIRECTORY .. path))
	return chunk(...)
end

LoadFile("totalRP3/Core/NameUtil.lua");
LoadFile("totalRP3/Core/StringUtil.lua");
