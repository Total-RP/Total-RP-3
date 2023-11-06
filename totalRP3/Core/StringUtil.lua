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

local function CanonicalizeSearchString(str)
	str = string.gsub(str, "[%p%c%s]", "-");
	str = string.utf8lower(str);
	return str;
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
		searchText = CanonicalizeSearchString(searchText);
		candidateText = CanonicalizeSearchString(candidateText);
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
		searchText = CanonicalizeSearchString(searchText);
	end

	local matchedScore = math.huge;
	local matchedText;

	for _, candidateText in ipairs(candidateList) do
		local score;

		if requireExactMatch then
			score = (strcmputf8i(searchText, candidateText) == 0) and -math.huge or math.huge
		else
			score = TRP3_StringUtil.CalculateSearchScore(searchText, CanonicalizeSearchString(candidateText));
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
