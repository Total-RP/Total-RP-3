-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "TA13ZXPnq4)xYtNNXPJaKeCzM(qQDVmxRn2J5CEYJmcqyZebIbjCJ7d83ExHo4UZ(sAtD85FSOLD3VVD)KKzESnSepwYgLHlV56GH0yETOvYncnlX8CRGL8Os9fwsal5MRDU1dPLQUH0RTVw3HH4ZI9dO0iclHWI9OrEyC0sselbdvPVlt12x3((lvQMp1Z7kyjHWRXsOS4qk8wlTa6CrvtLPIlR(BUPs1Wsk7BYTwdPlQvfB4zsXjd)XqQ7tv5qAJYmKo57xQAaKvYZfdPMhfqy7E5PpDctFxZU1fnf7E41j6d320jEOsdp(rP8mUuMXZ)IEbadiswYCtyi9JffIIdWSwilpDiThy16ITgR6Gio1w3Ngl1P7Q6pe1E7eRTaG9m(xmdUjQT()3WyTgAex1CHIdTJfVBsI9Ut(xaEAjxQfFd8)9yYq6VoKUbkX9oLPLsJw6pCZ2r3LBd6ya))qtcM87e7l2l2jOB66fUUMHLez1YaPfngWcw4HovFRZmxY1ANznV9(QITp0bfZz1(u7(XQBf5olEzz1xDMIMCvVfJ7LaL0LaW(21NZsqFLI9fL5cFpuugv4tbqPYFs0PTtZypec(gsBrHD46ADSevRDeBtA84HeBSNfetCcDGk9vYIZusvhSP)ZCzpS2NSR5ooyiD0h8NETrvplD(tXZhe7f8mHeuy5wNRN623nkC035WYDv18he67Ci6EPlKZf6CwYzxDXv3aun2Fhg9MW4RXZeuhj1QiVL4Wisy0skkCzqiR89eInvGZ4a2ks4s)ikHSetdIcM9JT(n7ZfBf2M)FeMK7czltC9lv54UJH0hCGVze829An7oL1yH33KVxkQZShlFegtPyefb0gtGV8rwgHTmEveYlYleJiie2lIqTEcSLX2lEnJD14NeNhVm5iKgAfLcPu9xZoQhl7ydaFerzzVuUPYifVqyAV4AC9VRS8fr)wLMwqsoYu6LG5fAsFkbhGWrWVXbWnIU5amHcbXkXFzab77b)GNNqGhpFFuicrdqGXumhm1oKC)C0PGA8zRqZyZR(yQu6o(JN4)TAXu)FECmQaMBmtDKFBl271IvVb4NPuZdLFVXEUoazfCjSwSv2L7qr(JkT9)vGNPEcwTQbUXGxS3EslcB7uLvYPGgpN1Wy)d";

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
				--RPDisplayName = RPDisplayName .. "\n" .. self.guildNameColor .. "<" .. customGuildName .. ">|r";
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
	elseif displayInfo.icon and plateFrame.TRP3Icon and not displayInfo.shouldHide then
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

	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	self.initialized = {};

	-- Grabbing the color config from the Plater mod settings
	self.guildNameColor = TRP3_API.CreateColor(unpack(self.modTable.config.guildNameColor));
	self.guildMemberColor = TRP3_API.CreateColor(unpack(self.modTable.config.guildMemberColor)); -- name color for members of your guild

	self.fullTitleColor = TRP3_API.CreateColor(unpack(self.modTable.config.fullTitleColor));
	self.useFullTitleColor = self.modTable.config.useFullTitleColor;

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
	version = 1,
	minVersion = 0,
	requiredDeps = { { PlaterAddonName, "external" } },
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});
