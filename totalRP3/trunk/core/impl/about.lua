----------------------------------------------------------------------------------
-- Total RP 3
-- About page
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local loc = TRP3_API.locale.getText;
local _G, tonumber, math, tinsert, type, assert, tostring, pairs, sort, strconcat = _G, tonumber, math, tinsert, type, assert, tostring, pairs, table.sort, strconcat;


TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	-- Page and menu
	registerMenu({
		id = "main_zz_about",
		text = loc("ABOUT_TITLE"),
		onSelected = function()  end,
	});

end);