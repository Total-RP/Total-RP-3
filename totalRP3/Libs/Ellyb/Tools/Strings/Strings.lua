local TRP3_API = select(2, ...);
local Ellyb = TRP3_API.Ellyb;

if Ellyb.Strings then
	return
end

---@class Ellyb_Strings
local Strings = {};
Ellyb.Strings = Strings;

--- Generate a unique name by checking in a table indexed by names if a given exists and iterate to find a suitable non-taken name
---@param table table A table indexed by names
---@param name string The name we want to use
---@param customSuffixPattern string A custom pattern to use when inserting a sequential number (for example, ":1")
---@return string The final name that can be used, if the given name was taken, (n) will be appended,
---@overload fun(table:table, name:string):string
---For example if "My name" is already taken and "My name (1)" is already taken, will return "My name (2)"
function Strings.generateUniqueName(table, name, customSuffixPattern)
	local suffix = customSuffixPattern or "(%s)"
	local originalName = name;
	local tries = 1;
	while table[name] ~= nil do
		name = originalName .. " " .. suffix:format(tries);
		tries = tries + 1;
	end
	return name;
end

local BYTES_MULTIPLES = { "byte", "bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" };
if GetLocale() == "frFR" then
	-- French locales use the term "octet" instead of "byte" https://en.wikipedia.org/wiki/Octet_(computing)
	BYTES_MULTIPLES = { "octet", "octets", "Ko", "Mo", "Go", "To", "Po", "Eo", "Zo", "Yo" };
end

local NON_BREAKING_SPACE = " ";

--- Format a size in bytes into a human readable size string.
---@param bytes number A numeric value representing a size in bytes.
---@return string A string representation of the size (example: `"8 bytes"`, `"23GB"`)
function Strings.formatBytes(bytes)
	Ellyb.Assertions.isType(bytes, "number", "bytes");

	if bytes < 2 then
		return bytes .. NON_BREAKING_SPACE .. BYTES_MULTIPLES[1];
	end

	local i = tonumber(math.floor(math.log(bytes) / math.log(1024)));

	return RoundToSignificantDigits(bytes / math.pow(1024, i), 2) .. NON_BREAKING_SPACE .. BYTES_MULTIPLES[i + 2];
end
