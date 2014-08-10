--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Mary Sue Protocol implementation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local _G, error, tinsert, assert, setmetatable, type, pairs = _G, error, tinsert, assert, setmetatable, type, pairs;
local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
local loc = TRP3_API.locale.getText;
local showAlertPopup = TRP3_API.popup.showAlertPopup;
local getPlayerCharacter = TRP3_API.profile.getPlayerCharacter;
local get, getCompleteName = TRP3_API.profile.getData, TRP3_API.register.getCompleteName;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LibMSP
-- This is a huge modification of Eterna's LibMSP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local msp, onInformationReceived;

local function loadLibMSP()

	_G.msp_RPAddOn = "Total RP 3";
	
	msp = {};
	local ChatThrottleLib = assert(ChatThrottleLib, "LibMSP requires ChatThrottleLib");
	assert(ChatThrottleLib.version >= 22, "LibMSP requires ChatThrottleLib v22 or later");

	msp.protocolversion = 1;

	local UNKNOWN = _G.UNKNOWN or "Unknown";

	local function emptyindex( table, key )
		table[key] = ""
		return table[key]
	end

	local function charindex( table, key )
		if key == "field" then
			table[key] = setmetatable( {}, { __index = emptyindex, } )
			return table[key]
		elseif key == "ver" or key == "time" then
			table[key] = {}
			return table[key]
		else
			return nil
		end
	end

	local function bufferindex( table, key )
		table[key] = setmetatable( {}, { __index = charindex, } )
		return table[key]
	end

	msp.char = setmetatable( {}, { __index = bufferindex } )

	msp.my = {}
	msp.myver = {}
	msp.my.VP = tostring( msp.protocolversion )

	local msp_my_previous = {}
	local msp_tt_cache = false

	local strfind, strmatch, strsub, strgmatch = strfind, strmatch, strsub, string.gmatch
	local tconcat = table.concat
	local tostring, tonumber, wipe, next, ipairs = tostring, tonumber, wipe, next, ipairs
	local GetTime = GetTime

	local MSP_TT_ALONE = { 'TT' }
	local MSP_FIELDS_IN_TT = { 'VP', 'VA', 'NA', 'NH', 'NI', 'NT', 'RA', 'FR', 'FC', 'CU' }
	local MSP_TT_FIELD = { VP=true, VA=true, NA=true, NH=true, NI=true, NT=true, RA=true, FR=true, FC=true, CU=true }
	local MSP_PROBE_FREQUENCY = 300.0 + math.random(0, 60) -- Wait 5-6 minutes for someone to respond before asking again
	local MSP_FIELD_UPDATE_FREQUENCY = 10.0 + math.random(0, 5) -- Fields newer than 10-15 seconds old are still fresh

	local garbage = setmetatable( {}, { __mode = "k" } )
	local function newtable()
		local t = next( garbage )
		if t then
			garbage[t] = nil
			return wipe(t)
		end
		return {}
	end

	local msp_incominglast, msp_incoming, msp_incomingchunk, msp_incomingnext, msp_incomingfirst, msp_onevent
	local MSP_INCOMING_HANDLER = {}

	function msp_onevent( this, event, prefix, body, dist, sender )
		if event == "CHAT_MSG_ADDON" then
			if MSP_INCOMING_HANDLER[ prefix ] then
				MSP_INCOMING_HANDLER[ prefix ]( sender, body )
			end
		end
	end

	function msp_incomingfirst( sender, body )
		msp.char[ sender ].buffer = body
	end

	function msp_incomingnext( sender, body )
		local buf = msp.char[ sender ].buffer
		if buf then
			if type( buf ) == "table" then
				tinsert( buf, body )
			else
				local temp = newtable()
				temp[ 1 ] = buf
				temp[ 2 ] = body
				msp.char[ sender ].buffer = temp
			end
		end
	end

	function msp_incomingchunk( sender, chunk )
		local reply = msp.reply
		local head, field, ver, body = strmatch( chunk, "(%p?)(%a%a)(%d*)=?(.*)" )
		ver = tonumber( ver ) or 0
		if not field then
			return
		end
		if head == "?" then
			if (ver == 0) or (ver < (msp.myver[ field ] or 0)) or (ver > (msp.myver[ field ] or 0)) then
				if field == "TT" then
					if not msp_tt_cache then
						msp:Update()
					end
					tinsert( reply, msp_tt_cache )
				else
					if not msp.my[ field ] or msp.my[ field ] == "" then
						tinsert( reply, field .. (msp.myver[ field ] or "") )
					else
						tinsert( reply, field .. (msp.myver[ field ] or "") .. "=" .. msp.my[ field ] )
					end
				end
			else
				tinsert( reply, "!"..field..(msp.myver[ field ] or "") )
			end
		elseif head == "!" then
			msp.char[ sender ].ver[ field ] = ver
			msp.char[ sender ].time[ field ] = GetTime()
		elseif head == "" then
			msp.char[ sender ].ver[ field ] = ver
			msp.char[ sender ].time[ field ] = GetTime()
			msp.char[ sender ].field[ field ] = body or ""
		end
	end

	function msp_incoming( sender, body )
		msp.char[ sender ].supported = true
		msp.char[ sender ].scantime = nil
		msp.reply = newtable()
		if body ~= "" then
			if strfind( body, "\1", 1, true ) then
				for chunk in strgmatch( body, "([^\1]+)\1*" ) do
					msp_incomingchunk( sender, chunk )
				end
			else
				msp_incomingchunk( sender, body )
			end
		end
		onInformationReceived( sender )
		msp:Send( sender, msp.reply )
		garbage[ msp.reply ] = true
	end

	function msp_incominglast( sender, body )
		local buf = msp.char[ sender ].buffer
		if buf then
			if type( buf ) == "table" then
				tinsert( buf, body )
				msp_incoming( sender, tconcat( buf ) )
				garbage[ buf ] = true
			else
				msp_incoming( sender, buf .. body )
			end
		end
	end

	MSP_INCOMING_HANDLER["MSP"] = msp_incoming
	MSP_INCOMING_HANDLER["MSP\1"] = msp_incomingfirst
	MSP_INCOMING_HANDLER["MSP\2"] = msp_incomingnext
	MSP_INCOMING_HANDLER["MSP\3"] = msp_incominglast

	msp.dummyframe = msp.dummyframe or CreateFrame( "Frame", "libmspDummyFrame" )
	msp.dummyframe:SetScript( "OnEvent", msp_onevent )
	msp.dummyframe:RegisterEvent( "CHAT_MSG_ADDON" )

	for prefix, handler in pairs( MSP_INCOMING_HANDLER ) do
		RegisterAddonMessagePrefix( prefix )
	end

	function msp:InitCache()
		for field, value in pairs( msp.my ) do
			msp_my_previous[ field ] = value or "";
			msp.myver[ field ] = msp.myver[ field ] or 0;
		end
		msp.myver.TT = (msp.myver.TT or 0);
		local tt = newtable();
		for k, field in ipairs( MSP_FIELDS_IN_TT ) do
			local value = msp.my[ field ]
			if not value or value == "" then
				tinsert( tt, field .. (msp.myver[ field ] or "") )
			else
				tinsert( tt, field .. (msp.myver[ field ] or "") .. "=" .. value )
			end
		end
		msp_tt_cache = (tconcat( tt, "\1" ) or "") .. "\1TT" .. msp.myver.TT;
	end

	--[[
	msp:Update()
	Call this function when you update (or might have updated) one of the fields in the player's own profile (msp.my).
	It'll deal with any version updates necessary and will rebuild the cached tooltip reply.
	]]
	function msp:Update()
		local updated = false
		local tt = newtable()
		for field, value in pairs( msp_my_previous ) do
			if not msp.my[ field ] then
				updated = true
				msp_my_previous[ field ] = ""
				msp.myver[ field ] = (msp.myver[ field ] or 0) + 1
				if MSP_TT_FIELD[ field ] then
					tinsert( tt, field .. msp.myver[ field ] )
				end
			end
		end
		for field, value in pairs( msp.my ) do
			if (msp_my_previous[ field ] or "") ~= value then
				updated = true
				msp_my_previous[ field ] = value or ""
				msp.myver[ field ] = (msp.myver[ field ] or 0) + 1
			end
		end
		for k, field in ipairs( MSP_FIELDS_IN_TT ) do
			local value = msp.my[ field ]
			if not value or value == "" then
				tinsert( tt, field .. (msp.myver[ field ] or "") )
			else
				tinsert( tt, field .. (msp.myver[ field ] or "") .. "=" .. value )
			end
		end
		local newtt = tconcat( tt, "\1" ) or ""
		if msp_tt_cache ~= newtt.."\1TT"..(msp.myver.TT or 0) then
			msp.myver.TT = (msp.myver.TT or 0) + 1
			msp_tt_cache = newtt.."\1TT"..msp.myver.TT
		end
		garbage[ tt ] = true
		return updated
	end

	--[[
	msp:Request( player, fields )
	player = Player name to query; if from a different realm, format should be "Name-Realm"
	fields = One (string) or more (table) fields to request from the player in question

	Returns true if we sent them a request, and false if we didn't (because we either have it
	recently cached already, or they didn't respond to our last request so might not support MSP).

	Notes:
	- This function does not spam: feel free to use frequently.
	- To avoid problems with network congestion, doesn't work on a player called "Unknown".
	- Player names are CASE SENSITIVE; pass them as you got them.
	- Replies aren't instant: to be notified if/when we get a reply, register a callback function.
	- For a quick shortcut, request field TT to get basic data you'll probably use in the tooltip.
	- Defaults to a TT (tooltip) request, if there is only one parameter.
	]]
	function msp:Request( player, fields )
		if player == UNKNOWN then
			return false
		else
			local now = GetTime()
			if msp.char[ player ].supported == false and ( now < msp.char[ player ].scantime + MSP_PROBE_FREQUENCY ) then
				return false
			elseif not msp.char[ player ].supported then
				msp.char[ player ].supported = false
				msp.char[ player ].scantime = now
			end
			if type( fields ) == "string" then
				fields = { fields }
			elseif type( fields ) ~= "table" then
				fields = MSP_TT_ALONE
			end
			local updateneeded = false
			local tosend = newtable()
			for k, field in ipairs(fields) do
				if not msp.char[ player ].supported or not msp.char[ player ].time[ field ] or (now > msp.char[ player ].time[ field ] + MSP_FIELD_UPDATE_FREQUENCY) then
					updateneeded = true
					if not msp.char[ player ].supported or not msp.char[ player ].ver[ field ] or msp.char[ player ].ver[ field ] == 0 then
						tinsert( tosend, "?" .. field )
					else
						tinsert( tosend, "?" .. field .. tostring( msp.char[ player ].ver[ field ] ) )
					end
				end
			end
			if updateneeded then
				msp:Send( player, tosend )
			end
			garbage[ tosend ] = true
			return updateneeded
		end
	end

	function msp:Send( player, chunks )
		local payload = ""
		if type( chunks ) == "string" then
			payload = chunks
		elseif type( chunks ) == "table" then
			payload = tconcat( chunks, "\1" )
		end
		if payload ~= "" then
			local len = #payload
			local queue = "MSPWHISPER" .. player
			if len < 256 then
				ChatThrottleLib:SendAddonMessage( "BULK", "MSP", payload, "WHISPER", player, queue )
				return 1
			else
				local chunk = strsub( payload, 1, 255 )
				ChatThrottleLib:SendAddonMessage( "BULK", "MSP\1", chunk, "WHISPER", player, queue )
				local pos = 256
				local parts = 2
				while pos + 255 <= len do
					chunk = strsub( payload, pos, pos + 254 )
					ChatThrottleLib:SendAddonMessage( "BULK", "MSP\2", chunk, "WHISPER", player, queue )
					pos = pos + 255
					parts = parts + 1
				end
				chunk = strsub( payload, pos )
				ChatThrottleLib:SendAddonMessage( "BULK", "MSP\3", chunk, "WHISPER", player, queue )
				return parts
			end
		end
		return 0
	end

	--[[
	WoW 4.0.3.13329: Bug Workaround
	(Invisible SendAddonMessage() returning visible ERR_CHAT_PLAYER_NOT_FOUND_S system message on failure)
	]]
	ChatFrame_AddMessageEventFilter( "CHAT_MSG_SYSTEM", function( self, event, msg )
		return msp:PlayerKnownAbout( msg:match( ERR_CHAT_PLAYER_NOT_FOUND_S:format( "(.+)" ) ) )
	end )
	function msp:PlayerKnownAbout( player )
		if player == nil or player == "" then
			return false
		end
		return msp.char[ player ].supported ~= nil
	end
end

-- TRP3_Characters["Telkostrasz-KirinTor"].mspver = nil;
-- /dump TRP3_Characters["Telkostrasz-KirinTor"].mspver;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Update
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function updateCharacterData()
	local character = getPlayerCharacter();
	msp.my['CU'] = character.CU;
	if character.XP == 1 then
		msp.my['FR'] = "Beginner roleplayer";
	elseif character.XP == 2 then
		msp.my['FR'] = "Experienced roleplayer";
	else
		msp.my['FR'] = "Volunteer roleplayer";
	end
	if character.RP == 1 then
		msp.my['FC'] = "2";
	else
		msp.my['FC'] = "1";
	end
end

local function removeTextTags(text)
	if text then
		return text:gsub("%{.-%}", "");
	end
end

local function updateAboutData()
	local dataTab = get("player/about");
	msp.my['DE'] = nil;
	msp.my['HI'] = nil;
	if dataTab.TE == 1 then
		msp.my['DE'] = removeTextTags(dataTab.T1.TX);
	elseif dataTab.TE == 2 then
		local text;
		for _, data in pairs(dataTab.T2) do
			if not text then text = "" end
			text = text .. (data.TX or "") .. "\n\n";
		end
		msp.my['DE'] = text;
	elseif dataTab.TE == 3 then
		msp.my['HI'] = dataTab.T3.HI.TX;
		msp.my['DE'] = dataTab.T3.PH.TX;
	end
end

local function updateCharacteristicsData()
	local dataTab = get("player/characteristics");
	msp.my['NA'] = getCompleteName(dataTab, Globals.player);
	msp.my['NT'] = dataTab.FT;
	msp.my['RA'] = dataTab.RA;
	msp.my['AG'] = dataTab.AG;
	msp.my['AE'] = dataTab.EC;
	msp.my['AH'] = dataTab.HE;
	msp.my['AW'] = dataTab.WE;
	msp.my['HH'] = dataTab.RE;
	msp.my['HB'] = dataTab.BP;
	msp.my['NT'] = dataTab.FT;
end

local function onProfileChanged()
	updateCharacteristicsData();
	updateAboutData();
	msp:Update();
end

local function onCharactChanged()
	updateCharacteristicsData();
	msp:Update();
end

local function onAboutChanged()
	updateAboutData();
	msp:Update();
end

local function onCharacterChanged()
	updateCharacterData();
	msp:Update();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Received
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function onInformationReceived()

end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onLoaded()
	-- Check for already loaded MSP addon
	if _G.msp_RPAddOn then
		local addonName = _G.msp_RPAddOn or "Unknown MSP addon";
		showAlertPopup(loc("REG_MSP_ALERT"):format(addonName));
		-- Provoke error to cancel module activation
		error(("Conflict with another MSP addon: %s"):format(addonName));
	end
	
	loadLibMSP();
	msp.my['VA'] = "TotalRP3/" .. Globals.version_display;

	-- MSP versions handling
	local character = getPlayerCharacter();
	if not character.mspver then
		character.mspver = {};
	end
	msp.myver = character.mspver;

	-- Initial update
	updateCharacteristicsData();
	updateAboutData();
	updateCharacterData();

	msp:InitCache();
	msp:Update();

	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, onProfileChanged);
	Events.listenToEvent(Events.REGISTER_CHARACTERISTICS_SAVED, onCharactChanged);
	Events.listenToEvent(Events.REGISTER_ABOUT_SAVED, onAboutChanged);
	Events.listenToEvents({Events.REGISTER_RPSTATUS_CHANGED, Events.REGISTER_XPSTATUS_CHANGED, Events.REGISTER_CURRENTLY_CHANGED}, onCharacterChanged);
end

local MODULE_STRUCTURE = {
	["name"] = "Mary Sue Protocol",
	["description"] = "MSP implementation for a compatibility with all MSP addons (MyRoleplay, FlagRSP, TotalRP2 ...)",
	["version"] = 1.000,
	["id"] = "trp3_msp",
	["onLoaded"] = onLoaded,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);