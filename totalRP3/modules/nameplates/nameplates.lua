----------------------------------------------------------------------------------
--- Total RP 3
--- Nameplates customizations
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
----------------------------------------------------------------------------------

TRP3_API.nameplates = {};

TRP3_API.module.registerModule({
	["name"] = "Nameplates",
	["description"] = "Customize nameplates",
	["version"] = 0.100,
	["id"] = "trp3_nameplates",
	["minVersion"] = 30,
	["onStart"] = function()
		
		---@type TRP3_NameplatesDecorator
		local NameplatesDecorator = TRP3_API.nameplates.decorator;
		---@type TRP3_NameplatesConfig
		local NameplatesConfig = TRP3_API.nameplates.config;
		---@type TRP3_NameplatesUnitData
		local NameplatesUnitData = TRP3_API.nameplates.unitData;
		---@type TRP3_NameplatesEvents
		local NameplatesEvents = TRP3_API.nameplates.events;

		local UnitIsPlayer = UnitIsPlayer;
		local UnitIsFriend = UnitIsFriend;
		local UnitIsUnit = UnitIsUnit;
		local UnitIsOtherPlayersPet = UnitIsOtherPlayersPet;

		local GetNamePlates = C_NamePlate.GetNamePlates;

		local pairs = pairs;
		local Utils = TRP3_API.utils;
		local Config = TRP3_API.configuration;
		local getUnitID = Utils.str.getUnitID
		local getConfigValue = Config.getValue;
		local isPlayerIC = TRP3_API.dashboard.isPlayerIC;
		

		local function customizeNameplate(nameplate)

			local namePlateUnitToken = nameplate.namePlateUnitToken;
			
			NameplatesDecorator.removeDecorations(nameplate);

			-- Stop right here and do not do any customizations to the nameplates if:
			if not namePlateUnitToken or -- Nameplate token is nil (¯\_(ツ)_/¯)
			not getConfigValue(NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION) or 							-- Nameplates customizations are disabled
			(getConfigValue(NameplatesConfig.configKeys.DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER) and not isPlayerIC()) or	-- Nameplates are disable when OOC
			UnitIsUnit(namePlateUnitToken, "player") or 								-- Nameplate is player self naemplate
			not UnitIsFriend("player", namePlateUnitToken) or 							-- Nameplate is not friendly nameplate
			( not UnitIsPlayer(namePlateUnitToken) and
			  not UnitIsOtherPlayersPet(namePlateUnitToken) ) then 							-- Nameplate is not player nameplate
				return NameplatesDecorator.restore(nameplate);
			end
			
			local unitID = getUnitID(namePlateUnitToken);
			local unitHasAnRPProfile, name, color, title, icon, glances;
			
			-- If unit is pet
			if UnitIsOtherPlayersPet(namePlateUnitToken) then
				unitHasAnRPProfile, name, color, title, icon, glances = NameplatesUnitData.getCompanionData(namePlateUnitToken, unitID);
			-- If unit is player
			elseif unitID then
				unitHasAnRPProfile, name, color, title, icon, glances = NameplatesUnitData.getPlayerData(namePlateUnitToken, unitID)
			end
			
			NameplatesDecorator.decorate(nameplate, unitHasAnRPProfile, name, color, title, icon, glances)
		end

		function TRP3_API.nameplates.refresh()
			for _, nameplate in pairs(GetNamePlates()) do
				customizeNameplate(nameplate);
			end
		end
		
		NameplatesConfig.init();
		NameplatesDecorator.init();
		NameplatesUnitData.init();
		NameplatesEvents.init();
		
	end,

});