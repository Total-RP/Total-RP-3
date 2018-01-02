local TRP3_API = TRP3_API;

local InCombatLockdown = InCombatLockdown;
local UnitIsPlayer = UnitIsPlayer;
local UnitCanAttack = UnitCanAttack;
local UnitVehicleSeatCount = UnitVehicleSeatCount;

local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local openMainFrame = TRP3_API.navigation.openMainFrame;
local openPageByUnitID = TRP3_API.register.openPageByUnitID;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local getConfigValue = TRP3_API.configuration.getValue;
local GetCursorPosition = GetCursorPosition;
local UIParent = UIParent;

local function hasProfile(unit)
	return true
end

---Check if we can view the unit profile by using the cursor
---@param unitID string @ A valid unit ID (probably mouseover here)
local function canViewUnitProfile(unit)

	if
	not unit
	or InCombatLockdown() -- We don't want to open stuff in combat
	or not UnitIsPlayer(unit) -- Unit has to be a player
	-- TODO Check if the unit is in group
	or not (UnitVehicleSeatCount(unit) and UnitVehicleSeatCount(unit) < 1) -- Avoid unit on multi seats mounts
	or UnitCanAttack("player", unit) -- Unit must not be attackable
	then
		return false;
	end

	local unitID = TRP3_API.utils.str.getUnitID(unit);
	if
	unitID == TRP3_API.globals.player_id -- Unit is not the player
	or not isUnitIDKnown(unitID) -- Unit is known by TRP3
	or hasProfile(unitID) == nil -- Unit has a RP profile available
	then
		return false;
	end

	return true;
end

---@type Frame
local CursorFrame = TRP3_CursorFrame;

CursorFrame:SetScript("OnUpdate", function(self)
	if not UnitName("mouseover") then
		self:Hide();
		return
	end
	local scale = 1 / UIParent:GetEffectiveScale();
	local x, y =  GetCursorPosition();
	CursorFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x * scale + 33, y * scale - 30);
end)


TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local CONFIG_RIGHT_CLICK_OPEN_PROFILE = "CONFIG_RIGHT_CLICK_OPEN_PROFILE";
	registerConfigKey(CONFIG_RIGHT_CLICK_OPEN_PROFILE, true);
	hooksecurefunc("TurnOrActionStart", function()
		if not getConfigValue(CONFIG_RIGHT_CLICK_OPEN_PROFILE) then return end
		if CursorFrame:IsVisible() then
			openMainFrame()
			openPageByUnitID(CursorFrame.unitID);
		end
	end)

	-- Listen to the mouse over event
	TRP3_API.utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", function()
		if canViewUnitProfile("mouseover") then
			local unitID = TRP3_API.utils.str.getUnitID("mouseover");
			CursorFrame.unitID = unitID;
			-- TODO Move cursor before showing, so that it doesn't appear at its old place for one frame
			CursorFrame:Show();
		else
			CursorFrame:Hide();
		end
	end);
	-- TODO Also refresh on register data update

	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = "Right click interaction",
		help = "Right click a player in the game to open their profile if they have one",
		configKey = CONFIG_RIGHT_CLICK_OPEN_PROFILE,
		dependentOnOptions = { "register_auto_add" },
	});

end)