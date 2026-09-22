-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

local PREVIEW_TARGET_NAMES = {
	Alliance = {
		"Mira Briarwick",
		"Perrin Candleford",
		"Thalan Duskbranch",
		"Rhoswen Saltmere",
		"Tibby Cogwhistle",
		"Nella Brassbutton",
		"Borin Flintmantle",
		"Brynja Runebeard",
		"Shu-Lin Mistvale",
		"Bao Ren Cloudstep",
	},
	Horde = {
		"Korga Bloodaxe",
		"Veyra Coldmarrow",
		"Aroha Boulderhide",
		"Jazulo Darktide",
		"Vaeron Brightsong",
		"M'jara Bloodscale",
		"Kezza Blastfuse",
		"Rixx Geargrin",
		"Mei-Lan Reedwhisker",
		"Tao-Shi Embertea",
		"Rava Dustrunner",
	},
};

local GetNextTargetNameIndex = CreateCounter(fastrandom(10));

local function GeneratePreviewTargetName()
	local names = PREVIEW_TARGET_NAMES[TRP3_API.globals.player_character.faction] or PREVIEW_TARGET_NAMES.Alliance;
	return names[Wrap(GetNextTargetNameIndex(), #names)];
end

local function GeneratePreviewPlayerName()
	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	return player:GetRoleplayingName();
end

local function GeneratePreviewDescription(description, playerName, targetName)
	local replacements = {
		["%1$s"] = playerName,
		["%2$s"] = targetName,
	};

	return (string.gsub(description, "%%[12]%$s", replacements));
end

local function GetRelationName(relation)
	return relation.name or L:GetText("REG_RELATION_" .. relation.id);
end

local function GetColoredRelationName(relation)
	local name = GetRelationName(relation);

	if relation.color then
		name = TRP3_API.CreateColorFromHexString(relation.color):WrapTextInColorCode(name);
	end

	return name;
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

function TRP3_RelationsListElementMixin:OnClick(mouseButtonName)
	if mouseButtonName == "RightButton" then
		self:InvokeMenuCallback();
	end
end

function TRP3_RelationsListElementMixin:OnDoubleClick()
	self:InvokeEditCallback();
end

function TRP3_RelationsListElementMixin:OnTooltipShow(description)
	-- Intentionally keeping tooltip titles the regular color for consistency.
	local title = GetRelationName(self.relation);
	local text = self.Text:IsTruncated() and self.previewDescription or nil;
	local instructions = {
		{ "DCLICK", L.CO_RELATIONS_MENU_EDIT },
		{ "RCLICK", L.CM_OPTIONS_ADDITIONAL },
	};

	if CanReorderRelation(self.relation) then
		table.insert(instructions, { "DRAGDROP", L.REG_RELATION_REORDER });
	end

	TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);
end

function TRP3_RelationsListElementMixin:Init(relation, options)
	local name = GetColoredRelationName(relation);

	self.relation = relation;
	self.editCallback = options.editCallback;
	self.menuCallback = options.menuCallback;
	self.previewDescription = GeneratePreviewDescription(GetRelationDescription(relation), GeneratePreviewPlayerName(), options.targetName);

	self.Title:SetText(name);
	self.Text:SetText(self.previewDescription);
	self.Icon:SetIconTexture(relation.texture);

	self.Actions:SetShown(relation.id ~= "NONE");
	self.Actions:SetActionCallback(function(button) self:InvokeMenuCallback(button); end);
end

function TRP3_RelationsListElementMixin:InvokeEditCallback()
	if self.editCallback then
		self.editCallback(self, self.relation);
	end
end

function TRP3_RelationsListElementMixin:InvokeMenuCallback(owner)
	if self.menuCallback then
		self.menuCallback(owner or self, self.relation);
	end
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

TRP3_RelationsListCreateButtonMixin = {};

function TRP3_RelationsListCreateButtonMixin:OnClick()
	TRP3_API.register.relation.showEditor();
end

TRP3_RelationsListMixin = {};

function TRP3_RelationsListMixin:OnLoad()
	self.dynamicEvents = TRP3_API.CreateCallbackGroup();
	self.dynamicEvents:AddCallback(TRP3_Addon, "REGISTER_DATA_UPDATED", self.OnRegisterDataUpdated, self);
	self.previewTargetNames = {};

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

function TRP3_RelationsListMixin:OnShow()
	self.dynamicEvents:Register();
	self.ScrollBox:Rebuild();
end

function TRP3_RelationsListMixin:OnHide()
	self.dynamicEvents:Unregister();
end

function TRP3_RelationsListMixin:OnRegisterDataUpdated(characterID, _profileID, dataType)
	if characterID == TRP3_API.globals.player_id and (dataType == nil or dataType == "characteristics") then
		self.ScrollBox:Rebuild();
	end
end

function TRP3_RelationsListMixin:OnListElementInitialize(frame, relation)
	frame:Init(relation, {
		targetName = self:GetTargetNameForRelation(relation),
		menuCallback = self.menuCallback,
		editCallback = self.editCallback,
	});
end

function TRP3_RelationsListMixin:OnListDropEnter(factory, candidate)
	local candidateFrame = candidate.frame;
	local indicatorFrame = factory("TRP3_RelationsListDragIndicatorTemplate");

	-- The last candidate in the list always anchors its indicator above, as
	-- putting it below would clip it out of the scroll view. We don't need
	-- to accomodate the first frame in the list as we don't allow reordering
	-- the None entry at the top.
	if candidate.area == DragIntersectionArea.Above or not candidate.nextFrame then
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

function TRP3_RelationsListMixin:GetTargetNameForRelation(relation)
	local targetName = self.previewTargetNames[relation.id];

	if not targetName then
		targetName = GeneratePreviewTargetName();
		self.previewTargetNames[relation.id] = targetName;
	end

	return targetName;
end

function TRP3_RelationsListMixin:SetEditCallback(callback)
	self.editCallback = callback;
end

function TRP3_RelationsListMixin:SetMenuCallback(callback)
	self.menuCallback = callback;
end

function TRP3_RelationsListMixin:SetDataProviderFactory(factory)
	self.dataProviderFactory = factory;
end

function TRP3_RelationsListMixin:SetDataProvider(dataProvider, retainScrollPosition)
	self.ScrollBox:SetDataProvider(dataProvider, retainScrollPosition ~= false);
end

function TRP3_RelationsListMixin:GetTutorialStructure()
	return {
		{
			box = {
				allPoints = self.CreateNew,
			},
			button = {
				x = 0, y = -10, anchor = "TOP",
				text = L.CO_RELATIONS_TUTORIAL_CREATE,
				textWidth = 320,
				arrow = "DOWN",
			},
		},
		{
			box = {
				allPoints = self.ScrollBox,
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = L.CO_RELATIONS_TUTORIAL_LIST,
				textWidth = 420,
				arrow = "UP",
			},
		},
	};
end
