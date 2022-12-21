-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local _, TRP3_API = ...;

local Locale = {};
TRP3_API.Locale = Locale;

function Locale.init()
	TRP3_API.configuration.registerConfigKey("AddonLocale", GetLocale());
	TRP3_API.loc:SetCurrentLocale(TRP3_API.configuration.getValue("AddonLocale"), true);
end
