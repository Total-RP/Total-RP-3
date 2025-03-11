-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local CHANGELOG_TEXT = [[
# Changelog version 3.0.9

## Fixed

- Fixed icon button right-click menu not appearing.

# Changelog version 3.0.8

## Added

- Right-clicking color picker buttons now opens a menu to copy, paste or discard colors.

## Fixed

- Fixed a Lua error appearing when opening some dropdowns (like walk-up friendly or RP proficiency).

# Changelog version 3.0.7

## Added

- Added 24 images from patch 11.1.0.
  - Icons and musics will be added in a future release.
- Added support for the new addon group feature in the addon list.

## Fixed

- Fixed nameplates not customizing properly if using Plater while disabling its friendly nameplates module.
- Fixed missing UI icons on Classic.

# Changelog version 3.0.6

## Added

- Added 5 images from patch 11.0.7.
- Added a warning that the addon will not exchange profiles when chat is disabled.

## Fixed

- Fixed description not displaying correctly when editing a relation in non-English languages.
- Fixed addon locale setting not working properly.
- Fixed toolbar buttons compatibility with addons like ElvUI or TitanPanel.
- Fixed icon display issues when Retail icons are manually added to older clients.

For a visual guide to the major changes of version 3.0, please see [this article](https://github.com/Total-RP/Total-RP-3/wiki/Guide-to-version-3.0) on our wiki.
]];

function TRP3_DashboardUtil.GenerateChangelog()
	return TRP3_DashboardUtil.GenerateListMarkup(CHANGELOG_TEXT);
end
