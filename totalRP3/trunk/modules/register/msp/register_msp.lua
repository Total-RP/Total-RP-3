--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Mary Sue Protocol implementation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- TRP3_Characters["Telkostrasz-KirinTor"].mspver = nil;
-- /dump TRP3_Characters["Telkostrasz-KirinTor"].mspver;

local function onStart()
	-- Check for already loaded MSP addon
	if _G.msp_RPAddOn then
		local addonName = _G.msp_RPAddOn or "Unknown MSP addon";
		TRP3_API.popup.showAlertPopup(TRP3_API.locale.getText("REG_MSP_ALERT"):format(addonName));
		-- Provoke error to cancel module activation
		error(("Conflict with another MSP addon: %s"):format(addonName));
	end

	local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
	local _G, error, tinsert, assert, setmetatable, type, pairs, wipe, GetTime, time = _G, error, tinsert, assert, setmetatable, type, pairs, wipe, GetTime, time;
	local tsize = Utils.table.size;
	local log = Utils.log.log;
	local loc = TRP3_API.locale.getText;
	local getPlayerCharacter = TRP3_API.profile.getPlayerCharacter;
	local get, getCompleteName = TRP3_API.profile.getData, TRP3_API.register.getCompleteName;
	local isIgnored = TRP3_API.register.isIDIgnored;
	local msp, onInformationReceived;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LibMSP
	-- This is a huge modification of Etarna's LibMSP
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	do
		_G.msp_RPAddOn = "Total RP 3";

		msp = {};
		msp.protocolversion = 1;

		local UNKNOWN = _G.UNKNOWN or "Unknown";

		local function emptyindex( table, key )
			table[key] = ""
			return table[key]
		end

		local function charindex( table, key )
			if key == "field" then
				table[key] = setmetatable( {}, { __index = emptyindex, } );
				return table[key];
			elseif key == "time" or key == "ver" then
				table[key] = {};
				return table[key];
			elseif key == "VA" then
				table[key] = "";
				return table[key];
			else
				return nil;
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
		local tostring, tonumber, next, ipairs = tostring, tonumber, next, ipairs

		local MSP_TT_ALONE = { 'TT' }
		local MSP_FIELDS_IN_TT = { 'VP', 'VA', 'NA', 'NH', 'NI', 'NT', 'RA', 'FR', 'FC', 'CU', 'RC' }
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
				if not isIgnored(sender) and MSP_INCOMING_HANDLER[ prefix ] then
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
				if field == "VA" then
					msp.char[ sender ].VA = body or "";
				end
				return field, body or "";
			end
		end

		function msp_incoming( sender, body )
			msp.char[ sender ].supported = true;
			msp.char[ sender ].scantime = nil;

			if body ~= "" then
				msp.reply = newtable();
				local updatedData = newtable();
				if strfind( body, "\1", 1, true ) then
					for chunk in strgmatch( body, "([^\1]+)\1*" ) do
						local field, value = msp_incomingchunk( sender, chunk );
						if field then
							updatedData[ field ] = value;
						end
					end
				else
					local field, value = msp_incomingchunk( sender, body );
					if field then
						updatedData[ field ] = value;
					end
				end
				if tsize(updatedData) > 0 then
					onInformationReceived(sender, updatedData);
				end
				msp:Send( sender, msp.reply );
				garbage[ msp.reply ] = true;
				garbage[ updatedData ] = true;
			end
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
						if msp.char[ player ].ver[ field ] and msp.char[ player ].ver[ field ] ~= 0 then
							tinsert( tosend, "?" .. field .. tostring( msp.char[ player ].ver[ field ] ) )
						else
							tinsert( tosend, "?" .. field )
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

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Update
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function updateCharacterData()
		local character = get("player/character");
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
		msp.my['RC'] = dataTab.CL;
		msp.my['AG'] = dataTab.AG;
		msp.my['AE'] = dataTab.EC;
		msp.my['AH'] = dataTab.HE;
		msp.my['AW'] = dataTab.WE;
		msp.my['HH'] = dataTab.RE;
		msp.my['HB'] = dataTab.BP;
		msp.my['NT'] = dataTab.FT;
		if dataTab.MI then
			for _, miscData in pairs(dataTab.MI) do
				if miscData.NA == loc("REG_PLAYER_MSP_MOTTO") then
					msp.my['MO'] = miscData.VA;
				elseif miscData.NA == loc("REG_PLAYER_MSP_HOUSE") then
					msp.my['NH'] = miscData.VA;
				elseif miscData.NA == loc("REG_PLAYER_MSP_NICK") then
					msp.my['NI'] = miscData.VA;
				end
			end
		end
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
	-- Exchange
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
	local getConfigValue = TRP3_API.configuration.getValue;
	local addCharacter, profileExists = TRP3_API.register.addCharacter, TRP3_API.register.profileExists;
	local isUnitIDKnown, getUnitIDCharacter = TRP3_API.register.isUnitIDKnown, TRP3_API.register.getUnitIDCharacter;
	local getUnitIDProfile, createUnitIDProfile = TRP3_API.register.getUnitIDProfile, TRP3_API.register.createUnitIDProfile;
	local hasProfile, saveCurrentProfileID = TRP3_API.register.hasProfile, TRP3_API.register.saveCurrentProfileID;
	local strtrim, emptyToNil, unitIDToInfo = strtrim, Utils.str.emptyToNil, Utils.str.unitIDToInfo;

	local CHARACTERISTICS_FIELDS = {
		NT = "FT",
		RA = "RA",
		RC = "CL",
		AG = "AG",
		AH = "HE",
		AW = "WE",
		HH = "RE",
		HB = "BP",
		NT = "FT",
		NA = "FN",
	}

	local CHARACTER_FIELDS = {
		FR = true, FC = true, CU = true, VA = true
	}

	local ABOUT_FIELDS = {
		HI = "HI",
		DE = "PH"
	}

	function onInformationReceived(senderID, data)

		if not isIgnored(senderID) and msp.char[senderID].VA:sub(1, 8) ~= "TotalRP3" then
			-- If sender is not known
			if not isUnitIDKnown(senderID) then
				-- We add him
				if getConfigValue("register_auto_add") then
					addCharacter(senderID);
				else
					return; -- The user choose not to add automatically new characters
				end
			end

			-- Check that the character has a profileID.
			local character = getUnitIDCharacter(senderID);
			character.msp = true;
			character.profileID = "[MSP]" .. senderID;
			if not profileExists(senderID) then
				-- Generate profile
				saveCurrentProfileID(senderID, character.profileID, true);
			end

			-- Init profile if not already done
			local profile = getUnitIDProfile(senderID);
			profile.msp = true;
			if not profile.characteristics then
				profile.characteristics = {};
			end
			if not profile.about then
				profile.about = {};
			end
			if not profile.character then
				profile.character = {};
			end
			if not profile.mspver then
				profile.mspver = {};
			end

			-- And only after all these checks, store data !
			local updatedCharacteristics, updatedAbout, updatedCharacter = false, false, false;
			for field, value in pairs(data) do
				-- Save version
				profile.mspver[field] = msp.char[senderID].ver[field];
				if CHARACTERISTICS_FIELDS[field] then
					updatedCharacteristics = true;
					profile.characteristics[CHARACTERISTICS_FIELDS[field]] = emptyToNil(strtrim(value));
					-- Hack for spaced name tolerated in MRP
					if field == "NA" and not profile.characteristics[CHARACTERISTICS_FIELDS[field]] then
						profile.characteristics[CHARACTERISTICS_FIELDS[field]] = unitIDToInfo(senderID);
					end
				elseif ABOUT_FIELDS[field] then
					updatedAbout = true;
					local old = nil;
					if profile.about.T3 and profile.about.T3[ABOUT_FIELDS[field]] then
						old = profile.about.T3[ABOUT_FIELDS[field]].TX;
					end
					profile.about.BK = 5;
					profile.about.TE = 3;
					if not profile.about.T3 then
						profile.about.T3 = {};
					end
					if not profile.about.T3.HI then
						profile.about.T3.HI = {BK = 1, IC = "INV_Misc_Book_17"};
					end
					if not profile.about.T3.PH then
						profile.about.T3.PH = {BK = 1, IC = "Ability_Warrior_StrengthOfArms"};
					end
					value = emptyToNil(strtrim(value));
					profile.about.T3[ABOUT_FIELDS[field]].TX = value;
					profile.about.read = value == old or value:len() == 0;
				elseif CHARACTER_FIELDS[field] then
					updatedCharacter = true;
					if field == "FC" then
						profile.character.RP = 2;
						if value == "2" then
							profile.character.RP = 1;
						end
					elseif field == "CU" then
						profile.character.CU = value;
					elseif field == "FR" then
						profile.character.XP = 2;
						if value == "4" then
							profile.character.XP = 1;
						end
					elseif field == "VA" and value:find("%/") then
						character.client = value:sub(1, value:find("%/") - 1);
						character.clientVersion = value:sub(value:find("%/") + 1);
					end
				elseif field == "MO" then
					if strtrim(value):len() ~= 0 then
						if not profile.characteristics.MI then
							profile.characteristics.MI = {};
						end
						local index = #profile.characteristics.MI + 1;
						for miscIndex, miscStructure in pairs(profile.characteristics.MI) do
							if miscStructure.NA == loc("REG_PLAYER_MSP_MOTTO") then
								index = miscIndex;
							end
						end
						if not profile.characteristics.MI[index] then
							profile.characteristics.MI[index] = {};
						else
							wipe(profile.characteristics.MI[index]);
						end
						profile.characteristics.MI[index].NA = loc("REG_PLAYER_MSP_MOTTO");
						profile.characteristics.MI[index].VA = "\"" .. value .. "\"";
						profile.characteristics.MI[index].IC = "INV_Inscription_ScrollOfWisdom_01";
					end
				elseif field == "NH" then
					if strtrim(value):len() ~= 0 then
						if not profile.characteristics.MI then
							profile.characteristics.MI = {};
						end
						local index = #profile.characteristics.MI + 1;
						for miscIndex, miscStructure in pairs(profile.characteristics.MI) do
							if miscStructure.NA == loc("REG_PLAYER_MSP_HOUSE") then
								index = miscIndex;
							end
						end
						if not profile.characteristics.MI[index] then
							profile.characteristics.MI[index] = {};
						else
							wipe(profile.characteristics.MI[index]);
						end
						profile.characteristics.MI[index].NA = loc("REG_PLAYER_MSP_HOUSE");
						profile.characteristics.MI[index].VA = value;
						profile.characteristics.MI[index].IC = "inv_misc_kingsring1";
					end
				elseif field == "NI" then
					if strtrim(value):len() ~= 0 then
						if not profile.characteristics.MI then
							profile.characteristics.MI = {};
						end
						local index = #profile.characteristics.MI + 1;
						for miscIndex, miscStructure in pairs(profile.characteristics.MI) do
							if miscStructure.NA == loc("REG_PLAYER_MSP_NICK") then
								index = miscIndex;
							end
						end
						if not profile.characteristics.MI[index] then
							profile.characteristics.MI[index] = {};
						else
							wipe(profile.characteristics.MI[index]);
						end
						profile.characteristics.MI[index].NA = loc("REG_PLAYER_MSP_NICK");
						profile.characteristics.MI[index].VA = value;
						profile.characteristics.MI[index].IC = "Ability_Hunter_BeastCall";
					end
				end
			end

			if updatedCharacteristics then
				Events.fireEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, hasProfile(senderID), "characteristics");
			end
			if updatedAbout then
				Events.fireEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, hasProfile(senderID), "about");
			end
			if updatedCharacter then
				Events.fireEvent(Events.REGISTER_EXCHANGE_RECEIVED_INFO, hasProfile(senderID), "character");
			end
			if updatedCharacter or updatedCharacteristics or updatedAbout then
				Events.fireEvent(Events.REGISTER_DATA_CHANGED, senderID, hasProfile(senderID));
			end
		end
	end

	local TT_TIMER_TAB, FIELDS_TIMER_TAB = {}, {};
	local TT_DELAY, FIELDS_DELAY = 5, 20;
	local REQUEST_TAB = {"HH", "AG", "AE", "HB", "DE", "HI", "AH", "AW", "MO", "NH"};

	local function requestInformation(targetID, targetMode)
		if targetID and targetMode == TYPE_CHARACTER
		and targetID ~= Globals.player_id
		and not isIgnored(targetID)
		and msp.char[targetID].VA:sub(1, 8) ~= "TotalRP3"
		then
			if not msp.char[targetID].ver then
				msp.char[targetID].ver = {};
			end
			local request = {};
			if not TT_TIMER_TAB[targetID] or time() - TT_TIMER_TAB[targetID] >= TT_DELAY then
				tinsert(request, "TT");
				TT_TIMER_TAB[targetID] = time();
			end
			if not FIELDS_TIMER_TAB[targetID] or time() - FIELDS_TIMER_TAB[targetID] >= FIELDS_DELAY then
				for _, field in pairs(REQUEST_TAB) do
					tinsert(request, field);
				end
				FIELDS_TIMER_TAB[targetID] = time();
			end
			if #request > 0 then
				msp:Request(targetID, request);
			end
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Init
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	msp.my['VA'] = "TotalRP3/" .. Globals.version_display;
	msp.my['GU'] = UnitGUID("player");
	msp.my['GS'] = tostring( UnitSex("player") );
	msp.my['GC'] = Globals.player_character.class;
	msp.my['GR'] = Globals.player_character.race;
	msp.my['GF'] = Globals.player_character.faction;

	-- MSP versions handling
	local character = getPlayerCharacter();
	if not character.mspver then
		character.mspver = {};
	end
	msp.myver = character.mspver;

	-- Init others vernum
	for profileID, profile in pairs(TRP3_API.register.getProfileList()) do
		if profile.msp and profile.mspver and profile.link then
			for fieldID, version in pairs(profile.mspver) do
				for ownerID, _ in pairs(profile.link) do
					msp.char[ownerID].ver[fieldID] = version;
				end
			end
		end
	end

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
	Events.listenToEvent(Events.MOUSE_OVER_CHANGED, requestInformation);
	Events.listenToEvent(Events.REGISTER_PROFILE_DELETED, function(profileID, mspOwners)
		if mspOwners then
			for _, ownerID in pairs(mspOwners) do
				wipe(msp.char[ownerID].ver);
				TT_TIMER_TAB[ownerID] = nil;
				FIELDS_TIMER_TAB[ownerID] = nil;
			end
		end
	end);
end

local MODULE_STRUCTURE = {
	["name"] = "Mary Sue Protocol",
	["description"] = "MSP implementation for a compatibility with all MSP addons (MyRoleplay, FlagRSP, TotalRP2 ...)",
	["version"] = 1.000,
	["id"] = "trp3_msp",
	["onStart"] = onStart,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);