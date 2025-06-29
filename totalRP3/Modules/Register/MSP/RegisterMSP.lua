-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local outstandingHelloRequests = {};

local function GetOrCreateTable(t, key)
	if t[key] ~= nil then
		return t[key];
	end

	t[key] = {};
	return t[key];
end

local function onStart()
	local loc = TRP3_API.loc;

	-- Check for already loaded MSP addon
	if msp_RPAddOn then
		TRP3_API.popup.showAlertPopup(loc.REG_MSP_ALERT:format(msp_RPAddOn));
		-- Provoke error to cancel module activation
		error(("Conflict with another MSP addon: %s"):format(msp_RPAddOn));
	end

	local Globals, Utils, Events = TRP3_API.globals, TRP3_API.utils, TRP3_Addon.Events;
	local get, getCompleteName = TRP3_API.profile.getData, TRP3_API.register.getCompleteName;
	local isIgnored = TRP3_API.register.isIDIgnored;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LibMSP support code
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	msp_RPAddOn = "Total RP 3";
	msp:AddFieldsToTooltip(AddOn_TotalRP3.MSP.TOOLTIP_FIELDS);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Update
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function updateCharacterData()
		local character = get("player/character");
		local experience = AddOn_TotalRP3.Player.GetCurrentUser():GetRoleplayExperience();
		msp.my['CU'] = character.CU;
		msp.my['CO'] = character.CO;
		if experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER then
			msp.my['FR'] = "1";  -- MRP: Beginner
		elseif experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN then
			msp.my['FR'] = "3";  -- MRP: Experienced
		elseif experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE then
			msp.my['FR'] = "4";  -- MRP: Guide
		else
			msp.my['FR'] = "2";  -- MRP: Casual
		end
		if character.RP == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER then
			if character.WU == AddOn_TotalRP3.Enums.WALKUP.YES then
				msp.my['FC'] = "3";
			else
				msp.my['FC'] = "2";
			end
		else
			msp.my['FC'] = "1";
		end
	end

	local function removeTextTags(text)
		if text then
			text =  text:gsub("%{link%*([^*]+)%*({icon:[^}]+})}","[%2]( %1 )"); --cleanup links instead of outright removing the tag
			text =  text:gsub("%{link%*(.-)%*(.-)%}","[%2]( %1 )"); --cleanup links instead of outright removing the tag
			text = Utils.str.convertTextTags(text);
			return text;
		end
	end

	local function updateAboutData()
		local dataTab = get("player/about");
		msp.my['DE'] = nil;
		msp.my['HI'] = nil;

		if dataTab.TE == 3 then
			msp.my['HI'] = removeTextTags(dataTab.T3.HI.TX);
			local PH = removeTextTags(dataTab.T3.PH.TX) or "";
			local PS = removeTextTags(dataTab.T3.PS.TX) or "";
			msp.my['DE'] = ("#Physical Description\n\n%s\n\n---\n\n#Personality traits\n\n%s"):format(PH, PS);
		elseif dataTab.TE == 1 then
			msp.my['DE'] = removeTextTags(dataTab.T1.TX);
		elseif dataTab.TE == 2 then
			local t = {};
			for _, data in ipairs(dataTab.T2) do
				if data.TX then
					t[#t + 1] = removeTextTags(data.TX);
				end
			end
			msp.my['DE'] = table.concat(t, "\n\n---\n\n");
		end

		msp.my['MU'] = dataTab.MU and tostring(dataTab.MU) or nil;
	end

	local function updateCharacteristicsData()
		local dataTab = get("player/characteristics");
		if dataTab.CH and dataTab.CH:len() > 0 then
			msp.my['NA'] = "|cff" .. dataTab.CH .. getCompleteName(dataTab, Globals.player) .. "|r";
		else
			msp.my['NA'] = getCompleteName(dataTab, Globals.player);
		end
		msp.my['IC'] = dataTab.IC or TRP3_InterfaceIcons.ProfileDefault;
		msp.my['NT'] = dataTab.FT;
		msp.my['PX'] = dataTab.TI;
		msp.my['RA'] = dataTab.RA;
		if dataTab.CL and dataTab.CH and dataTab.CH:len() > 0 then
			msp.my['RC'] = "|cff"..dataTab.CH..dataTab.CL.."|r";
		else
			msp.my['RC'] = dataTab.CL;
		end
		msp.my['AG'] = dataTab.AG;
		if dataTab.EC and dataTab.EH and dataTab.EH:len() > 0 then
			msp.my['AE'] = "|cff"..dataTab.EH..dataTab.EC.."|r";
		else
			msp.my['AE'] = dataTab.EC;
		end
		msp.my['AH'] = dataTab.HE;
		msp.my['AW'] = dataTab.WE;
		msp.my['HH'] = dataTab.RE;
		msp.my['HB'] = dataTab.BP;
		msp.my['NT'] = dataTab.FT;
		msp.my['RS'] = tostring(dataTab.RS or AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.UNKNOWN);
		-- Clear fields that may or may not exist in the updated profile.
		msp.my['MO'] = nil;
		msp.my['NH'] = nil;
		msp.my['NI'] = nil;
		msp.my['PN'] = nil;
		msp.my['PG'] = nil;
		msp.my['PR'] = nil;
		msp.my['PV'] = nil;
		if dataTab.MI then
			for _, miscData in pairs(dataTab.MI) do
				local miscType = TRP3_API.GetMiscInfoTypeFromData(miscData);

				if miscType == TRP3_API.MiscInfoType.Motto then
					msp.my['MO'] = miscData.VA;
				elseif miscType == TRP3_API.MiscInfoType.House then
					msp.my['NH'] = miscData.VA;
				elseif miscType == TRP3_API.MiscInfoType.Nickname then
					msp.my['NI'] = miscData.VA;
				elseif miscType == TRP3_API.MiscInfoType.Pronouns then
					msp.my['PN'] = miscData.VA;
				elseif miscType == TRP3_API.MiscInfoType.GuildName then
					msp.my['PG'] = miscData.VA;
				elseif miscType == TRP3_API.MiscInfoType.GuildRank then
					msp.my['PR'] = miscData.VA;
				elseif miscType == TRP3_API.MiscInfoType.VoiceReference then
					msp.my['PV'] = miscData.VA;
				end
			end
		end

		msp.my['PS'] = AddOn_TotalRP3.MSP.SerializeField("PS", dataTab.PS);
	end

	local RP_STYLE_FIELDS = {
		RI = "2",  -- Accept injuries
		RD = "3",  -- Accept death
		RR = "4",  -- Accept romance
		RM = "7",  -- Accept criminal activity
		RO = "8",  -- Accept loss of control
	};

	local function updateMiscData()
		local dataTab = get("player/misc");
		local peeks = {};
		for i = 1, 5 do
			local peek = dataTab.PE[tostring(i)];
			if peek and peek.AC then
				if #peeks > 0 then
					peeks[#peeks + 1] = "\n\n---\n\n";
				end
				peeks[#peeks + 1] = "|TInterface\\Icons\\";
				peeks[#peeks + 1] = peek.IC;
				peeks[#peeks + 1] = ":32:32|t\n";
				if peek.TI then
					peeks[#peeks + 1] = "#";
					peeks[#peeks + 1] = peek.TI;
					peeks[#peeks + 1] = "\n\n";
				end
				if peek.TX then
					peeks[#peeks + 1] = peek.TX;
				end
			end
		end
		msp.my['PE'] = table.concat(peeks);

		local styleData = get("player/misc/ST");
		msp.my['RI'] = styleData and tostring(styleData[RP_STYLE_FIELDS.RI] or 0);
		msp.my['RD'] = styleData and tostring(styleData[RP_STYLE_FIELDS.RD] or 0);
		msp.my['RR'] = styleData and tostring(styleData[RP_STYLE_FIELDS.RR] or 0);
		msp.my['RM'] = styleData and tostring(styleData[RP_STYLE_FIELDS.RM] or 0);
		msp.my['RO'] = styleData and tostring(styleData[RP_STYLE_FIELDS.RO] or 0);
	end

	local function onProfileChanged()
		updateCharacteristicsData();
		updateAboutData();
		updateMiscData();
		msp:Update();
	end

	local function onCharacterChanged()
		updateCharacterData();
		msp:Update();
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Exchange
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local addCharacter, profileExists = TRP3_API.register.addCharacter, TRP3_API.register.profileExists;
	local isUnitIDKnown, getUnitIDCharacter = TRP3_API.register.isUnitIDKnown, TRP3_API.register.getUnitIDCharacter;
	local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
	local hasProfile, saveCurrentProfileID = TRP3_API.register.hasProfile, TRP3_API.register.saveCurrentProfileID;
	local emptyToNil, unitIDToInfo = Utils.str.emptyToNil, Utils.str.unitIDToInfo;

	local SUPPORTED_FIELDS = {
		"VA", "NA", "NH", "NI", "NT", "RA", "CU", "FR", "FC", "PX", "RC",
		"IC", "CO", "PE", "HH", "AG", "AE", "HB", "AH", "AW", "MO", "DE",
		"HI", "TR", "MU", "RS", "PS", "PN", "PG", "PR",
	};

	local CHARACTERISTICS_FIELDS = {
		NT = "FT",
		RA = "RA",
		RC = "CL",
		AG = "AG",
		AE = "EC",
		AH = "HE",
		AW = "WE",
		HH = "RE",
		HB = "BP",
		NA = "FN",
		PX = "TI",
		IC = "IC",
		RS = "RS",
		PS = "PS",
	}

	local CHARACTER_FIELDS = {
		FR = true, FC = true, CU = true, VA = true, CO = true, TR = true,
	}

	local MISC_FIELDS = {
		PE = "PE",
	}

	local ABOUT_FIELDS = {
		HI = "HI",
		DE = "PH",
		MU = "MU",
	}

	local function getProfileForSender(senderID)
		-- If sender is not known
		if not isUnitIDKnown(senderID) then
			-- We add him
			addCharacter(senderID);
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
		character.msp = true;
		character.profileID = "[MSP]" .. senderID;
		return profile, character;
	end

	local function parsePeekString(str)
		local icon = str:match("%f[^\n%z]|TInterface\\Icons\\([^:|]+)[^|]*|t%f[\n%z]") or TRP3_InterfaceIcons.Default;
		local title = str:match("%f[^\n%z]#+% *(.-)% *%f[\n%z]");
		local text = str:match("%f[^\n%z]% *([^|#].-)%s*$");
		return {
			AC = true,
			IC = icon,
			TI = title,
			TX = text,
		};
	end

	local MISC_INFO_FIELDS = {
		MO = Mixin(TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Motto), {
			formatter = function(value) return string.format([["%s"]], value); end
		}),
		NH = TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.House),
		NI = TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Nickname),
		PN = TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Pronouns),
		PG = TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.GuildName),
		PR = TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.GuildRank),
		PV = TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.VoiceReference),
	};

	local function updateMiscInfoField(profile, field, value)
		local fieldInfo = MISC_INFO_FIELDS[field];

		if not field then
			return;
		end

		local miscInfo = GetOrCreateTable(profile.characteristics, "MI");
		local miscIndex = FindInTableIf(miscInfo, function(miscData)
			return (miscData.NA == fieldInfo.localizedName) or (miscData.NA == fieldInfo.englishName);
		end);

		if value then
			local miscData = GetOrCreateTable(miscInfo, miscIndex or #miscInfo + 1);
			table.wipe(miscData);

			miscData.ID = fieldInfo.type;
			miscData.NA = fieldInfo.localizedName;
			miscData.IC = fieldInfo.icon;
			miscData.VA = fieldInfo.formatter and fieldInfo.formatter(value) or value;
		elseif miscIndex then
			table.remove(miscInfo, miscIndex);
		end
	end

	local function UpdateRPStyleField(profile, field, value)
		local styleKey = RP_STYLE_FIELDS[field];

		if not styleKey then
			return;
		end

		local styleData = GetOrCreateTable(profile.misc, "ST");
		styleData[styleKey] = tonumber(value) or 0;
	end

	tinsert(msp.callback.received, function(senderID)
		local data = msp.char[senderID].field;

		if outstandingHelloRequests[senderID] then
			outstandingHelloRequests[senderID] = nil;
			TRP3_API.r.sendMSPQuery(senderID);
		end

		if not isIgnored(senderID) and data.VA ~= "" and not string.find(data.VA, "TotalRP3") then
			local profile, character = getProfileForSender(senderID);
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

			local color = false;
			for _, field in ipairs(SUPPORTED_FIELDS) do
				if profile.mspver[field] ~= msp.char[senderID].ver[field]
				or msp.ttAll[field] and profile.mspver.TT ~= msp.char[senderID].ver.TT
				then
					-- Save version
					profile.mspver[field] = msp.char[senderID].ver[field];

					-- Save fields
					local value = data[field];
					if value then
						value = emptyToNil(strtrim(value));
					end
					if CHARACTERISTICS_FIELDS[field] then
						-- NA/RC color escaping
						if (field == "NA" or field == "RC") and value then
							if not color then
								color = value:match("|c%x%x(%x%x%x%x%x%x)");
							end
							value = value:gsub("|c%x%x%x%x%x%x%x%x", "");
						end
						-- Remove title from full name, if present
						if field == "NA" and value and data.PX then
							if value:sub(1, #data.PX + 1) == (data.PX .. " ") then
								value = value:sub(#data.PX + 2);
							end
						end
						-- AE color escaping
						if field == "AE" then
							if value then
								profile.characteristics["EH"] = value:match("|c%x%x(%x%x%x%x%x%x)");
								value = value:gsub("|c%x%x%x%x%x%x%x%x", "");
							else
								profile.characteristics["EH"] = nil;
							end
						end
						-- Internal MSP weight is kilograms without units.
						if field == "AW" and value and tonumber(value) then
							value = value .. " kg";
						end
						-- Internal MSP height is centimeters without units.
						if field == "AH" and value and tonumber(value) then
							value = value .. " cm";
						end
						if field == "RS" and value then
							value = tonumber(value);
						end
						profile.characteristics[CHARACTERISTICS_FIELDS[field]] = value;
						-- Hack for spaced name tolerated in MRP
						if field == "NA" and not profile.characteristics[CHARACTERISTICS_FIELDS[field]] then
							profile.characteristics[CHARACTERISTICS_FIELDS[field]] = unitIDToInfo(senderID);
						end
						-- Machine-formatted psychological traits.
						if field == "PS" and value then
							profile.characteristics[CHARACTERISTICS_FIELDS[field]] = AddOn_TotalRP3.MSP.DeserializeField(field, value);
						end
					elseif ABOUT_FIELDS[field] then
						if field == "MU" then
							local fileID = tonumber(value);
							if not fileID and type(value) == "string" then
								fileID = Utils.music.convertPathToID(value);
							end

							profile.about.MU = fileID;
						else
							local old;
							if profile.about.T3 and profile.about.T3[ABOUT_FIELDS[field]] then
								old = profile.about.T3[ABOUT_FIELDS[field]].TX;
							end
							profile.about.BK = 5;
							profile.about.TE = 3;
							if not profile.about.T3 then
								profile.about.T3 = {};
							end
							if not profile.about.T3.HI then
								profile.about.T3.HI = {BK = 1, IC = TRP3_InterfaceIcons.HistorySection };
							end
							if not profile.about.T3.PH then
								profile.about.T3.PH = {BK = 1, IC = TRP3_InterfaceIcons.PhysicalSection };
							end
							profile.about.T3[ABOUT_FIELDS[field]].TX = value;
							if profile.about.read ~= false then
								profile.about.read = not value or value == old;
							end
						end
					elseif CHARACTER_FIELDS[field] then
					if field == "FC" then
						if value == "1" then
							profile.character.RP = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
						else
							profile.character.RP = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
						end
						if value == "3" then
							profile.character.WU = AddOn_TotalRP3.Enums.WALKUP.YES;
						else
							profile.character.WU = AddOn_TotalRP3.Enums.WALKUP.NO;
						end
						elseif field == "CU" then
							profile.character.CU = value;
						elseif field == "CO" then
							profile.character.CO = value;
						elseif field == "FR" then
							if value == "1" then
								character.roleplayExperience = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER;
							elseif value == "3" then
								character.roleplayExperience = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN;
							elseif value == "4" then
								character.roleplayExperience = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE;
							else
								character.roleplayExperience = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.CASUAL;
							end
						elseif field == "VA" then
							if value and value:find("/", nil, true) then
								character.client, character.clientVersion = value:match("^([^/;]+)/([^/;]+)");
								character.client = Utils.str.sanitize(character.client);
								character.clientVersion = Utils.str.sanitizeVersion(character.clientVersion);
							else
								character.client = UNKNOWN;
								character.clientVersion = "0";
							end
						elseif field == "TR" then
							character.isTrial = tonumber(value);
						end
					elseif MISC_FIELDS[field] then
						if field == "PE" and value then
							local peeks = {};
							local index = 1;
							for i = 1, 5 do
								local nextSplit, nextIndex = value:find("\n\n---\n\n", index, true);
								if not nextSplit then
									peeks[tostring(i)] = parsePeekString(value:sub(index, #value));
									break;
								else
									peeks[tostring(i)] = parsePeekString(value:sub(index, nextSplit));
								end
								index = nextIndex;
							end
							value = peeks;
						end
						if value then
							if not profile.misc then
								profile.misc = {};
							end
							profile.misc[MISC_FIELDS[field]] = value;
						end
					elseif MISC_INFO_FIELDS[field] then
						updateMiscInfoField(profile, field, value);
					elseif RP_STYLE_FIELDS[field] then
						UpdateRPStyleField(profile, field, value);
					end
				end
			end

			if color ~= false then
				profile.characteristics["CH"] = color;
			end

			TRP3_API.register.ui.sanitizeCharacteristics(profile.characteristics);
			TRP3_API.dashboard.sanitizeCharacter(profile.character)
			TRP3_API.register.ui.sanitizeMisc(profile.misc);

			TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, senderID, hasProfile(senderID), nil);
		end
	end);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Init
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	msp.my['VA'] = "TotalRP3/" .. Globals.version_display;
	msp.my['TR'] = tostring(AddOn_TotalRP3.Player.GetCurrentUser():GetAccountType());

	-- Init others vernum
	for _, profile in pairs(TRP3_API.register.getProfileList()) do
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
	updateMiscData();
	updateCharacterData();
	msp:Update();

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_DATA_UPDATED, function(_, unitID, _, dataType)
		if unitID == Globals.player_id then
			if not dataType or dataType == "about" or dataType == "characteristics" or dataType == "character" or dataType == "misc" then
				onProfileChanged();
			end
			if not dataType or dataType == "character" then
				onCharacterChanged();
			end
		end
	end);
	TRP3_API.RegisterCallback(TRP3_Addon, Events.MOUSE_OVER_CHANGED, function(_, unitID, targetMode)
		TRP3_API.r.sendMSPQuery(unitID, targetMode);
	end);
end

function TRP3_API.r.sendMSPQuery(name, targetMode)
	if msp_RPAddOn ~= "Total RP 3" then
		return;
	elseif not name or name == TRP3_API.globals.player_id or TRP3_API.register.isIDIgnored(name) then
		return;
	elseif targetMode and targetMode ~= AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		return;
	end

	local data = msp.char[name].field;

	if string.find(data.VA, "TotalRP3") then
		return;
	end

	-- Quick hack to fix the "double request" issue with our comms;
	-- previously it would be possible for requests to be sent via both
	-- TRP and MSP protocols. If this occurred at the same time, we
	-- effectively ended up doubling the comms needlessly in the worst
	-- case scenario.
	--
	-- To work around this, if we've not seen a unit (they have no VA
	-- field) we first send a "hello" request for just that field and
	-- mark the receiver in an outstanding requests table. When a response
	-- is received, we then re-send the request only if we're sure that
	-- the user is _not_ running TRP3.

	if data.VA == "" then
		outstandingHelloRequests[name] = true;
		msp:Request(name, { "VA" });
	else
		outstandingHelloRequests[name] = nil;
		msp:Request(name, AddOn_TotalRP3.MSP.REQUEST_FIELDS);
	end
end

local MODULE_STRUCTURE = {
	["name"] = "Mary Sue Protocol",
	["description"] = "MSP implementation for a compatibility with all MSP addons (MyRoleplay, FlagRSP, TotalRP2 ...)",
	["version"] = 2.000,
	["id"] = "trp3_msp",
	["onStart"] = onStart,
	["minVersion"] = 51,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
