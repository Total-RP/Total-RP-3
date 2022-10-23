-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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
