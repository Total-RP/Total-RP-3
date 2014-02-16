--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local loc = TRP3_L;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Business logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onTargetChanged(...)
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_UI_InitTargetFrame()
	TRP3_RegisterToEvent("PLAYER_TARGET_CHANGED", onTargetChanged);
end