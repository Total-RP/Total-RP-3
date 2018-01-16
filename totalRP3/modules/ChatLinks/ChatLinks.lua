----------------------------------------------------------------------------------
--- Total RP 3
--- Chat links
---    ---------------------------------------------------------------------------
---    Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

---@class TRP3_ChatLinks
--- # Chat links API
---
--- This part of the Total RP 3 core add-on will handle Total RP 3 custom links:
--- - discovering links inside chat message.
--- - displaying the links as clickable text in the chat frame.
--- - requesting the original sender of the link for the tooltip data that should be displayed.
--- - keeping a list of links send and their data.
local ChatLinks = {};
TRP3_API.ChatLinks = ChatLinks;

--- Ellyb imports
local ColorManager = TRP3_API.Ellyb.ColorManager;
local isType = TRP3_API.Ellyb.Assertions.isType;

--- Wow Imports
local assert = assert;
local pairs = pairs;
local gsub = string.gsub;
local strconcat = strconcat;
local format = string.format;
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter;
local UIParent = UIParent;
local ShowUIPanel = ShowUIPanel;

--- Total RP 3 imports
local ChatLinkModule = TRP3_API.ChatLinkModule;

local LINK_CODE = "totalrp3";
local LINK_LENGTHS = LINK_CODE:len();

local LINK_COLOR = ColorManager.YELLOW;
local CHAT_LINKS_PROTOCOL_REQUEST_PREFIX = "CTLK_R"; -- Request data about a link clicked
local CHAT_LINKS_PROTOCOL_DATA_PREFIX = "CTLK_D"; -- Send data bout a link sent

-- The link pattern is [TRP3:ITEM_NAME], for example [TRP3:Epic sword] or [TRP3:My campaign]
ChatLinks.LINK_PATTERN = "[TRP3:%s]";
ChatLinks.FIND_LINK_PATTERN = "%[TRP3:([^%]]+)%]";

ChatLinks.FORMAT = {
	SIZES = {
		TITLE = "TITLE",
		NORMAL = "NORMAL",
		SMALL = "SMALL",
	},
	COLORS = {
		YELLOW = ColorManager.YELLOW,
		WHITE = ColorManager.WHITE,
	}
}

---@type ChatLink[]
local sentLinks = {};

---@type ChatLinkModule[]
local chatLinksModules = {};

--- Instantiate a new ChatLinkModule with the ChatLinks module
---@param moduleName string @ The name of the module (
---@param moduleID string @ A unique (but identifiable) ID for the new chat link module. Will be used to relate links back to the module
function ChatLinks:InstantiateModule(moduleName, moduleID)
	assert(not chatLinksModules[moduleID], "Trying to register a ChatLinkModule with an existing ID " .. moduleID);

	local module = ChatLinkModule(moduleName, moduleID);
	chatLinksModules[moduleID] = module;
	return module;
end

---@return ChatLinkModule
function ChatLinks:GetModuleByID(moduleID)
	return chatLinksModules[moduleID];
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	---@param link ChatLink
	function ChatLinks.storeLink(link)
		local tries = 1;
		while sentLinks[link:GetIdentifier()] do
			link:SetIdentifier(link:GetIdentifier() .. tries);
			tries = tries + 1;
		end
		sentLinks[link:GetIdentifier()] = link;
	end

	-- List of channels we will support for our links
	local POSSIBLE_CHANNELS = {
		"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
		"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
		"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM",
		"CHAT_MSG_CHANNEL"
	};

	local FORMATTED_LINK_FORMAT = "|Htotalrp3:%s:%s|h%s|h|r";
	local function generateFormattedLink(text, playerName)
		assert(isType(text, "string", "text"));
		assert(isType(playerName, "string", "playerName"));

		local formattedName = LINK_COLOR:WrapTextInColorCode(strconcat("[", text, "]"));
		return format(FORMATTED_LINK_FORMAT, playerName, text, formattedName);
	end

	-- MessageEventFilter to look for Total RP 3 chat links and format the message accordingly
	local function lookForChatLinks(_, event, message, playerName, ...)
		message = gsub(message, ChatLinks.FIND_LINK_PATTERN, function(name)
			return generateFormattedLink(name, playerName)
		end)
		return false, message, playerName, ...;
	end

	for _, channel in pairs(POSSIBLE_CHANNELS) do
		ChatFrame_AddMessageEventFilter(channel, lookForChatLinks);
	end

	---Generate the table of data to display a single line in the tooltip
	---@param text string @ Text for the line
	---@param optional color ColorMixin @ Color for the text (default white)
	---@param optional size number @ Size of the text (default 12)
	function ChatLinks.generateSingleLineTooltipData(text, color, size, wrap)
		assert(isType(text, "string", "text"));
		if not color then
			color = ChatLinks.FORMAT.COLORS.WHITE;
		end
		if not size then
			size = ChatLinks.FORMAT.SIZES.NORMAL;
		end

		return {
			text = text,
			r = color.r,
			g = color.g,
			b = color.b,
			size = size,
			wrap = wrap,
		}
	end

	---Generate the table of data to display a double line in the tooltip (one text on the left and one text on the right
	---@param textLeft string @ Text to be shown on the left of the line
	---@param textRight string @ Text to be shown on the right of the line
	---@param optional colorLeft ColorMixin @ Color for the left text (default white)
	---@param optional colorRight ColorMixin @ Color for the right text (default white)
	---@param optional size number @ Size of the text (default 12)
	function ChatLinks.generateDoubleLineTooltipData(textLeft, textRight, colorLeft, colorRight, size, wrap)
		assert(isType(textLeft, "string", "textLeft"));
		assert(isType(textRight, "string", "textRight"));

		if not colorLeft then
			colorLeft = ChatLinks.FORMAT.COLORS.WHITE;
		end
		if not colorRight then
			colorRight = ChatLinks.FORMAT.COLORS.WHITE;
		end
		if not size then
			size = ChatLinks.FORMAT.SIZES.NORMAL;
		end

		return {
			double = true,
			textLeft = textLeft,
			textRight = textRight,
			colorLeft = colorLeft,
			colorRight = colorRight,
			size = size,
			wrap = wrap,
		}
	end

	local TRP3_RefTooltip = TRP3_RefTooltip;

	local function onActionButtonClicked(button)
		local module = ChatLinks:GetModuleByID(TRP3_RefTooltip.itemData.moduleID);
		module:OnActionButtonClicked(button.command, TRP3_RefTooltip.itemData.customData, TRP3_RefTooltip.sender);
	end
	for i = 1, 5 do
		TRP3_RefTooltip["Button" .. i]:SetScript("OnClick", onActionButtonClicked);
	end


	local function showTooltip(itemData, sender)
		local tooltipContent, actionButtons = itemData.tooltipLines, itemData.actionButtons;
		ShowUIPanel(TRP3_RefTooltip);
		if not TRP3_RefTooltip:IsVisible() then
			TRP3_RefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
		end
		TRP3_RefTooltip:ClearLines();

		TRP3_RefTooltip.sender = sender;
		TRP3_RefTooltip:SetText(tooltipContent.title, TRP3_API.Ellyb.ColorManager.YELLOW:GetRGB());

		if tooltipContent.lines then
			for _, line in pairs(tooltipContent.lines) do
				if line.double then
					TRP3_RefTooltip:AddDoubleLine(line.textLeft, line.textRight, line.rLeft, line.gLeft, line.bLeft,
						line.rRight, line.gRight, line.bRight, line.wrap);
				else
					TRP3_RefTooltip:AddLine(line.text, line.r, line.g, line.b, line.wrap);
				end
			end
		end

		if actionButtons then
			for i, button in pairs(actionButtons) do
				TRP3_RefTooltip:AddLine(" ");
				TRP3_RefTooltip:AddLine(" ");
				TRP3_RefTooltip["Button" .. i]:SetText(button.text);
				TRP3_RefTooltip["Button" .. i]:Show();
				TRP3_RefTooltip["Button" .. i].command = button.command;
			end
		end

		TRP3_RefTooltip.itemData = itemData;
		TRP3_RefTooltip:Show();
	end

	-- |Htotalrp3:CharacterName-RealName:Non formatted item name|h|cffaabbcc[My item name]|r|h
	hooksecurefunc("ChatFrame_OnHyperlinkShow", function(self, link, text, button)
		local linkType = link:sub(1, LINK_LENGTHS);
		if linkType == LINK_CODE then
			local linkContent = link:sub(LINK_LENGTHS + 2);
			local separatorIndex = linkContent:find(":");
			local playerName = linkContent:sub(1, separatorIndex - 1);
			local itemName = linkContent:sub(separatorIndex + 1);

			TRP3_API.communication.sendObject(CHAT_LINKS_PROTOCOL_REQUEST_PREFIX, itemName, playerName);

			TRP3_RefTooltip.itemName = itemName;
			-- TODO Localization and better UI feedback
			showTooltip({
				tooltipLines = {
					title = "Requesting data from " .. playerName,
				},
			});
		end
	end)

	local OriginalSetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		if (link and link:sub(0, 8) == "totalrp3") then
			return;
		end
		return OriginalSetHyperlink(self, link, ...);
	end

	-- Register command prefix when requested for tooltip data for an item
	TRP3_API.communication.registerProtocolPrefix(CHAT_LINKS_PROTOCOL_REQUEST_PREFIX, function(identifier, sender)
		local link = TRP3_API.ChatLinksManager:GetSentLinkForIdentifier(identifier);
		if not link then
			-- TODO Send error that we no longer have the data
			return
		end

		TRP3_API.communication.sendObject(CHAT_LINKS_PROTOCOL_DATA_PREFIX, {
			itemName = link:GetIdentifier(), -- Item name is sent back so the recipient knows what we are answering to
			tooltipLines = link:GetTooltipLines():GetRaw(), -- Get a list of lines to show inside the tooltip
			actionButtons = link:GetActionButtons(), --  Get a list of actions buttons to show inside the tooltip (only data)
			moduleID = link:GetModuleID(), -- Module ID is sent so recipient know what it is and use the right functions if they have the module
			customData = link:GetCustomData(),
			v = TRP3_API.globals.version, -- The TRP3 version is sent so that a warning is shown if version differs while clicking action buttons
		}, sender);
	end);

	-- Register command prefix when received tooltip data
	TRP3_API.communication.registerProtocolPrefix(CHAT_LINKS_PROTOCOL_DATA_PREFIX, function(itemData, sender)
		local itemName = itemData.itemName;
		if TRP3_RefTooltip.itemName == itemName then
			showTooltip(itemData, sender);
		end
	end);
end)