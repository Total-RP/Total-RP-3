local DEFAULT_LOCALE = "enUS";
local currentLocale = DEFAULT_LOCALE;

function TRP3.utils.resources.getMatureFilterDictionary()

	currentLocale = TRP3.utils.GetPreferredLocale();
	if not dictionary[currentLocale] then
		currentLocale = DEFAULT_LOCALE;
	end

	return dictionary[currentLocale]
end
