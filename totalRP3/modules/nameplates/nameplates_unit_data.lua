----------------------------------------------------------------------------------
---    Total RP 3
---    Nameplates unit data
---    ---------------------------------------------------------------------------
---    Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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
-------------------------------------------------------------------------------------


---@class TRP3_NameplatesUnitData
local NameplatesUnitData = {};
TRP3_API.nameplates.unitData = NameplatesUnitData;

function NameplatesUnitData.init()
	
	local getUnitCustomColor = TRP3_API.utils.color.getUnitCustomColor;
	local getPlayerName = TRP3_API.r.name;
	local GetClass = TRP3_API.utils.str.GetClass;
	local getClassColor = TRP3_API.utils.color.getClassColor;
	local isUnitIDKnown= TRP3_API.register.isUnitIDKnown;
	local getUnitProfile = TRP3_API.register.profileExists;
	
	function NameplatesUnitData.getPlayerData(namePlateUnitToken, unitID)
		
		local name, color, title, icon, glances;
		
		local playerHasRPProfile = isUnitIDKnown(unitID);
		
		if playerHasRPProfile then
			local profile = getUnitProfile(unitID);
			
			if profile and profile.characteristics then
				title = profile.characteristics.FT;
				icon = profile.characteristics.IC;
			end
			
			name = getPlayerName(namePlateUnitToken);
			color = getUnitCustomColor(unitID) or getClassColor(GetClass(namePlateUnitToken));
			
			if profile and profile.misc then
				glances = profile.misc.PE;
			end
		end
		
		return playerHasRPProfile, name, color, title, icon, glances;
	end
	
	local getCompanionFullID = TRP3_API.ui.misc.getCompanionFullID;
	local getCompanionProfile = TRP3_API.companions.register.getCompanionProfile;
	local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
	local getColorFromHexa = TRP3_API.utils.color.getColorFromHexadecimalCode;
	
	function NameplatesUnitData.getCompanionData(companionUnitID, nameplate)
		-- Try to retrieve the profile of the pet
		local companionFullID = getCompanionFullID(companionUnitID, TYPE_PET);
		local companionProfile = getCompanionProfile(companionFullID);
		
		local companionHasProfile = companionProfile ~= nil;
		local name, title, color, icon, glances;
		
		if companionHasProfile then
			local info = companionProfile.data or {};
			
			name = info.NA;
			title = info.TI;
			if info.NH then
				color = getColorFromHexa(info.NH);
			end
			icon = info.IC;
			glances = companionProfile.PE;
		end
		
		return companionHasProfile, name, color, title, icon, glances;
	end

end