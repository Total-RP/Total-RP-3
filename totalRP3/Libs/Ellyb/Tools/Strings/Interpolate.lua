---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Strings.interpolate then
	return
end

---@type Ellyb_Strings
local Strings = Ellyb.Strings;

--- Cache used by the Interpolator class that takes a format specifier without its preceeding "%" and gives it one.
--- This cache exists because we treat the replacement as a hot loop, and string concatenation is not very performant.
---@type string[]
local replacementCache = setmetatable({}, {
	__mode = "k",
	__index = function(self, specifier)
		self[specifier] = "%" .. specifier;
		return self[specifier];
	end,
});

--- Class that manages the replacement of named references in a format string.
--- It exists purely because we don't necessarily want to allocate a garbage
--- closure each time String.interpolate() is called.
---
--- This class should be treated as an implementation detail and not exported.
local Interpolator = Ellyb.Class("Interpolator");
Interpolator:include(Ellyb.PooledObjectMixin);

function Interpolator:initialize()
	-- Ensure the replacements and offset are reset on each re-init.
	self.replacements = nil;
	self.offset = 1;

	-- We'll need a closure to forward the actual replacement to our method. This should be cached across each init.
	self.onReplacement = self.onReplacement or Ellyb.Functions.bind(self.Replace, self);
end

--- Formats the given format string against the given table of replacements.
--- @param formatString string The template string to format.
--- @param replacements string Table of replacements to make.
--- @return string
function Interpolator:Format(formatString, replacements)
	-- Store the replacements and reset the offset, if present.
	self.replacements = replacements;
	self.offset = 1;

	-- This monstrosity below is a foul and arcane incantation that basically
	-- matches the subset of C's printf that Lua actually implements, as
	-- well as providing support for Blizzard's positional extension syntax.
	--
	-- If you're going to change this, please consult these references:
	--   - http://www.cplusplus.com/reference/cstdio/printf/
	--   - http://pgl.yoyo.org/luai/i/string.format
	local MATCH_STRING = "(%%((%d?)[%w_]*)$?([-+ #0]-%d*%.?%d*[diuoxXfFeEgGcsq]))";
	return formatString:gsub(MATCH_STRING, self.onReplacement);
end

--- Internal handler invoked by string.gsub when it finds a specifier match.
---@param full string
---@param key string
---@param keyFirstChar string
---@param specifier string
function Interpolator:Replace(full, key, keyFirstChar, specifier)
	-- Try converting the key to a number if anything.
	key = tonumber(key) or key;

	-- No key? Standard replacement. Increment our internal offset with it.
	if not key or key == "" then
		local offset = self.offset;
		local output = full:format(self.replacements[offset]);

		self.offset = offset + 1;
		return output;
	end

	-- Our documentation claims we only support Lua identifiers as keys, or fully numeric ones.
	-- If the first character is numeric but the full key isn't,
	-- then you're being mean by giving us something that isn't actually a Lua identifier.
	if tonumber(keyFirstChar) and not tonumber(key) then
		return;
	end

	-- Keyed/named replacement. The one catch here is specifier lacks the preceeding "%",
	-- and we can't use the full match because it has the key. Good thing we made that cache table, right?
	return replacementCache[specifier]:format(self.replacements[key]);
end

--- Formats the given format string against the given table of replacements.
---
---  The format string can contain standard format specifiers as well as WoW
---  ones ("%s", "%1$s") as well as named replacements in the similar form
---  of "%KEY_NAME$s".
---
---  If the key segment of the specifier can be converted to a number, it
---  will be. The key can otherwise only contain characters that would form a
---  valid Lua identifier.
---
---  Positional replacements (%s) are looked up in the array part of the table
---  and, for each match, an offset incremented. That is to say, the behavior
---  between this and string.format() is be identical.
---
---  @param formatString string The template string to format.
---  @param replacements string[] Table of replacements to make.
function Strings.interpolate(formatString, replacements)
	local replacer = Interpolator();
	local formatted = replacer:Format(formatString, replacements);
	replacer:ReleasePooledObject();
	return formatted;
end
