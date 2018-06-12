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

-- Total RP 3 imports
local loc = TRP3_API.loc;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

---@class ChatLinkActionButton : Object
local ChatLinkActionButton, _private = Ellyb.Class("ChatLinkActionButton");

---@param actionID string @ The ID of the action
---@param buttonText string @ The text to be displayed on the button
function ChatLinkActionButton:initialize(actionID, buttonText, questionCommand, answerCommand)
	assert(isType(actionID, "string", actionID));
	assert(isType(buttonText, "string", buttonText));
	assert(isType(questionCommand, "string", questionCommand));
	assert(isType(answerCommand, "string", answerCommand));

	_private[self] = {}
	_private[self].actionID = actionID;
	_private[self].buttonText = buttonText;
	_private[self].questionCommand = questionCommand;
	_private[self].answerCommand = answerCommand;

	-- Register to answer questions
	TRP3_API.communication.registerProtocolPrefix(questionCommand, function(linkData, sender)
		-- Previous versions of the chat links system were sending the link ID directly, as a string.
		-- We need to handle this for backward compatibility and
		if type(linkData) == "string" then
			linkData = { linkID = linkData };
		end
		local link = TRP3_API.ChatLinksManager:GetSentLinkForIdentifier(linkData.linkID);
		TRP3_API.communication.sendObject(answerCommand, link:GetData(), sender, "BULK", linkData.messageID);
	end);

	TRP3_API.communication.registerProtocolPrefix(answerCommand, function(data, sender)
		self:OnAnswerCommandReceived(data, sender)
	end)
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

--- OVERRIDE By default will send a command if one has been registered before
--- [RECIPIENT] Function called when the recipient clicked the button
---@param linkData table @ The link data as saved by the module
---@param sender string @ The name of the sender of the link
---@param button Button @ The UI button that was clicked
function ChatLinkActionButton:OnClick(linkID, sender, button)
	TRP3_API.ChatLinks:CheckVersions(function()
		-- Set the button text to indicate that we are sending the command
		button:SetText(loc.CL_SENDING_COMMAND);
		button:Disable();
		-- Get a unique message identifier for the data request, used for progression updates
		local reservedMessageID = TRP3_API.communication.getMessageIDAndIncrement();
		-- Register a new progress handler for this message ID
		TRP3_API.communication.addMessageIDHandler(sender, reservedMessageID, function(_, total, current)
			-- If the download is complete, we restore the button text
			if current == total then
				button:SetText(_private[self].buttonText);
				button:Enable();
			else
				-- We update the button text with the progression percentage
				button:Disable();
				button:SetText(loc.CL_DOWNLOADING:format((current / total) * 100));
			end
		end);

		-- Send a request for this link ID and indicate a message ID to use for progression updates
		TRP3_API.communication.sendObject(_private[self].questionCommand, {
			linkID = linkID,
			messageID = reservedMessageID,
		}, sender);
	end);
end

--- OVERRIDE
--- [RECIPIENT] Function called when the recipient received the requested data
---@param linkData table @ The request data
---@param sender string @ The name of the sender of the link
function ChatLinkActionButton:OnAnswerCommandReceived(data, sender)

end

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
	module:OnActionButtonClicked(self.command, TRP3_RefTooltip.itemData.customData, TRP3_RefTooltip.sender, self);
end

function TRP3_ChatLinkActionButtonMixin:Set(button)
	assert(isType(button, "table", button));
	assert(isType(button.text, "string", button.text));
	assert(isType(button.command, "string", button.command));

	self:SetText(button.text);
	self.command = button.command;
	self:Show();
end

function TRP3_ChatLinkActionButtonMixin:Reset()
	self:SetText("");
	self.command = nil;
	self:Hide();
	self:Enable();
end

TRP3_API.ChatLinkActionButton = ChatLinkActionButton;