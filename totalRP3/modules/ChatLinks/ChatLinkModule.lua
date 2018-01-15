----------------------------------------------------------------------------------
--- Total RP 3
---
--- Chat Link Module
---
--- This an Ellyb class used as an interface for Chat Link Modules.
--- The class defines methods for the modules that should be overridden to
--- implement the specific behaviour of each module.
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

-- WoW imports
local GetCurrentKeyBoardFocus = GetCurrentKeyBoardFocus;

-- Total RP 3 imports
local ChatLink = TRP3_API.ChatLink;

---@class ChatLinkModule : Object
local ChatLinkModule, _private = TRP3_API.Ellyb.Class("ChatLinkModule");

function ChatLinkModule:initialize(moduleName, moduleID)
	_private[self] = {}
	_private[self].moduleName = moduleName;
	_private[self].moduleID = moduleID;
end

---@return string moduleName
function ChatLinkModule:GetName()
	return _private[self].moduleName;
end

---@return string moduleID
function ChatLinkModule:GetID()
	return _private[self].moduleID;
end

--- [SENDER SIDE] Get the link data that will be sent
--- MODULES SHOULD OVERRIDE THIS FUNCTION to implement the behaviour needed for that module
----@return string, table linkText, linkData @ The text to show in the link and a table with whatever data the module needs to format the tooltip later
function ChatLinkModule:GetLinkData(...)
	return "link", {};
end

--- [SENDER SIDE] Get the tooltip lines that should be shown on the recipient's end
---@param linkData table @ The data table that was given by the ChatLinkModule in :GetLinkData()
---@return ChatLinkTooltipLines tooltipLines @ A table of tooltip lines to be displayed inside the tooltip on the recipient's end
function ChatLinkModule:GetTooltipLines(linkData)
	return {};
end

--- [SENDER SIDE] Get the action buttons to display inside the tooltip
--- Action buttons are only visible if the module that generated the link is available on the recipient's end
---@param linkData table @ A table of action buttons that should be shown inside the tooltip for this link data (can be empty)
function ChatLinkModule:GetActionButtons(linkData)
	return {};
end

--- [RECIPIENT SIDE] Function called when one of the action button displayed in the tooltip is clicked.
---@param actionID number @ The ID of the action that was clicked
---@param itemName string @ The item name as shown in the chat link
---@param tooltipData table @ The tooltip data as sent by the sender
function ChatLinkModule:OnActionButtonClicked(actionID, itemName, tooltipData)

end

--- Insert a link inside the currently focused editbox.
--- The arguments passed to this function will be passed to
---@param ... any @ You can pass any arguments that ChatLinkModule:GetLinkData(...) needs
function ChatLinkModule:InsertLink(...)
	local editbox = GetCurrentKeyBoardFocus();
	if editbox then
		local link = ChatLink(self:GetLinkData(...), self);
		editbox:Insert(link:GetText());
	end
end

TRP3_API.ChatLinkModule = ChatLinkModule;