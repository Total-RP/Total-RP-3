-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local SharedMenuProperties = {};

function SharedMenuProperties:__init()
	self.menuResponseCallbacks = {};
end

function SharedMenuProperties:AddMenuResponseCallback(callback)
	table.insert(self.menuResponseCallbacks, callback);
end

function SharedMenuProperties:GetMenuResponseCallbacks()
	return self.menuResponseCallbacks;
end

local function CreateSharedMenuProperties()
	return TRP3_API.CreateObject(SharedMenuProperties);
end

local BaseMenuDescription = {};

function BaseMenuDescription:__init()
	self.elementDescriptions = {};
	self.initializers = {};
end

function BaseMenuDescription:Insert(description, index)
	description:SetSharedMenuProperties(self:GetSharedMenuProperties());

	if index then
		table.insert(self.elementDescriptions, index, description);
	else
		table.insert(self.elementDescriptions, description);
	end

	return description;
end

function BaseMenuDescription:EnumerateElementDescriptions()
	return ipairs(self.elementDescriptions);
end

function BaseMenuDescription:HasElements()
	return next(self.elementDescriptions) ~= nil;
end

function BaseMenuDescription:CanOpenSubmenu()
	return self:HasElements();
end

function BaseMenuDescription:GetMinimumWidth()
	return self.minimumWidth or 0;
end

function BaseMenuDescription:SetMinimumWidth(width)
	self.minimumWidth = width;
end

function BaseMenuDescription:AddInitializer(initializer)
	-- Note: Initializers differs between modern and legacy menu renderers.
	table.insert(self.initializers, initializer);
end

function BaseMenuDescription:GetInitializers()
	return self.initializers;
end

function BaseMenuDescription:GetSharedMenuProperties()
	return self.sharedMenuProperties;
end

function BaseMenuDescription:SetSharedMenuProperties(sharedMenuProperties)
	self.sharedMenuProperties = sharedMenuProperties;
end

function BaseMenuDescription:GetMenuResponseCallbacks()
	return self:GetSharedMenuProperties():GetMenuResponseCallbacks();
end

local MenuElementDescription = CreateFromMixins(BaseMenuDescription);

function MenuElementDescription:GetData()
	return self.data;
end

function MenuElementDescription:SetData(data)
	self.data = data;
end

function MenuElementDescription:IsEnabled()
	if self.isEnabled == nil then
		return true;
	elseif type(self.isEnabled) == "boolean" then
		return self.isEnabled;
	else
		return self.isEnabled(self);
	end
end

function MenuElementDescription:SetEnabled(isEnabled)
	self.isEnabled = isEnabled;
end

function MenuElementDescription:SetRadio(isRadio)
	self.isRadio = isRadio;
end

function MenuElementDescription:IsRadio()
	return self.isRadio;
end

function MenuElementDescription:IsSelected()
	if self.isSelected == nil then
		return false;
	elseif type(self.isSelected) == "boolean" then
		return self.isSelected;
	else
		return self.isSelected(self:GetData());
	end
end

function MenuElementDescription:SetIsSelected(isSelected)
	self.isSelected = isSelected;
end

function MenuElementDescription:GetOnEnter()
	return self.onEnter;
end

function MenuElementDescription:HandleOnEnter(frame)
	if self.onEnter then
		self.onEnter(frame, self);
	end
end

function MenuElementDescription:SetOnEnter(onEnter)
	self.onEnter = onEnter;
end

function MenuElementDescription:GetOnLeave()
	return self.onLeave;
end

function MenuElementDescription:HandleOnLeave(frame)
	if self.onLeave then
		self.onLeave(frame, self);
	end
end

function MenuElementDescription:SetOnLeave(onLeave)
	self.onLeave = onLeave;
end

local function DefaultTooltipInitializer(tooltip, elementDescription)
	local titleText = TRP3_MenuUtil.GetElementText(elementDescription);
	GameTooltip_SetTitle(tooltip, titleText);
end

function MenuElementDescription:SetTooltip(initializer)
	if not initializer then
		initializer = DefaultTooltipInitializer;
	end

	local function OnEnter(frame)
		TRP3_MenuUtil.ShowTooltip(frame, initializer, self);
	end

	self:SetOnEnter(OnEnter);
end

function MenuElementDescription:SetResponder(callback)
	self.responder = callback;
end

function MenuElementDescription:Pick(menuInputData)
	local response;

	if self.responder then
		response = self.responder(self:GetData(), menuInputData);
	end

	if response == nil then
		response = self:GetDefaultResponse();
	end

	return response;
end

function MenuElementDescription:GetDefaultResponse()
	return self.defaultResponse;
end

function MenuElementDescription:SetResponse(response)
	self.defaultResponse = response;
end

function MenuElementDescription:GetSoundKit()
	if type(self.soundKit) == "number" then
		return self.soundKit;
	else
		return self.soundKit(self);
	end
end

function MenuElementDescription:SetSoundKit(soundKit)
	self.soundKit = soundKit;
end

function MenuElementDescription:CreateButton(text, callback, data)
	return self:Insert(TRP3_MenuUtil.CreateButton(text, callback, data));
end

function MenuElementDescription:CreateCheckbox(text, isSelected, setSelected, data)
	return self:Insert(TRP3_MenuUtil.CreateCheckbox(text, isSelected, setSelected, data));
end

function MenuElementDescription:CreateDivider()
	return self:Insert(TRP3_MenuUtil.CreateDivider());
end

function MenuElementDescription:CreateRadio(text, isSelected, setSelected, data)
	return self:Insert(TRP3_MenuUtil.CreateRadio(text, isSelected, setSelected, data));
end

function MenuElementDescription:CreateTitle(text, color)
	return self:Insert(TRP3_MenuUtil.CreateTitle(text, color));
end

local RootMenuDescription = CreateFromMixins(MenuElementDescription);

function RootMenuDescription:__init()
	BaseMenuDescription.__init(self);
	self.sharedMenuProperties = CreateSharedMenuProperties();
end

function RootMenuDescription:AddMenuResponseCallback(callback)
	self:GetSharedMenuProperties():AddMenuResponseCallback(callback);
end

TRP3_Menu = {};

function TRP3_Menu.CreateMenuElementDescription()
	return TRP3_API.CreateObject(MenuElementDescription);
end

function TRP3_Menu.CreateRootMenuDescription()
	return TRP3_API.CreateObject(RootMenuDescription);
end
