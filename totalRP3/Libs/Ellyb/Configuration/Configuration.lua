---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Configuration then
	return
end

-- Lua imports
local format = format;
local type = type;
local pairs = pairs;

---@class Configuration
local Configuration, _private = Ellyb.Class("Configuration");

local UNKNOWN_CONFIGURATION_KEY = [[Unknown configuration key %s.]];
local CONFIGURATION_KEY_ALREADY_EXISTS = [[Configuration key %s has already been registered.]];

---Constructor
---@param savedVariablesName string @ The saved variable name, used to access the table from _G
function Configuration:initialize(savedVariablesName)
	Ellyb.Assertions.isType(savedVariablesName, "string", "savedVariablesName");

	_private[self] = {};
	_private[self].savedVariablesName = savedVariablesName;
	_private[self].configCallbackRegistry = CreateFromMixins(CallbackRegistryBaseMixin);
	_private[self].configCallbackRegistry:OnLoad();
	_private[self].defaultValues = {};

	-- Initialize the saved variables global table if it has never been initialized before
	if not _G[savedVariablesName] then
		_G[savedVariablesName] = {};
	end
end

--- Register a new configuration key with its default value
---@param configurationKey string @ A new configuration key
---@param defaultValue any @ The default value for this new configuration key
function Configuration:RegisterConfigKey(configurationKey, defaultValue)
	Ellyb.Assertions.isType(configurationKey, "string", "configurationKey");
	assert(not self:IsConfigurationKeyRegistered(configurationKey), format(CONFIGURATION_KEY_ALREADY_EXISTS, configurationKey));

	_private[self].defaultValues[configurationKey] = defaultValue;

	if self:GetValue(configurationKey) == nil then
		self:SetValue(configurationKey, defaultValue);
	end
end

---IsConfigurationKeyRegistered
---@param configurationKey string @ A valid configuration key
---@return boolean isRegistered @ True if the configuration has already been registered
function Configuration:IsConfigurationKeyRegistered(configurationKey)
	Ellyb.Assertions.isType(configurationKey, "string", "configurationKey");
	return _private[self].defaultValues[configurationKey] ~= nil;
end

--- Get the value of a configuration key
---@param configurationKey string @ A valid configuration key, previously registered
function Configuration:GetValue(configurationKey)
	return _G[_private[self].savedVariablesName][configurationKey];
end

--- Set the value of a configuration key
---@param configurationKey string @ A valid configuration key that has previously been registered
---@param value any @ The new value for the configuration key
function Configuration:SetValue(configurationKey, value)
	Ellyb.Assertions.isType(configurationKey, "string", "configurationKey");
	assert(self:IsConfigurationKeyRegistered(configurationKey), format(UNKNOWN_CONFIGURATION_KEY, configurationKey));

	local savedVariables = _G[_private[self].savedVariablesName];
	if savedVariables[configurationKey] ~= value then
		savedVariables[configurationKey] = value;
		_private[self].configCallbackRegistry:TriggerEvent(configurationKey, value);
	end
end

--- Reset the value of a configuration key to its default value
---@param configurationKey string @ A valid configuration key that has previously been registered
function Configuration:ResetValue(configurationKey)
	Ellyb.Assertions.isType(configurationKey, "string", "configurationKey");
	assert(self:IsConfigurationKeyRegistered(configurationKey), format(UNKNOWN_CONFIGURATION_KEY, configurationKey));

	self:SetValue(configurationKey, _private[self].defaultValues[configurationKey]);
end

---OnChange
---@param key string|string[] @ A configuration key or a list of configuration keys to listen for change
---@param callback function @ A callback that will be called when the value of the given key changes.
function Configuration:OnChange(key, callback)
	if type(key) == "table" then
		for _, k in pairs(key) do
			self:OnChange(k, callback);
		end
	else
		_private[self].configCallbackRegistry:RegisterCallback(key, callback);
	end
end

Ellyb.Configuration = Configuration;
