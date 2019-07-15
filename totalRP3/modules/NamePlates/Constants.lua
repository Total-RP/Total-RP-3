-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local _, TRP3_API = ...;

-- TRP3_API imports.
local L = TRP3_API.loc;
local TRP3_UI = TRP3_API.ui;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Ellyb imports.
local ColorManager = TRP3_API.Ellyb.ColorManager;
local Icon = TRP3_API.Ellyb.Icon;

-- Returns the default OOC indicator style token.
local function GetDefaultOOCIndicatorStyle()
	-- Default to the text style.
	local defaultStyle = NamePlates.OOC_STYLE_TEXT;

	-- If the tooltip style is available as a setting, copy from that.
	if TRP3_Configuration then
		local tooltipStyle = TRP3_Configuration["tooltip_prefere_ooc_icon"];
		if tooltipStyle == "TEXT" or tooltipStyle == "ICON" then
			defaultStyle = tooltipStyle;
		end
	end

	return defaultStyle;
end

-- List of addon names that conflict with this module. If these are enabled
-- for the current character on initialization of this module, we won't
-- set up customizations.
NamePlates.CONFLICTING_ADDONS = {
	-- "AddOn_Name", -- Reason why it's disabled.
};

-- Page ID for the module configuration page.
NamePlates.CONFIG_PAGE_ID = "main_config_uuu_nameplates";

-- Controls if customizations are enabled globally.
NamePlates.CONFIG_ENABLE = "nameplates_enable";
-- Controls if customizations are disabled when out of character.
NamePlates.CONFIG_DISABLE_OUT_OF_CHARACTER = "nameplates_disable_out_of_character";
-- Controls if customizations are disabled when in combat.
NamePlates.CONFIG_DISABLE_IN_COMBAT = "nameplates_disable_in_combat";
-- Controls if requests should be sent out upon seeing new player nameplates.
NamePlates.CONFIG_ACTIVE_QUERY = "nameplates_active_query";
-- Controls if custom player names should be shown.
NamePlates.CONFIG_SHOW_PLAYER_NAMES = "nameplates_show_player_names";
-- Controls if custom oet names should be shown.
NamePlates.CONFIG_SHOW_PET_NAMES = "nameplates_show_pet_names";
-- Controls if custom name colors should be shown.
NamePlates.CONFIG_SHOW_COLORS = "nameplates_show_colors";
-- Controls if custom icons should be shown.
NamePlates.CONFIG_SHOW_ICONS = "nameplates_show_icons";
-- Controls if custom titles should be shown.
NamePlates.CONFIG_SHOW_TITLES = "nameplates_show_titles";
-- Controls if OOC indicators should be shown.
NamePlates.CONFIG_SHOW_OOC_INDICATORS = "nameplates_show_ooc_indicators";
-- Controls the style of OOC indicator to use. See OOC_STYLE_* constants.
NamePlates.CONFIG_OOC_INDICATOR_STYLE = "nameplates_ooc_indicator_style";
-- Controls if glances should be shown.
NamePlates.CONFIG_SHOW_GLANCES = "nameplates_show_glances";

-- Map of configuration keys to their default values. If the value type
-- is a function reference, it is executed when the key is due to be
-- registered.
NamePlates.DEFAULT_CONFIG = {
	[NamePlates.CONFIG_ENABLE]                   = true,
	[NamePlates.CONFIG_DISABLE_OUT_OF_CHARACTER] = false,
	[NamePlates.CONFIG_DISABLE_IN_COMBAT]        = false,
	[NamePlates.CONFIG_ACTIVE_QUERY]             = true,
	[NamePlates.CONFIG_SHOW_PLAYER_NAMES]        = true,
	[NamePlates.CONFIG_SHOW_PET_NAMES]           = true,
	[NamePlates.CONFIG_SHOW_COLORS]              = true,
	[NamePlates.CONFIG_SHOW_ICONS]               = true,
	[NamePlates.CONFIG_SHOW_TITLES]              = true,
	[NamePlates.CONFIG_SHOW_OOC_INDICATORS]      = true,
	[NamePlates.CONFIG_OOC_INDICATOR_STYLE]      = GetDefaultOOCIndicatorStyle,
	[NamePlates.CONFIG_SHOW_GLANCES]             = true,
};

-- Profile type constants. This is a subset of the standard types supported
-- by TRP, as not all types can have decoratable nameplates.
NamePlates.PROFILE_TYPE_CHARACTER = TRP3_UI.misc.TYPE_CHARACTER;
NamePlates.PROFILE_TYPE_PET = TRP3_UI.misc.TYPE_PET;

-- Cooldown between queries for the same profile from nameplate activity
-- alone, in seconds. Defaults to 5 minutes.
--
-- This should be higher than the cooldown imposed by protocols because
-- nameplates are generally more numerous than tooltips or the number of
-- people you can actively mouse-over.
NamePlates.REQUEST_COOLDOWN = 300;

-- OOC indicator style tokens.
NamePlates.OOC_STYLE_ICON = "ICON";
NamePlates.OOC_STYLE_TEXT = "TEXT";

-- OOC indicators for text or icon mode appropriately.
NamePlates.OOC_TEXT_INDICATOR = ColorManager.RED("[" .. L.CM_OOC .. "]");
NamePlates.OOC_ICON_INDICATOR = Icon([[Interface\COMMON\Indicator-Red]], 15);

-- Maximum number of characters for displayed strings before cropping.
NamePlates.MAX_TITLE_CHARS = 45;
NamePlates.MAX_NAME_CHARS = 45;
NamePlates.MAX_GLANCE_TITLE_CHARS = 45;
NamePlates.MAX_GLANCE_TEXT_CHARS = 280;

-- Common color to use for title text in nameplates. Displays need not use
-- this if another color is available; think of this as a default.
NamePlates.TITLE_TEXT_COLOR = ColorManager.ORANGE;

-- Size of custom icons.
NamePlates.ICON_WIDTH = 16;
NamePlates.ICON_HEIGHT = 16;

-- Path prefix for icons.
NamePlates.ICON_PATH = [[Interface\Icons\]];

-- Maximum number of glances to display.
NamePlates.MAX_NUM_GLANCES = 5;

-- Default icon name (without path) and text for empty glances.
NamePlates.DEFAULT_GLANCE_ICON = "INV_Misc_QuestionMark";
NamePlates.DEFAULT_GLANCE_TEXT = "...";
