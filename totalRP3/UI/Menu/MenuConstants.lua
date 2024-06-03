-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_USE_MODERN_MENUS = DoesTemplateExist("MenuTemplateBase");

TRP3_MenuResponse = MenuResponse or {
	Open = 1,
	Refresh = 2,
	Close = 3,
	CloseAll = 4,
};

TRP3_MenuInputContext = MenuInputContext or {
	None = 1,
	MouseButton = 2,
	MouseWheel = 3,
}

TRP3_DROPDOWN_MENU_POINT = "TOPLEFT";
TRP3_DROPDOWN_MENU_OFFSET_X = 0;
TRP3_DROPDOWN_MENU_OFFSET_Y = TRP3_USE_MODERN_MENUS and 0 or 6;
TRP3_DROPDOWN_MENU_RELATIVE_POINT = "BOTTOMLEFT";
