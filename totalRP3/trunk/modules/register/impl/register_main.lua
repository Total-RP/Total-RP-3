--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Main section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local color = TRP3_Color;
local loc = TRP3_L;

-- Saved variables references
local profiles;
local profileLinks;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_RegisterInfoTypes = {
	CHARACTERISTICS = "characteristics",
	ABOUT = "about",
	STYLE = "style",
	MISC = "misc"
}

TRP3_GetDefaultProfile().player = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_IncrementVersion(version, figures)
	local incremented = version + 1;
	if incremented >= math.pow(10, figures) then
		incremented = 1;
	end
	return incremented;
end

function TRP3_IsPlayerKnown(unitName)
	local unitID = TRP3_GetUnitID(unitName);
	return profileLinks[unitID] ~= nil;
end

function TRP3_IsPlayerIgnored(unitName)
	local unitID = TRP3_GetUnitID(unitName);
	-- TODO: also block unitID
	return TRP3_IsPlayerKnown(unitName) and profiles[profileLinks[unitID]].ignored == true;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Main data management
-- For decoupling reasons, the saved variable TRP3_Register shouln'd be used outside this file !
-- Please use all these public method instead.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_RegisterShouldUpdateInfo(unitName, infoType, version)
	local unitID = TRP3_GetUnitID(unitName);
	assert(profiles[unitID], "Unknown character: " .. tostring(unitID));
	if not profiles[unitID].currentProfileID or not profiles[unitID].profiles[profiles[unitID].currentProfileID] then
		return true; -- If we don't have any information about its current profile, yes we should update.
	end
	local unitProfile = profiles[unitID].profiles[profiles[unitID].currentProfileID];
	return not unitProfile[infoType] or not unitProfile[infoType].v or unitProfile[infoType].v ~= version;
end

function TRP3_RegisterSetCurrentProfile(unitName, currentProfileID)
	local unitID = TRP3_GetUnitID(unitName);
	assert(profiles[unitID], "Unknown character: " .. tostring(unitID));
	local old = profiles[unitID].currentProfileID;
	profiles[unitID].currentProfileID = currentProfileID;
	if old ~= profiles[unitID].currentProfileID then
		TRP3_ShouldRefreshTooltip(unitName);
	end
end

function TRP3_RegisterSetClient(unitName, client, clientVersion)
	local unitID = TRP3_GetUnitID(unitName);
	assert(profiles[unitID], "Unknown character: " .. tostring(unitID));
	profiles[unitID].client = client;
	profiles[unitID].clientVersion = clientVersion;
end

function TRP3_RegisterSetMainInfo(unitName, race, class, gender, faction, time, zone)
	local unitID = TRP3_GetUnitID(unitName);
	assert(profiles[unitID], "Unknown character: " .. tostring(unitID));
	if not profiles[unitID].info then 
		profiles[unitID].info = {};
	end
	profiles[unitID].info.class = class;
	profiles[unitID].info.race = race;
	profiles[unitID].info.gender = gender;
	profiles[unitID].info.faction = faction;
	profiles[unitID].info.time = time;
	profiles[unitID].info.zone = zone;
end

function TRP3_RegisterSetInforType(unitName, informationType, data)
	local unitID = TRP3_GetUnitID(unitName);
	assert(profiles[unitID], "Unknown character: " .. tostring(unitID));
	assert(profiles[unitID].currentProfileID, "Unknown current profile: " .. tostring(unitID));
	if not profiles[unitID].profiles[profiles[unitID].currentProfileID] then
		profiles[unitID].profiles[profiles[unitID].currentProfileID] = {};
	end
	local unitProfile = profiles[unitID].profiles[profiles[unitID].currentProfileID];
	if unitProfile[informationType] then
		wipe(unitProfile[informationType]);
	end
	unitProfile[informationType] = data;
end

function TRP3_RegisterAddCharacter(unitName)
	local unitID = TRP3_GetUnitID(unitName);
	assert(not profiles[unitID], "Already known character: " .. tostring(unitID));
	profiles[unitID] = {};
	profiles[unitID].profiles = {};
	log("Added to the register: " .. unitID);
end

function TRP3_RegisterGetCurrentProfile(unitName, unitRealm)
	local unitID = TRP3_GetUnitID(unitName, unitRealm);
	assert(profiles[unitID], "Unknown character: " .. tostring(unitID));
	if profiles[unitID].currentProfileID then
		return profiles[unitID].profiles[profiles[unitID].currentProfileID];
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onMouseOver(...)
	local unitName, unitRealm = UnitName("mouseover");
	if unitName and not unitRealm and TRP3_IsPlayerKnown(unitName) then
		local _, race = UnitRace("mouseover");
		local _, class, _ = UnitClass("mouseover");
		local englishFaction = UnitFactionGroup("mouseover");
		TRP3_RegisterSetMainInfo(unitName, race, class, UnitSex("mouseover"), englishFaction, time(), GetZoneText() .. " - " .. GetSubZoneText());
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI: TAB MANAGEMENT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabGroup;

local function createTabBar()
	local frame = CreateFrame("Frame", "TRP3_RegisterMainTabBar", TRP3_RegisterMain);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, -5);
	frame:SetFrameLevel(1);
	tabGroup = TRP3_TabBar_Create(frame,
	{
		{loc("REG_PLAYER_CARACT"), 1, 150},
		{loc("REG_PLAYER_ABOUT"), 2, 110},
		{loc("REG_PLAYER_STYLE_RPSTYLE_SHORT"), 3, 105},
		{loc("REG_PLAYER_PEEK"), 4, 130}
	},
	function(tabWidget, value)
		-- Clear all
		TRP3_RegisterCharact:Hide();
		TRP3_RegisterAbout:Hide();
		TRP3_RegisterRPStyle:Hide();
		TRP3_RegisterPeek:Hide();
		if value == 1 then
			TRP3_onCharacteristicsShown();
		elseif value == 2 then
			TRP3_onPlayerAboutShow();
		elseif value == 3 then
			TRP3_onPlayerRPStyleShow();
		elseif value == 4 then
			TRP3_onPlayerPeekShow();
		end
	end
	);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_InitRegister()
	if not TRP3_Register then
		TRP3_Register = {};
	end
	if not TRP3_Register.links then
		TRP3_Register.links = {};
	end
	if not TRP3_Register.profiles then
		TRP3_Register.profiles = {};
	end
	profiles = TRP3_Register.profiles;
	profileLinks = TRP3_Register.links;
	
	-- Listen to the mouse over event
	TRP3_RegisterToEvent("UPDATE_MOUSEOVER_UNIT", onMouseOver);
end

function TRP3_UI_InitRegister()
	TRP3_RegisterMenu({
		id = "main_00_player",
		text = TRP3_PLAYER,
		onSelected = function() TRP3_SetPage("player_main"); end,
	});

	TRP3_RegisterPage({
		id = "player_main",
		templateName = "TRP3_RegisterMain",
		frameName = "TRP3_RegisterMain",
		frame = TRP3_RegisterMain,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated",
		onPagePostShow = function()
			if tabGroup ~= nil and #tabGroup > 0 then
				tabGroup[1]:GetScript("OnClick")(tabGroup[1]); -- Select the first tab
			end
		end,
	});

	TRP3_Register_CharInit();
	TRP3_Register_AboutInit();
	TRP3_Register_StyleInit();
	TRP3_Register_PeekInit();
	TRP3_Register_DataExchangeInit();
	TRP3_Register_TooltipInit();

	createTabBar();
end