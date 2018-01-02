TRP3_HyperLinkedMixin = {};

function TRP3_HyperLinkedMixin:OnHyperlinkClick(url)
	TRP3_API.popup.showTextInputPopup(TRP3_API.locale.getText("UI_LINK_WARNING"), nil, nil, url);
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