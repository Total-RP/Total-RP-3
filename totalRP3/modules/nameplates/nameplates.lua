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

		local GetUnitName = GetUnitName;
		local UnitIsPlayer = UnitIsPlayer;
		local UnitIsFriend = UnitIsFriend;
		local UnitSelectionColor = UnitSelectionColor;

		local Utils = TRP3_API.utils;
		local Events = TRP3_API.events;
		local Config = TRP3_API.configuration;
		local loc = TRP3_API.locale.getText;

		local registerConfigKey = Config.registerConfigKey;
		local getConfigValue = Config.getValue;
		local registerHandler = Config.registerHandler;
		local isPlayerIC = TRP3_API.dashboard.isPlayerIC;

		local ENABLE_NAMEPLATES_CUSTOMIZATION = "nameplates_enable";
		local DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER = "nameplates_only_in_character";
		local HIDE_HEALTH_BARS = "nameplates_hide_healthbars";
		local USE_CUSTOM_COLOR = "nameplates_use_custom_color";
		local SHOW_TITLES = "nameplates_show_titles";
		local HIDE_NON_ROLEPLAY = "nameplates_hide_non_roleplay";
		local PET_NAMES = "nameplates_pet_names";

		local function restoreNameplate(nameplate)
			local name = GetUnitName(nameplate.UnitFrame.unit, true);
			nameplate.UnitFrame.name:SetText(name);
			nameplate.UnitFrame.name:SetVertexColor(UnitSelectionColor(nameplate.UnitFrame.unit, nameplate.UnitFrame.optionTable.colorNameWithExtendedColors));
			nameplate.UnitFrame.name:SetAlpha(1);
			nameplate.UnitFrame.healthBar:SetAlpha(1);
		end

		local function customizeNameplate(nameplate)

			local namePlateUnitToken = nameplate.namePlateUnitToken;
			if not namePlateUnitToken or not UnitIsFriend("player", namePlateUnitToken) or not UnitIsPlayer(namePlateUnitToken) then
				return
			end

			if not getConfigValue(ENABLE_NAMEPLATES_CUSTOMIZATION) then
				return restoreNameplate(nameplate);
			end

			if getConfigValue(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER) and not isPlayerIC() then
				return restoreNameplate(nameplate);
			end

			if getConfigValue(HIDE_NON_ROLEPLAY) then
				nameplate.UnitFrame.name:SetAlpha(0);
			else
				nameplate.UnitFrame.name:SetAlpha(1);
			end

			if getConfigValue(HIDE_HEALTH_BARS) then
				nameplate.UnitFrame.healthBar:SetAlpha(0);
			else
				nameplate.UnitFrame.healthBar:SetAlpha(1);
			end

			local unitID = Utils.str.getUnitID(namePlateUnitToken);

			if unitID and TRP3_API.register.isUnitIDKnown(unitID) then

				nameplate.UnitFrame.name:SetAlpha(1);

				local name = TRP3_API.r.name(namePlateUnitToken);

				nameplate.UnitFrame.name:SetText(name);

				--nameplate.UnitFrame.healthBar:SetWidth(nameplate.UnitFrame.name:GetStringWidth());
				if getConfigValue(USE_CUSTOM_COLOR) then
					---@type ColorMixin
					local color = Utils.color.getUnitCustomColor(unitID) or Utils.color.getClassColor(Utils.str.GetClass(namePlateUnitToken));
					if color then
						nameplate.UnitFrame.name:SetVertexColor(color:GetRGBA());
					end
				else
					nameplate.UnitFrame.name:SetVertexColor(UnitSelectionColor(nameplate.UnitFrame.unit, nameplate.UnitFrame.optionTable.colorNameWithExtendedColors));
				end

			end
		end

		local function refreshAllNameplates()
			for _, nameplate in pairs(C_NamePlate.GetNamePlates(true)) do
				customizeNameplate(nameplate);
			end
		end

		Utils.event.registerHandler("NAME_PLATE_CREATED", refreshAllNameplates);
		Utils.event.registerHandler("NAME_PLATE_UNIT_ADDED", refreshAllNameplates);
		Utils.event.registerHandler("NAME_PLATE_UNIT_REMOVED", refreshAllNameplates);
		Utils.event.registerHandler("PLAYER_TARGET_CHANGED", refreshAllNameplates);
		Utils.event.registerHandler("DISPLAY_SIZE_CHANGED", refreshAllNameplates);
		Utils.event.registerHandler("VARIABLES_LOADED", refreshAllNameplates);
		Utils.event.registerHandler("CVAR_UPDATE", refreshAllNameplates);
		Utils.event.registerHandler("RAID_TARGET_UPDATE", refreshAllNameplates);
		Utils.event.registerHandler("UNIT_FACTION", refreshAllNameplates);
		TRP3_API.events.listenToEvent(Events.REGISTER_DATA_UPDATED, refreshAllNameplates);

		registerConfigKey(ENABLE_NAMEPLATES_CUSTOMIZATION, true);
		registerConfigKey(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER, true);
		registerConfigKey(HIDE_HEALTH_BARS, true);
		registerConfigKey(HIDE_NON_ROLEPLAY, false);
		registerConfigKey(USE_CUSTOM_COLOR, true);
		registerConfigKey(PET_NAMES, true);
		registerConfigKey(SHOW_TITLES, false);

		registerHandler(ENABLE_NAMEPLATES_CUSTOMIZATION, refreshAllNameplates);
		registerHandler(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER, refreshAllNameplates);
		registerHandler(HIDE_HEALTH_BARS, refreshAllNameplates);
		registerHandler(HIDE_NON_ROLEPLAY, refreshAllNameplates);
		registerHandler(USE_CUSTOM_COLOR, refreshAllNameplates);
		registerHandler(SHOW_TITLES, refreshAllNameplates);
		registerHandler(PET_NAMES, refreshAllNameplates);

		-- Build configuration page
		TRP3_API.configuration.registerConfigurationPage(
		{
			id = "main_config_trp3_nameplates",
			menuText = loc("NAMEPLATE_CONFIG_MENU"),
			pageText = loc("NAMEPLATE_CONFIG_TITLE"),
			elements = {
				{
					inherit = "TRP3_ConfigCheck",
					title = loc("NAMEPLATE_ENABLE_CUSTOMIZATIONS"),
					help = loc("NAMEPLATE_CUSTOMIZATIONS_TT"),
					configKey = ENABLE_NAMEPLATES_CUSTOMIZATION
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = loc("NAMEPLATE_CUSTOM_COLORS"),
					help = loc("NAMEPLATE_CUSTOM_COLORS_TT"),
					configKey = USE_CUSTOM_COLOR,
					dependentOnOptions = {ENABLE_NAMEPLATES_CUSTOMIZATION},
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = loc("NAMEPLATE_HIDE_HEALTHBARS"),
					help = loc("NAMEPLATE_HIDE_HEALTHBARS_TT"),
					configKey = HIDE_HEALTH_BARS,
					dependentOnOptions = {ENABLE_NAMEPLATES_CUSTOMIZATION},
				},
				--{
				--	inherit   = "TRP3_ConfigCheck",
				--	title     = loc("KNP_PET_NAMES"),
				--	configKey = PET_NAMES
				--},
				{
					inherit = "TRP3_ConfigCheck",
					title = loc("NAMEPLATE_ONLY_IN_CHARACTER"),
					help = loc("NAMEPLATE_ONLY_IN_CHARACTER_TT"),
					configKey = DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER,
					dependentOnOptions = {ENABLE_NAMEPLATES_CUSTOMIZATION},
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = loc("NAMEPLATE_HIDE_NON_RP"),
					help = loc("NAMEPLATE_HIDE_NON_RP_TT"),
					configKey = HIDE_NON_ROLEPLAY,
					dependentOnOptions = {ENABLE_NAMEPLATES_CUSTOMIZATION},
				},
			}
		});

	end,

});