local DEFAULT_LOCALE = "enUS";
local currentLocale = DEFAULT_LOCALE;

function TRP3_API.utils.resources.getMatureFilterDictionary()

	currentLocale = TRP3_API.utils.GetPreferredLocale();
	if not dictionary[currentLocale] then
		currentLocale = DEFAULT_LOCALE;
	end

	return dictionary[currentLocale]
end
