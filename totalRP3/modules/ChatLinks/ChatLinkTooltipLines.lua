----------------------------------------------------------------------------------
--- Total RP 3
---
--- Chat Link Tooltip Data
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
local insert = table.insert;
local pairs = pairs;

---@class ChatLinkTooltipLines
local ChatLinkTooltipLines, _private = TRP3_API.Ellyb.Class("ChatLinkTooltipLines");

function ChatLinkTooltipLines:initialize(title)
	_private[self] = {};

	_private[self].title = title;
	_private[self].lines = {};
end

function ChatLinkTooltipLines:SetTitle(title)
	_private[self].title = title;
end

---@param text string
---@param color Color
---@param size number
function ChatLinkTooltipLines:AddLine(text, color, size)
	if not color then
		color = TRP3_API.Ellyb.ColorManager.WHITE;
	end
	local r, g, b = color:GetRGB();
	insert(_private[self].lines, {
		text = text,
		r = r,
		g = g,
		b = b,
		size = size
	});
end

---@param text string
---@param color Color
---@param size number
function ChatLinkTooltipLines:AddDoubleLine(textRight, textLeft, colorRight, colorLeft, size)

	if not colorLeft then
		colorLeft = TRP3_API.Ellyb.ColorManager.WHITE;
	end
	if not colorRight then
		colorRight = TRP3_API.Ellyb.ColorManager.WHITE;
	end

	local rLeft, gLeft, bLeft = colorLeft:GetRGB();
	local rRight, gRight, bRight = colorRight:GetRGB();
	insert(_private[self].lines, {
		double = true,
		textLeft = textLeft,
		textRight = textRight,
		rLeft = rLeft,
		gLeft = gLeft,
		bLeft = bLeft,
		rRight = rRight,
		gRight = gRight,
		bRight = bRight,
		size = size,
	});
end

function ChatLinkTooltipLines:GetRaw()
	return _private[self];
end

TRP3_API.ChatLinkTooltipLines = ChatLinkTooltipLines;