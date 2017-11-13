----------------------------------------------------------------------------------
--- Total RP 3
--- Chat links
---	---------------------------------------------------------------------------
---	Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
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

--- Total RP 3 imports
local Debug = TRP3_API.Debug;
local Colors = TRP3_API.Colors;

--- Wow Imports
local assert = assert;
local pairs = pairs;
local gsub = string.gsub;
local strconcat = strconcat;
local CreateColor = CreateColor;
local format = string.format;
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter;
local UIParent = UIParent;
local ShowUIPanel = ShowUIPanel;

local CONFIG_CHARACT_MAIN_SIZE = "tooltip_char_mainSize";
local CONFIG_CHARACT_SUB_SIZE = "tooltip_char_subSize";
local CONFIG_CHARACT_TER_SIZE = "tooltip_char_terSize";
local getConfigValue = TRP3_API.configuration.getValue;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	
	TRP3_API.ChatLinks = ChatLinks;
	
	local locf = TRP3_API.locale.getTextf;
	local LINK_COLOR = Colors.COLORS.YELLOW;
	local sentLinks = {};
	
	local LINK_CODE = "totalrp3";
	local LINK_LENGTHS = LINK_CODE:len();

	ChatLinks.FORMAT = {
		SIZES = {
			TITLE = "TITLE",
			NORMAL = "NORMAL",
			SMALL = "SMALL",
		},
		COLORS = {
			YELLOW = TRP3_API.Colors.COLORS.YELLOW,
			WHITE = CreateColor(1, 1, 1, 1),
		}
	}

	local function getUserDefinedTextSize(sizeCategory)
		if sizeCategory == ChatLinks.FORMAT.SIZES.TITLE then
			return getConfigValue(CONFIG_CHARACT_MAIN_SIZE);
		elseif sizeCategory == ChatLinks.FORMAT.SIZES.NORMAL then
			return getConfigValue(CONFIG_CHARACT_SUB_SIZE);
		elseif sizeCategory == ChatLinks.FORMAT.SIZES.SMALL then
			return getConfigValue(CONFIG_CHARACT_TER_SIZE);
		else
			return getConfigValue(CONFIG_CHARACT_SUB_SIZE);
		end
	end

	-- The link pattern is [TRP3:ITEM_NAME], for example [TRP3:Epic sword] or [TRP3:My campaign]
	ChatLinks.LINK_PATTERN = "[TRP3:%s]";
	ChatLinks.FIND_LINK_PATTERN = "%[TRP3:([^%]]+)%]";

	---Generate the correct text link format to send to other players
	---@param name string @ The name of the thing to send, will be visible by other people
	---@param linkData table @ The data that will be displayed in the tooltip for this link
	---@return string
	function ChatLinks.generateLink(name, linkData)
		assert(name, locf("DEBUG_NIL_PARAMETER", "name", "ChatLinks.generateLink(name, linkData)"));
		assert(linkData, locf("DEBUG_NIL_PARAMETER", "linkData", "ChatLinks.generateLink(name, linkData)"));
		if not sentLinks[name] then
			sentLinks[name] = linkData;
		elseif sentLinks[name] ~= linkData then
			-- TODO handle duplicate names
		end
		return format(ChatLinks.LINK_PATTERN, name);
	end

	-- List of channels we will support for our links
	local POSSIBLE_CHANNELS = {
		"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
		"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
		"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM",
		"CHAT_MSG_CHANNEL"
	};

	local FORMATTED_LINK_FORMAT = "|Htotalrp3:%s:%s|h%s|h|r";
	local function generateFormattedLink(name, playerName)
		assert(name, locf("DEBUG_NIL_PARAMETER", "name", "generateFormattedLink(name, playerName)"));
		assert(playerName, locf("DEBUG_NIL_PARAMETER", "playerName", "generateFormattedLink(name, playerName)"));
		local formattedName = LINK_COLOR:WrapTextInColorCode(strconcat("[", name, "]"));
		return format(FORMATTED_LINK_FORMAT, playerName, name, formattedName);
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
		assert(text, locf("DEBUG_NIL_PARAMETER", "text", "ChatLinks.generateSingleLineTooltipData(text, color, size, wrap)"));
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
		assert(textLeft, locf("DEBUG_NIL_PARAMETER", "textLeft", "ChatLinks.generateDoubleLineTooltipData(textLeft, textRight, colorLeft, colorRight, size, wrap)"));
		assert(textRight, locf("DEBUG_NIL_PARAMETER", "textRight", "ChatLinks.generateDoubleLineTooltipData(textLeft, textRight, colorLeft, colorRight, size, wrap)"));
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

	local ItemRefTooltip = ItemRefTooltip;
	local function showTooltip(tooltipContent)
		ShowUIPanel(ItemRefTooltip);
		if not ItemRefTooltip:IsVisible() then
			ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
		end
		ItemRefTooltip:ClearLines();

		for _, line in pairs(tooltipContent) do
			local size = getUserDefinedTextSize(line.size);
			if line.double then
				local colorLeft = line.colorLeft or {};
				local colorRight = line.colorRight or {};
				ItemRefTooltip:AddDoubleLine(line.textLeft, line.textRight, colorLeft.r, colorLeft.g, colorLeft.b, colorRight.r, colorRight.g, colorRight.b, line.wrap);
			else
				ItemRefTooltip:AddLine(line.text, line.r, line.g, line.b, line.wrap);
			end
		end

		ItemRefTooltip:Show();
	end

	-- |Htotalrp3:CharacterName-RealName:Non formatted item name|h|cffaabbcc[My item name]|r|h
	hooksecurefunc("ChatFrame_OnHyperlinkShow", function(self, link, text, button)
		local linkType = link:sub(1, LINK_LENGTHS);
		if linkType == LINK_CODE then
			local linkContent = link:sub(LINK_LENGTHS + 2);
			local separatorIndex = linkContent:find(":");
			local playerName = linkContent:sub(1, separatorIndex - 1);
			local itemName = linkContent:sub(separatorIndex + 1);
			
			-- TODO We would show that we are requesting the data and then replace the text asynchronously
			showTooltip({
				ChatLinks.generateSingleLineTooltipData("Requesting data from " .. playerName, ChatLinks.FORMAT.COLORS.YELLOW),
			});
			
			-- We are emulating the asynchronousness here with a timer function while working on the feature
			C_Timer.After(1, function()
				showTooltip(sentLinks[itemName])
			end);
		end
	end)
	
	local OriginalSetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		if(link and link:sub(0, 8) == "totalrp3") then
			return;
		end
		return OriginalSetHyperlink(self, link, ...);
	end
end)