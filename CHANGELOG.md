# Changelog version 1.6.6

## Added

- Added slash commands to change your roleplay status, which you can use in macros. You can now use `/trp3 status ic` to get in character, `/trp3 status ooc` to get out of character, or `/trp3 status toggle` to switch status.
- Added a chat setting to display the OOC indicator next to the name in chat.
- Added a setting to hide the map scan button if no scan is available.
- Added a roleplay language field to the main dashboard.
  - This setting is profile-based, defaults to your addon language, and allows you to indicate the language you're roleplaying in.
  - If your addon language doesn't match a player's roleplaying language, you'll see a flag at the bottom of their tooltip indicating their roleplaying language.
  - This change is mainly aimed at Classic roleplayers, as only English RP realms were made.
- Added back buttons to toggle helmet and cloak display for Classic.

## Changed

- Renamed the war mode setting to PvP mode for Classic.

## Fixed

- Fixed issues when the target bar module was disabled.
- Fixed an issue causing duplicate Mary-Sue Protocol profiles to appear in the register when unchecking "This realm only".
- Fixed a few remaining missing icons for Classic (default template 3 icons and `/trp3 roll` icons)
- Fixed an issue when using the "Right-click to open profile" setting on Classic.

# Changelog version 1.6.5

## Added

- Added Total RP 3: Extended version number alongside Total RP 3 version number at the bottom of the tooltip.

## Fixed

- Fixed an error when someone executes a scan in your zone. (Classic only)
- Fixed a potential error when saving a glance slot.

# Changelog version 1.6.4

We are aware of a current issue on Retail causing **quest item usage from the objective tracker** to sometimes fail. While we do not have a fix for it just yet, **typing /reload after getting the error message** temporarily fixes the issue. Sorry for the inconvenience.

## WoW: Classic support

- Total RP 3: Classic is now available as a separate download on CurseForge and WoWInterface! Be sure to install it instead of the retail version of Total RP 3 if you plan on roleplaying in WoW: Classic.
- Important points to be aware of for the Classic version:
  - A few icons have been changed across the addon to replace missing icons in Classic.
  - Companion profiles have been disabled for mounts and non-combat pets, as Blizzard did not provide us with beta access. We will work on implementing them back as soon as possible.
  - Total RP 3: Extended will not be ported to Classic at launch. We will be evaluating if a Classic port makes sense for us to do at a later date.

## Changed

- When using the character map scan, characters with which you have set a relationship will now appear on top of the others.