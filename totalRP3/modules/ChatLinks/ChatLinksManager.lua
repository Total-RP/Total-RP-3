----------------------------------------------------------------------------------
--- Total RP 3
--- Chat Link
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

local ChatLinksManager = {};

---@type ChatLink[]
local sentChatLinks, openedChatLinks = {}, {};

---@param chatLink ChatLink
function ChatLinksManager:StoreSentLink(chatLink)
	local tries = 1;
	while sentChatLinks[chatLink:GetIdentifier()] do
		chatLink:SetIdentifier(chatLink:GetIdentifier() .. tries);
		tries = tries + 1;
	end
	sentChatLinks[chatLink:GetIdentifier()] = chatLink;
end

---@return ChatLink
function ChatLinksManager:GetSentLinkForIdentifier(linkIdentifier)
	return sentChatLinks[linkIdentifier];
end

---@param chatLink ChatLink
function ChatLinksManager:StoreReceivedLink(chatLink)
	openedChatLinks[chatLink:GetIdentifier()] = chatLink;
end

---@return ChatLink
function ChatLinksManager:GetReceivedLinkForIdentifier(linkIdentifier)
	return openedChatLinks[linkIdentifier];
end

TRP3_API.ChatLinksManager = ChatLinksManager;
