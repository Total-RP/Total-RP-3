-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "Tw13ZTjoq4)xYtPZK2HFijGotFOxZ5oUxcjtKZ9ugfKbHdZjJyqICn3d83ExHaSDItMPxBi2Erl7UFF7(jbZNTIr9z0vkdxEZ1H9zP8TIgj3i0mQ5PgbJ(Gs9pmAiJEZ1o36(SsvBF212hR9WqcyPbHesmMrXSuFsCaojIeeXOiOkDTRvnDBBE)Lkv9x74TfmAe8ymkHLgLqy0elGoxuvxzQ4YQ)JBQu1mAzxDU1Qp70TQIv81sX76)wFM7QQSpRwz6ZM89HQAazL8CrFM5bbe2UhE6Qvy6AR3TUOUy3nVmrF8Q6lvfDsX5vARNtH6dHWOZSVp7ZffIIdaRwilpRpRdOZYIrJfTqeNzl4Jd14SDLBpoTcMg3BZ9qxw)XBBkGFNxyHQ9wixN6YSdlqWWfJU8)xZBPgW)v1xO4alo9KjjXjVBSh(ADWSsUulELg5B1s7Z(0ipDkP9y7nInvAyPlhd6yaFQ8M2oHBwyy0yR(baUO2awWcBAvDnoZCjxRDMB5n3xvmEtlGfNvZJn7hBRso6Gxww9DNPOox1zPWUeOBe5dwG9TlpNr9(obfikZfb(EXRjIaqzBu5pkA12jsQVNh8pK2Ic7aYrFgv1yht2KMoSXCLD)xk2PXaQ0vjl(IsQAHnA)nx2bR9v7AUTG9zd(GF60g125X)FjE6GyVGVwibvsU15YPHXDddF9DoSCx1w(gH(ohIUx6c5CHoNr)YvxC1navtd2Hr)jm(s8mb1bsTi2pbffJJItiErjHrSY3JX2ubotdzlWrjbXemobrcJdN9JS(n7ZfBfgZ)pdtYDHmYex)svoOW7Z24aF9a4T7xQ3DYMXcVxLVxk2U2Eu4rymHG8iEaTry4VaplJqwgVi2Zp2pc5H98q(XyI1tOTm2EXlzSRg)M48Wb4hH0qROuiLQ)D2X2HYo0aqhruw2jLRQmsXZeM2xwmS(BklFw0)QstliXhzk9CW8mnzabJc9qXW3Oqs84CaMqrGyfhKeIrb(Wh08ec84he4f55rc9aJPyoyQDi5(9Otb14twHMXMx9XuPKD8hnX)B1IP()84yqbm3yM6i)Xi270If)cWFTsnpu(ZA7b3aKvW7)0IrzxUdf5pO023pZxREewTQgo1NxS3EslcBAvLvYPGgoN1Wy)4p";

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
	-- We have to wait on the first run to avoid Plater stomping our color back to the default
	if self.firstRun then
		C_Timer.After(3, function()
			if displayInfo.shouldColorHealth then
				Plater.SetNameplateColor(unitFrame, displayInfo.color:GetRGBATable());
			else
				Plater.RefreshNameplateColor(unitFrame);
			end
			self.firstRun = false;
		end)
	else
		if displayInfo.shouldColorHealth then
			Plater.SetNameplateColor(unitFrame, displayInfo.color:GetRGBATable());
		else
			Plater.RefreshNameplateColor(unitFrame);
		end
	end

	-- Setting the new name string for all the Plater name elements
	plateFrame.CurrentUnitNameString:SetText(RPDisplayName);
	unitFrame.namePlateUnitName = RPDisplayName;
	plateFrame.namePlateUnitName = RPDisplayName;
	Plater.UpdateUnitName(plateFrame);

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
