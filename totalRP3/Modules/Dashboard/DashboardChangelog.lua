-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local CHANGELOG_TEXT = [[
# Changelog version 3.0.10

## Added

- Added compatibility with patch 11.1.5.
- Added 665 icons and 96 musics from patch 11.1.0 and 11.1.5.
  - Added 13 icons for Cataclysm Classic.
  - Added 4 icons and 3 musics for Classic Era.

## Fixed

- Fixed "Open profile" not showing when right-clicking a player from a community member list.
- Fixed an issue when using Prat where the setting to remove realm from character names wasn't working.

## Removed

- Removed the maximize button.
- Removed the Wago Analytics module.

For a visual guide to the major changes of version 3.0, please see [this article](https://github.com/Total-RP/Total-RP-3/wiki/Guide-to-version-3.0) on our wiki.
]];

function TRP3_DashboardUtil.GenerateChangelog()
	return TRP3_DashboardUtil.GenerateListMarkup(CHANGELOG_TEXT);
end
