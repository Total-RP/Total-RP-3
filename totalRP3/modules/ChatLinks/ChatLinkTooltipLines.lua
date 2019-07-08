----------------------------------------------------------------------------------
--- Total RP 3
--- Chat Link Tooltip Data
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
local Ellyb = Ellyb(...);

---@class ChatLinkTooltipLines
local ChatLinkTooltipLines, _private = TRP3_API.Ellyb.Class("ChatLinkTooltipLines");

---@param optional title string
function ChatLinkTooltipLines:initialize(title)
	_private[self] = {};

	_private[self].title = title or "";
	_private[self].lines = {};
end

function ChatLinkTooltipLines:SetTitle(title)
	Ellyb.Assertions.isType(title, "string", "title");

	_private[self].title = title;
end

---@param text string
---@param optional color Color
---@param optional size number
function ChatLinkTooltipLines:AddLine(text, color, size)
	Ellyb.Assertions.isType(text, "string", "text");

	if not color then
		color = TRP3_API.Ellyb.ColorManager.WHITE;
	end
	local r, g, b = color:GetRGB();
	tinsert(_private[self].lines, {
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
function ChatLinkTooltipLines:AddDoubleLine(textLeft, textRight, colorLeft, colorRight, size)
	Ellyb.Assertions.isType(textLeft, "string", "textLeft");
	Ellyb.Assertions.isType(textRight, "string", "textRight");

	if not colorLeft then
		colorLeft = TRP3_API.Ellyb.ColorManager.WHITE;
	end
	if not colorRight then
		colorRight = TRP3_API.Ellyb.ColorManager.WHITE;
	end

	local rLeft, gLeft, bLeft = colorLeft:GetRGB();
	local rRight, gRight, bRight = colorRight:GetRGB();
	tinsert(_private[self].lines, {
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
