--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

assert(TRP3_API, "Unable to find TRP3.");

local loc = TRP3_API.locale.getText;
local getDefaultLocaleStructure = TRP3_API.locale.getDefaultLocaleStructure;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local registerMenu = TRP3_API.navigation.menu.registerMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local table, pairs, tinsert = table, pairs, tinsert;

-- Frame placeholder
local frames = {};
local keys = {};

local function injectLocale()
	local locale = TRP3_API.locale.getEffectiveLocale();
	-- default locale ("enUS")
	locale.LOCALIZATOR_MENU = "Localizator";
	locale.LOCALIZATOR_EXPLAIN = 
			"Here you can translate all of the Total RP 3 texts. You can test your translation by choosing the Custom language in the General settings.\n\n"
			.."\\n = Line break\n||cff###### = Color tag.\n||r = Color reset.\n%s = String insertion.";
	locale.LOCALIZATOR_RESET = "Reset";
	locale.LOCALIZATOR_RESET_TT = "This action will reset your custom localization to the default one (enUS).\n\n|cffff0000There is no coming back !|r\n\nConfirm ?";
	locale.LOCALIZATOR_APPLY = "Apply";
	locale.LOCALIZATOR_APPLY_TT = "This action will reload the UI in order to take your localization changes into account.\n\n|cff00ff00Don't forget to select the custom language in the General settings !";
	locale.LOCALIZATOR_TEXT = "Text %s : %s";
end

local function escapeText(text)
	return text:gsub("|", "||");
end

local function unescapeText(text)
	return text:gsub("||", "|");
end

local function onInit()
	if not TRP3_API.locale.getTextocalizator then
		TRP3_API.locale.getTextocalizator = {};
	end
	for key, value in pairs(getDefaultLocaleStructure().localeContent) do
		if not TRP3_API.locale.getTextocalizator[key] then
			TRP3_API.locale.getTextocalizator[key] = value;
		end
	end
	local CUSTOM_LOCALE = {
		locale = "custom",
		localeText = "Custom",
		localeContent = TRP3_API.locale.getTextocalizator,
	};
	TRP3_API.locale.registerLocale(CUSTOM_LOCALE);
end

local function decorateBox(widget, index)
	local locale = getDefaultLocaleStructure().localeContent;
	local key = keys[index];
	_G[widget:GetName().."ScrollText"].key = key;
	_G[widget:GetName().."ScrollText"]:SetText(escapeText(TRP3_API.locale.getTextocalizator[key] or locale[key]));
	_G[widget:GetName().."Text"]:SetText(loc("LOCALIZATOR_TEXT"):format(index, key));
end

local function onTextChanged(self)
	local unescapedText = unescapeText(self:GetText());
	if self.key and TRP3_API.locale.getTextocalizator[self.key] ~= unescapedText then
		TRP3_API.locale.getTextocalizator[self.key] = unescapedText;
	end
end

local function reset()
	TRP3_API.popup.showConfirmPopup(loc("LOCALIZATOR_RESET_TT"), function() 
		TRP3_API.locale.getTextocalizator = nil;
		ReloadUI();
	end);
end

local function apply()
	ReloadUI();
end

local function onLoaded()
	injectLocale();
	
	TRP3_ConfigurationLocalizatorReset:SetScript("OnClick", reset);
	TRP3_ConfigurationLocalizatorReset:SetText(loc("LOCALIZATOR_RESET"));
	TRP3_ConfigurationLocalizatorApply:SetScript("OnClick", apply);
	TRP3_ConfigurationLocalizatorApply:SetText(loc("LOCALIZATOR_APPLY"));
	setTooltipForSameFrame(TRP3_ConfigurationLocalizatorApply, "TOP", 0, 5, loc("LOCALIZATOR_APPLY"), loc("LOCALIZATOR_APPLY_TT"));
	setTooltipForSameFrame(TRP3_ConfigurationLocalizatorReset, "TOP", 0, 5, loc("LOCALIZATOR_RESET"), loc("LOCALIZATOR_RESET_TT"));
	
	registerPage({
		id = "main_config_localizator",
		templateName = "TRP3_ConfigurationLocalizator",
		frameName = "TRP3_ConfigurationLocalizator",
		frame = TRP3_ConfigurationLocalizator,
	});
	registerMenu({
		id = "main_9z_config_gen",
		text = loc("LOCALIZATOR_MENU"),
		isChildOf = "main_90_config",
		onSelected = function() setPage("main_config_localizator"); end,
	});
	
	--Text
	TRP3_ConfigurationLocalizatorTitle:SetText(loc("LOCALIZATOR_MENU"));
	
	-- Generate list based on default locale
	local locale = getDefaultLocaleStructure().localeContent;
	-- List is sorted alphabetically by key name
	for key, _ in pairs(locale) do
		tinsert(keys, key);
	end
	table.sort(keys);
	
	local i;
	for i=0,5,1 do
		local frame = CreateFrame("Frame", "TRP3_ConfigurationLocalizatorKey_"..i, TRP3_ConfigurationLocalizatorContainer, "TRP3_ConfigurationLocalizatorBox");
		frame:SetPoint("TOPLEFT", 15, (i * -61) - 18);
		_G[frame:GetName().."ScrollText"]:SetScript("OnTextChanged", onTextChanged);
		tinsert(frames, frame);
	end
	
	handleMouseWheel(TRP3_ConfigurationLocalizator, TRP3_ConfigurationLocalizatorContainerSlider);
	TRP3_ConfigurationLocalizatorContainerSlider:SetValue(0);
	initList(
		{
			widgetTab = frames,
			decorate = decorateBox
		},
		keys,
		TRP3_ConfigurationLocalizatorContainerSlider
	);
end

local MODULE_STRUCTURE = {
	["name"] = "Dynamic locale",
	["version"] = 1,
	["id"] = "dyn_locale",
	["onInit"] = onInit,
	["onLoaded"] = onLoaded,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);