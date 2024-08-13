-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local TRP3_API = select(2, ...);
local Ellyb = TRP3_API.Ellyb;

-- Ellyb imports
local Class = Ellyb.Class;

-- Total RP 3 imports
local Configuration = TRP3_API.configuration;
local Dashboard = TRP3_API.dashboard;
local Navigation = TRP3_API.navigation;
local UITooltip = TRP3_API.ui.tooltip;
local loc = TRP3_API.loc;
local strhtml = TRP3_API.utils.str.toHTML;

local CHANGELOG_TEXT = [[
# Changelog version 3.0.2


## Added


- Added a chat token for the current character roleplay name.
  - %xp for the full name.
  - %xpf for the first name.
  - %xpl for the last name.
- Added color swatches to display the non-corrected color for class/eye color on characters and name color on companions.
- Added a swatch in the color browser to warn if the color you're selecting will be readable on the tooltip.
  - The swatch can be clicked to swap to the corrected color.
- Added 28 icons, 28 images and 357 musics from patch 10.0.2.

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


### {col:FFD200}For a visual guide to the major changes of version 3.0, please see [this article](https://github.com/Total-RP/Total-RP-3/wiki/Guide-to-version-3.0) on our wiki.{/col}


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

Thanks to {col:00ff00}Raenore{/col} for the help on some of these features, and {col:00ff00}keyboardturner{/col} for the new silhouette logo.

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
]];

--- Returns the fully formatted localized text for this view.
local function getLocalizedText()
	return strhtml(CHANGELOG_TEXT);
end

--- Toggles a setting and displays a UI toast.
---  @param setting The setting to be toggled.
local function toggleSetting(setting)
	if Configuration.getValue(setting) then
		Configuration.setValue(setting, false);
		UITooltip.toast(loc.OPTION_DISABLED_TOAST, 3);
	else
		Configuration.setValue(setting, true);
		UITooltip.toast(loc.OPTION_ENABLED_TOAST, 3);
	end
end

--- Mapping of URL handlers to register and unregister with this view.
local URL_HANDLERS = {
	right_click_profile = GenerateClosure(toggleSetting, "CONFIG_RIGHT_CLICK_OPEN_PROFILE"),
	companion_speech = GenerateClosure(toggleSetting, "chat_npcspeech_replacement"),
	default_color_picker = GenerateClosure(toggleSetting, "default_color_picker"),
	disable_chat_ooc = GenerateClosure(toggleSetting, "chat_disable_ooc"),
	open_mature_filter_settings = function()
		Navigation.menu.selectMenu("main_91_config_main_config_register");
	end,
};

--- Tab view class that displays our changelog, and points out the awesome
---  new features that we've spent far too much time working on.
local WhatsNewTabView = Class("TRP3_DashboardWhatsNewTabView", Dashboard.TabView);
Dashboard.WhatsNewTabView = WhatsNewTabView;

function WhatsNewTabView.static.getTabTitle()
	return loc.DB_NEW;
end

function WhatsNewTabView:initialize(dashboard)
	self.class.super.initialize(self, dashboard);

	self.body = getLocalizedText();
end

function WhatsNewTabView:Hide()
	self.class.super.Hide(self);

	-- Unregister the hyperlink handlers.
	for url in pairs(URL_HANDLERS) do
		self.dashboard:UnregisterHyperlink(url);
	end
end

function WhatsNewTabView:Show()
	self.class.super.Show(self);

	self.dashboard:SetHTML(getLocalizedText());

	-- Register all the URL strings that allow people to toggle settings
	-- from the view directly. Whoever thought of this feature was a genius,
	-- by the way.
	for url, handler in pairs(URL_HANDLERS) do
		self.dashboard:RegisterHyperlink(url, handler);
	end
end
