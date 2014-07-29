--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Pets/mounts managements
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, loc, Utils, Events = TRP3_API.globals, TRP3_API.locale.getText, TRP3_API.utils, TRP3_API.events;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local companionIDToInfo = TRP3_API.utils.str.companionIDToInfo;
local getCompanionProfile = TRP3_API.companions.player.getCompanionProfile;
local assert, tostring, type = assert, tostring, type;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.navigation.page.id.COMPANIONS_PAGE = "companions_page";

local function onPageShow(context)
	assert(context.profileID, "Missing profileID in context.");
	assert(context.profile, "Missing profile in context.");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Peek management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local PEEK_PRESETS; -- Read only

local function applyPeekSlot(slot, companionID, ic, ac, ti, tx)
	assert(slot, "No selection ...");
	local dataTab = (getCompanionProfile(companionID) or {}).data or {};
	if not dataTab.PE then
		dataTab.PE = {};
	end
	if not dataTab.PE[slot] then
		dataTab.PE[slot] = {};
	end
	local peekTab = dataTab.PE[slot];
	peekTab.IC = ic;
	peekTab.AC = ac;
	peekTab.TI = ti;
	peekTab.TX = tx;
	-- version increment
	dataTab.v2 = Utils.math.incrementNumber(dataTab.v2 or 0, 2);
	-- Refresh display & target frame
	Events.fireEvent(Events.TARGET_SHOULD_REFRESH, companionID);
end

function TRP3_API.companions.player.setGlanceSlotPreset(slot, presetID, companionFullID)
	local owner, companionID = companionIDToInfo(companionFullID);
	if presetID == -1 then
		applyPeekSlot(slot, companionID, nil, nil, nil, nil);
	else
		assert(PEEK_PRESETS[presetID], "Unknown peek preset: " .. tostring(presetID));
		local preset = PEEK_PRESETS[presetID];
		applyPeekSlot(slot, companionID, preset.icon, true, preset.title, preset.text);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	PEEK_PRESETS = TRP3_Presets.peek;
	
	registerPage({
		id = TRP3_API.navigation.page.id.COMPANIONS_PAGE,
		frame = TRP3_CompanionsPage,
		onPagePostShow = function(context)
			assert(context, "Missing context.");
			onPageShow(context);
		end,
	});

end);