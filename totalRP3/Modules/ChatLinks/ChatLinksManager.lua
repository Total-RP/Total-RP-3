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
	local stem = chatLink:GetIdentifier();
	local identifier = strjoin(":", stem, tries);

	while sentChatLinks[identifier] do
		tries = tries + 1;
		identifier = strjoin(":", stem, tries);
	end

	chatLink:SetIdentifier(identifier);
	sentChatLinks[identifier] = chatLink;
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
