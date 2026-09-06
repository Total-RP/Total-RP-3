-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

--- ICU transliterator IDs for common string transformations.
TRP3_Transliterators = {
	--- Removes every character except Unicode letters.
	LettersOnly = "[^[:L:]] Remove",
};

TRP3_StringUtil = {};

local DequotePatterns =
{
	'^"(.*)"$',                        -- U+0022 Quotation Mark
	"^'(.*)'$",                        -- U+0027 Apostrophe
	"^\226\128\156(.*)\226\128\157$",  -- U+201C / U+201D Double Quotation Mark
	"^\194\171(.*)\194\187$",          -- U+00AB / U+00BB Double Angle Quotation Mark
};

--- Removes matching quotation marks from a string.
---@param string string
---@return string dequotedString
---@return boolean wasDequoted
function TRP3_StringUtil.DequoteString(string)
	for _, pattern in ipairs(DequotePatterns) do
		local dequoted, replacements = string.gsub(string, pattern, "%1");

		if replacements > 0 then
			return dequoted, true;
		end
	end

	return string, false;
end

--- Compares strings using locale-aware collation for sorting.
--- This does not apply transliteration or special empty-key handling.
---@param a string
---@param b string
---@param strength Enum.CollationStrength?
---@return boolean
function TRP3_StringUtil.SortCompareStrings(a, b, strength)
	strength = strength or Enum.CollationStrength.Primary;
	return C_Intl.CompareStrings(a, b, strength) < 0;
end

--- Returns whether the search text exactly or partially matches the candidate.
---@param searchText string
---@param candidateText string
---@return boolean matches
function TRP3_StringUtil.IsExactOrSubstringMatch(searchText, candidateText)
	return TRP3_StringUtil.CreateMatcher(searchText):Matches(candidateText);
end

--- Returns the best matching candidate, or nil if none match.
---@param searchText string
---@param candidateList string[]
---@return string? matchedText
function TRP3_StringUtil.FindBestMatch(searchText, candidateList)
	return TRP3_StringUtil.CreateMatcher(searchText):FindBestMatch(candidateList);
end

--- Returns the first name, starting with `prefix`, that satisfies `predicate`.
--- If the prefix is already available, it is returned unchanged; otherwise,
--- numbered suffixes are appended until an available name is found.
---@param predicate fun(name: string): boolean
---@param prefix string
---@param suffix string?
---@return string name
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

--- Normalizes consecutive blank lines and trims surrounding whitespace.
---@param str string
---@return string trimmed
function TRP3_StringUtil.TrimNewlinesAndSpaces(str)
	str = str:gsub("\n%s*\n%s*", "\n\n");
	return string.trim(str);
end

-- String Matching
------------------------------------------------------------------------------

local SearchScoreConstants = {
	EmptyMatchScore = 0;
	DefinitiveMatchScore = -math.huge;
	NoMatchScore = math.huge;
};

---@param candidate string
---@param query string
---@param collation Enum.CollationStrength
---@return integer? startIndex
local function FindFirstStringMatch(candidate, query, collation)
	local matches = C_Intl.FindStringMatches(candidate, query, collation);
	local startIndex = matches and matches[1];
	-- C_Intl currently(?) returns zero-based string offsets, whereas the
	-- legacy string.find approach used one-based offsets.
	return startIndex and startIndex + 1 or nil;
end

---@param searchText string
---@param candidateText string
---@param collation Enum.CollationStrength
---@return number score
local function CalculateSearchScore(searchText, candidateText, collation)
	-- Largely just copying what Blizzard does for console autocomplete.
	-- Lower scores are better.

	local substringStartIndex = FindFirstStringMatch(candidateText, searchText, collation);

	if not substringStartIndex then
		return SearchScoreConstants.NoMatchScore;
	end

	local editDistance = CalculateStringEditDistance(searchText, candidateText)
	local substringScore = -#searchText * 10;
	local startOfMatchScore = ClampedPercentageBetween(substringStartIndex, 15, 1) * -2 * #searchText;

	return editDistance + substringScore + startOfMatchScore;
end

---@param result boolean
---@param successScore number?
---@param failureScore number?
local function CalculateMatchScore(result, successScore, failureScore)
	successScore = (successScore == nil) and SearchScoreConstants.DefinitiveMatchScore or successScore;
	failureScore = (failureScore == nil) and SearchScoreConstants.NoMatchScore or failureScore;
	return result and successScore or failureScore;
end

---@alias TRP3.StringMatcherMode "substring" | "exact" | "pattern"
---@alias TRP3.StringMatcherNormalization "none" | "casefold" | "destructive"

---@class (exact) TRP3.StringMatcherOptions
---@field mode? TRP3.StringMatcherMode
--- Matching mode. Defaults to `"exact"` for quoted queries and `"substring"`
--- otherwise.
---@field normalization? TRP3.StringMatcherNormalization
--- Normalization applied before matching. Defaults to `"destructive"` for
--- all non-pattern modes. Pattern queries are never normalized; candidates
--- may still be normalized if opted-in.
---@field collation? Enum.CollationStrength
--- Collation strength used for substring matching. Defaults to Primary.
---@field predicate? fun(query: string, candidate: string): boolean
--- Custom matcher taking precedence over `mode`.
---@field emptyQueryMatches? boolean
--- Whether an empty query matches every candidate. Defaults to true.

---@class TRP3.StringMatcher
---@field private options TRP3.StringMatcherOptions
---@field private rawQuery string
---@field private preparedQuery string
---@field private mode TRP3.StringMatcherMode
---@field private predicate? fun(query: string, candidate: string): boolean
---@field private collation Enum.CollationStrength
---@field private normalization TRP3.StringMatcherNormalization
---@field private emptyQueryMatches boolean
---@field private normalizedStringCache { [string]: string }
local StringMatcher = {};

---@param query string
---@param options TRP3.StringMatcherOptions?
function StringMatcher:__init(query, options)
	self.options = options or {};
	self.rawQuery = nil;
	self.predicate = self.options.predicate;
	self.collation = self.options.collation or Enum.CollationStrength.Primary;
	self.emptyQueryMatches = self.options.emptyQueryMatches ~= false;
	self.normalizedStringCache = {};

	self:SetQuery(query);
end

--- Returns whether `candidateText` matches the configured query.
---@param candidateText string
---@return boolean matches
function StringMatcher:Matches(candidateText)
	if self.preparedQuery == "" then
		return self.emptyQueryMatches;
	end

	local candidate = self:GetCandidate(candidateText);

	if self.predicate then
		return self.predicate(self.preparedQuery, candidate);
	elseif self.mode == "exact" then
		return self.preparedQuery == candidate;
	elseif self.mode == "pattern" then
		return string.find(candidate, self.preparedQuery) ~= nil;
	else
		return FindFirstStringMatch(candidate, self.preparedQuery, self.collation) ~= nil;
	end
end

--- Returns a match score for `candidateText`, where lower scores are better.
---@param candidateText string
---@return number score
function StringMatcher:Score(candidateText)
	if self.preparedQuery == "" then
		return CalculateMatchScore(self.emptyQueryMatches, SearchScoreConstants.EmptyMatchScore);
	end

	local candidate = self:GetCandidate(candidateText);

	if self.predicate then
		return CalculateMatchScore(self.predicate(self.preparedQuery, candidate));
	elseif self.mode == "exact" then
		return CalculateMatchScore(self.preparedQuery == candidate);
	elseif self.mode == "pattern" then
		return CalculateMatchScore(string.find(candidate, self.preparedQuery) ~= nil);
	else
		return CalculateSearchScore(self.preparedQuery, candidate, self.collation);
	end
end

--- Returns the best matching candidate, or nil if none match.
---@param candidateList string[]
---@return string? matchedText
function StringMatcher:FindBestMatch(candidateList)
	if self.preparedQuery == "" then
		return nil;
	end

	local matchedScore = SearchScoreConstants.NoMatchScore;
	local matchedText;

	for _, candidateText in ipairs(candidateList) do
		local score = self:Score(candidateText);

		if score < matchedScore then
			matchedScore = score;
			matchedText = candidateText;
		end

		if score == SearchScoreConstants.DefinitiveMatchScore then
			break;
		end
	end

	return matchedText;
end

--- Returns the original query string currently used by this matcher.
---@return string query
function StringMatcher:GetQuery()
	return self.rawQuery;
end

--- Changes the query used by this matcher.
---@param query string
function StringMatcher:SetQuery(query)
	if self.rawQuery == query then
		return;
	end

	local dequotedQuery, quoted = TRP3_StringUtil.DequoteString(query);
	local mode = self.options.mode or (quoted and "exact" or "substring");
	local normalization = self.options.normalization;

	self:ClearCache();

	if normalization == nil then
		-- Patterns are assumed by default to want no normalization of
		-- candidates unless explicitly requested. The default otherwise
		-- is destructive normalization.
		if mode == "pattern" then
			normalization = "none";
		else
			normalization = "destructive";
		end
	end

	self.mode = mode;
	self.normalization = normalization;
	self.rawQuery = query;

	if mode == "pattern" or normalization == "none" then
		self.preparedQuery = dequotedQuery;
	else
		self.preparedQuery = self:GetNormalizedString(dequotedQuery);
	end
end

--- Clears cached normalized query and candidate strings.
function StringMatcher:ClearCache()
	self.normalizedStringCache = {};
end

---@private
---@param text string
function StringMatcher:GetNormalizedString(text)
	local normalized = self.normalizedStringCache[text];

	if normalized == nil then
		normalized = text;

		if self.normalization == "destructive" then
			normalized = string.gsub(normalized, "[%p%c%s]+", "");
		end

		if self.normalization == "destructive" or self.normalization == "casefold" then
			normalized = C_Intl.FoldCase(normalized);
		end

		self.normalizedStringCache[text] = normalized;
	end

	return normalized;
end

---@private
---@param candidateText string
function StringMatcher:GetCandidate(candidateText)
	if self.normalization == "none" then
		return candidateText;
	end

	return self:GetNormalizedString(candidateText);
end

--- Creates a matcher for the supplied query and options.
--- The matcher can be reused for multiple candidate strings.
---@param query string
---@param options TRP3.StringMatcherOptions?
---@return TRP3.StringMatcher matcher
function TRP3_StringUtil.CreateMatcher(query, options)
	local matcher = TRP3_API.AllocateObject(StringMatcher);
	matcher:__init(query, options);
	return matcher;
end

-- String Sorting
------------------------------------------------------------------------------

---@enum TRP3.SortKeyDirection
TRP3_SortKeyDirection = {
	Ascending = "ascending",
	Descending = "descending",
};

---@enum TRP3.SortKeyEmptyPosition
TRP3_SortKeyEmptyPosition = {
	First = "first",
	Last = "last",
};

---@class TRP3.SortKeyOptions
---@field collation Enum.CollationStrength?
---@field transliterator string?
---@field projection? fun(value: any): string?
---@field emptyKeyPosition TRP3.SortKeyEmptyPosition?

---@param value any
---@param options TRP3.SortKeyOptions?
---@return string
function TRP3_StringUtil.GetSortKey(value, options)
	options = options or {};

	local normalizedValue = value;

	if options.projection then
		normalizedValue = options.projection(normalizedValue);
	end

	if normalizedValue == nil then
		normalizedValue = "";
	end

	if options.transliterator then
		normalizedValue = string.trim(C_Intl.Transliterate(normalizedValue, options.transliterator));
	end

	local prefix = "";

	if options.emptyKeyPosition ~= nil then
		local isEmpty = (normalizedValue == "");
		local emptyValuesSortLast = (options.emptyKeyPosition == TRP3_SortKeyEmptyPosition.Last);
		prefix = (isEmpty == emptyValuesSortLast) and "\255" or "\000";
	end

	local collation = options.collation or Enum.CollationStrength.Primary;
	return prefix .. (C_Intl.GetSortKey(normalizedValue, collation) or "");
end
