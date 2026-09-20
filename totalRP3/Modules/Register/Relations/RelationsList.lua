-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

local function GenerateEditDescription(description)
	return description:gsub("%%1%$s", "%%p"):gsub("%%2%$s", "%%t");
end

local function GetRelationName(relation)
	return relation.name or L:GetText("REG_RELATION_" .. relation.id);
end

local function GetRelationDescription(relation)
	return relation.description or L:GetText("REG_RELATION_" .. relation.id .. "_TT");
end

local function CanReorderRelation(relation)
	return relation.id ~= "NONE";
end

TRP3_RelationsListActionButtonMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_RelationsListActionButtonMixin:OnMouseDown()
	if self.actionCallback then
		self.actionCallback(self);
	end
end

function TRP3_RelationsListActionButtonMixin:OnTooltipShow(description)
	local title = L.CM_OPTIONS;
	local text = nil;
	local instructions = { { "CLICK", L.CM_OPTIONS_ADDITIONAL } };

	TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);
end

function TRP3_RelationsListActionButtonMixin:SetActionCallback(callback)
	self.actionCallback = callback;
end

TRP3_RelationsListElementMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_RelationsListElementMixin:OnLoad()
	self.Border:SetVertexColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN:GetRGB());
end

function TRP3_RelationsListElementMixin:OnTooltipShow(description)
	if CanReorderRelation(self.relation) then
		local title = GetRelationName(self.relation);
		local text = nil;
		local instructions = { { "DRAGDROP", L.REG_RELATION_REORDER } };

		TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);
	end
end

function TRP3_RelationsListElementMixin:Init(relation, actionCallback)
	self.relation = relation;
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

TRP3_RelationsListDragIndicatorMixin = {};

function TRP3_RelationsListDragIndicatorMixin:OnLoad()
	if C_Texture.GetAtlasExists("glues-characterSelect-divider") then
		self.Texture:SetAtlas("glues-characterSelect-divider");
	else
		self.Texture:SetAtlas("LevelUp-Bar-Green");
		self:SetHeight(30);
	end
end

TRP3_RelationsListMixin = {};

function TRP3_RelationsListMixin:OnLoad()
	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOP", self.Divider, "BOTTOM", 0, -3),
		AnchorUtil.CreateAnchor("LEFT", self, "LEFT", 6, 0),
		AnchorUtil.CreateAnchor("RIGHT", self.ScrollBar, "LEFT", -6, 0),
		AnchorUtil.CreateAnchor("BOTTOM", self, "BOTTOM", 0, 3),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		scrollBoxAnchorsWithBar[2],
		AnchorUtil.CreateAnchor("RIGHT", self, "RIGHT", -6, 0),
		scrollBoxAnchorsWithBar[4],
	};

	self.ScrollView = CreateScrollBoxListLinearView();
	self.ScrollView:SetElementInitializer("TRP3_RelationsListElementTemplate", function(frame, relation) self:OnListElementInitialize(frame, relation); end);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);

	self.DragBehavior = ScrollUtil.InitDefaultLinearDragBehavior(self.ScrollBox);
	self.DragBehavior:SetReorderable(true);
	self.DragBehavior:SetDragRelativeToCursor(true);
	self.DragBehavior:SetAreaIntersectMargin(self.dragAreaIntersectMargin);
	self.DragBehavior:SetDragPredicate(function(_, relation) return self:CanReorderListElement(relation); end);
	self.DragBehavior:SetDropPredicate(function(_, contextData) return self:CanDropOnListElement(contextData); end);
	self.DragBehavior:SetDropEnter(function(factory, candidate) self:OnListDropEnter(factory, candidate); end);
	self.DragBehavior:SetFinalizeDrop(function() self:OnListFinalizeDrop(); end);
end

function TRP3_RelationsListMixin:OnListElementInitialize(frame, relation)
	frame:Init(relation, self.actionCallback);
end

function TRP3_RelationsListMixin:OnListDropEnter(factory, candidate)
	local candidateFrame = candidate.frame;
	local indicatorFrame = factory("TRP3_RelationsListDragIndicatorTemplate");

	if candidate.area == DragIntersectionArea.Above then
		indicatorFrame:SetPoint("BOTTOMLEFT", candidateFrame, "TOPLEFT", 0, -4);
		indicatorFrame:SetPoint("BOTTOMRIGHT", candidateFrame, "TOPRIGHT", 0, -4);
	elseif candidate.area == DragIntersectionArea.Below then
		indicatorFrame:SetPoint("TOPLEFT", candidateFrame, "BOTTOMLEFT", 0, -12);
		indicatorFrame:SetPoint("TOPRIGHT", candidateFrame, "BOTTOMRIGHT", 0, -12);
	end
end

function TRP3_RelationsListMixin:OnListFinalizeDrop()
	local order = 0;

	local function UpdateRelationOrder(relation)
		if self:CanReorderListElement(relation) then
			order = order + 1;
			relation.order = order;
		else
			relation.order = 0;
		end
	end

	self.ScrollBox:ForEachElementData(UpdateRelationOrder);
end

function TRP3_RelationsListMixin:CanReorderListElement(relation)
	return CanReorderRelation(relation);
end

function TRP3_RelationsListMixin:CanDropOnListElement(contextData)
	return contextData.area ~= DragIntersectionArea.Inside and CanReorderRelation(contextData.elementData);
end

function TRP3_RelationsListMixin:SetActionCallback(callback)
	self.actionCallback = callback;
end

function TRP3_RelationsListMixin:SetDataProvider(dataProvider, retainScrollPosition)
	self.ScrollBox:SetDataProvider(dataProvider, retainScrollPosition ~= false);
end
