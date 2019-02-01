----------------------------------------------------------------------------------
--- Total RP 3
--- HTML Mixin
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---  Licensed under the Apache License, Version 2.0 (the "License");
---  you may not use this file except in compliance with the License.
---  You may obtain a copy of the License at
---
---    http://www.apache.org/licenses/LICENSE-2.0
---
---  Unless required by applicable law or agreed to in writing, software
---  distributed under the License is distributed on an "AS IS" BASIS,
---  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---  See the License for the specific language governing permissions and
---  limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

TRP3_HyperLinkedMixin = {};

function TRP3_HyperLinkedMixin:OnHyperlinkClick(url)
	TRP3_API.Ellyb.Popups:OpenURL(url, TRP3_API.loc.UI_LINK_WARNING);
end

function TRP3_HyperLinkedMixin:OnHyperlinkEnter(link, text)
	TRP3_MainTooltip:Hide();
	TRP3_MainTooltip:SetOwner(self, "ANCHOR_CURSOR");
	TRP3_MainTooltip:AddLine(text, 1, 1, 1, true);
	TRP3_MainTooltip:AddLine(link, 1, 1, 1, true);
	TRP3_MainTooltip:Show();
end

function TRP3_HyperLinkedMixin:OnHyperlinkLeave()
	TRP3_MainTooltip:Hide();
end
