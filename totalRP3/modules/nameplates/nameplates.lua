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

TRP3_API.module.registerModule({
	["name"] = "Nameplates",
	["description"] = "Customize nameplates",
	["version"] = 0.100,
	["id"] = "trp3_nameplates",
	["minVersion"] = 30,
	["onStart"] = function()

		local Utils = TRP3_API.utils;
		local Events = TRP3_API.events;

		local function customizeNameplate(...)
			local nameplates = C_NamePlate.GetNamePlates(true);
			for _, frame in pairs(nameplates) do
				local namePlateUnitToken = frame.namePlateUnitToken;
				if namePlateUnitToken and UnitIsFriend("player", namePlateUnitToken) and UnitIsPlayer(namePlateUnitToken) then
					frame.UnitFrame:Hide();
					frame.UnitFrame.name:SetAlpha(0);
					frame.UnitFrame.healthBar:SetAlpha(0);
					local unitID = Utils.str.getUnitID(namePlateUnitToken);

					if unitID and TRP3_API.register.isUnitIDKnown(unitID) then
						frame.UnitFrame:Show();
						frame.UnitFrame.name:SetAlpha(1);
						frame.UnitFrame.healthBar:SetAlpha(1);

						local name = TRP3_API.r.name(namePlateUnitToken);

						frame.UnitFrame.name:SetText(name);
						frame.UnitFrame.healthBar:SetWidth(frame.UnitFrame.name:GetStringWidth());
						---@type ColorMixin
						local color = Utils.color.getUnitCustomColor(unitID) or Utils.color.getClassColor(Utils.str.GetClass(namePlateUnitToken));
						if color then
							frame.UnitFrame.name:SetVertexColor(color:GetRGBA());
							--frame.UnitFrame.healthBar:SetStatusBarColor(color:GetRGB());
							frame.UnitFrame.healthBar:SetAlpha(0);
						end
					end
				end
			end
		end

		Utils.event.registerHandler("NAME_PLATE_CREATED", customizeNameplate);
		Utils.event.registerHandler("FORBIDDEN_NAME_PLATE_CREATED", customizeNameplate);
		Utils.event.registerHandler("NAME_PLATE_UNIT_ADDED", customizeNameplate);
		Utils.event.registerHandler("FORBIDDEN_NAME_PLATE_UNIT_ADDED", customizeNameplate);
		Utils.event.registerHandler("NAME_PLATE_UNIT_REMOVED", customizeNameplate);
		Utils.event.registerHandler("FORBIDDEN_NAME_PLATE_UNIT_REMOVED", customizeNameplate);
		Utils.event.registerHandler("PLAYER_TARGET_CHANGED", customizeNameplate);
		Utils.event.registerHandler("DISPLAY_SIZE_CHANGED", customizeNameplate);
		Utils.event.registerHandler("UNIT_AURA", customizeNameplate);
		Utils.event.registerHandler("VARIABLES_LOADED", customizeNameplate);
		Utils.event.registerHandler("CVAR_UPDATE", customizeNameplate);
		Utils.event.registerHandler("RAID_TARGET_UPDATE", customizeNameplate);
		Utils.event.registerHandler("UNIT_FACTION", customizeNameplate);
		Utils.event.registerHandler("PLAYER_TARGET_CHANGED", customizeNameplate);

		TRP3_API.events.listenToEvent(Events.REGISTER_DATA_UPDATED, customizeNameplate);
	end,

});