-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local CHANGELOG_TEXT = [[
# Changelog version 3.3.4

## Fixed

- Fixed an issue with tooltips not working after entering an instance. The TRP tooltip may not display in the same position as the game tooltip as a result.
- Fixed an error when right-clicking a wild battle pet.
- Fixed an error when trying to open a target's profile in instances using `/trp3 open` without a name. The command will just silently fail in that case.
- Fixed an error preventing profile transfers if the MSP module was disabled.

# Changelog version 3.3.3

## Changed

- TRP profiles will no longer be shared with other TRP users while another RP addon is running at the same time, as it would lead to display issues for other players.
- The Prat module can now be enabled without needing a /reload if it was previously disabled.
- Added method for other addons to customize text in NPC emotes.

# Changelog version 3.3.2

## Changed

- Nameplates from ignored characters and their pets are no longer customized.
- The `/trp3 reset` command has been changed to enable reset of individual frames, or include the main frame when resetting all frames.
  - See `/trp3 help` for the new command options.
- Currently/OOC tooltip text size is now bigger by default to be more readable on higher resolutions.

## Fixed

- Fixed multiple issues with Blizzard nameplates customization:
  - Fixed nameplate title/guild text sometimes attaching to the wrong units.
  - Fixed non-RP units nameplates missing guild text and class color when the relevant settings were enabled.
  - Fixed nameplates not refreshing when enabling/disabled text-only mode.
  - Fixed title and guild text size not updating with the nameplate size.
- Fixed nameplate icons sometimes attaching to the wrong units when using Plater.
- Fixed mount profiles not being marked properly as such when creating them from the toolbar button.
- Fixed Prat support (for an upcoming update). Thanks to QartemisT.

# Changelog version 3.3.1

## Added

- Added 84 images and 2 backgrounds from patches 12.0.0 and 12.0.1.
- Added class, race, faction and gender conditionals for automation. See our [Macro conditionals](https://github.com/Total-RP/Total-RP-3/wiki/Macro-conditionals) article for more info.

## Fixed

- Fixed remaining issues with profile exchange and tooltips in PvP instances.
- Fixed an issue with ElvUI chat being unable to display chat messages during encounters.
- Restored functionality for the AFK/DND status toolbar button during encounters. Tooltip icons remain disabled.

# Changelog version 3.3.0

## Added

- Added tag filters in the icon browser. Those tags are approximated based on names and not fully accurate, but should help looking for icons within a specific theme.
- Added Haranir icons for default profile and language.

## Fixed

- Fixed an issue with profile exchange after a recent build (notably in PvP, once Blizzard fixes the issue causing it to apply everywhere).
- Fixed an issue with the Plater mod initialization not executing at the correct time, causing a Lua error.

# Changelog version 3.2.4

## Fixed

- Disabled AFK/DND status toolbar button and tooltip icons during encounters to prevent issues.

# Changelog version 3.2.3

## Fixed

- Fixed a Lua error in instances when nameplates customization is disabled on some units.
- Fixed a Lua error in the Vashj'ir secret room when someone else is doing a map scan.
- Disabled language toolbar button functionality in instances to prevent chat issues during encounters.
- Fixed the tooltip colored border for relations when using ElvUI, and improvements to the looks of the skinned frames. Thanks to Simpy for the help on this.
- Fixed guilds not displaying on Blizzard nameplates for players without profiles.

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
]];

function TRP3_DashboardUtil.GenerateChangelog()
	return TRP3_DashboardUtil.GenerateListMarkup(CHANGELOG_TEXT);
end
