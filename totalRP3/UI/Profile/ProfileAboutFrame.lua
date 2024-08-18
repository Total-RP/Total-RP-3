-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

-- TODO: Backgrounds
-- TODO: Cleanup DP code

local AboutElementInitializer = {};

function AboutElementInitializer:GetTemplate()
	-- Override to return an XML template name for your section.
	return assert(self.templateName);
end

function AboutElementInitializer:GetExtent()
	-- Optional; override if the section has a dynamic extent that cannot be
	-- inferred from the size defined in the template.
	return nil;
end

function AboutElementInitializer:Factory(factory, initializeCallback)
	factory(self:GetTemplate(), initializeCallback);
end

function AboutElementInitializer:InitFrame(frame)
	if frame.Init then
		securecallfunction(frame.Init, frame, self);
	end
end

function AboutElementInitializer:Resetter(frame)
	if frame.Release then
		securecallfunction(frame.Release, frame, self);
	end
end

TRP3_AboutHTMLElementMixin = {};

function TRP3_AboutHTMLElementMixin:Init(initializer)
	self.Text:SetRichText(initializer:GetText());
	self:Layout();
end

function TRP3_AboutHTMLElementMixin:Reset()
	self.Text:ClearText();
end

local AboutHTMLInitializer = CreateFromMixins(AboutElementInitializer);

function AboutHTMLInitializer:GetTemplate()
	return "TRP3_AboutHTMLElementTemplate";
end

function AboutHTMLInitializer:GetText()
	return self.text;
end

function AboutHTMLInitializer:SetText(text)
	self.text = text;
end

local function CreateAboutHTMLInitializer(text)
	local initializer = TRP3_API.CreateObject(AboutHTMLInitializer);
	initializer:SetText(text);
	return initializer;
end

TRP3_AboutHTMLWithIconElementMixin = {};

function TRP3_AboutHTMLWithIconElementMixin:Init(initializer)
	self.Text:SetRichText(initializer:GetText());
	self.Icon:SetIconTexture(initializer:GetIcon());

	self.Icon:ClearAllPoints();
	self.Text:ClearAllPoints();

	if self:GetOrderIndex() % 2 == 1 then
		self.Icon:SetPoint("LEFT", 15, 0);
		self.Text:SetPoint("LEFT", self.Icon, "RIGHT", 10, 0);
		self.Text:SetPoint("TOPRIGHT", -20, -10);
	else
		self.Icon:SetPoint("RIGHT", -15, 0);
		self.Text:SetPoint("RIGHT", self.Icon, "LEFT", -10, 0);
		self.Text:SetPoint("TOPLEFT", 20, -10);
	end

	self:Layout();
end

function TRP3_AboutHTMLWithIconElementMixin:Reset()
	self.Text:ClearText();
end

local AboutHTMLWithIconInitializer = CreateFromMixins(AboutHTMLInitializer);

function AboutHTMLWithIconInitializer:GetTemplate()
	return "TRP3_AboutHTMLWithIconElementTemplate";
end

function AboutHTMLWithIconInitializer:GetIcon()
	return self.icon;
end

function AboutHTMLWithIconInitializer:SetIcon(icon)
	self.icon = icon;
end

local function CreateAboutHTMLWithIconInitializer(text, icon)
	local initializer = TRP3_API.CreateObject(AboutHTMLWithIconInitializer);
	initializer:SetText(text);
	initializer:SetIcon(icon);
	return initializer;
end

TRP3_AboutHTMLWithTitleElementMixin = {};

function TRP3_AboutHTMLWithTitleElementMixin:Init(initializer)
	local iconMarkup = TRP3_MarkupUtil.GenerateIconMarkup(initializer:GetTitleIcon(), { size = 25 });
	self.Title:SetFormattedText("%1$s    %2$s    %1$s", iconMarkup, initializer:GetTitleText());
	self.Text:SetRichText(initializer:GetText());
	self:Layout();
end

function TRP3_AboutHTMLWithTitleElementMixin:Reset()
	self.Text:ClearText();
end

local AboutHTMLWithTitleInitializer = CreateFromMixins(AboutHTMLInitializer);

function AboutHTMLWithTitleInitializer:GetTemplate()
	return "TRP3_AboutHTMLWithTitleElementTemplate";
end

function AboutHTMLWithTitleInitializer:GetTitleText()
	return self.titleText;
end

function AboutHTMLWithTitleInitializer:SetTitleText(titleText)
	self.titleText = titleText;
end

function AboutHTMLWithTitleInitializer:GetTitleIcon()
	return self.titleIcon;
end

function AboutHTMLWithTitleInitializer:SetTitleIcon(titleIcon)
	self.titleIcon = titleIcon;
end

local function CreateAboutHTMLWithTitleInitializer(text, title, icon)
	local initializer = TRP3_API.CreateObject(AboutHTMLWithTitleInitializer);
	initializer:SetText(text);
	initializer:SetTitleText(title);
	initializer:SetTitleIcon(icon);
	return initializer;
end

local function IsValidAboutSection(section)
	return section ~= nil and section.TX ~= nil and string.trim(section.TX) ~= "";
end

local function CreateAboutTemplate1DataProvider(data)
	local elements = {};

	if IsValidAboutSection(data) then
		local element = CreateAboutHTMLInitializer(data.TX);
		table.insert(elements, element);
	end

	return TRP3_ScrollUtil.CreateStaticDataProvider(elements);
end

local function CreateAboutTemplate2DataProvider(data)
	local elements = {};

	for _, section in ipairs(data) do
		if IsValidAboutSection(section) then
			local element = CreateAboutHTMLWithIconInitializer(section.TX, section.IC);
			table.insert(elements, element);
		end
	end

	return TRP3_ScrollUtil.CreateStaticDataProvider(elements);
end

local function CreateAboutTemplate3DataProvider(data)
	local elements = {};

	if IsValidAboutSection(data.PH) then
		local section = data.PH;
		local title = L.REG_PLAYER_PHYSICAL;
		local icon = section.IC or TRP3_InterfaceIcons.PhysicalSection;
		local element = CreateAboutHTMLWithTitleInitializer(section.TX, title, icon);
		table.insert(elements, element);
	end

	if IsValidAboutSection(data.PS) then
		local section = data.PS;
		local title = L.REG_PLAYER_PSYCHO;
		local icon = section.IC or TRP3_InterfaceIcons.TraitSection;
		local element = CreateAboutHTMLWithTitleInitializer(section.TX, title, icon);
		table.insert(elements, element);
	end

	if IsValidAboutSection(data.HI) then
		local section = data.HI;
		local title = L.REG_PLAYER_HISTORY;
		local icon = section.IC or TRP3_InterfaceIcons.HistorySection;
		local element = CreateAboutHTMLWithTitleInitializer(section.TX, title, icon);
		table.insert(elements, element);
	end

	return TRP3_ScrollUtil.CreateStaticDataProvider(elements);
end

local function InitSectionExtentCalculator(scrollBoxView)
	local pools = CreateFramePoolCollection();

	local function GetOrCreatePool(template)
		-- In 11.0.x the GetPool method will error if we attempt to retrieve a
		-- pool that doesn't yet exist - which is unfortunately precisely what
		-- we're trying to do. Clean this up when resolved.
		--
		-- See: <https://github.com/Stanzilla/WoWUIBugs/issues/632>

		local ok, pool = pcall(pools.GetPool, pools, template);

		if not ok or not pool then
			local templateInfo = C_XMLUtil.GetTemplateInfo(template);
			local parent = scrollBoxView:GetScrollTarget();
			pool = pools:CreatePool(templateInfo.type, parent, template);
		end

		return pool;
	end

	local function CalculateExtent(dataIndex, initializer)
		local extent = initializer:GetExtent();

		if not extent then
			-- Extent calculation based off the frame extent requires us to
			-- basically set the frame up identically to how scrollview
			-- internally prepares the frame.

			local pool = GetOrCreatePool(initializer:GetTemplate());
			local frame = pool:Acquire();

			scrollBoxView:AssignAccessors(frame, initializer);
			frame:SetOrderIndex(dataIndex);
			frame:Show();

			scrollBoxView:GetLayoutFunction()(dataIndex, frame, 0);

			initializer:InitFrame(frame);
			extent = scrollBoxView:GetFrameExtent(frame);

			if not scrollBoxView:GetScrollTarget():IsRectValid() then
				-- FIXME: Gosh heckin' darn it. Probably just bite the bullet
				--        and devirtualize + use a VLF with a linear view.
				AnchorUtil.PrintAnchorGraph(frame)
			end

			initializer:Resetter(frame);

			scrollBoxView:UnassignAccessors(frame);
			pool:Release(frame);
		end

		return extent;
	end

	scrollBoxView:SetElementExtentCalculator(CalculateExtent);
end

TRP3_ProfileAboutFrameMixin = {};

function TRP3_ProfileAboutFrameMixin:OnLoad()
	self.ScrollView = CreateScrollBoxListLinearView(self.paddingTop, self.paddingBottom, self.paddingLeft, self.paddingRight, self.spacing);
	self.ScrollBox:SetInterpolateScroll(self.canInterpolateScroll);
	self.ScrollBar:SetInterpolateScroll(self.canInterpolateScroll);

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 0, 0),
		AnchorUtil.CreateAnchor("BOTTOM", self, "BOTTOM", 0, 0),
		AnchorUtil.CreateAnchor("RIGHT", self.ScrollBar, "LEFT", -8, 0),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0),
	};

	TRP3_ScrollUtil.InitScrollBoxViewWithFactoryInitializer(self.ScrollView);
	InitSectionExtentCalculator(self.ScrollView);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
end

function TRP3_ProfileAboutFrameMixin:Render(data)
	local template = data and data.TE or nil;
	local provider;

	if template == 1 and data.T1 ~= nil then
		provider = CreateAboutTemplate1DataProvider(data.T1);
	elseif template == 2 and data.T2 ~= nil then
		provider = CreateAboutTemplate2DataProvider(data.T2);
	elseif template == 3 and data.T3 ~= nil then
		provider = CreateAboutTemplate3DataProvider(data.T3);
	end

	if provider then
		local retainScrollPosition = false;
		self.ScrollBox:SetDataProvider(provider, retainScrollPosition);
	else
		self.ScrollBox:RemoveDataProvider();
	end

	-- TODO: Pan extent should be derived from font sizes.
	self.ScrollBox:SetPanExtent(2.5*15);
end
