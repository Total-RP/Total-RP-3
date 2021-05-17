--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local function CaseInsensitiveEqualsAny(needle, ...)
	for i = 1, select("#", ...) do
		local haystack = (select(i, ...));

		if strcmputf8i(needle, haystack) == 0 then
			return true;
		end
	end

	return false;
end

local function GetPlayerObjectForCharacter(characterID)
	if characterID == TRP3_API.globals.player_id then
		return AddOn_TotalRP3.Player.GetCurrentUser();
	else
		return AddOn_TotalRP3.Player.CreateFromCharacterID(characterID);
	end
end

--
-- Sanitization Utilities
--

local function ConvertToPlainText(text)
	if type(text) ~= "string" then
		text = "";
	end

	text = TRP3_API.utils.str.sanitize(text);
	text = string.trim(text);

	return text;
end

local function ConvertToColoredText(text, color)
	text = ConvertToPlainText(text);

	if type(color) == "string" and #color == 6 and text ~= "" then
		text = string.format("|cff%s%s|r", color, text);
	end

	return text;
end

local function ConvertToRichText(text)
	if type(text) ~= "string" then
		text = "";
	end

	text = ConvertToPlainText(text);
	text = TRP3_API.utils.str.convertTextTags(text);
	text = string.gsub(text, "%{link%*(.-)%*(.-)%}", "[%2]( %1 )");

	return text;
end

local function ConvertToIconName(icon, default)
	if type(icon) == "string" and GetFileIDFromPath([[Interface\Icons\]] .. icon) then
		return icon;
	else
		return default or TRP3_InterfaceIcons.Default;
	end
end

local function ConvertToHexColor(color)
	if type(color) ~= "table" then
		return "";
	end

	local r = Saturate(tonumber(color.r) or 1);
	local g = Saturate(tonumber(color.g) or 1);
	local b = Saturate(tonumber(color.b) or 1);

	return string.format("%02x%02x%02x", r * 255, g * 255, b * 255);
end

--
-- Serialization Utilities
--

local function FindMiscInfoFieldByTitle(title)
	local function Predicate(fieldInfo)
		local englishText = GetValueOrCallFunction(fieldInfo, "englishText");
		local localizedText = GetValueOrCallFunction(fieldInfo, "localizedText");

		return CaseInsensitiveEqualsAny(title, englishText, localizedText);
	end;

	return select(2, FindInTableIf(TRP3_MSPMiscFieldInfo, Predicate));
end

local function EnumerateActiveGlances(glances)
	if type(glances) ~= "table" then
		glances = {};
	end

	local function NextGlance(glances, index)  -- luacheck: no redefined (glances)
		while index < TRP3_API.globals.MAX_GLANCE_COUNT do
			index = index + 1;

			local glance = glances[tostring(index)];

			if glance and glance.AC then
				return index, glance;
			end
		end
	end

	return NextGlance, glances, 0;
end

local function SerializePersonalityTrait(trait)
	--
	-- The PS field is serialized to the form:
	--    attr  := ident "=" quoted-value
	--    trait := "[trait" { " " attr } "]"
	--
	-- Where `ident` is just an ASCII string identifier like "name" or "icon"
	-- with support for limited special characters (-, _), and `quoted-value`
	-- is a value wrapped in double quotes.
	--
	-- For now, there's no support for escaping " characters in quoted-values.
	--
	-- Example:
	--    [trait id="3" value="0.75"]
	--    [trait value="0.4" left-name="My Left Trait" right-name="My Right Trait"]
	--
	-- A newline may be present between individual trait pairs but isn't
	-- required.
	--
	-- In terms of attributes, the following are supported:
	--    id: Numeric identifier for a standard trait.
	--    value: [0-1] floating point number for the strength of this trait.
	--    (left|right)-name: Name of a custom trait.
	--    (left|right)-icon: Name of a custom icon for this trait.
	--    (left|right)-color: Hexadecimal color code for this trait.
	--

	local fields = {};

	local value = trait.V2 / TRP3_API.globals.PSYCHO_MAX_VALUE_V2;
	table.insert(fields, string.format("value=\"%.2f\"", value));

	if trait.ID and trait.ID >= 1 and trait.ID <= #TRP3_MSPPersonalityTraits then
		-- This is a builtin preset trait; thankfully all our preset IDs
		-- currently map 1:1 to the MSP preset IDs.

		table.insert(fields, string.format("id=%q", trait.ID));

	elseif not trait.ID then
		-- Custom trait, these may have additional color data to be sent.

		local leftName;
		local leftIcon;
		local leftColor;
		local rightName;
		local rightIcon;
		local rightColor;

		leftName = ConvertToPlainText(trait.LT);
		leftName = string.gsub(leftName, "[%]\"]", "");
		leftIcon = ConvertToIconName(trait.LI, TRP3_InterfaceIcons.Default);
		leftColor = ConvertToHexColor(trait.LC or TRP3_API.globals.PSYCHO_DEFAULT_LEFT_COLOR:GetRGBTable());

		rightName = ConvertToPlainText(trait.RT);
		rightName = string.gsub(rightName, "[%]\"]", "");
		rightIcon = ConvertToIconName(trait.RI, TRP3_InterfaceIcons.Default);
		rightColor = ConvertToHexColor(trait.RC or TRP3_API.globals.PSYCHO_DEFAULT_RIGHT_COLOR:GetRGBTable());

		table.insert(fields, string.format("left-name=%q", leftName));
		table.insert(fields, string.format("left-icon=%q", leftIcon));
		table.insert(fields, string.format("left-color=%q", leftColor));
		table.insert(fields, string.format("right-name=%q", rightName));
		table.insert(fields, string.format("right-icon=%q", rightIcon));
		table.insert(fields, string.format("right-color=%q", rightColor));
	end

	return string.format("[trait %s]", table.concat(fields, " "));
end

--
-- Deserialization Utilities
--

local function ParseSingleGlance(str)
	local icon   = ConvertToIconName(string.match(str, "%f[^\n%z]|TInterface\\Icons\\([^:|]+)[^|]*|t%f[\n%z]"));
	local title  = ConvertToPlainText(string.match(str, "%f[^\n%z]#+% *(.-)% *%f[\n%z]"));
	local text   = ConvertToPlainText(string.match(str, "%f[^\n%z]% *([^|#].-)%s*$"));
	local active = (icon ~= TRP3_InterfaceIcons.Default or title ~= "" or text ~= "");

	return {
		AC = active,
		IC = icon,
		TI = title,
		TX = text,
	};
end

local function ParseGlances(str)
	local offset = 1;
	local length = #str;
	local count  = 0;

	local function NextGlanceFromString()
		if offset > length then
			return;
		end

		local delimiterStart, delimiterEnd = string.find(str, "\n\n---\n\n", offset, true);
		local glance;

		if delimiterStart then
			glance = string.sub(str, offset, delimiterStart);
			offset = delimiterEnd;
		else
			glance = string.sub(str, offset);
			offset = length + 1;
		end

		count = count + 1;

		return count, ParseSingleGlance(glance);
	end

	return NextGlanceFromString;
end

local function DeserializePersonalityTraits(traitString)
	if traitString == "" then
		return nil;
	end

	local traits = {};

	for traitPiece in string.gmatch(traitString, "%[trait [^%]]-%]") do
		local traitInfo = {};

		-- Process each attr="value" pair.
		for key, value in string.gmatch(traitPiece, "([%w_-]+)=\"([^\"]*)\"") do
			if key == "id" then
				traitInfo.ID = tonumber(value);
			elseif key == "value" then
				traitInfo.VA = math.floor(tonumber(value) * TRP3_API.globals.PSYCHO_MAX_VALUE_V1);
				traitInfo.V2 = math.floor(tonumber(value) * TRP3_API.globals.PSYCHO_MAX_VALUE_V2);
			elseif key == "left-name" then
				traitInfo.LT = ConvertToPlainText(value);
			elseif key == "left-icon" then
				traitInfo.LI = ConvertToIconName(value);
			elseif key == "left-color" then
				local r, g, b = Ellyb.ColorManager.hexaToNumber(value);
				traitInfo.LC = { r = r, g = g, b = b };
			elseif key == "right-name" then
				traitInfo.RT = ConvertToPlainText(value);
			elseif key == "right-icon" then
				traitInfo.RI = ConvertToIconName(value);
			elseif key == "right-color" then
				local r, g, b = Ellyb.ColorManager.hexaToNumber(value);
				traitInfo.RC = { r = r, g = g, b = b };
			end
		end

		-- Clear anything that isn't relevant for a builtin trait, and
		-- default things that are missing for custom ones.

		if traitInfo.ID then
			-- If it's a built-in clear any extraenous junk.
			traitInfo.LT = nil;
			traitInfo.LI = nil;
			traitInfo.LC = nil;
			traitInfo.RT = nil;
			traitInfo.RI = nil;
			traitInfo.RC = nil;
		elseif traitInfo.LT and traitInfo.RT then
			-- It's custom, default any missing fields.
			traitInfo.LI = traitInfo.LI or TRP3_InterfaceIcons.Default;
			traitInfo.LC = traitInfo.LC or TRP3_API.globals.PSYCHO_DEFAULT_LEFT_COLOR:GetRGBTable();
			traitInfo.RI = traitInfo.RI or TRP3_InterfaceIcons.Default;
			traitInfo.RC = traitInfo.RC or TRP3_API.globals.PSYCHO_DEFAULT_RIGHT_COLOR:GetRGBTable();
		end

		-- Only register traits that are valid. If the ID or custom names
		-- are missing, or the value isn't present we'll ignore it.

		if (traitInfo.ID or (traitInfo.LT and traitInfo.RT)) and traitInfo.V2 then
			table.insert(traits, traitInfo);
		end
	end

	return traits;
end

--
-- MSP Utilities
--

TRP3_MSPUtil = {};

function TRP3_MSPUtil.RegisterAddOnVersion(addonName, addonVersion)
	local contents = msp.my.VA or "";
	local identifier = string.join("/", addonName, addonVersion);

	if contents == "" then
		msp.my.VA = identifier;
	elseif not string.find(contents, addonName, 1, true) then
		msp.my.VA = string.join(";", identifier, contents);
	end
end

function TRP3_MSPUtil.GetFieldTableForCharacter(characterID)
	if characterID == TRP3_API.globals.player_id then
		return msp.my;
	else
		return msp.char[characterID].field;
	end
end

function TRP3_MSPUtil.GenerateProfileIDForCharacter(characterID)
	local character = msp.char[characterID];

	-- The contents of the VI field are preferred for explicit profile IDs
	-- when supplied; otherwise we'll use the old format.

	if character.field.VI ~= "" then
		return "[MSP]" .. character.field.VI;
	else
		return "[MSP]" .. characterID;
	end
end

function TRP3_MSPUtil.GetRegisterCharacter(characterID)
	if not TRP3_API.register.isUnitIDKnown(characterID) then
		return nil;  -- Character isn't known.
	end

	local character = TRP3_API.register.getUnitIDCharacter(characterID);

	if not character.msp then
		return nil;  -- Character isn't associated with an MSP profile.
	end

	return character;
end

function TRP3_MSPUtil.GetRegisterProfile(characterID)
	local character = TRP3_MSPUtil.GetRegisterCharacter(characterID);

	if not character then
		return nil;  -- Character isn't known.
	elseif not TRP3_API.register.profileExists(characterID) then
		return nil;  -- Character has no profile.
	end

	local profile = TRP3_API.register.getProfile(character.profileID);
	return profile;
end

function TRP3_MSPUtil.GetOrCreateRegisterProfile(characterID)
	if not TRP3_API.register.isUnitIDKnown(characterID) then
		TRP3_API.register.addCharacter(characterID);
	end

	local character = TRP3_API.register.getUnitIDCharacter(characterID);

	character.msp = true;
	character.profileID = TRP3_MSPUtil.GenerateProfileIDForCharacter(characterID);

	if not TRP3_API.register.profileExists(characterID) then
		TRP3_API.register.saveCurrentProfileID(characterID, character.profileID, true);
	end

	local profile = TRP3_API.register.getProfile(character.profileID);
	return profile;
end

function TRP3_MSPUtil.LoadCharacterData(characterID, output)
	local player = GetPlayerObjectForCharacter(characterID);
	local source = player:GetInfo("character");

	if type(source) ~= "table" then
		source = {};
	end

	output.CU = ConvertToPlainText(source.CU);  -- Currently
	output.CO = ConvertToPlainText(source.CO);  -- OOC

	-- Roleplay Experience

	if source.XP == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.BEGINNER then
		output.FR = "4";
	elseif source.XP == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.EXPERIENCED then
		output.FR = L.DB_STATUS_RP_EXP;
	elseif source.XP == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.VOLUNTEER then
		output.FR = L.DB_STATUS_RP_VOLUNTEER;
	else
		output.FR = nil;
	end

	-- Character Status

	if source.RP == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER then
		output.FC = "2";
	elseif source.RP == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		output.FC = "1";
	else
		output.FC = nil;
	end

	-- Profile ID

	local profileID = player:GetProfileID();

	if profileID then
		output.VI = string.join(":", tostringall(TRP3_MSPAddOnID, profileID));
	else
		output.VI = nil;
	end
end

function TRP3_MSPUtil.LoadAboutData(characterID, output)
	local player = GetPlayerObjectForCharacter(characterID);
	local source = player:GetInfo("about");

	if type(source) ~= "table" then
		source = {};
	end

	output.MU = source.MU and tostring(source.MU) or nil;  -- Music
	output.DE = nil;  -- Physical Description
	output.HI = nil;  -- History

	if source.TE == 1 and type(source.T1) == "table" then
		output.DE = ConvertToRichText(source.T1.TX);
	elseif source.TE == 2 and type(source.T2) == "table" then
		local blocks = {};

		for _, block in ipairs(source.T2) do
			local TX = ConvertToRichText(block.TX);

			if TX ~= "" then
				table.insert(blocks, TX);
			end
		end

		output.DE = table.concat(blocks, "\n\n---\n\n");
	elseif source.TE == 3 and type(source.T3) == "table" then
		local HI = ConvertToRichText(source.T3.HI and source.T3.HI.TX or "");
		local PH = ConvertToRichText(source.T3.PH and source.T3.PH.TX or "");
		local PS = ConvertToRichText(source.T3.PS and source.T3.PS.TX or "");

		output.HI = HI;
		output.DE = string.format("#Physical Description\n\n%s\n\n---\n\n#Personality traits\n\n%s", PH, PS);
	end
end

function TRP3_MSPUtil.LoadCharacteristicsData(characterID, output)
	local player = GetPlayerObjectForCharacter(characterID);
	local source = player:GetInfo("characteristics");

	if type(source) ~= "table" then
		source = {};
	end

	output.NA = ConvertToColoredText(player:GetRoleplayingName(), source.CH);  -- Name
	output.NT = ConvertToPlainText(source.FT);  -- Full title
	output.PX = ConvertToPlainText(source.TI);  -- Prefix title
	output.RA = ConvertToPlainText(source.RA);  -- Race
	output.RC = ConvertToColoredText(source.CL, source.CH);  -- Class
	output.IC = ConvertToIconName(source.IC, TRP3_InterfaceIcons.ProfileDefault);  -- Icon
	output.AE = ConvertToColoredText(source.EC, source.EH);  -- Eye color
	output.AG = ConvertToPlainText(source.AG);  -- Age
	output.AH = ConvertToPlainText(source.HE);  -- Height
	output.AW = ConvertToPlainText(source.WE);  -- Weight
	output.HH = ConvertToPlainText(source.RE);  -- Residence
	output.HB = ConvertToPlainText(source.BP);  -- Birthplace

	-- Relationship Status
	output.RS = tostring(tonumber(source.RS) or AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.UNKNOWN);

	-- Personality Traits

	output.PS = nil;

	if type(source.PS) == "table" then
		local traits = {};

		for _, trait in ipairs(source.PS) do
			table.insert(traits, SerializePersonalityTrait(trait));
		end

		output.PS = table.concat(traits, "\n");
	end

	-- Misc Info fields (Motto, House Name, Nickname, Pronouns)

	output.MO = nil;
	output.NH = nil;
	output.NI = nil;
	output.PN = nil;

	if type(source.MI) == "table" then
		for _, miscData in pairs(source.MI) do
			local fieldInfo = FindMiscInfoFieldByTitle(miscData.NA);

			if fieldInfo then
				output[fieldInfo.field] = ConvertToPlainText(miscData.VA);
			end
		end
	end
end

function TRP3_MSPUtil.LoadMiscData(characterID, output)
	local player = GetPlayerObjectForCharacter(characterID);
	local source = player:GetInfo("misc");

	if type(source) ~= "table" then
		source = {};
	end

	-- Glances

	if source.PE then
		local glances = {};

		for _, glanceInfo in EnumerateActiveGlances(source.PE) do
			local GLANCE_FORMAT = "|TInterface\\Icons\\%1$s:32:32|t\n#%2$s\n\n%3$s";

			local glanceIcon = ConvertToIconName(glanceInfo.IC);
			local glanceTitle = ConvertToPlainText(glanceInfo.TI);
			local glanceText = ConvertToPlainText(glanceInfo.TX);
			local glanceString = string.format(GLANCE_FORMAT, glanceIcon, glanceTitle, glanceText);

			table.insert(glances, glanceString);
		end

		output.PE = table.concat(glances, "\n\n---\n\n");
	else
		output.PE = nil;
	end
end

function TRP3_MSPUtil.LoadDataForCharacter(characterID)
	local output = TRP3_MSPUtil.GetFieldTableForCharacter(characterID);

	TRP3_MSPUtil.LoadCharacterData(characterID, output);
	TRP3_MSPUtil.LoadAboutData(characterID, output);
	TRP3_MSPUtil.LoadCharacteristicsData(characterID, output);
	TRP3_MSPUtil.LoadMiscData(characterID, output);
end

function TRP3_MSPUtil.ReadCharacterData(characterID, output)
	local source = TRP3_MSPUtil.GetFieldTableForCharacter(characterID);

	if type(output) ~= "table" then
		output = {};
	end

	output.CU = ConvertToPlainText(source.CU);  -- Currently
	output.CO = ConvertToPlainText(source.CO);  -- OOC text

	-- Character status

	if source.FC == "1" then
		output.RP = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
	else
		output.RP = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
	end

	-- Roleplay Experience

	if source.FR == "4" then
		output.XP = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.EXPERIENCED;
	else
		output.XP = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.BEGINNER;
	end

	return output;
end

function TRP3_MSPUtil.ReadAboutData(characterID, output)
	local source = TRP3_MSPUtil.GetFieldTableForCharacter(characterID);

	if type(output) ~= "table" then
		output = {};
	end

	-- Music

	if tonumber(source.MU) then
		output.MU = tonumber(source.MU);
	elseif source.MU ~= "" then
		output.MU = TRP3_API.utils.music.convertPathToID(source.MU);
	else
		output.MU = nil;
	end

	-- About text
	-- This is always forced to a T3 layout.

	output.BK = 5;  -- Background
	output.TE = 3;  -- Template
	output.T1 = nil;
	output.T2 = nil;

	if type(output.T3) ~= "table" then
		output.T3 = {};
	end

	if type(output.T3.HI) ~= "table" then
		output.T3.HI = {};
	end

	if type(output.T3.PH) ~= "table" then
		output.T3.PH = {};
	end

	local currentHistoryText = output.T3.HI.TX or "";
	local currentDescriptionText = output.T3.PH.TX or "";
	local currentReadState = not not output.read;

	output.T3.HI.BK = 1;
	output.T3.HI.IC = TRP3_InterfaceIcons.HistorySection;
	output.T3.HI.TX = source.HI;

	output.T3.PH.BK = 1;
	output.T3.PH.IC = TRP3_InterfaceIcons.PhysicalSection;
	output.T3.PH.TX = source.DE;

	-- If either text field changed we should clear the read state, otherwise
	-- keep the existing one.

	if source.HI == "" and source.DE == "" then
		output.read = true;
	elseif currentHistoryText ~= source.HI and currentDescriptionText ~= source.DE then
		output.read = false;
	else
		output.read = currentReadState;
	end

	return output;
end

function TRP3_MSPUtil.ReadCharacteristicsData(characterID, output)
	local source = TRP3_MSPUtil.GetFieldTableForCharacter(characterID);

	if type(output) ~= "table" then
		output = {};
	end

	output.FT = ConvertToPlainText(source.NT);  -- Full title
	output.RA = ConvertToPlainText(source.RA);  -- Race
	output.AG = ConvertToPlainText(source.AG);  -- Age
	output.IC = ConvertToIconName(source.IC);   -- Icon
	output.RE = ConvertToPlainText(source.HH);  -- Residence
	output.BP = ConvertToPlainText(source.HB);  -- Birthplace
	output.RS = tonumber(source.RS);            -- Relationship status

	output.PS = DeserializePersonalityTraits(source.PS);  -- Personality traits

	do  -- Name and Prefix title
		local name = ConvertToPlainText(msp.char[characterID].field.NA);
		local prefix = ConvertToPlainText(msp.char[characterID].field.PX);

		-- Strip the prefix title from the name if present.

		if string.find(name, prefix .. " ", 1, true) == 1 then
			name = string.sub(name, #prefix + 2);
			name = string.trim(name);
		end

		-- The title is set to nil explicitly due to a UI bug in the that
		-- causes names to be shunted over a bit if the title is an empty
		-- string.

		output.FN = name;
		output.TI = prefix ~= "" and prefix or nil
	end


	do  -- Class and class color
		local class = source.RC;
		local color = string.match(class, "|c%x%x(%x%x%x%x%x%x)");

		-- If no color is part of the class name, try the character name.

		if not color then
			color = color or string.match(source.NA, "|c%x%x(%x%x%x%x%x%x)");
		end

		output.CL = ConvertToPlainText(class);
		output.CH = color;
	end

	do  -- Eye color
		local text = source.AE;
		local color = string.match(text, "|c%x%x(%x%x%x%x%x%x)");

		output.EC = ConvertToPlainText(text);
		output.EH = color;
	end

	do  -- Height and Weight
		local height = tonumber(source.AW) or source.AW;
		local weight = tonumber(source.AH) or source.AH;

		if type(height) == "number" then
			height = tostring(height) .. " cm";
		end

		if type(weight) == "number" then
			weight = tostring(weight) .. " kg";
		end

		output.HE = ConvertToPlainText(height);
		output.WE = ConvertToPlainText(weight);
	end

	do  -- Misc. Info
		if type(output.MI) ~= "table" then
			output.MI = {};
		end

		for _, fieldInfo in ipairs(TRP3_MSPMiscFieldInfo) do
			local miscValue = source[fieldInfo.field];
			local miscIndex = FindInTableIf(output.MI, function(miscStruct)
				local englishText = GetValueOrCallFunction(fieldInfo, "englishText");
				local localizedText = GetValueOrCallFunction(fieldInfo, "localizedText");

				return CaseInsensitiveEqualsAny(miscStruct.NA, englishText, localizedText);
			end);

			if miscValue ~= "" then
				-- We've got data for this field that either needs to replace
				-- an existing found row at miscIndex, or should be appended
				-- to the list.

				local miscStruct = output.MI[miscIndex] or {};

				miscStruct.NA = ConvertToPlainText(GetValueOrCallFunction(fieldInfo, "localizedText"));
				miscStruct.IC = ConvertToIconName(fieldInfo.icon);

				if fieldInfo.formatter then
					miscStruct.VA = ConvertToPlainText(fieldInfo.formatter(miscValue));
				else
					miscStruct.VA = ConvertToPlainText(miscValue);
				end

				if not miscIndex then
					table.insert(output.MI, miscStruct);
				end
			elseif miscIndex then
				-- We've got existing data for this field that needs clearing.
				table.remove(output.MI, miscIndex);
			end
		end

	end

	return output;
end

function TRP3_MSPUtil.ReadMiscData(characterID, output)
	local source = TRP3_MSPUtil.GetFieldTableForCharacter(characterID);

	if type(output) ~= "table" then
		output = {};
	end

	-- Glances

	output.PE = {};

	for index, glance in ParseGlances(source.PE) do
		output.PE[tostring(index)] = glance;
	end

	return output;
end

function TRP3_MSPUtil.StoreDataForCharacter(characterID)
	local profile = TRP3_MSPUtil.GetOrCreateRegisterProfile(characterID);

	if type(profile.characteristics) ~= "table" then
		profile.characteristics = {};
	end

	if type(profile.about) ~= "table" then
		profile.about = {};
	end

	if type(profile.character) ~= "table" then
		profile.character = {};
	end

	if type(profile.misc) ~= "table" then
		profile.misc = {};
	end

	profile.character = TRP3_MSPUtil.ReadCharacterData(characterID, profile.character);
	profile.about = TRP3_MSPUtil.ReadAboutData(characterID, profile.about);
	profile.characteristics = TRP3_MSPUtil.ReadCharacteristicsData(characterID, profile.characteristics);
	profile.misc = TRP3_MSPUtil.ReadMiscData(characterID, profile.misc);

	-- The addon versions and trial field are stored at a character level
	-- and need special handling.

	local character = TRP3_MSPUtil.GetRegisterCharacter(characterID);

	do
		local source = TRP3_MSPUtil.GetFieldTableForCharacter(characterID);

		-- RP AddOn
		local client, version = string.match(source.VA, "([^/]+)/([^;]+)");

		if client then
			character.client = client;
			character.clientVersion = version;
		else
			character.client = UNKNOWN;
			character.clientVersion = "0";
		end

		-- Trial Status
		character.isTrial = tonumber(source.TR);
	end

	TRP3_API.events.fireEvent("REGISTER_DATA_UPDATED", characterID, character.profileID, nil);
end
