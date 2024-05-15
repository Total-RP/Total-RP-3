# Changelog version 2.8.3

## Added

- Added "Open Profile" right-click menu option on Battle.net friends.
  - This will only be shown if the other player is in the same region and using the same client.

## Fixed

- Added a temporary workaround to prevent disconnects under specific conditions.
  - The proper fix will come from Blizzard, this is just a short-term safety measure.
- Fixed an issue where the Kui nameplates customization wouldn't properly hide friendly nameplates according to the settings under specific circumstances.
- Fixed mount and character tooltips overlapping in some cases when the tooltip is anchored on the cursor.

# Changelog version 2.8.2

*The rate limit changes mentioned last version no longer apply in the outdoor world or garrisons. Instances are still heavily limited.*

## Added

- Added "Open Profile" right-click menu option for pets and battle pets.
- Added 94 icons and 47 images from patch 10.2.7 (and earlier).

## Fixed

- Fixed battle pets not being able to get a profile assigned on Cataclysm Classic.
  - As part of this fix, it is now possible to attach a profile to a non-renamed battle pet on Retail. It is still strongly advised to rename battle pets before assigning them a profile.
- Fixed map scan not working if the player was in Telogrus Rift.
- Fixed loading icon sometimes showing on companion tooltips.

# Changelog version 2.8.1

*Profile transfers will currently be much slower on Cataclysm Classic due to rate limit changes. We are looking into changes to alleviate this, but they will take time, please bear with us.*

## Fixed

- Fixed icons not showing in the tooltips on Classic.
- Fixed the "receiving profile" animated icon appearing as a green square on Classic.
- Fixed an issue when editing profiles with an invalid icon (for example, a Retail icon on Classic).
- Pasting a color code into the color picker field will now trim spaces that might have been copied with it to prevent issues.

# Changelog version 2.8.0

## Added

- Added a small indicator at the bottom of the tooltip while receiving updates to a profile.

## Changed

- Chat links will no longer display the added number at the end of the name when sent. (We've also learned that after 1 comes 2, not 12.)

## Fixed

- Fixed tooltip display issues when using non-English characters.
- Fixed error when displaying some NPC companion nameplates.
- Fixed errors when receiving profiles with a music theme not listed in the current addon version.
- Pets will no longer be asked to provide their profiles directly, as they can't reply.
- Fixed an issue where the addon would wait indefinitely for a profile if the transfer was interrupted, preventing from ever receiving that profile again until reload.

# Changelog version 2.7.2

## Added

- Added 4 musics and 8 images from patch 10.2.5.

## Changed

- Icons in the browser have been made bigger once again.
- The icon browser in the glance editor is no longer smaller than everywhere else.

# Changelog version 2.7.1

## Fixed

- Fixed the addon not loading on Mac.

# Changelog version 2.7.0

## Added

- Added 97 icons and 11 musics from patch 10.2.5.
- Added support for party/raid unit tokens in the "/trp3 open" command.

## Changed

- The icon browser has been further updated with a new look:
  - The list of icons shown is now bigger.
  - The currently selected icon is now highlighted and shows first in the list.
  - The search will now ignore punctuation in the icon name.
  - A text indicator will appear if a search hasn't returned any result.
- Additional Information preset fields can no longer be renamed to prevent confusion on the field to modify.
  - Preset fields which were renamed have been turned into custom fields and may need to be set again.
- Keybindings have been moved to a dedicated Total RP 3 category.

## Fixed

- Fixed own pet nameplate not customizing.
- Fixed an issue when trying to import a profile with an invalid music (when importing a Retail profile on Classic for instance).
- Fixed an issue when viewing some icons on first glance slots.
- Fixed some profile fields showing outdated info on other RP addons.
- Fixed some fields not being properly cleaned when received from other addons.

# Changelog version 2.6.2

## Fixed

- Fixed nameplate customization erroring in combat since a recent hotfix.
- Fixed custom names displaying on chat lines they're not supposed to (like preset emotes) while using Prat.

# Changelog version 2.6.1

## Fixed

- Fixed an issue with the nameplates addon detection which could cause the RP names not to apply.
- Fixed the shuffling of the map scans in the dropdown.
- Fixed the companion tooltip not showing on humanoid battle pets.
  - Battle pet types will still be shown incorrectly until Blizzard fixes the bug which caused the issue in the first place.

# Changelog version 2.6.0

## Added

- Added 448 icons, 10 images and 118 musics from patch 10.2.
- Added 5 Classic icons from patch 3.4.3.
- Added profiles to the automation system to allow you to set different automation rules for different characters, especially useful for alternate forms, stance or specialization conditionals.
- Added a new "Launcher settings" category letting you control visibility of the minimap button and addon compartment entry, as well as modifying what actions are executed depending on how you click them (left/middle/right mouse button, with modifier key...).
- Added a guild members map scan.

## Changed

- Reworked the icon browser search to be asynchronous, in order to prevent issues related to the amount of icons in the game.
- Changed the nameplate visibility settings from checkboxes to dropdowns offering clearer control over which nameplates to display or hide.

## Fixed

- Fixed the size of the main window not persisting between sessions. **The position may be reset once upon login with the new version.**
