----------------------------------------------------------------------------------
--- List of Ellypse's patreon supporters
---
--- This file was made to be used in several different add-ons.
--- ---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---  http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

if ELLYPSE_PATREON_SUPPORTERS then return end

-- Lua imports
local sort = sort;
local pairs = pairs;

---@type ColorMixin
local PURPLE = CreateColor(0.5, 0, 1);

local GOLDEN_SUPPORTERS = {
	"Bas(AstaLawl)",
	"Connor Macleod",
	"Vlad",
	"Mooncubus",
}

local PATREON_SUPPORTERS = {
	"Nikradical",
	"Solanya",
	"Ripperley",
	"Keyboardturner",
	"Petr Cihelka",
}

sort(GOLDEN_SUPPORTERS);
sort(PATREON_SUPPORTERS);

local LINE_FORMAT = "- %s\n";

local patreonMessage = "";
for _, patreonSupporter in pairs(GOLDEN_SUPPORTERS) do
	patreonMessage = patreonMessage .. LINE_FORMAT:format(PURPLE:WrapTextInColorCode(patreonSupporter));
end
patreonMessage = patreonMessage .. "\n";
for _, patreonSupporter in pairs(PATREON_SUPPORTERS) do
	patreonMessage = patreonMessage .. LINE_FORMAT:format(patreonSupporter);
end

ELLYPSE_PATREON_SUPPORTERS = patreonMessage;