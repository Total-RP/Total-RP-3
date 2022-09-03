---@type Ellyb
local Ellyb = Ellyb(...);

---@class Ellyb_Locale
local Locale = Ellyb.Class("Locale");
Ellyb.Locale = Locale;

---@type {code: string, name: string, content: table<string, string>}[]
local private = Ellyb.getPrivateStorage();

---Constructor
---@param code string The code for the locale, must be one of the game's supported locale code
---@param name string The name of the locale, as could be displayed to the user
---@param content table<string, string> Content of the locale, a table with texts indexed with locale keys
function Locale:initialize(code, name, content)
	Ellyb.Assertions.isType(code, "string", "code");
	Ellyb.Assertions.isType(name, "string", "name");

	private[self].code = code;
	private[self].name = name;
	private[self].content = {};

	-- If the content of the locale was passed to the constructor, we add the content to the locale
	if content then
		self:AddTexts(content);
	end
end

-- Flavour syntax: we can add new values to the locale by adding them directly to the object Locale.LOCALIZATION_KEY = "value
function Locale:__newindex(key, value)
	self:AddText(key, value);
end

-- Flavour syntax: we can get the value for a key in the locale using Locale.LOCALIZATION_KEY
function Locale:__index(localeKey)
	return self:GetText(localeKey);
end

---@return string
function Locale:GetCode()
	return private[self].code;
end

---@return string
function Locale:GetName()
	return private[self].name;
end

---Get the localization value for this locale corresponding to the given localization key
---@param localizationKey string
---@return string
function Locale:GetText(localizationKey)
	Ellyb.Assertions.isType(localizationKey,"string", "localizationKey");

	return private[self].content[localizationKey];
end

---Add a new localization value to the locale
---@param localizationKey string
---@param value string
function Locale:AddText(localizationKey, value)
	Ellyb.Assertions.isType(localizationKey, "string", "localizationKey");
	Ellyb.Assertions.isType(value, "string", "value");

	private[self].content[localizationKey] = value;
end

--- Add a table of localization texts to the locale
---@param localeTexts table<string, string>
function Locale:AddTexts(localeTexts)
	Ellyb.Assertions.isType(localeTexts, "table", "localeTexts");

	for localizationKey, value in pairs(localeTexts) do
		self:AddText(localizationKey, value);
	end
end

--- Check if the locale has a value for a localization key
---@return boolean
function Locale:LocalizationKeyExists(localizationKey)
	return self:GetText(localizationKey) ~= nil;
end
