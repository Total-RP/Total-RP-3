-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

TRP3_HyperLinkedMixin = {};

function TRP3_HyperLinkedMixin:OnHyperlinkClick(url)
	TRP3_API.Ellyb.Popups:OpenURL(url, TRP3_API.loc.UI_LINK_WARNING, nil, TRP3_API.loc.COPY_SYSTEM_MESSAGE);
end

function TRP3_HyperLinkedMixin:OnHyperlinkEnter(link, text)
	TRP3_MainTooltip:Hide();
	TRP3_MainTooltip:SetOwner(self, "ANCHOR_CURSOR");
	TRP3_MainTooltip:AddLine(text, 1, 1, 1, true);
	TRP3_MainTooltip:AddLine(link, 1, 1, 1, true);
	TRP3_MainTooltip:Show();
end

function TRP3_HyperLinkedMixin:OnHyperlinkLeave()
	TRP3_MainTooltip:Hide();
end
