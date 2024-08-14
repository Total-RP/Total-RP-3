-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_HTMLScrollFrameMixin = {};

function TRP3_HTMLScrollFrameMixin:OnLoad()
	self.ScrollView = CreateScrollBoxLinearView(0, 0, 0, 0, 0);
	self.ScrollBox:SetAlignmentOverlapIgnored(true);
	self.ScrollBox:SetInterpolateScroll(self.canInterpolateScroll);
	self.ScrollBar:SetInterpolateScroll(self.canInterpolateScroll);
	self.ScrollBox.ScrollTarget:RegisterCallback("OnSizeChanged", self.OnScrollTargetSizeChanged, self);

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 0, 0),
		AnchorUtil.CreateAnchor("BOTTOM", self, "BOTTOM", 0, 0),
		AnchorUtil.CreateAnchor("RIGHT", self.ScrollBar, "LEFT", -8, 0),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0),
	};

	ScrollUtil.InitScrollBoxWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);

	local child = CreateFrame("SimpleHTML", nil, self, self.scrollChildTemplate);
	self:SetScrollChild(child);
	self:SetPadding(self.initialPaddingTop, self.initialPaddingBottom, self.initialPaddingLeft, self.initialPaddingRight);
end

function TRP3_HTMLScrollFrameMixin:OnShow()
	self:Layout();
end

function TRP3_HTMLScrollFrameMixin:OnUpdate()
	self:Layout();
end

function TRP3_HTMLScrollFrameMixin:OnScrollTargetSizeChanged()
	self:Layout();
end

function TRP3_HTMLScrollFrameMixin:OnScrollChildSizeChanged()
	self.ScrollBox:FullUpdate();
end

function TRP3_HTMLScrollFrameMixin:GetFontObject(textType)
	return self.ScrollChild:GetFontObject(textType);
end

function TRP3_HTMLScrollFrameMixin:SetFontObject(textType, fontObject)
	self.ScrollChild:SetFontObject(textType, fontObject);
	self:UpdatePanExtent();
end

function TRP3_HTMLScrollFrameMixin:ClearText()
	self.ScrollChild:ClearText();
end

local function ResetScrollPosition(self, retainScrollPosition)
	if retainScrollPosition then
		return;
	end

	local noInterpolation = ScrollBoxConstants.NoScrollInterpolation;
	self.ScrollBox:ScrollToBegin(noInterpolation);
end

function TRP3_HTMLScrollFrameMixin:SetHTML(html, retainScrollPosition)
	self.ScrollChild:SetHTML(html);
	ResetScrollPosition(self, retainScrollPosition);
end

function TRP3_HTMLScrollFrameMixin:SetPlainText(text, retainScrollPosition)
	self.ScrollChild:SetPlainText(text);
	ResetScrollPosition(self, retainScrollPosition);
end

function TRP3_HTMLScrollFrameMixin:SetRichText(text, options, retainScrollPosition)
	self.ScrollChild:SetRichText(text, options);
	ResetScrollPosition(self, retainScrollPosition);
end

function TRP3_HTMLScrollFrameMixin:SetText(text, ignoreMarkup, retainScrollPosition)
	self.ScrollChild:SetText(text, ignoreMarkup);
	ResetScrollPosition(self, retainScrollPosition);
end

function TRP3_HTMLScrollFrameMixin:GetJustifyH(textType)
	return self.ScrollChild:GetJustifyH(textType);
end

function TRP3_HTMLScrollFrameMixin:SetJustifyH(textType, justifyH)
	self.ScrollChild:SetJustifyH(textType, justifyH);
end

function TRP3_HTMLScrollFrameMixin:GetJustifyV(textType)
	return self.ScrollChild:GetJustifyV(textType);
end

function TRP3_HTMLScrollFrameMixin:SetJustifyV(textType, justifyV)
	self.ScrollChild:SetJustifyV(textType, justifyV);
end

function TRP3_HTMLScrollFrameMixin:GetHyperlinkFormat()
	return self.ScrollChild:GetHyperlinkFormat();
end

function TRP3_HTMLScrollFrameMixin:SetHyperlinkFormat(format)
	self.ScrollChild:SetHyperlinkFormat(format);
end

function TRP3_HTMLScrollFrameMixin:GetTextColor(textType)
	local r, g, b = self.ScrollChild:GetTextColor(textType);
	return TRP3_API.CreateColor(r, g, b);
end

function TRP3_HTMLScrollFrameMixin:SetTextColor(textType, color)
	self.ScrollChild:SetTextColor(textType, color:GetRGB());
end

function TRP3_HTMLScrollFrameMixin:GetSpacing(textType)
	return self.ScrollChild:GetSpacing(textType);
end

function TRP3_HTMLScrollFrameMixin:SetSpacing(textType, spacing)
	self.ScrollChild:SetSpacing(textType, spacing);
end

function TRP3_HTMLScrollFrameMixin:CreateLinkHandler(linkType, clickCallback, tooltipCallback)
	return self.ScrollChild:CreateLinkHandler(linkType, clickCallback, tooltipCallback);
end

function TRP3_HTMLScrollFrameMixin:RegisterLinkHandler(linkType, handler)
	return self.ScrollChild:RegisterLinkHandler(linkType, handler);
end

function TRP3_HTMLScrollFrameMixin:UnregisterLinkHandler(linkType)
	self.ScrollChild:UnregisterLinkHandler(linkType);
end

function TRP3_HTMLScrollFrameMixin:UnregisterAllLinkHandlers()
	self.ScrollChild:UnregisterAllLinkHandlers();
end

function TRP3_HTMLScrollFrameMixin:GetScrollBar()
	return self.ScrollBar;
end

function TRP3_HTMLScrollFrameMixin:GetScrollBox()
	return self.ScrollBox;
end

function TRP3_HTMLScrollFrameMixin:GetScrollView()
	return self.ScrollView;
end

function TRP3_HTMLScrollFrameMixin:GetScrollChild()
	return self.ScrollChild;
end

function TRP3_HTMLScrollFrameMixin:SetScrollChild(child)
	assert(not self.ScrollChild, "attempted to replace an assigned scroll child");

	child.scrollable = true;
	self.ScrollChild = child;
	self.ScrollView:ReparentScrollChildren(child);

	-- The scroll child is expected to update its vertical extent whenever
	-- the content changes, or when an explicit layout call occurs. When this
	-- happens we need to bubble the size change up to our scrollbox and tell
	-- it to update the scrollable extent.

	child:RegisterCallback("OnSizeChanged", self.OnScrollChildSizeChanged, self);

	-- The pan extent is based on the assigned fonts of the scroll child, so
	-- should be updated when initialized.

	self:UpdatePanExtent();
	self:Layout();
end

function TRP3_HTMLScrollFrameMixin:HasScrollableExtent()
	return self.ScrollBox:HasScrollableExtent();
end

function TRP3_HTMLScrollFrameMixin:IsScrollAllowed()
	return self.ScrollBox:IsScrollAllowed();
end

function TRP3_HTMLScrollFrameMixin:SetScrollAllowed(allowed)
	self.ScrollBox:SetScrollAllowed(allowed);
end

function TRP3_HTMLScrollFrameMixin:SetInterpolateScroll(canInterpolateScroll)
	self.ScrollBox:SetInterpolateScroll(canInterpolateScroll);
	self.ScrollBar:SetInterpolateScroll(canInterpolateScroll);
end

function TRP3_HTMLScrollFrameMixin:GetPadding()
	return self.ScrollView:GetPadding();
end

function TRP3_HTMLScrollFrameMixin:SetPadding(top, bottom, left, right)
	self.ScrollView:SetPadding(top, bottom, left, right);
end

function TRP3_HTMLScrollFrameMixin:GetPanExtentMultiplier()
	return self.panExtentMultiplier or 1;
end

function TRP3_HTMLScrollFrameMixin:SetPanExtentMultiplier(multiplier)
	self.panExtentMultiplier = multiplier;
	self:UpdatePanExtent();
end

function TRP3_HTMLScrollFrameMixin:ScrollToBegin(noInterpolation)
	self.ScrollBox:ScrollToBegin(noInterpolation);
end

function TRP3_HTMLScrollFrameMixin:ScrollToEnd(noInterpolation)
	self.ScrollBox:ScrollToEnd(noInterpolation);
end

function TRP3_HTMLScrollFrameMixin:ScrollToOffset(offset, noInterpolation)
	self.ScrollBox:ScrollToOffset(offset, noInterpolation);
end

function TRP3_HTMLScrollFrameMixin:UpdatePanExtent()
	local fontHeight = select(2, self.ScrollChild:GetFont("P"));

	if not fontHeight then
		return;
	end

	local panExtent = fontHeight * self:GetPanExtentMultiplier();
	self.ScrollView:SetPanExtent(panExtent);
end

function TRP3_HTMLScrollFrameMixin:MarkDirty()
	self:SetScript("OnUpdate", self.OnUpdate);
end

function TRP3_HTMLScrollFrameMixin:MarkClean()
	self:SetScript("OnUpdate", nil);
end

function TRP3_HTMLScrollFrameMixin:Layout()
	if not self:IsShown() then
		return;
	end

	self:MarkClean();

	-- Use the width of the ScrollTarget as this accounts for padding along
	-- the left and right edges. Updating the layout of the child should
	-- reflow its content, update the height of the region, and in turn
	-- trigger a scrollbox update automatically.

	self.ScrollChild:SetWidth(self.ScrollBox:GetScrollTarget():GetWidth());
	self.ScrollChild:Layout();
end
