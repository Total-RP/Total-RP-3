-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- TODO: Font object support; should be supplied with the initializers.
-- TODO: The entire about frame API.
-- TODO: Backgrounds
-- TODO: Cleanup DP code
-- TODO: T1 & T3

local SectionFactoryInitializer = {};

function SectionFactoryInitializer:GetTemplate()
	-- Override to return an XML template name for your section.
	return assert(self.templateName);
end

function SectionFactoryInitializer:GetExtent()
	-- Optional; override if the section has a dynamic extent that cannot be
	-- inferred from the size defined in the template.
	return nil;
end

function SectionFactoryInitializer:Factory(factory, initializeCallback)
	factory(self:GetTemplate(), initializeCallback);
end

function SectionFactoryInitializer:InitFrame(frame)
	if frame.Init then
		frame:Init(self);
	end
end

function SectionFactoryInitializer:Resetter(frame)
	if frame.Release then
		frame:Release(self);
	end
end

local SectionTextInitializer = CreateFromMixins(SectionFactoryInitializer);

function SectionTextInitializer:GetTemplate()
	return "TRP3_ProfileAboutSectionTextTemplate";
end

function SectionTextInitializer:GetText()
	return self.text;
end

function SectionTextInitializer:SetText(text)
	self.text = text;
end

local function CreateSectionTextInitializer(text)
	local initializer = TRP3_API.CreateObject(SectionTextInitializer, text);
	initializer:SetText(text);
	return initializer;
end

local SectionTextWithTitleInitializer = CreateFromMixins(SectionTextInitializer);

function SectionTextWithTitleInitializer:GetTemplate()
	return "TRP3_ProfileAboutSectionTextWithTitleTemplate";
end

function SectionTextWithTitleInitializer:GetTitleText()
	return self.titleText;
end

function SectionTextWithTitleInitializer:SetTitleText(titleText)
	self.titleText = titleText;
end

function SectionTextWithTitleInitializer:GetTitleIcon()
	return self.titleIcon;
end

function SectionTextWithTitleInitializer:SetTitleIcon(titleIcon)
	self.titleIcon = titleIcon;
end

local function CreateSectionTextWithTitleInitializer(text, title, icon)
	local initializer = TRP3_API.CreateObject(SectionTextWithTitleInitializer, text, title, icon);
	initializer:SetText(text);
	initializer:SetTitleText(title);
	initializer:SetTitleIcon(icon);
	return initializer;
end

local SectionTextWithIconInitializer = CreateFromMixins(SectionTextInitializer);

function SectionTextWithIconInitializer:GetTemplate()
	return "TRP3_ProfileAboutSectionTextWithIconTemplate";
end

function SectionTextWithIconInitializer:GetIcon()
	return self.icon;
end

function SectionTextWithIconInitializer:SetIcon(icon)
	self.icon = icon;
end

local function CreateSectionTextWithIconInitializer(text, icon)
	local initializer = TRP3_API.CreateObject(SectionTextWithIconInitializer, text, icon);
	initializer:SetText(text);
	initializer:SetIcon(icon);
	return initializer;
end

local function IsValidAboutSection(section)
	return section ~= nil and section.TX ~= nil and string.trim(section.TX) ~= "";
end

local function CreateAboutTemplate1DataProvider(data)
	local elements = {};

	if IsValidAboutSection(data) then
		local element = CreateSectionTextInitializer(data.TX);
		table.insert(elements, element);
	end

	return TRP3_ScrollUtil.CreateStaticDataProvider(elements);
end

local function CreateAboutTemplate2DataProvider(data)
	local elements = {};

	for _, section in ipairs(data) do
		if IsValidAboutSection(section) then
			local element = CreateSectionTextWithIconInitializer(section.TX, section.IC);
			table.insert(elements, element);
		end
	end

	return TRP3_ScrollUtil.CreateStaticDataProvider(elements);
end

local function CreateAboutTemplate3DataProvider(data)
	local elements = {};

	if IsValidAboutSection(data.PH) then
		local section = data.PH;
		local element = CreateSectionTextWithTitleInitializer(section.TX, section.TI, section.IC);
		table.insert(elements, element);
	end

	if IsValidAboutSection(data.PS) then
		local section = data.PS;
		local element = CreateSectionTextWithTitleInitializer(section.TX, section.TI, section.IC);
		table.insert(elements, element);
	end

	if IsValidAboutSection(data.HI) then
		local section = data.HI;
		local element = CreateSectionTextWithTitleInitializer(section.TX, section.TI, section.IC);
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

	local function CalculateExtent(_, initializer)
		local extent = initializer:GetExtent();

		if not extent then
			local pool = GetOrCreatePool(initializer:GetTemplate());
			local frame = pool:Acquire();
			initializer:InitFrame(frame);
			extent = scrollBoxView:GetFrameExtent(frame);
			initializer:Resetter(frame);
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

TRP3_ProfileAboutSectionTextMixin = {};

function TRP3_ProfileAboutSectionTextMixin:Init(initializer)
	print("SectionText.Init");
	self:Layout();
end

TRP3_ProfileAboutSectionTextWithTitleMixin = {};

function TRP3_ProfileAboutSectionTextWithTitleMixin:Init(initializer)
	print("SectionTextWithTitle.Init");
	self:Layout();
end

TRP3_ProfileAboutSectionTextWithIconMixin = {};

function TRP3_ProfileAboutSectionTextWithIconMixin:Init(initializer)
	-- print("SectionTextWithIcon.Init");

	self.Text:SetRichText(initializer:GetText());
	self.Icon:SetIconTexture(initializer:GetIcon());

	if self.GetOrderIndex and self:GetOrderIndex() % 2 == 1 then
		self.Icon:SetPoint("LEFT", 15, 0);
		self.Text:SetPoint("LEFT", self.Icon, "RIGHT", 10, 0);
		self.Text:SetPoint("TOPRIGHT", -20, -10);
	else
		self.Icon:SetPoint("RIGHT", -15, 0);
		self.Text:SetPoint("RIGHT", self.Icon, "LEFT", -10, 0);
		self.Text:SetPoint("TOPLEFT", 20, -10);
	end

	self.Text:Layout();
	self:Layout();
	self:Show();
end
