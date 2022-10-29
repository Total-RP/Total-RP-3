-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local ADDON_NAME = ...;

local function GetDefaultLocale()
	-- GAME_LOCALE is an opt-in variable honored by other localization systems
	-- and may be set by generic "change all addon locale"-style addons and
	-- scripts. We give it higher precedence than the client locale if defined.

	return GAME_LOCALE or GetLocale();
end

local function GetSuggestedLocale()
	local locale;

	if type(TRP3_Configuration) == "table" then
		locale = TRP3_Configuration.AddonLocale;  -- This may be nil.
	end

	if type(locale) ~= "string" then
		locale = GetDefaultLocale();
	end

	return locale;
end

local function OnAddonLoaded(owner, addonName)
	if addonName == ADDON_NAME then
		TRP3_AddonLocale = TRP3_AddonLocale or GetDefaultLocale();
		EventRegistry:UnregisterCallback("ADDON_LOADED", owner);
		EventRegistry:UnregisterFrameEvent("ADDON_LOADED");
	end
end

local function OnAddonsUnloading()
	-- When persisting locales if the suggested one is also the default for the
	-- client we don't store it. This is to accommodate cases where the locale
	-- hasn't been explicitly configured by the user, where we'll instead want
	-- to use the (possibly new) default locale on the following startup.

	local defaultLocale = GetDefaultLocale();
	local suggestedLocale = GetSuggestedLocale();

	if suggestedLocale == defaultLocale then
		TRP3_AddonLocale = nil;
	else
		TRP3_AddonLocale = suggestedLocale;
	end
end

-- In 3.4.1+ we may be able to use RegisterFrameEventAndCallback, and
-- can drop the empty-table 'owner' argument.

EventRegistry:RegisterFrameEvent("ADDON_LOADED");
EventRegistry:RegisterFrameEvent("ADDONS_UNLOADING");
EventRegistry:RegisterCallback("ADDON_LOADED", OnAddonLoaded, {});
EventRegistry:RegisterCallback("ADDONS_UNLOADING", OnAddonsUnloading, {});
