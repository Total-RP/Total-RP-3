# Changelog for version 1.3.5.1

## Fixed

- Removed the workaround for the realm name issue introduced in yesterday's maintenance as it was causing multiple issues in other parts of the add-on. We are now using LibRealmInfo instead, which is more stable.

# Changelog for version 1.3.5

## Fixed

- Fixed issue when trying to get realm name introduced with the latest maintenance.
- Fixed an error that would prevent the add-on from having access to the game's tooltip when using friendly nameplates in dungeons.
- Fixed an issue with the WIM custom chat module when the option to disable chat features when Out Of Character was enabled.
- Fixed an issue that would make the tooltip flicker briefly when using the option to position the tooltip on the cursor.

## Added

- Added custom chat module for ElvUI (now required as they are no longer using standard functions to get player names).
- Added custom skinning module for ElvUI, to apply ElvUI's theme to the tooltip and target frame (can be disabled in the new ElvUI settings tab).  
![](https://www.dropbox.com/s/g57644riwygwww9/elvui_tooltip.png?raw=1)
