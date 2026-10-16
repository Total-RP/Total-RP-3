-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local CHANGELOG_TEXT = [[
# Changelog version 3.5.2

## Added

- Added 3 new backgrounds for the About page.
- When creating/importing/duplicating a new profile, if a profile named with the default "Realm - Name" format already exists, a number is now added to the initial suggested name.
- Added sounds for the map scan on Classic.

## Changed

- The directory entries on the left side of the main TRP window now display the full name rather than the first name.

## Fixed

- Fixed a Lua error when trying to display target names while they are secret.
- Fixed a Lua error when hovering water elementals in combat on Forever.
- Removed the ability to open the right-click menu on default profiles.

# Changelog version 3.5.0

## Added

- Added support for icons without official filenames, as well as class/race icons.
- Icons can now be searched by ID.
- When selecting an icon in the browser, typing the exact icon name or ID in the search bar and pressing Enter will automatically select that icon.
- Added |cnGREEN_FONT_COLOR:[time:...]|r and |cnGREEN_FONT_COLOR:[weather:...]|r custom macro conditionals for automation.
  - For more details, see {link*https://github.com/Total-RP/Total-RP-3/wiki/Macro-conditionals*our doc on macro conditionals}
- The About tab will now be disabled when the profile contains no description or music theme.
- When creating a new profile, pressing Enter will create the profile without needing to click the "Create profile" button.
- Added a warning when music may not play due to sound settings.

## Changed

- The relations list has been visually improved, including better scrolling and drag-and-drop behaviour, more intuitive and readable example lines, and a tutorial structure.
- Text search and sort functions across the addon now ignore accents and Unicode characters.
- OOC detection was made smarter to handle smileys and nested parentheses.
  - The OOC pattern setting was removed as a result.
- Improved profile importer error messaging, and made older profile imports more reliable when pasting extra characters before the exported string.
- Improved profile exporter messaging, and removed exporter size limit.
- The "Crop unreasonably long texts" tooltip option is now permanently enabled.

## Fixed

- Creating a profile should once again automatically switch to it.
- Fixed priority of pins on the map scan: players with relations are displayed above other pins, players on other war mode settings will no longer be forced above other pins.
- Fixed issues with NPC emotes display when using Prat.
- Fixed Lua error when using Prat while the Chat frames module is disabled.
- The icon browser will now reliably close on Escape no matter where it was opened from.
- Fixed issues when using the default color picker on the About page.
- Fixed notes and relations data being shared incorrectly when linking a profile.

## Whatever this is

- Added right-click menu options for recent allies.
- Removed right-click menu options for recent allies (and other friendlist entries) until Blizzard fixes the taint issues with them.

# Changelog version 3.4.3

## Fixed

- Fixed an issue with names not being colored while out of the health bar even when the setting to color them was on.
- Fixed an issue with invisible castbars while using BetterBlizzPlates
- Fixed an issue with nameplates while using Plater

# Changelog version 3.4.2

## Fixed

- Fixed secret errors with nameplates.
- Fixed name text color not reverting to white while the text is inside the health bar.
- The right-click menu option to change your character's RP status is now available while right-clicking your name in chat.

## Changed

- The "Hide bars on Blizzard nameplates" is now tied to the new persistent setting "Show only text" in the game's nameplates settings.
  - The setting has been kept for now while players learn of the existence of the one in the game settings, and will likely be removed in the future.

# Changelog version 3.4.1

## Fixed

- Fixed an issue with the Currently/OOC info editboxes not being editable.

# Changelog version 3.4.0

## Added

- Added 399 icons, 58 images and 92 musics from patch 12.1.0 and earlier.
  - Note: For the foreseeable future, expect many new icons to not be added to the icon browser, as Blizzard is removing icon names from the game files.
- Added a Directory setting to make the About page easier to read. It forces the background to black and removes custom text colours.
- Added handles to reorder relations.
- Added RP name support to the raid warning channel.

## Changed

- The profile list page has been overhauled, including a new flow for profile creation.
  - Importing a profile is now done through profile creation (rather than overwriting an existing profile).
- Relations can now be deleted even when still assigned to any profile.

## Fixed

- Fixed some errors related to patch 12.1 API changes.
]];

function TRP3_DashboardUtil.GenerateChangelog()
	return TRP3_DashboardUtil.GenerateListMarkup(CHANGELOG_TEXT);
end
