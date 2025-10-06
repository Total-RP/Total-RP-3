-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local CHANGELOG_TEXT = [[
# Changelog version 3.1.2

## Changed

- The profile directory has received some changes:
  - The relation column will now sort by relation order rather than alphabetically, and None relation will always sort to the bottom.
  - The guild and realm columns have been added (only visible if the window is wide enough to display them).
  - The profile type column has been removed.
  - The entire line can now be hovered and clicked rather than only a portion of it.
- Glances will no longer display leading/trailing spaces and excess newlines.
- The dice roll broadcast line can now be right-clicked to see the sender's character name.
- Dice rolls broadcast to a target will not show if sent in quick succession. This doesn't apply to party/raid broadcast.

## Fixed

- Fixed Enter/Escape not working on popups requiring an input.

# Changelog version 3.1.1

## Fixed

- Profiles with notes or relations are once again protected from auto-purge.

# Changelog version 3.1.0

## Added

- Added an indicator on the main profile view when the profile is currently getting received.
- Added 485 icons, 12 images and 94 musics from patch 11.2.

## Changed

- Changed the format of profile exports to allow bigger profiles to be exported, and avoid issues with data becoming invalid after copy/pasting the exports on some platforms.
  - Older profile exports can still be imported as before.

## Fixed

- Restore settings to enable/disable buttons on the target frame.
- Toolbar and target frame are now hidden properly when starting a pet battle.
- Fixed some issues with companion profiles in Classic.
- Fixed a bug when pressing the Alt key while a chat link tooltip is open but still currently receiving data.

# Changelog version 3.0.12

## Added

- Added icons and musics for MoP Classic.

# Changelog version 3.0.11

## Added

- Added 65 icons, 7 images and 5 musics from patch 11.1.7.

## Fixed

- Fixed icon links being formatted incorrectly for MRP users.
- Fixed issues with tutorials.

For a visual guide to the major changes of version 3.0, please see [this article](https://github.com/Total-RP/Total-RP-3/wiki/Guide-to-version-3.0) on our wiki.
]];

function TRP3_DashboardUtil.GenerateChangelog()
	return TRP3_DashboardUtil.GenerateListMarkup(CHANGELOG_TEXT);
end
