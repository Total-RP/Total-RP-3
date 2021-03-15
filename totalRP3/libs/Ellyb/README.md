# Ellyb, Ellypse's Library [![Build Status](https://travis-ci.org/Ellypse/Ellyb.svg?branch=master)](https://travis-ci.org/Ellypse/Ellyb)

Various Lua tools bundled in a convenient library for my various projects of add-ons for World of Warcraft.

Some of the functions are based on the utils function made by [Kajisensei/Telkostrasz](https://github.com/kajisensei) in [Total RP 3](https://github.com/Ellypse/Total-RP-3) that have been either refactored or re-implemented.

Disclaimer: Some part of this might be only useful to me on my project.

## How to use

The global reference to the library `Ellyb` keeps track of which version was bundled in your add-on using the add-on name passed as a file argument. You can ask it to give you the instance of the library using the `GetInstance` method or by calling `Ellyb` it self as a shortcut.

```lua
local myAddonName = ...;
local Ellyb = Ellyb:GetInstance(myAddonName);
-- or shorter way
local Ellyb = Ellyb(...);
```

This also means that if you need to interface with another add-on using Ellyb and you want to make sure you use their version, you can get their own instance (using the add-on name as indicated in their .toc file).

```lua
local MyEllyb = Ellyb(...); -- Version 1.1
local TRP3Ellyb = Ellyb("totalRP3"); -- Version 1.0 bundled with Total RP 3
```

The rest of the documentation assume that `Ellyb` is referring to an instance of the library and not the global table/function. The documentation is available in the [Wiki](https://github.com/Ellypse/Ellyb/wiki) of this GitHub repo.

## Implementation details

Only one instance of the same version of the library is kept in memory, add-ons using the same versions will point to the same instance. Tools that can be configured or that stores data comes as classes that should be instanced. Tools that do not store data or preferences comes as simple tables of functions.
