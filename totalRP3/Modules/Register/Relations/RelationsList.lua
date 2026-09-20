-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local function GenerateEditDescription(description)
	return description:gsub("%%1%$s", "%%p"):gsub("%%2%$s", "%%t");
end

local function GetRelationName(relation)
	return relation.name or TRP3_API.loc:GetText("REG_RELATION_" .. relation.id);
end

local function GetRelationDescription(relation)
	return relation.description or TRP3_API.loc:GetText("REG_RELATION_" .. relation.id .. "_TT");
end

TRP3_RelationsListActionButtonMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_RelationsListActionButtonMixin:OnMouseDown()
	if self.actionCallback then
		self.actionCallback(self);
	end
end

function TRP3_RelationsListActionButtonMixin:OnTooltipShow(description)
	local title = TRP3_API.loc.CM_OPTIONS;
	local text = nil;
	local instructions = { { "CLICK", TRP3_API.loc.CM_OPTIONS_ADDITIONAL } };

	TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);
end

function TRP3_RelationsListActionButtonMixin:SetActionCallback(callback)
	self.actionCallback = callback;
end

TRP3_RelationsListElementMixin = {};

function TRP3_RelationsListElementMixin:OnLoad()
	self.Border:SetVertexColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN:GetRGB());
end

function TRP3_RelationsListElementMixin:Init(relation, actionCallback)
	local name = GetRelationName(relation);

	if relation.color then
		name = TRP3_API.CreateColorFromHexString(relation.color):WrapTextInColorCode(name);
	end

	self.Title:SetText(name);
	self.Text:SetText(GenerateEditDescription(GetRelationDescription(relation)));
	self.Icon:SetIconTexture(relation.texture);

	self.Actions:SetShown(relation.id ~= "NONE");
	self.Actions:SetActionCallback(function(button) return actionCallback(button, relation); end);
end

TRP3_RelationsListMixin = {};

function TRP3_RelationsListMixin:OnLoad()
	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self.Divider, "BOTTOMLEFT", 0, -1),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.ScrollBar, "BOTTOMLEFT", -10, 4),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -16, 4),
	};

	local function OnListElementInitialize(frame, relation)
		frame:Init(relation, self.actionCallback);
	end

	self.ScrollView = CreateScrollBoxListLinearView();
	self.ScrollView:SetElementInitializer("TRP3_RelationsListElementTemplate", OnListElementInitialize);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
end

function TRP3_RelationsListMixin:SetActionCallback(callback)
	self.actionCallback = callback;
end

function TRP3_RelationsListMixin:SetDataProvider(dataProvider, retainScrollPosition)
	self.ScrollBox:SetDataProvider(dataProvider, retainScrollPosition ~= false);
end
