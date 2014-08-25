--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Flyway
-- Patches source
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.flyway.patches = {};

-- Internal reinit du to TRP-45
TRP3_API.flyway.patches["2"] = function()
	TRP3_Profiles = nil;
	TRP3_Characters = nil;
end