-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "1w13VTTnq4)x6tPaPfu)GuYfypSfpx4TeNGqN9uaJOLoLimArbrQSM9G(BFhfTKTtmgqrtJqSpZJ8UVV7(4jrGyTGhi4R1wP62BI6Zwj3cnkPfmcU9LgqWFsR)BbpsWV9gVBtFwPUTp7g32Ap(iHIvHrmwkvWPIvbjHr00iAsIGhJzPRDJUPBBZNUsRR)ANSTqWtWTj4mXQ0aIGpZbO5qvDLTsQQ(xPTsxl4LD15oR(SZ2Qlwl3OGp2)h9z(NQY(SATTp7Ih(1IIRRnFEPzW4sTSako7dJ07dFSpZH8HnpgOpxvJ0OuMd9z2NG69XD8PfSDTyUlLkdS3nuxCWENSEBC)Y11xPl6uW8kJZZzi2Xdl4tvU(meVqXre1aQYZ7Z6WsXYIDglAXtCUl1ppKJZ3NUF46XACHhCiAOVAEFkgVkOF5UMc87PfwOBVdP1zEs6ll4HNEe8L)8uc)CA29z)YoA7VFCa5VfESYGlD1UdDkgmMEBBh4vjwbp1DRabouBrlCHhB1DnEZCL0y8MBLnpuvS7hTAf4TAEU5WZ2IG0BjllR(M3eQZ1DokSpaMgiFWcTVB5CbN8nwCiuMdHbK0nmiKHGsN)m0ACTMvbbecjedBrHRt5PVGRBC9lxqxnmUzTBQYkCaXFcVGmPRsvCHwPBnxk3akb)VKQoCSZxDo8dxW2PBd4xDgRE7KwW57OiGYLCNJLJnJ79QG79y5(QTYhbZ9Ee9GYNV5GjxWV46lV(wKQRc3JXGdXOlzdzzeHd8zrAWS4KuAs6mgjzwuIO8tuQlkOZvrIf0KzHPmkDwmlknAYFSZVDKcVLRFFmj3FKDmXxR0Ldk8(Sh9bVEi4Ulo17NxBDy8089ky7gO9emMXIjmcs7yk(xiXXOyhJxKscsdsIjucjoiLYCEICzWvlojJ9j5DJZdVw6eKglfLGsP)NjhBhs8qbi(TIYYoLADLvbNsy6En4GZ)Fz5RIXpG00bs6B7shNGxPkdz04isCk(zCelDxNa7rjOCLgolIghgG)hp1JqpbHHKecHfrqJXZCCF71K)9rNIQXxCYaRlYMtPsz75F8o(3zGfNSe8BJG9odm2CM6vdsKjw89b)nA9ut53RDdUriRX3mBGDYUCFsYFsBW3TKj3OFgxTQgN6llo4oPdanT6Yk14HgMZAfI)7d";

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
	if not C_AddOns.IsAddOnLoaded(PlaterAddonName) then
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
