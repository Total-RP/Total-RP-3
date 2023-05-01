# Changelog version 2.5.0

## Added

- Added 503 icons, 15 images and 70 musics from patch 10.1.
- Added Automation system, accessible in the settings
  - This allows you to automate actions based on macro conditionals.
  - Actions include changing your profile, your roleplay status, whether the map scan is enabled or not...
  - For a list of macro conditionals, see [our wiki article](https://github.com/Total-RP/Total-RP-3/wiki/Analytics-in-Total-RP-3).
- Added Analytics module
  - **This is strictly opt-in and only applies to users of the Wago Addons client who enabled "Help addon developers".**
  - For more details, see [our wiki article](https://github.com/Total-RP/Total-RP-3/wiki/Analytics-in-Total-RP-3).
- Added entry in the new addon compartment located below the calendar button, with the same actions as the minimap button.
- Added tooltip indicator if the guild fields have been customized, as well as options to display both/either custom and in-game guild info.
- Added ability to get the party started.

## Changed

- "Always show target" nameplate option will now display the target nameplate even if it is OOC and "Hide out of character units" was enabled.

# Changelog version 2.4.6

## Added

- Added support for 10.0.7 furbolg language.
- Added voice reference, custom guild name and rank presets in additional info.
  - Voice reference will be shown in the tooltip if filled in.
  - Custom guild name/rank will replace the original fields in TRP tooltips.
  - You may disable either of these changes via tooltip settings ("Show voice reference" and "Show custom guild names").
- Added nameplates settings:
  - Name and title max length on nameplates
  - Display first name only
  - Display custom guild name
  - Disable customizations in instances
  - Disable customizations on NPCs
- IC/OOC fields from other players' profile are now selectable to make it easier to copy URLs.
- Added setting to disable the welcome message on login.

## Fixed

- Fixed an issue with "Unknown" names potentially showing on tooltips after a loading screen.
- Fixed an issue with the KuiNameplates module to properly fade/hide nameplates when appropriate.
- Fixed an issue where the target frame would stay hidden after a UI reload with a target selected.

# Changelog version 2.4.5

## Added

- Added Plater support for RP nameplates customization. Thanks to Ghost for this addition.
- The TRP toolbar can now be set to only show while in character with the Toolbar display conditions setting (replacing Toolbar show on login).
- OOC characters are now hidden from the map scan.
  - You can re-enable them by checking "Show out of character players" in Register settings > Location settings. Pins with only OOC characters will appear faded.
  - Only players from this version onwards are recognized as OOC, so this may take some time to be accurate.

## Fixed

- Re-enabled right-click menu options (with the exception of the IC/OOC status toggle).
- Fixed dashboard dropdowns not showing the correct selected values.
- Fixed name-only nameplates setting not persisting upon logout.
- Fixed an issue with profiles showing as Unknown in the directory quick entries if the profile was received for the first time.

# Changelog version 2.4.4

## Fixed

- Fixed "not currently playing" error messages sometimes showing up for players from specific realms.
- Fixed "Import profile" popup not properly resetting after importing a profile.

# Changelog version 2.4.3

## Added

- Added a setting to customize date formats displayed in the directory. (Thanks to Kisis for the initial work on it)
  - The default format now respects regional formats based on current game client.
  - Total RP 3: Extended will be updated to support this at a later date.

## Fixed

- Fixed tooltipData error showing since 10.0.2.
- Fixed map scan not working on WotLK Classic.
- Fixed potential taint issues leading to blocked actions.

# Changelog version 2.4.2

## Fixed

- Fixed missing dracthyr default profile icon.
- Fixed companion profiles not working properly on the second pet from Animal Companion talent.
- Fixed companion profiles on water elementals in WotLK Classic (for real this time).
- Fixed broadcast channel order setting being checked before configuration was set up.
- Fixed an issue with chat links that could lead to blocked actions.

# Changelog version 2.4.1

## Added

- Added support for Retail 10.0.2.
- Added 5 icons, 68 images and 218 musics from patch 10.0.2 and before.
- Added the ability to right-click a pin after a map scan to open someone's profile.

## Fixed

- Fixed the "Hide immediately instead of fading" tooltip setting.
- Fixed another issue with water elemental pets not being valid targets to bind a companion profile to in WotLK Classic
- Fixed an issue with colorblind mode preventing companion tooltips from displaying.

# Changelog version 2.4

## Added

- Added support for Retail 10.0.0.
- Added 2246 icons from patch 10.0.0.
- Added 2 new command lines for use in macros:
  - /trp3 set: Allows you to set a profile field to a given value.

  ![](https://user-images.githubusercontent.com/287102/197398575-4ea8f528-a212-4cdb-a4ce-9297638d4de9.png)
  - /trp3 location: Allows you to control whether or not you appear on the map scan.
- Added macro conditionals for the 2 aforementioned command lines:
  - [ic], [ooc], [rpstatus:{status}] - IC/OOC status
  - [loc:{location name}], [location:{location name}] - Current location
  - [profile:{profile name}] - Current profile name
  - Regular macro conditionals are also supported

## Fixed

- Fixed an issue with the color picker not working in WotLK Classic.
- Fixed an issue with water elemental pets not being valid targets to bind a companion profile to in WotLK Classic.
- More tooltip cleanup.

## Removed

- Removed temporarily right-click menu options in Retail due to a conflict with Edit Mode that can prevent the use of abilities in combat. They will be re-added once the conflict has been resolved.
