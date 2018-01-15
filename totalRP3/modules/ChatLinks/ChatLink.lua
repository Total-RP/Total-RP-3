----------------------------------------------------------------------------------
--- Total RP 3
---
--- Chat Link
---
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

-- Lua imports
local format = string.format;

---@class ChatLink
local ChatLink, _private = TRP3_API.Ellyb.Class("ChatLink");

function ChatLink:initialize(identifier, data, moduleID)
	_private[self] = {};
	_private[self].identifier = identifier;
	_private[self].data = data;
	_private[self].moduleID = moduleID;

	TRP3_API.ChatLinksManager:StoreSentLink(self);
end

function ChatLink:GetIdentifier()
	return _private[self].identifier;
end

---@param identifier string
function ChatLink:SetIdentifier(identifier)
	_private[self].identifier = identifier;
end

function ChatLink:GetText()
	return format(TRP3_API.ChatLinks.LINK_PATTERN, self:GetIdentifier());
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
	local tooltipLines =  self:GetModule():GetTooltipLines(self:GetData());
	tooltipLines:AddLine("");
	tooltipLines:AddLine(self:GetModuleName(), TRP3_API.Ellyb.ColorManager.ORANGE, TRP3_API.ChatLinks.FORMAT.SIZES.SMALL);
	return tooltipLines;
end

---@return ChatLinkActionButton[]
function ChatLink:GetActionButtons()
	return self:GetModule():GetActionButtons(self:GetData());
end

TRP3_API.ChatLink = ChatLink;