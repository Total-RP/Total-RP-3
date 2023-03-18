-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

TRP3_Support = TRP3_Addon:NewModule("Support");

function TRP3_Support:OnInitalize()
end

function TRP3_Support:OnEnable()
	local MENU_ID = "main_99_support";

	TRP3_API.navigation.menu.registerMenu({
		id = MENU_ID,
		text = L.SUPPORT_MENU_TITLE,
		onSelected = GenerateClosure(TRP3_API.navigation.page.setPage, MENU_ID),
	});

	TRP3_API.navigation.page.registerPage({
		id = MENU_ID,
		frameName = "TRP3_SupportPageFrame",
		templateName = "TRP3_SupportPageTemplate",
	});
end

TRP3_SupportPageMixin = {};

function TRP3_SupportPageMixin:OnLoad()
	local wrapMode = "REPEAT";
	self.NineSlice.Center:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]], wrapMode, wrapMode);

	local fontHeight = select(2, GameFontNormal:GetFont());
	local view = CreateScrollBoxLinearView();
	view:SetPanExtent(fontHeight);
	self.ScrollBox:SetView(view);
	ScrollUtil.InitScrollBoxWithScrollBar(self.ScrollBox, self.ScrollBar);
	self.ScrollBox.Content:Layout();
end
