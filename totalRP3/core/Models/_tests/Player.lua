----------------------------------------------------------------------------------
--- Total RP 3
--- Player model tests
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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


if not WoWUnit then
	return
end

local Tests = WoWUnit("TRP3:E Character Operands", "PLAYER_ENTERING_WORLD");
local Player = AddOn_TotalRP3.Player;
local Enums = AddOn_TotalRP3.Enums;

--region Regular player tests
function Tests:GetAccountTypeFromCharacterInfo()
	-- Given
	WoWUnit.Replace(TRP3_API.register, "getUnitIDCharacter", function()
		return { isTrial = AddOn_TotalRP3.Enums.ACCOUNT_TYPE.VETERAN }
	end)
	-- When
	local player = Player.CreateFromCharacterID("any");
	-- Then
	WoWUnit.AreEqual(Enums.ACCOUNT_TYPE.VETERAN, player:GetAccountType());
end

function Tests:CheckIfPlayerIsOnTrialAccountFromCharacterInfo()
	local player;
	-- Given
	WoWUnit.Replace(TRP3_API.register, "getUnitIDCharacter", function()
		return { isTrial = AddOn_TotalRP3.Enums.ACCOUNT_TYPE.VETERAN }
	end)
	-- When
	player = Player.CreateFromCharacterID("any");
	-- Then
	WoWUnit.IsTrue(player:IsOnATrialAccount());

	-- Given
	WoWUnit.Replace(TRP3_API.register, "getUnitIDCharacter", function()
		return { isTrial = AddOn_TotalRP3.Enums.ACCOUNT_TYPE.TRIAL }
	end)
	-- When
	player = Player.CreateFromCharacterID("any");
	-- Then
	WoWUnit.IsTrue(player:IsOnATrialAccount());

	-- Given
	WoWUnit.Replace(TRP3_API.register, "getUnitIDCharacter", function()
		return { isTrial = AddOn_TotalRP3.Enums.ACCOUNT_TYPE.REGULAR }
	end)
	-- When
	player = Player.CreateFromCharacterID("any");
	-- Then
	WoWUnit.IsFalse(player:IsOnATrialAccount());

	-- Backward compatibility check

	-- Given
	WoWUnit.Replace(TRP3_API.register, "getUnitIDCharacter", function()
		return { isTrial = true }
	end)
	-- When
	player = Player.CreateFromCharacterID("any");
	-- Then
	WoWUnit.IsTrue(player:IsOnATrialAccount());

	-- Given
	WoWUnit.Replace(TRP3_API.register, "getUnitIDCharacter", function()
		return { isTrial = false }
	end)
	-- When
	player = Player.CreateFromCharacterID("any");
	-- Then
	WoWUnit.IsFalse(player:IsOnATrialAccount());
end
--endregion

--region Current player tests
function Tests:GetAccountTypeFromGameClient()
	local player;

	-- Given
	WoWUnit.Replace("IsTrialAccount", function()
		return true
	end)
	-- When
	player = Player.GetCurrentUser();
	-- Then
	WoWUnit.AreEqual(Enums.ACCOUNT_TYPE.TRIAL, player:GetAccountType())

	-- Given
	WoWUnit.Replace("IsTrialAccount", function()
		return false
	end)
	WoWUnit.Replace("IsVeteranTrialAccount", function()
		return true
	end)
	-- When
	player = Player.GetCurrentUser();
	-- Then
	WoWUnit.AreEqual(Enums.ACCOUNT_TYPE.VETERAN, player:GetAccountType())

	-- Given
	WoWUnit.Replace("IsTrialAccount", function()
		return false
	end)
	WoWUnit.Replace("IsVeteranTrialAccount", function()
		return false
	end)
	-- When
	player = Player.GetCurrentUser();
	-- Then
	WoWUnit.AreEqual(Enums.ACCOUNT_TYPE.REGULAR, player:GetAccountType())

end
--endregion

WoWUnit:Show()
