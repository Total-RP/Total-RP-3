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
local Ellyb = Ellyb(...);

-- Lua imports
local insert = table.insert;
local assert = assert;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

---@class ChatLinkTooltipLines
local ChatLinkTooltipLines, _private = TRP3_API.Ellyb.Class("ChatLinkTooltipLines");

---@param optional title string
function ChatLinkTooltipLines:initialize(title)
	_private[self] = {};

	_private[self].title = title or "";
	_private[self].lines = {};
end

function ChatLinkTooltipLines:SetTitle(title)
	assert(isType(title, "string", "title"));

	_private[self].title = title;
end

---@param text string
---@param optional color Color
---@param optional size number
function ChatLinkTooltipLines:AddLine(text, color, size)
	assert(isType(text, "string", "text"));

	if not color then
		color = TRP3_API.Ellyb.ColorManager.WHITE;
	end
	local r, g, b = color:GetRGB();
	insert(_private[self].lines, {
		text = text,
		r = r,
		g = g,
		b = b,
		size = size,
		wrap = true,
	});
end

---@param textLeft string
---@param textRight string
---@param colorRight Color
---@param colorLeft Color
---@param size number
function ChatLinkTooltipLines:AddDoubleLine(textLeft, textRight, colorRight, colorLeft, size)
	assert(isType(textLeft, "string", "textLeft"));
	assert(isType(textRight, "string", "textRight"));

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