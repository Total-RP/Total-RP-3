# Change-log version 1.2

# New features

- **New scaling system**: the 3D model scale has to be manually defined for each model against each other. That's a huge task. We added a quick and easy way for **you** to re-scale models while questing. You can now ALT+Scroll on the frame to resize the NPC model and SHIFT+Scroll on the frame to resize your own model. The resizing will be saved between session, which means that you will only have to scale once your character against a specific model to see them scaled forever. _In the future, we will create an online form for people willing to share their scaling data with us so we can combine everyone's data into crowd sourced scaling table that we will include with the add-on. We'll inform you when that's ready._ 
![Velen can now be correctly sized against your character][path_to_image]

- **The options have been moved to the Interface menu**. As we are adding more and more options (and as we are planning on a fullscreen mode), we decided to move our options to the Interface menu. The little cog icon at the bottom left of the Storyline frame is still here and will open the Interface menu directly in Storyline's options.

- **Text styling options**: you can now change the size and font of various text elements (more are comming). We are using LibSharedMedia to gather fonts provided by other add-ons. You can manually add fonts using the [SharedMedia add-on](http://www.curse.com/addons/wow/sharedmedia). We are currently providing only one additional font: [OpenDyslexic](http://opendyslexic.org), a free open source font created to increase readability for readers with dyslexia.
![OpenDyslexic font in Storyline][path_to_image]

## Bug fixes

- We are using a different widget for 3D models. One of the advantage of this new widget is that models feets are all on the same levels (previously dwarfs where higher and dryads were too low).

- Also the new 3D model widget allowed us to extand the frame of each models so that they take the whole width of the frame. This means models will no longer be cut in the middle and the two models can overlap each other.

- Dead NPCs will now be shown as dead. _Please note that we cannot retrieve the NPC current animation in the world. We are only relying on a “dead” flag or the health points to determine if an NPC is dead and show him dead. NPC's that are wounded, just lying on the ground are kneeling will still be shown standing up._

- Fixed the graphical issue where your character would rise from the ground when Storyline was opened while you are on a mount.

- The window can no longer be resized to be bigger than the actual screensize.

- Fixed a small Lua error.