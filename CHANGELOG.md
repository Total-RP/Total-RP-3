# Changelog version 1.6.3

## Changed

- Companion tooltips will now adjust contrast for the custom color if the setting is enabled.

## Fixed

- Fixed a companion tooltip error when the API fails to return the pet type.
- Fixed an issue which could make the toolbar appear above the world map.
- Fixed an anchoring error with the target frame.

# Changelog version 1.6.2

## Added

- Added 328 icons and 20 images from patch 8.2.
- Added an indicator to the music browser when the default name of a music differs from the one matching the current filter.

## Fixed

- Fixed issues in the music data transfer between TRP and MRP.
- Fixed an issue with duplicated lines on the map scan button tooltip.
- Further speculative fixes to the map issue on login.

# Changelog version 1.6.1.3

- Fixed another issue with the music patch. I promise we're done with bugfixes for now (;-;)

# Changelog version 1.6.1.2

- Fixed an issue with the music patch when the player logged in before updating the addon.

# Changelog version 1.6.1.1

- Fixed a potential error on login related to the map.

# Changelog version 1.6.1

## Music system rework

- Technical changes in patch 8.2 required us to change how music is handled by the addon. **This means the update is required for musics to work.** This change should be seamless and backwards compatible (music themes from profiles coming from outdated versions should still play fine).
- This allowed for the addition of musics previously unavailable (looking at you, void elf musics).
- The duration of all musics should now be visible in the music browser line tooltips.

## Changed

- Settings to increase color contrast in tooltips and chat have been consolidated in a single setting for both which can be found in the General settings. It also applies in more places, like the map scan tooltips.

## Fixed

- The anchor for the map scan button can now properly be set.
- Fixed a switch in Headers/Paragraph dropdown titles
- Fixed an error message that could be caused by other addons misusing official API functions.

# Changelog version 1.6.0

## Personal notes

You can now write personal notes inside the addon !

These notes can either be written on your own profile (if you wish to take generic notes for your character), or on someone else's profile (the top field being tied to your current profile, the bottom field being common to all your profiles). These notes are obviously private, nobody else but you can see them.

![The new personal notes tab](https://i.imgur.com/Q2cW18F.jpg)

To access personal notes, simply click on the new Notes button on the target frame, or open a profile and click on the Notes tab.

![The target frame button to access notes](https://i.imgur.com/POCSb9V.jpg)

The register also received a checkbox to only display profiles on which you wrote notes.

![The register new notes filter checkbox](https://i.imgur.com/USuXjiS.jpg)

## Added

- Added HTML support for About templates 2 and 3. You can now use the full array of HTML tags while using those templates to format their fields, using the toolbar which is now visible for all templates.

![A template 2 profile using HTML](https://i.imgur.com/cfyZXGo.jpg)

- Added compatibility with other RP addons for personality traits and HTML tags.

## Changed

- The "Report profile" buttons will now both link to the [support website](https://battle.net/support/help/product/wow/197/1501/solution), as the in-game report feature previously added was an invalid method to report addon abuse. The popup will still show a timestamp for the profile's reception, which you can provide to Blizzard CS to help them track the offense.

## Fixed

- Fixed an error which could prevent the addon from loading.
- Fixed a compatibility issue for template 3 if the addon locale was not English.

## Removed

- Removed auto-highlighting of the full text when entering focus of a text area (About fields, Currently, OOC Info...)
- Removed April Fools' code (including the forgotten rainbow companion names).
