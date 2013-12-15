--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local log = TRP3_Log;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Icon utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_InitIconButton(self, icon)
	assert(self, "Frame is nil");
	assert(_G[self:GetName().."Icon"], "Frame must have a Icon");
	_G[self:GetName().."Icon"]:SetTexture("Interface\\ICONS\\"..icon);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Fieldsets
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local FIELDSET_DEFAULT_CAPTION_WIDTH = 100;

function TRP3_FieldSet_SetCaption(fieldset, text, size)
	if fieldset and _G[fieldset:GetName().."CaptionPanelCaption"] then
		_G[fieldset:GetName().."CaptionPanelCaption"]:SetText(text);
		if _G[fieldset:GetName().."CaptionPanel"] then
			_G[fieldset:GetName().."CaptionPanel"]:SetWidth(size or FIELDSET_DEFAULT_CAPTION_WIDTH);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tab bar
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabBar_index = 0;
local tabBar_HEIGHT_SELECTED = 34;
local tabBar_HEIGHT_NORMAL = 32;

local function tabBar_onSelect(tabGroup, index)
	assert(#tabGroup >= index, "Index out of bound.");
	local i;
	for i=1, #tabGroup do
		local widget = tabGroup[i];
		if i == index then
			widget:SetAlpha(1);
			widget:Disable();
			widget:LockHighlight();
			_G[widget:GetName().."Left"]:SetHeight(tabBar_HEIGHT_SELECTED);
			_G[widget:GetName().."Middle"]:SetHeight(tabBar_HEIGHT_SELECTED);
			_G[widget:GetName().."Right"]:SetHeight(tabBar_HEIGHT_SELECTED);
			widget:GetHighlightTexture():SetAlpha(0.7);
			widget:GetHighlightTexture():SetDesaturated(1);
		else
			widget:SetAlpha(0.85);
			widget:Enable();
			widget:UnlockHighlight();
			_G[widget:GetName().."Left"]:SetHeight(tabBar_HEIGHT_NORMAL);
			_G[widget:GetName().."Middle"]:SetHeight(tabBar_HEIGHT_NORMAL);
			_G[widget:GetName().."Right"]:SetHeight(tabBar_HEIGHT_NORMAL);
			widget:GetHighlightTexture():SetAlpha(0.5);
			widget:GetHighlightTexture():SetDesaturated(0);
		end
	end
end

function TRP3_TabBar_Create(tabBar, data, callback)
	assert(tabBar, "The tabBar can't be nil");
	
	local lastWidget = nil;
	local tabGroup = {};
	for index, tabData in pairs(data) do
		local text = tabData[1];
		local value = tabData[2];
		local width = tabData[3];
		local tabWidget = CreateFrame("Button", "TRP3_TabBar_Tab_" .. tabBar_index, tabBar, "TRP3_TabBar_Tab");
		if lastWidget == nil then
			tabWidget:SetPoint("LEFT", 0, 0);
		else
			tabWidget:SetPoint("LEFT", lastWidget, "RIGHT", 2, 0);
		end
		tabWidget:SetText(text);
		tabWidget:SetWidth(width or (text:len() * 11));
		tabWidget:SetScript("OnClick", function(self)
			tabBar_onSelect(tabGroup, index);
			if callback then
				callback(tabWidget, value);
			end
		end);
		
		tinsert(tabGroup, tabWidget);
		lastWidget = tabWidget;
		tabBar_index = tabBar_index + 1;
	end
	tabGroup[1]:GetScript("OnClick")(tabGroup[1]);
	return tabGroup;
end