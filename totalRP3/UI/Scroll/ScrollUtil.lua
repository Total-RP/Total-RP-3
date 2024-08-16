-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ScrollUtil = {};

function TRP3_ScrollUtil.CreateStaticDataProvider(elements)
	local provider = CreateFromMixins(CallbackRegistryMixin);
	provider:GenerateCallbackEvents({ "OnSizeChanged" });

	function provider:Find(i)
		return elements[i];
	end

	function provider:GetSize()
		return #elements;
	end

	function provider:Enumerate()
		return ipairs(elements);
	end

	provider:OnLoad();

	return provider;
end

function TRP3_ScrollUtil.InitScrollBoxViewWithFactoryInitializer(scrollBoxView)
	local function Initializer(frame, elementData)
		elementData:InitFrame(frame);
	end

	local function Factory(factory, elementData)
		elementData:Factory(factory, Initializer);
	end

	local function Resetter(frame, elementData)
		elementData:Resetter(frame);
	end

	local function ExtentCalculator(_, elementData)
		local extent = elementData:GetExtent();

		if not extent then
			extent = scrollBoxView:GetTemplateExtent(elementData:GetTemplate());
		end

		-- If this fires then the template associated with the element likely
		-- has no statically defined size in XML. Set one, or override the
		-- GetExtent method on the element itself to return a non-nil value.

		assert(extent ~= nil, "element has an invalid extent", elementData);

		return extent;
	end

	scrollBoxView:SetElementFactory(Factory);
	scrollBoxView:SetElementResetter(Resetter);
	scrollBoxView:SetElementExtentCalculator(ExtentCalculator);

	return scrollBoxView;
end
