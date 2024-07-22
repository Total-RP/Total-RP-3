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
- Added a tooltip setting to hide the addon version text and trial indicator separately from the bottom icons.
- Added the ability to drag and drop personality traits to reorder them
  - Additional info now uses the same button style rather than drag and dropping the icon itself.
- Added the ability to duplicate a personality trait or additional info line, as well as convert preset lines into custom.
  - These are located within the new Options button at the end of the line, alongside deletion of the line.
  - Preset additional info lines appearing on the tooltip will no longer appear if converted to custom.
- Added indicators on additional info presets which will appear on tooltips by default.
- Added the ability to right-click an icon button to copy/paste icons between buttons or copy the name of the selected icon.
- Added a new background browser, as well as 33 new background options for the "About" section (and Extended documents).
- The toolbar will now be skinned while using ElvUI.
- Added X icons, X images and X musics from patch 11.0.

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
