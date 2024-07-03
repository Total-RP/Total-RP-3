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

local function GenerateXPStatusMenu(_, rootDescription)
	do -- Beginner Roleplayer
		local level = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER;
		local elementDescription = rootDescription:CreateRadio(L.DB_STATUS_XP_NEWCOMER, IsRoleplayExperienceLevel, SetRoleplayExperienceLevel, level);
		TRP3_MenuUtil.AttachTexture(elementDescription, TRP3_API.GetRoleplayExperienceIcon(level));
		TRP3_MenuUtil.SetElementTooltip(elementDescription, L.DB_STATUS_XP_NEWCOMER_TT);
	end

	do -- Casual Roleplayer
		local level = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.CASUAL;
		local elementDescription = rootDescription:CreateRadio(L.DB_STATUS_XP_NORMAL, IsRoleplayExperienceLevel, SetRoleplayExperienceLevel, level);
		TRP3_MenuUtil.AttachTexture(elementDescription, TRP3_API.GetRoleplayExperienceIcon(level));
		TRP3_MenuUtil.SetElementTooltip(elementDescription, L.DB_STATUS_XP_NORMAL_TT);
	end

	do -- Experienced Roleplayer
		local level = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN;
		local elementDescription = rootDescription:CreateRadio(L.DB_STATUS_XP_VETERAN, IsRoleplayExperienceLevel, SetRoleplayExperienceLevel, level);
		TRP3_MenuUtil.AttachTexture(elementDescription, TRP3_API.GetRoleplayExperienceIcon(level));
		TRP3_MenuUtil.SetElementTooltip(elementDescription, L.DB_STATUS_XP_VETERAN_TT);
	end

	do -- Newcomer Guide Roleplayer
		local level = AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE;
		local elementDescription = rootDescription:CreateRadio(L.DB_STATUS_XP_NEWCOMER_GUIDE, IsRoleplayExperienceLevel, SetRoleplayExperienceLevel, level);
		TRP3_MenuUtil.AttachTexture(elementDescription, TRP3_API.GetRoleplayExperienceIcon(level));
		TRP3_MenuUtil.SetElementTooltip(elementDescription, L.DB_STATUS_XP_NEWCOMER_GUIDE_TT);
	end
end

TRP3_DashboardStatusPanelMixin = {};

function TRP3_DashboardStatusPanelMixin:OnLoad()
	BackdropTemplateMixin.OnBackdropLoaded(self);

	TRP3_Addon.RegisterCallback(self, "REGISTER_DATA_UPDATED", "OnRegisterDataUpdated");
end

function TRP3_DashboardStatusPanelMixin:OnShow()
	TRP3_API.ui.frame.setupFieldPanel(self, L.DB_STATUS, 150);
	self.RPStatusLabel:SetText(L.DB_STATUS_RP);
	self.XPStatusLabel:SetText(L.DB_STATUS_XP);
	self.RPStatusMenu:SetSelectionTranslator(GetRoleplayStatusButtonText);
	self.RPStatusMenu:SetupMenu(GenerateRPStatusMenu);
	self.XPStatusMenu:SetupMenu(GenerateXPStatusMenu);
end

function TRP3_DashboardStatusPanelMixin:OnRegisterDataUpdated(_, characterID, _, dataType)
	if characterID ~= TRP3_API.globals.player_id then
		return;
	elseif dataType and dataType ~= "character" then
		return;
	else
		self.RPStatusMenu:Update();
		self.XPStatusMenu:Update();
	end
end
