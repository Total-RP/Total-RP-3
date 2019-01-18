----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard HTML Content Frame
--- ------------------------------------------------------------------------------
--- Copyright 2018 Daniel "Meorawr" Yates <me@meorawr.io>
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local addonName, TRP3_API = ...;
local Ellyb = Ellyb(addonName);

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
	Popups:OpenURL(url, loc.UI_LINK_SAFE);
end

function TRP3_DashboardHTMLContentMixin:OnHyperlinkClickTwitter(url, _, button)
	-- Left click opens the Social UI, right-click gives you a profile link.
	if Social_ToggleShow and button == "LeftButton" then
		Social_ToggleShow(url:gsub("twitter", "|cff61AAEE@") .. "|r ");
	else
		url = url:gsub("twitter", "http://twitter.com/");
		Popups:OpenURL(url, "|cff55aceeTwitter profile|r\n");
	end
end

--- Called when any hyperlinks in the content are moused-over.
function TRP3_DashboardHTMLContentMixin:OnHyperlinkEnter(url, text)
	local tooltip = self.tooltip;

	tooltip:Hide();
	tooltip:SetOwner(self, "ANCHOR_CURSOR");

	if Social_ToggleShow and url:sub(1, 7) == "twitter" then
		-- Display the Twitter handle of the user and a two-line instruction
		-- with left and right click actions.
		tooltip:AddLine(url:gsub("twitter", "|cff61AAEE@"), 1, 1, 1, true);
		tooltip:AddLine(strformat(
			"|cffffff00%s:|r %s|n|cffffff00%s:|r %s",
			loc.CM_CLICK, loc.CM_TWEET,
			loc.CM_R_CLICK, loc.CM_TWEET_PROFILE
		), 1, 1, 1, true);
	else
		-- Display the text of the hyperlink and a single left-click
		-- line that clicking this means opening a popup.
		tooltip:AddLine(text, 1, 1, 1, true);
		tooltip:AddLine(strformat(
			"|cffffff00%s:|r %s",
			loc.CM_CLICK, loc.CM_OPEN
		), 1, 1, 1, true);
	end
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
