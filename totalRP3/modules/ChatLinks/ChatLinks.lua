----------------------------------------------------------------------------------
--- Total RP 3
--- Chat links
------------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---     http://www.apache.org/licenses/LICENSE-2.0
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

--region Ellyb imports
local ColorManager = Ellyb.ColorManager;
local ORANGE = ColorManager.ORANGE;
--endregion

--region Wow Imports
local assert = assert;
local pairs = pairs;
local gsub = string.gsub;
local ipairs = ipairs
local strconcat = strconcat;
local format = string.format;
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter;
local UIParent = UIParent;
local ShowUIPanel = ShowUIPanel;
--endregion

--region Total RP 3 imports
local ChatLinkModule = TRP3_API.ChatLinkModule;
local loc = TRP3_API.loc;
--endregion

local LINK_CODE = "totalrp3";
local LINK_LENGTHS = LINK_CODE:len();

local LINK_COLOR = ColorManager.YELLOW;
local CHAT_LINKS_PROTOCOL_REQUEST_PREFIX = "CTLK_R"; -- Request data about a link clicked
local CHAT_LINKS_PROTOCOL_DATA_PREFIX = "CTLK_D"; -- Send data bout a link sent

local UNKNOWN_LINK = "UNKNOWN_LINK";

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
---@return ChatLinkModule module
function ChatLinks:InstantiateModule(moduleName, moduleID)
	assert(not chatLinksModules[moduleID], "Trying to register a ChatLinkModule with an existing ID " .. moduleID);

	local module = ChatLinkModule(moduleName, moduleID);
	chatLinksModules[moduleID] = module;
	return module;
end

---@return ChatLinkModule
function ChatLinks:GetModuleByID(moduleID)
	Ellyb.Assertions.isType(moduleID, "string", "moduleID");
	return chatLinksModules[moduleID];
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	---@param link ChatLink
	function ChatLinks.storeLink(link)
		Ellyb.Assertions.isInstanceOf(link, "ChatLink", "link");
		local linkIdentifier = TRP3_API.Ellyb.Strings.generateUniqueName(sentLinks, link:GetIdentifier());
		link:SetIdentifier(linkIdentifier);
		sentLinks[linkIdentifier] = link;
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
		Ellyb.Assertions.isType(text, "string", "text");
		Ellyb.Assertions.isType(playerName, "string", "playerName");

		local formattedName = LINK_COLOR:WrapTextInColorCode(strconcat("[", text, "]"));
		return format(FORMATTED_LINK_FORMAT, playerName, text, formattedName);
	end

	-- MessageEventFilter to look for Total RP 3 chat links and format the message accordingly
	local function lookForChatLinks(_, _, message, playerName, ...)
		message = gsub(message, ChatLinks.FIND_LINK_PATTERN, function(name)
			return generateFormattedLink(name, playerName)
		end)
		return false, message, playerName, ...;
	end

	for _, channel in pairs(POSSIBLE_CHANNELS) do
		ChatFrame_AddMessageEventFilter(channel, lookForChatLinks);
	end

	---@type GameTooltip
	local TRP3_RefTooltip = TRP3_RefTooltip;
	---@type TRP3_ChatLinkActionButtonMixin[]
	local ActionButtons = {
		TRP3_RefTooltip.Button1,
		TRP3_RefTooltip.Button2,
		TRP3_RefTooltip.Button3,
		TRP3_RefTooltip.Button4,
		TRP3_RefTooltip.Button5,
	}

	local function hideActionButtons()
		for _, button in pairs(ActionButtons) do
			button:Reset();
		end
	end

	local function showTooltip(itemData, sender)
		local tooltipContent, actionButtons = itemData.tooltipLines, itemData.actionButtons;
		ShowUIPanel(TRP3_RefTooltip);
		if not TRP3_RefTooltip:IsVisible() then
			TRP3_RefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
		end
		TRP3_RefTooltip:ClearLines();
		hideActionButtons();

		TRP3_RefTooltip.sender = sender;
		TRP3_RefTooltip:SetText(tooltipContent.title, TRP3_API.Ellyb.ColorManager.WHITE:GetRGB());

		if tooltipContent.lines then
			for _, line in ipairs(tooltipContent.lines) do
				if line.double then
					TRP3_RefTooltip:AddDoubleLine(line.textLeft, line.textRight, line.rLeft, line.gLeft, line.bLeft,
						line.rRight, line.gRight, line.bRight, line.wrap);
				else
					TRP3_RefTooltip:AddLine(line.text, line.r, line.g, line.b, line.wrap);
				end
			end
		end

		if IsAltKeyDown() then
			TRP3_RefTooltip:AddLine(" ");
			if itemData.moduleName then
				TRP3_RefTooltip:AddLine(loc.CL_TYPE:format(ORANGE(itemData.moduleName)));
			end
			TRP3_RefTooltip:AddLine(loc.CL_SENT_BY:format(ORANGE(sender)));
			if itemData.size then
				TRP3_RefTooltip:AddLine(loc.CL_CONTENT_SIZE:format(ORANGE(Ellyb.Strings.formatBytes(itemData.size))));
			end
			TRP3_RefTooltip.wasAltKeyDown = true;
		else
			TRP3_RefTooltip.wasAltKeyDown = false;
		end

		local minWidth = 0;
		local buttonAddedHeight = 0;
		if actionButtons and ChatLinks:HasModule(itemData.moduleID) then
			for i, button in pairs(actionButtons) do
				ActionButtons[i]:Set(button);
				buttonAddedHeight = buttonAddedHeight + ActionButtons[i]:GetHeight() + 5;
				if ActionButtons[i]:GetWidth() > minWidth then
					minWidth = ActionButtons[i]:GetWidth();
				end
			end
		end

		TRP3_RefTooltip.itemData = itemData;
		TRP3_RefTooltip:Show();
		TRP3_RefTooltip:SetHeight(TRP3_RefTooltip:GetHeight() + buttonAddedHeight + 5);
		if TRP3_RefTooltip:GetWidth() < minWidth then
			TRP3_RefTooltip:SetWidth(minWidth + 20)
		end
	end

	function TRP3_RefTooltip:Refresh()
		showTooltip(self.itemData, self.sender);
	end

	-- |Htotalrp3:CharacterName-RealName:Non formatted item name|h|cffaabbcc[My item name]|r|h
	hooksecurefunc("ChatFrame_OnHyperlinkShow", function(_, link)
		local linkType = link:sub(1, LINK_LENGTHS);
		if linkType == LINK_CODE then
			if IsShiftKeyDown() then
				-- If the shift key is down, the user is trying to insert a TRP3 link.
				-- That's not supported for now, so we'll remove the hyperlink escape sequence from the chatframe editbox text
				local activeChatFrame = ChatEdit_GetActiveWindow();
				if activeChatFrame and activeChatFrame.chatFrame and activeChatFrame.chatFrame.editBox then
					activeChatFrame.chatFrame.editBox:SetText(TRP3_API.utils.str.sanitize(activeChatFrame.chatFrame.editBox:GetText()));
				end
			else
				local linkContent = link:sub(LINK_LENGTHS + 2);
				local separatorIndex = linkContent:find(":");
				local playerName = linkContent:sub(1, separatorIndex - 1);
				local itemName = linkContent:sub(separatorIndex + 1);

				AddOn_TotalRP3.Communications.sendObject(CHAT_LINKS_PROTOCOL_REQUEST_PREFIX, itemName, playerName);

				TRP3_RefTooltip.itemName = itemName;
				-- TODO Localization and better UI feedback
				showTooltip({
					tooltipLines = {
						title = loc.CL_REQUESTING_DATA:format(playerName),
					},
				});
			end
		end
	end)

	-- Sadly we need this so that Blizzard's code doesn't raise an error because we clicked on a link it doesn't understand
	local OriginalSetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		if (link and link:sub(0, 8) == "totalrp3") then
			return;
		end
		return OriginalSetHyperlink(self, link, ...);
	end

	-- Register command prefix when requested for tooltip data for an item
	AddOn_TotalRP3.Communications.registerSubSystemPrefix(CHAT_LINKS_PROTOCOL_REQUEST_PREFIX, function(identifier, sender)
		local link = TRP3_API.ChatLinksManager:GetSentLinkForIdentifier(identifier);
		if not link then
			AddOn_TotalRP3.Communications.sendObject(CHAT_LINKS_PROTOCOL_DATA_PREFIX, UNKNOWN_LINK, sender);
			return
		end

		AddOn_TotalRP3.Communications.sendObject(CHAT_LINKS_PROTOCOL_DATA_PREFIX, {
			itemName = link:GetIdentifier(), -- Item name is sent back so the recipient knows what we are answering to
			tooltipLines = link:GetTooltipLines():GetRaw(), -- Get a list of lines to show inside the tooltip
			actionButtons = link:GetActionButtons(), --  Get a list of actions buttons to show inside the tooltip (only data)
			moduleID = link:GetModuleID(), -- Module ID is sent so recipient know what it is and use the right functions if they have the module
			customData = link:GetIdentifier(),
			size = link:GetContentSize(), -- Indicates the size of the content
			moduleName = link:GetModuleName(), -- Module name, shown in the tooltip
			v = TRP3_API.globals.version, -- The TRP3 version is sent so that a warning is shown if version differs while clicking action buttons
		}, sender, nil, nil, true);
	end);

	-- Register command prefix when received tooltip data
	AddOn_TotalRP3.Communications.registerSubSystemPrefix(CHAT_LINKS_PROTOCOL_DATA_PREFIX, function(itemData, sender)
		if itemData == UNKNOWN_LINK then
			showTooltip({
				tooltipLines = {
					title = loc.CL_EXPIRED,
				},
			});
			return
		end
		local itemName = itemData.itemName;
		if TRP3_RefTooltip.itemName == itemName then
			showTooltip(itemData, sender);
		end
	end);

	function ChatLinks:OpenMakeImportablePrompt(linkType, callback)
		Ellyb.Assertions.isType(linkType, "string", "linkType");
		Ellyb.Assertions.isType(callback, "function", "callback");

		TRP3_API.popup.showCustomYesNoPopup(loc.CL_MAKE_IMPORTABLE_SIMPLER:format(TRP3_API.Ellyb.ColorManager.ORANGE(linkType)),
			loc.CL_MAKE_IMPORTABLE_BUTTON_TEXT,
			loc.CL_MAKE_NON_IMPORTABLE,
			function()
				callback(true);
			end,
			function()
				callback(false);
			end)
	end

	function ChatLinks:CheckVersions(callback)
		Ellyb.Assertions.isType(callback, "function", "callback");

		if TRP3_RefTooltip.itemData.v ~= TRP3_API.globals.version then
			TRP3_API.popup.showConfirmPopup(TRP3_API.loc.CL_VERSIONS_DIFFER, callback);
		else
			callback();
		end
	end

	function ChatLinks:HasModule(moduleID)
		Ellyb.Assertions.isType(moduleID, "string", "moduleID");
		return chatLinksModules[moduleID] ~= nil;
	end
end)
