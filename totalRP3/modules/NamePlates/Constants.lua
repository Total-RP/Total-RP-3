-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local _, TRP3_API = ...;

-- TRP3_API imports.
local L = TRP3_API.loc;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Ellyb imports.
local ColorManager = TRP3_API.Ellyb.ColorManager;
local Icon = TRP3_API.Ellyb.Icon;

-- OOC indicators for text or icon mode appropriately.
NamePlates.OOC_TEXT_INDICATOR = ColorManager.RED("[" .. L.CM_OOC .. "]");
NamePlates.OOC_ICON_INDICATOR = Icon([[Interface\COMMON\Indicator-Red]], 15);

-- Maximum number of characters for displayed titles before cropping.
NamePlates.MAX_TITLE_CHARS = 40;
