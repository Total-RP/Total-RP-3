-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local PlaterAddonName = "Plater";

local platerHooks = {
	["Initialization"] = [[
		function(modTable)
			if not AddOnUtil.IsAddOnEnabledForCurrentCharacter("totalRP3") then
				return;
			end

			if not TRP3_PlaterNamePlates then
				EventUtil.ContinueOnAddOnLoaded("totalRP3", function()
					TRP3_PlaterNamePlates:RegisterModTable(modTable);
				end);
			else
				TRP3_PlaterNamePlates:RegisterModTable(modTable);
			end
		end
	]],
	["Nameplate Added"] = [[
		function(self, unitId, unitFrame, envTable, modTable)
			if not AddOnUtil.IsAddOnEnabledForCurrentCharacter("totalRP3") or not TRP3_NamePlates then
				return;
			end

			TRP3_NamePlates:UpdateNamePlateForUnit(unitId);
		end
	]]
};

local platerScriptObject = {
	Enabled = true,
	Name = "TotalRP3 Nameplates",
	Icon = 236685,
	Desc = "RP Names for Plater Nameplates",
	UID = "0x642efce2108b6e25",
	PlaterCore = Plater.CoreVersion,
	Prio = 99,
	Author = "The TotalRP3 Team",
	Revision = 1,
	Time = time(),
	Options = {
		{
			Type = 5,
			Name = "guildColors",
			Value = "Guild Name Color Customization",
			Key = "guildColorsLabel",
			Icon = "Interface\\AddOns\\Plater\\images\\option_label",
			Desc = COLOR
		},
		{
			Type = 1,
			Name = "Guild Name Color",
			Value = {
				0.2274509966373444,
				1,
				0.1607843190431595,
				1,
			},
			Key = "guildNameColor",
			Icon = "Interface\\AddOns\\Plater\\images\\option_color",
			Desc = "Color of the guild name on nameplates",
		},
		{
			Type = 1,
			Name = "Guild Member Color",
			Value = {
				0.3686274588108063,
				0.8901961445808411,
				1,
				1,
			},
			Key = "guildMemberColor",
			Icon = "Interface\\AddOns\\Plater\\images\\option_color",
			Desc = "Color for the guild name of fellow guild members",
		},
		{
			Type = 5,
			Name = "fullTitleColors",
			Value = "RP Title Color Customization",
			Key = "fullTitleColorsLabel",
			Icon = "Interface\\AddOns\\Plater\\images\\option_label",
			Desc = "",
		},
		{
			Type = 1,
			Name = "RP Title Color",
			Value = {
				0.917647123336792,
				0.8823530077934265,
				0.8784314393997192,
				1,
			},
			Key = "fullTitleColor",
			Icon = "Interface\\AddOns\\Plater\\images\\option_color",
			Desc = "Color of player titles on nameplates",
		},
		{
			Type = 4,
			Name = "Use Custom Color for RP Title",
			Value = true,
			Key = "useFullTitleColor",
			Icon = "Interface\\AddOns\\Plater\\images\\option_bool",
			Desc = "Enable to use the color chosen above instead of the RP profile color",
		},
	},
	OptionsValues = {},
	LoadConditions = {
		class = {},
		spec = {},
		race = {},
		talent = {},
		pvptalent = {},
		group = {},
		role = {},
		affix = {},
		encounter_ids = {},
		map_ids = {}
	},
	Hooks = CopyTable(platerHooks),
	HooksTemp = {},
	LastHookEdited = "",
	url = "",
	version = -1,
	semver = ""
};

TRP3_PlaterNamePlates = {};

function TRP3_PlaterNamePlates:CustomizeNameplate(nameplate, unitToken, displayInfo)
	if nameplate:IsForbidden() or not nameplate:IsShown() or not displayInfo then
		return;
	end

	local unitFrame = nameplate.unitFrame;

	if not unitFrame or not unitFrame.PlaterOnScreen then
		return;
	end

	local plateFrame = unitFrame.PlateFrame;

	-- Set the display name to the unit's RP name
	local showServerName = false;
	local displayName = displayInfo.name or GetUnitName(unitToken, showServerName);

	-- Attach the RP status if necessary
	if displayInfo.roleplayStatus then
		displayName = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(displayName, displayInfo.roleplayStatus);
	end

	-- Insert the full RP title (if FT display is chosen by the user)
	if TRP3_NamePlatesUtil.IsFullTitleEnabled() and displayInfo.fullTitle and not displayInfo.shouldHide then
		local fullTitle = displayInfo.fullTitle;
		if self.useFullTitleColor then
			displayName = displayName .. "\n" .. self.fullTitleColor:WrapTextInColorCode(fullTitle);
		else
			displayName = displayName .. "\n"  .. fullTitle;
		end
	end

	-- Append guild name (visibility of this is controlled via Plater settings)
	if not plateFrame.PlateConfig or plateFrame.PlateConfig.show_guild_name then
		local currentPlayer = AddOn_TotalRP3.Player.GetCurrentUser();
		local customGuildName = displayInfo.guildName or plateFrame.playerGuildName;
		local playerCustomGuildTable = currentPlayer:GetMiscFieldByType(TRP3_API.MiscInfoType.GuildName);
		local playerCustomGuild = playerCustomGuildTable and playerCustomGuildTable.value or Plater.PlayerGuildName;
		local sameGuild = customGuildName == playerCustomGuild;

		if customGuildName and not displayName:find("<" .. customGuildName .. ">") then
			if sameGuild then
				displayName = displayName .. "\n" .. self.guildMemberColor:WrapTextInColorCode("<" .. customGuildName .. ">");
			else
				displayName = displayName .. "\n" .. self.guildNameColor:WrapTextInColorCode("<" .. customGuildName .. ">");
			end
		end
	end

	-- Add the icon widget if it doesn't exist, if it does, update it
	if displayInfo.icon and not plateFrame.TRP3Icon and not displayInfo.shouldHide then
		do
			local iconWidget = plateFrame:CreateTexture(nil, "ARTWORK");
			iconWidget:ClearAllPoints();
			iconWidget:SetPoint("RIGHT", plateFrame.CurrentUnitNameString, "LEFT", -4, 0);
			iconWidget:Hide();

			plateFrame.TRP3Icon = iconWidget;
		end
	end

	if displayInfo.icon and plateFrame.TRP3Icon and not displayInfo.shouldHide then
		plateFrame.TRP3Icon:ClearAllPoints();
		plateFrame.TRP3Icon:SetTexture(TRP3_API.utils.getIconTexture(displayInfo.icon));
		plateFrame.TRP3Icon:SetSize(TRP3_NamePlatesUtil.GetPreferredIconSize());
		plateFrame.TRP3Icon:SetPoint("RIGHT", plateFrame.CurrentUnitNameString, "LEFT", -4, 0);
		plateFrame.TRP3Icon:Show();
	elseif plateFrame.TRP3Icon then
		plateFrame.TRP3Icon:Hide();
	end

	-- Update nameplate visibility
	-- We need to check if the nameplate is still visible first, so we don't re-show it if it's been hidden elsewhere
	unitFrame:SetShown(not displayInfo.shouldHide);

	-- Set the color of the name to the RP profile color
	if displayInfo.shouldColorName then
		displayName = displayInfo.color:WrapTextInColorCode(displayName);
	end

	-- Set the nameplate color to color the health bar
	-- We have to wait on the first run to avoid Plater stomping our color back to the default
	if displayInfo.shouldColorHealth then
		if self.firstRun then
			C_Timer.After(3, function()
				if unitFrame.PlaterOnScreen and displayInfo.color then
					Plater.SetNameplateColor(unitFrame, displayInfo.color:GetRGBTable());
				end
				self.firstRun = false;
			end);
		else
			Plater.SetNameplateColor(unitFrame, displayInfo.color:GetRGBTable());
		end
	else
		Plater.RefreshNameplateColor(unitFrame);
	end

	-- Setting the new name string for all the Plater name elements
	plateFrame.CurrentUnitNameString:SetText(displayName);
	unitFrame.namePlateUnitName = displayName;
	plateFrame.namePlateUnitName = displayName;
	Plater.UpdateUnitName(plateFrame);

	return true;
end

--- Called from within the Plater mod to make this module aware of it and it's inner workings
function TRP3_PlaterNamePlates:RegisterModTable(modTable)
	if not modTable or not self.Enabled then
		return nil;
	end

	self.modTable = modTable;

	-- Grabbing the color config from the Plater mod settings
	self.guildNameColor = TRP3_API.CreateColor(unpack(self.modTable.config.guildNameColor));
	self.guildMemberColor = TRP3_API.CreateColor(unpack(self.modTable.config.guildMemberColor)); -- name color for members of your guild

	self.fullTitleColor = TRP3_API.CreateColor(unpack(self.modTable.config.fullTitleColor));
	self.useFullTitleColor = self.modTable.config.useFullTitleColor;

	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	return self;
end

function TRP3_PlaterNamePlates:OnNamePlateDataUpdated(_, nameplate, unitToken, displayInfo)
	self:CustomizeNameplate(nameplate, unitToken, displayInfo);
end

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if not AddOnUtil.IsAddOnEnabledForCurrentCharacter(PlaterAddonName) then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	if self.PlaterMod then
		Plater.RecompileScript(self.PlaterMod);
	end
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	if not C_AddOns.IsAddOnLoaded(PlaterAddonName) then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	-- Check if the friendly nameplates module is enabled within Plater
	if not Plater.db.profile.plate_config.friendlyplayer.module_enabled then
		return TRP3_API.module.status.CONFLICTED, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	self.Enabled = true;

	-- Check if the script exists and has the same revision before importing it, to avoid flooding the recycle bin
	local scriptType = "hook";
	local scriptDB = Plater.GetScriptDB(scriptType);

	local noOverwrite = true;
	for i=1, #scriptDB do
		local script = scriptDB[i];
		if script.Name == platerScriptObject.Name then
			if script.Revision < platerScriptObject.Revision then
				noOverwrite = false;
				break;
			end
		end
	end

	Plater.AddScript(platerScriptObject, noOverwrite);
	Plater.RecompileScript(platerScriptObject);
	Plater.ForceTickOnAllNameplates();

	self.PlaterMod = platerScriptObject;
	self.firstRun = true;
end

-- Unregistering the callback and disabling the Plater mod so other nameplate addons can take over without a /reload
function TRP3_PlaterNamePlates:OnModuleDisable()
	TRP3_NamePlates.UnregisterCallback(self, "OnNamePlateDataUpdated");
	self.PlaterMod.Enabled = false;
	self.firstRun = true;
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_plater_nameplates",
	name = L.PLATER_NAMEPLATES_MODULE_NAME,
	description = L.PLATER_NAMEPLATES_MODULE_DESCRIPTION,
	version = 2,
	minVersion = 0,
	requiredDeps = { { PlaterAddonName, "external" } },
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});
