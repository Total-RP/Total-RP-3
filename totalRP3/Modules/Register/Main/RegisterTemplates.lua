-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_RegisterSectionHeaderMixin = {};

function TRP3_RegisterSectionHeaderMixin:SetText(text)
	self.Text:SetText(text);
end

function TRP3_RegisterSectionHeaderMixin:SetIconTexture(icon)
	self.Icon:SetIconTexture(icon);
end

TRP3_RegisterTraitLineMixin = {};

function TRP3_RegisterTraitLineMixin:OnEnter()
	TRP3_API.register.togglePsychoCountText(self, true);
end

function TRP3_RegisterTraitLineMixin:OnLeave()
	TRP3_API.register.togglePsychoCountText(self, false);
end

function TRP3_RegisterTraitLineMixin:SetLeftText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.LeftText:SetText(text);
end

function TRP3_RegisterTraitLineMixin:SetRightText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.RightText:SetText(text);
end

function TRP3_RegisterTraitLineMixin:SetLeftIcon(icon)
	self.LeftIcon:SetIconTexture(icon);
end

function TRP3_RegisterTraitLineMixin:SetRightIcon(icon)
	self.RightIcon:SetIconTexture(icon);
end

function TRP3_RegisterTraitLineMixin:SetLeftColor(color)
	self.LeftText:SetReadableTextColor(color);
	self.LeftText:SetFixedColor(true);
	self.Bar:SetStatusBarColor(color:GetRGBA());
end

function TRP3_RegisterTraitLineMixin:SetRightColor(color)
	self.RightText:SetReadableTextColor(color);
	self.RightText:SetFixedColor(true);
	self.Bar.OppositeFill:SetVertexColor(color:GetRGBA());
end

TRP3_RegisterColorSwatchMixin = {};

function TRP3_RegisterColorSwatchMixin:OnMouseDown(mouseButtonName)
	if mouseButtonName ~= "RightButton" then
		return;
	end

	local color = self:GetColor();

	local function OnCopyColorClicked()
		local code = "#" .. color:GenerateHexColorOpaque();
		TRP3_API.popup.showCopyDropdownPopup({ code });
	end

	local function OnSaveColorClicked()
		local function OnPopupResponse(name)
			if name == "" then
				name = TRP3_ColorPresetManager.GenerateDefaultPresetName(color);
			end

			TRP3_ColorPresetManager.SaveCustomPreset(name, color);
		end

		local prompt = string.join("|n|n", L.BW_CUSTOM_NAME, L.BW_CUSTOM_NAME_TT);
		TRP3_API.popup.showTextInputPopup(prompt, OnPopupResponse);
	end

	local function GenerateMenu(_, rootDescription)
		rootDescription:CreateButton(L.REG_PLAYER_COLOR_TT_COPY, TRP3_API.SetLastCopiedColor, color);
		rootDescription:CreateButton(L.REG_PLAYER_COLOR_TT_COPYNAME, OnCopyColorClicked);
		rootDescription:CreateButton(L.BW_COLOR_PRESET_SAVE_AS_CUSTOM, OnSaveColorClicked);
	end

	TRP3_MenuUtil.CreateContextMenu(self, GenerateMenu);
end

function TRP3_RegisterColorSwatchMixin:OnTooltipShow(description)
	if self.showContrastTooltip then
		description:AddNormalLine(L.REG_COLOR_SWATCH_WARNING);
		description:AddBlankLine();
		description:AddInstructionLine("RCLICK", L.REG_PLAYER_COLOR_TT_OPTIONS);
	end
end

function TRP3_RegisterColorSwatchMixin:SetShowContrastTooltip(showContrastTooltip)
	self.showContrastTooltip = showContrastTooltip;
	self:RefreshTooltip();
end

TRP3_RegisterInfoLineMixin = {};

function TRP3_RegisterInfoLineMixin:OnLoad()
	self.Value:SetFixedColor(true);
end

function TRP3_RegisterInfoLineMixin:OnSizeChanged(width)
	self.Title:SetWidth(width * 0.3);
end

function TRP3_RegisterInfoLineMixin:SetIcon(icon)
	self.Icon:SetIconTexture(icon);
end

function TRP3_RegisterInfoLineMixin:SetIconShown(shown)
	self.Icon:SetShown(shown);
	self:SetHeight(shown and 34 or 26);
end

function TRP3_RegisterInfoLineMixin:SetTitleText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.Title:SetText(text);
end

function TRP3_RegisterInfoLineMixin:SetValueText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.Value:SetText(text);
end

TRP3_RegisterInfoSwatchLineMixin = CreateFromMixins(TRP3_RegisterInfoLineMixin);

function TRP3_RegisterInfoSwatchLineMixin:SetValueColorFromHexString(hex)
	local color;

	if hex then
		color = TRP3_API.ParseColorFromHexString(hex);
	end

	self:SetValueColor(color);
end

function TRP3_RegisterInfoSwatchLineMixin:SetValueColor(color)
	if color then
		self.Value:SetReadableTextColor(color);
		self.Swatch:SetColor(color);
		self.Swatch:SetShowContrastTooltip(not TRP3_API.IsColorReadable(color, TRP3_PARCHMENT_BACKGROUND_COLOR));
		self.Swatch:Show();
	else
		self.Value:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB());
		self.Swatch:Hide();
	end
end

TRP3_RegisterListRefreshToastMixin = {};

function TRP3_RegisterListRefreshToastMixin:OnLoad()
	self.task = nil;
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.timerMap = TimerUtil.CreateTimedSignalCallbackMap();
	self.shownAt = 0;

	self.showSignal = self.timerMap:RegisterCallback(function() self:PlayShowAnimation(); end);
	self.hideSignal = self.timerMap:RegisterCallback(function() self:PlayHideAnimation(); end);

	self.AnimOut:SetScript("OnFinished", function() self:OnHideAnimationFinished(); end);
	self.Border:SetVertexColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN:GetRGB());
end

function TRP3_RegisterListRefreshToastMixin:OnShow()
	ResizeLayoutMixin.OnShow(self);

	if self.task and self.task:GetState() == "running" then
		self.shownAt = GetTime();
	end
end

function TRP3_RegisterListRefreshToastMixin:OnHideAnimationFinished()
	self:Hide();
end

---@param _progress TRP3.RegisterListRefreshProgress
function TRP3_RegisterListRefreshToastMixin:OnTaskProgressChanged(_progress)
	self:UpdateProgress();
end

---@param state TRP3.RegisterListRefreshTaskState
function TRP3_RegisterListRefreshToastMixin:OnTaskStateChanged(state)
	if state == "running" then
		self:OnTaskStarted();
	elseif state == "finished" or state == "cancelled" then
		self:OnTaskFinished();
	end
end

function TRP3_RegisterListRefreshToastMixin:OnTaskStarted()
	self:UpdateProgress();
	self:BeginShow();
end

function TRP3_RegisterListRefreshToastMixin:OnTaskFinished()
	self:UpdateProgress();
	self:BeginHide();
end

function TRP3_RegisterListRefreshToastMixin:ClearTask()
	if self.task then
		self.task.UnregisterAllCallbacks(self);
	end

	self.timerMap:CancelSignal(self.showSignal);
	self.timerMap:CancelSignal(self.hideSignal);
	self.task = nil;
	self:Hide();

	self:UpdateProgress();
end

---@param task TRP3.RegisterListRefreshTask
function TRP3_RegisterListRefreshToastMixin:SetTask(task)
	self:ClearTask();

	self.task = task;

	TRP3_API.RegisterCallback(task, "OnStateChanged", self.OnTaskStateChanged, self);
	TRP3_API.RegisterCallback(task, "OnProgressChanged", self.OnTaskProgressChanged, self);
end

---@private
function TRP3_RegisterListRefreshToastMixin:BeginShow()
	self.timerMap:CancelSignal(self.hideSignal);
	self.AnimOut:Stop();

	if not self:IsShown() then
		self.timerMap:SignalAfter(self.showSignal, self.showDelay);
	end
end

---@private
function TRP3_RegisterListRefreshToastMixin:BeginHide()
	self.timerMap:CancelSignal(self.showSignal);

	if self:IsShown() then
		self.timerMap:SignalAt(self.hideSignal, self.shownAt + self.minimumVisibleDuration);
	else
		self:OnHideAnimationFinished();
	end
end

---@private
function TRP3_RegisterListRefreshToastMixin:PlayShowAnimation()
	if self.task and self.task:GetState() == "running" and not self:IsShown() then
		self.AnimIn:Play();
		self:Show();
	end
end

---@private
function TRP3_RegisterListRefreshToastMixin:PlayHideAnimation()
	if self:IsShown() then
		self.AnimOut:Play();
	end
end

---@private
function TRP3_RegisterListRefreshToastMixin:UpdateProgress()
	local state;

	if self.task ~= nil then
		state = self.task:GetState();
	end

	-- SetOnUpdateMode is required to flush hidden status bar values;
	-- interpolated updates can continue from stale rendered value if a
	-- SetValue call without interpolation is made while the bar isn't visible.

	if state == nil or state == "pending" then
		self.ProgressBar:SetOnUpdateMode(Enum.OnUpdateMode.RunOnce);
		self.ProgressBar:SetValue(0, Enum.StatusBarInterpolation.Immediate);
	else
		self.ProgressBar:SetOnUpdateMode(state == "running" and Enum.OnUpdateMode.RunAlways or Enum.OnUpdateMode.RunWhenVisible);
		local progress = self.task:GetProgress();
		local value = (progress.total == 0) and 1 or progress.searched / progress.total;
		self.ProgressBar:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut);
	end
end
