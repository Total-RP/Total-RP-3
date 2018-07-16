# Changelog for version 1.4

**This version requires Battle for Azeroth, patch 8.0.1.**

 ## Add-on communications improvement
 
 Total RP 3 implements the next version of the Mary Sue Protocol. This improved version bring the following improvements:
 
 - **Profiles are now logged on Blizzard's servers** when sent to other players. This is so Blizzard can see what's the actual content of people's RP profiles in case of reported of abuses, like target harassment or doxxing. **This means that you should now treat what you put in your profile as if you were witting that content in /say** (_Goldshire_).
 - **Cross server and cross faction support with Battle.net friends:** the add-on can now use Battle.net to transfer data between two Battle.net friends, even if they are from a server that is not connected to yours or if they are from the opposite faction.
 - **Improved performances:** thanks to looser limitations and newer compression algorithms, all data transfers should be faster (sometimes up to 8 times faster for big Extended campaigns).
 
 **_It was not possible to make this newer protocol backward compatible with older versions (which will not work with patch 8.0 anyway) and cross add-on communications will only work between people using this newer version of the protocol._**

## New logos

![](https://www.dropbox.com/s/rm0lzcubo9tl5bk/TRP3_Extended_Logo.png?raw=1)  
Total RP 3 has a new original logo, to replace the modified game logo (which we obviously did not owned), that was commissioned to [EbonFeathers@Tumblr](https://ebonfeathers.tumblr.com/). Using the theme of classic D&D, this logo showcases that role-playing is all about picking the role _you_ want to play.


A new minimap icon also replaces the older one and showcases a classic D&D die.  
![](https://www.dropbox.com/s/ri35tugtkj0g2c7/trp_icon.png?raw=1)

## Added

- Added a new settings category called Advanced. Changing the settings on this page may break your experience of the add-on, so a warning message will be displayed to warn you when you modify something, and a reset button will allow you to reset all advanced settings to their default values. Amongst these new advanced settings you can find the settings for the broadcast channel, NPC talk prefix, disable the option to remember the last language used between session, and more.

## Modified

- You can no longer set your residence marker inside an instanced zone.
- Fixed several issues related to patch 8.0.1.

## Fixed

- Added support for other add-ons through the Mary Sue Protocol when using `/trp3 open [playerName]` command.

## Removed

- The map features have been temporarily disabled while we are still working on having them fixed for Battle for Azeroth. The entire world map UI has been completely re-implemented by Blizzard and it requires more or less a complete rewrite of how we handle map stuff.
- We have disabled the button to show the residence location of players from the profile page while we are re-implementing the map features for patch 8.0.
- The system to upvote or downvote profiles have been removed. The system was confusing to new players and was incorrectly used by groups of people to downvote targeted people.
