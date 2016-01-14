----------------------------------------------------------------------------------
-- Total RP 3: Document system
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------
local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local _G, assert, tostring, tinsert, wipe, pairs = _G, assert, tostring, tinsert, wipe, pairs;
local loc = TRP3_API.locale.getText;
local Log = Utils.log;
local EMPTY = TRP3_API.globals.empty;
local getClass = TRP3_API.extended.getClass;

local documentFrame = TRP3_DocumentFrame;
local HTMLFrame = documentFrame.scroll.child.HTML;

TRP3_API.extended.document = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTILS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MARGIN = 100;

local function setFrameSize(width, height)
	TRP3_DocumentFrame:SetSize(width, height);
	HTMLFrame:SetSize(width - MARGIN, 5);
	HTMLFrame:SetText(HTMLFrame.html);
end

local function setFrameHTML(html)
	HTMLFrame.html = Utils.str.toHTML(html);
	HTMLFrame:SetText(HTMLFrame.html);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Document API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function showDocument(documentID)
	local document = getClass(documentID);

	local HTML = "";
	if document.PA and document.PA[1] then
		HTML = document.PA[1].TX or "";
	end

	documentFrame.ID = documentID;
	documentFrame.class = document;

	setFrameHTML(HTML);
	setFrameSize(document.WI or 450, document.HE or 600);
	documentFrame:Show();
	return 0;
end
TRP3_API.extended.document.showDocument = showDocument;

local function onLinkClicked(self, url)
	if documentFrame.class and documentFrame.class.AC and documentFrame.class.AC[url] and documentFrame.class.SC then
		local scriptID = documentFrame.class.AC[url];
		local retCode = TRP3_API.script.executeClassScript(scriptID, documentFrame.class.SC,
			{
				documentID = documentFrame.ID, documentClass = documentFrame.class
			});
	end
end

local function closeDocument(documentID)
	if documentFrame:IsVisible() and documentFrame.ID == documentID then
		documentFrame:Hide();
	end
end
TRP3_API.extended.document.closeDocument = closeDocument;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onLoaded()

end

function TRP3_API.extended.document.onStart()

	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, onLoaded);

	-- Customize HTML
	HTMLFrame:SetFontObject("p", GameTooltipHeader);
	HTMLFrame:SetTextColor("p", 0.2824, 0.0157, 0.0157);
	HTMLFrame:SetShadowOffset("p", 0, 0)
	HTMLFrame:SetFontObject("h1", DestinyFontHuge);
	HTMLFrame:SetTextColor("h1", 0, 0, 0);
	HTMLFrame:SetFontObject("h2", QuestFont_Huge);
	HTMLFrame:SetTextColor("h2", 0, 0, 0);
	HTMLFrame:SetFontObject("h3", GameFontNormalLarge);
	HTMLFrame:SetTextColor("h3", 1, 1, 1);
	HTMLFrame:SetScript("OnHyperlinkClick", onLinkClicked);

	-- Effect and operands
	TRP3_API.script.registerEffects({
		document_show = {
			codeReplacementFunc = function (args)
				local documentID = args[1];
				return ("lastEffectReturn = showDocument(\"%s\");"):format(documentID);
			end,
			env = {
				showDocument = "TRP3_API.extended.document.showDocument",
			}
		},

		document_close = {
			codeReplacementFunc = function (args)
				local documentID = args[1];
				return ("lastEffectReturn = closeDocument(\"%s\");"):format(documentID);
			end,
			env = {
				closeDocument = "TRP3_API.extended.document.closeDocument",
			}
		}
	});
end
