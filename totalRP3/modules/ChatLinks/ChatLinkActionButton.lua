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
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

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
	AddOn_TotalRP3.Communications.registerSubSystemPrefix(questionCommand, function(linkData, sender)
		local link = TRP3_API.ChatLinksManager:GetSentLinkForIdentifier(linkData.linkID);
		AddOn_TotalRP3.Communications.sendObject(answerCommand, link:GetData(), sender, "LOW", linkData.messageToken)
	end);

	AddOn_TotalRP3.Communications.registerSubSystemPrefix(
		answerCommand,
		-- Note: We cannot use Ellyb's Functions.bind here since the OnAnswerCommandReceived method is overwritten at a
		-- later time by the module created and the binding will target the wrong method.
		function(data, sender, channel)
			self:OnAnswerCommandReceived(data, sender, channel);
		end,
		function(messageToken, sender, msgTotal, msgID)
			self:OnProgressDownload(messageToken, sender, msgTotal, msgID);
		end
	)
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
		local messageToken = TRP3_API.communication.getMessageIDAndIncrement();
		self.messageToken = messageToken;
		-- Send a request for this link ID and indicate a message ID to use for progression updates
		TRP3_API.communication.sendObject(_private[self].questionCommand, {
			linkID = linkID,
			messageID = messageToken,
		}, sender);
	end);
end

--- OVERRIDE
--- [RECIPIENT] Function called when the recipient received the requested data
---@param linkData table @ The request data
---@param sender string @ The name of the sender of the link
function ChatLinkActionButton:OnAnswerCommandReceived(data, sender)

end

function ChatLinkActionButton:OnProgressDownload(messageToken, sender, amountOfMessagesIncoming, amountOfMessagesReceived)
	if not messageToken == self.messageToken then
		return
	end
	-- If the download is complete, we restore the button text
	if amountOfMessagesReceived == amountOfMessagesIncoming then
		self.button:SetText(_private[self].buttonText);
		self.button:Enable();
	else
		-- We update the button text with the progression percentage
		self.button:Disable();
		self.button:SetText(loc.CL_DOWNLOADING:format((amountOfMessagesReceived / amountOfMessagesIncoming) * 100));
	end
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
