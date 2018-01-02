local TRP3_API = TRP3_API;

local InCombatLockdown = InCombatLockdown;
local UnitIsPlayer = UnitIsPlayer;
local UnitCanAttack = UnitCanAttack;
local UnitVehicleSeatCount = UnitVehicleSeatCount;

local hasProfile = TRP3_API.register.hasProfile;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local openMainFrame = TRP3_API.navigation.openMainFrame;
local openPageByUnitID = TRP3_API.register.openPageByUnitID;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local getConfigValue = TRP3_API.configuration.getValue;
local GetCursorPosition = GetCursorPosition;
local SetCursor = SetCursor;
local UIParent = UIParent;

---Check if we can view the unit profile by using the cursor
---@param unitID string @ A valid unit ID (probably mouseover here)
local function canViewUnitProfile(unit)

	if
	not unit
	or InCombatLockdown() -- We don't want to open stuff in combat
	or not UnitIsPlayer(unit) -- Unit has to be a player
	or not UnitVehicleSeatCount(unit) < 1 -- Avoid unit on multi seats mounts
	or UnitCanAttack("player", unit) -- Unit must not be attackable
	then
		return false;
	end

	local unitID = TRP3_API.utils.str.getUnitID(unit);
	if
	unitID == TRP3_API.globals.player_id -- Unit is not the player
	or not isUnitIDKnown(unitID) -- Unit is known by TRP3
	or not hasProfile(unitID) -- Unit has a RP profile available
	then
		return false;
	end

	return true;
end

local CursorFrame = CreateFrame("Frame", nil, UIParent);
CursorFrame:SetWidth(1);
CursorFrame:SetHeight(1);

CursorFrame:SetScript("OnUpdate", function()
	local effScale, x, y = self:GetEffectiveScale(), GetCursorPosition();
	self:ClearAllPoints();
	self:SetPoint("CENTER", UIParent, "CENTER", (x / effScale) + 10, (y / effScale) + 10);
end)


TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local CONFIG_RIGHT_CLICK_OPEN_PROFILE = "CONFIG_RIGHT_CLICK_OPEN_PROFILE";
	registerConfigKey(CONFIG_RIGHT_CLICK_OPEN_PROFILE, true);

	hooksecurefunc("InteractUnit", function(unit)
		if not getConfigValue(CONFIG_RIGHT_CLICK_OPEN_PROFILE) then return end
		if canViewUnitProfile(unit) then
			local unitID = TRP3_API.utils.str.getUnitID(unit);
			openMainFrame()
			openPageByUnitID(unitID);
		end
	end)

	-- Listen to the mouse over event
	TRP3_API.events.listenToEvent(TRP3_API.events.MOUSE_OVER_CHANGED, function(targetID, targetMode)
		if canViewUnitProfile() then
			CursorFrame:Show();
			SetCursor([[Interface\Cursor\WorkOrders]]);
		else
			CursorFrame:Hide();
			SetCursor();
		end
	end);

	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = "Right click interaction",
		help = "Right click a player in the game to open their profile if they have one",
		configKey = CONFIG_RIGHT_CLICK_OPEN_PROFILE,
		dependentOnOptions = { "register_auto_add" },
	});

end)