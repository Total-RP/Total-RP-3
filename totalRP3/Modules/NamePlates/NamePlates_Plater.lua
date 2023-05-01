-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "Tw13VrQnq4)xUNYjLRIFymWj1hAV0902MqII30NICWlmKGQxmcBsV0h4V9ogdS7MS3jDTxi7UdEyM57BMpB4(8nCMpNTrzeYBVjCiptSdALcdO5mZlTaN9Ks9xCwiND7no36H8kv3q(n2hR74qc4zbHuAseNfXZ8PjbrPjr(y0eSk9DBvT97A)WvkvZN7fDLCwm(yCgLNfNMWzPwaDbu3uBQfY6)ryQvnCwvFtH1Ai)SDQYnITs49d)(qU7QUAiVrzgYN99t1niYQefWqU5jadB)dpF1bM(UM9RdnL7V5Tj6Jx3CLQSxcxuRTEodRpgcNTW(H8FPSekpcSAqwD(qEpsN1LtgR6Wio3wWNhRX57l3bCAdonEWM7XUS(J31wI)USWkv3DyUoZLzhwWGXloB9)TM3AnI)RBUujqwC27MLeV79t9WVwhmVsi1WxPr(TAPd5)8epDkPdy7TWJ1ACPRMc6uaFU8MUEWnlmCwIv)GahAmOfUWJDQ(wNzHuO1oZDI2hQlNUPtjbNv7ZThgRUfkCwIQQ6V4mHMcvVLchKaKmJwO9DRVGZ8(cLeavfqGVxYwkeqrqPkEg602jsMVNh(pM2Ys7aYrFot1Aht2KMnUXCJD)xgUv6pGxqM0xll)KsQ60xk2cso7pfYECd6NToCBdhYhFa8NETrTBrcy9DugqvsH1X65HX9JdF99oSCF9oXJG(EhIEq6Q3fGUGZ(01xE9TivZc2Jr)dXOTyJvzgHJ8zvIFkjojkojL6fNggZR(quKnlOZSq(QO40GeAuukHgMeU4Ny9BMPWB563htkCHmXexVsvnQWhYF0L8MXKB3V0S)KnJfJNMVxb72cDNGXukXJ6H0MeH)f4zzeXY4vjE(j(XeVippIFse16j0wbBV4Km2vKFyCE8a8tqASvubsP6VxCSBSWJnaYBfLv9s5MAJeoLW0(cJrNFBz5RYX)dPPfKrVDkDCbELQmGgrc9ij43KqAY0KaNrXOCnkinmIe4JFilZi0JFqGxSNhn0dnMJ5452Rj)pgDkQgFXkdm2mRpLkLUN)Kj(3RHvNSf8RZG9onmpCwMvJsKfw89b)Tk1Yq53AShCJqwHV)tdtYUcxrkEsPTVFwSv9mUADdEQVO8G9Kwa02PQQLZbnEoRHZ)3p";

TRP3_PlaterNamePlates = {}; -- magic public table

function TRP3_PlaterNamePlates:CustomizeNameplate(nameplate, unitToken, displayInfo)
	if nameplate:IsForbidden() or not nameplate:IsShown() or not displayInfo then
		return;
	end

	local unitFrame = nameplate.unitFrame;

	if not unitFrame then
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
	unitFrame:SetShown(not displayInfo.shouldHide);

	-- Set the color of the name to the RP profile color
	if displayInfo.shouldColorName then
		displayName = displayInfo.color:WrapTextInColorCode(displayName);
	end

	-- Set the nameplate color to color the health bar
	-- We have to wait on the first run to avoid Plater stomping our color back to the default
	if self.firstRun then
		C_Timer.After(3, function()
			if displayInfo.shouldColorHealth then
				Plater.SetNameplateColor(unitFrame, displayInfo.color:GetRGBTable());
			else
				Plater.RefreshNameplateColor(unitFrame);
			end
			self.firstRun = false;
		end)
	else
		if displayInfo.shouldColorHealth then
			Plater.SetNameplateColor(unitFrame, displayInfo.color:GetRGBTable());
		else
			Plater.RefreshNameplateColor(unitFrame);
		end
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
