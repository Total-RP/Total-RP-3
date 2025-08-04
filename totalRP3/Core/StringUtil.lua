-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_StringUtil = {};

local DequotePatterns =
{
	'^"(.*)"$',                        -- U+0022 Quotation Mark
	"^'(.*)'$",                        -- U+0027 Apostrophe
	"^\226\128\156(.*)\226\128\157$",  -- U+201C / U+201D Double Quotation Mark
	"^\194\171(.*)\194\187$",          -- U+00AB / U+00BB Double Angle Quotation Mark
};

function TRP3_StringUtil.DequoteString(string)
	for _, pattern in ipairs(DequotePatterns) do
		local dequoted, replacements = string.gsub(string, pattern, "%1");

		if replacements > 0 then
			return dequoted, true;
		end
	end

	return string, false;
end

function TRP3_StringUtil.SortCompareStrings(a, b)
	return strcmputf8i(a, b) < 0;
end

local function GenerateSearchableString(str)
	str = string.gsub(str, "[%p%c%s]+", "");
	str = string.lower(str);
	str = string.trim(str);
	return str;
end

local SearchableStringCache = setmetatable({}, {
	__index = function(tbl, str)
		tbl[str] = GenerateSearchableString(str);
		return rawget(tbl, str);
	end,
});

function TRP3_StringUtil.GenerateSearchableString(str)
	return SearchableStringCache[str];
end

function TRP3_StringUtil.CalculateSearchScore(searchText, candidateText)
	-- Largely just copying what Blizzard does for console autocomplete.
	-- Lower scores are better.

	local substringStartIndex = string.find(candidateText, searchText, 1, true);
	local editDistance = CalculateStringEditDistance(searchText, candidateText);

	if not substringStartIndex and editDistance == math.max(#searchText, #candidateText) then
		return math.huge;  -- Supplied text doesn't match at all.
	end

	local substringScore = 0;
	local startOfMatchScore = 0;

	if substringStartIndex then
		substringScore = -#searchText * 10;
		startOfMatchScore = ClampedPercentageBetween(substringStartIndex, 15, 1) * -2 * #searchText;
	end

	return editDistance + substringScore + startOfMatchScore;
end

function TRP3_StringUtil.IsExactOrSubstringMatch(searchText, candidateText)
	local requireExactMatch;
	searchText, requireExactMatch = TRP3_StringUtil.DequoteString(searchText);

	if not requireExactMatch then
		searchText = TRP3_StringUtil.GenerateSearchableString(searchText);
		candidateText = TRP3_StringUtil.GenerateSearchableString(candidateText);
	end

	if requireExactMatch then
		return (strcmputf8i(searchText, candidateText) == 0);
	else
		return string.find(candidateText, searchText, 1, true) ~= nil;
	end
end

function TRP3_StringUtil.FindClosestMatch(searchText, candidateList)
	local requireExactMatch;
	searchText, requireExactMatch = TRP3_StringUtil.DequoteString(searchText);

	if not requireExactMatch then
		searchText = TRP3_StringUtil.GenerateSearchableString(searchText);
	end

	local matchedScore = math.huge;
	local matchedText;

	for _, candidateText in ipairs(candidateList) do
		local score;

		if requireExactMatch then
			score = (strcmputf8i(searchText, candidateText) == 0) and -math.huge or math.huge
		else
			score = TRP3_StringUtil.CalculateSearchScore(searchText, TRP3_StringUtil.GenerateSearchableString(candidateText));
		end

		if score < matchedScore then
			matchedScore = score;
			matchedText = candidateText;
		end

		if matchedScore == -math.huge then
			break;
		end
	end

	return matchedText;
end

function TRP3_StringUtil.GenerateIncrementalName(predicate, prefix, suffix)
	if not suffix then
		suffix = " (%d)";
	end

	local name = prefix;
	local count = 1;

	while not predicate(name) do
		name = prefix .. string.format(suffix, count);
		count = count + 1;
	end

	return name;
end

---@class TRP3.StringBuilder
---@field private buffer string[]
---@field private index integer
---@field private size integer
local StringBuilder = {};

function StringBuilder:IsEmpty()
	return self.size == 0;
end

function StringBuilder:GetSize()
	return self.size;
end

function StringBuilder:Clear()
	self.index = 1;
	self.size = 0;
end

function StringBuilder:ClearQueue()
	self.index = self.size + 1;
end

---@param str string
function StringBuilder:Append(str)
	local index = self.index;
	self.buffer[index] = str;
	self.index = index + 1;
	self.size = index;
end

---@param format string
function StringBuilder:AppendFormatted(format, ...)
	self:Append(string.format(format, ...));
end

---@param str string
function StringBuilder:Queue(str)
	local index = self.index;
	self.buffer[index] = str;
	self.index = index + 1;
end

---@param format string
function StringBuilder:QueueFormatted(format, ...)
	self:Queue(string.format(format, ...));
end

---@param delimiter string?
function StringBuilder:Concat(delimiter)
	return table.concat(self.buffer, delimiter or "", 1, self.size);
end

---@param delimiter string?
function StringBuilder:Finalize(delimiter)
	local str = self:Concat(delimiter);
	self:Clear();
	return str;
end

---@param reservation number?
function TRP3_StringUtil.CreateStringBuilder(reservation)
	local builder = {
		buffer = table.create(reservation or 16);
		index = 1;
		size = 0;
	};

	return TRP3_API.SetObjectPrototype(builder, StringBuilder);
end

local ByteToChar = {};

for i = 0, 255 do
	ByteToChar[i] = string.char(i);
end

---@class TRP3.StringReader
---@field private data string
---@field private offset integer
---@field private length integer
local StringReader = {};

function StringReader:IsEmpty()
	return self.offset > self.length;
end

function StringReader:GetString()
	return self.data;
end

function StringReader:GetOffset()
	return self.offset;
end

function StringReader:GetLength()
	return self.length;
end

function StringReader:GetRemainingLength()
	return self.length - self.offset;
end

function StringReader:GetRemainingString()
	return string.sub(self.data, self.offset, self.length);
end

function StringReader:AdvanceBy(n)
	self.offset = self.offset + n;
end

function StringReader:AdvanceTo(offset)
	self.offset = offset;
end
function StringReader:PeekByte()
	local offset = self.offset;
	return string.byte(self.data, offset, offset);
end

function StringReader:PeekChar()
	return ByteToChar[self:PeekByte()];
end

function StringReader:ReadByte()
	local offset = self.offset;
	local byte = string.byte(self.data, offset, offset);
	self.offset = offset + 1;
	return byte;
end

function StringReader:ReadChar()
	return ByteToChar[self:ReadByte()];
end

function StringReader:ReadPattern(pattern)
	local offset = self.offset;
	local _, captureEnd, capture = string.find(self.data, pattern, offset);

	if captureEnd then
		self.offset = captureEnd + 1;
		return capture;
	end
end

function StringReader:SkipWhitespace()
	local _, whitespaceEnd = string.find(self.data, "^%s*", self.offset);
	self.offset = whitespaceEnd + 1;
end

function TRP3_StringUtil.CreateStringReader(str)
	local reader = { data = str, offset = 1, length = #str };
	return TRP3_API.SetObjectPrototype(reader, StringReader);
end
