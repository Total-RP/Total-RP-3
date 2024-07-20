-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;


local function IsRoleplayStatus(status)
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local currentStatus = currentUser:GetRoleplayStatus();
	return currentStatus == status;
end

local function IsRoleplayExperienceLevel(level)
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local currentExperience = currentUser:GetRoleplayExperience();
	return currentExperience == level;
end

local function IsWalkupFriendly(walkup)
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local currentWalkup = currentUser:GetWalkup();
	return currentWalkup == walkup;
end

local function GetRoleplayExperienceButtonText(selection)
	local status = selection:GetData();
	local text = TRP3_MenuUtil.GetElementText(selection);

	local icon = TRP3_API.GetRoleplayExperienceIcon(status);
	if icon and C_Texture.GetAtlasInfo(icon) then
		text = string.join(" ", "|A:" .. icon .. ":16:16|a ", text);
	elseif icon and GetFileIDFromPath(icon) then
		text = string.join(" ", "|T" .. icon .. ":16:16|t ", text);
	end

	return text;
end

local function SetRoleplayExperienceLevel(level)
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	currentUser:SetRoleplayExperience(level);
end

local function GetRoleplayStatusButtonText(selection)
	local status = selection:GetData();
	local text = TRP3_MenuUtil.GetElementText(selection);

	if status == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER then
		text = string.join(" ", "|TInterface\\COMMON\\Indicator-Green:16:16|t ", text);
	elseif status == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		text = string.join(" ", "|TInterface\\COMMON\\Indicator-Red:16:16|t ", text);
	end

	return text;
end

local function SetRoleplayStatus(status)
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	currentUser:SetRoleplayStatus(status);
end

local function GetWalkupButtonText(selection)
	local status = selection:GetData();
	local text = TRP3_MenuUtil.GetElementText(selection);

	if status == AddOn_TotalRP3.Enums.WALKUP.YES then
		text = string.join(" ", "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-walkup:16:16|t ", text);
	end

	return text;
end

local function SetWalkup(walkup)
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	currentUser:SetWalkup(walkup);
end

local function GenerateRPStatusMenu(_, rootDescription)
	do  -- In character
		local status = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
		local elementDescription = rootDescription:CreateRadio(L.DB_STATUS_RP_IC, IsRoleplayStatus, SetRoleplayStatus, status);
		TRP3_MenuUtil.AttachTexture(elementDescription, [[Interface\COMMON\Indicator-Green]]);
		TRP3_MenuUtil.SetElementTooltip(elementDescription, L.DB_STATUS_RP_IC_TT);
	end

	do  -- Out of character
		local status = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
		local elementDescription = rootDescription:CreateRadio(L.DB_STATUS_RP_OOC, IsRoleplayStatus, SetRoleplayStatus, status);
		TRP3_MenuUtil.AttachTexture(elementDescription, [[Interface\COMMON\Indicator-Red]]);
		TRP3_MenuUtil.SetElementTooltip(elementDescription, L.DB_STATUS_RP_OOC_TT);
	end
end

local function GenerateWalkupMenu(_, rootDescription)
	do  -- Walkup Yes
		local walkup = AddOn_TotalRP3.Enums.WALKUP.YES;
		local elementDescription = rootDescription:CreateRadio(L.CM_YES, IsWalkupFriendly, SetWalkup, walkup);
		TRP3_MenuUtil.AttachTexture(elementDescription, [[Interface\AddOns\totalRP3\Resources\UI\ui-icon-walkup.tga]]);
		TRP3_MenuUtil.SetElementTooltip(elementDescription, L.DB_STATUS_WU_YES_TT);
	end

	do  -- Walkup No
		local walkup = AddOn_TotalRP3.Enums.WALKUP.NO;
		local elementDescription = rootDescription:CreateRadio(L.CM_DO_NOT_SHOW, IsWalkupFriendly, SetWalkup, walkup);
		TRP3_MenuUtil.AttachTexture(elementDescription);
	end
end

local function GenerateXPStatusMenu(_, rootDescription)
	local levels = {
		AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER,
		AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.CASUAL,
		AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN,
		AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE,
	};

	for _, level in ipairs(levels) do
		local text = TRP3_API.GetRoleplayExperienceText(level);
		local icon = TRP3_API.GetRoleplayExperienceIcon(level);
		local tooltipText = TRP3_API.GetRoleplayExperienceTooltipText(level);

		local elementDescription = rootDescription:CreateRadio(text, IsRoleplayExperienceLevel, SetRoleplayExperienceLevel, level);
		TRP3_MenuUtil.AttachTexture(elementDescription, icon);
		TRP3_MenuUtil.SetElementTooltip(elementDescription, tooltipText);
	end
end

TRP3_DashboardStatusPanelMixin = {};

function TRP3_DashboardStatusPanelMixin:OnLoad()
	BackdropTemplateMixin.OnBackdropLoaded(self);

	TRP3_Addon.RegisterCallback(self, "REGISTER_DATA_UPDATED", "OnRegisterDataUpdated");
end

function TRP3_DashboardStatusPanelMixin:OnShow()
	self:SetTitleText(L.DB_STATUS);
	self.RPStatusLabel:SetText(L.DB_STATUS_RP);
	self.WUStatusLabel:SetText(L.DB_STATUS_WU);
	self.XPStatusLabel:SetText(L.DB_STATUS_XP);
	self.RPStatusMenu:SetSelectionTranslator(GetRoleplayStatusButtonText);
	self.RPStatusMenu:SetupMenu(GenerateRPStatusMenu);
	self.WUStatusMenu:SetSelectionTranslator(GetWalkupButtonText);
	self.WUStatusMenu:SetupMenu(GenerateWalkupMenu);
	self.XPStatusMenu:SetSelectionTranslator(GetRoleplayExperienceButtonText);
	self.XPStatusMenu:SetupMenu(GenerateXPStatusMenu);
end

function TRP3_DashboardStatusPanelMixin:OnRegisterDataUpdated(_, characterID, _, dataType)
	if characterID ~= TRP3_API.globals.player_id then
		return;
	elseif dataType and dataType ~= "character" then
		return;
	else
		self.RPStatusMenu:Update();
		self.WUStatusMenu:Update();
		self.XPStatusMenu:Update();
	end
end
