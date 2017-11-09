# Changelog

## [1.2.11] - 2017-11-09

### Added

- Added support for the profile downloading indicator from and to the XRP add-on.

### Fixed

- Fixed an error when trying to whitelist a profile that has been flagged as containing mature content when the profile hasn't been entirely downloaded yet ([ticket #133](https://wow.curseforge.com/projects/total-rp-3/issues/133)).
- Fixed an issue allowing the user to send empty NPC messages when using the Enter key ([ticket #124](https://wow.curseforge.com/projects/total-rp-3/issues/124)).
- Fixed an error when targeting battle pets that are participating in a pet battle ([ticket #96](https://wow.curseforge.com/projects/total-rp-3/issues/96)).
- Fixed an issue where if you used a single space character for your class (like to indicate you have none) it would be considered as empty and your character's real class would be used instead ([ticket #103](https://wow.curseforge.com/projects/total-rp-3/issues/103)).
- Fixed an issue where players with custom RP status from other add-ons sent via the Mary Sue Protocol would be shown as Out Of Character.

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

[1.2.11]: https://github.com/Ellypse/Total-RP-3/compare/1.2.10...1.2.11
[1.2.10]: https://github.com/Ellypse/Total-RP-3/compare/1.2.9.2...1.2.10
[1.2.9.2]: https://github.com/Ellypse/Total-RP-3/compare/1.2.9.1...1.2.9.2
[1.2.9.1]: https://github.com/Ellypse/Total-RP-3/compare/1.2.9...1.2.9.1
