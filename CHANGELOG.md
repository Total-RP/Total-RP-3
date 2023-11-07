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

# Changelog version 2.5.5

## Added

- Added 3 musics, 4 images and 76 icons from patch 10.1.7.
- Added setting to crop long guild names on RP nameplates.

## Fixed

- Improved icon browser performance to deal with an occasional addon loading issue.
- Fixed a recycling issue with RP nameplates when using Plater Nameplates.

# Changelog version 2.5.4

## Added

- Added 53 musics, 45 images and 169 icons from patch 10.1.5 and before (some previously encrypted icons).

## Fixed

- Fixed close/minimize/resize buttons positions for Retail.
- Fixed a bug with the dashboard potentially related to Prat.

# Changelog version 2.5.3

## Fixed

- Prevented invalid dice roll messages from showing.
- Updated TaintLess library for patch 3.4.2.

# Changelog version 2.5.2

## Fixed

- Fixed an issue with the Plater RP nameplates getting stuck on screen.

# Changelog version 2.5.1

## Fixed

- Fixed an error with the Prat module out if a player had no custom color.
- Fixed an error with chat links.
- Empty guild rank/name fields will now display default values in the tooltip.
- Fixed an issue with "No player named..." messages appearing when hovering players on realms with non-latin characters.

# Changelog version 2.5.0

## Added

- Added 503 icons, 15 images and 70 musics from patch 10.1.
- Added Automation system, accessible in the settings
  - This allows you to automate actions based on macro conditionals.
  - Actions include changing your profile, your roleplay status, whether the map scan is enabled or not...
  - For a list of macro conditionals, see [our wiki article](https://github.com/Total-RP/Total-RP-3/wiki/Macro-conditionals).
- Added Analytics module
  - **This is strictly opt-in and only applies to users of the Wago Addons client who enabled "Help addon developers".**
  - For more details, see [our wiki article](https://github.com/Total-RP/Total-RP-3/wiki/Analytics-in-Total-RP-3).
- Added entry in the new addon compartment located below the calendar button, with the same actions as the minimap button.
- Added tooltip indicator if the guild fields have been customized, as well as options to display both/either custom and in-game guild info.
- Added ability to get the party started.

## Changed

- "Always show target" nameplate option will now display the target nameplate even if it is OOC and "Hide out of character units" was enabled.
