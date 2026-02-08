# Changelog version 3.2.3

## Fixed

- Fixed a Lua error in instances when nameplates customization is disabled on some units.
- Fixed a Lua error in the Vashj'ir secret room when someone else is doing a map scan.
- Disabled language toolbar button functionality in instances to prevent chat issues during encounters.
- Fixed the tooltip colored border for relations when using ElvUI, and improvements to the looks of the skinned frames. Thanks to Simpy for the help on this.

# Changelog version 3.2.2

## Changed

- Replaced the "Show full titles" checkbox with a subtext dropdown:
  - On Blizzard nameplates, this allows to display full titles and/or guild names.
  - On Platynator nameplates, this allows to choose between full titles or guild names.
  - On Plater nameplates, the setting works as before, allowing to display full titles while guild names are handled by Plater settings.
- When changing the game text language, the addon will now automatically adjust to the new selected language by default.
  - You can re-select a specific language in the addon settings if you don't want the addon automatically adjusting the language.
  - If your addon language settings were already different from the game, this setting was not modified.

## Fixed

- Fixed default class colors not displaying properly in chat (for real this time).
- Fixed some secret-related issues when right-clicking a unit, having soft target enabled, or using Prat.
- Fixed the name-only Blizzard nameplates setting not persisting through client restarts.
- Pet nameplates will no longer have colored text and titles while text-only mode is enabled on Blizzard nameplates.
- Fixed Platynator customization erasing NPC titles when displaying full titles.
- Fixed Blizzard nameplates customization not applying if Kui is left enabled despite not loading.

# Changelog version 3.2.1

## Fixed

- Fixed default class colors not displaying properly in chat.
- Fixed an error when hovering on a character without a profile.
- Fixed tooltips not working when health text is enabled.
  - The text will temporarily not be hidden when the target is at 100% health. We'll investigate a potential fix later.

# Changelog version 3.2.0

## Added

- Added Platynator support for RP nameplates customization. Thanks to Peterodox for the work on it.
- Added 1930 icons and 74 musics from patch 12.0.0.

## Changed

- Modified the behaviour of the language button. Left-click now switches to the next language in the list, while right-click opens the dropdown as it used to.
- Disabled some features in cases where the new API restrictions apply. This mostly applies to instanced boss encounters, Mythic+ dungeons and battlegrounds.

## Fixed

- Fixed an issue with slider values sometimes displaying a lot of decimals.
- Fixed an issue with the target frame still displaying if a character's profile is deleted from the directory but a new profile cannot be retrieved on them.

# Changelog version 3.1.5

## Fixed

- Fixed players in houses replying to every scan instead of just their neighborhood scan.

# Changelog version 3.1.4

## Changed

- The map scan has been adjusted in neighborhoods:
  - Scanning the neighborhood map is only possible while inside a neighborhood, and will only show players in that specific neighborhood.
  - Players inside houses will also respond to the scan, but only if the house is set to allow "Anyone" in.

## Fixed

- Fixed chat issues when using ElvUI or WIM.
- Housing zones will no longer count as instances for the "Hide in instance" settings for nameplates, tooltips and unit popups.

# Changelog version 3.1.3

*Due to some significant upcoming changes in 12.0.0, we are temporarily pausing Classic releases. The previous version should work without issues until we resume the updates.*

## Added

- Added 160 icons, 72 musics and 35 images from patch 11.2.7.

## Fixed

- Fixed %xt/%xf tokens not working after patch 11.2.7.
- Fixed addon detection for compatibility modules sometimes failing.

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
