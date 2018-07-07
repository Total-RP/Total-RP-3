----------------------------------------------------------------------------------
--- Total RP 3
--- Workarounds
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

local Workarounds = {};
TRP3_API.Workarounds = Workarounds ;

local workaroundsToApply = {};

-- Workaround for 7.2.5 issue with debuff on friendly nameplates in dungeons that would forever forbid the GameTooltip
-- from being accessible from add-ons.
-- I do not like to override CVar for the user and impose options, but there is no way around it as we need to use
-- the GameTooltip and Blizzard is giving us no choice. This situation is a fucking sad joke.
-- See https://www.wowace.com/projects/libactionbutton-1-0/issues/23
table.insert(workaroundsToApply, function()
	local IsInInstance = IsInInstance;
	local InCombatLockdown = InCombatLockdown;
	local SetCVar = SetCVar;
	local GetCVar = GetCVar;
	local previousUserSetting = GetCVar("nameplateShowDebuffsOnFriendly");

	local function fix(value)
		SetCVar("nameplateShowDebuffsOnFriendly", value)
	end

	-- To make sure the user never turns that option on again, we hook SetCVar and check if someone is trying to turn that on
	hooksecurefunc("SetCVar", function(cvarName, value)
		if InCombatLockdown() then return end
		if cvarName == "nameplateShowDebuffsOnFriendly" and value == 1 and IsInInstance() then
			fix(0)
		end
	end)

	TRP3_API.Ellyb.GameEvents.registerCallback("PLAYER_ENTERING_WORLD", function()
		if InCombatLockdown() then return end
		if IsInInstance() and GetCVar("nameplateShowDebuffsOnFriendly") == 1 then
			previousUserSetting = 1
			-- Set the nameplateShowDebuffsOnFriendly to false, never show debuff on friendly nameplates
			fix(0)
		else
			fix(previousUserSetting)
		end
	end)
end)

function Workarounds.applyWorkarounds()
	for _, workaround in pairs(workaroundsToApply) do
		workaround();
	end
end


Workarounds.applyWorkarounds();