--[[
-- Total RP 3 plugin for KuiNameplates by Renaud "Ellypse" Parize,
-- based on the Custom code injector template for Kui_Nameplates_Core
-- By Kesava at curse.com
--]]

local function onModuleStart()
    local Events = TRP3_API.events;
    local Config = TRP3_API.configuration;
    local Utils = TRP3_API.utils;

    local addon = KuiNameplates;
    local mod = addon:NewPlugin('Total RP 3: KuiNameplates', 200);

    local UnitIsPlayer = UnitIsPlayer;
    local getUnitID = Utils.str.getUnitID;
    local unitIDIsKnown = TRP3_API.register.isUnitIDKnown;
    local getUnitFullName = TRP3_API.r.name;
    local getUnitProfile = TRP3_API.register.profileExists;
    local colorHexaToFloats = Utils.color.hexaToFloat;
    local registerConfigKey = Config.registerConfigKey;
    local getConfigValue = Config.getValue;
    local registerHandler = Config.registerHandler;
    local isPlayerIC = TRP3_API.dashboard.isPlayerIC;

    local loc = TRP3_API.locale.getText;

    local ENABLE_NAMEPLATES_CUSTOMIZATION = "nameplates_enable";
    local DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER = "nameplates_only_in_character";
    local USE_CUSTOM_COLOR = "nameplates_use_custom_color";
    local SHOW_TITLES = "nameplates_show_titles";


    ---
    -- Update the nameplate with informations we get from the Total RP 3 API
    -- @param nameplate
    --
    function mod:UpdateRPName(nameplate)

        -- Only continue if the customization has not be disabled manually and check if we are in character if the option is checked
        if not getConfigValue(ENABLE_NAMEPLATES_CUSTOMIZATION) or (getConfigValue(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER) and not isPlayerIC()) then return end;

        -- If we don't have a unit or it is not a player, we can stop here
        if not nameplate.unit or not UnitIsPlayer(nameplate.unit) then return end;

        local unitID = getUnitID(nameplate.unit);

        -- If we didn't get a proper unit ID or we don't have any data for this unit ID we can stop here
        if not unitID or not unitIDIsKnown(unitID) then return end;

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
        end
    end

    function mod:Initialise()
        self:RegisterMessage('Show', 'UpdateRPName');
        self:RegisterMessage('GainedTarget', 'UpdateRPName');
        self:RegisterMessage('LostTarget', 'UpdateRPName');
    end

    local function refreshAllNameplates()
        for _, nameplate in addon:Frames() do
            if nameplate.unit then
                nameplate:UpdateNameText();
                nameplate:UpdateGuildText();
                mod:UpdateRPName(nameplate);
            end
        end
    end

    local TRP3_KUINAMEPLATES_LOCALE = {};

    TRP3_KUINAMEPLATES_LOCALE["enUS"] = {
        KNP_MODULE = "KuiNameplates module",
        KNP_ENABLE_CUSTOMIZATION = "Enable nameplates customizations",
        KNP_ONLY_IC = "Only when in character",
        KNP_CUSTOM_COLORS = "Use custom colors",
        KNP_CUSTOM_TITLES = "Show custom titles",
        KNP_CUSTOM_TITLES_TT = "Be aware that custom titles may be really long and take a lot of space. This options needs the nameplates to be hidden and re-shown once to work."
    }

    TRP3_KUINAMEPLATES_LOCALE["frFR"] = {
        KNP_MODULE = "Module pour KuiNameplates",
        KNP_ENABLE_CUSTOMIZATION = "Activer les modifications des barres d'infos",
        KNP_ONLY_IC = "Seulement quand je suis \"Dans le personnage\"",
        KNP_CUSTOM_COLORS = "Utiliser les couleurs personnalisées",
        KNP_CUSTOM_TITLES = "Afficher les titres personnalisés",
        KNP_CUSTOM_TITLES_TT = "Attention, certains titres peuvent être très long et prendre beaucoup de place. Pour que les changements soient appliqués les barres d'infos doivent être cachées puis ré-affichées au moins une fois."
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
    registerConfigKey(USE_CUSTOM_COLOR, true);
    registerConfigKey(SHOW_TITLES, false);

    registerHandler(ENABLE_NAMEPLATES_CUSTOMIZATION, refreshAllNameplates);
    registerHandler(DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER, refreshAllNameplates);
    registerHandler(USE_CUSTOM_COLOR, refreshAllNameplates);
    registerHandler(SHOW_TITLES, refreshAllNameplates);

    -- Build configuration page
    TRP3_API.configuration.registerConfigurationPage({
        id = "main_config_nameplates",
        menuText = "KuiNameplates",
        pageText = loc("KNP_MODULE"),
        elements = {
            {
                inherit = "TRP3_ConfigCheck",
                title = loc("KNP_ENABLE_CUSTOMIZATION"),
                configKey = ENABLE_NAMEPLATES_CUSTOMIZATION
            },
            {
                inherit = "TRP3_ConfigCheck",
                title = loc("KNP_ONLY_IC"),
                configKey = DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER
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
    ["name"] = "KuiNameplates module",
    ["description"] = "Add Total RP 3 customizations to Kui|cff9966ffNameplates|r.",
    ["version"] = 1.000,
    ["id"] = "trp3_kuinameplates",
    ["onStart"] = onModuleStart,
    ["minVersion"] = 24,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
