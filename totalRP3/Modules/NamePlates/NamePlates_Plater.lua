-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "1w13VrQnq4)xUNYjL7Kbmg4KUhAt6EABtyJI30NICWlysq1lgHnPx6d83EhJb2FKTv6AsdzZoXdZmFFZ8XaZJTMr9y01kdxE7nb9zP8TIgj3i0mQ5LgbJ(Ks9hmAaJE7no36(SsvBF2n2BR9Wq8zP(besCiJgYs9iXb(4eIFeJIHQ01Ur10TT5txRu1FRJ3wWOrWTXOewAmkHrtSa6srvDLPIlR(lUPsvZOLD15wR(SZ2QkwZ3ifFS)x7ZCxvL9z1ktF2s9pvuSQ(kfVquC2hMy1h(yFMfWd3Zu8FUQgqFjpx0NzEsuVlDtxTctxluYsUul25wuxS39oB968(Lv1xRk6KIlR0wpNbqgcMrNBy9zaEffhWpTqwEEFwh0bwwmASOfI4CBPFEOgNVRC)xBdRHdEWcKHPO(9PhCus)YDnfW3ZhSq1EhWMZCCZ1nGGNVy0LV7Z9)FgT9zFDKTUhc2JZ3kESsdhD9yqNc4tL302jCAcdJgBL(aWf1gWco4XwvxJZmxY1AN5wEZdvfJ)tlGfNvZZn7hBRso6Gxww9DNPOox1zPWUeOBe5dwG9DlVKrrFNG9fL5cFpu8gIWNaGsL)SOvBNiPEie8lK2Ic7aYrFgv1yht2KMoStzTD1rAOtRduPRswCHsQAHDe)ox2bN9n7zUTh9zd(GV60g125X)VjE5GyVIVribvsU15YPHX9ddF99oSCF1w(Jc99oe9G0fYLcDoJEXQRwDlq1u)Dy0BcJVgptqDGulI9sWrXHrXjeuusqeR8tHH2ubotdylcJs8JjHHjysqCWSFS1VzFUyRWy()rysUlKrM46xQYbfEF2JoWxpaE7Zl17wkBSW7FKVxl2UXUf)emMqWiccOnoe(Xhzze2Y4fXiVyVimkeHWEXHeRNaBzS9IxZyxnEN48W7EobPHwrPqkv)5SJTdLDObGpHOSStkxxzKIJeM23ZnC()QS8OOFRstlidpXu6yWCKM0NeIdq4y4V4as84CaMqrGyn0pjie77bFWZtiWJNVpkcHibiWykMdMAhsU3hDkOgFXk0m28QpLkLSJ)4j(FNwm1)NhhdkG5gZuh5NhXENwS4na)nk18q5xQTlUbiRG3dRfJYUChkYFsPH3TKX3OEgoTQg26Zl27zslcBAvLvYPGg2ZAyS)o";

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

	-- Insert the full RP title
	if displayInfo.fullTitle and not displayInfo.shouldHide then
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
	if not TRP3_API.utils.IsAddOnEnabled(PlaterAddonName) then
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

	-- Check if the script exists and has the same revision before importing it, to avoid flooding the recycle bin
	local scriptObject;
	local scriptType = "hook";
	local scriptDB = Plater.GetScriptDB(scriptType);
	local newScriptTable = Plater.DecompressData(importString, "print");
	local newScript = Plater.BuildScriptObjectFromIndexTable(newScriptTable, scriptType);

	for i=1, #scriptDB do
		local script = scriptDB[i];
		if script.Name == newScript.Name then
			if script.Revision == newScript.Revision then
				scriptObject = script;
				break;
			end
		end
	end

	if not scriptObject then
		local success, scriptAdded = Plater.ImportScriptString(importString);

		if not success or not scriptAdded then
			return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR;
		end

		scriptObject = scriptAdded;
	end

	scriptObject.Enabled = true;

	Plater.RecompileScript(scriptObject);
	Plater.ForceTickOnAllNameplates();

	self.PlaterMod = scriptObject;
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
