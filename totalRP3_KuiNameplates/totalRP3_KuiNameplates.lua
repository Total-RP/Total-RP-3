--[[
-- Total RP 3 plugin for KuiNameplates by Renaud "Ellypse" Parize,
-- based on the Custom code injector template for Kui_Nameplates_Core
-- By Kesava at curse.com
--]]

local function onModuleStart()
	local Events = TRP3_API.events;
	local Config = TRP3_API.configuration;
	local Utils = TRP3_API.utils;
	local EMPTY = TRP3_API.globals.empty;
	local log = TRP3_API.utils.log.log;

	local addon = KuiNameplates;
	local mod = addon:NewPlugin('Total RP 3: KuiNameplates', 200);


	local getUnitID = Utils.str.getUnitID;
	local unitIDIsKnown = TRP3_API.register.isUnitIDKnown;
	local getUnitFullName = TRP3_API.r.name;
	local getUnitProfile = TRP3_API.register.profileExists;
	local colorHexaToFloats = Utils.color.hexaToFloat;
	local registerConfigKey = Config.registerConfigKey;
	local getConfigValue = Config.getValue;
	local registerHandler = Config.registerHandler;
	local isPlayerIC = TRP3_API.dashboard.isPlayerIC;

	local UnitIsOtherPlayersPet = UnitIsOtherPlayersPet;
	local UnitIsPlayer = UnitIsPlayer;

	local loc = TRP3_API.locale.getText;

	local ENABLE_NAMEPLATES_CUSTOMIZATION = "nameplates_enable";
	local DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER = "nameplates_only_in_character";
	local USE_CUSTOM_COLOR = "nameplates_use_custom_color";
	local SHOW_TITLES = "nameplates_show_titles";
	local HIDE_NON_ROLEPLAY = "nameplates_hide_non_roleplay";
	local PET_NAMES = "nameplates_pet_names";

	---
	-- We cannot hide a specific nameplate, so we're just emptying the text ¯\_(ツ)_/¯
	-- @param nameplate
	--
	function mod:HideNonRoleplayNameplate(nameplate)
		nameplate.state.name = "";
		nameplate.NameText:SetText("");
		nameplate.NameText:Hide();
		nameplate.state.guild_text = "";
		nameplate.GuildText:SetText("")
		nameplate.GuildText:Hide();
	end

	local scanTool = CreateFrame( "GameTooltip", "ScanTooltip", nil, "GameTooltipTemplate" )
	scanTool:SetOwner( WorldFrame, "ANCHOR_NONE" )

	-- TRP3_API.locale.findPetOwner

	local function getPetOwner(petName)
		scanTool:ClearLines()
		scanTool:SetUnit(petName)
		local ownerText = scanText:GetText()
		if not ownerText then return nil end
		local owner, _ = string.split("'",ownerText)

		return owner -- This is the pet's owner
	end

	---
	-- Update the nameplate with informations we get from the Total RP 3 API
	-- @param nameplate
	--
	function mod:UpdateRPName(nameplate)

		-- Only continue if the customization has not be disabled manually and check if we are in character if the option is checked
		if not getConfigValue(ENABLE_NAMEPLATES_CUSTOMIZATION) or (getConfigValue(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER) and not isPlayerIC()) then return end;

		-- If we don't have a unit, we can stop here
		if not nameplate.unit then return end;

		-- Check if the unit is a player)
		if not UnitIsPlayer(nameplate.unit) then
			-- Check if the unit is controlled by a player (it is a pet)
			if getConfigValue(PET_NAMES) and UnitIsOtherPlayersPet(nameplate.unit) then

				-- Try to retrieve the profile of the pet
				local companionFullID = TRP3_API.ui.misc.getCompanionFullID(nameplate.unit, TRP3_API.ui.misc.TYPE_PET);
				local companionProfile = TRP3_API.companions.register.getCompanionProfile(companionFullID);

				-- If we do have a profile we can start filling the nameplate with the data
				if companionProfile then
					local info = companionProfile.data;

					if info.NA then
						nameplate.state.name = info.NA;
						nameplate.NameText:SetText(nameplate.state.name);
					end

					if getConfigValue(USE_CUSTOM_COLOR) and info.NH then
						local r, g, b = colorHexaToFloats(info.NH);
						nameplate.NameText:SetTextColor(r, g, b)
					end

					if getConfigValue(SHOW_TITLES) and info.TI then
						nameplate.state.guild_text = "<" .. info.TI .. ">";
						nameplate.GuildText:SetText(nameplate.state.guild_text)
						nameplate.GuildText:Show();
					end
					return
				end
			end
			if getConfigValue(HIDE_NON_ROLEPLAY) then
				mod:HideNonRoleplayNameplate(nameplate);
			end
			return;
		end

		local unitID = getUnitID(nameplate.unit);

		-- If we didn't get a proper unit ID or we don't have any data for this unit ID we can stop here
		if not unitID or not unitIDIsKnown(unitID) then
			if getConfigValue(HIDE_NON_ROLEPLAY) then
				mod:HideNonRoleplayNameplate(nameplate);
			end
			return
		end;

		local profile = getUnitProfile(unitID);

		-- If we have more information (sometimes we don't have them yet) we continue
		if profile and profile.characteristics then
			nameplate.state.name = TRP3_API.register.getCompleteName(profile.characteristics, getUnitFullName(nameplate.unit), false);
			nameplate.NameText:SetText(nameplate.state.name);

			-- If the profile has a custom color defined for the player name we use it to color the nameplate
			if getConfigValue(USE_CUSTOM_COLOR) and profile.characteristics.CH then
				local r, g, b = colorHexaToFloats(profile.characteristics.CH);
				nameplate.NameText:SetTextColor(r, g, b)
			end

			-- If the profile has a full title defined we use it
			if getConfigValue(SHOW_TITLES) and profile.characteristics and profile.characteristics.FT and profile.characteristics.FT:len() > 0 then
				nameplate.state.guild_text = "<" .. profile.characteristics.FT .. ">";
				nameplate.GuildText:SetText(nameplate.state.guild_text)
				nameplate.GuildText:Show();
			end
		elseif getConfigValue(HIDE_NON_ROLEPLAY) then
			mod:HideNonRoleplayNameplate(nameplate);
		end
	end

	local function refreshAllNameplates()
		for _, nameplate in addon:Frames() do
			if nameplate.unit then
				nameplate:UpdateNameText();
				nameplate.state.guild_text = "";
				nameplate.GuildText:SetText(nameplate.state.guild_text);
				nameplate.GuildText:Hide();
				nameplate:UpdateGuildText();
				mod:UpdateRPName(nameplate);
			end
		end
	end

	mod.RefreshAllNameplates = refreshAllNameplates;

	function mod:Initialise()
		self:RegisterMessage('Create', 'RefreshAllNameplates');
		self:RegisterMessage('Show', 'UpdateRPName');
		self:RegisterMessage('GainedTarget', 'UpdateRPName');
		self:RegisterMessage('LostTarget', 'UpdateRPName');
	end

	local TRP3_KUINAMEPLATES_LOCALE = {};

	TRP3_KUINAMEPLATES_LOCALE["enUS"] = {
		KNP_MODULE = "Kui|cff9966ffNameplates|r module",
		KNP_ENABLE_CUSTOMIZATION = "Enable nameplates customizations",
		KNP_ONLY_IC = "Only when in character",
		KNP_HIDE_NON_RP = "Hide non-roleplay nameplates",
		KNP_HIDE_NON_RP_TT = [[Hide nameplates of players who do not have a roleplay profile, so you only see the names of people with a RP profile.

Note: If you have enabled the option ot only enable nameplate customisation when you are In Character, you can quickly switch the Out Of Character to see everyone's name!]],
		KNP_CUSTOM_COLORS = "Use custom colors",
		KNP_CUSTOM_TITLES = "Show custom titles",
		KNP_CUSTOM_TITLES_TT = "Replace the guild text by the RP title of the player. Be aware that custom titles may be really long and take a lot of space.",
		KNP_PET_NAMES = "Pet names"
	}

	TRP3_KUINAMEPLATES_LOCALE["frFR"] = {
		KNP_MODULE = "Module pour Kui|cff9966ffNameplates|r",
		KNP_ENABLE_CUSTOMIZATION = "Activer les modifications des barres d'infos",
		KNP_ONLY_IC = "Seulement quand je suis \"Dans le personnage\"",
		KNP_HIDE_NON_RP = "Cacher les noms des joueurs non RP",
		KNP_HIDE_NON_RP_TT = [[Cacher les barres d'infos des joueurs n'ayant pas de profil roleplay, pour ne voir plus que les noms des joueurs avec un profile RP.

Note: Si vous avez activé l'option de modifier les barres d'infos uniquement lorsque vous êtes "dans le personnage", vous pouvez passer de "dans le personnage" à "hors du personnage" pour afficher toutes les barres d'infos à nouveau!]],
		KNP_CUSTOM_COLORS = "Utiliser les couleurs personnalisées",
		KNP_CUSTOM_TITLES = "Afficher les titres personnalisés",
		KNP_CUSTOM_TITLES_TT = [[Remplace la ligne du texte de guilde par le titre RP du joueur. Attention, certains titres peuvent être très long et prendre beaucoup de place]],
		KNP_PET_NAMES = "Nom des familiers"
	}

	-- Register locales
	for localeID, localeStructure in pairs(TRP3_KUINAMEPLATES_LOCALE) do
		local locale = TRP3_API.locale.getLocale(localeID);
		for localeKey, text in pairs(localeStructure) do
			locale.localeContent[localeKey] = text;
		end
	end

	-- We listen to the register data update event fired by Total RP 3 when we receive new data
	-- about a player.
	-- It's not super efficient, but we will refresh all RP names on all nameplates for now
	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, refreshAllNameplates);

	registerConfigKey(ENABLE_NAMEPLATES_CUSTOMIZATION, true);
	registerConfigKey(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER, true);
	registerConfigKey(HIDE_NON_ROLEPLAY, false);
	registerConfigKey(USE_CUSTOM_COLOR, true);
	registerConfigKey(PET_NAMES, true);
	registerConfigKey(SHOW_TITLES, false);

	registerHandler(ENABLE_NAMEPLATES_CUSTOMIZATION, refreshAllNameplates);
	registerHandler(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER, refreshAllNameplates);
	registerHandler(HIDE_NON_ROLEPLAY, refreshAllNameplates);
	registerHandler(USE_CUSTOM_COLOR, refreshAllNameplates);
	registerHandler(SHOW_TITLES, refreshAllNameplates);
	registerHandler(PET_NAMES, refreshAllNameplates);

	-- Build configuration page
	TRP3_API.configuration.registerConfigurationPage({
		id = "main_config_nameplates",
		menuText = "Kui|cff9966ffNameplates|r",
		pageText = loc("KNP_MODULE"),
		elements = {
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("KNP_ENABLE_CUSTOMIZATION"),
				configKey = ENABLE_NAMEPLATES_CUSTOMIZATION
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("KNP_PET_NAMES"),
				configKey = PET_NAMES
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("KNP_ONLY_IC"),
				configKey = DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("KNP_HIDE_NON_RP"),
				configKey = HIDE_NON_ROLEPLAY,
				help = loc("KNP_HIDE_NON_RP_TT")
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("KNP_CUSTOM_COLORS"),
				configKey = USE_CUSTOM_COLOR
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("KNP_CUSTOM_TITLES"),
				configKey = SHOW_TITLES,
				help = loc("KNP_CUSTOM_TITLES_TT")
			},
		}
	});
end

local MODULE_STRUCTURE = {
	["name"] = "Kui|cff9966ffNameplates|r module",
	["description"] = "Add Total RP 3 customizations to Kui|cff9966ffNameplates|r.",
	["version"] = 1.100,
	["id"] = "trp3_kuinameplates",
	["onStart"] = onModuleStart,
	["minVersion"] = 24,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
