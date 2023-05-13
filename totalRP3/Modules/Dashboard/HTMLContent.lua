-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local TRP3_API = select(2, ...);
local Ellyb = TRP3_API.Ellyb;

-- Lua imports
local strformat = string.format;

-- Ellyb imports
local Popups = Ellyb.Popups;

-- WoW imports
local hooksecurefunc = hooksecurefunc;
local twipe = table.wipe;

-- Total RP 3 imports
local loc = TRP3_API.loc;

--- Mixin for the SimpleHTML content frame that provides a GetText() method,
---  as well as script handlers for hyperlinks.
TRP3_DashboardHTMLContentMixin = {};

function TRP3_DashboardHTMLContentMixin:OnLoad()
	-- Reuse the main tooltip for our hyperlink goodness.
	self.tooltip = TRP3_MainTooltip;

	-- Mapping of URL identifiers to a single handler function.
	self.urlHandlers = {};

	-- Replace the SetText method with a hooked equivalent.
	hooksecurefunc(self, "SetText", self.OnTextChanged);
end

--- Returns the content of the text currently displayed by this frame.
function TRP3_DashboardHTMLContentMixin:GetText()
	return self.text;
end

--- Called when a hyperlink in the frame is clicked.
function TRP3_DashboardHTMLContentMixin:OnHyperlinkClick(url, text, button)
	-- If there's a custom URL handler installed that matches this, dispatch.
	local handler = self.urlHandlers[url];
	if handler then
		return handler(url, text, button);
	end

	-- Otherwise try some builtins.
	if url:sub(1, 7) == "twitter" then
		-- Twitter link.
		return self:OnHyperlinkClickTwitter(url, text, button);
	end

	-- Fallback: Allow the user to just copy the URL.
	Popups:OpenURL(url, loc.UI_LINK_SAFE, nil, loc.COPY_SYSTEM_MESSAGE);
end

function TRP3_DashboardHTMLContentMixin:OnHyperlinkClickTwitter(url)
	url = url:gsub("twitter", "http://twitter.com/");
	Popups:OpenURL(url, "|cff55aceeTwitter profile|r\n", nil, loc.COPY_SYSTEM_MESSAGE);
end

--- Called when any hyperlinks in the content are moused-over.
function TRP3_DashboardHTMLContentMixin:OnHyperlinkEnter(_, text)
	local tooltip = self.tooltip;

	tooltip:Hide();
	tooltip:SetOwner(self, "ANCHOR_CURSOR");
	tooltip:AddLine(text, 1, 1, 1, true);
	tooltip:AddLine(strformat(
		"|cffffff00%s:|r %s",
		loc.CM_CLICK, loc.CM_OPEN
	), 1, 1, 1, true);
	tooltip:Show();
end

--- Called when any hyperlinks in the content are no longer moused-over.
function TRP3_DashboardHTMLContentMixin:OnHyperlinkLeave()
	self.tooltip:Hide();
end

--- Called when the text on the widget has changed. Stores the text for
---  retrieval via GetText().
function TRP3_DashboardHTMLContentMixin:OnTextChanged(text)
	self.text = text;
end

--- Registers a handler for the given URL. When clicked, this handler will
---  be called. Only a single handler may be present for any URL at a given time.
function TRP3_DashboardHTMLContentMixin:RegisterHyperlink(url, handler)
	self.urlHandlers[url] = handler;
end

--- Unregisters any active handler for the given URL.
function TRP3_DashboardHTMLContentMixin:UnregisterHyperlink(url)
	self.urlHandlers[url] = nil;
end

--- Unregisters all registered URL handler functions.
function TRP3_DashboardHTMLContentMixin:UnregisterAllHyperlinks()
	twipe(self.urlHandlers);
end
