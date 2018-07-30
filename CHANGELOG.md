# Changelog for version 1.4.4

## Fixed

- Fixed XML errors from libraries when using both Storyline and Total RP 3.
- Fixed Lua error when targeting companions.
- The trial account flagged is now also displayed in your own tooltip.
- Names are now correctly class colored in chat for non-customized names - [Issue #175](https://github.com/Ellypse/Total-RP-3/issues/175)
- Fixed Total RP 3's logo missing a die, and improved the minimap icon, including a transparent version for databroker add-ons.
- The target frame is now refreshed when you summon and dismiss your own mount.

## Added

- Added a limitation option for line breaks in the "currently" tooltip fields (default to 5 line breaks).

# Changelog for version 1.4.3

## Fixed

- Fixed an issue brought by yesterday's hotfixes that would prevent Battle.net communications from working.
- Fixed an issue where un-selecting profiles in the directory would not actually deselect them, and improved consistency when purging profiles while having some profiles already selected - [Issue #160](https://github.com/Ellypse/Total-RP-3/issues/160)
- Fixed an issue introduced with the 8.0.1 pre-patch preventing mount profiles from being displayed properly in the tooltips and on the target frame - [Issue #164](https://github.com/Ellypse/Total-RP-3/issues/164)
- Fixed a layout in the profiles UI that would prevent the Additional information parts from being rendered properly - [Issue #162](https://github.com/Ellypse/Total-RP-3/issues/162)
- Fixed an issue that would render the chat links tooltip lines in a random order, instead of the correct one.
- Fixed an issue that would render some profile informations (Additional information, Personality traits) in a random order, instead of the correct one.


# Changelog for version 1.4.2

## Fixed

- Fixed another rare Lua error that could randomly happen on login (with the `getPlayerCompleteName()` function) - [Issue #159](https://github.com/Ellypse/Total-RP-3/issues/159)

# Changelog for version 1.4.1

Fixed a rare Lua error that could randomly happen on login.

# Changelog for version 1.4

**This version requires Battle for Azeroth, patch 8.0.1.**

## Add-on communications improvement
 
 Total RP 3 implements the next version of the Mary Sue Protocol. This improved version bring the following improvements:
 
- **Profiles are now logged on Blizzard's servers** when sent to other players. This enables Blizzard to view the content of RP profiles in cases of abuse, such as harassment or doxxing. **This means you should now treat the contents of your profile as you would public chat in /say, for example.** (_Goldshire_)
- **Cross server and cross faction support with Battle.net friends:** the add-on can now use Battle.net to transfer data between two Battle.net friends, even if they are from a server that is not connected to yours or if they are from the opposite faction.
- **Improved performance:** thanks to looser limitations and newer compression algorithms, all data transfer should be faster (sometimes up to 8 times faster for big Extended campaigns).
 
 **_It was not possible to make this newer protocol backward compatible with older versions (which will not work with patch 8.0 anyway) and cross add-on communications will only work between people using this newer version of the protocol._**

## New logos

![](http://totalrp3.info/documentation/TRP3_Logo_small.png)  
Total RP 3 has a new, original logo, to replace the modified game logo (which we obviously did not own). It was commissioned to [EbonFeathers@Tumblr](https://ebonfeathers.tumblr.com/). Using the theme of classic D&D, this logo showcases that role-playing is all about picking the role _you_ want to play.


A new minimap icon also replaces the older one and showcases a classic D&D die.  
![](https://www.dropbox.com/s/ri35tugtkj0g2c7/trp_icon.png?raw=1)

## Added

- Added a new settings category called Advanced. Changing the settings on this page may break your experience of the add-on, so a warning message will be displayed to warn you when you modify something, and a reset button will allow you to reset all advanced settings to their default values. Amongst these new advanced settings you can find the settings for the broadcast channel, NPC talk prefix, disable the option to remember the last language used between session, and more.
- Resources added to the browsers: 369 musics, 1698 icons and 178 images from the Battle for Azeroth expansion.

## Modified

- You can no longer set your residence marker inside an instanced zone.
- Fixed several issues related to patch 8.0.1.

## Fixed

- Added support for other add-ons through the Mary Sue Protocol when using `/trp3 open [playerName]` command.

## Removed

- Map features have been temporarily disabled while we keep working on fixing them for Battle for Azeroth. The entire world map UI has been re-implemented by Blizzard and it requires more or less a complete rewrite of our map code.
- We have disabled the button to show the residence location of players from the profile page while we are re-implementing the map features for patch 8.0.
- The system to upvote or downvote profiles have been removed. The system was confusing to new players and was incorrectly used by groups of people to downvote targeted people.
