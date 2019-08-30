----------------------------------------------------------------------------------
--- Total RP 3
--- Mary Sue Protocol implementation
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
--- Copyright / © 2018 Justin Snelgrove
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local function onStart()
	local loc = TRP3_API.loc;

	-- Check for already loaded MSP addon
	if msp_RPAddOn then
		TRP3_API.popup.showAlertPopup(loc.REG_MSP_ALERT:format(msp_RPAddOn));
		-- Provoke error to cancel module activation
		error(("Conflict with another MSP addon: %s"):format(msp_RPAddOn));
	end

	local Globals, Utils, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.events;
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
		msp.my['CU'] = character.CU;
		msp.my['CO'] = character.CO;
		if character.XP == 1 then
			msp.my['FR'] = "4";
		elseif character.XP == 2 then
			msp.my['FR'] = loc.DB_STATUS_RP_EXP;
		else
			msp.my['FR'] = loc.DB_STATUS_RP_VOLUNTEER;
		end
		if character.RP == 1 then
			msp.my['FC'] = "2";
		else
			msp.my['FC'] = "1";
		end

		msp.my["LC"] = character.LC;
	end

	local function removeTextTags(text)
		if text then
			text = Utils.str.convertTextTags(text);
			return text:gsub("%{link%*(.-)%*(.-)%}","[%2]( %1 )"); --cleanup links instead of outright removing the tag
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
		msp.my['IC'] = dataTab.IC or Globals.icons.profile_default;
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
		if dataTab.MI then
			for _, miscData in pairs(dataTab.MI) do
				if miscData.NA == loc.REG_PLAYER_MSP_MOTTO then
					msp.my['MO'] = miscData.VA;
				elseif miscData.NA == loc.REG_PLAYER_MSP_HOUSE then
					msp.my['NH'] = miscData.VA;
				elseif miscData.NA == loc.REG_PLAYER_MSP_NICK then
					msp.my['NI'] = miscData.VA;
				end
			end
		end

		msp.my['PS'] = AddOn_TotalRP3.MSP.SerializeField("PS", dataTab.PS);
	end

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

	local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
	local addCharacter, profileExists = TRP3_API.register.addCharacter, TRP3_API.register.profileExists;
	local isUnitIDKnown, getUnitIDCharacter = TRP3_API.register.isUnitIDKnown, TRP3_API.register.getUnitIDCharacter;
	local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
	local hasProfile, saveCurrentProfileID = TRP3_API.register.hasProfile, TRP3_API.register.saveCurrentProfileID;
	local emptyToNil, unitIDToInfo = Utils.str.emptyToNil, Utils.str.unitIDToInfo;

	local SUPPORTED_FIELDS = {
		"VA", "NA", "NH", "NI", "NT", "RA", "CU", "FR", "FC", "PX", "RC",
		"IC", "CO", "PE", "HH", "AG", "AE", "HB", "AH", "AW", "MO", "DE",
		"HI", "TR", "MU", "RS", "PS"
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
		LC = true,
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
		local icon = str:match("%f[^\n%z]|TInterface\\Icons\\([^:|]+)[^|]*|t%f[\n%z]") or "INV_Misc_QuestionMark";
		local title = str:match("%f[^\n%z]#+% *(.-)% *%f[\n%z]");
		local text = str:match("%f[^\n%z]% *([^|#].-)%s*$");
		return {
			AC = true,
			IC = icon,
			TI = title,
			TX = text,
		};
	end

	tinsert(msp.callback.received, function(senderID)
		local data = msp.char[senderID].field;
		if not isIgnored(senderID) and data.VA:sub(1, 8) ~= "TotalRP3" then
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
						-- Preserve empty class field.
						if not value and CHARACTERISTICS_FIELDS[field] == "CL" then
							value = " ";
						end
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
								profile.about.T3.HI = {BK = 1, IC = "INV_Misc_Book_17"};
							end
							if not profile.about.T3.PH then
								profile.about.T3.PH = {BK = 1, IC = "Ability_Warrior_StrengthOfArms"};
							end
							profile.about.T3[ABOUT_FIELDS[field]].TX = value;
							if profile.about.read ~= false then
								profile.about.read = not value or value == old;
							end
						end
					elseif CHARACTER_FIELDS[field] then
						if field == "FC" then
							if value == "1" then
								profile.character.RP = 2;
							else
								profile.character.RP = 1;
							end
						elseif field == "CU" then
							profile.character.CU = value;
						elseif field == "CO" then
							profile.character.CO = value;
						elseif field == "FR" then
							profile.character.XP = 2;
							if value == "4" then
								profile.character.XP = 1;
							end
						elseif field == "VA" then
							if value and value:find("/", nil, true) then
								character.client, character.clientVersion = value:match("^([^/;]+)/([^/;]+)");
							else
								character.client = UNKNOWN;
								character.clientVersion = "0";
							end
						elseif field == "TR" then
							character.isTrial = tonumber(value);
						elseif field == "LC" then
							profile.character.LC = value;
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
					elseif field == "MO" then
						if not profile.characteristics.MI then
							profile.characteristics.MI = {};
						end
						local index = #profile.characteristics.MI + 1;
						for miscIndex, miscStructure in pairs(profile.characteristics.MI) do
							if miscStructure.NA == loc.REG_PLAYER_MSP_MOTTO then
								index = miscIndex;
								break;
							end
						end
						if not profile.characteristics.MI[index] then
							if value then
								profile.characteristics.MI[index] = {};
							end
						else
							if value then
								wipe(profile.characteristics.MI[index]);
							else
								tremove(profile.characteristics.MI, index);
							end
						end
						if value then
							profile.characteristics.MI[index].NA = loc.REG_PLAYER_MSP_MOTTO;
							profile.characteristics.MI[index].VA = "\"" .. value .. "\"";
							profile.characteristics.MI[index].IC = "INV_Inscription_ScrollOfWisdom_01";
						end
					elseif field == "NH" then
						if not profile.characteristics.MI then
							profile.characteristics.MI = {};
						end
						local index = #profile.characteristics.MI + 1;
						for miscIndex, miscStructure in pairs(profile.characteristics.MI) do
							if miscStructure.NA == loc.REG_PLAYER_MSP_HOUSE then
								index = miscIndex;
								break;
							end
						end
						if not profile.characteristics.MI[index] then
							if value then
								profile.characteristics.MI[index] = {};
							end
						else
							if value then
								wipe(profile.characteristics.MI[index]);
							else
								tremove(profile.characteristics.MI, index);
							end
						end
						if value then
							profile.characteristics.MI[index].NA = loc.REG_PLAYER_MSP_HOUSE;
							profile.characteristics.MI[index].VA = value;
							profile.characteristics.MI[index].IC = "inv_misc_kingsring1";
						end
					elseif field == "NI" then
						if not profile.characteristics.MI then
							profile.characteristics.MI = {};
						end
						local index = #profile.characteristics.MI + 1;
						for miscIndex, miscStructure in pairs(profile.characteristics.MI) do
							if miscStructure.NA == loc.REG_PLAYER_MSP_NICK then
								index = miscIndex;
								break;
							end
						end
						if not profile.characteristics.MI[index] then
							if value then
								profile.characteristics.MI[index] = {};
							end
						else
							if value then
								wipe(profile.characteristics.MI[index]);
							else
								tremove(profile.characteristics.MI, index);
							end
						end
						if value then
							profile.characteristics.MI[index].NA = loc.REG_PLAYER_MSP_NICK;
							profile.characteristics.MI[index].VA = value;
							profile.characteristics.MI[index].IC = "Ability_Hunter_BeastCall";
						end
					end
				end
			end

			if color ~= false then
				profile.characteristics["CH"] = color;
			end

			Events.fireEvent(Events.REGISTER_DATA_UPDATED, senderID, hasProfile(senderID), nil);
		end
	end);

	local function requestInformation(targetID, targetMode)
		if not targetID then return end
		local data = msp.char[targetID].field;
		if targetID and targetMode == TYPE_CHARACTER
		and targetID ~= Globals.player_id
		and not isIgnored(targetID)
		and data.VA:sub(1, 8) ~= "TotalRP3"
		then
			msp:Request(targetID, AddOn_TotalRP3.MSP.REQUEST_FIELDS);
		end
	end

	TRP3_API.r.sendMSPQuery = function(name)
		-- This function has never had the checks that the above does. Whether
		-- it should or not should be revisited in the future.
		msp:Request(name, AddOn_TotalRP3.MSP.REQUEST_FIELDS);
	end

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

	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, _, dataType)
		if unitID == Globals.player_id then
			if not dataType or dataType == "about" or dataType == "characteristics" or dataType == "character" or dataType == "misc" then
				onProfileChanged();
			end
			if not dataType or dataType == "character" then
				onCharacterChanged();
			end
		end
	end);
	Events.listenToEvent(Events.MOUSE_OVER_CHANGED, requestInformation);

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
