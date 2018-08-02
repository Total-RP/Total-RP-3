----------------------------------------------------------------------------------
--- Total RP 3
---
--- Mary Sue Protocol implementation
---	---------------------------------------------------------------------------
---	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
--- © Justin Snelgrove
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------


local function onStart()
	local loc = TRP3_API.loc;

	-- Check for already loaded MSP addon
	if msp_RPAddOn then
		TRP3_API.popup.showAlertPopup(loc.REG_MSP_ALERT:format(msp_RPAddOn));
		-- Provoke error to cancel module activation
		error(("Conflict with another MSP addon: %s"):format(msp_RPAddOn));
	end

	local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
	local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;
	local tsize = Utils.table.size;
	local log = Utils.log.log;
	local getPlayerCharacter = TRP3_API.profile.getPlayerCharacter;
	local get, getCompleteName = TRP3_API.profile.getData, TRP3_API.register.getCompleteName;
	local isIgnored = TRP3_API.register.isIDIgnored;
	local onInformationReceived;
	local CONFIG_T3_ONLY = "msp_t3";

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LibMSP support code
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	msp_RPAddOn = "Total RP 3";
	msp:AddFieldsToTooltip({'PX', 'RC', 'IC', 'CO'});

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Update
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function updateCharacterData()
		local character = get("player/character");
		msp.my['CU'] = character.CU;
		msp.my['CO'] = character.CO;
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
			text = text:gsub("%{link%*(.-)%*(.-)%}","[%2]( %1 )"); --cleanup links instead of outright removing the tag
			return text:gsub("%{.-%}", "");
		end
	end

	local function updateAboutData()
		local dataTab = get("player/about");
		msp.my['DE'] = nil;
		msp.my['HI'] = nil;

		if getConfigValue(CONFIG_T3_ONLY) or dataTab.TE == 3 then
			msp.my['HI'] = dataTab.T3.HI.TX;
			msp.my['DE'] = dataTab.T3.PH.TX;
		elseif dataTab.TE == 1 then
			local text = Utils.str.convertTextTags(dataTab.T1.TX);
			msp.my['DE'] = removeTextTags(text);
		elseif dataTab.TE == 2 then
			local text;
			for _, data in pairs(dataTab.T2) do
				if not text then text = "" end
				text = text .. (data.TX or "") .. "\n\n";
			end
			msp.my['DE'] = text;
		end
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
	end

	local function updateMiscData()
		local dataTab = get("player/misc");
		local peeks = {};
		for i = 1, 5 do
			local peek = dataTab.PE[tostring(i)];
			if peek and peek.AC then
				if i > 1 then
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
	local addCharacter, profileExists = TRP3_API.register.addCharacter, TRP3_API.register.profileExists;
	local isUnitIDKnown, getUnitIDCharacter = TRP3_API.register.isUnitIDKnown, TRP3_API.register.getUnitIDCharacter;
	local getUnitIDProfile, createUnitIDProfile = TRP3_API.register.getUnitIDProfile, TRP3_API.register.createUnitIDProfile;
	local hasProfile, saveCurrentProfileID = TRP3_API.register.hasProfile, TRP3_API.register.saveCurrentProfileID;
	local emptyToNil, unitIDToInfo = Utils.str.emptyToNil, Utils.str.unitIDToInfo;

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
		IC = "IC",
	}

	local CHARACTER_FIELDS = {
		FR = true, FC = true, CU = true, VA = true, CO = true,
	}

	local MISC_FIELDS = {
		PE = "PE",
	}

	local ABOUT_FIELDS = {
		HI = "HI",
		DE = "PH",
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
		local icon = str:match("^%s*|TInterface\\Icons\\([^:|]+)") or "TEMP";
		str = str:gsub("^%s*|T.-|t%s*", "");
		local title = str:match("^#([^\n]+)");
		if title then
			title = title:trim();
		end
		str = str:gsub("^#[^\n]+%s*", "");
		local text = str:trim();
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

			-- And only after all these checks, store data !
			local updatedCharacteristics, updatedAbout, updatedCharacter = false, false, false;
			local color;
			for field, value in pairs(data) do
				-- Save version
				profile.mspver[field] = msp.char[senderID].ver[field];

				-- Save fields
				if CHARACTERISTICS_FIELDS[field] then
					updatedCharacteristics = true;
					-- NA/RC color escaping
					if (field == "NA" or field == "RC") and value then
						if not color then
							color = value:match("|c%x%x(%x%x%x%x%x%x)");
						end
						value = value:gsub("|c%x%x%x%x%x%x%x%x", "");
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
					-- We do not want to trim the class field
					-- Some users are using a space to indicate they don't have a class
					if CHARACTERISTICS_FIELDS[field] ~= "CL" then
						value = strtrim(value);
					end
					profile.characteristics[CHARACTERISTICS_FIELDS[field]] = emptyToNil(value);
					-- Hack for spaced name tolerated in MRP
					if field == "NA" and not profile.characteristics[CHARACTERISTICS_FIELDS[field]] then
						profile.characteristics[CHARACTERISTICS_FIELDS[field]] = unitIDToInfo(senderID);
					end
				elseif ABOUT_FIELDS[field] then
					updatedAbout = true;
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
					value = emptyToNil(strtrim(value));
					profile.about.T3[ABOUT_FIELDS[field]].TX = value;
					profile.about.read = value == old or value == nil or value:len() == 0;
				elseif CHARACTER_FIELDS[field] then
					updatedCharacter = true;
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
					elseif field == "VA" and value:find("%/") then
						character.client = value:sub(1, value:find("%/") - 1);
						character.clientVersion = value:sub(value:find("%/") + 1);
					end
				elseif MISC_FIELDS[field] then
					updatedCharacter = true;
					if field == "PE" then
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
						if not profile.misc then
							profile.misc = {};
						end
						profile.misc.PE = peeks;
					end
				elseif field == "MO" then
					if strtrim(value):len() ~= 0 then
						if not profile.characteristics.MI then
							profile.characteristics.MI = {};
						end
						local index = #profile.characteristics.MI + 1;
						for miscIndex, miscStructure in pairs(profile.characteristics.MI) do
							if miscStructure.NA == loc.REG_PLAYER_MSP_MOTTO then
								index = miscIndex;
							end
						end
						if not profile.characteristics.MI[index] then
							profile.characteristics.MI[index] = {};
						else
							wipe(profile.characteristics.MI[index]);
						end
						profile.characteristics.MI[index].NA = loc.REG_PLAYER_MSP_MOTTO;
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
							if miscStructure.NA == loc.REG_PLAYER_MSP_HOUSE then
								index = miscIndex;
							end
						end
						if not profile.characteristics.MI[index] then
							profile.characteristics.MI[index] = {};
						else
							wipe(profile.characteristics.MI[index]);
						end
						profile.characteristics.MI[index].NA = loc.REG_PLAYER_MSP_HOUSE;
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
							if miscStructure.NA == loc.REG_PLAYER_MSP_NICK then
								index = miscIndex;
							end
						end
						if not profile.characteristics.MI[index] then
							profile.characteristics.MI[index] = {};
						else
							wipe(profile.characteristics.MI[index]);
						end
						profile.characteristics.MI[index].NA = loc.REG_PLAYER_MSP_NICK;
						profile.characteristics.MI[index].VA = value;
						profile.characteristics.MI[index].IC = "Ability_Hunter_BeastCall";
					end
				end
			end

			profile.characteristics["CH"] = color;

			if updatedCharacter or updatedCharacteristics or updatedAbout then
				Events.fireEvent(Events.REGISTER_DATA_UPDATED, senderID, hasProfile(senderID), nil);
			end
		end
	end);

	local REQUEST_TAB = {"TT", "PE", "HH", "AG", "AE", "HB", "AH", "AW", "MO", "DE", "HI"};

	local function requestInformation(targetID, targetMode)
		if not targetID then return end
		local data = msp.char[targetID].field;
		if targetID and targetMode == TYPE_CHARACTER
		and targetID ~= Globals.player_id
		and not isIgnored(targetID)
		and data.VA:sub(1, 8) ~= "TotalRP3"
		then
			msp:Request(targetID, REQUEST_TAB);
		end
	end

	TRP3_API.r.sendMSPQuery = function(name)
		local request = {};
		tinsert(request, "TT");
		for _, field in pairs(REQUEST_TAB) do
			tinsert(request, field);
		end
		msp:Request(name, request);
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Init
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	msp.my['VA'] = "TotalRP3/" .. Globals.version_display;

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

	-- Build configuration page
	registerConfigKey(CONFIG_T3_ONLY, false);
	registerConfigHandler(CONFIG_T3_ONLY, onAboutChanged);
	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_MSP,
	});
	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_MSP_T3,
		help = loc.CO_MSP_T3_TT,
		configKey = CONFIG_T3_ONLY,
	});

	-- Initial update
	updateCharacteristicsData();
	onProfileChanged();
	onCharacterChanged();

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
	Events.listenToEvent(Events.REGISTER_PROFILE_DELETED, function(profileID, mspOwners)
		if mspOwners then
			for _, ownerID in pairs(mspOwners) do
				msp.char[ownerID] = nil;
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
