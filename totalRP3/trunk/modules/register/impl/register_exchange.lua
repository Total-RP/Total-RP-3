--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Data exchange
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- TRP3 API
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
-- WoW API
local UnitName = UnitName;
local CheckInteractDistance = CheckInteractDistance;
local UnitIsPlayer = UnitIsPlayer;
local UnitFactionGroup = UnitFactionGroup;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Queries
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local LAST_QUERY = {};
local COOLDOWN_DURATION = 1; -- integer or gtfo :)

local function isPlayerElligible(unitName)
    local unitID = TRP3_GetUnitID(unitName);
    return TRP3_Register[unitName] ~= nil and TRP3_Register[unitName].ignored ~= false;
end

local function queryVernum(unitRealm, unitName)
    
end

local function queryMarySueProtocol(unitRealm, unitName)
    
end

--- Send vernum request to the player if this is a known TRP player
-- The main rule is : we send a vernum query 
-- Note that we can't send query to a player from another realm.
local function onMouseOver(...)
    local unitName, unitRealm = UnitName("mouseover");
    
    if unitName -- unitName equals nil if no character under the mouse (possible if the event trigger is delayed)
        and unitRealm == nil -- Don't send query to players from other realm. You just can't.
        and UnitIsPlayer("mouseover") -- Don't query NPC ;D
        and unitName ~= TRP3_PLAYER -- Don't query yourself ;D
        and unitName ~= UNKNOWNOBJECT -- Name could equals UNKNOWNOBJECT if the player is not "loaded" (far away, disconnected ...)
        and UnitFactionGroup("mouseover") == UnitFactionGroup("player") -- Don't query other faction !
        and CheckInteractDistance("mouseover", 4) -- Should be at range, this is kind of optimization
        and isPlayerElligible(unitName) -- No interest sending query to non-TRP or ignored players ...
        and (not LAST_QUERY[unitName] or time() - LAST_QUERY[unitName] > COOLDOWN_DURATION) -- Optimization (cooldown from last query)
    then
        LAST_QUERY[unitName] = time();
        queryVernum(unitRealm, unitName);
        queryMarySueProtocol(unitRealm, unitName);
    end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_DataExchangeInit()

    if not TRP3_Register then
        TRP3_Register = {};
    end

    -- Listen to the mouse over event
    TRP3_RegisterToEvent("UPDATE_MOUSEOVER_UNIT", onMouseOver);
end