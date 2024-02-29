-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

--- Enumeration of valid font alphabets. These strings match the tokens used
--- in XML FontFamily definitions.
---@alias TRP3.FontAlphabet "roman" | "korean" | "simplifiedchinese" | "traditionalchinese" | "russian"

---@type { [TRP3.FontAlphabet]: string }
local AlphabetTexts = {
	["roman"] = "T",
	["korean"] = "더",
	["simplifiedchinese"] = "這",
	["traditionalchinese"] = "以",
	["russian"] = "Э",
};

TRP3_FontUtil = {};

local DummyFontString = UIParent:CreateFontString();

--- Obtains the font face, height, and flags that would be selected from a
--- font object based upon an alphabet.
---
---@param font FontObject The font family to query.
---@param alphabet TRP3.FontAlphabet The alphabet to query.
function TRP3_FontUtil.GetFontForAlphabet(font, alphabet)
	DummyFontString:SetFontObject(font);
	DummyFontString:SetText(AlphabetTexts[alphabet]);
	return DummyFontString:GetFontObject():GetFont();
end

--- Obtains the font face, height, and flags that would be selected from a
--- font object if the supplied text were used.
---
---@param font FontObject The font family to query.
---@param text string The text to test.
function TRP3_FontUtil.GetFontForText(font, text)
	DummyFontString:SetFontObject(font);
	DummyFontString:SetText(text);
	return DummyFontString:GetFontObject():GetFont();
end

--- Replaces the font used by a specific alphabet within a font family.
---
--- If the height or flags parameters are nil, the existing values for the
--- current font will be retained.
---
---@param font FontObject The font family to modify.
---@param alphabet TRP3.FontAlphabet The alphabet to change the font of.
---@param file string? The desired font face for this alphabet.
---@param height number? The desired font height for this alphabet.
---@param flags string? The desired font flags for this alphabet.
function TRP3_FontUtil.SetFontForAlphabet(font, alphabet, file, height, flags)
	DummyFontString:SetFontObject(font);
	DummyFontString:SetText(AlphabetTexts[alphabet]);

	local alphabetFont = DummyFontString:GetFontObject();
	local alphabetFile, alphabetHeight, alphabetFlags = alphabetFont:GetFont();

	alphabetFont:SetFont(file or alphabetFile, height or alphabetHeight, flags or alphabetFlags);
end

--- Changes the height and outlining options for all alphabet members of a
--- supplied font family.
---
--- If the height or flags parameters are nil, the existing values for the
--- current fonts will be retained.
---
---@param font FontObject The font family to modify.
---@param height number? The desired height to apply to all family members.
---@param flags string? The desired flags to apply to all family members.
function TRP3_FontUtil.SetFontOptions(font, height, flags)
	local file = nil;

	TRP3_FontUtil.SetFontForAlphabet(font, "roman", file, height, flags);
	TRP3_FontUtil.SetFontForAlphabet(font, "korean", file, height, flags);
	TRP3_FontUtil.SetFontForAlphabet(font, "simplifiedchinese", file, height, flags);
	TRP3_FontUtil.SetFontForAlphabet(font, "traditionalchinese", file, height, flags);
	TRP3_FontUtil.SetFontForAlphabet(font, "russian", file, height, flags);
end

--- Changes the height and outlining options applied to a font string.
---
--- This function picks an appropriate font family from the supplied font
--- object based upon the current text content of the string.
---
--- If the height or flags parameters are nil, the existing values for the
--- selected font will be retained.
---
---@param fontString FontString The font string to change the font of.
---@param font FontObject The font object to select a font face from.
---@param height number? The desired height of the font.
---@param flags string? The desired flags of the font.
function TRP3_FontUtil.SetFontStringOptions(fontString, font, height, flags)
	local alphabetFile, alphabetHeight, alphabetFlags = TRP3_FontUtil.GetFontForText(font, fontString:GetText());
	fontString:SetFont(alphabetFile, height or alphabetHeight, flags or alphabetFlags);
end
