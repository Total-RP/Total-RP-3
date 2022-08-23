-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

---@class ChatLink
local ChatLink, _private = Ellyb.Class("ChatLink");

function ChatLink:initialize(identifier, data, moduleID)
	Ellyb.Assertions.isType(identifier, "string", "identifier");
	Ellyb.Assertions.isNotEmpty(data, "data");
	Ellyb.Assertions.isType(moduleID, "string", "moduleID");

	_private[self] = {};
	_private[self].identifier = identifier;
	_private[self].data = data;
	_private[self].moduleID = moduleID;

	TRP3_API.ChatLinksManager:StoreSentLink(self);

	local tooltipLines = self:GetModule():GetTooltipLines(self:GetData());
	_private[self].tooltipLines = tooltipLines;
end

function ChatLink:GetIdentifier()
	return _private[self].identifier;
end

---@param identifier string
function ChatLink:SetIdentifier(identifier)
	Ellyb.Assertions.isType(identifier, "string", "identifier");

	_private[self].identifier = identifier;
end

function ChatLink:GetText()
	return TRP3_API.ChatLinks.LINK_PATTERN:format(self:GetIdentifier());
end

function ChatLink:GetModuleID()
	return _private[self].moduleID;
end

function ChatLink:GetModuleName()
	return self:GetModule():GetName();
end

---@return ChatLinkModule
function ChatLink:GetModule()
	return TRP3_API.ChatLinks:GetModuleByID(self:GetModuleID());
end

function ChatLink:GetData()
	return _private[self].data;
end

---@return ChatLinkTooltipLines
function ChatLink:GetTooltipLines()
	return _private[self].tooltipLines;
end

---@return ChatLinkActionButton[]
function ChatLink:GetActionButtons()
	return self:GetModule():GetActionButtons(self:GetData());
end

function ChatLink:GetCustomData()
	return self:GetModule():GetCustomData(self:GetData());
end

---Returns the size of the data that will be sent
function ChatLink:GetContentSize()
	if not _private[self].contentSize then
		-- We save the content size so we only have to get it once, instead of serializing every time
		_private[self].contentSize = AddOn_TotalRP3.Communications.estimateStructureSize(self:GetData(), true);
	end
	return _private[self].contentSize;
end

TRP3_API.ChatLink = ChatLink;
