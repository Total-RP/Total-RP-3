-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ToolbarUtil = {};

function TRP3_ToolbarUtil.GetFormattedTooltipTitle(elementData)
	local icon = TRP3_MarkupUtil.GenerateIconMarkup(elementData.icon, { size = 32 });
	local text = elementData.tooltip or elementData.configText;
	return string.trim(string.join(" ", icon, text));
end

function TRP3_ToolbarUtil.GetToolbarAnchor()
	local point = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.AnchorPoint);
	local relativeTo = UIParent;
	local relativePoint = point;
	local offsetX = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.AnchorOffsetX);
	local offsetY = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.AnchorOffsetY);

	return AnchorUtil.CreateAnchor(point, relativeTo, relativePoint, offsetX, offsetY);
end

function TRP3_ToolbarUtil.GetToolbarButtonExtent()
	local configuredExtent = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.ButtonExtent);
	local extraExtent = TRP3_ToolbarConstants.ButtonExtraExtent;

	return configuredExtent + extraExtent;
end
