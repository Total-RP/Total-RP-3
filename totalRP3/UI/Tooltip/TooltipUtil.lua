-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type { [GameTooltip]: { left: FontString?, right: FontString? }[] }
local TooltipFontStrings = setmetatable({}, { __index = function(t, k) t[k] = {}; return t[k]; end });

local function GetTooltipFontStrings(tooltip, numLines)
	local fontstrings = TooltipFontStrings[tooltip];

	for i = #fontstrings + 1, numLines do
		local left  = tooltip["TextLeft" .. i]  or _G[tooltip:GetName() .. "TextLeft" .. i];
		local right = tooltip["TextRight" .. i] or _G[tooltip:GetName() .. "TextRight" .. i];

		if not left and not right then
			break
		end

		fontstrings[i] = { left = left, right = right };
	end

	return fontstrings;
end

TRP3_TooltipUtil = {};

--- Returns the left and right fontstrings of a tooltip line, if present.
---@param tooltip GameTooltip The tooltip frame to query.
---@param line integer? The line index to obtain fontstrings for.
function TRP3_TooltipUtil.GetLineFontStrings(tooltip, line)
	local fontstrings = GetTooltipFontStrings(tooltip, line)[line];

	if fontstrings then
		return fontstrings.left, fontstrings.right;
	end
end

local function NextLineFontStrings(tooltip, line)
	line = line + 1;
	local left, right = TRP3_TooltipUtil.GetLineFontStrings(tooltip, line);

	if left or right then
		return line, left, right;
	end
end

--- Obtains an iterator for enumerating over the fontstrings in a tooltip.
---@param tooltip GameTooltip The tooltip frame to query.
---@param line integer? The line index to begin enumerating from.
function TRP3_TooltipUtil.EnumerateFontStrings(tooltip, line)
	return NextLineFontStrings, tooltip, line or 0;
end

--- Adds a single line to the tooltip.
---@param tooltip GameTooltip The tooltip frame to append to.
---@param text string The text to display on the line.
---@param options TRP3_TooltipUtil.LineOptions? Options for this line.
function TRP3_TooltipUtil.AddLine(tooltip, text, options)
	local wrap = options and options.wrap or false;
	local color = options and options.color or NORMAL_FONT_COLOR;

	local r, g, b = color:GetRGB();
	tooltip:AddLine(text, r, g, b, wrap);
end

--- Adds a two-column line to the tooltip.
---@param tooltip GameTooltip The tooltip frame to append to.
---@param textLeft string The text to display on the left side of the line.
---@param textRight string The text to display on the right side of the line.
---@param options TRP3_TooltipUtil.DoubleLineOptions? Options for this line.
function TRP3_TooltipUtil.AddDoubleLine(tooltip, textLeft, textRight, options)
	local colorLeft = options and (options.colorLeft or options.color) or NORMAL_FONT_COLOR;
	local colorRight = options and (options.colorRight or options.color) or NORMAL_FONT_COLOR;

	local rL, gL, bL = colorLeft:GetRGB();
	local rR, gR, bR = colorRight:GetRGB();

	tooltip:AddDoubleLine(textLeft, textRight, rL, gL, bL, rR, gR, bR);
end

--- Adds a blank line to the tooltip.
---@param tooltip GameTooltip The tooltip frame to append to.
function TRP3_TooltipUtil.AddBlankLine(tooltip)
	tooltip:AddLine(" ");
end

function TRP3_TooltipUtil.SetLineFontOptions(tooltip, line, height, flags)
	local fontStringLeft, fontStringRight = TRP3_TooltipUtil.GetLineFontStrings(tooltip, line);

	if fontStringLeft then
		TRP3_FontUtil.SetFontStringOptions(fontStringLeft, GameTooltipText, height, flags);
	end

	if fontStringRight then
		TRP3_FontUtil.SetFontStringOptions(fontStringRight, GameTooltipText, height, flags);
	end
end

function TRP3_TooltipUtil.HideTooltip(owner)
	local tooltip = TRP3_MainTooltip;

	if tooltip:IsOwned(owner) then
		tooltip:Hide();
	end
end

function TRP3_TooltipUtil.ShowTooltip(owner, generator, ...)
	local description = TRP3_Tooltip.CreateTooltipDescription(owner);
	TRP3_Tooltip.PopulateTooltipDescription(generator, owner, description, ...);
	TRP3_Tooltip.ProcessTooltipDescription(TRP3_MainTooltip, description);
end

---@class TRP3_TooltipUtil.LineOptions
---@field color ColorMixin? The color to apply to the line.
---@field wrap boolean? If true, automatically wrap text on the line.

---@class TRP3_TooltipUtil.DoubleLineOptions
---@field color ColorMixin? The color to apply to both sides of the line.
---@field colorLeft ColorMixin? The color to apply to the left side of the line.
---@field colorRight ColorMixin? The color to apply to the right side of the line.
