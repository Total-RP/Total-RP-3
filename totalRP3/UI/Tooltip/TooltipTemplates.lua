-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TooltipTemplates = {};

function TRP3_TooltipTemplates.CreateLine(text, color, wrap, leftOffset)
	local line = TRP3_Tooltip.CreateLineDescription();
	line:SetText(text);
	line:SetTextColor(color);
	line:SetWordWrap(wrap ~= false);
	line:SetLeftOffset(leftOffset);
	return line;
end

function TRP3_TooltipTemplates.CreateDoubleLine(leftText, rightText, leftColor, rightColor, wrap, leftOffset)
	local line = TRP3_Tooltip.CreateLineDescription();
	line:SetLeftText(leftText);
	line:SetLeftTextColor(leftColor);
	line:SetRightText(rightText);
	line:SetRightTextColor(rightColor);
	line:SetWordWrap(wrap ~= false);
	line:SetLeftOffset(leftOffset);
	return line;
end

function TRP3_TooltipTemplates.CreateTitleLine(text, color, wrap, leftOffset)
	local line = TRP3_TooltipTemplates.CreateLine(text, color or HIGHLIGHT_FONT_COLOR, wrap, leftOffset);
	line:SetFontObject(GameTooltipHeaderText);
	return line;
end

function TRP3_TooltipTemplates.CreateTitleLineWithIcon(text, icon, color, wrap, leftOffset)
	if icon ~= nil and icon ~= "" then
		local markup = TRP3_MarkupUtil.GenerateIconMarkup(icon, { size = 24 });
		text = string.join(" ", markup, text);
	end

	return TRP3_TooltipTemplates.CreateTitleLine(text, color, wrap, leftOffset);
end

function TRP3_TooltipTemplates.CreateNormalLine(text, wrap, leftOffset)
	return TRP3_TooltipTemplates.CreateLine(text, NORMAL_FONT_COLOR, wrap, leftOffset);
end

function TRP3_TooltipTemplates.CreateHighlightLine(text, wrap, leftOffset)
	return TRP3_TooltipTemplates.CreateLine(text, HIGHLIGHT_FONT_COLOR, wrap, leftOffset);
end

function TRP3_TooltipTemplates.CreateErrorLine(text, wrap, leftOffset)
	return TRP3_TooltipTemplates.CreateLine(text, RED_FONT_COLOR, wrap, leftOffset);
end

function TRP3_TooltipTemplates.CreateDisabledLine(text, wrap, leftOffset)
	return TRP3_TooltipTemplates.CreateLine(text, DISABLED_FONT_COLOR, wrap, leftOffset);
end

function TRP3_TooltipTemplates.CreateInstructionLine(binding, instruction, shortcutType)
	local line = TRP3_Tooltip.CreateLineDescription();
	line:SetText(TRP3_API.FormatShortcutWithInstruction(binding, instruction, shortcutType));
	line:SetTextColor(GREEN_FONT_COLOR);
	line:SetUseFixedColor(true);
	line:SetWordWrap(false);
	return line;
end

function TRP3_TooltipTemplates.CreateBlankLine()
	local line = TRP3_Tooltip.CreateLineDescription();
	line:SetShouldShow(true);
	return line;
end

function TRP3_TooltipTemplates.ShowBasicTooltip(owner, title, text)
	local function GenerateBasicTooltip(_, description)
		description:AddTitleLine(title);

		if text and text ~= "" then
			description:AddNormalLine(text);
		end
	end

	TRP3_TooltipUtil.ShowTooltip(owner, GenerateBasicTooltip);
end

function TRP3_TooltipTemplates.ShowInstructionTooltip(owner, title, text, instructions)
	local function GenerateInstructionTooltip(_, description)
		description:AddTitleLine(title);
		description:AddNormalLine(text);
		description:QueueBlankLine();

		for _, instruction in ipairs(instructions) do
			description:AddInstructionLine(instruction[1], instruction[2]);
		end
	end

	TRP3_TooltipUtil.ShowTooltip(owner, GenerateInstructionTooltip);
end
