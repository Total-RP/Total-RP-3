# Changelog version 3.1.2

## Changed

- The profile directory has received some changes:
  - The relation column will now sort by relation order rather than alphabetically.
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

# Changelog version 3.0.12

## Added

- Added icons and musics for MoP Classic.

# Changelog version 3.0.11

## Added

- Added 65 icons, 7 images and 5 musics from patch 11.1.7.

## Fixed

- Fixed icon links being formatted incorrectly for MRP users.
- Fixed issues with tutorials.

# Changelog version 3.0.10

## Added

- Added compatibility with patch 11.1.5.
- Added 665 icons and 96 musics from patch 11.1.0 and 11.1.5.
  - Added 13 icons for Cataclysm Classic.
  - Added 4 icons and 3 musics for Classic Era.

## Fixed

- Fixed "Open profile" not showing when right-clicking a player from a community member list.
- Fixed an issue when using Prat where the setting to remove realm from character names wasn't working.

## Removed

- Removed the maximize button.
- Removed the Wago Analytics module.

# Changelog version 3.0.9

## Fixed

- Fixed icon button right-click menu not appearing.

# Changelog version 3.0.8

## Added

- Right-clicking color picker buttons now opens a menu to copy, paste or discard colors.

## Fixed

- Fixed a Lua error appearing when opening some dropdowns (like walk-up friendly or RP proficiency).

# Changelog version 3.0.7

## Added

- Added 24 images from patch 11.1.0.
  - Icons and musics will be added in a future release.
- Added support for the new addon group feature in the addon list.

## Fixed

- Fixed nameplates not customizing properly if using Plater while disabling its friendly nameplates module.
- Fixed missing UI icons on Classic.

# Changelog version 3.0.6

## Added

- Added 5 images from patch 11.0.7.
- Added a warning that the addon will not exchange profiles when chat is disabled.

## Fixed

- Fixed description not displaying correctly when editing a relation in non-English languages.
- Fixed addon locale setting not working properly.
- Fixed toolbar buttons compatibility with addons like ElvUI or TitanPanel.
- Fixed icon display issues when Retail icons are manually added to older clients.

# Changelog version 3.0.5

## Added

- Added 101 icons, 2 images and 1 music from patch 11.0.5.

## Changed

- The main frame can now be moved partially off-screen.

# Changelog version 3.0.4

## Added

- Right-clicking on a color swatch now allows you to copy the color code or save the color as a preset.
- Added 89 icons and 10 musics from recent patches.

## Changed

- The dashboard tabs formatting has been improved to be more readable.
- Resizing TRP windows no longer lets the shadow get smaller than the minimum window size.

## Fixed

- The Customization menu and relations system no longer break when putting a lone % in a relation description.
- Hovering on a party/raid unit frame will now properly display their TRP tooltip if their profile is known.
- The current profile size displayed on the quick export warning should no longer appear lower than the maximum size allowed.
- Adjusted the looks of the close, maximize, minimize and resize buttons on Classic to be consistent with Retail.
- Adjusted the background color used for contrast adjustment in the characteristics panel.
- Clicking on "No scan available" when all map scans are disabled no longer throws an error.

# Changelog version 3.0.3

## Added

- Added a monochrome contrast option to turn colored text white or black depending on background.

## Changed

- The new color swatches for class and eye color have been moved to the left to let the text be aligned again, and their size has been slightly reduced.
- Opening the color browser now automatically focuses on the hex color field to allow a hex code to be pasted immediately.
- "Menu settings" has been renamed to "Unit menus" to be consistent with all other renamed settings categories.

## Fixed

- Fixed an issue where right-clicking on a map scan pin would zoom out the map.
- Fixed an issue which could cause icons and full titles to linger on unrelated nameplates when using KuiNameplates.
- Modules disabled because of a missing dependency will no longer display an error.

# Changelog version 3.0.2

## Added

- Added a chat token for the current character roleplay name.
  - %xp for the full name.
  - %xpf for the first name.
  - %xpl for the last name.
- Added color swatches to display the non-corrected color for class/eye color on characters and name color on companions.
- Added a swatch in the color browser to warn if the color you're selecting will be readable on the tooltip.
  - The swatch can be clicked to swap to the corrected color.
- Added 28 icons, 64 images and 357 musics from patch 10.0.2.

## Changed

- The IC/OOC toolbar icons have been replaced to be more readable by colorblind players.
  - IC Green/OOC Red -> IC White/OOC Black
- Classes, class resources and custom preset colors are now sorted alphabetically.
  - The color now shows in a box instead of modifying the text itself for readability. (Retail only)
  - Renaming and deleting a custom preset can now be done without needing to select the preset first.
- Spaces at the beginning/end of notes will now be removed (in order not to display the icon notes on spaces-only notes).

## Fixed

- Fixed "Toggle nameplates customization in combat" setting not working properly.
- The toolbar now correctly updates its size based on the amount of icons toggled.
- Fixed an error when trying to use a map scan while in combat.
- Fixed a rare issue where opening another player's profile could copy their Currently/OOC content into your own profile.

## Removed

- Removed support for pre-BfA personality traits. When importing a profile from Legion or before, the personality traits values will have to be set again.

# Changelog version 3.0.1

## Added

- The character profile dropdown on the toolbar is now capped in height and scrollable on Retail.
  - The companion profile dropdown on the target frame will also receive this change in patch 11.0.2.

## Changed

- Glance slots click instructions have been removed from their tooltips and moved to the help button in the "At first glance" section of the Miscellaneous tab.

## Fixed

- Fixed icon button right-click actions not working properly in the relation editor.
- Fixed an error when disabling the tooltip module.

# Changelog version 3.0.0

This version adds support for patch 11.0.

Thanks to Raenore for the help on some of these features, and keyboardturner for the new silhouette logo.

**For a visual guide to the major changes of this version, please see [this article](https://github.com/Total-RP/Total-RP-3/wiki/Guide-to-version-3.0) on our wiki.**

## Added
- Added a new Relations menu located in the Customization section, alongside the moved Automation settings.
  - This menu lets you edit the preset relations you can have with other players, as well as create new ones.
  - Those relations are still only personal, and not shared with other players.
  - The relation will now be shown as a line on the tooltip in addition to the border color. This can be changed to show the relation description, or disabled in Tooltip settings.
- Added a "Currently" toolbar button letting you open a frame to quickly modify your Currently info.
- Added a toolbar button to open/close the main Total RP 3 window.
- Added a target frame button for your own companion to auto-fill the speech window with its name in brackets.
  - This will apply RP name customization to its speech lines.
- Added a dropdown to set whether you are open to other players walking up to your character.
  - This will show as an icon on your tooltip and in your profile characteristics.
  - Existing tooltip bottom icons have also been changed for clarity.
    - Book: Profile has an unread description.
    - Note: You have notes on this profile.
    - Three people: Walkup friendly.
- Added the new unread description icon to the About tab when relevant.
- Added the ability to drag and drop personality traits to reorder them
  - Additional info now uses the same button style rather than drag and dropping the icon itself.
- Added the ability to duplicate a personality trait or additional info line, as well as convert preset lines into custom.
  - These are located within the new Options button at the end of the line, alongside deletion of the line.
  - Preset additional info lines appearing on the tooltip will no longer appear if converted to custom.
- Added indicators on additional info presets which will appear on tooltips by default.
- Added the ability to right-click an icon button to copy/paste icons between buttons or copy the name of the selected icon.
- Added a new background browser, as well as 33 new background options for the "About" section (and Extended documents).
- Added a tooltip setting to hide the addon version text and trial indicator separately from the bottom icons.
- The toolbar will now be skinned while using ElvUI.
- Added 1526 icons and 6 musics from patch 11.0.0.

## Changed
- The UI has received an extensive makeover, including smoother scrolling in profiles list and directory.
- The toolbar and target frame buttons have had their icons updated to make their actions clearer.
- The toolbar and target frame tooltips now adjust which side of the button they appear on based on their position on the screen.
- The roleplay styles options at the bottom of the Miscellaneous section have been revised.
  - Removed "in-character frequence" and "battle resolution".
  - Added more settings to indicate what RP types your character is open to: "criminal activity" (theft, mugging) and "loss of control" (getting imprisoned or mind controlled).
- New profiles (and the default profile) now default to OOC when created.
- RP proficiency is now an account-wide setting rather than per profile, and has been adjusted to add an option between Beginner and Experienced.
  - Beginner/Guide icons have been updated on Retail.
  - As part of this change, the setting has been reset and should be set again.
- Pressing Escape while a popup is displayed (such as browsers) will no longer close the entire main window, but only the popup.
- Other players default profiles will no longer appear in your directory or be used for chat/nameplate customization.
- Character names are now customized in the TRP dice roll output.
- The music browser now formats the duration with minutes and seconds, and the search now ignores punctuation in the name (as currently supported in the icon browser).
- Glances with empty names will now show as such instead of replacing it with "...".
- Glances from your character still show their icons on your profile and target frame while disabled.
  - These will still not be sent to other players.
- Dragging a glance to reorder it will now display its icon on the cursor.
- Toolbar button and slash command for the NPC speech window now closes it if already shown.
- Clicking the target frame button for companion profiles now directly opens the profile.
  - The options menu to unbind/select a new profile can still be accessed with a right-click.
- The companion/mount profile buttons no longer change icon based on the selected profile.
- "Frames settings" has been split into Toolbar and Target frame categories.
  - The map scan button settings have been moved to the Directory category.
- Tooltip texts across the addon were reworked to follow a more consistent format and add clarity when needed.
- Chat links can now be closed with Escape, and profile chat link tooltips have received minor display improvements.
- The Icon browser now displays icons in a larger size both on the grid and in tooltips.
- The maximum length of names, titles, class and race in tooltips has been reduced.
- Consecutive spaces in the title fields will now be trimmed to prevent display issues in profiles and nameplates.
- Truncated profile fields can now be hovered to see the full text.
- The size of the version number line on the tooltip is no longer tied to the tertiary font size, and is instead locked to the current default size of 10.

## Fixed
- Fixed some causes of lingering tooltips.
  - Soft target support has been disabled by default with this update, as some issues remain. It can still be reenabled in Tooltip settings.
- Fixed an issue where disabling the KuiNameplates module would break KuiNameplates itself.
- Fixed an issue when disabling Extended while a launcher action was set to an Extended action.
- Fixed profiles being marked as unread when the About section is empty.
- Fixed target companion names not getting customized on tooltips.
- Fixed mount titles not wrapping properly on their tooltip.
- Fixed the directory tutorial not properly scaling with the window and reworked its content.
- Fixed an issue where the glance editor would sometimes overlap with other elements in the UI (like the target frame).
- Fixed an issue where MRP/XRP profiles with empty classes would not display the game class as fallback in their tooltips.
- Fixed an issue with non-Latin alphabets displaying incorrectly or causing a different font to linger in some cases.
- Fixed cases where the TRP tooltip would fail to display in the correct position while using ElvUI.
- Fixed an issue where the class text would appear slightly indented on tooltips if no race was set.
- Fixed an issue where toast notifications (like the one being shown when linking a profile to a companion) could get stuck instead of fading properly.
- Fixed currently summoned pet not being remembered on Classic Era.
- Fixed an issue where the locale would still be changed when canceling the prompt appearing after selecting a language in the dropdown.
- Fixed an issue when trying to change language from Traditional Chinese.

## Removed
- Removed UI sound and animation settings.
- Removed Info tooltip size setting. (The game should already auto-adjust font size on high resolutions)
- Removed the setting to change the tooltip anchor for glances on the target frame.
- Removed the ability to copy glances from other players.
- Removed the ability to fully disable the directory purge to reduce risks of losing the entire directory data.
  - Profiles with notes or relations are still exempt from the purge.
- Removed advanced comms settings.
