# Changelog

## Unreleased

### New feature: chat links

We have added a new chat links framework to Total RP 3, allowing you send links for many features of Total RP 3 to other Total RP 3 users. With this update, you can send people links of your profile, companions profiles, at-first-glances and other players profiles from your directory.

When clicking a link you can see a quick preview of what was shared in a tooltip, with action buttons available to open or even import the content. When you create a link, you will be asked if you want to let other people import what you are sharing, so you can send a link of your profile but only let people consult it.

[Total RP 3: Extended] will be updated in the upcoming weeks to use this new framework to share items, campaigns and more.

### New feature: right-click a player to open their profile

We have added a new feature that allows you to right-click on a player in the game to open their profile in Total RP 3. An icon will appear next to the cursor when the player has a RP profile that can be opened. This feature is disabled by default and can be enabled in the Directory settings, and is always disabled when you are in combat. You can also choose to automatically disable it when you go out of character, or apply a modifier like Shift or Control when clicking.

### Added

- Added new slash command to open someone's profile. Using `/trp3 open` will open your target's profile and using `/trp3 open CharacterName` (or `/trp3 open CharacterName-RealmName` for connected servers) will request that player for their profile and open it inside Total RP 3 when fully downloaded.
- Added color palettes to the color picker, with basic colors, class colors, item quality colors, resources colors, and a custom palette where you can save custom colors you might want to re-use later.
- Added an option to use the default color picker instead of Total RP 3's color picker in the General settings. When this option is enabled, the default color picker or any replacement add-on will be used instead when setting a color. When the option is disabled, you can Shift + Click to open the default color picker instead of Total RP 3's.
- Added option to disable chat modifications (custom names, text emotes detection, etc.) while set as out of character.
- Added option to crop long text in the at-first-glance tooltip when shown on the target frame, enabled by default, only applies to other people's at-first-glances. The tooltips inside the profile page are not cropped.
- Updated list of icons for the icon browser, added 177 icons from patch 7.3.5.
- Updated list of images for the image browser, added 97 images of the game's zones from the new warboard UI from patch 7.3.5.
- Added tooltip flag to indicate when a player is on a trial account.

### Fixed

- Fixed an issue causing incorrect colors in NPC chat messages when using text emotes (`* *` or `< >`) or out of character texts (`( )` or `(( ))`).
- Text emotes and out of character texts patterns are no longer parsed in links (like item links or achievement links).
- Fixed issue preventing from clicking on links in companion profiles.
- Fixed an issue that prevent at-first-glance information from companion profiles to be updated.
- Fixed an issue with name formatting when Shift + Clicking player names in chat

### Modified

- The mature profile filter now lets you set a strength when filtering profiles, which affects how many bad words must be found before a profile is considered as mature.
- Profiles that have been flagged as mature are now re-evaluated after 24 hours.
- The previous custom dictionaries of mature language words that we manually made have been replaced by dictionaries from a crowd sourced source, and are now available for German, Italian, Mexican Spanish, and Russian.
- Various under the hood fixes and improvements in various places, using new libraries and cleaned up some code.
- Improvements to the localization system. More pets should be recognized as companions, especially when using non-English clients.
- We are now using a custom popup dialog when clicking on a link to offer to copy-paste the URL, to avoid issues when other add-ons are messing with the game's default dialog.
- Minor changes to the way some tooltips are displayed (color picker buttons, the minimap button).

### Removed

- Removed various advanced option that was causing confusion and would often result in the add-on not working when the user would change the default configuration (automatically adding people to the directory, the broadcast channel name)


## [1.2.11.3]  - 2018-01-02

Happy new year! The Total RP 3 team wishes you the best for 2018.

### Updated

- Updated list of Patreon supporters inside the add-on for the month of December.

## [1.2.11.2] - 2017-12-26

### Fixed

- Fixed a Lua overflow error with the ChatThrottleLib that could occur in rare cases.
- Fixed an issue that would cause the tooltip to reload all the data too frequently.
- Fixed an issue that could cause a larger than usual amount of Unknown profiles to be listed in the Directory.

### Removed

- Removed the downloading progression indicator in the tooltip for now as it was the cause of some of these issues. It will be brought back later with a better implementation.

## [1.2.11.1] - 2017-12-08

### Fixed

- Fixed an issue where the Mary Sue Protocol downloading indicator would get stuck for Total RP 3 profiles.

## [1.2.11] - 2017-11-09

### Added

- Added support for the profile downloading indicator from and to the XRP add-on.

### Fixed

- Fixed an error when trying to whitelist a profile that has been flagged as containing mature content when the profile hasn't been entirely downloaded yet ([ticket #133](https://wow.curseforge.com/projects/total-rp-3/issues/133)).
- Fixed an issue allowing the user to send empty NPC messages when using the Enter key ([ticket #124](https://wow.curseforge.com/projects/total-rp-3/issues/124)).
- Fixed an error when targeting battle pets that are participating in a pet battle ([ticket #96](https://wow.curseforge.com/projects/total-rp-3/issues/96)).
- Fixed an issue where if you used a single space character for your class (like to indicate you have none) it would be considered as empty and your character's real class would be used instead ([ticket #103](https://wow.curseforge.com/projects/total-rp-3/issues/103)).
- Fixed an issue where players with custom RP status from other add-ons sent via the Mary Sue Protocol would be shown as out Of Character.

### Removed

- Removed workaround for the text box issue introduced in patch 7.3 as this issue has been fixed in patch 7.3.2.

## [1.2.10] - 2017-09-28

### Added

- Added 494 icons to our icon browser, from the latest patches.
- Added 185 musics to our music browser. We were finally able to find the musics for patch 7.1, 7.2 and 7.3, including Karazhan, Winter Veil, Diablo Anniversary, Tomb of Sargeras, Argus and more!
- Added 142 images to our image browser, including the new prestige icons, PvP emblems, the new dressing room backgrounds, and even the calendar icon for the [Running of the Gnomes event](http://bit.ly/GnomeRun2k17)!
- Added thank you message for Ellypse's Patreon supporters.

### Fixed

- Improved the workaround for the text cursor misalignment issue brought by patch 7.3 in the EditBox. The text no longer go beyond the limits of the EditBox.

## [1.2.9.2] - 2017-09-14

### Fixed

- Implemented a temporary workaround for the issue introduced by patch 7.3 in the game's code that cause the misalignment of the text cursor in multi lines text fields. Note that this workaround is not perfect, and result in empty lines visible at the bottom of the text, but at least the cursor is actually on the right line. But Blizzard is aware of the issue and is working on fixing it properly on their end.

## [1.2.9.1] - 2017-08-29

### Added

- Added Traditional Chinese and Korean localizations.

### Changed

- Renamed Chinese localization to Simplified Chinese.

### Removed
- Removed the option to change the detection pattern for NPC speeches, as it created many issues and there really wasn't a need for it.

### Fixed

- Fixed issues with patch 7.3.

[1.2.11.3]: https://github.com/Ellypse/Total-RP-3/compare/1.2.11.2...1.2.11.3
[1.2.11.2]: https://github.com/Ellypse/Total-RP-3/compare/1.2.11.1...1.2.11.2
[1.2.11.1]: https://github.com/Ellypse/Total-RP-3/compare/1.2.11...1.2.11.1
[1.2.11]: https://github.com/Ellypse/Total-RP-3/compare/1.2.10...1.2.11
[1.2.10]: https://github.com/Ellypse/Total-RP-3/compare/1.2.9.2...1.2.10
[1.2.9.2]: https://github.com/Ellypse/Total-RP-3/compare/1.2.9.1...1.2.9.2
[1.2.9.1]: https://github.com/Ellypse/Total-RP-3/compare/1.2.9...1.2.9.1

[Total RP 3: Extended]: http://extended.totalrp3.info