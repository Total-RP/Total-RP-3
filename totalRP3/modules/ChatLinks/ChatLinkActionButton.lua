----------------------------------------------------------------------------------
--- Total RP 3
---
--- Chat Link Action Button
---
--- This an Ellyb class that defines action buttons to be displayed in chat links tooltips
--- ---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---   http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

-- Lua imports
local assert = assert;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

---@class ChatLinkActionButton : Object
local ChatLinkActionButton, _private = Ellyb.Class("ChatLinkActionButton");

---@param actionID string @ The ID of the action
---@param buttonText string @ The text to be displayed on the button
function ChatLinkActionButton:initialize(actionID, buttonText)
	assert(isType(actionID, "string", actionID));
	assert(isType(buttonText, "string", buttonText));

	_private[self] = {}
	_private[self].actionID = actionID;
	_private[self].buttonText = buttonText;
end

---@return string actionID @ The ID of the action
function ChatLinkActionButton:GetID()
	return _private[self].actionID;
end

---@return string buttonText @ The text to be shown on the button
function ChatLinkActionButton:GetText()
	return _private[self].buttonText;
end

--- OVERRIDE
--- [SENDER] Check if the button should be visible for the given data
---@return boolean isVisible @ Returns true if the action should be visible
function ChatLinkActionButton:IsVisible(...)
	return true
end

--- OVERRIDE
--- [RECIPIENT] Function called when the recipient clicked the button
---@param linkData table @ The link data as saved by the module
---@param sender string @ The name of the sender of the link
function ChatLinkActionButton:OnClick(linkData, sender) end

---@class TRP3_ChatLinkActionButtonMixin : Button
TRP3_ChatLinkActionButtonMixin = {};

function TRP3_ChatLinkActionButtonMixin:OnLoad()
	hooksecurefunc(self, "SetText", self.OnSetText);
end

function TRP3_ChatLinkActionButtonMixin:OnSetText()
	self:SetWidth(self:GetTextWidth() + 40)
end

function TRP3_ChatLinkActionButtonMixin:OnClick()
	local module = TRP3_API.ChatLinks:GetModuleByID(TRP3_RefTooltip.itemData.moduleID);
	module:OnActionButtonClicked(self.command, TRP3_RefTooltip.itemData.customData, TRP3_RefTooltip.sender);
end

function TRP3_ChatLinkActionButtonMixin:Set(button)
	assert(isType(button, "table", button));
	assert(isType(button.text, "string", button.text));
	assert(isType(button.command, "string", button.command));

	-- TODO find a more elegant solution than adding blank lines to make room for the button
	TRP3_RefTooltip:AddLine(" ");
	TRP3_RefTooltip:AddLine(" ");

	self:SetText(button.text);
	self.command = button.command;
	self:Show();
end

function TRP3_ChatLinkActionButtonMixin:Reset()
	self:SetText("");
	self.command = nil;
	self:Hide();
end

TRP3_API.ChatLinkActionButton = ChatLinkActionButton;