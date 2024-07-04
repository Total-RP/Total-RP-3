-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local SharedTooltipProperties = {};

function SharedTooltipProperties:__init()
end

function SharedTooltipProperties:IsColorWrappingEnabled()
	return self.colorWrappingEnabled;
end

function SharedTooltipProperties:SetColorWrappingEnabled(enabled)
	self.colorWrappingEnabled = enabled;
end

local function CreateSharedTooltipProperties()
	return TRP3_API.CreateObject(SharedTooltipProperties);
end

local TooltipElementDescription = {};

function TooltipElementDescription:__init()
end

function TooltipElementDescription:GetSharedTooltipProperties()
	return self.sharedTooltipProperties;
end

function TooltipElementDescription:SetSharedTooltipProperties(properties)
	self.sharedTooltipProperties = properties;
end

function TooltipElementDescription:GetTag()
	return self.tag;
end

function TooltipElementDescription:SetTag(tag)
	self.tag = tag;
end

function TooltipElementDescription:ShouldShow()
	if self.shouldShow ~= nil then
		return GetValueOrCallFunction(self, "shouldShow");
	else
		return true;
	end
end

function TooltipElementDescription:IsColorWrappingEnabled()
	return self:GetSharedTooltipProperties():IsColorWrappingEnabled();
end

function TooltipElementDescription:SetColorWrappingEnabled(enabled)
	return self:GetSharedTooltipProperties():SetColorWrappingEnabled(enabled);
end

function TooltipElementDescription:SetShouldShow(shouldShow)
	self.shouldShow = shouldShow;
end

local TooltipLineDescription = CreateFromMixins(TooltipElementDescription);

function TooltipLineDescription:__init()
	TooltipElementDescription.__init(self);
end

function TooltipLineDescription:GetLeftText()
	return self.leftText or "";
end

function TooltipLineDescription:GetRightText()
	return self.rightText or "";
end

function TooltipLineDescription:SetText(text)
	self.leftText = text;
	self.rightText = nil;
end

function TooltipLineDescription:SetLeftText(text)
	self.leftText = text;
end

function TooltipLineDescription:SetRightText(text)
	self.rightText = text;
end

function TooltipLineDescription:GetLeftTextColor()
	return self.leftTextColor;
end

function TooltipLineDescription:GetRightTextColor()
	return self.rightTextColor;
end

function TooltipLineDescription:SetTextColor(color)
	self.leftTextColor = color;
	self.rightTextColor = color;
end

function TooltipLineDescription:SetLeftTextColor(color)
	self.leftTextColor = color;
end

function TooltipLineDescription:SetRightTextColor(color)
	self.rightTextColor = color;
end

function TooltipLineDescription:GetLeftFontObject()
	return self.leftFontObject or GameTooltipText;
end

function TooltipLineDescription:GetRightFontObject()
	return self.rightFontObject or GameTooltipText;
end

function TooltipLineDescription:SetFontObject(fontObject)
	self.leftFontObject = fontObject;
	self.rightFontObject = fontObject;
end

function TooltipLineDescription:SetLeftFontObject(fontObject)
	self.leftFontObject = fontObject;
end

function TooltipLineDescription:SetRightFontObject(fontObject)
	self.rightFontObject = fontObject;
end

function TooltipLineDescription:GetLeftOffset()
	return self.leftOffset;
end

function TooltipLineDescription:SetLeftOffset(indent)
	self.leftOffset = indent;
end

function TooltipLineDescription:ShouldUseFixedColor()
	return not not self.useFixedColor;
end

function TooltipLineDescription:SetUseFixedColor(useFixedColor)
	self.useFixedColor = useFixedColor;
end

function TooltipLineDescription:ShouldWordWrap()
	return self.wordWrap;
end

function TooltipLineDescription:SetWordWrap(wrap)
	self.wordWrap = wrap;
end

local TooltipDescription = CreateFromMixins(TooltipElementDescription);

function TooltipDescription:__init()
	TooltipElementDescription.__init(self);
	self.sharedTooltipProperties = CreateSharedTooltipProperties();
	self.lineDescriptions = {};
	self.queuedDescriptions = {};
	self.preTooltipCallbacks = {};
	self.postTooltipCallbacks = {};
end

function TooltipDescription:AddLine(text, color, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateLine(text, color, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddDoubleLine(leftText, rightText, leftColor, rightColor, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateDoubleLine(leftText, rightText, leftColor, rightColor, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddTitleLine(text, color, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateTitleLine(text, color, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddTitleLineWithIcon(text, icon, color, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateTitleLineWithIcon(text, icon, color, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddNormalLine(text, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateNormalLine(text, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddHighlightLine(text, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateHighlightLine(text, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddErrorLine(text, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateErrorLine(text, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddDisabledLine(text, wrap, leftOffset)
	local lineDescription = TRP3_TooltipTemplates.CreateDisabledLine(text, wrap, leftOffset);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddInstructionLine(binding, instruction, shortcutType)
	local lineDescription = TRP3_TooltipTemplates.CreateInstructionLine(binding, instruction, shortcutType);
	return self:InsertLine(lineDescription);
end

function TooltipDescription:AddBlankLine()
	local lineDescription = TRP3_TooltipTemplates.CreateBlankLine();
	return self:InsertLine(lineDescription);
end

function TooltipDescription:InsertLine(lineDescription, index)
	self:FlushQueuedLines();
	lineDescription:SetSharedTooltipProperties(self:GetSharedTooltipProperties());

	if index == nil then
		table.insert(self.lineDescriptions, lineDescription);
	else
		table.insert(self.lineDescriptions, index, lineDescription);
	end

	return lineDescription;
end

function TooltipDescription:QueueBlankLine()
	local lineDescription = TRP3_TooltipTemplates.CreateBlankLine();
	return self:QueueLine(lineDescription);
end

function TooltipDescription:QueueLine(lineDescription)
	lineDescription:SetSharedTooltipProperties(self:GetSharedTooltipProperties());
	table.insert(self.queuedDescriptions, lineDescription);
	return lineDescription;
end

function TooltipDescription:ClearQueuedLines()
	self.queuedDescriptions = {};
end

function TooltipDescription:FlushQueuedLines()
	local queuedDescriptions = self.queuedDescriptions;
	self.queuedDescriptions = {};

	for _, lineDescription in ipairs(queuedDescriptions) do
		table.insert(self.lineDescriptions, lineDescription);
	end
end

function TooltipDescription:EnumerateLines()
	return ipairs(self.lineDescriptions);
end

function TooltipDescription:FindLine(tag)
	for index, lineDescription in self:EnumerateLines() do
		if lineDescription:GetTag() == tag then
			return lineDescription, index;
		end
	end

	return nil, nil;
end

function TooltipDescription:GetLineSpacing()
	return self.lineSpacing;
end

function TooltipDescription:SetLineSpacing(spacing)
	self.lineSpacing = spacing;
end

function TooltipDescription:GetMinimumWidth()
	return self.minimumWidth;
end

function TooltipDescription:SetMinimumWidth(minimumWidth)
	self.minimumWidth = minimumWidth;
end

function TooltipDescription:GetMinimumWordWrapWidth()
	return self.minimumWordWrapWidth;
end

function TooltipDescription:SetMinimumWordWrapWidth(wordWrapWidth)
	self.minimumWordWrapWidth = wordWrapWidth;
end

function TooltipDescription:GetPadding()
	return self.paddingLeft or 0, self.paddingRight or 0, self.paddingTop or 0, self.paddingBottom or 0;
end

function TooltipDescription:SetPadding(left, right, top, bottom)
	self.paddingLeft = left;
	self.paddingRight = right;
	self.paddingTop = top;
	self.paddingBottom = bottom;
end

function TooltipDescription:AddPreTooltipCallback(callback)
	table.insert(self.preTooltipCallbacks, callback);
end

function TooltipDescription:AddPostTooltipCallback(callback)
	table.insert(self.postTooltipCallbacks, callback);
end

local function ExecuteTooltipCallback(_, callback, ...)
	callback(...);
end

function TooltipDescription:ExecutePreTooltipCallbacks(tooltip)
	secureexecuterange(self.preTooltipCallbacks, ExecuteTooltipCallback, tooltip, self);
end

function TooltipDescription:ExecutePostTooltipCallbacks(tooltip)
	secureexecuterange(self.postTooltipCallbacks, ExecuteTooltipCallback, tooltip, self);
end

TRP3_Tooltip = {};

function TRP3_Tooltip.CreateLineDescription()
	return TRP3_API.CreateObject(TooltipLineDescription);
end

function TRP3_Tooltip.CreateTooltipDescription()
	return TRP3_API.CreateObject(TooltipDescription);
end

local function UnpackColor(color)
	if color then
		return color.r, color.g, color.b;
	else
		return NORMAL_FONT_COLOR:GetRGB();
	end
end

local function UnpackTooltipPadding(left, right, top, bottom)
	return right, bottom, left, top;
end

local function ProcessLineDescription(tooltip, description)
	if not description:ShouldShow() then
		return;
	end

	local leftText = description:GetLeftText();
	local rightText = description:GetRightText();

	if leftText == "" and rightText == "" then
		tooltip:AddLine(" ");
	elseif rightText == "" then
		local color = description:GetLeftTextColor();
		local r, g, b = UnpackColor(color);
		local wrap = description:ShouldWordWrap();
		local leftOffset = description:GetLeftOffset();

		if color and description:IsColorWrappingEnabled() then
			leftText = color:WrapTextInColorCode(leftText);
		end

		tooltip:AddLine(leftText, r, g, b, wrap, leftOffset);
	else
		local leftColor = description:GetLeftTextColor();
		local leftR, leftG, leftB = UnpackColor(leftColor);
		local rightColor = description:GetRightTextColor();
		local rightR, rightG, rightB = UnpackColor(rightColor);
		local wrap = description:ShouldWordWrap();
		local leftOffset = description:GetLeftOffset();

		if leftColor and description:IsColorWrappingEnabled() then
			leftText = leftColor:WrapTextInColorCode(leftText);
		end

		if rightColor and description:IsColorWrappingEnabled() then
			rightText = rightColor:WrapTextInColorCode(rightText);
		end

		tooltip:AddDoubleLine(leftText, rightText, leftR, leftG, leftB, rightR, rightG, rightB, wrap, leftOffset);
	end

	local leftFontString, rightFontString = TRP3_TooltipUtil.GetLineFontStrings(tooltip, tooltip:NumLines());
	local leftFontObject = description:GetLeftFontObject();
	local rightFontObject = description:GetRightFontObject();

	-- Font objects can't be assigned until lines are added, but doing so
	-- also means that any previously used colors are dropped if the assigned
	-- font object would change - hence the need for SetTextColor calls here.

	leftFontString:SetFontObject(leftFontObject);
	leftFontString:SetFixedColor(description:ShouldUseFixedColor());
	leftFontString:SetTextColor(UnpackColor(description:GetLeftTextColor()));
	rightFontString:SetFontObject(rightFontObject);
	rightFontString:SetFixedColor(description:ShouldUseFixedColor());
	rightFontString:SetTextColor(UnpackColor(description:GetRightTextColor()));
end

function TRP3_Tooltip.ProcessTooltipDescription(tooltip, description)
	if not description:ShouldShow() then
		return;
	end

	description:ExecutePreTooltipCallbacks(tooltip);

	for _, lineDescription in description:EnumerateLines() do
		ProcessLineDescription(tooltip, lineDescription);
	end

	tooltip:SetCustomLineSpacing(description:GetLineSpacing());
	tooltip:SetCustomWordWrapMinWidth(description:GetMinimumWordWrapWidth());
	tooltip:SetPadding(UnpackTooltipPadding(description:GetPadding()));
	description:ExecutePostTooltipCallbacks(tooltip);
end

local TooltipModifyCallbacks = TRP3_API.CreateCallbackRegistry();

function TRP3_Tooltip.PopulateTooltipDescription(generator, ownerRegion, description, ...)
	securecallfunction(generator, ownerRegion, description, ...);

	local tag = description:GetTag();

	if tag ~= nil then
		TooltipModifyCallbacks:TriggerEvent(tag, ownerRegion, description, ...);
	end
end

function TRP3_Tooltip.ModifyTooltip(tag, callback)
	return TRP3_API.RegisterCallback(TooltipModifyCallbacks, tag, callback);
end
