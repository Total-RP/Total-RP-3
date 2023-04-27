-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "TwvtZnkoq0)lZPmhMTeGqatv7HDhVzQSBcjvKN9ukfKbrc1kJOqISj7b(TpDJa78HtQA2mHy72QPv)E97HSiqSwWde81gNuF5frJf5YTQoT0PScU7HoLGFRX8pcEKGF5f(02XIAt)yXf4T1)0scf5HrmwASGhlYdyPHXPzzrHcof6Yq)gt3W2UpDMX0(1bzFLGNa3MGZe5jSebpdb0kvtBJRrQB(pPRX0k41dTLy0yXrBnvRLB0Qpo(NJf(RM6XIwJBSyj3V00ciRwwQglC3QGY2FZlx9k3qF7(1vTv7)Yl3OpFE7zMQbTAvJfZCe0FOeb)K)Fq9e7VvvDE7PgzLQ6OpSiaF4JZi(1WBrTuBvVcSFlcmw8RJfRHwCTx3qvBkY(5lv30yHLoBUOdb8L276huEM7e8uuTaGRADqeSWn9MHoFyPwAT(WTYURBQM)spGfFu3DDpU2EJEoHSUU5EFOQT0mGuy)gy7uLtrq83ozLGtUNrdv1LQWas6gMkKbGYuENQ3IksEaHa)dBBvfkqE6l4MouMWnnF6XG1OBphmU4KbOYqJU6lgTPhS1)TupaR9vCnVHFSykh8XG1z2Ut()l1dpP2tLBuAWLuIjpzrmUAs8Tx5XYvnBL3OSx5r01AFjRu2sb)lNF65xcunpCpgdwW4lXZcuNi1XPbz0K04K0mgjjlkru)P4yCRGK5rIJJtYctzXXzuwuA0U8umV7XCb7W8()JWKsFjZmXpVm1to8XIB8GVDc84ZlT7phXHW7v57zQTBWdEoaJzmkHraAtJH)cjiJOiJpoLeKgKqjXecninMHzIW2GZIxYyFp(jX5PJlpaPHrrTsRn)7UeBNA70aGEatz9GwVUXPvpZyIhnpT(BAlFw1VxRjcY4dOsphmpZtgYIPreAk8onILoRdGcLaM14WSOyAya8IUtHGmbHHKecHfrGGLAEIQ9uY9ZXNcUXhqJMd3x7HCPS98NUW)VzvlZ)DYXKdy3GzzI87ZyFWQo(Da)ngZor5pAXdUbiBglgSQzBxPhfL3AS4Vgk3yUdwTPfo1xw9ONjre21BQB0lfnDoRti((d";

TRP3_PlaterNamePlates = {}; -- magic public table

function TRP3_PlaterNamePlates:CustomizeNameplate(nameplate, unitToken, displayInfo)
	if nameplate:IsForbidden() or not nameplate:IsShown() then
		return;
	end

	local unitFrame = nameplate.unitFrame;

	if not unitFrame then
		return;
	end

	local plateFrame = unitFrame.PlateFrame;

	if not displayInfo then return false; end

	-- Set the display name to the unit's RP name
	local RPDisplayName;
	if displayInfo.name then
		RPDisplayName = displayInfo.name;
	else
		RPDisplayName = GetUnitName(unitToken, false);
	end

	-- Attach the RP status if necessary
	if displayInfo.roleplayStatus then
		RPDisplayName = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(RPDisplayName, displayInfo.roleplayStatus);
	end

	-- Insert the full RP title
	if displayInfo.fullTitle and not displayInfo.shouldHide then
		local fullTitle = displayInfo.fullTitle;
		if self.useFullTitleColor then
			RPDisplayName = RPDisplayName .. "\n" .. self.fullTitleColor:WrapTextInColorCode(fullTitle);
		else
			RPDisplayName = RPDisplayName .. "\n"  .. fullTitle;
		end
	end

	local currentPlayer = AddOn_TotalRP3.Player.GetCurrentUser();

	-- Append guild name (visibility of this is controlled via Plater settings)
	if plateFrame.PlateConfig.show_guild_name then
		local customGuildName = displayInfo.guildName or plateFrame.playerGuildName;
		local playerCustomGuildTable = currentPlayer:GetMiscFieldByType(TRP3_API.MiscInfoType.GuildName);
		local playerCustomGuild = playerCustomGuildTable and playerCustomGuildTable.value or Plater.PlayerGuildName;
		local sameGuild = customGuildName == playerCustomGuild;

		if customGuildName and not RPDisplayName:find("<" .. customGuildName .. ">") then
			if sameGuild then
				RPDisplayName = RPDisplayName .. "\n" .. self.guildMemberColor:WrapTextInColorCode("<" .. customGuildName .. ">");
			else
				RPDisplayName = RPDisplayName .. "\n" .. self.guildNameColor:WrapTextInColorCode("<" .. customGuildName .. ">");
			end
		end
	end

	-- Add the icon widget if it doesn't exist, if it does, update it
	if displayInfo.icon and not plateFrame.TRP3Icon and not displayInfo.shouldHide then
		do
			local iconWidget = plateFrame:CreateTexture(nil, "ARTWORK")
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
	if displayInfo.shouldHide then
		unitFrame:Hide();
	else
		unitFrame:Show();
	end

	-- Set the color of the name to the RP profile color
	if displayInfo.shouldColorName then
		RPDisplayName = displayInfo.color:WrapTextInColorCode(RPDisplayName);
	end

	-- Set the nameplate color to color the health bar
	if displayInfo.shouldColorHealth then
		Plater.SetNameplateColor(unitFrame, displayInfo.color:GetRGBTable());
	end

	-- Setting the new name string for all the Plater name elements
	plateFrame.CurrentUnitNameString:SetText(RPDisplayName);
	unitFrame.namePlateUnitName = RPDisplayName;
	plateFrame.namePlateUnitName = RPDisplayName;

	return true;
end

--- Called from within the Plater mod to make this module aware of it and it's inner workings
function TRP3_PlaterNamePlates:RegisterModTable(modTable)
	if not modTable then
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
	if GetAddOnEnableState(nil, PlaterAddonName) ~= 2 then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	if self.PlaterMod then
		Plater.RecompileScript(self.PlaterMod);
	end
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	if not IsAddOnLoaded(PlaterAddonName) then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	Plater = _G.Plater;

	local success, scriptAdded, _ = Plater.ImportScriptString(importString, false);

	-- If the mod was not installed (is already up to date) then find the installed mod object so we can still control it
	if not success and not scriptAdded then
		local scriptType = "hook";

		local scriptDB = Plater.GetScriptDB(scriptType);
		local newScriptTable = Plater.DecompressData(importString, "print");
		local newScript = Plater.BuildScriptObjectFromIndexTable(newScriptTable, scriptType);

		for i = 1, #scriptDB do
			local scriptObject = scriptDB[i];
			if scriptObject.Name == newScript.Name then
				scriptAdded = scriptObject;
			end
		end
	end

	if not scriptAdded then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end

	scriptAdded.Enabled = true;

	Plater.RecompileScript(scriptAdded);
	Plater.ForceTickOnAllNameplates();

	self.PlaterMod = scriptAdded;
end

-- Unregistering the callback and disabling the Plater mod so other nameplate addons can take over without a /reload
function TRP3_PlaterNamePlates:OnModuleDisable()
	TRP3_NamePlates.UnregisterCallback(self, "OnNamePlateDataUpdated");
	self.PlaterMod.Enabled = false;
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
