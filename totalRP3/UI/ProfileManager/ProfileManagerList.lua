-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_ProfileManagerListMixin = {};

function TRP3_ProfileManagerListMixin:OnLoad()
	BackdropTemplateMixin.OnBackdropLoaded(self);

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOP", self.Divider, "BOTTOM", 0, -3),
		AnchorUtil.CreateAnchor("LEFT", self, "LEFT", 6, 0),
		AnchorUtil.CreateAnchor("RIGHT", self.ScrollBar, "LEFT", -6, 0),
		AnchorUtil.CreateAnchor("BOTTOM", self, "BOTTOM", 0, 6),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		scrollBoxAnchorsWithBar[2],
		AnchorUtil.CreateAnchor("RIGHT", self, "RIGHT", -6, 0),
		scrollBoxAnchorsWithBar[4],
	};

	self.ScrollView = CreateScrollBoxListLinearView();
	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
end

function TRP3_ProfileManagerListMixin:OnShow()
	self.CreateButton:SetText(L.PR_CREATE_PROFILE);
	self.ScrollBox.EmptyText:SetText(L.PR_PROFILEMANAGER_EMPTY);
end

function TRP3_ProfileManagerListMixin:GetSearchText()
	return self.SearchBox:GetText();
end

function TRP3_ProfileManagerListMixin:SetSearchText(text)
	self.SearchBox:SetText(text);
end

function TRP3_ProfileManagerListMixin:ClearSearchText()
	self.SearchBox:SetText("");
end

function TRP3_ProfileManagerListMixin:SetCreateCallback(callback)
	local function OnClick(button, mouseButtonName)
		callback(self, button, mouseButtonName);
	end

	self.CreateButton:SetShown(callback ~= nil);
	self.CreateButton:SetScript("OnClick", OnClick);
end

function TRP3_ProfileManagerListMixin:SetHelpCallback(callback)
	local function OnEnter(buttonFrame)
		TRP3_TooltipUtil.ShowTooltip(buttonFrame, callback);
	end

	self.HelpButton:SetShown(callback ~= nil);
	self.HelpButton:SetScript("OnLeave", TRP3_TooltipUtil.HideTooltip);
	self.HelpButton:SetScript("OnEnter", OnEnter);

	if callback then
		self.SearchBox:SetPoint("RIGHT", self.HelpButton, "LEFT", -10, 0);
	else
		self.SearchBox:SetPoint("RIGHT", -15, 0);
	end
end

function TRP3_ProfileManagerListMixin:SetSearchCallback(callback)
	local function OnTextChanged(editbox)
		SearchBoxTemplate_OnTextChanged(editbox);
		local text = editbox:GetText();
		callback(self, editbox, text);
	end

	self.SearchBox:SetShown(callback ~= nil);
	self.SearchBox:SetScript("OnTextChanged", OnTextChanged);
end

function TRP3_ProfileManagerListMixin:SetElementInitializer(template, initializer)
	self.ScrollView:SetElementInitializer(template, initializer);
end
