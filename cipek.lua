--[[
-- This file is generated automatically and is not intended to be modified.
-- To view the source code, see the 'src' folder on GitHub!
--
-- Author: 0866
-- License: MIT
-- GitHub: https://github.com/richie0866/remote-spy
--]]

local instanceFromId = {}
local idFromInstance = {}

local modules = {}
local currentlyLoading = {}

-- Module resolution

local function loadModule(object, caller)
	local module = modules[object]

	if module.isLoaded then
		return module.data
	end

	if caller then
		currentlyLoading[caller] = object

		local currentObject = object
		local depth = 0
	
		-- Keep looping until we reach the top of the dependency chain.
		-- Throw an error if we encounter a circular dependency.
		while currentObject do
			depth = depth + 1
			currentObject = currentlyLoading[currentObject]
	
			if currentObject == object then
				local str = currentObject:GetFullName()
	
				for _ = 1, depth do
					currentObject = currentlyLoading[currentObject]
					str = str .. "  ⇒ " .. currentObject:GetFullName()
				end
	
				error("Failed to load '" .. object:GetFullName() .. "'! Detected a circular dependency chain: " .. str, 2)
			end
		end
	end

	local data = module.fn()

	if currentlyLoading[caller] == object then -- Thread-safe cleanup!
		currentlyLoading[caller] = nil
	end

	module.data = data
	module.isLoaded = true

	return data
end

local function start()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	for object in pairs(modules) do
		if object:IsA("LocalScript") and not object.Disabled then
			task.defer(loadModule, object)
		end
	end
end

-- Project setup

local globalMt = {
	__index = getfenv(0),
	__metatable = "This metatable is locked",
}

local function _env(id)
	local object = instanceFromId[id]

	return setmetatable({
		script = object,
		require = function (target)
			if modules[target] and target:IsA("ModuleScript") then
				return loadModule(target, object)
			else
				return require(target)
			end
		end,
	}, globalMt)
end

local function _module(name, className, path, parent, fn)
	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = instanceFromId[parent]

	instanceFromId[path] = instance
	idFromInstance[instance] = path

	modules[instance] = {
		fn = fn,
		isLoaded = false,
		value = nil,
	}
end

local function _instance(name, className, path, parent)
	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = instanceFromId[parent]

	instanceFromId[path] = instance
	idFromInstance[instance] = path
end


_instance("RemoteSpy", "Folder", "RemoteSpy", nil)

_module("acrylic", "LocalScript", "RemoteSpy.acrylic", "RemoteSpy", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.include.RuntimeLib)\
local Make = TS.import(script, TS.getModule(script, \"@rbxts\", \"make\"))\
local IS_ACRYLIC_ENABLED = TS.import(script, script.Parent, \"constants\").IS_ACRYLIC_ENABLED\
local _services = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\"))\
local Lighting = _services.Lighting\
local Workspace = _services.Workspace\
local changed = TS.import(script, script.Parent, \"store\").changed\
local selectIsClosing = TS.import(script, script.Parent, \"reducers\", \"action-bar\").selectIsClosing\
local baseEffect = Make(\"DepthOfFieldEffect\", {\
\9FarIntensity = 0,\
\9InFocusRadius = 0.1,\
\9NearIntensity = 1,\
})\
local depthOfFieldDefaults = {}\
local function enable()\
\9for effect in pairs(depthOfFieldDefaults) do\
\9\9effect.Enabled = false\
\9end\
\9baseEffect.Parent = Lighting\
end\
local function disable()\
\9for effect, defaults in pairs(depthOfFieldDefaults) do\
\9\9effect.Enabled = defaults.enabled\
\9end\
\9baseEffect.Parent = nil\
end\
local function registerDefaults()\
\9local register = function(object)\
\9\9if object:IsA(\"DepthOfFieldEffect\") then\
\9\9\9local _arg1 = {\
\9\9\9\9enabled = object.Enabled,\
\9\9\9}\
\9\9\9depthOfFieldDefaults[object] = _arg1\
\9\9end\
\9end\
\9local _exp = Lighting:GetChildren()\
\9for _k, _v in ipairs(_exp) do\
\9\9register(_v, _k - 1, _exp)\
\9end\
\9local _result = Workspace.CurrentCamera\
\9if _result ~= nil then\
\9\9local _exp_1 = _result:GetChildren()\
\9\9for _k, _v in ipairs(_exp_1) do\
\9\9\9register(_v, _k - 1, _exp_1)\
\9\9end\
\9end\
end\
if IS_ACRYLIC_ENABLED then\
\9registerDefaults()\
\9enable()\
\9changed(selectIsClosing, function(active)\
\9\9return active and disable()\
\9end)\
end\
", '@'.."RemoteSpy.acrylic")) setfenv(fn, _env("RemoteSpy.acrylic")) return fn() end)

_module("app", "LocalScript", "RemoteSpy.app", "RemoteSpy", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Provider = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-rodux-hooked\").out).Provider\
local App = TS.import(script, script.Parent, \"components\", \"App\").default\
local IS_LOADED = TS.import(script, script.Parent, \"constants\").IS_LOADED\
local _store = TS.import(script, script.Parent, \"store\")\
local changed = _store.changed\
local configureStore = _store.configureStore\
local _global_util = TS.import(script, script.Parent, \"utils\", \"global-util\")\
local getGlobal = _global_util.getGlobal\
local setGlobal = _global_util.setGlobal\
local selectIsClosing = TS.import(script, script.Parent, \"reducers\", \"action-bar\").selectIsClosing\
if getGlobal(IS_LOADED) == true then\
\9error(\"The global \" .. (IS_LOADED .. \" is already defined.\"))\
end\
local store = configureStore()\
local tree = Roact.mount(Roact.createElement(Provider, {\
\9store = store,\
}, {\
\9Roact.createElement(App),\
}))\
changed(selectIsClosing, function(active)\
\9if active then\
\9\9Roact.unmount(tree)\
\9\9setGlobal(IS_LOADED, false)\
\9\9task.defer(function()\
\9\9\9return store:destruct()\
\9\9end)\
\9end\
end)\
setGlobal(IS_LOADED, true)\
", '@'.."RemoteSpy.app")) setfenv(fn, _env("RemoteSpy.app")) return fn() end)

_instance("components", "Folder", "RemoteSpy.components", "RemoteSpy")

_module("Acrylic", "ModuleScript", "RemoteSpy.components.Acrylic", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"Acrylic\").default\
return exports\
", '@'.."RemoteSpy.components.Acrylic")) setfenv(fn, _env("RemoteSpy.components.Acrylic")) return fn() end)

_module("Acrylic", "ModuleScript", "RemoteSpy.components.Acrylic.Acrylic", "RemoteSpy.components.Acrylic", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local AcrylicImpl = TS.import(script, script.Parent, \"AcrylicImpl\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local IS_ACRYLIC_ENABLED = TS.import(script, script.Parent.Parent.Parent, \"constants\").IS_ACRYLIC_ENABLED\
local function Acrylic(_param)\
\9local distance = _param.distance\
\9if not IS_ACRYLIC_ENABLED then\
\9\9return Roact.createFragment()\
\9end\
\9return Roact.createElement(AcrylicImpl, {\
\9\9distance = distance,\
\9})\
end\
return {\
\9default = Acrylic,\
}\
", '@'.."RemoteSpy.components.Acrylic.Acrylic")) setfenv(fn, _env("RemoteSpy.components.Acrylic.Acrylic")) return fn() end)

_module("AcrylicImpl", "ModuleScript", "RemoteSpy.components.Acrylic.AcrylicImpl", "RemoteSpy.components.Acrylic", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Workspace = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).Workspace\
local createAcrylic = TS.import(script, script.Parent, \"create-acrylic\").createAcrylic\
local _utils = TS.import(script, script.Parent, \"utils\")\
local getOffset = _utils.getOffset\
local viewportPointToWorld = _utils.viewportPointToWorld\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useCallback = _roact_hooked.useCallback\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local useMutable = _roact_hooked.useMutable\
local function AcrylicImpl(_param)\
\9local distance = _param.distance\
\9if distance == nil then\
\9\9distance = 0.001\
\9end\
\9local positions = useMutable({\
\9\9topLeft = Vector2.zero,\
\9\9topRight = Vector2.zero,\
\9\9bottomRight = Vector2.zero,\
\9})\
\9local model = useMemo(function()\
\9\9local model = createAcrylic()\
\9\9model.Parent = Workspace\
\9\9return model\
\9end, {})\
\9useEffect(function()\
\9\9return function()\
\9\9\9return model:Destroy()\
\9\9end\
\9end, {})\
\9local updatePositions = useCallback(function(size, position)\
\9\9local _object = {\
\9\9\9topLeft = position,\
\9\9}\
\9\9local _left = \"topRight\"\
\9\9local _vector2 = Vector2.new(size.X, 0)\
\9\9_object[_left] = position + _vector2\
\9\9_object.bottomRight = position + size\
\9\9positions.current = _object\
\9end, { distance })\
\9local render = useCallback(function()\
\9\9local _result = Workspace.CurrentCamera\
\9\9if _result ~= nil then\
\9\9\9_result = _result.CFrame\
\9\9end\
\9\9local _condition = _result\
\9\9if _condition == nil then\
\9\9\9_condition = CFrame.new()\
\9\9end\
\9\9local camera = _condition\
\9\9local _binding = positions.current\
\9\9local topLeft = _binding.topLeft\
\9\9local topRight = _binding.topRight\
\9\9local bottomRight = _binding.bottomRight\
\9\9local topLeft3D = viewportPointToWorld(topLeft, distance)\
\9\9local topRight3D = viewportPointToWorld(topRight, distance)\
\9\9local bottomRight3D = viewportPointToWorld(bottomRight, distance)\
\9\9local width = (topRight3D - topLeft3D).Magnitude\
\9\9local height = (topRight3D - bottomRight3D).Magnitude\
\9\9model.CFrame = CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, camera.XVector, camera.YVector, camera.ZVector)\
\9\9model.Mesh.Scale = Vector3.new(width, height, 0)\
\9end, { distance })\
\9local onChange = useCallback(function(rbx)\
\9\9local offset = getOffset()\
\9\9local _absoluteSize = rbx.AbsoluteSize\
\9\9local _vector2 = Vector2.new(offset, offset)\
\9\9local size = _absoluteSize - _vector2\
\9\9local _absolutePosition = rbx.AbsolutePosition\
\9\9local _vector2_1 = Vector2.new(offset / 2, offset / 2)\
\9\9local position = _absolutePosition + _vector2_1\
\9\9updatePositions(size, position)\
\9\9task.spawn(render)\
\9end, {})\
\9useEffect(function()\
\9\9local camera = Workspace.CurrentCamera\
\9\9local cframeChanged = camera:GetPropertyChangedSignal(\"CFrame\"):Connect(render)\
\9\9local fovChanged = camera:GetPropertyChangedSignal(\"FieldOfView\"):Connect(render)\
\9\9local screenChanged = camera:GetPropertyChangedSignal(\"ViewportSize\"):Connect(render)\
\9\9task.spawn(render)\
\9\9return function()\
\9\9\9cframeChanged:Disconnect()\
\9\9\9fovChanged:Disconnect()\
\9\9\9screenChanged:Disconnect()\
\9\9end\
\9end, { render })\
\9return Roact.createElement(\"Frame\", {\
\9\9[Roact.Change.AbsoluteSize] = onChange,\
\9\9[Roact.Change.AbsolutePosition] = onChange,\
\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9BackgroundTransparency = 1,\
\9})\
end\
local default = pure(AcrylicImpl)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.Acrylic.AcrylicImpl")) setfenv(fn, _env("RemoteSpy.components.Acrylic.AcrylicImpl")) return fn() end)

_module("create-acrylic", "ModuleScript", "RemoteSpy.components.Acrylic.create-acrylic", "RemoteSpy.components.Acrylic", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Make = TS.import(script, TS.getModule(script, \"@rbxts\", \"make\"))\
local function createAcrylic()\
\9return Make(\"Part\", {\
\9\9Name = \"Body\",\
\9\9Color = Color3.new(0, 0, 0),\
\9\9Material = Enum.Material.Glass,\
\9\9Size = Vector3.new(1, 1, 0),\
\9\9Anchored = true,\
\9\9CanCollide = false,\
\9\9Locked = true,\
\9\9CastShadow = false,\
\9\9Transparency = 0.999,\
\9\9Children = { Make(\"SpecialMesh\", {\
\9\9\9MeshType = Enum.MeshType.Brick,\
\9\9\9Offset = Vector3.new(0, 0, -0.000001),\
\9\9}) },\
\9})\
end\
return {\
\9createAcrylic = createAcrylic,\
}\
", '@'.."RemoteSpy.components.Acrylic.create-acrylic")) setfenv(fn, _env("RemoteSpy.components.Acrylic.create-acrylic")) return fn() end)

_module("utils", "ModuleScript", "RemoteSpy.components.Acrylic.utils", "RemoteSpy.components.Acrylic", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Workspace = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).Workspace\
local map = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"number-util\").map\
local function viewportPointToWorld(location, distance)\
\9local unitRay = Workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)\
\9local _origin = unitRay.Origin\
\9local _arg0 = unitRay.Direction * distance\
\9return _origin + _arg0\
end\
local function getOffset()\
\9return map(Workspace.CurrentCamera.ViewportSize.Y, 0, 2560, 8, 56)\
end\
return {\
\9viewportPointToWorld = viewportPointToWorld,\
\9getOffset = getOffset,\
}\
", '@'.."RemoteSpy.components.Acrylic.utils")) setfenv(fn, _env("RemoteSpy.components.Acrylic.utils")) return fn() end)

_module("ActionBar", "ModuleScript", "RemoteSpy.components.ActionBar", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"ActionBar\").default\
return exports\
", '@'.."RemoteSpy.components.ActionBar")) setfenv(fn, _env("RemoteSpy.components.ActionBar")) return fn() end)

_module("ActionBar", "ModuleScript", "RemoteSpy.components.ActionBar.ActionBar", "RemoteSpy.components.ActionBar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local ActionBarEffects = TS.import(script, script.Parent, \"ActionBarEffects\").default\
local ActionButton = TS.import(script, script.Parent, \"ActionButton\").default\
local ActionLine = TS.import(script, script.Parent, \"ActionLine\").default\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function ActionBar()\
\9return Roact.createFragment({\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9BackgroundColor3 = Color3.new(1, 1, 1),\
\9\9\9BackgroundTransparency = 0.92,\
\9\9\9Size = UDim2.new(1, 0, 0, 1),\
\9\9\9Position = UDim2.new(0, 0, 0, 83),\
\9\9\9BorderSizePixel = 0,\
\9\9}),\
\9\9Roact.createElement(ActionBarEffects),\
\9\9Roact.createElement(Container, {\
\9\9\9size = UDim2.new(1, 0, 0, 36),\
\9\9\9position = UDim2.new(0, 0, 0, 42),\
\9\9}, {\
\9\9\9Roact.createElement(ActionButton, {\
\9\9\9\9id = \"navigatePrevious\",\
\9\9\9\9icon = \"rbxassetid://9887696242\",\
\9\9\9}),\
\9\9\9Roact.createElement(ActionButton, {\
\9\9\9\9id = \"navigateNext\",\
\9\9\9\9icon = \"rbxassetid://9887978919\",\
\9\9\9}),\
\9\9\9Roact.createElement(ActionLine),\
\9\9\9Roact.createElement(ActionButton, {\
\9\9\9\9id = \"copy\",\
\9\9\9\9icon = \"rbxassetid://9887696628\",\
\9\9\9}),\
\9\9\9Roact.createElement(ActionButton, {\
\9\9\9\9id = \"save\",\
\9\9\9\9icon = \"rbxassetid://9932819855\",\
\9\9\9}),\
\9\9\9Roact.createElement(ActionButton, {\
\9\9\9\9id = \"delete\",\
\9\9\9\9icon = \"rbxassetid://9887696922\",\
\9\9\9}),\
\9\9\9Roact.createElement(ActionLine),\
\9\9\9Roact.createElement(ActionButton, {\
\9\9\9\9id = \"traceback\",\
\9\9\9\9icon = \"rbxassetid://9887697255\",\
\9\9\9\9caption = \"Traceback\",\
\9\9\9}),\
\9\9\9Roact.createElement(ActionButton, {\
\9\9\9\9id = \"copyPath\",\
\9\9\9\9icon = \"rbxassetid://9887697099\",\
\9\9\9\9caption = \"Copy as path\",\
\9\9\9}),\
\9\9\9Roact.createElement(\"UIListLayout\", {\
\9\9\9\9Padding = UDim.new(0, 4),\
\9\9\9\9FillDirection = \"Horizontal\",\
\9\9\9\9HorizontalAlignment = \"Left\",\
\9\9\9\9VerticalAlignment = \"Center\",\
\9\9\9}),\
\9\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9\9PaddingLeft = UDim.new(0, 8),\
\9\9\9}),\
\9\9}),\
\9})\
end\
return {\
\9default = ActionBar,\
}\
", '@'.."RemoteSpy.components.ActionBar.ActionBar")) setfenv(fn, _env("RemoteSpy.components.ActionBar.ActionBar")) return fn() end)

_module("ActionBarEffects", "ModuleScript", "RemoteSpy.components.ActionBar.ActionBarEffects", "RemoteSpy.components.ActionBar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _tab_group = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"tab-group\")\
local TabType = _tab_group.TabType\
local deleteTab = _tab_group.deleteTab\
local selectActiveTab = _tab_group.selectActiveTab\
local _utils = TS.import(script, script.Parent, \"utils\")\
local codifyOutgoingSignal = _utils.codifyOutgoingSignal\
local stringifyRemote = _utils.stringifyRemote\
local _instance_util = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"instance-util\")\
local getInstanceFromId = _instance_util.getInstanceFromId\
local getInstancePath = _instance_util.getInstancePath\
local _remote_log = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"remote-log\")\
local makeSelectRemoteLog = _remote_log.makeSelectRemoteLog\
local removeOutgoingSignal = _remote_log.removeOutgoingSignal\
local selectRemoteIdSelected = _remote_log.selectRemoteIdSelected\
local selectSignalSelected = _remote_log.selectSignalSelected\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useEffect = _roact_hooked.useEffect\
local removeRemoteLog = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"remote-log\").removeRemoteLog\
local setActionEnabled = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"action-bar\").setActionEnabled\
local useActionEffect = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-action-effect\").useActionEffect\
local _use_root_store = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-root-store\")\
local useRootDispatch = _use_root_store.useRootDispatch\
local useRootSelector = _use_root_store.useRootSelector\
local useRootStore = _use_root_store.useRootStore\
local selectRemoteLog = makeSelectRemoteLog()\
local function ActionBarEffects()\
\9local store = useRootStore()\
\9local dispatch = useRootDispatch()\
\9local currentTab = useRootSelector(selectActiveTab)\
\9local remoteId = useRootSelector(selectRemoteIdSelected)\
\9local remote = useRootSelector(function(state)\
\9\9return if remoteId ~= nil then selectRemoteLog(state, remoteId) else nil\
\9end)\
\9local signal = useRootSelector(selectSignalSelected)\
\9useActionEffect(\"copy\", function()\
\9\9if remote then\
\9\9\9local _result = setclipboard\
\9\9\9if _result ~= nil then\
\9\9\9\9_result(getInstancePath(remote.object))\
\9\9\9end\
\9\9elseif signal then\
\9\9\9local _result = setclipboard\
\9\9\9if _result ~= nil then\
\9\9\9\9_result(codifyOutgoingSignal(signal))\
\9\9\9end\
\9\9end\
\9end)\
\9useActionEffect(\"copyPath\", function()\
\9\9local _result = remote\
\9\9if _result ~= nil then\
\9\9\9_result = _result.object\
\9\9end\
\9\9local _condition = _result\
\9\9if _condition == nil then\
\9\9\9_condition = (currentTab and getInstanceFromId(currentTab.id))\
\9\9end\
\9\9local object = _condition\
\9\9if object then\
\9\9\9local _result_1 = setclipboard\
\9\9\9if _result_1 ~= nil then\
\9\9\9\9_result_1(getInstancePath(object))\
\9\9\9end\
\9\9end\
\9end)\
\9useActionEffect(\"save\", function()\
\9\9if remote then\
\9\9\9local remoteName = string.gsub(string.sub(getInstancePath(remote.object), -66, -1), \"[^a-zA-Z0-9]+\", \"_\")\
\9\9\9local fileName = remoteName .. \".txt\"\
\9\9\9local fileContents = stringifyRemote(remote)\
\9\9\9local _result = writefile\
\9\9\9if _result ~= nil then\
\9\9\9\9_result(fileName, fileContents)\
\9\9\9end\
\9\9elseif signal then\
\9\9\9local remote = selectRemoteLog(store:getState(), signal.remoteId)\
\9\9\9local _outgoing = remote.outgoing\
\9\9\9local _arg0 = function(s)\
\9\9\9\9return s.id == signal.id\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.findIndex ▼\
\9\9\9local _result = -1\
\9\9\9for _i, _v in ipairs(_outgoing) do\
\9\9\9\9if _arg0(_v, _i - 1, _outgoing) == true then\
\9\9\9\9\9_result = _i - 1\
\9\9\9\9\9break\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.findIndex ▲\
\9\9\9local signalOrder = _result\
\9\9\9local remoteName = string.gsub(string.sub(getInstancePath(remote.object), -66, -1), \"[^a-zA-Z0-9]+\", \"_\")\
\9\9\9local fileName = remoteName .. (\"_Signal\" .. (tostring(signalOrder + 1) .. \".txt\"))\
\9\9\9local fileContents = stringifyRemote(remote, function(s)\
\9\9\9\9return signal.id == s.id\
\9\9\9end)\
\9\9\9local _result_1 = writefile\
\9\9\9if _result_1 ~= nil then\
\9\9\9\9_result_1(fileName, fileContents)\
\9\9\9end\
\9\9end\
\9end)\
\9useActionEffect(\"delete\", function()\
\9\9if remote then\
\9\9\9dispatch(removeRemoteLog(remote.id))\
\9\9\9dispatch(deleteTab(remote.id))\
\9\9elseif signal then\
\9\9\9dispatch(removeOutgoingSignal(signal.remoteId, signal.id))\
\9\9end\
\9end)\
\9useEffect(function()\
\9\9local remoteEnabled = remoteId ~= nil\
\9\9local _condition = signal ~= nil\
\9\9if _condition then\
\9\9\9local _result = currentTab\
\9\9\9if _result ~= nil then\
\9\9\9\9_result = _result.id\
\9\9\9end\
\9\9\9_condition = _result == signal.remoteId\
\9\9end\
\9\9local signalEnabled = _condition\
\9\9local _result = currentTab\
\9\9if _result ~= nil then\
\9\9\9_result = _result.type\
\9\9end\
\9\9local isHome = _result == TabType.Home\
\9\9dispatch(setActionEnabled(\"copy\", remoteEnabled or signalEnabled))\
\9\9dispatch(setActionEnabled(\"save\", remoteEnabled or signalEnabled))\
\9\9dispatch(setActionEnabled(\"delete\", remoteEnabled or signalEnabled))\
\9\9dispatch(setActionEnabled(\"traceback\", signalEnabled))\
\9\9dispatch(setActionEnabled(\"copyPath\", remoteEnabled or not isHome))\
\9end, { remoteId == nil, signal, currentTab })\
\9return Roact.createFragment()\
end\
local default = pure(ActionBarEffects)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.ActionBar.ActionBarEffects")) setfenv(fn, _env("RemoteSpy.components.ActionBar.ActionBarEffects")) return fn() end)

_module("ActionButton", "ModuleScript", "RemoteSpy.components.ActionBar.ActionButton", "RemoteSpy.components.ActionBar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent, \"Button\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _action_bar = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"action-bar\")\
local activateAction = _action_bar.activateAction\
local selectActionById = _action_bar.selectActionById\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local TextService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).TextService\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useMemo = _roact_hooked.useMemo\
local useGroupMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useGroupMotor\
local _use_root_store = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-root-store\")\
local useRootDispatch = _use_root_store.useRootDispatch\
local useRootSelector = _use_root_store.useRootSelector\
local MARGIN = 10\
local BUTTON_DEFAULT = { Spring.new(1, {\
\9frequency = 6,\
}), Spring.new(0, {\
\9frequency = 6,\
}) }\
local BUTTON_HOVERED = { Spring.new(0.94, {\
\9frequency = 6,\
}), Spring.new(0, {\
\9frequency = 6,\
}) }\
local BUTTON_PRESSED = { Instant.new(0.96), Instant.new(0.2) }\
local function ActionButton(_param)\
\9local id = _param.id\
\9local icon = _param.icon\
\9local caption = _param.caption\
\9local dispatch = useRootDispatch()\
\9local actionState = useRootSelector(function(state)\
\9\9return selectActionById(state, id)\
\9end)\
\9local _binding = useGroupMotor({ 1, 0 })\
\9local transparency = _binding[1]\
\9local setGoal = _binding[2]\
\9local backgroundTransparency = if actionState.disabled then 1 else transparency:map(function(t)\
\9\9return t[1]\
\9end)\
\9local foregroundTransparency = if actionState.disabled then 0.5 else transparency:map(function(t)\
\9\9return t[2]\
\9end)\
\9local textSize = useMemo(function()\
\9\9return if caption ~= nil then TextService:GetTextSize(caption, 11, \"Gotham\", Vector2.new(150, 36)) else Vector2.new()\
\9end, { caption })\
\9local _attributes = {\
\9\9onClick = function()\
\9\9\9setGoal(BUTTON_HOVERED)\
\9\9\9local _ = not actionState.disabled and (not actionState.active and dispatch(activateAction(id)))\
\9\9end,\
\9\9onPress = function()\
\9\9\9return setGoal(BUTTON_PRESSED)\
\9\9end,\
\9\9onHover = function()\
\9\9\9return setGoal(BUTTON_HOVERED)\
\9\9end,\
\9\9onHoverEnd = function()\
\9\9\9return setGoal(BUTTON_DEFAULT)\
\9\9end,\
\9\9active = not actionState.disabled,\
\9\9size = UDim2.new(0, if caption ~= nil then textSize.X + 16 + MARGIN * 3 else 36, 0, 36),\
\9\9transparency = backgroundTransparency,\
\9\9cornerRadius = UDim.new(0, 4),\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = icon,\
\9\9\9ImageTransparency = foregroundTransparency,\
\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9Position = UDim2.new(0, MARGIN, 0.5, 0),\
\9\9\9AnchorPoint = Vector2.new(0, 0.5),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9}\
\9local _length = #_children\
\9local _child = caption ~= nil and (Roact.createElement(\"TextLabel\", {\
\9\9Text = caption,\
\9\9Font = \"Gotham\",\
\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9TextTransparency = foregroundTransparency,\
\9\9TextSize = 11,\
\9\9TextXAlignment = \"Left\",\
\9\9TextYAlignment = \"Center\",\
\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9Position = UDim2.new(0, MARGIN * 2 + 16, 0, 0),\
\9\9BackgroundTransparency = 1,\
\9}))\
\9if _child then\
\9\9_children[_length + 1] = _child\
\9end\
\9return Roact.createElement(Button, _attributes, _children)\
end\
local default = pure(ActionButton)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.ActionBar.ActionButton")) setfenv(fn, _env("RemoteSpy.components.ActionBar.ActionButton")) return fn() end)

_module("ActionLine", "ModuleScript", "RemoteSpy.components.ActionBar.ActionLine", "RemoteSpy.components.ActionBar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function ActionLine()\
\9return Roact.createElement(Container, {\
\9\9size = UDim2.new(0, 13, 0, 32),\
\9}, {\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9BackgroundColor3 = Color3.new(1, 1, 1),\
\9\9\9BackgroundTransparency = 0.92,\
\9\9\9Size = UDim2.new(0, 1, 0, 24),\
\9\9\9Position = UDim2.new(0, 6, 0, 4),\
\9\9\9BorderSizePixel = 0,\
\9\9}),\
\9})\
end\
return {\
\9default = ActionLine,\
}\
", '@'.."RemoteSpy.components.ActionBar.ActionLine")) setfenv(fn, _env("RemoteSpy.components.ActionBar.ActionLine")) return fn() end)

_module("utils", "ModuleScript", "RemoteSpy.components.ActionBar.utils", "RemoteSpy.components.ActionBar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local stringifySignalTraceback = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"remote-log\").stringifySignalTraceback\
local codifyTable = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"codify\").codifyTable\
local _function_util = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"function-util\")\
local describeFunction = _function_util.describeFunction\
local stringifyFunctionSignature = _function_util.stringifyFunctionSignature\
local getInstancePath = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"instance-util\").getInstancePath\
local line = \"-----------------------------------------------------\"\
local stringifyOutgoingSignal\
local function stringifyRemote(remote, filter)\
\9local lines = {}\
\9local _arg0 = \"Remote name: \" .. remote.object.Name\
\9table.insert(lines, _arg0)\
\9local _arg0_1 = \"Remote type: \" .. remote.object.ClassName\
\9table.insert(lines, _arg0_1)\
\9local _arg0_2 = \"Remote location: \" .. getInstancePath(remote.object)\
\9table.insert(lines, _arg0_2)\
\9local _outgoing = remote.outgoing\
\9local _arg0_3 = function(signal, index)\
\9\9if if filter then filter(signal) else true then\
\9\9\9local _arg0_4 = line .. \"\\n\" .. stringifyOutgoingSignal(signal, index)\
\9\9\9table.insert(lines, _arg0_4)\
\9\9end\
\9end\
\9for _k, _v in ipairs(_outgoing) do\
\9\9_arg0_3(_v, _k - 1, _outgoing)\
\9end\
\9return table.concat(lines, \"\\n\")\
end\
function stringifyOutgoingSignal(signal, index)\
\9local lines = {}\
\9local description = describeFunction(signal.callback)\
\9if index ~= nil then\
\9\9local _arg0 = \"(OUTGOING SIGNAL \" .. (tostring(index + 1) .. \")\")\
\9\9table.insert(lines, _arg0)\
\9end\
\9local _arg0 = \"Calling script: \" .. (if signal.caller then signal.caller.Name else \"Not called from a script\")\
\9table.insert(lines, _arg0)\
\9local _arg0_1 = \"Remote name: \" .. signal.name\
\9table.insert(lines, _arg0_1)\
\9local _arg0_2 = \"Remote location: \" .. signal.pathFmt\
\9table.insert(lines, _arg0_2)\
\9local _arg0_3 = \"Remote parameters: \" .. codifyTable(signal.parameters)\
\9table.insert(lines, _arg0_3)\
\9local _arg0_4 = \"Function signature: \" .. stringifyFunctionSignature(signal.callback)\
\9table.insert(lines, _arg0_4)\
\9local _arg0_5 = \"Function source: \" .. description.source\
\9table.insert(lines, _arg0_5)\
\9table.insert(lines, \"Function traceback:\")\
\9for _, line in ipairs(stringifySignalTraceback(signal)) do\
\9\9local _arg0_6 = \"\9\" .. line\
\9\9table.insert(lines, _arg0_6)\
\9end\
\9return table.concat(lines, \"\\n\")\
end\
local function codifyOutgoingSignal(signal)\
\9local lines = {}\
\9local _arg0 = \"local remote = \" .. signal.pathFmt\
\9table.insert(lines, _arg0)\
\9local _arg0_1 = \"local arguments = \" .. codifyTable(signal.parameters)\
\9table.insert(lines, _arg0_1)\
\9if signal.remote:IsA(\"RemoteEvent\") then\
\9\9table.insert(lines, \"remote:FireServer(unpack(arguments))\")\
\9else\
\9\9table.insert(lines, \"local results = remote:InvokeServer(unpack(arguments))\")\
\9end\
\9return table.concat(lines, \"\\n\\n\")\
end\
return {\
\9stringifyRemote = stringifyRemote,\
\9stringifyOutgoingSignal = stringifyOutgoingSignal,\
\9codifyOutgoingSignal = codifyOutgoingSignal,\
}\
", '@'.."RemoteSpy.components.ActionBar.utils")) setfenv(fn, _env("RemoteSpy.components.ActionBar.utils")) return fn() end)

_module("App", "ModuleScript", "RemoteSpy.components.App", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"App\").default\
return exports\
", '@'.."RemoteSpy.components.App")) setfenv(fn, _env("RemoteSpy.components.App")) return fn() end)

_module("App", "ModuleScript", "RemoteSpy.components.App.App", "RemoteSpy.components.App", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local MainWindow = TS.import(script, script.Parent.Parent, \"MainWindow\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function App()\
\9return Roact.createFragment({\
\9\9Roact.createElement(MainWindow),\
\9})\
end\
return {\
\9default = App,\
}\
", '@'.."RemoteSpy.components.App.App")) setfenv(fn, _env("RemoteSpy.components.App.App")) return fn() end)

_module("App.story", "ModuleScript", "RemoteSpy.components.App.App.story", "RemoteSpy.components.App", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local App = TS.import(script, script.Parent, \"App\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Provider = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-rodux-hooked\").out).Provider\
local configureStore = TS.import(script, script.Parent.Parent.Parent, \"store\").configureStore\
local _remote_log = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"remote-log\")\
local createOutgoingSignal = _remote_log.createOutgoingSignal\
local createRemoteLog = _remote_log.createRemoteLog\
local pushOutgoingSignal = _remote_log.pushOutgoingSignal\
local pushRemoteLog = _remote_log.pushRemoteLog\
local getInstanceId = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"instance-util\").getInstanceId\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local useRootDispatch = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-root-store\").useRootDispatch\
local rng = Random.new()\
local function testFn(x, y)\
end\
local function testFnCaller(x, ...)\
\9local args = { ... }\
\9testFn()\
end\
local function topLevelCaller(x, y, z)\
\9testFnCaller()\
end\
local Dispatcher = pure(function()\
\9local dispatch = useRootDispatch()\
\9local names = { \"SendMessage\", \"UpdateCameraLook\", \"TryGetValue\", \"GetEnumerator\", \"ToString\", \"RequestStoreState\", \"ReallyLongNameForSomeReason \\n ☆*: .｡. o(≧▽≦)o .｡.:*☆ \\n Lol\", \"PurchaseProduct\", \"IsMessaging\", \"TestDispatcher\", \"RequestAction\" }\
\9for _, name in ipairs(names) do\
\9\9local className = if rng:NextInteger(0, 1) == 1 then \"RemoteEvent\" else \"RemoteFunction\"\
\9\9local remote = {\
\9\9\9Name = name,\
\9\9\9ClassName = className,\
\9\9\9Parent = game:GetService(\"ReplicatedStorage\"),\
\9\9\9IsA = function(self, name)\
\9\9\9\9return className == name\
\9\9\9end,\
\9\9\9GetFullName = function(self)\
\9\9\9\9return \"ReplicatedStorage.\" .. name\
\9\9\9end,\
\9\9}\
\9\9dispatch(pushRemoteLog(createRemoteLog(remote)))\
\9\9local max = rng:NextInteger(-3, 30)\
\9\9do\
\9\9\9local i = 0\
\9\9\9local _shouldIncrement = false\
\9\9\9while true do\
\9\9\9\9if _shouldIncrement then\
\9\9\9\9\9i += 1\
\9\9\9\9else\
\9\9\9\9\9_shouldIncrement = true\
\9\9\9\9end\
\9\9\9\9if not (i < max) then\
\9\9\9\9\9break\
\9\9\9\9end\
\9\9\9\9if i < 0 then\
\9\9\9\9\9break\
\9\9\9\9end\
\9\9\9\9local signal = createOutgoingSignal(remote, nil, testFn, { testFn, testFnCaller, topLevelCaller }, { \"Hello\", rng:NextInteger(100, 1000), {\
\9\9\9\9\9message = \"Hello, world!\",\
\9\9\9\9\9receivers = {},\
\9\9\9\9}, rng:NextInteger(100, 1000), game:GetService(\"Workspace\") })\
\9\9\9\9dispatch(pushOutgoingSignal(getInstanceId(remote), signal))\
\9\9\9end\
\9\9end\
\9end\
\9return Roact.createFragment()\
end)\
return function(target)\
\9local handle = Roact.mount(Roact.createElement(Provider, {\
\9\9store = configureStore(),\
\9}, {\
\9\9Roact.createElement(Dispatcher),\
\9\9Roact.createElement(App),\
\9}), target, \"App\")\
\9return function()\
\9\9Roact.unmount(handle)\
\9end\
end\
", '@'.."RemoteSpy.components.App.App.story")) setfenv(fn, _env("RemoteSpy.components.App.App.story")) return fn() end)

_module("Button", "ModuleScript", "RemoteSpy.components.Button", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function Button(props)\
\9local _attributes = {\
\9\9[Roact.Event.Activated] = props.onClick,\
\9\9[Roact.Event.MouseButton1Down] = props.onPress,\
\9\9[Roact.Event.MouseButton1Up] = props.onRelease,\
\9\9[Roact.Event.MouseEnter] = props.onHover,\
\9\9[Roact.Event.MouseLeave] = props.onHoverEnd,\
\9\9Active = props.active,\
\9\9BackgroundColor3 = props.background or Color3.new(1, 1, 1),\
\9}\
\9local _condition = props.transparency\
\9if _condition == nil then\
\9\9_condition = 1\
\9end\
\9_attributes.BackgroundTransparency = _condition\
\9_attributes.Size = props.size\
\9_attributes.Position = props.position\
\9_attributes.AnchorPoint = props.anchorPoint\
\9_attributes.ZIndex = props.zIndex\
\9_attributes.LayoutOrder = props.layoutOrder\
\9_attributes.Text = \"\"\
\9_attributes.BorderSizePixel = 0\
\9_attributes.AutoButtonColor = false\
\9local _children = {}\
\9local _length = #_children\
\9local _child = props[Roact.Children]\
\9if _child then\
\9\9for _k, _v in pairs(_child) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_children[_length + _k] = _v\
\9\9\9else\
\9\9\9\9_children[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9_length = #_children\
\9local _child_1 = props.cornerRadius and Roact.createElement(\"UICorner\", {\
\9\9CornerRadius = props.cornerRadius,\
\9})\
\9if _child_1 then\
\9\9_children[_length + 1] = _child_1\
\9end\
\9return Roact.createElement(\"TextButton\", _attributes, _children)\
end\
return {\
\9default = Button,\
}\
", '@'.."RemoteSpy.components.Button")) setfenv(fn, _env("RemoteSpy.components.Button")) return fn() end)

_module("Container", "ModuleScript", "RemoteSpy.components.Container", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function Container(_param)\
\9local size = _param.size\
\9if size == nil then\
\9\9size = UDim2.new(1, 0, 1, 0)\
\9end\
\9local position = _param.position\
\9local anchorPoint = _param.anchorPoint\
\9local order = _param.order\
\9local clipChildren = _param.clipChildren\
\9local children = _param[Roact.Children]\
\9local _attributes = {\
\9\9Size = size,\
\9\9Position = position,\
\9\9AnchorPoint = anchorPoint,\
\9\9LayoutOrder = order,\
\9\9ClipsDescendants = clipChildren,\
\9\9BackgroundTransparency = 1,\
\9}\
\9local _children = {}\
\9local _length = #_children\
\9if children then\
\9\9for _k, _v in pairs(children) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_children[_length + _k] = _v\
\9\9\9else\
\9\9\9\9_children[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9return Roact.createElement(\"Frame\", _attributes, _children)\
end\
return {\
\9default = Container,\
}\
", '@'.."RemoteSpy.components.Container")) setfenv(fn, _env("RemoteSpy.components.Container")) return fn() end)

_module("FunctionTree", "ModuleScript", "RemoteSpy.components.FunctionTree", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"FunctionTree\").default\
return exports\
", '@'.."RemoteSpy.components.FunctionTree")) setfenv(fn, _env("RemoteSpy.components.FunctionTree")) return fn() end)

_module("FunctionTree", "ModuleScript", "RemoteSpy.components.FunctionTree.FunctionTree", "RemoteSpy.components.FunctionTree", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _SidePanel = TS.import(script, script.Parent.Parent, \"SidePanel\")\
local SidePanel = _SidePanel.default\
local useSidePanelContext = _SidePanel.useSidePanelContext\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local Divider = function()\
\9return Roact.createElement(\"Frame\", {\
\9\9BackgroundColor3 = Color3.new(1, 1, 1),\
\9\9BackgroundTransparency = 0.92,\
\9\9Size = UDim2.new(1, 0, 0, 1),\
\9\9Position = UDim2.new(0, 0, 1, -1),\
\9\9BorderSizePixel = 0,\
\9})\
end\
local function FunctionTree()\
\9local _binding = useSidePanelContext()\
\9local setUpperHidden = _binding.setUpperHidden\
\9local upperHidden = _binding.upperHidden\
\9local upperSize = _binding.upperSize\
\9return Roact.createElement(Container, {\
\9\9size = upperSize,\
\9}, {\
\9\9Roact.createElement(SidePanel.TitleBar, {\
\9\9\9caption = \"Function Tree\",\
\9\9\9hidden = upperHidden,\
\9\9\9toggleHidden = function()\
\9\9\9\9return setUpperHidden(not upperHidden)\
\9\9\9end,\
\9\9}),\
\9\9Roact.createElement(Divider),\
\9})\
end\
local default = pure(FunctionTree)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.FunctionTree.FunctionTree")) setfenv(fn, _env("RemoteSpy.components.FunctionTree.FunctionTree")) return fn() end)

_module("MainWindow", "ModuleScript", "RemoteSpy.components.MainWindow", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"MainWindow\").default\
return exports\
", '@'.."RemoteSpy.components.MainWindow")) setfenv(fn, _env("RemoteSpy.components.MainWindow")) return fn() end)

_module("AcrylicBackground", "ModuleScript", "RemoteSpy.components.MainWindow.AcrylicBackground", "RemoteSpy.components.MainWindow", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Acrylic = TS.import(script, script.Parent.Parent, \"Acrylic\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Window = TS.import(script, script.Parent.Parent, \"Window\").default\
local function AcrylicBackground()\
\9return Roact.createElement(Window.Background, {\
\9\9background = Color3.fromHex(\"#FFFFFF\"),\
\9\9transparency = 0.9,\
\9}, {\
\9\9Roact.createElement(Acrylic),\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9BackgroundColor3 = Color3.fromHex(\"#1C1F28\"),\
\9\9\9BackgroundTransparency = 0.4,\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BorderSizePixel = 0,\
\9\9}, {\
\9\9\9Roact.createElement(\"UICorner\", {\
\9\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9BackgroundColor3 = Color3.fromHex(\"#FFFFFF\"),\
\9\9\9BackgroundTransparency = 0.4,\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BorderSizePixel = 0,\
\9\9}, {\
\9\9\9Roact.createElement(\"UICorner\", {\
\9\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9\9}),\
\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9Color = ColorSequence.new(Color3.fromHex(\"#252221\"), Color3.fromHex(\"#171515\")),\
\9\9\9\9Rotation = 90,\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9968344105\",\
\9\9\9ImageTransparency = 0.98,\
\9\9\9ScaleType = \"Tile\",\
\9\9\9TileSize = UDim2.new(0, 128, 0, 128),\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UICorner\", {\
\9\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9968344227\",\
\9\9\9ImageTransparency = 0.85,\
\9\9\9ScaleType = \"Tile\",\
\9\9\9TileSize = UDim2.new(0, 128, 0, 128),\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UICorner\", {\
\9\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9\9}),\
\9\9}),\
\9})\
end\
return {\
\9default = AcrylicBackground,\
}\
", '@'.."RemoteSpy.components.MainWindow.AcrylicBackground")) setfenv(fn, _env("RemoteSpy.components.MainWindow.AcrylicBackground")) return fn() end)

_module("MainWindow", "ModuleScript", "RemoteSpy.components.MainWindow.MainWindow", "RemoteSpy.components.MainWindow", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local AcrylicBackground = TS.import(script, script.Parent, \"AcrylicBackground\").default\
local ActionBar = TS.import(script, script.Parent.Parent, \"ActionBar\").default\
local FunctionTree = TS.import(script, script.Parent.Parent, \"FunctionTree\").default\
local PageGroup = TS.import(script, script.Parent.Parent, \"PageGroup\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Root = TS.import(script, script.Parent.Parent, \"Root\").default\
local SidePanel = TS.import(script, script.Parent.Parent, \"SidePanel\").default\
local TabGroup = TS.import(script, script.Parent.Parent, \"TabGroup\").default\
local Traceback = TS.import(script, script.Parent.Parent, \"Traceback\").default\
local Window = TS.import(script, script.Parent.Parent, \"Window\").default\
local activateAction = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"action-bar\").activateAction\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local useRootDispatch = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-root-store\").useRootDispatch\
local function MainWindow()\
\9local dispatch = useRootDispatch()\
\9return Roact.createElement(Root, {}, {\
\9\9Roact.createElement(Window.Root, {\
\9\9\9initialSize = UDim2.new(0, 1080, 0, 700),\
\9\9\9initialPosition = UDim2.new(0.5, -540, 0.5, -350),\
\9\9}, {\
\9\9\9Roact.createElement(Window.DropShadow),\
\9\9\9Roact.createElement(AcrylicBackground),\
\9\9\9Roact.createElement(ActionBar),\
\9\9\9Roact.createElement(TabGroup),\
\9\9\9Roact.createElement(PageGroup),\
\9\9\9Roact.createElement(SidePanel.Root, {}, {\
\9\9\9\9Roact.createElement(Traceback),\
\9\9\9\9Roact.createElement(FunctionTree),\
\9\9\9}),\
\9\9\9Roact.createElement(Window.TitleBar, {\
\9\9\9\9onClose = function()\
\9\9\9\9\9return dispatch(activateAction(\"close\"))\
\9\9\9\9end,\
\9\9\9\9caption = '<font color=\"#FFFFFF\">RemoteSpy</font>    <font color=\"#B2B2B2\">' .. (\"0.2.0-alpha\" .. \"</font>\"),\
\9\9\9\9captionTransparency = 0.1,\
\9\9\9\9icon = \"rbxassetid://9886981409\",\
\9\9\9}),\
\9\9\9Roact.createElement(Window.Resize, {\
\9\9\9\9minSize = Vector2.new(650, 450),\
\9\9\9}),\
\9\9}),\
\9})\
end\
local default = pure(MainWindow)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.MainWindow.MainWindow")) setfenv(fn, _env("RemoteSpy.components.MainWindow.MainWindow")) return fn() end)

_module("MainWindow.story", "ModuleScript", "RemoteSpy.components.MainWindow.MainWindow.story", "RemoteSpy.components.MainWindow", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local MainWindow = TS.import(script, script.Parent, \"MainWindow\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Provider = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-rodux-hooked\").out).Provider\
local configureStore = TS.import(script, script.Parent.Parent.Parent, \"store\").configureStore\
return function(target)\
\9local handle = Roact.mount(Roact.createElement(Provider, {\
\9\9store = configureStore(),\
\9}, {\
\9\9Roact.createElement(MainWindow),\
\9}), target, \"MainWindow\")\
\9return function()\
\9\9Roact.unmount(handle)\
\9end\
end\
", '@'.."RemoteSpy.components.MainWindow.MainWindow.story")) setfenv(fn, _env("RemoteSpy.components.MainWindow.MainWindow.story")) return fn() end)

_module("PageGroup", "ModuleScript", "RemoteSpy.components.PageGroup", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"PageGroup\").default\
return exports\
", '@'.."RemoteSpy.components.PageGroup")) setfenv(fn, _env("RemoteSpy.components.PageGroup")) return fn() end)

_module("Home", "ModuleScript", "RemoteSpy.components.PageGroup.Home", "RemoteSpy.components.PageGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"Home\").default\
return exports\
", '@'.."RemoteSpy.components.PageGroup.Home")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Home")) return fn() end)

_module("Home", "ModuleScript", "RemoteSpy.components.PageGroup.Home.Home", "RemoteSpy.components.PageGroup.Home", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Row = TS.import(script, script.Parent, \"Row\").default\
local Selection = TS.import(script, script.Parent.Parent.Parent, \"Selection\").default\
local arrayToMap = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).arrayToMap\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useEffect = _roact_hooked.useEffect\
local _remote_log = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\")\
local selectRemoteIdSelected = _remote_log.selectRemoteIdSelected\
local selectRemoteLogIds = _remote_log.selectRemoteLogIds\
local setRemoteSelected = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\").setRemoteSelected\
local _use_root_store = TS.import(script, script.Parent.Parent.Parent.Parent, \"hooks\", \"use-root-store\")\
local useRootDispatch = _use_root_store.useRootDispatch\
local useRootSelector = _use_root_store.useRootSelector\
local function Home(_param)\
\9local pageSelected = _param.pageSelected\
\9local dispatch = useRootDispatch()\
\9local remoteLogIds = useRootSelector(selectRemoteLogIds)\
\9local selection = useRootSelector(selectRemoteIdSelected)\
\9useEffect(function()\
\9\9local _value = not pageSelected and selection\
\9\9if _value ~= \"\" and _value then\
\9\9\9dispatch(setRemoteSelected(nil))\
\9\9end\
\9end, { pageSelected })\
\9useEffect(function()\
\9\9if selection ~= nil and not (table.find(remoteLogIds, selection) ~= nil) then\
\9\9\9dispatch(setRemoteSelected(nil))\
\9\9end\
\9end, { remoteLogIds })\
\9local selectionOrder = if selection ~= nil then (table.find(remoteLogIds, selection) or 0) - 1 else -1\
\9local _attributes = {\
\9\9ScrollBarThickness = 0,\
\9\9ScrollBarImageTransparency = 1,\
\9\9CanvasSize = UDim2.new(0, 0, 0, (#remoteLogIds + 1) * (64 + 4)),\
\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9BorderSizePixel = 0,\
\9\9BackgroundTransparency = 1,\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9PaddingLeft = UDim.new(0, 12),\
\9\9\9PaddingRight = UDim.new(0, 12),\
\9\9\9PaddingTop = UDim.new(0, 12),\
\9\9}),\
\9\9Roact.createElement(Selection, {\
\9\9\9height = 64,\
\9\9\9offset = if selectionOrder ~= -1 then selectionOrder * (64 + 4) else nil,\
\9\9\9hasSelection = selection ~= nil,\
\9\9}),\
\9}\
\9local _length = #_children\
\9for _k, _v in pairs(arrayToMap(remoteLogIds, function(id, order)\
\9\9return { id, Roact.createElement(Row, {\
\9\9\9id = id,\
\9\9\9order = order,\
\9\9\9selected = selection == id,\
\9\9\9onClick = function()\
\9\9\9\9return if selection ~= id then dispatch(setRemoteSelected(id)) else dispatch(setRemoteSelected(nil))\
\9\9\9end,\
\9\9}) }\
\9end)) do\
\9\9_children[_k] = _v\
\9end\
\9return Roact.createElement(\"ScrollingFrame\", _attributes, _children)\
end\
local default = pure(Home)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Home.Home")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Home.Home")) return fn() end)

_module("Row", "ModuleScript", "RemoteSpy.components.PageGroup.Home.Row", "RemoteSpy.components.PageGroup.Home", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent.Parent, \"Button\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local _tab_group = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"tab-group\")\
local TabType = _tab_group.TabType\
local createTabColumn = _tab_group.createTabColumn\
local pushTab = _tab_group.pushTab\
local selectTab = _tab_group.selectTab\
local setActiveTab = _tab_group.setActiveTab\
local formatEscapes = TS.import(script, script.Parent.Parent.Parent.Parent, \"utils\", \"format-escapes\").formatEscapes\
local getInstancePath = TS.import(script, script.Parent.Parent.Parent.Parent, \"utils\", \"instance-util\").getInstancePath\
local _remote_log = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\")\
local makeSelectRemoteLogObject = _remote_log.makeSelectRemoteLogObject\
local makeSelectRemoteLogOutgoing = _remote_log.makeSelectRemoteLogOutgoing\
local makeSelectRemoteLogType = _remote_log.makeSelectRemoteLogType\
local multiply = TS.import(script, script.Parent.Parent.Parent.Parent, \"utils\", \"number-util\").multiply\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useCallback = _roact_hooked.useCallback\
local useMemo = _roact_hooked.useMemo\
local useMutable = _roact_hooked.useMutable\
local _roact_hooked_plus = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out)\
local useGroupMotor = _roact_hooked_plus.useGroupMotor\
local useSpring = _roact_hooked_plus.useSpring\
local _use_root_store = TS.import(script, script.Parent.Parent.Parent.Parent, \"hooks\", \"use-root-store\")\
local useRootSelector = _use_root_store.useRootSelector\
local useRootStore = _use_root_store.useRootStore\
local ROW_DEFAULT = { Spring.new(1, {\
\9frequency = 6,\
}), Spring.new(0, {\
\9frequency = 6,\
}) }\
local ROW_HOVERED = { Spring.new(0.95, {\
\9frequency = 6,\
}), Spring.new(0, {\
\9frequency = 6,\
}) }\
local ROW_PRESSED = { Instant.new(0.97), Instant.new(0.2) }\
local function Row(_param)\
\9local onClick = _param.onClick\
\9local id = _param.id\
\9local order = _param.order\
\9local selected = _param.selected\
\9local store = useRootStore()\
\9local selectType = useMemo(makeSelectRemoteLogType, {})\
\9local remoteType = useRootSelector(function(state)\
\9\9return selectType(state, id)\
\9end)\
\9local selectObject = useMemo(makeSelectRemoteLogObject, {})\
\9local remoteObject = useRootSelector(function(state)\
\9\9return selectObject(state, id)\
\9end)\
\9local selectOutgoing = useMemo(makeSelectRemoteLogOutgoing, {})\
\9local outgoing = useRootSelector(function(state)\
\9\9return selectOutgoing(state, id)\
\9end)\
\9local _binding = useGroupMotor({ 1, 0 })\
\9local transparency = _binding[1]\
\9local setGoal = _binding[2]\
\9local backgroundTransparency = transparency:map(function(t)\
\9\9return t[1]\
\9end)\
\9local foregroundTransparency = transparency:map(function(t)\
\9\9return t[2]\
\9end)\
\9local highlight = useSpring(if selected then 0.95 else 1, {\
\9\9frequency = 6,\
\9})\
\9local yOffset = useSpring(order * (64 + 4), {\
\9\9frequency = 6,\
\9})\
\9local lastClickTime = useMutable(0)\
\9local openOnDoubleClick = useCallback(function()\
\9\9if not remoteObject then\
\9\9\9return nil\
\9\9end\
\9\9local now = tick()\
\9\9if now - lastClickTime.current > 0.3 then\
\9\9\9lastClickTime.current = now\
\9\9\9return false\
\9\9end\
\9\9lastClickTime.current = now\
\9\9if selectTab(store:getState(), id) == nil then\
\9\9\9local tab = createTabColumn(id, remoteObject.Name, remoteType)\
\9\9\9store:dispatch(pushTab(tab))\
\9\9end\
\9\9store:dispatch(setActiveTab(id))\
\9\9return true\
\9end, { id })\
\9if not remoteObject then\
\9\9return Roact.createFragment()\
\9end\
\9return Roact.createElement(Button, {\
\9\9onClick = function()\
\9\9\9setGoal(ROW_HOVERED)\
\9\9\9local _ = (not openOnDoubleClick() or selected) and onClick()\
\9\9end,\
\9\9onPress = function()\
\9\9\9return setGoal(ROW_PRESSED)\
\9\9end,\
\9\9onHover = function()\
\9\9\9return setGoal(ROW_HOVERED)\
\9\9end,\
\9\9onHoverEnd = function()\
\9\9\9return setGoal(ROW_DEFAULT)\
\9\9end,\
\9\9size = UDim2.new(1, 0, 0, 64),\
\9\9position = yOffset:map(function(y)\
\9\9\9return UDim2.new(0, 0, 0, y)\
\9\9end),\
\9\9transparency = backgroundTransparency,\
\9\9cornerRadius = UDim.new(0, 4),\
\9\9layoutOrder = order,\
\9}, {\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BackgroundColor3 = Color3.new(1, 1, 1),\
\9\9\9BackgroundTransparency = highlight,\
\9\9}, {\
\9\9\9Roact.createElement(\"UICorner\", {\
\9\9\9\9CornerRadius = UDim.new(0, 4),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = if remoteType == TabType.Event then \"rbxassetid://9904941486\" else \"rbxassetid://9904941685\",\
\9\9\9ImageTransparency = foregroundTransparency,\
\9\9\9Size = UDim2.new(0, 24, 0, 24),\
\9\9\9Position = UDim2.new(0, 18, 0, 20),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = formatEscapes(if outgoing and #outgoing > 0 then remoteObject.Name .. (\" • \" .. tostring(#outgoing)) else remoteObject.Name),\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextTransparency = foregroundTransparency,\
\9\9\9TextSize = 13,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Bottom\",\
\9\9\9Size = UDim2.new(1, -100, 0, 12),\
\9\9\9Position = UDim2.new(0, 58, 0, 18),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.9, 0), NumberSequenceKeypoint.new(1, 1) }),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = formatEscapes(getInstancePath(remoteObject)),\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextTransparency = foregroundTransparency:map(function(t)\
\9\9\9\9return multiply(t, 0.2)\
\9\9\9end),\
\9\9\9TextSize = 11,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Top\",\
\9\9\9Size = UDim2.new(1, -100, 0, 12),\
\9\9\9Position = UDim2.new(0, 58, 0, 39),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.9, 0), NumberSequenceKeypoint.new(1, 1) }),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9913448173\",\
\9\9\9ImageTransparency = foregroundTransparency,\
\9\9\9AnchorPoint = Vector2.new(1, 0),\
\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9Position = UDim2.new(1, -18, 0, 24),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9})\
end\
local default = pure(Row)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Home.Row")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Home.Row")) return fn() end)

_module("Logger", "ModuleScript", "RemoteSpy.components.PageGroup.Logger", "RemoteSpy.components.PageGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"Logger\").default\
return exports\
", '@'.."RemoteSpy.components.PageGroup.Logger")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger")) return fn() end)

_module("Header", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Header", "RemoteSpy.components.PageGroup.Logger", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent.Parent, \"Button\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local TabType = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"tab-group\").TabType\
local clearOutgoingSignals = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\").clearOutgoingSignals\
local formatEscapes = TS.import(script, script.Parent.Parent.Parent.Parent, \"utils\", \"format-escapes\").formatEscapes\
local getInstancePath = TS.import(script, script.Parent.Parent.Parent.Parent, \"utils\", \"instance-util\").getInstancePath\
local _remote_log = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\")\
local makeSelectRemoteLogObject = _remote_log.makeSelectRemoteLogObject\
local makeSelectRemoteLogType = _remote_log.makeSelectRemoteLogType\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useMemo = _roact_hooked.useMemo\
local useGroupMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useGroupMotor\
local _use_root_store = TS.import(script, script.Parent.Parent.Parent.Parent, \"hooks\", \"use-root-store\")\
local useRootDispatch = _use_root_store.useRootDispatch\
local useRootSelector = _use_root_store.useRootSelector\
local deleteSprings = {\
\9default = { Spring.new(0.94, {\
\9\9frequency = 6,\
\9}), Spring.new(0, {\
\9\9frequency = 6,\
\9}) },\
\9hovered = { Spring.new(0.9, {\
\9\9frequency = 6,\
\9}), Spring.new(0, {\
\9\9frequency = 6,\
\9}) },\
\9pressed = { Instant.new(0.94), Instant.new(0.2) },\
}\
local captionTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.85, 0), NumberSequenceKeypoint.new(1, 1) })\
local function Header(_param)\
\9local id = _param.id\
\9local dispatch = useRootDispatch()\
\9local selectType = useMemo(makeSelectRemoteLogType, {})\
\9local remoteType = useRootSelector(function(state)\
\9\9return selectType(state, id)\
\9end)\
\9local selectObject = useMemo(makeSelectRemoteLogObject, {})\
\9local remoteObject = useRootSelector(function(state)\
\9\9return selectObject(state, id)\
\9end)\
\9local _binding = useGroupMotor({ 0.94, 0 })\
\9local deleteTransparency = _binding[1]\
\9local setDeleteTransparency = _binding[2]\
\9local deleteButton = useMemo(function()\
\9\9return {\
\9\9\9background = deleteTransparency:map(function(t)\
\9\9\9\9return t[1]\
\9\9\9end),\
\9\9\9foreground = deleteTransparency:map(function(t)\
\9\9\9\9return t[2]\
\9\9\9end),\
\9\9}\
\9end, {})\
\9return Roact.createElement(\"Frame\", {\
\9\9BackgroundColor3 = Color3.new(1, 1, 1),\
\9\9BackgroundTransparency = 0.96,\
\9\9Size = UDim2.new(1, 0, 0, 64),\
\9\9LayoutOrder = -1,\
\9}, {\
\9\9Roact.createElement(\"UICorner\", {\
\9\9\9CornerRadius = UDim.new(0, 4),\
\9\9}),\
\9\9Roact.createElement(Button, {\
\9\9\9onClick = function()\
\9\9\9\9setDeleteTransparency(deleteSprings.hovered)\
\9\9\9\9dispatch(clearOutgoingSignals(id))\
\9\9\9end,\
\9\9\9onPress = function()\
\9\9\9\9return setDeleteTransparency(deleteSprings.pressed)\
\9\9\9end,\
\9\9\9onHover = function()\
\9\9\9\9return setDeleteTransparency(deleteSprings.hovered)\
\9\9\9end,\
\9\9\9onHoverEnd = function()\
\9\9\9\9return setDeleteTransparency(deleteSprings.default)\
\9\9\9end,\
\9\9\9anchorPoint = Vector2.new(1, 0),\
\9\9\9size = UDim2.new(0, 94, 0, 28),\
\9\9\9position = UDim2.new(1, -18, 0, 18),\
\9\9\9transparency = deleteButton.background,\
\9\9\9cornerRadius = UDim.new(0, 4),\
\9\9}, {\
\9\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9\9Text = \"Delete history\",\
\9\9\9\9Font = \"Gotham\",\
\9\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9\9TextTransparency = deleteButton.foreground,\
\9\9\9\9TextSize = 11,\
\9\9\9\9TextXAlignment = \"Center\",\
\9\9\9\9TextYAlignment = \"Center\",\
\9\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9\9BackgroundTransparency = 1,\
\9\9\9}, {\
\9\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9\9Transparency = captionTransparency,\
\9\9\9\9}),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = if remoteType == TabType.Event then \"rbxassetid://9904941486\" else \"rbxassetid://9904941685\",\
\9\9\9Size = UDim2.new(0, 24, 0, 24),\
\9\9\9Position = UDim2.new(0, 18, 0, 20),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = if remoteObject then formatEscapes(remoteObject.Name) else \"Unknown\",\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextSize = 13,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Bottom\",\
\9\9\9Size = UDim2.new(1, -170, 0, 12),\
\9\9\9Position = UDim2.new(0, 58, 0, 18),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9Transparency = captionTransparency,\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = if remoteObject then formatEscapes(getInstancePath(remoteObject)) else \"Unknown\",\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextTransparency = 0.2,\
\9\9\9TextSize = 11,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Top\",\
\9\9\9Size = UDim2.new(1, -170, 0, 12),\
\9\9\9Position = UDim2.new(0, 58, 0, 39),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9Transparency = captionTransparency,\
\9\9\9}),\
\9\9}),\
\9})\
end\
local default = pure(Header)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Header")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Header")) return fn() end)

_module("Logger", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Logger", "RemoteSpy.components.PageGroup.Logger", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent.Parent, \"Container\").default\
local Header = TS.import(script, script.Parent, \"Header\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Row = TS.import(script, script.Parent, \"Row\").default\
local Selection = TS.import(script, script.Parent.Parent.Parent, \"Selection\").default\
local arrayToMap = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).arrayToMap\
local _remote_log = TS.import(script, script.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\")\
local makeSelectRemoteLogOutgoing = _remote_log.makeSelectRemoteLogOutgoing\
local selectSignalIdSelected = _remote_log.selectSignalIdSelected\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useMemo = _roact_hooked.useMemo\
local useRootSelector = TS.import(script, script.Parent.Parent.Parent.Parent, \"hooks\", \"use-root-store\").useRootSelector\
local function Logger(_param)\
\9local id = _param.id\
\9local selectOutgoing = useMemo(makeSelectRemoteLogOutgoing, {})\
\9local outgoing = useRootSelector(function(state)\
\9\9return selectOutgoing(state, id)\
\9end)\
\9local selection = useRootSelector(selectSignalIdSelected)\
\9local selectionOrder = useMemo(function()\
\9\9local _result = outgoing\
\9\9if _result ~= nil then\
\9\9\9local _arg0 = function(signal)\
\9\9\9\9return signal.id == selection\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.findIndex ▼\
\9\9\9local _result_1 = -1\
\9\9\9for _i, _v in ipairs(_result) do\
\9\9\9\9if _arg0(_v, _i - 1, _result) == true then\
\9\9\9\9\9_result_1 = _i - 1\
\9\9\9\9\9break\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.findIndex ▲\
\9\9\9_result = _result_1\
\9\9end\
\9\9local _condition = _result\
\9\9if _condition == nil then\
\9\9\9_condition = -1\
\9\9end\
\9\9return _condition\
\9end, { outgoing, selection })\
\9local _binding = useBinding(0)\
\9local contentHeight = _binding[1]\
\9local setContentHeight = _binding[2]\
\9if not outgoing then\
\9\9return Roact.createFragment()\
\9end\
\9local _attributes = {\
\9\9CanvasSize = contentHeight:map(function(h)\
\9\9\9return UDim2.new(0, 0, 0, h + 48)\
\9\9end),\
\9\9ScrollBarThickness = 0,\
\9\9ScrollBarImageTransparency = 1,\
\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9BorderSizePixel = 0,\
\9\9BackgroundTransparency = 1,\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9PaddingLeft = UDim.new(0, 12),\
\9\9\9PaddingRight = UDim.new(0, 12),\
\9\9\9PaddingTop = UDim.new(0, 12),\
\9\9}),\
\9\9Roact.createElement(Selection, {\
\9\9\9height = 64,\
\9\9\9offset = if selection ~= nil and selectionOrder ~= -1 then (selectionOrder + 1) * (64 + 4) else nil,\
\9\9\9hasSelection = selection ~= nil and selectionOrder ~= -1,\
\9\9}),\
\9}\
\9local _length = #_children\
\9local _children_1 = {\
\9\9Roact.createElement(\"UIListLayout\", {\
\9\9\9[Roact.Change.AbsoluteContentSize] = function(rbx)\
\9\9\9\9return setContentHeight(rbx.AbsoluteContentSize.Y)\
\9\9\9end,\
\9\9\9SortOrder = \"LayoutOrder\",\
\9\9\9FillDirection = \"Vertical\",\
\9\9\9Padding = UDim.new(0, 4),\
\9\9\9VerticalAlignment = \"Top\",\
\9\9}),\
\9\9Roact.createElement(Header, {\
\9\9\9id = id,\
\9\9}),\
\9}\
\9local _length_1 = #_children_1\
\9for _k, _v in pairs(arrayToMap(outgoing, function(signal, order)\
\9\9return { signal.id, Roact.createElement(Row, {\
\9\9\9signal = signal,\
\9\9\9order = order,\
\9\9\9selected = selection == signal.id,\
\9\9}) }\
\9end)) do\
\9\9_children_1[_k] = _v\
\9end\
\9_children[_length + 1] = Roact.createElement(Container, {}, _children_1)\
\9return Roact.createElement(\"ScrollingFrame\", _attributes, _children)\
end\
local default = pure(Logger)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Logger")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Logger")) return fn() end)

_module("Row", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row", "RemoteSpy.components.PageGroup.Logger", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"Row\").default\
return exports\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row")) return fn() end)

_module("Row", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row.Row", "RemoteSpy.components.PageGroup.Logger.Row", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local RowView = TS.import(script, script.Parent, \"RowView\").default\
local Spring = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).Spring\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useEffect = _roact_hooked.useEffect\
local useSingleMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useSingleMotor\
local function Row(_param)\
\9local signal = _param.signal\
\9local order = _param.order\
\9local selected = _param.selected\
\9local _binding = useBinding(0)\
\9local contentHeight = _binding[1]\
\9local setContentHeight = _binding[2]\
\9local _binding_1 = useSingleMotor(0)\
\9local animation = _binding_1[1]\
\9local setGoal = _binding_1[2]\
\9useEffect(function()\
\9\9setGoal(Spring.new(if selected then 1 else 0, {\
\9\9\9frequency = 6,\
\9\9}))\
\9end, { selected })\
\9return Roact.createElement(Container, {\
\9\9order = order,\
\9\9size = Roact.joinBindings({ contentHeight, animation }):map(function(_param_1)\
\9\9\9local y = _param_1[1]\
\9\9\9local a = _param_1[2]\
\9\9\9return UDim2.new(1, 0, 0, 64 + math.round(y * a))\
\9\9end),\
\9\9clipChildren = true,\
\9}, {\
\9\9Roact.createElement(RowView, {\
\9\9\9signal = signal,\
\9\9\9onHeightChange = setContentHeight,\
\9\9\9selected = selected,\
\9\9}),\
\9})\
end\
local default = pure(Row)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row.Row")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row.Row")) return fn() end)

_module("RowBody", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row.RowBody", "RemoteSpy.components.PageGroup.Logger.Row", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local RowCaption = TS.import(script, script.Parent, \"RowCaption\").default\
local RowDoubleCaption = TS.import(script, script.Parent, \"RowDoubleCaption\").default\
local RowLine = TS.import(script, script.Parent, \"RowLine\").default\
local stringifySignalTraceback = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\").stringifySignalTraceback\
local codify = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"codify\").codify\
local _function_util = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"function-util\")\
local describeFunction = _function_util.describeFunction\
local stringifyFunctionSignature = _function_util.stringifyFunctionSignature\
local formatEscapes = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"format-escapes\").formatEscapes\
local getInstancePath = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"instance-util\").getInstancePath\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useMemo = _roact_hooked.useMemo\
local function stringifyTypesAndValues(list)\
\9local types = {}\
\9local values = {}\
\9for index, value in pairs(list) do\
\9\9if index > 12 then\
\9\9\9table.insert(types, \"...\")\
\9\9\9table.insert(values, \"...\")\
\9\9\9break\
\9\9end\
\9\9if typeof(value) == \"Instance\" then\
\9\9\9local _className = value.ClassName\
\9\9\9table.insert(types, _className)\
\9\9else\
\9\9\9local _arg0 = typeof(value)\
\9\9\9table.insert(types, _arg0)\
\9\9end\
\9\9local _arg0 = formatEscapes(string.sub(codify(value, -1), 1, 256))\
\9\9table.insert(values, _arg0)\
\9end\
\9return { types, values }\
end\
local function RowBody(_param)\
\9local signal = _param.signal\
\9local description = useMemo(function()\
\9\9return describeFunction(signal.callback)\
\9end, {})\
\9local tracebackNames = useMemo(function()\
\9\9return stringifySignalTraceback(signal)\
\9end, {})\
\9local _binding = useMemo(function()\
\9\9return stringifyTypesAndValues(signal.parameters)\
\9end, {})\
\9local parameterTypes = _binding[1]\
\9local parameterValues = _binding[2]\
\9local _binding_1 = useMemo(function()\
\9\9return if signal.returns then stringifyTypesAndValues(signal.returns) else { { \"void\" }, { \"void\" } }\
\9end, {})\
\9local returnTypes = _binding_1[1]\
\9local returnValues = _binding_1[2]\
\9local _children = {\
\9\9Roact.createElement(RowLine),\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9AutomaticSize = \"Y\",\
\9\9\9Size = UDim2.new(1, 0, 0, 0),\
\9\9\9BackgroundColor3 = Color3.new(1, 1, 1),\
\9\9\9BackgroundTransparency = 0.98,\
\9\9\9BorderSizePixel = 0,\
\9\9}, {\
\9\9\9Roact.createElement(RowCaption, {\
\9\9\9\9text = \"Remote name\",\
\9\9\9\9description = formatEscapes(signal.name),\
\9\9\9\9wrapped = true,\
\9\9\9}),\
\9\9\9Roact.createElement(RowCaption, {\
\9\9\9\9text = \"Remote location\",\
\9\9\9\9description = formatEscapes(signal.path),\
\9\9\9\9wrapped = true,\
\9\9\9}),\
\9\9\9Roact.createElement(RowCaption, {\
\9\9\9\9text = \"Remote caller\",\
\9\9\9\9description = if signal.caller then formatEscapes(getInstancePath(signal.caller)) else \"No script found\",\
\9\9\9\9wrapped = true,\
\9\9\9}),\
\9\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9\9PaddingLeft = UDim.new(0, 58),\
\9\9\9\9PaddingRight = UDim.new(0, 58),\
\9\9\9\9PaddingTop = UDim.new(0, 6),\
\9\9\9\9PaddingBottom = UDim.new(0, 6),\
\9\9\9}),\
\9\9\9Roact.createElement(\"UIListLayout\", {\
\9\9\9\9FillDirection = \"Vertical\",\
\9\9\9\9Padding = UDim.new(),\
\9\9\9\9VerticalAlignment = \"Top\",\
\9\9\9}),\
\9\9}),\
\9}\
\9local _length = #_children\
\9local _child = #parameterTypes > 0 and (Roact.createFragment({\
\9\9Roact.createElement(RowLine),\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9AutomaticSize = \"Y\",\
\9\9\9Size = UDim2.new(1, 0, 0, 0),\
\9\9\9BackgroundColor3 = Color3.new(1, 1, 1),\
\9\9\9BackgroundTransparency = 0.98,\
\9\9\9BorderSizePixel = 0,\
\9\9}, {\
\9\9\9Roact.createElement(RowDoubleCaption, {\
\9\9\9\9text = \"Parameters\",\
\9\9\9\9hint = table.concat(parameterTypes, \"\\n\"),\
\9\9\9\9description = table.concat(parameterValues, \"\\n\"),\
\9\9\9}),\
\9\9\9returnTypes and (Roact.createElement(RowDoubleCaption, {\
\9\9\9\9text = \"Returns\",\
\9\9\9\9hint = table.concat(returnTypes, \"\\n\"),\
\9\9\9\9description = table.concat(returnValues, \"\\n\"),\
\9\9\9})),\
\9\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9\9PaddingLeft = UDim.new(0, 58),\
\9\9\9\9PaddingRight = UDim.new(0, 58),\
\9\9\9\9PaddingTop = UDim.new(0, 6),\
\9\9\9\9PaddingBottom = UDim.new(0, 6),\
\9\9\9}),\
\9\9\9Roact.createElement(\"UIListLayout\", {\
\9\9\9\9FillDirection = \"Vertical\",\
\9\9\9\9Padding = UDim.new(),\
\9\9\9\9VerticalAlignment = \"Top\",\
\9\9\9}),\
\9\9}),\
\9}))\
\9if _child then\
\9\9_children[_length + 1] = _child\
\9end\
\9_length = #_children\
\9_children[_length + 1] = Roact.createElement(RowLine)\
\9_children[_length + 2] = Roact.createElement(\"ImageLabel\", {\
\9\9AutomaticSize = \"Y\",\
\9\9Image = \"rbxassetid://9913871236\",\
\9\9ImageColor3 = Color3.new(1, 1, 1),\
\9\9ImageTransparency = 0.98,\
\9\9ScaleType = \"Slice\",\
\9\9SliceCenter = Rect.new(4, 4, 4, 4),\
\9\9Size = UDim2.new(1, 0, 0, 0),\
\9\9BackgroundTransparency = 1,\
\9}, {\
\9\9Roact.createElement(RowCaption, {\
\9\9\9text = \"Signature\",\
\9\9\9description = stringifyFunctionSignature(signal.callback),\
\9\9\9wrapped = true,\
\9\9}),\
\9\9Roact.createElement(RowCaption, {\
\9\9\9text = \"Source\",\
\9\9\9description = description.source,\
\9\9\9wrapped = true,\
\9\9}),\
\9\9Roact.createElement(RowCaption, {\
\9\9\9text = \"Traceback\",\
\9\9\9wrapped = true,\
\9\9\9description = table.concat(tracebackNames, \"\\n\"),\
\9\9}),\
\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9PaddingLeft = UDim.new(0, 58),\
\9\9\9PaddingRight = UDim.new(0, 58),\
\9\9\9PaddingTop = UDim.new(0, 6),\
\9\9\9PaddingBottom = UDim.new(0, 6),\
\9\9}),\
\9\9Roact.createElement(\"UIListLayout\", {\
\9\9\9FillDirection = \"Vertical\",\
\9\9\9Padding = UDim.new(),\
\9\9\9VerticalAlignment = \"Top\",\
\9\9}),\
\9})\
\9return Roact.createFragment(_children)\
end\
local default = pure(RowBody)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row.RowBody")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row.RowBody")) return fn() end)

_module("RowCaption", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row.RowCaption", "RemoteSpy.components.PageGroup.Logger.Row", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function RowCaption(_param)\
\9local text = _param.text\
\9local description = _param.description\
\9local wrapped = _param.wrapped\
\9local richText = _param.richText\
\9return Roact.createElement(\"TextLabel\", {\
\9\9Text = text,\
\9\9Font = \"Gotham\",\
\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9TextSize = 11,\
\9\9AutomaticSize = \"Y\",\
\9\9Size = UDim2.new(1, 50, 0, 23),\
\9\9TextXAlignment = \"Left\",\
\9\9TextYAlignment = \"Top\",\
\9\9BackgroundTransparency = 1,\
\9}, {\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9RichText = richText,\
\9\9\9Text = description,\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextSize = 11,\
\9\9\9TextTransparency = 0.3,\
\9\9\9TextWrapped = wrapped,\
\9\9\9AutomaticSize = \"Y\",\
\9\9\9Size = UDim2.new(1, -114, 0, 0),\
\9\9\9Position = UDim2.new(0, 114, 0, 0),\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Top\",\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9\9PaddingBottom = UDim.new(0, 6),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9PaddingTop = UDim.new(0, 4),\
\9\9}),\
\9})\
end\
return {\
\9default = RowCaption,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row.RowCaption")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row.RowCaption")) return fn() end)

_module("RowDoubleCaption", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row.RowDoubleCaption", "RemoteSpy.components.PageGroup.Logger.Row", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function RowDoubleCaption(_param)\
\9local text = _param.text\
\9local hint = _param.hint\
\9local description = _param.description\
\9return Roact.createElement(\"TextLabel\", {\
\9\9Text = text,\
\9\9Font = \"Gotham\",\
\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9TextSize = 11,\
\9\9AutomaticSize = \"Y\",\
\9\9Size = UDim2.new(1, 0, 0, 23),\
\9\9TextXAlignment = \"Left\",\
\9\9TextYAlignment = \"Top\",\
\9\9BackgroundTransparency = 1,\
\9}, {\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = hint,\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextSize = 11,\
\9\9\9TextTransparency = 0.5,\
\9\9\9AutomaticSize = \"Y\",\
\9\9\9Size = UDim2.new(1, -114, 0, 0),\
\9\9\9Position = UDim2.new(0, 114, 0, 0),\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Top\",\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9\9PaddingBottom = UDim.new(0, 6),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = description,\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextSize = 11,\
\9\9\9TextTransparency = 0.3,\
\9\9\9AutomaticSize = \"Y\",\
\9\9\9Size = UDim2.new(1, -114 - 100, 0, 0),\
\9\9\9Position = UDim2.new(0, 114 + 100, 0, 0),\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Top\",\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9\9PaddingBottom = UDim.new(0, 6),\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9PaddingTop = UDim.new(0, 4),\
\9\9}),\
\9})\
end\
return {\
\9default = RowDoubleCaption,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row.RowDoubleCaption")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row.RowDoubleCaption")) return fn() end)

_module("RowHeader", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row.RowHeader", "RemoteSpy.components.PageGroup.Logger.Row", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent.Parent.Parent, \"Button\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local formatEscapes = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"format-escapes\").formatEscapes\
local getInstancePath = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"instance-util\").getInstancePath\
local multiply = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"number-util\").multiply\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local stringifyFunctionSignature = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"utils\", \"function-util\").stringifyFunctionSignature\
local useGroupMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useGroupMotor\
local rowSprings = {\
\9default = { Spring.new(0.97, {\
\9\9frequency = 6,\
\9}), Spring.new(0, {\
\9\9frequency = 6,\
\9}) },\
\9defaultOpen = { Spring.new(0.96, {\
\9\9frequency = 6,\
\9}), Spring.new(0, {\
\9\9frequency = 6,\
\9}) },\
\9hovered = { Spring.new(0.93, {\
\9\9frequency = 6,\
\9}), Spring.new(0, {\
\9\9frequency = 6,\
\9}) },\
\9pressed = { Instant.new(0.98), Instant.new(0.2) },\
}\
local captionTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.9, 0), NumberSequenceKeypoint.new(1, 1) })\
local function RowHeader(_param)\
\9local signal = _param.signal\
\9local open = _param.open\
\9local onClick = _param.onClick\
\9local _binding = useGroupMotor({ 0.97, 0 })\
\9local rowTransparency = _binding[1]\
\9local setRowTransparency = _binding[2]\
\9local rowButton = {\
\9\9background = rowTransparency:map(function(t)\
\9\9\9return t[1]\
\9\9end),\
\9\9foreground = rowTransparency:map(function(t)\
\9\9\9return t[2]\
\9\9end),\
\9}\
\9return Roact.createElement(Button, {\
\9\9onClick = function()\
\9\9\9setRowTransparency(rowSprings.hovered)\
\9\9\9onClick()\
\9\9end,\
\9\9onPress = function()\
\9\9\9return setRowTransparency(rowSprings.pressed)\
\9\9end,\
\9\9onHover = function()\
\9\9\9return setRowTransparency(rowSprings.hovered)\
\9\9end,\
\9\9onHoverEnd = function()\
\9\9\9return setRowTransparency(if open then rowSprings.defaultOpen else rowSprings.default)\
\9\9end,\
\9\9size = UDim2.new(1, 0, 0, 64),\
\9}, {\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = if open then \"rbxassetid://9913260292\" else \"rbxassetid://9913260388\",\
\9\9\9ImageColor3 = Color3.new(1, 1, 1),\
\9\9\9ImageTransparency = rowButton.background,\
\9\9\9ScaleType = \"Slice\",\
\9\9\9SliceCenter = Rect.new(4, 4, 4, 4),\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9913356706\",\
\9\9\9ImageTransparency = rowButton.foreground,\
\9\9\9Size = UDim2.new(0, 24, 0, 24),\
\9\9\9Position = UDim2.new(0, 18, 0, 20),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = (if signal.caller then formatEscapes(signal.caller.Name) else \"No script\") .. (\" • \" .. stringifyFunctionSignature(signal.callback)),\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextTransparency = rowButton.foreground,\
\9\9\9TextSize = 13,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Bottom\",\
\9\9\9Size = UDim2.new(1, -100, 0, 12),\
\9\9\9Position = UDim2.new(0, 58, 0, 18),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9Transparency = captionTransparency,\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = if signal.caller then formatEscapes(getInstancePath(signal.caller)) else \"Not called from a script\",\
\9\9\9Font = \"Gotham\",\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9TextTransparency = rowButton.foreground:map(function(t)\
\9\9\9\9return multiply(t, 0.2)\
\9\9\9end),\
\9\9\9TextSize = 11,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Top\",\
\9\9\9Size = UDim2.new(1, -100, 0, 12),\
\9\9\9Position = UDim2.new(0, 58, 0, 39),\
\9\9\9BackgroundTransparency = 1,\
\9\9}, {\
\9\9\9Roact.createElement(\"UIGradient\", {\
\9\9\9\9Transparency = captionTransparency,\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = if open then \"rbxassetid://9913448536\" else \"rbxassetid://9913448364\",\
\9\9\9ImageTransparency = rowButton.foreground,\
\9\9\9AnchorPoint = Vector2.new(1, 0),\
\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9Position = UDim2.new(1, -18, 0, 24),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9})\
end\
local default = pure(RowHeader)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row.RowHeader")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row.RowHeader")) return fn() end)

_module("RowLine", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row.RowLine", "RemoteSpy.components.PageGroup.Logger.Row", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function RowLine()\
\9return Roact.createElement(\"Frame\", {\
\9\9Size = UDim2.new(1, 0, 0, 1),\
\9\9BackgroundColor3 = Color3.new(),\
\9\9BackgroundTransparency = 0.85,\
\9\9BorderSizePixel = 0,\
\9})\
end\
return {\
\9default = RowLine,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row.RowLine")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row.RowLine")) return fn() end)

_module("RowView", "ModuleScript", "RemoteSpy.components.PageGroup.Logger.Row.RowView", "RemoteSpy.components.PageGroup.Logger.Row", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local RowBody = TS.import(script, script.Parent, \"RowBody\").default\
local RowHeader = TS.import(script, script.Parent, \"RowHeader\").default\
local toggleSignalSelected = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"reducers\", \"remote-log\").toggleSignalSelected\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useCallback = _roact_hooked.useCallback\
local useRootDispatch = TS.import(script, script.Parent.Parent.Parent.Parent.Parent, \"hooks\", \"use-root-store\").useRootDispatch\
local function RowView(_param)\
\9local signal = _param.signal\
\9local selected = _param.selected\
\9local onHeightChange = _param.onHeightChange\
\9local dispatch = useRootDispatch()\
\9local _binding = useBinding(0)\
\9local contentHeight = _binding[1]\
\9local setContentHeight = _binding[2]\
\9local toggle = useCallback(function()\
\9\9return dispatch(toggleSignalSelected(signal.remoteId, signal.id))\
\9end, {})\
\9local _children = {\
\9\9Roact.createElement(RowHeader, {\
\9\9\9signal = signal,\
\9\9\9open = selected,\
\9\9\9onClick = toggle,\
\9\9}),\
\9}\
\9local _length = #_children\
\9local _attributes = {\
\9\9clipChildren = true,\
\9\9size = contentHeight:map(function(y)\
\9\9\9return UDim2.new(1, 0, 0, y)\
\9\9end),\
\9\9position = UDim2.new(0, 0, 0, 64),\
\9}\
\9local _children_1 = {\
\9\9Roact.createElement(\"UIListLayout\", {\
\9\9\9[Roact.Change.AbsoluteContentSize] = function(_param_1)\
\9\9\9\9local AbsoluteContentSize = _param_1.AbsoluteContentSize\
\9\9\9\9setContentHeight(AbsoluteContentSize.Y)\
\9\9\9\9onHeightChange(AbsoluteContentSize.Y)\
\9\9\9end,\
\9\9\9SortOrder = \"LayoutOrder\",\
\9\9\9FillDirection = \"Vertical\",\
\9\9\9Padding = UDim.new(),\
\9\9\9VerticalAlignment = \"Top\",\
\9\9}),\
\9}\
\9local _length_1 = #_children_1\
\9local _child = selected and Roact.createElement(RowBody, {\
\9\9signal = signal,\
\9})\
\9if _child then\
\9\9_children_1[_length_1 + 1] = _child\
\9end\
\9_children[_length + 1] = Roact.createElement(Container, _attributes, _children_1)\
\9return Roact.createFragment(_children)\
end\
local default = pure(RowView)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Logger.Row.RowView")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Logger.Row.RowView")) return fn() end)

_module("Page", "ModuleScript", "RemoteSpy.components.PageGroup.Page", "RemoteSpy.components.PageGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Home = TS.import(script, script.Parent, \"Home\").default\
local Logger = TS.import(script, script.Parent, \"Logger\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Script = TS.import(script, script.Parent, \"Script\").default\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local _tab_group = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"tab-group\")\
local TabType = _tab_group.TabType\
local selectActiveTabId = _tab_group.selectActiveTabId\
local selectActiveTabOrder = _tab_group.selectActiveTabOrder\
local selectTabOrder = _tab_group.selectTabOrder\
local selectTabType = _tab_group.selectTabType\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useEffect = _roact_hooked.useEffect\
local useMutable = _roact_hooked.useMutable\
local useRootSelector = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-root-store\").useRootSelector\
local useSingleMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useSingleMotor\
local function Page(_param)\
\9local id = _param.id\
\9local tabType = useRootSelector(function(state)\
\9\9return selectTabType(state, id)\
\9end)\
\9local tabOrder = useRootSelector(function(state)\
\9\9return selectTabOrder(state, id)\
\9end)\
\9local activeTabOrder = useRootSelector(selectActiveTabOrder)\
\9local activeTabId = useRootSelector(selectActiveTabId)\
\9local lastActiveTabId = useMutable(\"\")\
\9local targetSide = if tabOrder < activeTabOrder then -1 elseif tabOrder > activeTabOrder then 1 else 0\
\9local _binding = useSingleMotor(if targetSide == 0 then 1 else targetSide)\
\9local side = _binding[1]\
\9local setSide = _binding[2]\
\9useEffect(function()\
\9\9local isOrWasActive = id == activeTabId or id == lastActiveTabId.current\
\9\9local activeTabChanged = activeTabId ~= lastActiveTabId.current\
\9\9if isOrWasActive and activeTabChanged then\
\9\9\9setSide(Spring.new(targetSide))\
\9\9else\
\9\9\9setSide(Instant.new(targetSide))\
\9\9end\
\9end, { targetSide })\
\9useEffect(function()\
\9\9lastActiveTabId.current = activeTabId\
\9end)\
\9local _attributes = {\
\9\9position = side:map(function(s)\
\9\9\9return UDim2.new(s, 0, 0, 0)\
\9\9end),\
\9}\
\9local _children = {}\
\9local _length = #_children\
\9local _child = if tabType == TabType.Event or tabType == TabType.Function then (Roact.createElement(Logger, {\
\9\9id = id,\
\9})) elseif tabType == TabType.Home then (Roact.createElement(Home, {\
\9\9pageSelected = activeTabId == id,\
\9})) elseif tabType == TabType.Script then (Roact.createElement(Script)) else nil\
\9if _child then\
\9\9_children[_length + 1] = _child\
\9end\
\9return Roact.createElement(Container, _attributes, _children)\
end\
local default = pure(Page)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Page")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Page")) return fn() end)

_module("PageGroup", "ModuleScript", "RemoteSpy.components.PageGroup.PageGroup", "RemoteSpy.components.PageGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Page = TS.import(script, script.Parent, \"Page\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local SIDE_PANEL_WIDTH = TS.import(script, script.Parent.Parent.Parent, \"constants\").SIDE_PANEL_WIDTH\
local arrayToMap = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).arrayToMap\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local useTabs = TS.import(script, script.Parent.Parent, \"TabGroup\").useTabs\
local function PageGroup()\
\9local tabs = useTabs()\
\9local _attributes = {\
\9\9BackgroundTransparency = 0.96,\
\9\9BackgroundColor3 = Color3.fromHex(\"#FFFFFF\"),\
\9\9Size = UDim2.new(1, -SIDE_PANEL_WIDTH - 5, 1, -129),\
\9\9Position = UDim2.new(0, 5, 0, 124),\
\9\9ClipsDescendants = true,\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"UICorner\", {\
\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9}),\
\9}\
\9local _length = #_children\
\9for _k, _v in pairs(arrayToMap(tabs, function(tab)\
\9\9return { tab.id, Roact.createElement(Page, {\
\9\9\9id = tab.id,\
\9\9}) }\
\9end)) do\
\9\9_children[_k] = _v\
\9end\
\9return Roact.createElement(\"Frame\", _attributes, _children)\
end\
local default = pure(PageGroup)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.PageGroup")) setfenv(fn, _env("RemoteSpy.components.PageGroup.PageGroup")) return fn() end)

_module("Script", "ModuleScript", "RemoteSpy.components.PageGroup.Script", "RemoteSpy.components.PageGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"Script\").default\
return exports\
", '@'.."RemoteSpy.components.PageGroup.Script")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Script")) return fn() end)

_module("Script", "ModuleScript", "RemoteSpy.components.PageGroup.Script.Script", "RemoteSpy.components.PageGroup.Script", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local function Script()\
\9return Roact.createElement(Container, {}, {\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = \"Script page\",\
\9\9\9TextSize = 30,\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9})\
end\
local default = pure(Script)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.PageGroup.Script.Script")) setfenv(fn, _env("RemoteSpy.components.PageGroup.Script.Script")) return fn() end)

_module("Root", "ModuleScript", "RemoteSpy.components.Root", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local DISPLAY_ORDER = TS.import(script, script.Parent.Parent, \"constants\").DISPLAY_ORDER\
local Players = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).Players\
local function hasCoreAccess()\
\9local _arg0 = function()\
\9\9return game:GetService(\"CoreGui\").Name\
\9end\
\9local _success, _valueOrError = pcall(_arg0)\
\9return (_success and {\
\9\9success = true,\
\9\9value = _valueOrError,\
\9} or {\
\9\9success = false,\
\9\9error = _valueOrError,\
\9}).success\
end\
local function getTarget()\
\9if gethui then\
\9\9return gethui()\
\9end\
\9if hasCoreAccess() then\
\9\9return game:GetService(\"CoreGui\")\
\9end\
\9return Players.LocalPlayer:WaitForChild(\"PlayerGui\")\
end\
local function Root(_param)\
\9local displayOrder = _param.displayOrder\
\9if displayOrder == nil then\
\9\9displayOrder = 0\
\9end\
\9local children = _param[Roact.Children]\
\9local _attributes = {\
\9\9target = getTarget(),\
\9}\
\9local _children = {}\
\9local _length = #_children\
\9local _attributes_1 = {\
\9\9IgnoreGuiInset = true,\
\9\9ResetOnSpawn = false,\
\9\9ZIndexBehavior = \"Sibling\",\
\9\9DisplayOrder = DISPLAY_ORDER + displayOrder,\
\9}\
\9local _children_1 = {}\
\9local _length_1 = #_children_1\
\9if children then\
\9\9for _k, _v in pairs(children) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_children_1[_length_1 + _k] = _v\
\9\9\9else\
\9\9\9\9_children_1[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9_children[_length + 1] = Roact.createElement(\"ScreenGui\", _attributes_1, _children_1)\
\9return Roact.createElement(Roact.Portal, _attributes, _children)\
end\
return {\
\9default = Root,\
}\
", '@'.."RemoteSpy.components.Root")) setfenv(fn, _env("RemoteSpy.components.Root")) return fn() end)

_module("Selection", "ModuleScript", "RemoteSpy.components.Selection", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Linear = _flipper.Linear\
local Spring = _flipper.Spring\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useEffect = _roact_hooked.useEffect\
local _roact_hooked_plus = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out)\
local useSingleMotor = _roact_hooked_plus.useSingleMotor\
local useSpring = _roact_hooked_plus.useSpring\
local function Selection(_param)\
\9local height = _param.height\
\9local offset = _param.offset\
\9local hasSelection = _param.hasSelection\
\9local _binding = useSingleMotor(-100)\
\9local offsetAnim = _binding[1]\
\9local setOffsetGoal = _binding[2]\
\9local offsetSpring = _binding[3]\
\9local _binding_1 = useSingleMotor(0)\
\9local speedAnim = _binding_1[1]\
\9local setSpeedGoal = _binding_1[2]\
\9local heightAnim = useSpring(if hasSelection then 20 else 0, {\
\9\9frequency = 8,\
\9})\
\9useEffect(function()\
\9\9if offset ~= nil then\
\9\9\9setOffsetGoal(Spring.new(offset, {\
\9\9\9\9frequency = 5,\
\9\9\9}))\
\9\9end\
\9end, { offset })\
\9useEffect(function()\
\9\9if hasSelection and offset ~= nil then\
\9\9\9setOffsetGoal(Instant.new(offset))\
\9\9end\
\9end, { hasSelection })\
\9useEffect(function()\
\9\9if not hasSelection then\
\9\9\9setSpeedGoal(Instant.new(0))\
\9\9\9return nil\
\9\9end\
\9\9local lastValue = offset\
\9\9local lastTime = 0\
\9\9local handle = offsetSpring:onStep(function(value)\
\9\9\9local now = tick()\
\9\9\9local deltaTime = now - lastTime\
\9\9\9if lastValue ~= nil then\
\9\9\9\9setSpeedGoal(Linear.new(math.abs(value - lastValue) / (deltaTime * 60), {\
\9\9\9\9\9velocity = 300,\
\9\9\9\9}))\
\9\9\9\9lastValue = value\
\9\9\9end\
\9\9\9lastTime = now\
\9\9end)\
\9\9return function()\
\9\9\9return handle:disconnect()\
\9\9end\
\9end, { hasSelection })\
\9return Roact.createElement(Container, {\
\9\9size = UDim2.new(0, 4, 0, height),\
\9\9position = offsetAnim:map(function(y)\
\9\9\9return UDim2.new(0, 0, 0, math.round(y))\
\9\9end),\
\9}, {\
\9\9Roact.createElement(\"Frame\", {\
\9\9\9AnchorPoint = Vector2.new(0, 0.5),\
\9\9\9Size = Roact.joinBindings({ heightAnim, speedAnim }):map(function(_param_1)\
\9\9\9\9local h = _param_1[1]\
\9\9\9\9local s = _param_1[2]\
\9\9\9\9return UDim2.new(0, 4, 0, math.round(h + s * 1.7))\
\9\9\9end),\
\9\9\9Position = UDim2.new(0, 0, 0.5, 0),\
\9\9\9BackgroundColor3 = Color3.fromHex(\"#4CC2FF\"),\
\9\9}, {\
\9\9\9Roact.createElement(\"UICorner\", {\
\9\9\9\9CornerRadius = UDim.new(0, 2),\
\9\9\9}),\
\9\9}),\
\9})\
end\
local default = pure(Selection)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.Selection")) setfenv(fn, _env("RemoteSpy.components.Selection")) return fn() end)

_module("SidePanel", "ModuleScript", "RemoteSpy.components.SidePanel", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
local SidePanel = TS.import(script, script, \"SidePanel\").default\
local TitleBar = TS.import(script, script, \"TitleBar\").default\
for _k, _v in pairs(TS.import(script, script, \"use-side-panel-context\") or {}) do\
\9exports[_k] = _v\
end\
local default = {\
\9Root = SidePanel,\
\9TitleBar = TitleBar,\
}\
exports.default = default\
return exports\
", '@'.."RemoteSpy.components.SidePanel")) setfenv(fn, _env("RemoteSpy.components.SidePanel")) return fn() end)

_module("SidePanel", "ModuleScript", "RemoteSpy.components.SidePanel.SidePanel", "RemoteSpy.components.SidePanel", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local SIDE_PANEL_WIDTH = TS.import(script, script.Parent.Parent.Parent, \"constants\").SIDE_PANEL_WIDTH\
local SidePanelContext = TS.import(script, script.Parent, \"use-side-panel-context\").SidePanelContext\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useMemo = _roact_hooked.useMemo\
local useState = _roact_hooked.useState\
local useSpring = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useSpring\
local MIN_PANEL_HEIGHT = 40\
local function SidePanel(_param)\
\9local children = _param[Roact.Children]\
\9local _binding = useBinding(200)\
\9local lowerHeight = _binding[1]\
\9local setLowerHeight = _binding[2]\
\9local _binding_1 = useState(false)\
\9local lowerHidden = _binding_1[1]\
\9local setLowerHidden = _binding_1[2]\
\9local _binding_2 = useState(false)\
\9local upperHidden = _binding_2[1]\
\9local setUpperHidden = _binding_2[2]\
\9local lowerAnim = useSpring(if lowerHidden then 1 else 0, {\
\9\9frequency = 8,\
\9})\
\9local upperAnim = useSpring(if upperHidden then 1 else 0, {\
\9\9frequency = 8,\
\9})\
\9local lowerSize = useMemo(function()\
\9\9return Roact.joinBindings({ lowerHeight, lowerAnim, upperAnim }):map(function(_param_1)\
\9\9\9local height = _param_1[1]\
\9\9\9local n = _param_1[2]\
\9\9\9local ftn = _param_1[3]\
\9\9\9local lowerShown = UDim2.new(1, 0, 0, height)\
\9\9\9local lowerHidden = UDim2.new(1, 0, 0, MIN_PANEL_HEIGHT)\
\9\9\9local upperHidden = UDim2.new(1, 0, 1, -MIN_PANEL_HEIGHT)\
\9\9\9return lowerShown:Lerp(upperHidden, ftn):Lerp(lowerHidden, n)\
\9\9end)\
\9end, {})\
\9local lowerPosition = useMemo(function()\
\9\9return Roact.joinBindings({ lowerHeight, lowerAnim, upperAnim }):map(function(_param_1)\
\9\9\9local height = _param_1[1]\
\9\9\9local n = _param_1[2]\
\9\9\9local ftn = _param_1[3]\
\9\9\9local lowerShown = UDim2.new(0, 0, 1, -height)\
\9\9\9local lowerHidden = UDim2.new(0, 0, 1, -MIN_PANEL_HEIGHT)\
\9\9\9local upperHidden = UDim2.new(0, 0, 0, MIN_PANEL_HEIGHT)\
\9\9\9return lowerShown:Lerp(lowerHidden, n):Lerp(upperHidden, ftn)\
\9\9end)\
\9end, {})\
\9local upperSize = useMemo(function()\
\9\9return Roact.joinBindings({ lowerHeight, upperAnim, lowerAnim }):map(function(_param_1)\
\9\9\9local height = _param_1[1]\
\9\9\9local n = _param_1[2]\
\9\9\9local tn = _param_1[3]\
\9\9\9local upperShown = UDim2.new(1, 0, 1, -height)\
\9\9\9local upperHidden = UDim2.new(1, 0, 0, MIN_PANEL_HEIGHT)\
\9\9\9local lowerHidden = UDim2.new(1, 0, 1, -MIN_PANEL_HEIGHT)\
\9\9\9return upperShown:Lerp(lowerHidden, tn):Lerp(upperHidden, n)\
\9\9end)\
\9end, {})\
\9local _attributes = {\
\9\9value = {\
\9\9\9upperHidden = upperHidden,\
\9\9\9upperSize = upperSize,\
\9\9\9setUpperHidden = setUpperHidden,\
\9\9\9lowerHidden = lowerHidden,\
\9\9\9lowerSize = lowerSize,\
\9\9\9lowerPosition = lowerPosition,\
\9\9\9setLowerHidden = setLowerHidden,\
\9\9\9setLowerHeight = setLowerHeight,\
\9\9},\
\9}\
\9local _children = {}\
\9local _length = #_children\
\9local _attributes_1 = {\
\9\9anchorPoint = Vector2.new(1, 0),\
\9\9size = UDim2.new(0, SIDE_PANEL_WIDTH, 1, -84),\
\9\9position = UDim2.new(1, 0, 0, 84),\
\9}\
\9local _children_1 = {}\
\9local _length_1 = #_children_1\
\9if children then\
\9\9for _k, _v in pairs(children) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_children_1[_length_1 + _k] = _v\
\9\9\9else\
\9\9\9\9_children_1[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9_children[_length + 1] = Roact.createElement(Container, _attributes_1, _children_1)\
\9return Roact.createElement(SidePanelContext.Provider, _attributes, _children)\
end\
local default = pure(SidePanel)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.SidePanel.SidePanel")) setfenv(fn, _env("RemoteSpy.components.SidePanel.SidePanel")) return fn() end)

_module("TitleBar", "ModuleScript", "RemoteSpy.components.SidePanel.TitleBar", "RemoteSpy.components.SidePanel", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent, \"Button\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local useGroupMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useGroupMotor\
local CHEVRON_DEFAULT = { Spring.new(1, {\
\9frequency = 6,\
}), Spring.new(0, {\
\9frequency = 6,\
}) }\
local CHEVRON_HOVERED = { Spring.new(0.95, {\
\9frequency = 6,\
}), Spring.new(0, {\
\9frequency = 6,\
}) }\
local CHEVRON_PRESSED = { Instant.new(0.97), Instant.new(0.2) }\
local function TitleBar(_param)\
\9local caption = _param.caption\
\9local hidden = _param.hidden\
\9local toggleHidden = _param.toggleHidden\
\9local _binding = useGroupMotor({ 1, 0 })\
\9local chevronTransparency = _binding[1]\
\9local setChevronGoal = _binding[2]\
\9local chevronBackgroundTransparency = chevronTransparency:map(function(t)\
\9\9return t[1]\
\9end)\
\9local chevronForegroundTransparency = chevronTransparency:map(function(t)\
\9\9return t[2]\
\9end)\
\9return Roact.createFragment({\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9Text = caption,\
\9\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9\9Font = \"GothamBold\",\
\9\9\9TextSize = 11,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Top\",\
\9\9\9Size = UDim2.new(1, -24, 0, 20),\
\9\9\9Position = UDim2.new(0, 12, 0, 14),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(Button, {\
\9\9\9onClick = function()\
\9\9\9\9setChevronGoal(CHEVRON_HOVERED)\
\9\9\9\9toggleHidden()\
\9\9\9end,\
\9\9\9onPress = function()\
\9\9\9\9return setChevronGoal(CHEVRON_PRESSED)\
\9\9\9end,\
\9\9\9onHover = function()\
\9\9\9\9return setChevronGoal(CHEVRON_HOVERED)\
\9\9\9end,\
\9\9\9onHoverEnd = function()\
\9\9\9\9return setChevronGoal(CHEVRON_DEFAULT)\
\9\9\9end,\
\9\9\9transparency = chevronBackgroundTransparency,\
\9\9\9size = UDim2.new(0, 24, 0, 24),\
\9\9\9position = UDim2.new(1, -8, 0, 8),\
\9\9\9anchorPoint = Vector2.new(1, 0),\
\9\9\9cornerRadius = UDim.new(0, 4),\
\9\9}, {\
\9\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9\9Image = if hidden then \"rbxassetid://9888526164\" else \"rbxassetid://9888526348\",\
\9\9\9\9ImageTransparency = chevronForegroundTransparency,\
\9\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9\9Position = UDim2.new(0, 4, 0, 4),\
\9\9\9\9BackgroundTransparency = 1,\
\9\9\9}),\
\9\9}),\
\9})\
end\
local default = pure(TitleBar)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.SidePanel.TitleBar")) setfenv(fn, _env("RemoteSpy.components.SidePanel.TitleBar")) return fn() end)

_module("use-side-panel-context", "ModuleScript", "RemoteSpy.components.SidePanel.use-side-panel-context", "RemoteSpy.components.SidePanel", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local useContext = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useContext\
local SidePanelContext = Roact.createContext(nil)\
local function useSidePanelContext()\
\9return useContext(SidePanelContext)\
end\
return {\
\9useSidePanelContext = useSidePanelContext,\
\9SidePanelContext = SidePanelContext,\
}\
", '@'.."RemoteSpy.components.SidePanel.use-side-panel-context")) setfenv(fn, _env("RemoteSpy.components.SidePanel.use-side-panel-context")) return fn() end)

_module("TabGroup", "ModuleScript", "RemoteSpy.components.TabGroup", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
for _k, _v in pairs(TS.import(script, script, \"use-tab-group\") or {}) do\
\9exports[_k] = _v\
end\
exports.default = TS.import(script, script, \"TabGroup\").default\
return exports\
", '@'.."RemoteSpy.components.TabGroup")) setfenv(fn, _env("RemoteSpy.components.TabGroup")) return fn() end)

_module("TabColumn", "ModuleScript", "RemoteSpy.components.TabGroup.TabColumn", "RemoteSpy.components.TabGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent, \"Button\").default\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local _tab_group = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"tab-group\")\
local MAX_TAB_CAPTION_WIDTH = _tab_group.MAX_TAB_CAPTION_WIDTH\
local deleteTab = _tab_group.deleteTab\
local getTabCaptionWidth = _tab_group.getTabCaptionWidth\
local getTabWidth = _tab_group.getTabWidth\
local _services = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\"))\
local RunService = _services.RunService\
local UserInputService = _services.UserInputService\
local formatEscapes = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"format-escapes\").formatEscapes\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local useState = _roact_hooked.useState\
local tabIcons = TS.import(script, script.Parent, \"constants\").tabIcons\
local _use_tab_group = TS.import(script, script.Parent, \"use-tab-group\")\
local useDeleteTab = _use_tab_group.useDeleteTab\
local useMoveTab = _use_tab_group.useMoveTab\
local useSetActiveTab = _use_tab_group.useSetActiveTab\
local useTabIsActive = _use_tab_group.useTabIsActive\
local useTabOffset = _use_tab_group.useTabOffset\
local useTabWidth = _use_tab_group.useTabWidth\
local useRootStore = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-root-store\").useRootStore\
local _roact_hooked_plus = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out)\
local useSingleMotor = _roact_hooked_plus.useSingleMotor\
local useSpring = _roact_hooked_plus.useSpring\
local FOREGROUND_ACTIVE = Instant.new(0)\
local FOREGROUND_DEFAULT = Spring.new(0.4, {\
\9frequency = 6,\
})\
local FOREGROUND_HOVERED = Spring.new(0.2, {\
\9frequency = 6,\
})\
local CLOSE_DEFAULT = Spring.new(1, {\
\9frequency = 6,\
})\
local CLOSE_HOVERED = Spring.new(0.9, {\
\9frequency = 6,\
})\
local CLOSE_PRESSED = Instant.new(0.94)\
local function TabColumn(_param)\
\9local tab = _param.tab\
\9local canvasPosition = _param.canvasPosition\
\9local store = useRootStore()\
\9local active = useTabIsActive(tab.id)\
\9local width = useTabWidth(tab)\
\9local offset = useTabOffset(tab.id)\
\9local captionWidth = useMemo(function()\
\9\9return getTabCaptionWidth(tab)\
\9end, { tab })\
\9local activate = useSetActiveTab(tab.id)\
\9local move = useMoveTab(tab.id)\
\9local close = useDeleteTab(tab.id)\
\9local _binding = useSingleMotor(if active then 0 else 0.4)\
\9local foreground = _binding[1]\
\9local setForeground = _binding[2]\
\9local _binding_1 = useSingleMotor(1)\
\9local closeBackground = _binding_1[1]\
\9local setCloseBackground = _binding_1[2]\
\9local offsetAnim = useSpring(offset, {\
\9\9frequency = 30,\
\9\9dampingRatio = 3,\
\9})\
\9useEffect(function()\
\9\9setForeground(if active then FOREGROUND_ACTIVE else FOREGROUND_DEFAULT)\
\9end, { active })\
\9local _binding_2 = useState()\
\9local dragState = _binding_2[1]\
\9local setDragState = _binding_2[2]\
\9local _binding_3 = useBinding(nil)\
\9local dragPosition = _binding_3[1]\
\9local setDragPosition = _binding_3[2]\
\9useEffect(function()\
\9\9if not dragState then\
\9\9\9return nil\
\9\9end\
\9\9local tabs\
\9\9local estimateNewIndex = function(dragOffset)\
\9\9\9local totalWidth = 0\
\9\9\9for _, t in ipairs(tabs) do\
\9\9\9\9totalWidth += getTabWidth(t)\
\9\9\9\9if totalWidth > dragOffset + width / 2 then\
\9\9\9\9\9return (table.find(tabs, t) or 0) - 1\
\9\9\9\9end\
\9\9\9end\
\9\9\9return #tabs - 1\
\9\9end\
\9\9tabs = store:getState().tabGroup.tabs\
\9\9local startCanvasPosition = canvasPosition:getValue()\
\9\9local lastIndex = estimateNewIndex(0)\
\9\9local mouseMoved = RunService.Heartbeat:Connect(function()\
\9\9\9local current = UserInputService:GetMouseLocation()\
\9\9\9local position = current.X - dragState.mousePosition + dragState.tabPosition\
\9\9\9local canvasDelta = canvasPosition:getValue().X - startCanvasPosition.X\
\9\9\9setDragPosition(position + canvasDelta)\
\9\9\9local newIndex = estimateNewIndex(position + canvasDelta)\
\9\9\9if newIndex ~= lastIndex then\
\9\9\9\9lastIndex = newIndex\
\9\9\9\9move(newIndex)\
\9\9\9end\
\9\9end)\
\9\9local mouseUp = UserInputService.InputEnded:Connect(function(input)\
\9\9\9if input.UserInputType == Enum.UserInputType.MouseButton1 then\
\9\9\9\9setDragState(nil)\
\9\9\9\9setDragPosition(nil)\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9mouseMoved:Disconnect()\
\9\9\9mouseUp:Disconnect()\
\9\9end\
\9end, { dragState })\
\9local _attributes = {\
\9\9onPress = function(_, x)\
\9\9\9if not active then\
\9\9\9\9activate()\
\9\9\9end\
\9\9\9setDragState({\
\9\9\9\9dragging = false,\
\9\9\9\9mousePosition = x,\
\9\9\9\9tabPosition = offset,\
\9\9\9})\
\9\9end,\
\9\9onClick = function()\
\9\9\9return not active and setForeground(FOREGROUND_HOVERED)\
\9\9end,\
\9\9onHover = function()\
\9\9\9return not active and setForeground(FOREGROUND_HOVERED)\
\9\9end,\
\9\9onHoverEnd = function()\
\9\9\9return not active and setForeground(FOREGROUND_DEFAULT)\
\9\9end,\
\9\9size = UDim2.new(0, width, 1, 0),\
\9\9position = Roact.joinBindings({\
\9\9\9dragPosition = dragPosition,\
\9\9\9offsetAnim = offsetAnim,\
\9\9}):map(function(binding)\
\9\9\9local xOffset = if binding.dragPosition ~= nil then math.max(binding.dragPosition, 0) else math.round(binding.offsetAnim)\
\9\9\9return UDim2.new(0, xOffset, 0, 0)\
\9\9end),\
\9\9zIndex = dragPosition:map(function(drag)\
\9\9\9return if drag ~= nil then 1 else 0\
\9\9end),\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9896472554\",\
\9\9\9ImageTransparency = if active then 0.96 else 1,\
\9\9\9ImageColor3 = Color3.fromHex(\"#FFFFFF\"),\
\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9BackgroundTransparency = 1,\
\9\9\9ScaleType = \"Slice\",\
\9\9\9SliceCenter = Rect.new(8, 8, 8, 8),\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9896472759\",\
\9\9\9ImageTransparency = if active then 0.96 else 1,\
\9\9\9ImageColor3 = Color3.fromHex(\"#FFFFFF\"),\
\9\9\9Size = UDim2.new(0, 5, 0, 5),\
\9\9\9Position = UDim2.new(0, -5, 1, -5),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9896472676\",\
\9\9\9ImageTransparency = if active then 0.96 else 1,\
\9\9\9ImageColor3 = Color3.fromHex(\"#FFFFFF\"),\
\9\9\9Size = UDim2.new(0, 5, 0, 5),\
\9\9\9Position = UDim2.new(1, 0, 1, -5),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9}\
\9local _length = #_children\
\9local _children_1 = {\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = tabIcons[tab.type],\
\9\9\9ImageTransparency = foreground,\
\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9}\
\9local _length_1 = #_children_1\
\9local _attributes_1 = {\
\9\9Text = formatEscapes(tab.caption),\
\9\9Font = \"Gotham\",\
\9\9TextColor3 = Color3.new(1, 1, 1),\
\9\9TextTransparency = foreground,\
\9\9TextSize = 11,\
\9\9TextXAlignment = \"Left\",\
\9\9TextYAlignment = \"Center\",\
\9\9Size = UDim2.new(0, captionWidth, 1, 0),\
\9\9BackgroundTransparency = 1,\
\9}\
\9local _children_2 = {}\
\9local _length_2 = #_children_2\
\9local _child = captionWidth == MAX_TAB_CAPTION_WIDTH and (Roact.createElement(\"UIGradient\", {\
\9\9Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.9, 0), NumberSequenceKeypoint.new(1, 1) }),\
\9}))\
\9if _child then\
\9\9_children_2[_length_2 + 1] = _child\
\9end\
\9_children_1[_length_1 + 1] = Roact.createElement(\"TextLabel\", _attributes_1, _children_2)\
\9local _child_1 = tab.canClose and (Roact.createElement(Button, {\
\9\9onClick = function()\
\9\9\9deleteTab(tab.id)\
\9\9\9close()\
\9\9end,\
\9\9onPress = function()\
\9\9\9return setCloseBackground(CLOSE_PRESSED)\
\9\9end,\
\9\9onHover = function()\
\9\9\9return setCloseBackground(CLOSE_HOVERED)\
\9\9end,\
\9\9onHoverEnd = function()\
\9\9\9return setCloseBackground(CLOSE_DEFAULT)\
\9\9end,\
\9\9transparency = closeBackground,\
\9\9size = UDim2.new(0, 17, 0, 17),\
\9\9cornerRadius = UDim.new(0, 4),\
\9}, {\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = \"rbxassetid://9896553856\",\
\9\9\9ImageTransparency = foreground,\
\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9}))\
\9if _child_1 then\
\9\9_children_1[_length_1 + 2] = _child_1\
\9end\
\9_length_1 = #_children_1\
\9_children_1[_length_1 + 1] = Roact.createElement(\"UIPadding\", {\
\9\9PaddingLeft = UDim.new(0, 8),\
\9\9PaddingRight = UDim.new(0, 8),\
\9\9PaddingTop = UDim.new(0, 10),\
\9\9PaddingBottom = UDim.new(0, 10),\
\9})\
\9_children_1[_length_1 + 2] = Roact.createElement(\"UIListLayout\", {\
\9\9Padding = UDim.new(0, 6),\
\9\9FillDirection = \"Horizontal\",\
\9\9HorizontalAlignment = \"Left\",\
\9\9VerticalAlignment = \"Center\",\
\9})\
\9_children[_length + 1] = Roact.createElement(Container, {}, _children_1)\
\9return Roact.createElement(Button, _attributes, _children)\
end\
local default = pure(TabColumn)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.TabGroup.TabColumn")) setfenv(fn, _env("RemoteSpy.components.TabGroup.TabColumn")) return fn() end)

_module("TabGroup", "ModuleScript", "RemoteSpy.components.TabGroup.TabGroup", "RemoteSpy.components.TabGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local TabColumn = TS.import(script, script.Parent, \"TabColumn\").default\
local SIDE_PANEL_WIDTH = TS.import(script, script.Parent.Parent.Parent, \"constants\").SIDE_PANEL_WIDTH\
local arrayToMap = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).arrayToMap\
local getTabWidth = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"tab-group\").getTabWidth\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useMemo = _roact_hooked.useMemo\
local useTabs = TS.import(script, script.Parent, \"use-tab-group\").useTabs\
local function TabGroup()\
\9local tabs = useTabs()\
\9local _binding = useBinding(Vector2.new())\
\9local canvasPosition = _binding[1]\
\9local setCanvasPosition = _binding[2]\
\9local totalWidth = useMemo(function()\
\9\9local _arg0 = function(acc, tab)\
\9\9\9return acc + getTabWidth(tab)\
\9\9end\
\9\9-- ▼ ReadonlyArray.reduce ▼\
\9\9local _result = 0\
\9\9local _callback = _arg0\
\9\9for _i = 1, #tabs do\
\9\9\9_result = _callback(_result, tabs[_i], _i - 1, tabs)\
\9\9end\
\9\9-- ▲ ReadonlyArray.reduce ▲\
\9\9return _result\
\9end, tabs)\
\9local _attributes = {\
\9\9[Roact.Change.CanvasPosition] = function(rbx)\
\9\9\9return setCanvasPosition(rbx.CanvasPosition)\
\9\9end,\
\9\9CanvasSize = UDim2.new(0, totalWidth + 100, 0, 0),\
\9\9ScrollingDirection = \"X\",\
\9\9HorizontalScrollBarInset = \"None\",\
\9\9ScrollBarThickness = 0,\
\9\9Size = UDim2.new(1, -SIDE_PANEL_WIDTH - 5, 0, 35),\
\9\9Position = UDim2.new(0, 5, 0, 89),\
\9\9BackgroundTransparency = 1,\
\9\9BorderSizePixel = 0,\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"UIPadding\", {\
\9\9\9PaddingLeft = UDim.new(0, 12),\
\9\9}),\
\9}\
\9local _length = #_children\
\9for _k, _v in pairs(arrayToMap(tabs, function(tab)\
\9\9return { tab.id, Roact.createElement(TabColumn, {\
\9\9\9tab = tab,\
\9\9\9canvasPosition = canvasPosition,\
\9\9}) }\
\9end)) do\
\9\9_children[_k] = _v\
\9end\
\9return Roact.createElement(\"ScrollingFrame\", _attributes, _children)\
end\
local default = pure(TabGroup)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.TabGroup.TabGroup")) setfenv(fn, _env("RemoteSpy.components.TabGroup.TabGroup")) return fn() end)

_module("constants", "ModuleScript", "RemoteSpy.components.TabGroup.constants", "RemoteSpy.components.TabGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local TabType = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"tab-group\").TabType\
local tabIcons = {\
\9[TabType.Home] = \"rbxassetid://9896611868\",\
\9[TabType.Event] = \"rbxassetid://9896665149\",\
\9[TabType.Function] = \"rbxassetid://9896665330\",\
\9[TabType.Script] = \"rbxassetid://9896665034\",\
}\
return {\
\9tabIcons = tabIcons,\
}\
", '@'.."RemoteSpy.components.TabGroup.constants")) setfenv(fn, _env("RemoteSpy.components.TabGroup.constants")) return fn() end)

_module("use-tab-group", "ModuleScript", "RemoteSpy.components.TabGroup.use-tab-group", "RemoteSpy.components.TabGroup", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local _tab_group = TS.import(script, script.Parent.Parent.Parent, \"reducers\", \"tab-group\")\
local deleteTab = _tab_group.deleteTab\
local getTabWidth = _tab_group.getTabWidth\
local makeSelectTabOffset = _tab_group.makeSelectTabOffset\
local moveTab = _tab_group.moveTab\
local pushTab = _tab_group.pushTab\
local selectActiveTabId = _tab_group.selectActiveTabId\
local selectTab = _tab_group.selectTab\
local selectTabCount = _tab_group.selectTabCount\
local selectTabGroup = _tab_group.selectTabGroup\
local selectTabIsActive = _tab_group.selectTabIsActive\
local selectTabOrder = _tab_group.selectTabOrder\
local selectTabType = _tab_group.selectTabType\
local selectTabs = _tab_group.selectTabs\
local setActiveTab = _tab_group.setActiveTab\
local useMemo = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useMemo\
local _use_root_store = TS.import(script, script.Parent.Parent.Parent, \"hooks\", \"use-root-store\")\
local useRootDispatch = _use_root_store.useRootDispatch\
local useRootSelector = _use_root_store.useRootSelector\
local function useTabWidth(tab)\
\9return getTabWidth(tab)\
end\
local function useTabType(id)\
\9return useRootSelector(function(state)\
\9\9return selectTabType(state, id)\
\9end)\
end\
local function useTabOffset(id)\
\9local selectTabOffset = useMemo(makeSelectTabOffset, {})\
\9return useRootSelector(function(state)\
\9\9return selectTabOffset(state, id)\
\9end)\
end\
local function useTabGroup()\
\9return useRootSelector(selectTabGroup)\
end\
local function useTabs()\
\9return useRootSelector(selectTabs)\
end\
local function useTabCount()\
\9return useRootSelector(selectTabCount)\
end\
local function useActiveTabId()\
\9return useRootSelector(selectActiveTabId)\
end\
local function useTab(id)\
\9return useRootSelector(function(state)\
\9\9return selectTab(state, id)\
\9end)\
end\
local function useTabIsActive(id)\
\9return useRootSelector(function(state)\
\9\9return selectTabIsActive(state, id)\
\9end)\
end\
local function useTabOrder(id)\
\9return useRootSelector(function(state)\
\9\9return selectTabOrder(state, id)\
\9end)\
end\
local function useSetActiveTab(id)\
\9local dispatch = useRootDispatch()\
\9return function()\
\9\9return dispatch(setActiveTab(id))\
\9end\
end\
local function useDeleteTab(id)\
\9local dispatch = useRootDispatch()\
\9return function()\
\9\9return dispatch(deleteTab(id))\
\9end\
end\
local function useMoveTab(id)\
\9local dispatch = useRootDispatch()\
\9return function(to)\
\9\9return dispatch(moveTab(id, to))\
\9end\
end\
local function usePushTab()\
\9local dispatch = useRootDispatch()\
\9return function(tab)\
\9\9return dispatch(pushTab(tab))\
\9end\
end\
return {\
\9useTabWidth = useTabWidth,\
\9useTabType = useTabType,\
\9useTabOffset = useTabOffset,\
\9useTabGroup = useTabGroup,\
\9useTabs = useTabs,\
\9useTabCount = useTabCount,\
\9useActiveTabId = useActiveTabId,\
\9useTab = useTab,\
\9useTabIsActive = useTabIsActive,\
\9useTabOrder = useTabOrder,\
\9useSetActiveTab = useSetActiveTab,\
\9useDeleteTab = useDeleteTab,\
\9useMoveTab = useMoveTab,\
\9usePushTab = usePushTab,\
}\
", '@'.."RemoteSpy.components.TabGroup.use-tab-group")) setfenv(fn, _env("RemoteSpy.components.TabGroup.use-tab-group")) return fn() end)

_module("Traceback", "ModuleScript", "RemoteSpy.components.Traceback", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
exports.default = TS.import(script, script, \"Traceback\").default\
return exports\
", '@'.."RemoteSpy.components.Traceback")) setfenv(fn, _env("RemoteSpy.components.Traceback")) return fn() end)

_module("Traceback", "ModuleScript", "RemoteSpy.components.Traceback.Traceback", "RemoteSpy.components.Traceback", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local SidePanel = TS.import(script, script.Parent.Parent, \"SidePanel\").default\
local pure = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).pure\
local useSidePanelContext = TS.import(script, script.Parent.Parent, \"SidePanel\").useSidePanelContext\
local function Traceback()\
\9local _binding = useSidePanelContext()\
\9local lowerHidden = _binding.lowerHidden\
\9local setLowerHidden = _binding.setLowerHidden\
\9local lowerSize = _binding.lowerSize\
\9local lowerPosition = _binding.lowerPosition\
\9return Roact.createElement(Container, {\
\9\9size = lowerSize,\
\9\9position = lowerPosition,\
\9}, {\
\9\9Roact.createElement(SidePanel.TitleBar, {\
\9\9\9caption = \"Traceback\",\
\9\9\9hidden = lowerHidden,\
\9\9\9toggleHidden = function()\
\9\9\9\9return setLowerHidden(not lowerHidden)\
\9\9\9end,\
\9\9}),\
\9})\
end\
local default = pure(Traceback)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.Traceback.Traceback")) setfenv(fn, _env("RemoteSpy.components.Traceback.Traceback")) return fn() end)

_module("Window", "ModuleScript", "RemoteSpy.components.Window", "RemoteSpy.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local Window = TS.import(script, script, \"Window\").default\
local WindowBackground = TS.import(script, script, \"WindowBackground\").default\
local WindowDropShadow = TS.import(script, script, \"WindowDropShadow\").default\
local WindowResize = TS.import(script, script, \"WindowResize\").default\
local WindowTitleBar = TS.import(script, script, \"WindowTitleBar\").default\
local default = {\
\9Root = Window,\
\9TitleBar = WindowTitleBar,\
\9Background = WindowBackground,\
\9DropShadow = WindowDropShadow,\
\9Resize = WindowResize,\
}\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.Window")) setfenv(fn, _env("RemoteSpy.components.Window")) return fn() end)

_module("Window", "ModuleScript", "RemoteSpy.components.Window.Window", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local WindowContext = TS.import(script, script.Parent, \"use-window-context\").WindowContext\
local lerp = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"number-util\").lerp\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useState = _roact_hooked.useState\
local _roact_hooked_plus = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out)\
local useSpring = _roact_hooked_plus.useSpring\
local useViewportSize = _roact_hooked_plus.useViewportSize\
local apply = function(v2, udim)\
\9return Vector2.new(v2.X * udim.X.Scale + udim.X.Offset, v2.Y * udim.Y.Scale + udim.Y.Offset)\
end\
local function Window(_param)\
\9local initialSize = _param.initialSize\
\9local initialPosition = _param.initialPosition\
\9local children = _param[Roact.Children]\
\9local viewportSize = useViewportSize()\
\9local _binding = useBinding(apply(viewportSize:getValue(), initialSize))\
\9local size = _binding[1]\
\9local setSize = _binding[2]\
\9local _binding_1 = useBinding(apply(viewportSize:getValue(), initialPosition))\
\9local position = _binding_1[1]\
\9local setPosition = _binding_1[2]\
\9local _binding_2 = useState(false)\
\9local maximized = _binding_2[1]\
\9local setMaximized = _binding_2[2]\
\9local maximizeAnim = useSpring(if maximized then 1 else 0, {\
\9\9frequency = 6,\
\9})\
\9local _attributes = {\
\9\9value = {\
\9\9\9size = size,\
\9\9\9setSize = setSize,\
\9\9\9position = position,\
\9\9\9setPosition = setPosition,\
\9\9\9maximized = maximized,\
\9\9\9setMaximized = setMaximized,\
\9\9},\
\9}\
\9local _children = {}\
\9local _length = #_children\
\9local _attributes_1 = {\
\9\9BackgroundTransparency = 1,\
\9\9Size = Roact.joinBindings({\
\9\9\9size = size,\
\9\9\9viewportSize = viewportSize,\
\9\9\9maximizeAnim = maximizeAnim,\
\9\9}):map(function(_param_1)\
\9\9\9local size = _param_1.size\
\9\9\9local viewportSize = _param_1.viewportSize\
\9\9\9local maximizeAnim = _param_1.maximizeAnim\
\9\9\9return UDim2.new(0, math.round(lerp(size.X, viewportSize.X, maximizeAnim)), 0, math.round(lerp(size.Y, viewportSize.Y, maximizeAnim)))\
\9\9end),\
\9\9Position = Roact.joinBindings({\
\9\9\9position = position,\
\9\9\9maximizeAnim = maximizeAnim,\
\9\9}):map(function(_param_1)\
\9\9\9local position = _param_1.position\
\9\9\9local maximizeAnim = _param_1.maximizeAnim\
\9\9\9return UDim2.new(0, math.round(position.X * (1 - maximizeAnim)), 0, math.round(position.Y * (1 - maximizeAnim)))\
\9\9end),\
\9}\
\9local _children_1 = {\
\9\9Roact.createElement(\"UICorner\", {\
\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9}),\
\9}\
\9local _length_1 = #_children_1\
\9local _children_2 = {}\
\9local _length_2 = #_children_2\
\9if children then\
\9\9for _k, _v in pairs(children) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_children_2[_length_2 + _k] = _v\
\9\9\9else\
\9\9\9\9_children_2[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9_children_1[_length_1 + 1] = Roact.createFragment(_children_2)\
\9_children[_length + 1] = Roact.createElement(\"Frame\", _attributes_1, _children_1)\
\9return Roact.createElement(WindowContext.Provider, _attributes, _children)\
end\
local default = pure(Window)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.Window.Window")) setfenv(fn, _env("RemoteSpy.components.Window.Window")) return fn() end)

_module("Window.story", "ModuleScript", "RemoteSpy.components.Window.Window.story", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local Root = TS.import(script, script.Parent.Parent, \"Root\").default\
local Window = TS.import(script, script.Parent).default\
return function(target)\
\9local handle = Roact.mount(Roact.createElement(Root, {}, {\
\9\9Roact.createElement(Window.Root, {\
\9\9\9initialSize = UDim2.new(0, 1080, 0, 700),\
\9\9\9initialPosition = UDim2.new(0.5, -1080 / 2, 0.5, -700 / 2),\
\9\9}, {\
\9\9\9Roact.createElement(Window.DropShadow),\
\9\9\9Roact.createElement(Window.Background),\
\9\9\9Roact.createElement(Window.TitleBar, {\
\9\9\9\9caption = '<font color=\"#E5E5E5\">New window</font>',\
\9\9\9\9icon = \"rbxassetid://9886981409\",\
\9\9\9}),\
\9\9\9Roact.createElement(Window.Resize, {\
\9\9\9\9minSize = Vector2.new(350, 250),\
\9\9\9}),\
\9\9}),\
\9}), target, \"App\")\
\9return function()\
\9\9Roact.unmount(handle)\
\9end\
end\
", '@'.."RemoteSpy.components.Window.Window.story")) setfenv(fn, _env("RemoteSpy.components.Window.Window.story")) return fn() end)

_module("WindowBackground", "ModuleScript", "RemoteSpy.components.Window.WindowBackground", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function WindowBackground(_param)\
\9local background = _param.background\
\9if background == nil then\
\9\9background = Color3.fromHex(\"#202020\")\
\9end\
\9local transparency = _param.transparency\
\9if transparency == nil then\
\9\9transparency = 0.2\
\9end\
\9local children = _param[Roact.Children]\
\9local _attributes = {\
\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9BackgroundColor3 = background,\
\9\9BackgroundTransparency = transparency,\
\9\9BorderSizePixel = 0,\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"UICorner\", {\
\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9}),\
\9}\
\9local _length = #_children\
\9if children then\
\9\9for _k, _v in pairs(children) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_children[_length + _k] = _v\
\9\9\9else\
\9\9\9\9_children[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9_length = #_children\
\9_children[_length + 1] = Roact.createElement(Container, {}, {\
\9\9Roact.createElement(\"UICorner\", {\
\9\9\9CornerRadius = UDim.new(0, 8),\
\9\9}),\
\9\9Roact.createElement(\"UIStroke\", {\
\9\9\9Color = Color3.fromHex(\"#606060\"),\
\9\9\9Transparency = 0.5,\
\9\9\9Thickness = 1,\
\9\9}),\
\9})\
\9return Roact.createElement(\"Frame\", _attributes, _children)\
end\
return {\
\9default = WindowBackground,\
}\
", '@'.."RemoteSpy.components.Window.WindowBackground")) setfenv(fn, _env("RemoteSpy.components.Window.WindowBackground")) return fn() end)

_module("WindowDropShadow", "ModuleScript", "RemoteSpy.components.Window.WindowDropShadow", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local WindowAssets = TS.import(script, script.Parent, \"assets\").WindowAssets\
local IMAGE_SIZE = Vector2.new(226, 226)\
local function WindowDropShadow()\
\9return Roact.createElement(\"ImageLabel\", {\
\9\9Image = WindowAssets.DropShadow,\
\9\9ScaleType = \"Slice\",\
\9\9SliceCenter = Rect.new(IMAGE_SIZE / 2, IMAGE_SIZE / 2),\
\9\9AnchorPoint = Vector2.new(0.5, 0.5),\
\9\9Size = UDim2.new(1, 110, 1, 110),\
\9\9Position = UDim2.new(0.5, 0, 0.5, 24),\
\9\9BackgroundTransparency = 1,\
\9})\
end\
return {\
\9default = WindowDropShadow,\
}\
", '@'.."RemoteSpy.components.Window.WindowDropShadow")) setfenv(fn, _env("RemoteSpy.components.Window.WindowDropShadow")) return fn() end)

_module("WindowResize", "ModuleScript", "RemoteSpy.components.Window.WindowResize", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent, \"Button\").default\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local UserInputService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).UserInputService\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useEffect = _roact_hooked.useEffect\
local useState = _roact_hooked.useState\
local useWindowContext = TS.import(script, script.Parent, \"use-window-context\").useWindowContext\
local THICKNESS = 14\
local Handle = function(props)\
\9return Roact.createElement(Button, {\
\9\9onPress = function(_, x, y)\
\9\9\9return props.dragStart(Vector2.new(x, y))\
\9\9end,\
\9\9anchorPoint = Vector2.new(0.5, 0.5),\
\9\9size = props.size,\
\9\9position = props.position,\
\9\9active = false,\
\9})\
end\
local function WindowResize(_param)\
\9local minSize = _param.minSize\
\9if minSize == nil then\
\9\9minSize = Vector2.new(250, 250)\
\9end\
\9local maxSize = _param.maxSize\
\9if maxSize == nil then\
\9\9maxSize = Vector2.new(2048, 2048)\
\9end\
\9local _binding = useWindowContext()\
\9local size = _binding.size\
\9local setSize = _binding.setSize\
\9local position = _binding.position\
\9local setPosition = _binding.setPosition\
\9local maximized = _binding.maximized\
\9local _binding_1 = useState()\
\9local dragStart = _binding_1[1]\
\9local setDragStart = _binding_1[2]\
\9useEffect(function()\
\9\9if not dragStart or maximized then\
\9\9\9return nil\
\9\9end\
\9\9local startPosition = position:getValue()\
\9\9local startSize = size:getValue()\
\9\9local inputBegan = UserInputService.InputChanged:Connect(function(input)\
\9\9\9if input.UserInputType == Enum.UserInputType.MouseMovement then\
\9\9\9\9local current = UserInputService:GetMouseLocation()\
\9\9\9\9local _mouse = dragStart.mouse\
\9\9\9\9local delta = current - _mouse\
\9\9\9\9local _arg0 = dragStart.direction * delta\
\9\9\9\9local targetSize = startSize + _arg0\
\9\9\9\9local targetSizeClamped = Vector2.new(math.clamp(targetSize.X, minSize.X, maxSize.X), math.clamp(targetSize.Y, minSize.Y, maxSize.Y))\
\9\9\9\9setSize(targetSizeClamped)\
\9\9\9\9if dragStart.direction.X < 0 and dragStart.direction.Y < 0 then\
\9\9\9\9\9local _arg0_1 = startSize - targetSizeClamped\
\9\9\9\9\9setPosition(startPosition + _arg0_1)\
\9\9\9\9elseif dragStart.direction.X < 0 then\
\9\9\9\9\9setPosition(Vector2.new(startPosition.X + (startSize.X - targetSizeClamped.X), startPosition.Y))\
\9\9\9\9elseif dragStart.direction.Y < 0 then\
\9\9\9\9\9setPosition(Vector2.new(startPosition.X, startPosition.Y + (startSize.Y - targetSizeClamped.Y)))\
\9\9\9\9end\
\9\9\9end\
\9\9end)\
\9\9local inputEnded = UserInputService.InputEnded:Connect(function(input)\
\9\9\9if input.UserInputType == Enum.UserInputType.MouseButton1 then\
\9\9\9\9setDragStart(nil)\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9inputBegan:Disconnect()\
\9\9\9inputEnded:Disconnect()\
\9\9end\
\9end, { dragStart })\
\9return Roact.createElement(Container, {}, {\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(0, -1),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(1, -THICKNESS, 0, THICKNESS),\
\9\9\9position = UDim2.new(0.5, 0, 0, 0),\
\9\9}),\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(-1, 0),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(0, THICKNESS, 1, -THICKNESS),\
\9\9\9position = UDim2.new(0, 0, 0.5, 0),\
\9\9}),\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(1, 0),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(0, THICKNESS, 1, -THICKNESS),\
\9\9\9position = UDim2.new(1, 0, 0.5, 0),\
\9\9}),\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(0, 1),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(1, -THICKNESS, 0, THICKNESS),\
\9\9\9position = UDim2.new(0.5, 0, 1, 0),\
\9\9}),\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(-1, -1),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(0, THICKNESS, 0, THICKNESS),\
\9\9\9position = UDim2.new(0, 0, 0, 0),\
\9\9}),\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(1, -1),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(0, THICKNESS, 0, THICKNESS),\
\9\9\9position = UDim2.new(1, 0, 0, 0),\
\9\9}),\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(-1, 1),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(0, THICKNESS, 0, THICKNESS),\
\9\9\9position = UDim2.new(0, 0, 1, 0),\
\9\9}),\
\9\9Roact.createElement(Handle, {\
\9\9\9dragStart = function(mouse)\
\9\9\9\9return setDragStart({\
\9\9\9\9\9mouse = mouse,\
\9\9\9\9\9direction = Vector2.new(1, 1),\
\9\9\9\9})\
\9\9\9end,\
\9\9\9size = UDim2.new(0, THICKNESS, 0, THICKNESS),\
\9\9\9position = UDim2.new(1, 0, 1, 0),\
\9\9}),\
\9})\
end\
local default = pure(WindowResize)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.Window.WindowResize")) setfenv(fn, _env("RemoteSpy.components.Window.WindowResize")) return fn() end)

_module("WindowTitleBar", "ModuleScript", "RemoteSpy.components.Window.WindowTitleBar", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Button = TS.import(script, script.Parent.Parent, \"Button\").default\
local Container = TS.import(script, script.Parent.Parent, \"Container\").default\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local Instant = _flipper.Instant\
local Spring = _flipper.Spring\
local TOPBAR_OFFSET = TS.import(script, script.Parent.Parent.Parent, \"constants\").TOPBAR_OFFSET\
local UserInputService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).UserInputService\
local WindowAssets = TS.import(script, script.Parent, \"assets\").WindowAssets\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local pure = _roact_hooked.pure\
local useBinding = _roact_hooked.useBinding\
local useEffect = _roact_hooked.useEffect\
local useState = _roact_hooked.useState\
local useSingleMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked-plus\").out).useSingleMotor\
local useWindowContext = TS.import(script, script.Parent, \"use-window-context\").useWindowContext\
local function WindowTitleBar(_param)\
\9local caption = _param.caption\
\9if caption == nil then\
\9\9caption = \"New window\"\
\9end\
\9local captionColor = _param.captionColor\
\9if captionColor == nil then\
\9\9captionColor = Color3.new(1, 1, 1)\
\9end\
\9local captionTransparency = _param.captionTransparency\
\9if captionTransparency == nil then\
\9\9captionTransparency = 0\
\9end\
\9local icon = _param.icon\
\9if icon == nil then\
\9\9icon = WindowAssets.DefaultWindowIcon\
\9end\
\9local height = _param.height\
\9if height == nil then\
\9\9height = 42\
\9end\
\9local onClose = _param.onClose\
\9local children = _param[Roact.Children]\
\9local _binding = useWindowContext()\
\9local size = _binding.size\
\9local maximized = _binding.maximized\
\9local setMaximized = _binding.setMaximized\
\9local setPosition = _binding.setPosition\
\9local _binding_1 = useSingleMotor(1)\
\9local closeTransparency = _binding_1[1]\
\9local setCloseTransparency = _binding_1[2]\
\9local _binding_2 = useSingleMotor(1)\
\9local minimizeTransparency = _binding_2[1]\
\9local setMinimizeTransparency = _binding_2[2]\
\9local _binding_3 = useSingleMotor(1)\
\9local maximizeTransparency = _binding_3[1]\
\9local setMaximizeTransparency = _binding_3[2]\
\9local _binding_4 = useBinding(Vector2.new())\
\9local startPosition = _binding_4[1]\
\9local setStartPosition = _binding_4[2]\
\9local _binding_5 = useState()\
\9local dragStart = _binding_5[1]\
\9local setDragStart = _binding_5[2]\
\9useEffect(function()\
\9\9if not dragStart then\
\9\9\9return nil\
\9\9end\
\9\9local startPos = startPosition:getValue()\
\9\9local shouldMinimize = maximized\
\9\9local mouseMoved = UserInputService.InputChanged:Connect(function(input)\
\9\9\9if input.UserInputType == Enum.UserInputType.MouseMovement then\
\9\9\9\9local current = UserInputService:GetMouseLocation()\
\9\9\9\9local delta = current - dragStart\
\9\9\9\9setPosition(startPos + delta)\
\9\9\9\9if shouldMinimize then\
\9\9\9\9\9shouldMinimize = false\
\9\9\9\9\9setMaximized(false)\
\9\9\9\9end\
\9\9\9end\
\9\9end)\
\9\9local mouseUp = UserInputService.InputEnded:Connect(function(input)\
\9\9\9if input.UserInputType == Enum.UserInputType.MouseButton1 then\
\9\9\9\9setDragStart(nil)\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9mouseMoved:Disconnect()\
\9\9\9mouseUp:Disconnect()\
\9\9end\
\9end, { dragStart })\
\9local _attributes = {\
\9\9size = UDim2.new(1, 0, 0, height),\
\9}\
\9local _children = {\
\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9Image = icon,\
\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9Position = UDim2.new(0, 16, 0.5, 0),\
\9\9\9AnchorPoint = Vector2.new(0, 0.5),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(\"TextLabel\", {\
\9\9\9RichText = true,\
\9\9\9Text = caption,\
\9\9\9TextColor3 = captionColor,\
\9\9\9TextTransparency = captionTransparency,\
\9\9\9Font = \"Gotham\",\
\9\9\9TextSize = 11,\
\9\9\9TextXAlignment = \"Left\",\
\9\9\9TextYAlignment = \"Center\",\
\9\9\9Size = UDim2.new(1, -44, 1, 0),\
\9\9\9Position = UDim2.new(0, 44, 0, 0),\
\9\9\9BackgroundTransparency = 1,\
\9\9}),\
\9\9Roact.createElement(Button, {\
\9\9\9onPress = function(rbx, x, y)\
\9\9\9\9local mouse = Vector2.new(x, y)\
\9\9\9\9if maximized then\
\9\9\9\9\9local currentSize = Vector2.new(size:getValue().X - 46 * 3, height)\
\9\9\9\9\9setStartPosition(Vector2.new())\
\9\9\9\9\9local _absoluteSize = rbx.AbsoluteSize\
\9\9\9\9\9local _arg0 = currentSize / _absoluteSize\
\9\9\9\9\9setDragStart(mouse * _arg0)\
\9\9\9\9else\
\9\9\9\9\9setStartPosition(rbx.AbsolutePosition + TOPBAR_OFFSET)\
\9\9\9\9\9setDragStart(mouse)\
\9\9\9\9end\
\9\9\9end,\
\9\9\9active = false,\
\9\9\9size = UDim2.new(1, -46 * 3, 1, 0),\
\9\9}),\
\9\9Roact.createElement(Button, {\
\9\9\9onClick = function()\
\9\9\9\9setCloseTransparency(Spring.new(0, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9\9local _result = onClose\
\9\9\9\9if _result ~= nil then\
\9\9\9\9\9_result()\
\9\9\9\9end\
\9\9\9end,\
\9\9\9onPress = function()\
\9\9\9\9return setCloseTransparency(Instant.new(0.25))\
\9\9\9end,\
\9\9\9onHover = function()\
\9\9\9\9return setCloseTransparency(Spring.new(0, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9end,\
\9\9\9onHoverEnd = function()\
\9\9\9\9return setCloseTransparency(Spring.new(1, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9end,\
\9\9\9size = UDim2.new(0, 46, 1, 0),\
\9\9\9position = UDim2.new(1, 0, 0, 0),\
\9\9\9anchorPoint = Vector2.new(1, 0),\
\9\9}, {\
\9\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9\9Image = WindowAssets.CloseButton,\
\9\9\9\9ImageTransparency = closeTransparency,\
\9\9\9\9ImageColor3 = Color3.fromHex(\"#C83D3D\"),\
\9\9\9\9ScaleType = \"Slice\",\
\9\9\9\9SliceCenter = Rect.new(8, 8, 8, 8),\
\9\9\9\9Size = UDim2.new(1, 0, 1, 0),\
\9\9\9\9BackgroundTransparency = 1,\
\9\9\9}),\
\9\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9\9Image = WindowAssets.Close,\
\9\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9\9Position = UDim2.new(0.5, 0, 0.5, 0),\
\9\9\9\9AnchorPoint = Vector2.new(0.5, 0.5),\
\9\9\9\9BackgroundTransparency = 1,\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(Button, {\
\9\9\9onClick = function()\
\9\9\9\9setMaximizeTransparency(Spring.new(0.94, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9\9setMaximized(not maximized)\
\9\9\9end,\
\9\9\9onPress = function()\
\9\9\9\9return setMaximizeTransparency(Instant.new(0.96))\
\9\9\9end,\
\9\9\9onHover = function()\
\9\9\9\9return setMaximizeTransparency(Spring.new(0.94, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9end,\
\9\9\9onHoverEnd = function()\
\9\9\9\9return setMaximizeTransparency(Spring.new(1, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9end,\
\9\9\9background = Color3.fromHex(\"#FFFFFF\"),\
\9\9\9transparency = maximizeTransparency,\
\9\9\9size = UDim2.new(0, 46, 1, 0),\
\9\9\9position = UDim2.new(1, -46, 0, 0),\
\9\9\9anchorPoint = Vector2.new(1, 0),\
\9\9}, {\
\9\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9\9Image = if maximized then WindowAssets.RestoreDown else WindowAssets.Maximize,\
\9\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9\9Position = UDim2.new(0.5, 0, 0.5, 0),\
\9\9\9\9AnchorPoint = Vector2.new(0.5, 0.5),\
\9\9\9\9BackgroundTransparency = 1,\
\9\9\9}),\
\9\9}),\
\9\9Roact.createElement(Button, {\
\9\9\9onClick = function()\
\9\9\9\9local _viewportSize = game:GetService(\"Workspace\").CurrentCamera\
\9\9\9\9if _viewportSize ~= nil then\
\9\9\9\9\9_viewportSize = _viewportSize.ViewportSize\
\9\9\9\9end\
\9\9\9\9local viewportSize = _viewportSize\
\9\9\9\9if viewportSize then\
\9\9\9\9\9local _vector2 = Vector2.new(42, height)\
\9\9\9\9\9setPosition(viewportSize - _vector2)\
\9\9\9\9\9if maximized then\
\9\9\9\9\9\9setMaximized(false)\
\9\9\9\9\9end\
\9\9\9\9end\
\9\9\9\9setMinimizeTransparency(Spring.new(0.94, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9end,\
\9\9\9onPress = function()\
\9\9\9\9return setMinimizeTransparency(Instant.new(0.96))\
\9\9\9end,\
\9\9\9onHover = function()\
\9\9\9\9return setMinimizeTransparency(Spring.new(0.94, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9end,\
\9\9\9onHoverEnd = function()\
\9\9\9\9return setMinimizeTransparency(Spring.new(1, {\
\9\9\9\9\9frequency = 6,\
\9\9\9\9}))\
\9\9\9end,\
\9\9\9background = Color3.fromHex(\"#FFFFFF\"),\
\9\9\9transparency = minimizeTransparency,\
\9\9\9size = UDim2.new(0, 46, 1, 0),\
\9\9\9position = UDim2.new(1, -46 * 2, 0, 0),\
\9\9\9anchorPoint = Vector2.new(1, 0),\
\9\9}, {\
\9\9\9Roact.createElement(\"ImageLabel\", {\
\9\9\9\9Image = WindowAssets.Minimize,\
\9\9\9\9Size = UDim2.new(0, 16, 0, 16),\
\9\9\9\9Position = UDim2.new(0.5, 0, 0.5, 0),\
\9\9\9\9AnchorPoint = Vector2.new(0.5, 0.5),\
\9\9\9\9BackgroundTransparency = 1,\
\9\9\9}),\
\9\9}),\
\9}\
\9local _length = #_children\
\9if children then\
\9\9for _k, _v in pairs(children) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_children[_length + _k] = _v\
\9\9\9else\
\9\9\9\9_children[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9return Roact.createElement(Container, _attributes, _children)\
end\
local default = pure(WindowTitleBar)\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.components.Window.WindowTitleBar")) setfenv(fn, _env("RemoteSpy.components.Window.WindowTitleBar")) return fn() end)

_module("assets", "ModuleScript", "RemoteSpy.components.Window.assets", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local WindowAssets\
do\
\9local _inverse = {}\
\9WindowAssets = setmetatable({}, {\
\9\9__index = _inverse,\
\9})\
\9WindowAssets.Close = \"rbxassetid://9886659671\"\
\9_inverse[\"rbxassetid://9886659671\"] = \"Close\"\
\9WindowAssets.CloseButton = \"rbxassetid://9887215356\"\
\9_inverse[\"rbxassetid://9887215356\"] = \"CloseButton\"\
\9WindowAssets.Maximize = \"rbxassetid://9886659406\"\
\9_inverse[\"rbxassetid://9886659406\"] = \"Maximize\"\
\9WindowAssets.RestoreDown = \"rbxassetid://9886659001\"\
\9_inverse[\"rbxassetid://9886659001\"] = \"RestoreDown\"\
\9WindowAssets.Minimize = \"rbxassetid://9886659276\"\
\9_inverse[\"rbxassetid://9886659276\"] = \"Minimize\"\
\9WindowAssets.DefaultWindowIcon = \"rbxassetid://9886659555\"\
\9_inverse[\"rbxassetid://9886659555\"] = \"DefaultWindowIcon\"\
\9WindowAssets.DropShadow = \"rbxassetid://9886919127\"\
\9_inverse[\"rbxassetid://9886919127\"] = \"DropShadow\"\
end\
return {\
\9WindowAssets = WindowAssets,\
}\
", '@'.."RemoteSpy.components.Window.assets")) setfenv(fn, _env("RemoteSpy.components.Window.assets")) return fn() end)

_module("use-window-context", "ModuleScript", "RemoteSpy.components.Window.use-window-context", "RemoteSpy.components.Window", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local useContext = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useContext\
local WindowContext = Roact.createContext(nil)\
local function useWindowContext()\
\9return useContext(WindowContext)\
end\
return {\
\9useWindowContext = useWindowContext,\
\9WindowContext = WindowContext,\
}\
", '@'.."RemoteSpy.components.Window.use-window-context")) setfenv(fn, _env("RemoteSpy.components.Window.use-window-context")) return fn() end)

_module("constants", "ModuleScript", "RemoteSpy.constants", "RemoteSpy", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local DISPLAY_ORDER = 6\
local SIDE_PANEL_WIDTH = 280\
local TOPBAR_OFFSET = (game:GetService(\"GuiService\"):GetGuiInset())\
local IS_LOADED = \"__REMOTESPY_IS_LOADED__\"\
local IS_ELEVATED = loadstring ~= nil\
local HAS_FILE_ACCESS = readfile ~= nil\
local IS_ACRYLIC_ENABLED = true\
return {\
\9DISPLAY_ORDER = DISPLAY_ORDER,\
\9SIDE_PANEL_WIDTH = SIDE_PANEL_WIDTH,\
\9TOPBAR_OFFSET = TOPBAR_OFFSET,\
\9IS_LOADED = IS_LOADED,\
\9IS_ELEVATED = IS_ELEVATED,\
\9HAS_FILE_ACCESS = HAS_FILE_ACCESS,\
\9IS_ACRYLIC_ENABLED = IS_ACRYLIC_ENABLED,\
}\
", '@'.."RemoteSpy.constants")) setfenv(fn, _env("RemoteSpy.constants")) return fn() end)

_instance("hooks", "Folder", "RemoteSpy.hooks", "RemoteSpy")

_module("use-action-effect", "ModuleScript", "RemoteSpy.hooks.use-action-effect", "RemoteSpy.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local _action_bar = TS.import(script, script.Parent.Parent, \"reducers\", \"action-bar\")\
local deactivateAction = _action_bar.deactivateAction\
local selectActionIsActive = _action_bar.selectActionIsActive\
local useEffect = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useEffect\
local _use_root_store = TS.import(script, script.Parent, \"use-root-store\")\
local useRootDispatch = _use_root_store.useRootDispatch\
local useRootSelector = _use_root_store.useRootSelector\
local function useActionEffect(action, effect)\
\9local dispatch = useRootDispatch()\
\9local activated = useRootSelector(function(state)\
\9\9return selectActionIsActive(state, action)\
\9end)\
\9useEffect(function()\
\9\9if activated then\
\9\9\9task.spawn(effect)\
\9\9\9dispatch(deactivateAction(action))\
\9\9end\
\9end, { activated })\
end\
return {\
\9useActionEffect = useActionEffect,\
}\
", '@'.."RemoteSpy.hooks.use-action-effect")) setfenv(fn, _env("RemoteSpy.hooks.use-action-effect")) return fn() end)

_module("use-root-store", "ModuleScript", "RemoteSpy.hooks.use-root-store", "RemoteSpy.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local _roact_rodux_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-rodux-hooked\").out)\
local useDispatch = _roact_rodux_hooked.useDispatch\
local useSelector = _roact_rodux_hooked.useSelector\
local useStore = _roact_rodux_hooked.useStore\
local useRootSelector = useSelector\
local useRootDispatch = useDispatch\
local useRootStore = useStore\
return {\
\9useRootSelector = useRootSelector,\
\9useRootDispatch = useRootDispatch,\
\9useRootStore = useRootStore,\
}\
", '@'.."RemoteSpy.hooks.use-root-store")) setfenv(fn, _env("RemoteSpy.hooks.use-root-store")) return fn() end)

_module("receiver", "LocalScript", "RemoteSpy.receiver", "RemoteSpy", function () local fn = assert(loadstring("local TS = require(script.Parent.include.RuntimeLib)\
local logger = TS.import(script, script.Parent, \"reducers\", \"remote-log\")\
local store = TS.import(script, script.Parent, \"store\")\
local getFunctionScript = TS.import(script, script.Parent, \"utils\", \"function-util\").getFunctionScript\
local getInstanceId = TS.import(script, script.Parent, \"utils\", \"instance-util\").getInstanceId\
local makeSelectRemoteLog = TS.import(script, script.Parent, \"reducers\", \"remote-log\", \"selectors\").makeSelectRemoteLog\
\
local CALLER_STACK_LEVEL = if KRNL_LOADED then 6 else 4\
\
local FireServer = Instance.new(\"RemoteEvent\").FireServer\
local InvokeServer = Instance.new(\"RemoteFunction\").InvokeServer\
local IsA = game.IsA\
\
local refs = {}\
local selectRemoteLog = makeSelectRemoteLog()\
\
if not hookfunction then\
\9return\
end\
\
if not getcallingscript then\
\9function getcallingscript()\
\9\9return nil\
\9end\
end\
\
local function onReceive(self, params, returns)\
\9local traceback = {}\
\9local callback = debug.info(CALLER_STACK_LEVEL, \"f\")\
\
\9local level, fn = 4, callback\
\
\9while fn do\
\9\9table.insert(traceback, fn)\
\9\9level = level + 1\
\9\9fn = debug.info(level, \"f\")\
\9end\
\
\9task.defer(function()\
\9\9local script = getcallingscript() or (callback and getFunctionScript(callback))\
\9\9local signal = logger.createOutgoingSignal(self, script, callback, traceback, params, returns)\
\9\9local remoteId = getInstanceId(self)\
\
\9\9if store.get(function(state)\
\9\9\9return selectRemoteLog(state, remoteId)\
\9\9end) then\
\9\9\9store.dispatch(logger.pushOutgoingSignal(remoteId, signal))\
\9\9else\
\9\9\9local remoteLog = logger.createRemoteLog(self, signal)\
\9\9\9store.dispatch(logger.pushRemoteLog(remoteLog))\
\9\9end\
\9end)\
end\
\
-- Hooks\
\
refs.FireServer = hookfunction(FireServer, function(self, ...)\
\9if self and store.isActive() and typeof(self) == \"Instance\" and self:IsA(\"RemoteEvent\") then\
\9\9onReceive(self, { ... })\
\9end\
\9return refs.FireServer(self, ...)\
end)\
\
refs.InvokeServer = hookfunction(InvokeServer, function(self, ...)\
\9if self and store.isActive() and typeof(self) == \"Instance\" and self:IsA(\"RemoteFunction\") then\
\9\9onReceive(self, { ... })\
\9end\
\9return refs.InvokeServer(self, ...)\
end)\
\
refs.__namecall = hookmetamethod(game, \"__namecall\", function(self, ...)\
\9local method = getnamecallmethod()\
\
\9if\
\9\9(store.isActive() and method == \"FireServer\" and IsA(self, \"RemoteEvent\")) or\
\9\9(store.isActive() and method == \"InvokeServer\" and IsA(self, \"RemoteFunction\"))\
\9then\
\9\9onReceive(self, { ... })\
\9end\
\
\9return refs.__namecall(self, ...)\
end)\
", '@'.."RemoteSpy.receiver")) setfenv(fn, _env("RemoteSpy.receiver")) return fn() end)

_module("reducers", "ModuleScript", "RemoteSpy.reducers", "RemoteSpy", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.include.RuntimeLib)\
local Rodux = TS.import(script, TS.getModule(script, \"@rbxts\", \"rodux\").src)\
local actionBarReducer = TS.import(script, script, \"action-bar\").default\
local remoteLogReducer = TS.import(script, script, \"remote-log\").default\
local tabGroupReducer = TS.import(script, script, \"tab-group\").default\
local tracebackReducer = TS.import(script, script, \"traceback\").default\
local default = Rodux.combineReducers({\
\9actionBar = actionBarReducer,\
\9remoteLog = remoteLogReducer,\
\9tabGroup = tabGroupReducer,\
\9traceback = tracebackReducer,\
})\
return {\
\9default = default,\
}\
", '@'.."RemoteSpy.reducers")) setfenv(fn, _env("RemoteSpy.reducers")) return fn() end)

_module("action-bar", "ModuleScript", "RemoteSpy.reducers.action-bar", "RemoteSpy.reducers", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
for _k, _v in pairs(TS.import(script, script, \"actions\") or {}) do\
\9exports[_k] = _v\
end\
for _k, _v in pairs(TS.import(script, script, \"model\") or {}) do\
\9exports[_k] = _v\
end\
exports.default = TS.import(script, script, \"reducer\").default\
for _k, _v in pairs(TS.import(script, script, \"selectors\") or {}) do\
\9exports[_k] = _v\
end\
return exports\
", '@'.."RemoteSpy.reducers.action-bar")) setfenv(fn, _env("RemoteSpy.reducers.action-bar")) return fn() end)

_module("actions", "ModuleScript", "RemoteSpy.reducers.action-bar.actions", "RemoteSpy.reducers.action-bar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function setActionEnabled(id, enabled)\
\9return {\
\9\9type = \"SET_ACTION_ENABLED\",\
\9\9id = id,\
\9\9enabled = enabled,\
\9}\
end\
local function activateAction(id)\
\9return {\
\9\9type = \"ACTIVATE_ACTION\",\
\9\9id = id,\
\9}\
end\
local function deactivateAction(id)\
\9return {\
\9\9type = \"DEACTIVATE_ACTION\",\
\9\9id = id,\
\9}\
end\
return {\
\9setActionEnabled = setActionEnabled,\
\9activateAction = activateAction,\
\9deactivateAction = deactivateAction,\
}\
", '@'.."RemoteSpy.reducers.action-bar.actions")) setfenv(fn, _env("RemoteSpy.reducers.action-bar.actions")) return fn() end)

_module("model", "ModuleScript", "RemoteSpy.reducers.action-bar.model", "RemoteSpy.reducers.action-bar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
return nil\
", '@'.."RemoteSpy.reducers.action-bar.model")) setfenv(fn, _env("RemoteSpy.reducers.action-bar.model")) return fn() end)

_module("reducer", "ModuleScript", "RemoteSpy.reducers.action-bar.reducer", "RemoteSpy.reducers.action-bar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local initialState = {\
\9actions = {\
\9\9close = {\
\9\9\9id = \"close\",\
\9\9\9disabled = false,\
\9\9\9active = false,\
\9\9},\
\9\9navigatePrevious = {\
\9\9\9id = \"navigatePrevious\",\
\9\9\9disabled = true,\
\9\9\9active = false,\
\9\9},\
\9\9navigateNext = {\
\9\9\9id = \"navigateNext\",\
\9\9\9disabled = false,\
\9\9\9active = false,\
\9\9},\
\9\9copy = {\
\9\9\9id = \"copy\",\
\9\9\9disabled = true,\
\9\9\9active = false,\
\9\9},\
\9\9save = {\
\9\9\9id = \"save\",\
\9\9\9disabled = true,\
\9\9\9active = false,\
\9\9},\
\9\9delete = {\
\9\9\9id = \"delete\",\
\9\9\9disabled = true,\
\9\9\9active = false,\
\9\9},\
\9\9traceback = {\
\9\9\9id = \"traceback\",\
\9\9\9disabled = false,\
\9\9\9active = false,\
\9\9},\
\9\9copyPath = {\
\9\9\9id = \"copyPath\",\
\9\9\9disabled = false,\
\9\9\9active = false,\
\9\9},\
\9},\
}\
local function actionBarReducer(state, action)\
\9if state == nil then\
\9\9state = initialState\
\9end\
\9local _exp = action.type\
\9repeat\
\9\9if _exp == \"SET_ACTION_ENABLED\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"actions\"\
\9\9\9local _object_1 = {}\
\9\9\9for _k, _v in pairs(state.actions) do\
\9\9\9\9_object_1[_k] = _v\
\9\9\9end\
\9\9\9local _left_1 = action.id\
\9\9\9local _object_2 = {}\
\9\9\9for _k, _v in pairs(state.actions[action.id]) do\
\9\9\9\9_object_2[_k] = _v\
\9\9\9end\
\9\9\9_object_2.disabled = not action.enabled\
\9\9\9_object_1[_left_1] = _object_2\
\9\9\9_object[_left] = _object_1\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"ACTIVATE_ACTION\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"actions\"\
\9\9\9local _object_1 = {}\
\9\9\9for _k, _v in pairs(state.actions) do\
\9\9\9\9_object_1[_k] = _v\
\9\9\9end\
\9\9\9local _left_1 = action.id\
\9\9\9local _object_2 = {}\
\9\9\9for _k, _v in pairs(state.actions[action.id]) do\
\9\9\9\9_object_2[_k] = _v\
\9\9\9end\
\9\9\9_object_2.active = true\
\9\9\9_object_1[_left_1] = _object_2\
\9\9\9_object[_left] = _object_1\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"DEACTIVATE_ACTION\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"actions\"\
\9\9\9local _object_1 = {}\
\9\9\9for _k, _v in pairs(state.actions) do\
\9\9\9\9_object_1[_k] = _v\
\9\9\9end\
\9\9\9local _left_1 = action.id\
\9\9\9local _object_2 = {}\
\9\9\9for _k, _v in pairs(state.actions[action.id]) do\
\9\9\9\9_object_2[_k] = _v\
\9\9\9end\
\9\9\9_object_2.active = false\
\9\9\9_object_1[_left_1] = _object_2\
\9\9\9_object[_left] = _object_1\
\9\9\9return _object\
\9\9end\
\9\9return state\
\9until true\
end\
return {\
\9default = actionBarReducer,\
}\
", '@'.."RemoteSpy.reducers.action-bar.reducer")) setfenv(fn, _env("RemoteSpy.reducers.action-bar.reducer")) return fn() end)

_module("selectors", "ModuleScript", "RemoteSpy.reducers.action-bar.selectors", "RemoteSpy.reducers.action-bar", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local selectActionBarState = function(state)\
\9return state.actionBar.actions\
end\
local selectIsClosing = function(state)\
\9return state.actionBar.actions.close.active\
end\
local selectActionById = function(state, id)\
\9return state.actionBar.actions[id]\
end\
local selectActionIsActive = function(state, id)\
\9return state.actionBar.actions[id].active\
end\
local selectActionIsDisabled = function(state, id)\
\9return state.actionBar.actions[id].disabled\
end\
return {\
\9selectActionBarState = selectActionBarState,\
\9selectIsClosing = selectIsClosing,\
\9selectActionById = selectActionById,\
\9selectActionIsActive = selectActionIsActive,\
\9selectActionIsDisabled = selectActionIsDisabled,\
}\
", '@'.."RemoteSpy.reducers.action-bar.selectors")) setfenv(fn, _env("RemoteSpy.reducers.action-bar.selectors")) return fn() end)

_module("remote-log", "ModuleScript", "RemoteSpy.reducers.remote-log", "RemoteSpy.reducers", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
for _k, _v in pairs(TS.import(script, script, \"actions\") or {}) do\
\9exports[_k] = _v\
end\
for _k, _v in pairs(TS.import(script, script, \"model\") or {}) do\
\9exports[_k] = _v\
end\
exports.default = TS.import(script, script, \"reducer\").default\
for _k, _v in pairs(TS.import(script, script, \"utils\") or {}) do\
\9exports[_k] = _v\
end\
for _k, _v in pairs(TS.import(script, script, \"selectors\") or {}) do\
\9exports[_k] = _v\
end\
return exports\
", '@'.."RemoteSpy.reducers.remote-log")) setfenv(fn, _env("RemoteSpy.reducers.remote-log")) return fn() end)

_module("actions", "ModuleScript", "RemoteSpy.reducers.remote-log.actions", "RemoteSpy.reducers.remote-log", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function pushRemoteLog(log)\
\9return {\
\9\9type = \"PUSH_REMOTE_LOG\",\
\9\9log = log,\
\9}\
end\
local function removeRemoteLog(id)\
\9return {\
\9\9type = \"REMOVE_REMOTE_LOG\",\
\9\9id = id,\
\9}\
end\
local function pushOutgoingSignal(id, signal)\
\9return {\
\9\9type = \"PUSH_OUTGOING_SIGNAL\",\
\9\9id = id,\
\9\9signal = signal,\
\9}\
end\
local function removeOutgoingSignal(id, signalId)\
\9return {\
\9\9type = \"REMOVE_OUTGOING_SIGNAL\",\
\9\9id = id,\
\9\9signalId = signalId,\
\9}\
end\
local function clearOutgoingSignals(id)\
\9return {\
\9\9type = \"CLEAR_OUTGOING_SIGNALS\",\
\9\9id = id,\
\9}\
end\
local function setRemoteSelected(id)\
\9return {\
\9\9type = \"SET_REMOTE_SELECTED\",\
\9\9id = id,\
\9}\
end\
local function setSignalSelected(remote, id)\
\9return {\
\9\9type = \"SET_SIGNAL_SELECTED\",\
\9\9remote = remote,\
\9\9id = id,\
\9}\
end\
local function toggleSignalSelected(remote, id)\
\9return {\
\9\9type = \"TOGGLE_SIGNAL_SELECTED\",\
\9\9remote = remote,\
\9\9id = id,\
\9}\
end\
return {\
\9pushRemoteLog = pushRemoteLog,\
\9removeRemoteLog = removeRemoteLog,\
\9pushOutgoingSignal = pushOutgoingSignal,\
\9removeOutgoingSignal = removeOutgoingSignal,\
\9clearOutgoingSignals = clearOutgoingSignals,\
\9setRemoteSelected = setRemoteSelected,\
\9setSignalSelected = setSignalSelected,\
\9toggleSignalSelected = toggleSignalSelected,\
}\
", '@'.."RemoteSpy.reducers.remote-log.actions")) setfenv(fn, _env("RemoteSpy.reducers.remote-log.actions")) return fn() end)

_module("model", "ModuleScript", "RemoteSpy.reducers.remote-log.model", "RemoteSpy.reducers.remote-log", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
return nil\
", '@'.."RemoteSpy.reducers.remote-log.model")) setfenv(fn, _env("RemoteSpy.reducers.remote-log.model")) return fn() end)

_module("reducer", "ModuleScript", "RemoteSpy.reducers.remote-log.reducer", "RemoteSpy.reducers.remote-log", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local initialState = {\
\9logs = {},\
}\
local function remoteLogReducer(state, action)\
\9if state == nil then\
\9\9state = initialState\
\9end\
\9local _exp = action.type\
\9repeat\
\9\9if _exp == \"PUSH_REMOTE_LOG\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"logs\"\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9local _array_1 = state.logs\
\9\9\9local _Length = #_array_1\
\9\9\9table.move(_array_1, 1, _Length, _length + 1, _array)\
\9\9\9_length += _Length\
\9\9\9_array[_length + 1] = action.log\
\9\9\9_object[_left] = _array\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"REMOVE_REMOTE_LOG\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"logs\"\
\9\9\9local _logs = state.logs\
\9\9\9local _arg0 = function(log)\
\9\9\9\9return log.id ~= action.id\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.filter ▼\
\9\9\9local _newValue = {}\
\9\9\9local _length = 0\
\9\9\9for _k, _v in ipairs(_logs) do\
\9\9\9\9if _arg0(_v, _k - 1, _logs) == true then\
\9\9\9\9\9_length += 1\
\9\9\9\9\9_newValue[_length] = _v\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.filter ▲\
\9\9\9_object[_left] = _newValue\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"PUSH_OUTGOING_SIGNAL\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"logs\"\
\9\9\9local _logs = state.logs\
\9\9\9local _arg0 = function(log)\
\9\9\9\9if log.id == action.id then\
\9\9\9\9\9local _array = { action.signal }\
\9\9\9\9\9local _length = #_array\
\9\9\9\9\9local _array_1 = log.outgoing\
\9\9\9\9\9table.move(_array_1, 1, #_array_1, _length + 1, _array)\
\9\9\9\9\9local outgoing = _array\
\9\9\9\9\9if #outgoing > 80 then\
\9\9\9\9\9\9outgoing[#outgoing] = nil\
\9\9\9\9\9end\
\9\9\9\9\9local _object_1 = {}\
\9\9\9\9\9for _k, _v in pairs(log) do\
\9\9\9\9\9\9_object_1[_k] = _v\
\9\9\9\9\9end\
\9\9\9\9\9_object_1.outgoing = outgoing\
\9\9\9\9\9return _object_1\
\9\9\9\9end\
\9\9\9\9return log\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.map ▼\
\9\9\9local _newValue = table.create(#_logs)\
\9\9\9for _k, _v in ipairs(_logs) do\
\9\9\9\9_newValue[_k] = _arg0(_v, _k - 1, _logs)\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.map ▲\
\9\9\9_object[_left] = _newValue\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"REMOVE_OUTGOING_SIGNAL\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"logs\"\
\9\9\9local _logs = state.logs\
\9\9\9local _arg0 = function(log)\
\9\9\9\9if log.id == action.id then\
\9\9\9\9\9local _object_1 = {}\
\9\9\9\9\9for _k, _v in pairs(log) do\
\9\9\9\9\9\9_object_1[_k] = _v\
\9\9\9\9\9end\
\9\9\9\9\9local _left_1 = \"outgoing\"\
\9\9\9\9\9local _outgoing = log.outgoing\
\9\9\9\9\9local _arg0_1 = function(signal)\
\9\9\9\9\9\9return signal.id ~= action.signalId\
\9\9\9\9\9end\
\9\9\9\9\9-- ▼ ReadonlyArray.filter ▼\
\9\9\9\9\9local _newValue = {}\
\9\9\9\9\9local _length = 0\
\9\9\9\9\9for _k, _v in ipairs(_outgoing) do\
\9\9\9\9\9\9if _arg0_1(_v, _k - 1, _outgoing) == true then\
\9\9\9\9\9\9\9_length += 1\
\9\9\9\9\9\9\9_newValue[_length] = _v\
\9\9\9\9\9\9end\
\9\9\9\9\9end\
\9\9\9\9\9-- ▲ ReadonlyArray.filter ▲\
\9\9\9\9\9_object_1[_left_1] = _newValue\
\9\9\9\9\9return _object_1\
\9\9\9\9end\
\9\9\9\9return log\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.map ▼\
\9\9\9local _newValue = table.create(#_logs)\
\9\9\9for _k, _v in ipairs(_logs) do\
\9\9\9\9_newValue[_k] = _arg0(_v, _k - 1, _logs)\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.map ▲\
\9\9\9_object[_left] = _newValue\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"CLEAR_OUTGOING_SIGNALS\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"logs\"\
\9\9\9local _logs = state.logs\
\9\9\9local _arg0 = function(log)\
\9\9\9\9if log.id == action.id then\
\9\9\9\9\9local _object_1 = {}\
\9\9\9\9\9for _k, _v in pairs(log) do\
\9\9\9\9\9\9_object_1[_k] = _v\
\9\9\9\9\9end\
\9\9\9\9\9_object_1.outgoing = {}\
\9\9\9\9\9return _object_1\
\9\9\9\9end\
\9\9\9\9return log\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.map ▼\
\9\9\9local _newValue = table.create(#_logs)\
\9\9\9for _k, _v in ipairs(_logs) do\
\9\9\9\9_newValue[_k] = _arg0(_v, _k - 1, _logs)\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.map ▲\
\9\9\9_object[_left] = _newValue\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"SET_REMOTE_SELECTED\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9_object.remoteSelected = action.id\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"SET_SIGNAL_SELECTED\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9_object.signalSelected = action.id\
\9\9\9_object.remoteForSignalSelected = if action.id ~= nil then action.remote else nil\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"TOGGLE_SIGNAL_SELECTED\" then\
\9\9\9local signalSelected = if state.signalSelected == action.id then nil else action.id\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9_object.signalSelected = signalSelected\
\9\9\9_object.remoteForSignalSelected = if signalSelected ~= nil then action.remote else nil\
\9\9\9return _object\
\9\9end\
\9\9return state\
\9until true\
end\
return {\
\9default = remoteLogReducer,\
}\
", '@'.."RemoteSpy.reducers.remote-log.reducer")) setfenv(fn, _env("RemoteSpy.reducers.remote-log.reducer")) return fn() end)

_module("selectors", "ModuleScript", "RemoteSpy.reducers.remote-log.selectors", "RemoteSpy.reducers.remote-log", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local createSelector = TS.import(script, TS.getModule(script, \"@rbxts\", \"roselect\").src).createSelector\
local selectRemoteLogs = function(state)\
\9return state.remoteLog.logs\
end\
local selectRemoteLogIds = createSelector({ selectRemoteLogs }, function(logs)\
\9local _arg0 = function(log)\
\9\9return log.id\
\9end\
\9-- ▼ ReadonlyArray.map ▼\
\9local _newValue = table.create(#logs)\
\9for _k, _v in ipairs(logs) do\
\9\9_newValue[_k] = _arg0(_v, _k - 1, logs)\
\9end\
\9-- ▲ ReadonlyArray.map ▲\
\9return _newValue\
end)\
local selectRemoteLogsOutgoing = function(state)\
\9local _logs = state.remoteLog.logs\
\9local _arg0 = function(log)\
\9\9return log.outgoing\
\9end\
\9-- ▼ ReadonlyArray.map ▼\
\9local _newValue = table.create(#_logs)\
\9for _k, _v in ipairs(_logs) do\
\9\9_newValue[_k] = _arg0(_v, _k - 1, _logs)\
\9end\
\9-- ▲ ReadonlyArray.map ▲\
\9return _newValue\
end\
local selectRemoteIdSelected = function(state)\
\9return state.remoteLog.remoteSelected\
end\
local selectSignalIdSelected = function(state)\
\9return state.remoteLog.signalSelected\
end\
local selectSignalIdSelectedRemote = function(state)\
\9return state.remoteLog.remoteForSignalSelected\
end\
local makeSelectRemoteLog = function()\
\9return createSelector({ selectRemoteLogs, function(_, id)\
\9\9return id\
\9end }, function(logs, id)\
\9\9local _arg0 = function(log)\
\9\9\9return log.id == id\
\9\9end\
\9\9-- ▼ ReadonlyArray.find ▼\
\9\9local _result\
\9\9for _i, _v in ipairs(logs) do\
\9\9\9if _arg0(_v, _i - 1, logs) == true then\
\9\9\9\9_result = _v\
\9\9\9\9break\
\9\9\9end\
\9\9end\
\9\9-- ▲ ReadonlyArray.find ▲\
\9\9return _result\
\9end)\
end\
local makeSelectRemoteLogOutgoing = function()\
\9return createSelector({ makeSelectRemoteLog() }, function(log)\
\9\9local _result = log\
\9\9if _result ~= nil then\
\9\9\9_result = _result.outgoing\
\9\9end\
\9\9return _result\
\9end)\
end\
local makeSelectRemoteLogObject = function()\
\9return createSelector({ makeSelectRemoteLog() }, function(log)\
\9\9local _result = log\
\9\9if _result ~= nil then\
\9\9\9_result = _result.object\
\9\9end\
\9\9return _result\
\9end)\
end\
local makeSelectRemoteLogType = function()\
\9return createSelector({ makeSelectRemoteLog() }, function(log)\
\9\9local _result = log\
\9\9if _result ~= nil then\
\9\9\9_result = _result.type\
\9\9end\
\9\9return _result\
\9end)\
end\
local _selectOutgoing = makeSelectRemoteLogOutgoing()\
local selectSignalSelected = createSelector({ function(state)\
\9local _condition = selectSignalIdSelectedRemote(state)\
\9if _condition == nil then\
\9\9_condition = \"\"\
\9end\
\9return _selectOutgoing(state, _condition)\
end, selectSignalIdSelected }, function(outgoing, id)\
\9local _result\
\9if outgoing and id ~= nil then\
\9\9local _result_1 = outgoing\
\9\9if _result_1 ~= nil then\
\9\9\9local _arg0 = function(signal)\
\9\9\9\9return signal.id == id\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.find ▼\
\9\9\9local _result_2\
\9\9\9for _i, _v in ipairs(_result_1) do\
\9\9\9\9if _arg0(_v, _i - 1, _result_1) == true then\
\9\9\9\9\9_result_2 = _v\
\9\9\9\9\9break\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.find ▲\
\9\9\9_result_1 = _result_2\
\9\9end\
\9\9_result = _result_1\
\9else\
\9\9_result = nil\
\9end\
\9return _result\
end)\
return {\
\9selectRemoteLogs = selectRemoteLogs,\
\9selectRemoteLogIds = selectRemoteLogIds,\
\9selectRemoteLogsOutgoing = selectRemoteLogsOutgoing,\
\9selectRemoteIdSelected = selectRemoteIdSelected,\
\9selectSignalIdSelected = selectSignalIdSelected,\
\9selectSignalIdSelectedRemote = selectSignalIdSelectedRemote,\
\9makeSelectRemoteLog = makeSelectRemoteLog,\
\9makeSelectRemoteLogOutgoing = makeSelectRemoteLogOutgoing,\
\9makeSelectRemoteLogObject = makeSelectRemoteLogObject,\
\9makeSelectRemoteLogType = makeSelectRemoteLogType,\
\9selectSignalSelected = selectSignalSelected,\
}\
", '@'.."RemoteSpy.reducers.remote-log.selectors")) setfenv(fn, _env("RemoteSpy.reducers.remote-log.selectors")) return fn() end)

_module("utils", "ModuleScript", "RemoteSpy.reducers.remote-log.utils", "RemoteSpy.reducers.remote-log", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local TabType = TS.import(script, script.Parent.Parent, \"tab-group\").TabType\
local _instance_util = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"instance-util\")\
local getInstanceId = _instance_util.getInstanceId\
local getInstancePath = _instance_util.getInstancePath\
local stringifyFunctionSignature = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"function-util\").stringifyFunctionSignature\
local nextId = 0\
local function createRemoteLog(object, signal)\
\9local id = getInstanceId(object)\
\9local remoteType = if object:IsA(\"RemoteEvent\") then TabType.Event else TabType.Function\
\9return {\
\9\9id = id,\
\9\9object = object,\
\9\9type = remoteType,\
\9\9outgoing = if signal then { signal } else {},\
\9}\
end\
local function createOutgoingSignal(object, caller, callback, traceback, parameters, returns)\
\9local _object = {}\
\9local _left = \"id\"\
\9local _original = nextId\
\9nextId += 1\
\9_object[_left] = \"signal-\" .. tostring(_original)\
\9_object.remote = object\
\9_object.remoteId = getInstanceId(object)\
\9_object.name = object.Name\
\9_object.path = getInstancePath(object)\
\9_object.pathFmt = getInstancePath(object)\
\9_object.parameters = parameters\
\9_object.returns = returns\
\9_object.caller = caller\
\9_object.callback = callback\
\9_object.traceback = traceback\
\9return _object\
end\
local function stringifySignalTraceback(signal)\
\9local _exp = signal.traceback\
\9-- ▼ ReadonlyArray.map ▼\
\9local _newValue = table.create(#_exp)\
\9for _k, _v in ipairs(_exp) do\
\9\9_newValue[_k] = stringifyFunctionSignature(_v, _k - 1, _exp)\
\9end\
\9-- ▲ ReadonlyArray.map ▲\
\9local mapped = _newValue\
\9local length = #mapped\
\9do\
\9\9local i = 0\
\9\9local _shouldIncrement = false\
\9\9while true do\
\9\9\9if _shouldIncrement then\
\9\9\9\9i += 1\
\9\9\9else\
\9\9\9\9_shouldIncrement = true\
\9\9\9end\
\9\9\9if not (i < length / 2) then\
\9\9\9\9break\
\9\9\9end\
\9\9\9local temp = mapped[i + 1]\
\9\9\9mapped[i + 1] = mapped[length - i - 1 + 1]\
\9\9\9mapped[length - i - 1 + 1] = temp\
\9\9end\
\9end\
\9mapped[length - 1 + 1] = \"→ \" .. (mapped[length - 1 + 1] .. \" ←\")\
\9return mapped\
end\
return {\
\9createRemoteLog = createRemoteLog,\
\9createOutgoingSignal = createOutgoingSignal,\
\9stringifySignalTraceback = stringifySignalTraceback,\
}\
", '@'.."RemoteSpy.reducers.remote-log.utils")) setfenv(fn, _env("RemoteSpy.reducers.remote-log.utils")) return fn() end)

_module("tab-group", "ModuleScript", "RemoteSpy.reducers.tab-group", "RemoteSpy.reducers", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
for _k, _v in pairs(TS.import(script, script, \"actions\") or {}) do\
\9exports[_k] = _v\
end\
for _k, _v in pairs(TS.import(script, script, \"model\") or {}) do\
\9exports[_k] = _v\
end\
exports.default = TS.import(script, script, \"reducer\").default\
for _k, _v in pairs(TS.import(script, script, \"selectors\") or {}) do\
\9exports[_k] = _v\
end\
for _k, _v in pairs(TS.import(script, script, \"utils\") or {}) do\
\9exports[_k] = _v\
end\
return exports\
", '@'.."RemoteSpy.reducers.tab-group")) setfenv(fn, _env("RemoteSpy.reducers.tab-group")) return fn() end)

_module("actions", "ModuleScript", "RemoteSpy.reducers.tab-group.actions", "RemoteSpy.reducers.tab-group", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function pushTab(tab)\
\9return {\
\9\9type = \"PUSH_TAB\",\
\9\9tab = tab,\
\9}\
end\
local function deleteTab(id)\
\9return {\
\9\9type = \"DELETE_TAB\",\
\9\9id = id,\
\9}\
end\
local function moveTab(id, to)\
\9return {\
\9\9type = \"MOVE_TAB\",\
\9\9id = id,\
\9\9to = to,\
\9}\
end\
local function setActiveTab(id)\
\9return {\
\9\9type = \"SET_ACTIVE_TAB\",\
\9\9id = id,\
\9}\
end\
return {\
\9pushTab = pushTab,\
\9deleteTab = deleteTab,\
\9moveTab = moveTab,\
\9setActiveTab = setActiveTab,\
}\
", '@'.."RemoteSpy.reducers.tab-group.actions")) setfenv(fn, _env("RemoteSpy.reducers.tab-group.actions")) return fn() end)

_module("model", "ModuleScript", "RemoteSpy.reducers.tab-group.model", "RemoteSpy.reducers.tab-group", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TabType\
do\
\9local _inverse = {}\
\9TabType = setmetatable({}, {\
\9\9__index = _inverse,\
\9})\
\9TabType.Home = \"home\"\
\9_inverse.home = \"Home\"\
\9TabType.Event = \"event\"\
\9_inverse.event = \"Event\"\
\9TabType.Function = \"function\"\
\9_inverse[\"function\"] = \"Function\"\
\9TabType.Script = \"script\"\
\9_inverse.script = \"Script\"\
end\
return {\
\9TabType = TabType,\
}\
", '@'.."RemoteSpy.reducers.tab-group.model")) setfenv(fn, _env("RemoteSpy.reducers.tab-group.model")) return fn() end)

_module("reducer", "ModuleScript", "RemoteSpy.reducers.tab-group.reducer", "RemoteSpy.reducers.tab-group", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local TabType = TS.import(script, script.Parent, \"model\").TabType\
local createTabColumn = TS.import(script, script.Parent, \"utils\").createTabColumn\
local initialState = {\
\9tabs = { createTabColumn(\"home\", \"Home\", TabType.Home, false) },\
\9activeTab = \"home\",\
}\
local function tabGroupReducer(state, action)\
\9if state == nil then\
\9\9state = initialState\
\9end\
\9local _exp = action.type\
\9repeat\
\9\9if _exp == \"PUSH_TAB\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9local _left = \"tabs\"\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9local _array_1 = state.tabs\
\9\9\9local _Length = #_array_1\
\9\9\9table.move(_array_1, 1, _Length, _length + 1, _array)\
\9\9\9_length += _Length\
\9\9\9_array[_length + 1] = action.tab\
\9\9\9_object[_left] = _array\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"DELETE_TAB\" then\
\9\9\9local _tabs = state.tabs\
\9\9\9local _arg0 = function(tab)\
\9\9\9\9return tab.id == action.id\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.findIndex ▼\
\9\9\9local _result = -1\
\9\9\9for _i, _v in ipairs(_tabs) do\
\9\9\9\9if _arg0(_v, _i - 1, _tabs) == true then\
\9\9\9\9\9_result = _i - 1\
\9\9\9\9\9break\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.findIndex ▲\
\9\9\9local index = _result\
\9\9\9local _object = {}\
\9\9\9local _left = \"tabs\"\
\9\9\9local _tabs_1 = state.tabs\
\9\9\9local _arg0_1 = function(tab)\
\9\9\9\9return tab.id ~= action.id\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.filter ▼\
\9\9\9local _newValue = {}\
\9\9\9local _length = 0\
\9\9\9for _k, _v in ipairs(_tabs_1) do\
\9\9\9\9if _arg0_1(_v, _k - 1, _tabs_1) == true then\
\9\9\9\9\9_length += 1\
\9\9\9\9\9_newValue[_length] = _v\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.filter ▲\
\9\9\9_object[_left] = _newValue\
\9\9\9local _left_1 = \"activeTab\"\
\9\9\9local _result_1\
\9\9\9if state.activeTab == action.id then\
\9\9\9\9local _result_2 = state.tabs[index - 1 + 1]\
\9\9\9\9if _result_2 ~= nil then\
\9\9\9\9\9_result_2 = _result_2.id\
\9\9\9\9end\
\9\9\9\9local _condition = _result_2\
\9\9\9\9if _condition == nil then\
\9\9\9\9\9_condition = state.tabs[index + 1 + 1].id\
\9\9\9\9end\
\9\9\9\9_result_1 = _condition\
\9\9\9else\
\9\9\9\9_result_1 = state.activeTab\
\9\9\9end\
\9\9\9_object[_left_1] = _result_1\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"MOVE_TAB\" then\
\9\9\9local _tabs = state.tabs\
\9\9\9local _arg0 = function(tab)\
\9\9\9\9return tab.id == action.id\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.find ▼\
\9\9\9local _result\
\9\9\9for _i, _v in ipairs(_tabs) do\
\9\9\9\9if _arg0(_v, _i - 1, _tabs) == true then\
\9\9\9\9\9_result = _v\
\9\9\9\9\9break\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.find ▲\
\9\9\9local tab = _result\
\9\9\9local from = (table.find(state.tabs, tab) or 0) - 1\
\9\9\9local tabs = table.clone(state.tabs)\
\9\9\9table.remove(tabs, from + 1)\
\9\9\9local _to = action.to\
\9\9\9table.insert(tabs, _to + 1, tab)\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9_object.tabs = tabs\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"SET_ACTIVE_TAB\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9_object.activeTab = action.id\
\9\9\9return _object\
\9\9end\
\9\9return state\
\9until true\
end\
return {\
\9default = tabGroupReducer,\
}\
", '@'.."RemoteSpy.reducers.tab-group.reducer")) setfenv(fn, _env("RemoteSpy.reducers.tab-group.reducer")) return fn() end)

_module("selectors", "ModuleScript", "RemoteSpy.reducers.tab-group.selectors", "RemoteSpy.reducers.tab-group", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local createSelector = TS.import(script, TS.getModule(script, \"@rbxts\", \"roselect\").src).createSelector\
local getTabOffset = TS.import(script, script.Parent, \"utils\").getTabOffset\
local selectTabGroup = function(state)\
\9return state.tabGroup\
end\
local selectTabs = function(state)\
\9return state.tabGroup.tabs\
end\
local selectActiveTabId = function(state)\
\9return state.tabGroup.activeTab\
end\
local selectTabCount = function(state)\
\9return #state.tabGroup.tabs\
end\
local selectTab\
local selectActiveTab = function(state)\
\9return selectTab(state, state.tabGroup.activeTab)\
end\
selectTab = function(state, id)\
\9local _tabs = state.tabGroup.tabs\
\9local _arg0 = function(tab)\
\9\9return tab.id == id\
\9end\
\9-- ▼ ReadonlyArray.find ▼\
\9local _result\
\9for _i, _v in ipairs(_tabs) do\
\9\9if _arg0(_v, _i - 1, _tabs) == true then\
\9\9\9_result = _v\
\9\9\9break\
\9\9end\
\9end\
\9-- ▲ ReadonlyArray.find ▲\
\9return _result\
end\
local selectTabOrder = function(state, id)\
\9local _tabs = state.tabGroup.tabs\
\9local _arg0 = function(tab)\
\9\9return tab.id == id\
\9end\
\9-- ▼ ReadonlyArray.findIndex ▼\
\9local _result = -1\
\9for _i, _v in ipairs(_tabs) do\
\9\9if _arg0(_v, _i - 1, _tabs) == true then\
\9\9\9_result = _i - 1\
\9\9\9break\
\9\9end\
\9end\
\9-- ▲ ReadonlyArray.findIndex ▲\
\9return _result\
end\
local selectActiveTabOrder = function(state)\
\9local _tabs = state.tabGroup.tabs\
\9local _arg0 = function(tab)\
\9\9return tab.id == state.tabGroup.activeTab\
\9end\
\9-- ▼ ReadonlyArray.findIndex ▼\
\9local _result = -1\
\9for _i, _v in ipairs(_tabs) do\
\9\9if _arg0(_v, _i - 1, _tabs) == true then\
\9\9\9_result = _i - 1\
\9\9\9break\
\9\9end\
\9end\
\9-- ▲ ReadonlyArray.findIndex ▲\
\9return _result\
end\
local selectTabIsActive = function(state, id)\
\9return state.tabGroup.activeTab == id\
end\
local selectTabType = function(state, id)\
\9local _result = selectTab(state, id)\
\9if _result ~= nil then\
\9\9_result = _result.type\
\9end\
\9return _result\
end\
local makeSelectTabsBefore = function()\
\9local selectTabsBefore = createSelector({ selectTabs, selectTabOrder }, function(tabs, order)\
\9\9local _arg0 = function(_, index)\
\9\9\9return index < order\
\9\9end\
\9\9-- ▼ ReadonlyArray.filter ▼\
\9\9local _newValue = {}\
\9\9local _length = 0\
\9\9for _k, _v in ipairs(tabs) do\
\9\9\9if _arg0(_v, _k - 1, tabs) == true then\
\9\9\9\9_length += 1\
\9\9\9\9_newValue[_length] = _v\
\9\9\9end\
\9\9end\
\9\9-- ▲ ReadonlyArray.filter ▲\
\9\9return _newValue\
\9end)\
\9return selectTabsBefore\
end\
local makeSelectTabOffset = function()\
\9local selectTabOffset = createSelector({ makeSelectTabsBefore(), selectTab }, function(tabs, tab)\
\9\9if not tab then\
\9\9\9return 0\
\9\9end\
\9\9return getTabOffset(tabs, tab)\
\9end)\
\9return selectTabOffset\
end\
return {\
\9selectTabGroup = selectTabGroup,\
\9selectTabs = selectTabs,\
\9selectActiveTabId = selectActiveTabId,\
\9selectTabCount = selectTabCount,\
\9selectActiveTab = selectActiveTab,\
\9selectTab = selectTab,\
\9selectTabOrder = selectTabOrder,\
\9selectActiveTabOrder = selectActiveTabOrder,\
\9selectTabIsActive = selectTabIsActive,\
\9selectTabType = selectTabType,\
\9makeSelectTabsBefore = makeSelectTabsBefore,\
\9makeSelectTabOffset = makeSelectTabOffset,\
}\
", '@'.."RemoteSpy.reducers.tab-group.selectors")) setfenv(fn, _env("RemoteSpy.reducers.tab-group.selectors")) return fn() end)

_module("utils", "ModuleScript", "RemoteSpy.reducers.tab-group.utils", "RemoteSpy.reducers.tab-group", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local TextService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).TextService\
local MAX_TAB_CAPTION_WIDTH = 150\
local function createTabColumn(id, caption, tabType, canClose)\
\9if canClose == nil then\
\9\9canClose = true\
\9end\
\9return {\
\9\9id = id,\
\9\9caption = caption,\
\9\9type = tabType,\
\9\9canClose = canClose,\
\9}\
end\
local function getTabCaptionWidth(tab)\
\9local textSize = TextService:GetTextSize(tab.caption, 11, \"Gotham\", Vector2.new(300, 0))\
\9return math.min(textSize.X, MAX_TAB_CAPTION_WIDTH)\
end\
local function getTabWidth(tab)\
\9local captionWidth = getTabCaptionWidth(tab)\
\9local iconWidth = 16 + 6\
\9local closeWidth = if tab.canClose then 16 + 6 else 3\
\9return 8 + iconWidth + captionWidth + closeWidth + 8\
end\
local function getTabOffset(tabs, tab)\
\9local offset = 0\
\9for _, t in ipairs(tabs) do\
\9\9if t == tab then\
\9\9\9break\
\9\9end\
\9\9offset += getTabWidth(t)\
\9end\
\9return offset\
end\
return {\
\9createTabColumn = createTabColumn,\
\9getTabCaptionWidth = getTabCaptionWidth,\
\9getTabWidth = getTabWidth,\
\9getTabOffset = getTabOffset,\
\9MAX_TAB_CAPTION_WIDTH = MAX_TAB_CAPTION_WIDTH,\
}\
", '@'.."RemoteSpy.reducers.tab-group.utils")) setfenv(fn, _env("RemoteSpy.reducers.tab-group.utils")) return fn() end)

_module("traceback", "ModuleScript", "RemoteSpy.reducers.traceback", "RemoteSpy.reducers", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local exports = {}\
for _k, _v in pairs(TS.import(script, script, \"actions\") or {}) do\
\9exports[_k] = _v\
end\
for _k, _v in pairs(TS.import(script, script, \"model\") or {}) do\
\9exports[_k] = _v\
end\
for _k, _v in pairs(TS.import(script, script, \"selectors\") or {}) do\
\9exports[_k] = _v\
end\
exports.default = TS.import(script, script, \"reducer\").default\
return exports\
", '@'.."RemoteSpy.reducers.traceback")) setfenv(fn, _env("RemoteSpy.reducers.traceback")) return fn() end)

_module("actions", "ModuleScript", "RemoteSpy.reducers.traceback.actions", "RemoteSpy.reducers.traceback", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function setTracebackCallStack(callStack)\
\9return {\
\9\9type = \"SET_TRACEBACK_CALL_STACK\",\
\9\9callStack = callStack,\
\9}\
end\
local function clearTraceback()\
\9return {\
\9\9type = \"CLEAR_TRACEBACK\",\
\9}\
end\
return {\
\9setTracebackCallStack = setTracebackCallStack,\
\9clearTraceback = clearTraceback,\
}\
", '@'.."RemoteSpy.reducers.traceback.actions")) setfenv(fn, _env("RemoteSpy.reducers.traceback.actions")) return fn() end)

_module("model", "ModuleScript", "RemoteSpy.reducers.traceback.model", "RemoteSpy.reducers.traceback", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
return nil\
", '@'.."RemoteSpy.reducers.traceback.model")) setfenv(fn, _env("RemoteSpy.reducers.traceback.model")) return fn() end)

_module("reducer", "ModuleScript", "RemoteSpy.reducers.traceback.reducer", "RemoteSpy.reducers.traceback", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local initialState = {\
\9callStack = {},\
}\
local function tracebackReducer(state, action)\
\9if state == nil then\
\9\9state = initialState\
\9end\
\9local _exp = action.type\
\9repeat\
\9\9if _exp == \"SET_TRACEBACK_CALL_STACK\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9_object.callStack = action.callStack\
\9\9\9return _object\
\9\9end\
\9\9if _exp == \"CLEAR_TRACEBACK\" then\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(state) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9_object.callStack = {}\
\9\9\9return _object\
\9\9end\
\9\9return state\
\9until true\
end\
return {\
\9default = tracebackReducer,\
}\
", '@'.."RemoteSpy.reducers.traceback.reducer")) setfenv(fn, _env("RemoteSpy.reducers.traceback.reducer")) return fn() end)

_module("selectors", "ModuleScript", "RemoteSpy.reducers.traceback.selectors", "RemoteSpy.reducers.traceback", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.Parent.include.RuntimeLib)\
local createSelector = TS.import(script, TS.getModule(script, \"@rbxts\", \"roselect\").src).createSelector\
local _function_util = TS.import(script, script.Parent.Parent.Parent, \"utils\", \"function-util\")\
local describeFunction = _function_util.describeFunction\
local getFunctionScript = _function_util.getFunctionScript\
local selectTracebackState = function(state)\
\9return state.traceback\
end\
local selectTracebackCallStack = function(state)\
\9return state.traceback.callStack\
end\
local selectTracebackByString = createSelector({ selectTracebackState, function(_, searchString)\
\9return searchString\
end }, function(traceback, searchString)\
\9local _callStack = traceback.callStack\
\9local _arg0 = function(callback)\
\9\9local description = describeFunction(callback)\
\9\9local creator = getFunctionScript(callback)\
\9\9return (string.find(description.name, searchString)) ~= nil or (string.find(tostring(creator), searchString)) ~= nil\
\9end\
\9-- ▼ ReadonlyArray.filter ▼\
\9local _newValue = {}\
\9local _length = 0\
\9for _k, _v in ipairs(_callStack) do\
\9\9if _arg0(_v, _k - 1, _callStack) == true then\
\9\9\9_length += 1\
\9\9\9_newValue[_length] = _v\
\9\9end\
\9end\
\9-- ▲ ReadonlyArray.filter ▲\
\9return _newValue\
end)\
return {\
\9selectTracebackState = selectTracebackState,\
\9selectTracebackCallStack = selectTracebackCallStack,\
\9selectTracebackByString = selectTracebackByString,\
}\
", '@'.."RemoteSpy.reducers.traceback.selectors")) setfenv(fn, _env("RemoteSpy.reducers.traceback.selectors")) return fn() end)

_module("store", "ModuleScript", "RemoteSpy.store", "RemoteSpy", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.include.RuntimeLib)\
local Rodux = TS.import(script, TS.getModule(script, \"@rbxts\", \"rodux\").src)\
local rootReducer = TS.import(script, script.Parent, \"reducers\").default\
local store\
local isDestructed = false\
local function createStore()\
\9return Rodux.Store.new(rootReducer, nil)\
end\
local function configureStore()\
\9if store then\
\9\9return store\
\9end\
\9store = createStore()\
\9return store\
end\
local function destruct()\
\9if isDestructed then\
\9\9return nil\
\9end\
\9isDestructed = true\
\9store:destruct()\
end\
local function isActive()\
\9return store and not isDestructed\
end\
local function dispatch(action)\
\9if isDestructed then\
\9\9return nil\
\9end\
\9return configureStore():dispatch(action)\
end\
local function get(selector)\
\9if isDestructed then\
\9\9return nil\
\9end\
\9local store = configureStore()\
\9return if selector then selector(store:getState()) else store:getState()\
end\
local function changed(selector, callback)\
\9if isDestructed then\
\9\9return nil\
\9end\
\9local store = configureStore()\
\9local lastState = selector(store:getState())\
\9task.defer(callback, lastState)\
\9return store.changed:connect(function(state)\
\9\9local newState = selector(state)\
\9\9if lastState ~= newState then\
\9\9\9local _fn = task\
\9\9\9lastState = newState\
\9\9\9_fn.spawn(callback, lastState)\
\9\9end\
\9end)\
end\
return {\
\9configureStore = configureStore,\
\9destruct = destruct,\
\9isActive = isActive,\
\9dispatch = dispatch,\
\9get = get,\
\9changed = changed,\
}\
", '@'.."RemoteSpy.store")) setfenv(fn, _env("RemoteSpy.store")) return fn() end)

_instance("utils", "Folder", "RemoteSpy.utils", "RemoteSpy")

_module("codify", "ModuleScript", "RemoteSpy.utils.codify", "RemoteSpy.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = require(script.Parent.Parent.include.RuntimeLib)\
local getInstancePath = TS.import(script, script.Parent, \"instance-util\").getInstancePath\
local codifyTableFlat, codifyTable, codify\
local transformers = {\
\9table = function(value, level)\
\9\9return if level == -1 then codifyTableFlat(value) else codifyTable(value, level + 1)\
\9end,\
\9string = function(value)\
\9\9return string.format(\"%q\", (string.gsub(value, \"\\n\", \"\\\\n\")))\
\9end,\
\9number = function(value)\
\9\9return tostring(value)\
\9end,\
\9boolean = function(value)\
\9\9return tostring(value)\
\9end,\
\9Instance = function(value)\
\9\9return getInstancePath(value)\
\9end,\
\9BrickColor = function(value)\
\9\9return 'BrickColor.new(\"' .. (value.Name .. '\")')\
\9end,\
\9Color3 = function(value)\
\9\9return \"Color3.new(\" .. (tostring(value.R) .. (\", \" .. (tostring(value.G) .. (\", \" .. (tostring(value.B) .. \")\")))))\
\9end,\
\9ColorSequenceKeypoint = function(value)\
\9\9return \"ColorSequenceKeypoint.new(\" .. (tostring(value.Time) .. (\", \" .. (codify(value.Value) .. \")\")))\
\9end,\
\9ColorSequence = function(value)\
\9\9return \"ColorSequence.new(\" .. (codify(value.Keypoints) .. \")\")\
\9end,\
\9NumberRange = function(value)\
\9\9return \"NumberRange.new(\" .. (tostring(value.Min) .. (\", \" .. (tostring(value.Max) .. \")\")))\
\9end,\
\9NumberSequenceKeypoint = function(value)\
\9\9return \"NumberSequenceKeypoint.new(\" .. (tostring(value.Time) .. (\", \" .. (codify(value.Value) .. \")\")))\
\9end,\
\9NumberSequence = function(value)\
\9\9return \"NumberSequence.new(\" .. (codify(value.Keypoints) .. \")\")\
\9end,\
\9Vector3 = function(value)\
\9\9return \"Vector3.new(\" .. (tostring(value.X) .. (\", \" .. (tostring(value.Y) .. (\", \" .. (tostring(value.Z) .. \")\")))))\
\9end,\
\9Vector2 = function(value)\
\9\9return \"Vector2.new(\" .. (tostring(value.X) .. (\", \" .. (tostring(value.Y) .. \")\")))\
\9end,\
\9UDim2 = function(value)\
\9\9return \"UDim2.new(\" .. (tostring(value.X.Scale) .. (\", \" .. (tostring(value.X.Offset) .. (\", \" .. (tostring(value.Y.Scale) .. (\", \" .. (tostring(value.Y.Offset) .. \")\")))))))\
\9end,\
\9Ray = function(value)\
\9\9return \"Ray.new(\" .. (codify(value.Origin) .. (\", \" .. (codify(value.Direction) .. \")\")))\
\9end,\
\9CFrame = function(value)\
\9\9return \"CFrame.new(\" .. (table.concat({ value:GetComponents() }, \", \") .. \")\")\
\9end,\
}\
function codify(value, level)\
\9if level == nil then\
\9\9level = 0\
\9end\
\9local transformer = transformers[typeof(value)]\
\9if transformer then\
\9\9return transformer(value, level)\
\9else\
\9\9return tostring(value) .. (\" --[[\" .. (typeof(value) .. \" not supported]]\"))\
\9end\
end\
function codifyTable(object, level)\
\9if level == nil then\
\9\9level = 0\
\9end\
\9local lines = {}\
\9local indent = string.rep(\"\9\", level + 1)\
\9for key, value in pairs(object) do\
\9\9if type(value) == \"function\" or type(value) == \"thread\" then\
\9\9\9continue\
\9\9end\
\9\9local _arg0 = indent .. (\"[\" .. (codify(key, level) .. (\"] = \" .. codify(value, level))))\
\9\9table.insert(lines, _arg0)\
\9end\
\9if #lines == 0 then\
\9\9return \"{}\"\
\9end\
\9return \"{\\n\" .. (table.concat(lines, \",\\n\") .. (\"\\n\" .. (string.sub(indent, 1, -2) .. \"}\")))\
end\
function codifyTableFlat(object)\
\9local lines = {}\
\9for key, value in pairs(object) do\
\9\9if type(value) == \"function\" or type(value) == \"thread\" then\
\9\9\9continue\
\9\9end\
\9\9local _arg0 = \"[\" .. (codify(key, -1) .. (\"] = \" .. codify(value, -1)))\
\9\9table.insert(lines, _arg0)\
\9end\
\9if #lines == 0 then\
\9\9return \"{}\"\
\9end\
\9return \"{ \" .. (table.concat(lines, \", \") .. \" }\")\
end\
return {\
\9codify = codify,\
\9codifyTable = codifyTable,\
\9codifyTableFlat = codifyTableFlat,\
}\
", '@'.."RemoteSpy.utils.codify")) setfenv(fn, _env("RemoteSpy.utils.codify")) return fn() end)

_module("format-escapes", "ModuleScript", "RemoteSpy.utils.format-escapes", "RemoteSpy.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function formatEscapes(str)\
\9return (string.gsub(str, \"[\\n\\r\\t]+\", \" \"))\
end\
return {\
\9formatEscapes = formatEscapes,\
}\
", '@'.."RemoteSpy.utils.format-escapes")) setfenv(fn, _env("RemoteSpy.utils.format-escapes")) return fn() end)

_module("function-util", "ModuleScript", "RemoteSpy.utils.function-util", "RemoteSpy.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function describeFunction(fn)\
\9if debug.getinfo then\
\9\9local info = debug.getinfo(fn)\
\9\9local _object = {\
\9\9\9name = if info.name == \"\" or info.name == nil then \"(anonymous)\" else info.name,\
\9\9\9source = info.short_src,\
\9\9}\
\9\9local _left = \"parameters\"\
\9\9local _condition = info.numparams\
\9\9if _condition == nil then\
\9\9\9_condition = 0\
\9\9end\
\9\9_object[_left] = _condition\
\9\9_object.variadic = if info.is_vararg == 1 then true else false\
\9\9return _object\
\9end\
\9local name = debug.info(fn, \"n\")\
\9local source = debug.info(fn, \"s\")\
\9local parameters, variadic = debug.info(fn, \"a\")\
\9return {\
\9\9name = if name == \"\" or name == nil then \"(anonymous)\" else name,\
\9\9source = source,\
\9\9parameters = parameters,\
\9\9variadic = variadic,\
\9}\
end\
local function getFunctionScript(fn)\
\9return rawget(getfenv(fn), \"script\")\
end\
local function stringifyFunctionSignature(fn)\
\9local description = describeFunction(fn)\
\9local params = {}\
\9do\
\9\9local i = 0\
\9\9local _shouldIncrement = false\
\9\9while true do\
\9\9\9if _shouldIncrement then\
\9\9\9\9i += 1\
\9\9\9else\
\9\9\9\9_shouldIncrement = true\
\9\9\9end\
\9\9\9if not (i < description.parameters) then\
\9\9\9\9break\
\9\9\9end\
\9\9\9local _arg0 = string.char((string.byte(\"A\")) + i)\
\9\9\9table.insert(params, _arg0)\
\9\9end\
\9end\
\9if description.variadic then\
\9\9table.insert(params, \"...\")\
\9end\
\9return description.name .. (\"(\" .. (table.concat(params, \", \") .. \")\"))\
end\
return {\
\9describeFunction = describeFunction,\
\9getFunctionScript = getFunctionScript,\
\9stringifyFunctionSignature = stringifyFunctionSignature,\
}\
", '@'.."RemoteSpy.utils.function-util")) setfenv(fn, _env("RemoteSpy.utils.function-util")) return fn() end)

_module("global-util", "ModuleScript", "RemoteSpy.utils.global-util", "RemoteSpy.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local globals = if getgenv then getgenv() else {}\
local function getGlobals()\
\9return globals\
end\
local function setGlobal(key, value)\
\9globals[key] = value\
end\
local function getGlobal(key)\
\9return globals[key]\
end\
local function hasGlobal(key)\
\9return globals[key] ~= nil\
end\
return {\
\9getGlobals = getGlobals,\
\9setGlobal = setGlobal,\
\9getGlobal = getGlobal,\
\9hasGlobal = hasGlobal,\
}\
", '@'.."RemoteSpy.utils.global-util")) setfenv(fn, _env("RemoteSpy.utils.global-util")) return fn() end)

_module("instance-util", "ModuleScript", "RemoteSpy.utils.instance-util", "RemoteSpy.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local idsByObject = {}\
local objectsById = {}\
local nextId = 0\
local hasSpecialCharacters = function(str)\
\9return (string.match(str, \"[a-zA-Z0-9_]+\")) ~= str\
end\
local function getInstanceId(object)\
\9if not (idsByObject[object] ~= nil) then\
\9\9local _original = nextId\
\9\9nextId += 1\
\9\9local id = \"instance-\" .. tostring(_original)\
\9\9idsByObject[object] = id\
\9\9objectsById[id] = object\
\9end\
\9return idsByObject[object]\
end\
local function getInstanceFromId(id)\
\9return objectsById[id]\
end\
local function getInstancePath(object)\
\9local path = \"\"\
\9local current = object\
\9local isInDataModel = false\
\9repeat\
\9\9do\
\9\9\9if current == game then\
\9\9\9\9path = \"game\" .. path\
\9\9\9\9isInDataModel = true\
\9\9\9elseif current.Parent == game then\
\9\9\9\9path = \":GetService(\" .. (string.format(\"%q\", current.ClassName) .. (\")\" .. path))\
\9\9\9else\
\9\9\9\9path = if hasSpecialCharacters(current.Name) then \"[\" .. (string.format(\"%q\", current.Name) .. (\"]\" .. path)) else \".\" .. (current.Name .. path)\
\9\9\9end\
\9\9\9current = current.Parent\
\9\9end\
\9until not current\
\9if not isInDataModel then\
\9\9path = \"(nil)\" .. path\
\9end\
\9path = string.gsub(path, '^game:GetService%(\"Workspace\"%)', \"workspace\")\
\9return path\
end\
return {\
\9getInstanceId = getInstanceId,\
\9getInstanceFromId = getInstanceFromId,\
\9getInstancePath = getInstancePath,\
}\
", '@'.."RemoteSpy.utils.instance-util")) setfenv(fn, _env("RemoteSpy.utils.instance-util")) return fn() end)

_module("number-util", "ModuleScript", "RemoteSpy.utils.number-util", "RemoteSpy.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function map(n, min0, max0, min1, max1)\
\9return min1 + ((n - min0) * (max1 - min1)) / (max0 - min0)\
end\
local function mapStrict(n, min0, max0, min1, max1)\
\9return math.clamp(min1 + ((n - min0) * (max1 - min1)) / (max0 - min0), min1, max1)\
end\
local function lerp(a, b, t)\
\9return a + (b - a) * t\
end\
local function multiply(n, ...)\
\9local args = { ... }\
\9local _arg0 = function(a, b)\
\9\9return 1 - (1 - a) * (1 - b)\
\9end\
\9-- ▼ ReadonlyArray.reduce ▼\
\9local _result = n\
\9local _callback = _arg0\
\9for _i = 1, #args do\
\9\9_result = _callback(_result, args[_i], _i - 1, args)\
\9end\
\9-- ▲ ReadonlyArray.reduce ▲\
\9return _result\
end\
return {\
\9map = map,\
\9mapStrict = mapStrict,\
\9lerp = lerp,\
\9multiply = multiply,\
}\
", '@'.."RemoteSpy.utils.number-util")) setfenv(fn, _env("RemoteSpy.utils.number-util")) return fn() end)

_instance("include", "Folder", "RemoteSpy.include", "RemoteSpy")

_module("Promise", "ModuleScript", "RemoteSpy.include.Promise", "RemoteSpy.include", function () local fn = assert(loadstring("--[[\
\9An implementation of Promises similar to Promise/A+.\
]]\
\
local ERROR_NON_PROMISE_IN_LIST = \"Non-promise value passed into %s at index %s\"\
local ERROR_NON_LIST = \"Please pass a list of promises to %s\"\
local ERROR_NON_FUNCTION = \"Please pass a handler function to %s!\"\
local MODE_KEY_METATABLE = { __mode = \"k\" }\
\
local function isCallable(value)\
\9if type(value) == \"function\" then\
\9\9return true\
\9end\
\
\9if type(value) == \"table\" then\
\9\9local metatable = getmetatable(value)\
\9\9if metatable and type(rawget(metatable, \"__call\")) == \"function\" then\
\9\9\9return true\
\9\9end\
\9end\
\
\9return false\
end\
\
--[[\
\9Creates an enum dictionary with some metamethods to prevent common mistakes.\
]]\
local function makeEnum(enumName, members)\
\9local enum = {}\
\
\9for _, memberName in ipairs(members) do\
\9\9enum[memberName] = memberName\
\9end\
\
\9return setmetatable(enum, {\
\9\9__index = function(_, k)\
\9\9\9error(string.format(\"%s is not in %s!\", k, enumName), 2)\
\9\9end,\
\9\9__newindex = function()\
\9\9\9error(string.format(\"Creating new members in %s is not allowed!\", enumName), 2)\
\9\9end,\
\9})\
end\
\
--[=[\
\9An object to represent runtime errors that occur during execution.\
\9Promises that experience an error like this will be rejected with\
\9an instance of this object.\
\
\9@class Error\
]=]\
local Error\
do\
\9Error = {\
\9\9Kind = makeEnum(\"Promise.Error.Kind\", {\
\9\9\9\"ExecutionError\",\
\9\9\9\"AlreadyCancelled\",\
\9\9\9\"NotResolvedInTime\",\
\9\9\9\"TimedOut\",\
\9\9}),\
\9}\
\9Error.__index = Error\
\
\9function Error.new(options, parent)\
\9\9options = options or {}\
\9\9return setmetatable({\
\9\9\9error = tostring(options.error) or \"[This error has no error text.]\",\
\9\9\9trace = options.trace,\
\9\9\9context = options.context,\
\9\9\9kind = options.kind,\
\9\9\9parent = parent,\
\9\9\9createdTick = os.clock(),\
\9\9\9createdTrace = debug.traceback(),\
\9\9}, Error)\
\9end\
\
\9function Error.is(anything)\
\9\9if type(anything) == \"table\" then\
\9\9\9local metatable = getmetatable(anything)\
\
\9\9\9if type(metatable) == \"table\" then\
\9\9\9\9return rawget(anything, \"error\") ~= nil and type(rawget(metatable, \"extend\")) == \"function\"\
\9\9\9end\
\9\9end\
\
\9\9return false\
\9end\
\
\9function Error.isKind(anything, kind)\
\9\9assert(kind ~= nil, \"Argument #2 to Promise.Error.isKind must not be nil\")\
\
\9\9return Error.is(anything) and anything.kind == kind\
\9end\
\
\9function Error:extend(options)\
\9\9options = options or {}\
\
\9\9options.kind = options.kind or self.kind\
\
\9\9return Error.new(options, self)\
\9end\
\
\9function Error:getErrorChain()\
\9\9local runtimeErrors = { self }\
\
\9\9while runtimeErrors[#runtimeErrors].parent do\
\9\9\9table.insert(runtimeErrors, runtimeErrors[#runtimeErrors].parent)\
\9\9end\
\
\9\9return runtimeErrors\
\9end\
\
\9function Error:__tostring()\
\9\9local errorStrings = {\
\9\9\9string.format(\"-- Promise.Error(%s) --\", self.kind or \"?\"),\
\9\9}\
\
\9\9for _, runtimeError in ipairs(self:getErrorChain()) do\
\9\9\9table.insert(\
\9\9\9\9errorStrings,\
\9\9\9\9table.concat({\
\9\9\9\9\9runtimeError.trace or runtimeError.error,\
\9\9\9\9\9runtimeError.context,\
\9\9\9\9}, \"\\n\")\
\9\9\9)\
\9\9end\
\
\9\9return table.concat(errorStrings, \"\\n\")\
\9end\
end\
\
--[[\
\9Packs a number of arguments into a table and returns its length.\
\
\9Used to cajole varargs without dropping sparse values.\
]]\
local function pack(...)\
\9return select(\"#\", ...), { ... }\
end\
\
--[[\
\9Returns first value (success), and packs all following values.\
]]\
local function packResult(success, ...)\
\9return success, select(\"#\", ...), { ... }\
end\
\
local function makeErrorHandler(traceback)\
\9assert(traceback ~= nil, \"traceback is nil\")\
\
\9return function(err)\
\9\9-- If the error object is already a table, forward it directly.\
\9\9-- Should we extend the error here and add our own trace?\
\
\9\9if type(err) == \"table\" then\
\9\9\9return err\
\9\9end\
\
\9\9return Error.new({\
\9\9\9error = err,\
\9\9\9kind = Error.Kind.ExecutionError,\
\9\9\9trace = debug.traceback(tostring(err), 2),\
\9\9\9context = \"Promise created at:\\n\\n\" .. traceback,\
\9\9})\
\9end\
end\
\
--[[\
\9Calls a Promise executor with error handling.\
]]\
local function runExecutor(traceback, callback, ...)\
\9return packResult(xpcall(callback, makeErrorHandler(traceback), ...))\
end\
\
--[[\
\9Creates a function that invokes a callback with correct error handling and\
\9resolution mechanisms.\
]]\
local function createAdvancer(traceback, callback, resolve, reject)\
\9return function(...)\
\9\9local ok, resultLength, result = runExecutor(traceback, callback, ...)\
\
\9\9if ok then\
\9\9\9resolve(unpack(result, 1, resultLength))\
\9\9else\
\9\9\9reject(result[1])\
\9\9end\
\9end\
end\
\
local function isEmpty(t)\
\9return next(t) == nil\
end\
\
--[=[\
\9An enum value used to represent the Promise's status.\
\9@interface Status\
\9@tag enum\
\9@within Promise\
\9.Started \"Started\" -- The Promise is executing, and not settled yet.\
\9.Resolved \"Resolved\" -- The Promise finished successfully.\
\9.Rejected \"Rejected\" -- The Promise was rejected.\
\9.Cancelled \"Cancelled\" -- The Promise was cancelled before it finished.\
]=]\
--[=[\
\9@prop Status Status\
\9@within Promise\
\9@readonly\
\9@tag enums\
\9A table containing all members of the `Status` enum, e.g., `Promise.Status.Resolved`.\
]=]\
--[=[\
\9A Promise is an object that represents a value that will exist in the future, but doesn't right now.\
\9Promises allow you to then attach callbacks that can run once the value becomes available (known as *resolving*),\
\9or if an error has occurred (known as *rejecting*).\
\
\9@class Promise\
\9@__index prototype\
]=]\
local Promise = {\
\9Error = Error,\
\9Status = makeEnum(\"Promise.Status\", { \"Started\", \"Resolved\", \"Rejected\", \"Cancelled\" }),\
\9_getTime = os.clock,\
\9_timeEvent = game:GetService(\"RunService\").Heartbeat,\
\9_unhandledRejectionCallbacks = {},\
}\
Promise.prototype = {}\
Promise.__index = Promise.prototype\
\
function Promise._new(traceback, callback, parent)\
\9if parent ~= nil and not Promise.is(parent) then\
\9\9error(\"Argument #2 to Promise.new must be a promise or nil\", 2)\
\9end\
\
\9local self = {\
\9\9-- Used to locate where a promise was created\
\9\9_source = traceback,\
\
\9\9_status = Promise.Status.Started,\
\
\9\9-- A table containing a list of all results, whether success or failure.\
\9\9-- Only valid if _status is set to something besides Started\
\9\9_values = nil,\
\
\9\9-- Lua doesn't like sparse arrays very much, so we explicitly store the\
\9\9-- length of _values to handle middle nils.\
\9\9_valuesLength = -1,\
\
\9\9-- Tracks if this Promise has no error observers..\
\9\9_unhandledRejection = true,\
\
\9\9-- Queues representing functions we should invoke when we update!\
\9\9_queuedResolve = {},\
\9\9_queuedReject = {},\
\9\9_queuedFinally = {},\
\
\9\9-- The function to run when/if this promise is cancelled.\
\9\9_cancellationHook = nil,\
\
\9\9-- The \"parent\" of this promise in a promise chain. Required for\
\9\9-- cancellation propagation upstream.\
\9\9_parent = parent,\
\
\9\9-- Consumers are Promises that have chained onto this one.\
\9\9-- We track them for cancellation propagation downstream.\
\9\9_consumers = setmetatable({}, MODE_KEY_METATABLE),\
\9}\
\
\9if parent and parent._status == Promise.Status.Started then\
\9\9parent._consumers[self] = true\
\9end\
\
\9setmetatable(self, Promise)\
\
\9local function resolve(...)\
\9\9self:_resolve(...)\
\9end\
\
\9local function reject(...)\
\9\9self:_reject(...)\
\9end\
\
\9local function onCancel(cancellationHook)\
\9\9if cancellationHook then\
\9\9\9if self._status == Promise.Status.Cancelled then\
\9\9\9\9cancellationHook()\
\9\9\9else\
\9\9\9\9self._cancellationHook = cancellationHook\
\9\9\9end\
\9\9end\
\
\9\9return self._status == Promise.Status.Cancelled\
\9end\
\
\9coroutine.wrap(function()\
\9\9local ok, _, result = runExecutor(self._source, callback, resolve, reject, onCancel)\
\
\9\9if not ok then\
\9\9\9reject(result[1])\
\9\9end\
\9end)()\
\
\9return self\
end\
\
--[=[\
\9Construct a new Promise that will be resolved or rejected with the given callbacks.\
\
\9If you `resolve` with a Promise, it will be chained onto.\
\
\9You can safely yield within the executor function and it will not block the creating thread.\
\
\9```lua\
\9local myFunction()\
\9\9return Promise.new(function(resolve, reject, onCancel)\
\9\9\9wait(1)\
\9\9\9resolve(\"Hello world!\")\
\9\9end)\
\9end\
\
\9myFunction():andThen(print)\
\9```\
\
\9You do not need to use `pcall` within a Promise. Errors that occur during execution will be caught and turned into a rejection automatically. If `error()` is called with a table, that table will be the rejection value. Otherwise, string errors will be converted into `Promise.Error(Promise.Error.Kind.ExecutionError)` objects for tracking debug information.\
\
\9You may register an optional cancellation hook by using the `onCancel` argument:\
\
\9* This should be used to abort any ongoing operations leading up to the promise being settled.\
\9* Call the `onCancel` function with a function callback as its only argument to set a hook which will in turn be called when/if the promise is cancelled.\
\9* `onCancel` returns `true` if the Promise was already cancelled when you called `onCancel`.\
\9* Calling `onCancel` with no argument will not override a previously set cancellation hook, but it will still return `true` if the Promise is currently cancelled.\
\9* You can set the cancellation hook at any time before resolving.\
\9* When a promise is cancelled, calls to `resolve` or `reject` will be ignored, regardless of if you set a cancellation hook or not.\
\
\9@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()\
\9@return Promise\
]=]\
function Promise.new(executor)\
\9return Promise._new(debug.traceback(nil, 2), executor)\
end\
\
function Promise:__tostring()\
\9return string.format(\"Promise(%s)\", self._status)\
end\
\
--[=[\
\9The same as [Promise.new](/api/Promise#new), except execution begins after the next `Heartbeat` event.\
\
\9This is a spiritual replacement for `spawn`, but it does not suffer from the same [issues](https://eryn.io/gist/3db84579866c099cdd5bb2ff37947cec) as `spawn`.\
\
\9```lua\
\9local function waitForChild(instance, childName, timeout)\
\9  return Promise.defer(function(resolve, reject)\
\9\9local child = instance:WaitForChild(childName, timeout)\
\
\9\9;(child and resolve or reject)(child)\
\9  end)\
\9end\
\9```\
\
\9@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()\
\9@return Promise\
]=]\
function Promise.defer(executor)\
\9local traceback = debug.traceback(nil, 2)\
\9local promise\
\9promise = Promise._new(traceback, function(resolve, reject, onCancel)\
\9\9local connection\
\9\9connection = Promise._timeEvent:Connect(function()\
\9\9\9connection:Disconnect()\
\9\9\9local ok, _, result = runExecutor(traceback, executor, resolve, reject, onCancel)\
\
\9\9\9if not ok then\
\9\9\9\9reject(result[1])\
\9\9\9end\
\9\9end)\
\9end)\
\
\9return promise\
end\
\
-- Backwards compatibility\
Promise.async = Promise.defer\
\
--[=[\
\9Creates an immediately resolved Promise with the given value.\
\
\9```lua\
\9-- Example using Promise.resolve to deliver cached values:\
\9function getSomething(name)\
\9\9if cache[name] then\
\9\9\9return Promise.resolve(cache[name])\
\9\9else\
\9\9\9return Promise.new(function(resolve, reject)\
\9\9\9\9local thing = getTheThing()\
\9\9\9\9cache[name] = thing\
\
\9\9\9\9resolve(thing)\
\9\9\9end)\
\9\9end\
\9end\
\9```\
\
\9@param ... any\
\9@return Promise<...any>\
]=]\
function Promise.resolve(...)\
\9local length, values = pack(...)\
\9return Promise._new(debug.traceback(nil, 2), function(resolve)\
\9\9resolve(unpack(values, 1, length))\
\9end)\
end\
\
--[=[\
\9Creates an immediately rejected Promise with the given value.\
\
\9:::caution\
\9Something needs to consume this rejection (i.e. `:catch()` it), otherwise it will emit an unhandled Promise rejection warning on the next frame. Thus, you should not create and store rejected Promises for later use. Only create them on-demand as needed.\
\9:::\
\
\9@param ... any\
\9@return Promise<...any>\
]=]\
function Promise.reject(...)\
\9local length, values = pack(...)\
\9return Promise._new(debug.traceback(nil, 2), function(_, reject)\
\9\9reject(unpack(values, 1, length))\
\9end)\
end\
\
--[[\
\9Runs a non-promise-returning function as a Promise with the\
  given arguments.\
]]\
function Promise._try(traceback, callback, ...)\
\9local valuesLength, values = pack(...)\
\
\9return Promise._new(traceback, function(resolve)\
\9\9resolve(callback(unpack(values, 1, valuesLength)))\
\9end)\
end\
\
--[=[\
\9Begins a Promise chain, calling a function and returning a Promise resolving with its return value. If the function errors, the returned Promise will be rejected with the error. You can safely yield within the Promise.try callback.\
\
\9:::info\
\9`Promise.try` is similar to [Promise.promisify](#promisify), except the callback is invoked immediately instead of returning a new function.\
\9:::\
\
\9```lua\
\9Promise.try(function()\
\9\9return math.random(1, 2) == 1 and \"ok\" or error(\"Oh an error!\")\
\9end)\
\9\9:andThen(function(text)\
\9\9\9print(text)\
\9\9end)\
\9\9:catch(function(err)\
\9\9\9warn(\"Something went wrong\")\
\9\9end)\
\9```\
\
\9@param callback (...: T...) -> ...any\
\9@param ... T... -- Additional arguments passed to `callback`\
\9@return Promise\
]=]\
function Promise.try(callback, ...)\
\9return Promise._try(debug.traceback(nil, 2), callback, ...)\
end\
\
--[[\
\9Returns a new promise that:\
\9\9* is resolved when all input promises resolve\
\9\9* is rejected if ANY input promises reject\
]]\
function Promise._all(traceback, promises, amount)\
\9if type(promises) ~= \"table\" then\
\9\9error(string.format(ERROR_NON_LIST, \"Promise.all\"), 3)\
\9end\
\
\9-- We need to check that each value is a promise here so that we can produce\
\9-- a proper error rather than a rejected promise with our error.\
\9for i, promise in pairs(promises) do\
\9\9if not Promise.is(promise) then\
\9\9\9error(string.format(ERROR_NON_PROMISE_IN_LIST, \"Promise.all\", tostring(i)), 3)\
\9\9end\
\9end\
\
\9-- If there are no values then return an already resolved promise.\
\9if #promises == 0 or amount == 0 then\
\9\9return Promise.resolve({})\
\9end\
\
\9return Promise._new(traceback, function(resolve, reject, onCancel)\
\9\9-- An array to contain our resolved values from the given promises.\
\9\9local resolvedValues = {}\
\9\9local newPromises = {}\
\
\9\9-- Keep a count of resolved promises because just checking the resolved\
\9\9-- values length wouldn't account for promises that resolve with nil.\
\9\9local resolvedCount = 0\
\9\9local rejectedCount = 0\
\9\9local done = false\
\
\9\9local function cancel()\
\9\9\9for _, promise in ipairs(newPromises) do\
\9\9\9\9promise:cancel()\
\9\9\9end\
\9\9end\
\
\9\9-- Called when a single value is resolved and resolves if all are done.\
\9\9local function resolveOne(i, ...)\
\9\9\9if done then\
\9\9\9\9return\
\9\9\9end\
\
\9\9\9resolvedCount = resolvedCount + 1\
\
\9\9\9if amount == nil then\
\9\9\9\9resolvedValues[i] = ...\
\9\9\9else\
\9\9\9\9resolvedValues[resolvedCount] = ...\
\9\9\9end\
\
\9\9\9if resolvedCount >= (amount or #promises) then\
\9\9\9\9done = true\
\9\9\9\9resolve(resolvedValues)\
\9\9\9\9cancel()\
\9\9\9end\
\9\9end\
\
\9\9onCancel(cancel)\
\
\9\9-- We can assume the values inside `promises` are all promises since we\
\9\9-- checked above.\
\9\9for i, promise in ipairs(promises) do\
\9\9\9newPromises[i] = promise:andThen(function(...)\
\9\9\9\9resolveOne(i, ...)\
\9\9\9end, function(...)\
\9\9\9\9rejectedCount = rejectedCount + 1\
\
\9\9\9\9if amount == nil or #promises - rejectedCount < amount then\
\9\9\9\9\9cancel()\
\9\9\9\9\9done = true\
\
\9\9\9\9\9reject(...)\
\9\9\9\9end\
\9\9\9end)\
\9\9end\
\
\9\9if done then\
\9\9\9cancel()\
\9\9end\
\9end)\
end\
\
--[=[\
\9Accepts an array of Promises and returns a new promise that:\
\9* is resolved after all input promises resolve.\
\9* is rejected if *any* input promises reject.\
\
\9:::info\
\9Only the first return value from each promise will be present in the resulting array.\
\9:::\
\
\9After any input Promise rejects, all other input Promises that are still pending will be cancelled if they have no other consumers.\
\
\9```lua\
\9local promises = {\
\9\9returnsAPromise(\"example 1\"),\
\9\9returnsAPromise(\"example 2\"),\
\9\9returnsAPromise(\"example 3\"),\
\9}\
\
\9return Promise.all(promises)\
\9```\
\
\9@param promises {Promise<T>}\
\9@return Promise<{T}>\
]=]\
function Promise.all(promises)\
\9return Promise._all(debug.traceback(nil, 2), promises)\
end\
\
--[=[\
\9Folds an array of values or promises into a single value. The array is traversed sequentially.\
\
\9The reducer function can return a promise or value directly. Each iteration receives the resolved value from the previous, and the first receives your defined initial value.\
\
\9The folding will stop at the first rejection encountered.\
\9```lua\
\9local basket = {\"blueberry\", \"melon\", \"pear\", \"melon\"}\
\9Promise.fold(basket, function(cost, fruit)\
\9\9if fruit == \"blueberry\" then\
\9\9\9return cost -- blueberries are free!\
\9\9else\
\9\9\9-- call a function that returns a promise with the fruit price\
\9\9\9return fetchPrice(fruit):andThen(function(fruitCost)\
\9\9\9\9return cost + fruitCost\
\9\9\9end)\
\9\9end\
\9end, 0)\
\9```\
\
\9@since v3.1.0\
\9@param list {T | Promise<T>}\
\9@param reducer (accumulator: U, value: T, index: number) -> U | Promise<U>\
\9@param initialValue U\
]=]\
function Promise.fold(list, reducer, initialValue)\
\9assert(type(list) == \"table\", \"Bad argument #1 to Promise.fold: must be a table\")\
\9assert(isCallable(reducer), \"Bad argument #2 to Promise.fold: must be a function\")\
\
\9local accumulator = Promise.resolve(initialValue)\
\9return Promise.each(list, function(resolvedElement, i)\
\9\9accumulator = accumulator:andThen(function(previousValueResolved)\
\9\9\9return reducer(previousValueResolved, resolvedElement, i)\
\9\9end)\
\9end):andThen(function()\
\9\9return accumulator\
\9end)\
end\
\
--[=[\
\9Accepts an array of Promises and returns a Promise that is resolved as soon as `count` Promises are resolved from the input array. The resolved array values are in the order that the Promises resolved in. When this Promise resolves, all other pending Promises are cancelled if they have no other consumers.\
\
\9`count` 0 results in an empty array. The resultant array will never have more than `count` elements.\
\
\9```lua\
\9local promises = {\
\9\9returnsAPromise(\"example 1\"),\
\9\9returnsAPromise(\"example 2\"),\
\9\9returnsAPromise(\"example 3\"),\
\9}\
\
\9return Promise.some(promises, 2) -- Only resolves with first 2 promises to resolve\
\9```\
\
\9@param promises {Promise<T>}\
\9@param count number\
\9@return Promise<{T}>\
]=]\
function Promise.some(promises, count)\
\9assert(type(count) == \"number\", \"Bad argument #2 to Promise.some: must be a number\")\
\
\9return Promise._all(debug.traceback(nil, 2), promises, count)\
end\
\
--[=[\
\9Accepts an array of Promises and returns a Promise that is resolved as soon as *any* of the input Promises resolves. It will reject only if *all* input Promises reject. As soon as one Promises resolves, all other pending Promises are cancelled if they have no other consumers.\
\
\9Resolves directly with the value of the first resolved Promise. This is essentially [[Promise.some]] with `1` count, except the Promise resolves with the value directly instead of an array with one element.\
\
\9```lua\
\9local promises = {\
\9\9returnsAPromise(\"example 1\"),\
\9\9returnsAPromise(\"example 2\"),\
\9\9returnsAPromise(\"example 3\"),\
\9}\
\
\9return Promise.any(promises) -- Resolves with first value to resolve (only rejects if all 3 rejected)\
\9```\
\
\9@param promises {Promise<T>}\
\9@return Promise<T>\
]=]\
function Promise.any(promises)\
\9return Promise._all(debug.traceback(nil, 2), promises, 1):andThen(function(values)\
\9\9return values[1]\
\9end)\
end\
\
--[=[\
\9Accepts an array of Promises and returns a new Promise that resolves with an array of in-place Statuses when all input Promises have settled. This is equivalent to mapping `promise:finally` over the array of Promises.\
\
\9```lua\
\9local promises = {\
\9\9returnsAPromise(\"example 1\"),\
\9\9returnsAPromise(\"example 2\"),\
\9\9returnsAPromise(\"example 3\"),\
\9}\
\
\9return Promise.allSettled(promises)\
\9```\
\
\9@param promises {Promise<T>}\
\9@return Promise<{Status}>\
]=]\
function Promise.allSettled(promises)\
\9if type(promises) ~= \"table\" then\
\9\9error(string.format(ERROR_NON_LIST, \"Promise.allSettled\"), 2)\
\9end\
\
\9-- We need to check that each value is a promise here so that we can produce\
\9-- a proper error rather than a rejected promise with our error.\
\9for i, promise in pairs(promises) do\
\9\9if not Promise.is(promise) then\
\9\9\9error(string.format(ERROR_NON_PROMISE_IN_LIST, \"Promise.allSettled\", tostring(i)), 2)\
\9\9end\
\9end\
\
\9-- If there are no values then return an already resolved promise.\
\9if #promises == 0 then\
\9\9return Promise.resolve({})\
\9end\
\
\9return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)\
\9\9-- An array to contain our resolved values from the given promises.\
\9\9local fates = {}\
\9\9local newPromises = {}\
\
\9\9-- Keep a count of resolved promises because just checking the resolved\
\9\9-- values length wouldn't account for promises that resolve with nil.\
\9\9local finishedCount = 0\
\
\9\9-- Called when a single value is resolved and resolves if all are done.\
\9\9local function resolveOne(i, ...)\
\9\9\9finishedCount = finishedCount + 1\
\
\9\9\9fates[i] = ...\
\
\9\9\9if finishedCount >= #promises then\
\9\9\9\9resolve(fates)\
\9\9\9end\
\9\9end\
\
\9\9onCancel(function()\
\9\9\9for _, promise in ipairs(newPromises) do\
\9\9\9\9promise:cancel()\
\9\9\9end\
\9\9end)\
\
\9\9-- We can assume the values inside `promises` are all promises since we\
\9\9-- checked above.\
\9\9for i, promise in ipairs(promises) do\
\9\9\9newPromises[i] = promise:finally(function(...)\
\9\9\9\9resolveOne(i, ...)\
\9\9\9end)\
\9\9end\
\9end)\
end\
\
--[=[\
\9Accepts an array of Promises and returns a new promise that is resolved or rejected as soon as any Promise in the array resolves or rejects.\
\
\9:::warning\
\9If the first Promise to settle from the array settles with a rejection, the resulting Promise from `race` will reject.\
\
\9If you instead want to tolerate rejections, and only care about at least one Promise resolving, you should use [Promise.any](#any) or [Promise.some](#some) instead.\
\9:::\
\
\9All other Promises that don't win the race will be cancelled if they have no other consumers.\
\
\9```lua\
\9local promises = {\
\9\9returnsAPromise(\"example 1\"),\
\9\9returnsAPromise(\"example 2\"),\
\9\9returnsAPromise(\"example 3\"),\
\9}\
\
\9return Promise.race(promises) -- Only returns 1st value to resolve or reject\
\9```\
\
\9@param promises {Promise<T>}\
\9@return Promise<T>\
]=]\
function Promise.race(promises)\
\9assert(type(promises) == \"table\", string.format(ERROR_NON_LIST, \"Promise.race\"))\
\
\9for i, promise in pairs(promises) do\
\9\9assert(Promise.is(promise), string.format(ERROR_NON_PROMISE_IN_LIST, \"Promise.race\", tostring(i)))\
\9end\
\
\9return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)\
\9\9local newPromises = {}\
\9\9local finished = false\
\
\9\9local function cancel()\
\9\9\9for _, promise in ipairs(newPromises) do\
\9\9\9\9promise:cancel()\
\9\9\9end\
\9\9end\
\
\9\9local function finalize(callback)\
\9\9\9return function(...)\
\9\9\9\9cancel()\
\9\9\9\9finished = true\
\9\9\9\9return callback(...)\
\9\9\9end\
\9\9end\
\
\9\9if onCancel(finalize(reject)) then\
\9\9\9return\
\9\9end\
\
\9\9for i, promise in ipairs(promises) do\
\9\9\9newPromises[i] = promise:andThen(finalize(resolve), finalize(reject))\
\9\9end\
\
\9\9if finished then\
\9\9\9cancel()\
\9\9end\
\9end)\
end\
\
--[=[\
\9Iterates serially over the given an array of values, calling the predicate callback on each value before continuing.\
\
\9If the predicate returns a Promise, we wait for that Promise to resolve before moving on to the next item\
\9in the array.\
\
\9:::info\
\9`Promise.each` is similar to `Promise.all`, except the Promises are ran in order instead of all at once.\
\
\9But because Promises are eager, by the time they are created, they're already running. Thus, we need a way to defer creation of each Promise until a later time.\
\
\9The predicate function exists as a way for us to operate on our data instead of creating a new closure for each Promise. If you would prefer, you can pass in an array of functions, and in the predicate, call the function and return its return value.\
\9:::\
\
\9```lua\
\9Promise.each({\
\9\9\"foo\",\
\9\9\"bar\",\
\9\9\"baz\",\
\9\9\"qux\"\
\9}, function(value, index)\
\9\9return Promise.delay(1):andThen(function()\
\9\9print((\"%d) Got %s!\"):format(index, value))\
\9\9end)\
\9end)\
\
\9--[[\
\9\9(1 second passes)\
\9\9> 1) Got foo!\
\9\9(1 second passes)\
\9\9> 2) Got bar!\
\9\9(1 second passes)\
\9\9> 3) Got baz!\
\9\9(1 second passes)\
\9\9> 4) Got qux!\
\9]]\
\9```\
\
\9If the Promise a predicate returns rejects, the Promise from `Promise.each` is also rejected with the same value.\
\
\9If the array of values contains a Promise, when we get to that point in the list, we wait for the Promise to resolve before calling the predicate with the value.\
\
\9If a Promise in the array of values is already Rejected when `Promise.each` is called, `Promise.each` rejects with that value immediately (the predicate callback will never be called even once). If a Promise in the list is already Cancelled when `Promise.each` is called, `Promise.each` rejects with `Promise.Error(Promise.Error.Kind.AlreadyCancelled`). If a Promise in the array of values is Started at first, but later rejects, `Promise.each` will reject with that value and iteration will not continue once iteration encounters that value.\
\
\9Returns a Promise containing an array of the returned/resolved values from the predicate for each item in the array of values.\
\
\9If this Promise returned from `Promise.each` rejects or is cancelled for any reason, the following are true:\
\9- Iteration will not continue.\
\9- Any Promises within the array of values will now be cancelled if they have no other consumers.\
\9- The Promise returned from the currently active predicate will be cancelled if it hasn't resolved yet.\
\
\9@since 3.0.0\
\9@param list {T | Promise<T>}\
\9@param predicate (value: T, index: number) -> U | Promise<U>\
\9@return Promise<{U}>\
]=]\
function Promise.each(list, predicate)\
\9assert(type(list) == \"table\", string.format(ERROR_NON_LIST, \"Promise.each\"))\
\9assert(isCallable(predicate), string.format(ERROR_NON_FUNCTION, \"Promise.each\"))\
\
\9return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)\
\9\9local results = {}\
\9\9local promisesToCancel = {}\
\
\9\9local cancelled = false\
\
\9\9local function cancel()\
\9\9\9for _, promiseToCancel in ipairs(promisesToCancel) do\
\9\9\9\9promiseToCancel:cancel()\
\9\9\9end\
\9\9end\
\
\9\9onCancel(function()\
\9\9\9cancelled = true\
\
\9\9\9cancel()\
\9\9end)\
\
\9\9-- We need to preprocess the list of values and look for Promises.\
\9\9-- If we find some, we must register our andThen calls now, so that those Promises have a consumer\
\9\9-- from us registered. If we don't do this, those Promises might get cancelled by something else\
\9\9-- before we get to them in the series because it's not possible to tell that we plan to use it\
\9\9-- unless we indicate it here.\
\
\9\9local preprocessedList = {}\
\
\9\9for index, value in ipairs(list) do\
\9\9\9if Promise.is(value) then\
\9\9\9\9if value:getStatus() == Promise.Status.Cancelled then\
\9\9\9\9\9cancel()\
\9\9\9\9\9return reject(Error.new({\
\9\9\9\9\9\9error = \"Promise is cancelled\",\
\9\9\9\9\9\9kind = Error.Kind.AlreadyCancelled,\
\9\9\9\9\9\9context = string.format(\
\9\9\9\9\9\9\9\"The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\\n\\nThat Promise was created at:\\n\\n%s\",\
\9\9\9\9\9\9\9index,\
\9\9\9\9\9\9\9value._source\
\9\9\9\9\9\9),\
\9\9\9\9\9}))\
\9\9\9\9elseif value:getStatus() == Promise.Status.Rejected then\
\9\9\9\9\9cancel()\
\9\9\9\9\9return reject(select(2, value:await()))\
\9\9\9\9end\
\
\9\9\9\9-- Chain a new Promise from this one so we only cancel ours\
\9\9\9\9local ourPromise = value:andThen(function(...)\
\9\9\9\9\9return ...\
\9\9\9\9end)\
\
\9\9\9\9table.insert(promisesToCancel, ourPromise)\
\9\9\9\9preprocessedList[index] = ourPromise\
\9\9\9else\
\9\9\9\9preprocessedList[index] = value\
\9\9\9end\
\9\9end\
\
\9\9for index, value in ipairs(preprocessedList) do\
\9\9\9if Promise.is(value) then\
\9\9\9\9local success\
\9\9\9\9success, value = value:await()\
\
\9\9\9\9if not success then\
\9\9\9\9\9cancel()\
\9\9\9\9\9return reject(value)\
\9\9\9\9end\
\9\9\9end\
\
\9\9\9if cancelled then\
\9\9\9\9return\
\9\9\9end\
\
\9\9\9local predicatePromise = Promise.resolve(predicate(value, index))\
\
\9\9\9table.insert(promisesToCancel, predicatePromise)\
\
\9\9\9local success, result = predicatePromise:await()\
\
\9\9\9if not success then\
\9\9\9\9cancel()\
\9\9\9\9return reject(result)\
\9\9\9end\
\
\9\9\9results[index] = result\
\9\9end\
\
\9\9resolve(results)\
\9end)\
end\
\
--[=[\
\9Checks whether the given object is a Promise via duck typing. This only checks if the object is a table and has an `andThen` method.\
\
\9@param object any\
\9@return boolean -- `true` if the given `object` is a Promise.\
]=]\
function Promise.is(object)\
\9if type(object) ~= \"table\" then\
\9\9return false\
\9end\
\
\9local objectMetatable = getmetatable(object)\
\
\9if objectMetatable == Promise then\
\9\9-- The Promise came from this library.\
\9\9return true\
\9elseif objectMetatable == nil then\
\9\9-- No metatable, but we should still chain onto tables with andThen methods\
\9\9return isCallable(object.andThen)\
\9elseif\
\9\9type(objectMetatable) == \"table\"\
\9\9and type(rawget(objectMetatable, \"__index\")) == \"table\"\
\9\9and isCallable(rawget(rawget(objectMetatable, \"__index\"), \"andThen\"))\
\9then\
\9\9-- Maybe this came from a different or older Promise library.\
\9\9return true\
\9end\
\
\9return false\
end\
\
--[=[\
\9Wraps a function that yields into one that returns a Promise.\
\
\9Any errors that occur while executing the function will be turned into rejections.\
\
\9:::info\
\9`Promise.promisify` is similar to [Promise.try](#try), except the callback is returned as a callable function instead of being invoked immediately.\
\9:::\
\
\9```lua\
\9local sleep = Promise.promisify(wait)\
\
\9sleep(1):andThen(print)\
\9```\
\
\9```lua\
\9local isPlayerInGroup = Promise.promisify(function(player, groupId)\
\9\9return player:IsInGroup(groupId)\
\9end)\
\9```\
\
\9@param callback (...: any) -> ...any\
\9@return (...: any) -> Promise\
]=]\
function Promise.promisify(callback)\
\9return function(...)\
\9\9return Promise._try(debug.traceback(nil, 2), callback, ...)\
\9end\
end\
\
--[=[\
\9Returns a Promise that resolves after `seconds` seconds have passed. The Promise resolves with the actual amount of time that was waited.\
\
\9This function is **not** a wrapper around `wait`. `Promise.delay` uses a custom scheduler which provides more accurate timing. As an optimization, cancelling this Promise instantly removes the task from the scheduler.\
\
\9:::warning\
\9Passing `NaN`, infinity, or a number less than 1/60 is equivalent to passing 1/60.\
\9:::\
\
\9```lua\
\9\9Promise.delay(5):andThenCall(print, \"This prints after 5 seconds\")\
\9```\
\
\9@function delay\
\9@within Promise\
\9@param seconds number\
\9@return Promise<number>\
]=]\
do\
\9-- uses a sorted doubly linked list (queue) to achieve O(1) remove operations and O(n) for insert\
\
\9-- the initial node in the linked list\
\9local first\
\9local connection\
\
\9function Promise.delay(seconds)\
\9\9assert(type(seconds) == \"number\", \"Bad argument #1 to Promise.delay, must be a number.\")\
\9\9-- If seconds is -INF, INF, NaN, or less than 1 / 60, assume seconds is 1 / 60.\
\9\9-- This mirrors the behavior of wait()\
\9\9if not (seconds >= 1 / 60) or seconds == math.huge then\
\9\9\9seconds = 1 / 60\
\9\9end\
\
\9\9return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)\
\9\9\9local startTime = Promise._getTime()\
\9\9\9local endTime = startTime + seconds\
\
\9\9\9local node = {\
\9\9\9\9resolve = resolve,\
\9\9\9\9startTime = startTime,\
\9\9\9\9endTime = endTime,\
\9\9\9}\
\
\9\9\9if connection == nil then -- first is nil when connection is nil\
\9\9\9\9first = node\
\9\9\9\9connection = Promise._timeEvent:Connect(function()\
\9\9\9\9\9local threadStart = Promise._getTime()\
\
\9\9\9\9\9while first ~= nil and first.endTime < threadStart do\
\9\9\9\9\9\9local current = first\
\9\9\9\9\9\9first = current.next\
\
\9\9\9\9\9\9if first == nil then\
\9\9\9\9\9\9\9connection:Disconnect()\
\9\9\9\9\9\9\9connection = nil\
\9\9\9\9\9\9else\
\9\9\9\9\9\9\9first.previous = nil\
\9\9\9\9\9\9end\
\
\9\9\9\9\9\9current.resolve(Promise._getTime() - current.startTime)\
\9\9\9\9\9end\
\9\9\9\9end)\
\9\9\9else -- first is non-nil\
\9\9\9\9if first.endTime < endTime then -- if `node` should be placed after `first`\
\9\9\9\9\9-- we will insert `node` between `current` and `next`\
\9\9\9\9\9-- (i.e. after `current` if `next` is nil)\
\9\9\9\9\9local current = first\
\9\9\9\9\9local next = current.next\
\
\9\9\9\9\9while next ~= nil and next.endTime < endTime do\
\9\9\9\9\9\9current = next\
\9\9\9\9\9\9next = current.next\
\9\9\9\9\9end\
\
\9\9\9\9\9-- `current` must be non-nil, but `next` could be `nil` (i.e. last item in list)\
\9\9\9\9\9current.next = node\
\9\9\9\9\9node.previous = current\
\
\9\9\9\9\9if next ~= nil then\
\9\9\9\9\9\9node.next = next\
\9\9\9\9\9\9next.previous = node\
\9\9\9\9\9end\
\9\9\9\9else\
\9\9\9\9\9-- set `node` to `first`\
\9\9\9\9\9node.next = first\
\9\9\9\9\9first.previous = node\
\9\9\9\9\9first = node\
\9\9\9\9end\
\9\9\9end\
\
\9\9\9onCancel(function()\
\9\9\9\9-- remove node from queue\
\9\9\9\9local next = node.next\
\
\9\9\9\9if first == node then\
\9\9\9\9\9if next == nil then -- if `node` is the first and last\
\9\9\9\9\9\9connection:Disconnect()\
\9\9\9\9\9\9connection = nil\
\9\9\9\9\9else -- if `node` is `first` and not the last\
\9\9\9\9\9\9next.previous = nil\
\9\9\9\9\9end\
\9\9\9\9\9first = next\
\9\9\9\9else\
\9\9\9\9\9local previous = node.previous\
\9\9\9\9\9-- since `node` is not `first`, then we know `previous` is non-nil\
\9\9\9\9\9previous.next = next\
\
\9\9\9\9\9if next ~= nil then\
\9\9\9\9\9\9next.previous = previous\
\9\9\9\9\9end\
\9\9\9\9end\
\9\9\9end)\
\9\9end)\
\9end\
end\
\
--[=[\
\9Returns a new Promise that resolves if the chained Promise resolves within `seconds` seconds, or rejects if execution time exceeds `seconds`. The chained Promise will be cancelled if the timeout is reached.\
\
\9Rejects with `rejectionValue` if it is non-nil. If a `rejectionValue` is not given, it will reject with a `Promise.Error(Promise.Error.Kind.TimedOut)`. This can be checked with [[Error.isKind]].\
\
\9```lua\
\9getSomething():timeout(5):andThen(function(something)\
\9\9-- got something and it only took at max 5 seconds\
\9end):catch(function(e)\
\9\9-- Either getting something failed or the time was exceeded.\
\
\9\9if Promise.Error.isKind(e, Promise.Error.Kind.TimedOut) then\
\9\9\9warn(\"Operation timed out!\")\
\9\9else\
\9\9\9warn(\"Operation encountered an error!\")\
\9\9end\
\9end)\
\9```\
\
\9Sugar for:\
\
\9```lua\
\9Promise.race({\
\9\9Promise.delay(seconds):andThen(function()\
\9\9\9return Promise.reject(\
\9\9\9\9rejectionValue == nil\
\9\9\9\9and Promise.Error.new({ kind = Promise.Error.Kind.TimedOut })\
\9\9\9\9or rejectionValue\
\9\9\9)\
\9\9end),\
\9\9promise\
\9})\
\9```\
\
\9@param seconds number\
\9@param rejectionValue? any -- The value to reject with if the timeout is reached\
\9@return Promise\
]=]\
function Promise.prototype:timeout(seconds, rejectionValue)\
\9local traceback = debug.traceback(nil, 2)\
\
\9return Promise.race({\
\9\9Promise.delay(seconds):andThen(function()\
\9\9\9return Promise.reject(rejectionValue == nil and Error.new({\
\9\9\9\9kind = Error.Kind.TimedOut,\
\9\9\9\9error = \"Timed out\",\
\9\9\9\9context = string.format(\
\9\9\9\9\9\"Timeout of %d seconds exceeded.\\n:timeout() called at:\\n\\n%s\",\
\9\9\9\9\9seconds,\
\9\9\9\9\9traceback\
\9\9\9\9),\
\9\9\9}) or rejectionValue)\
\9\9end),\
\9\9self,\
\9})\
end\
\
--[=[\
\9Returns the current Promise status.\
\
\9@return Status\
]=]\
function Promise.prototype:getStatus()\
\9return self._status\
end\
\
--[[\
\9Creates a new promise that receives the result of this promise.\
\
\9The given callbacks are invoked depending on that result.\
]]\
function Promise.prototype:_andThen(traceback, successHandler, failureHandler)\
\9self._unhandledRejection = false\
\
\9-- Create a new promise to follow this part of the chain\
\9return Promise._new(traceback, function(resolve, reject)\
\9\9-- Our default callbacks just pass values onto the next promise.\
\9\9-- This lets success and failure cascade correctly!\
\
\9\9local successCallback = resolve\
\9\9if successHandler then\
\9\9\9successCallback = createAdvancer(traceback, successHandler, resolve, reject)\
\9\9end\
\
\9\9local failureCallback = reject\
\9\9if failureHandler then\
\9\9\9failureCallback = createAdvancer(traceback, failureHandler, resolve, reject)\
\9\9end\
\
\9\9if self._status == Promise.Status.Started then\
\9\9\9-- If we haven't resolved yet, put ourselves into the queue\
\9\9\9table.insert(self._queuedResolve, successCallback)\
\9\9\9table.insert(self._queuedReject, failureCallback)\
\9\9elseif self._status == Promise.Status.Resolved then\
\9\9\9-- This promise has already resolved! Trigger success immediately.\
\9\9\9successCallback(unpack(self._values, 1, self._valuesLength))\
\9\9elseif self._status == Promise.Status.Rejected then\
\9\9\9-- This promise died a terrible death! Trigger failure immediately.\
\9\9\9failureCallback(unpack(self._values, 1, self._valuesLength))\
\9\9elseif self._status == Promise.Status.Cancelled then\
\9\9\9-- We don't want to call the success handler or the failure handler,\
\9\9\9-- we just reject this promise outright.\
\9\9\9reject(Error.new({\
\9\9\9\9error = \"Promise is cancelled\",\
\9\9\9\9kind = Error.Kind.AlreadyCancelled,\
\9\9\9\9context = \"Promise created at\\n\\n\" .. traceback,\
\9\9\9}))\
\9\9end\
\9end, self)\
end\
\
--[=[\
\9Chains onto an existing Promise and returns a new Promise.\
\
\9:::warning\
\9Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.\
\9:::\
\
\9Return a Promise from the success or failure handler and it will be chained onto.\
\
\9@param successHandler (...: any) -> ...any\
\9@param failureHandler? (...: any) -> ...any\
\9@return Promise<...any>\
]=]\
function Promise.prototype:andThen(successHandler, failureHandler)\
\9assert(successHandler == nil or isCallable(successHandler), string.format(ERROR_NON_FUNCTION, \"Promise:andThen\"))\
\9assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, \"Promise:andThen\"))\
\
\9return self:_andThen(debug.traceback(nil, 2), successHandler, failureHandler)\
end\
\
--[=[\
\9Shorthand for `Promise:andThen(nil, failureHandler)`.\
\
\9Returns a Promise that resolves if the `failureHandler` worked without encountering an additional error.\
\
\9:::warning\
\9Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.\
\9:::\
\
\
\9@param failureHandler (...: any) -> ...any\
\9@return Promise<...any>\
]=]\
function Promise.prototype:catch(failureHandler)\
\9assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, \"Promise:catch\"))\
\9return self:_andThen(debug.traceback(nil, 2), nil, failureHandler)\
end\
\
--[=[\
\9Similar to [Promise.andThen](#andThen), except the return value is the same as the value passed to the handler. In other words, you can insert a `:tap` into a Promise chain without affecting the value that downstream Promises receive.\
\
\9```lua\
\9\9getTheValue()\
\9\9:tap(print)\
\9\9:andThen(function(theValue)\
\9\9\9print(\"Got\", theValue, \"even though print returns nil!\")\
\9\9end)\
\9```\
\
\9If you return a Promise from the tap handler callback, its value will be discarded but `tap` will still wait until it resolves before passing the original value through.\
\
\9@param tapHandler (...: any) -> ...any\
\9@return Promise<...any>\
]=]\
function Promise.prototype:tap(tapHandler)\
\9assert(isCallable(tapHandler), string.format(ERROR_NON_FUNCTION, \"Promise:tap\"))\
\9return self:_andThen(debug.traceback(nil, 2), function(...)\
\9\9local callbackReturn = tapHandler(...)\
\
\9\9if Promise.is(callbackReturn) then\
\9\9\9local length, values = pack(...)\
\9\9\9return callbackReturn:andThen(function()\
\9\9\9\9return unpack(values, 1, length)\
\9\9\9end)\
\9\9end\
\
\9\9return ...\
\9end)\
end\
\
--[=[\
\9Attaches an `andThen` handler to this Promise that calls the given callback with the predefined arguments. The resolved value is discarded.\
\
\9```lua\
\9\9promise:andThenCall(someFunction, \"some\", \"arguments\")\
\9```\
\
\9This is sugar for\
\
\9```lua\
\9\9promise:andThen(function()\
\9\9return someFunction(\"some\", \"arguments\")\
\9\9end)\
\9```\
\
\9@param callback (...: any) -> any\
\9@param ...? any -- Additional arguments which will be passed to `callback`\
\9@return Promise\
]=]\
function Promise.prototype:andThenCall(callback, ...)\
\9assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, \"Promise:andThenCall\"))\
\9local length, values = pack(...)\
\9return self:_andThen(debug.traceback(nil, 2), function()\
\9\9return callback(unpack(values, 1, length))\
\9end)\
end\
\
--[=[\
\9Attaches an `andThen` handler to this Promise that discards the resolved value and returns the given value from it.\
\
\9```lua\
\9\9promise:andThenReturn(\"some\", \"values\")\
\9```\
\
\9This is sugar for\
\
\9```lua\
\9\9promise:andThen(function()\
\9\9\9return \"some\", \"values\"\
\9\9end)\
\9```\
\
\9:::caution\
\9Promises are eager, so if you pass a Promise to `andThenReturn`, it will begin executing before `andThenReturn` is reached in the chain. Likewise, if you pass a Promise created from [[Promise.reject]] into `andThenReturn`, it's possible that this will trigger the unhandled rejection warning. If you need to return a Promise, it's usually best practice to use [[Promise.andThen]].\
\9:::\
\
\9@param ... any -- Values to return from the function\
\9@return Promise\
]=]\
function Promise.prototype:andThenReturn(...)\
\9local length, values = pack(...)\
\9return self:_andThen(debug.traceback(nil, 2), function()\
\9\9return unpack(values, 1, length)\
\9end)\
end\
\
--[=[\
\9Cancels this promise, preventing the promise from resolving or rejecting. Does not do anything if the promise is already settled.\
\
\9Cancellations will propagate upwards and downwards through chained promises.\
\
\9Promises will only be cancelled if all of their consumers are also cancelled. This is to say that if you call `andThen` twice on the same promise, and you cancel only one of the child promises, it will not cancel the parent promise until the other child promise is also cancelled.\
\
\9```lua\
\9\9promise:cancel()\
\9```\
]=]\
function Promise.prototype:cancel()\
\9if self._status ~= Promise.Status.Started then\
\9\9return\
\9end\
\
\9self._status = Promise.Status.Cancelled\
\
\9if self._cancellationHook then\
\9\9self._cancellationHook()\
\9end\
\
\9if self._parent then\
\9\9self._parent:_consumerCancelled(self)\
\9end\
\
\9for child in pairs(self._consumers) do\
\9\9child:cancel()\
\9end\
\
\9self:_finalize()\
end\
\
--[[\
\9Used to decrease the number of consumers by 1, and if there are no more,\
\9cancel this promise.\
]]\
function Promise.prototype:_consumerCancelled(consumer)\
\9if self._status ~= Promise.Status.Started then\
\9\9return\
\9end\
\
\9self._consumers[consumer] = nil\
\
\9if next(self._consumers) == nil then\
\9\9self:cancel()\
\9end\
end\
\
--[[\
\9Used to set a handler for when the promise resolves, rejects, or is\
\9cancelled. Returns a new promise chained from this promise.\
]]\
function Promise.prototype:_finally(traceback, finallyHandler, onlyOk)\
\9if not onlyOk then\
\9\9self._unhandledRejection = false\
\9end\
\
\9-- Return a promise chained off of this promise\
\9return Promise._new(traceback, function(resolve, reject)\
\9\9local finallyCallback = resolve\
\9\9if finallyHandler then\
\9\9\9finallyCallback = createAdvancer(traceback, finallyHandler, resolve, reject)\
\9\9end\
\
\9\9if onlyOk then\
\9\9\9local callback = finallyCallback\
\9\9\9finallyCallback = function(...)\
\9\9\9\9if self._status == Promise.Status.Rejected then\
\9\9\9\9\9return resolve(self)\
\9\9\9\9end\
\
\9\9\9\9return callback(...)\
\9\9\9end\
\9\9end\
\
\9\9if self._status == Promise.Status.Started then\
\9\9\9-- The promise is not settled, so queue this.\
\9\9\9table.insert(self._queuedFinally, finallyCallback)\
\9\9else\
\9\9\9-- The promise already settled or was cancelled, run the callback now.\
\9\9\9finallyCallback(self._status)\
\9\9end\
\9end, self)\
end\
\
--[=[\
\9Set a handler that will be called regardless of the promise's fate. The handler is called when the promise is resolved, rejected, *or* cancelled.\
\
\9Returns a new promise chained from this promise.\
\
\9:::caution\
\9If the Promise is cancelled, any Promises chained off of it with `andThen` won't run. Only Promises chained with `finally` or `done` will run in the case of cancellation.\
\9:::\
\
\9```lua\
\9local thing = createSomething()\
\
\9doSomethingWith(thing)\
\9\9:andThen(function()\
\9\9\9print(\"It worked!\")\
\9\9\9-- do something..\
\9\9end)\
\9\9:catch(function()\
\9\9\9warn(\"Oh no it failed!\")\
\9\9end)\
\9\9:finally(function()\
\9\9\9-- either way, destroy thing\
\
\9\9\9thing:Destroy()\
\9\9end)\
\
\9```\
\
\9@param finallyHandler (status: Status) -> ...any\
\9@return Promise<...any>\
]=]\
function Promise.prototype:finally(finallyHandler)\
\9assert(finallyHandler == nil or isCallable(finallyHandler), string.format(ERROR_NON_FUNCTION, \"Promise:finally\"))\
\9return self:_finally(debug.traceback(nil, 2), finallyHandler)\
end\
\
--[=[\
\9Same as `andThenCall`, except for `finally`.\
\
\9Attaches a `finally` handler to this Promise that calls the given callback with the predefined arguments.\
\
\9@param callback (...: any) -> any\
\9@param ...? any -- Additional arguments which will be passed to `callback`\
\9@return Promise\
]=]\
function Promise.prototype:finallyCall(callback, ...)\
\9assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, \"Promise:finallyCall\"))\
\9local length, values = pack(...)\
\9return self:_finally(debug.traceback(nil, 2), function()\
\9\9return callback(unpack(values, 1, length))\
\9end)\
end\
\
--[=[\
\9Attaches a `finally` handler to this Promise that discards the resolved value and returns the given value from it.\
\
\9```lua\
\9\9promise:finallyReturn(\"some\", \"values\")\
\9```\
\
\9This is sugar for\
\
\9```lua\
\9\9promise:finally(function()\
\9\9\9return \"some\", \"values\"\
\9\9end)\
\9```\
\
\9@param ... any -- Values to return from the function\
\9@return Promise\
]=]\
function Promise.prototype:finallyReturn(...)\
\9local length, values = pack(...)\
\9return self:_finally(debug.traceback(nil, 2), function()\
\9\9return unpack(values, 1, length)\
\9end)\
end\
\
--[=[\
\9Set a handler that will be called only if the Promise resolves or is cancelled. This method is similar to `finally`, except it doesn't catch rejections.\
\
\9:::caution\
\9`done` should be reserved specifically when you want to perform some operation after the Promise is finished (like `finally`), but you don't want to consume rejections (like in <a href=\"/roblox-lua-promise/lib/Examples.html#cancellable-animation-sequence\">this example</a>). You should use `andThen` instead if you only care about the Resolved case.\
\9:::\
\
\9:::warning\
\9Like `finally`, if the Promise is cancelled, any Promises chained off of it with `andThen` won't run. Only Promises chained with `done` and `finally` will run in the case of cancellation.\
\9:::\
\
\9Returns a new promise chained from this promise.\
\
\9@param doneHandler (status: Status) -> ...any\
\9@return Promise<...any>\
]=]\
function Promise.prototype:done(doneHandler)\
\9assert(doneHandler == nil or isCallable(doneHandler), string.format(ERROR_NON_FUNCTION, \"Promise:done\"))\
\9return self:_finally(debug.traceback(nil, 2), doneHandler, true)\
end\
\
--[=[\
\9Same as `andThenCall`, except for `done`.\
\
\9Attaches a `done` handler to this Promise that calls the given callback with the predefined arguments.\
\
\9@param callback (...: any) -> any\
\9@param ...? any -- Additional arguments which will be passed to `callback`\
\9@return Promise\
]=]\
function Promise.prototype:doneCall(callback, ...)\
\9assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, \"Promise:doneCall\"))\
\9local length, values = pack(...)\
\9return self:_finally(debug.traceback(nil, 2), function()\
\9\9return callback(unpack(values, 1, length))\
\9end, true)\
end\
\
--[=[\
\9Attaches a `done` handler to this Promise that discards the resolved value and returns the given value from it.\
\
\9```lua\
\9\9promise:doneReturn(\"some\", \"values\")\
\9```\
\
\9This is sugar for\
\
\9```lua\
\9\9promise:done(function()\
\9\9\9return \"some\", \"values\"\
\9\9end)\
\9```\
\
\9@param ... any -- Values to return from the function\
\9@return Promise\
]=]\
function Promise.prototype:doneReturn(...)\
\9local length, values = pack(...)\
\9return self:_finally(debug.traceback(nil, 2), function()\
\9\9return unpack(values, 1, length)\
\9end, true)\
end\
\
--[=[\
\9Yields the current thread until the given Promise completes. Returns the Promise's status, followed by the values that the promise resolved or rejected with.\
\
\9@yields\
\9@return Status -- The Status representing the fate of the Promise\
\9@return ...any -- The values the Promise resolved or rejected with.\
]=]\
function Promise.prototype:awaitStatus()\
\9self._unhandledRejection = false\
\
\9if self._status == Promise.Status.Started then\
\9\9local bindable = Instance.new(\"BindableEvent\")\
\
\9\9self:finally(function()\
\9\9\9bindable:Fire()\
\9\9end)\
\
\9\9bindable.Event:Wait()\
\9\9bindable:Destroy()\
\9end\
\
\9if self._status == Promise.Status.Resolved then\
\9\9return self._status, unpack(self._values, 1, self._valuesLength)\
\9elseif self._status == Promise.Status.Rejected then\
\9\9return self._status, unpack(self._values, 1, self._valuesLength)\
\9end\
\
\9return self._status\
end\
\
local function awaitHelper(status, ...)\
\9return status == Promise.Status.Resolved, ...\
end\
\
--[=[\
\9Yields the current thread until the given Promise completes. Returns true if the Promise resolved, followed by the values that the promise resolved or rejected with.\
\
\9:::caution\
\9If the Promise gets cancelled, this function will return `false`, which is indistinguishable from a rejection. If you need to differentiate, you should use [[Promise.awaitStatus]] instead.\
\9:::\
\
\9```lua\
\9\9local worked, value = getTheValue():await()\
\
\9if worked then\
\9\9print(\"got\", value)\
\9else\
\9\9warn(\"it failed\")\
\9end\
\9```\
\
\9@yields\
\9@return boolean -- `true` if the Promise successfully resolved\
\9@return ...any -- The values the Promise resolved or rejected with.\
]=]\
function Promise.prototype:await()\
\9return awaitHelper(self:awaitStatus())\
end\
\
local function expectHelper(status, ...)\
\9if status ~= Promise.Status.Resolved then\
\9\9error((...) == nil and \"Expected Promise rejected with no value.\" or (...), 3)\
\9end\
\
\9return ...\
end\
\
--[=[\
\9Yields the current thread until the given Promise completes. Returns the values that the promise resolved with.\
\
\9```lua\
\9local worked = pcall(function()\
\9\9print(\"got\", getTheValue():expect())\
\9end)\
\
\9if not worked then\
\9\9warn(\"it failed\")\
\9end\
\9```\
\
\9This is essentially sugar for:\
\
\9```lua\
\9select(2, assert(promise:await()))\
\9```\
\
\9**Errors** if the Promise rejects or gets cancelled.\
\
\9@error any -- Errors with the rejection value if this Promise rejects or gets cancelled.\
\9@yields\
\9@return ...any -- The values the Promise resolved with.\
]=]\
function Promise.prototype:expect()\
\9return expectHelper(self:awaitStatus())\
end\
\
-- Backwards compatibility\
Promise.prototype.awaitValue = Promise.prototype.expect\
\
--[[\
\9Intended for use in tests.\
\
\9Similar to await(), but instead of yielding if the promise is unresolved,\
\9_unwrap will throw. This indicates an assumption that a promise has\
\9resolved.\
]]\
function Promise.prototype:_unwrap()\
\9if self._status == Promise.Status.Started then\
\9\9error(\"Promise has not resolved or rejected.\", 2)\
\9end\
\
\9local success = self._status == Promise.Status.Resolved\
\
\9return success, unpack(self._values, 1, self._valuesLength)\
end\
\
function Promise.prototype:_resolve(...)\
\9if self._status ~= Promise.Status.Started then\
\9\9if Promise.is((...)) then\
\9\9\9(...):_consumerCancelled(self)\
\9\9end\
\9\9return\
\9end\
\
\9-- If the resolved value was a Promise, we chain onto it!\
\9if Promise.is((...)) then\
\9\9-- Without this warning, arguments sometimes mysteriously disappear\
\9\9if select(\"#\", ...) > 1 then\
\9\9\9local message = string.format(\
\9\9\9\9\"When returning a Promise from andThen, extra arguments are \" .. \"discarded! See:\\n\\n%s\",\
\9\9\9\9self._source\
\9\9\9)\
\9\9\9warn(message)\
\9\9end\
\
\9\9local chainedPromise = ...\
\
\9\9local promise = chainedPromise:andThen(function(...)\
\9\9\9self:_resolve(...)\
\9\9end, function(...)\
\9\9\9local maybeRuntimeError = chainedPromise._values[1]\
\
\9\9\9-- Backwards compatibility < v2\
\9\9\9if chainedPromise._error then\
\9\9\9\9maybeRuntimeError = Error.new({\
\9\9\9\9\9error = chainedPromise._error,\
\9\9\9\9\9kind = Error.Kind.ExecutionError,\
\9\9\9\9\9context = \"[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]\",\
\9\9\9\9})\
\9\9\9end\
\
\9\9\9if Error.isKind(maybeRuntimeError, Error.Kind.ExecutionError) then\
\9\9\9\9return self:_reject(maybeRuntimeError:extend({\
\9\9\9\9\9error = \"This Promise was chained to a Promise that errored.\",\
\9\9\9\9\9trace = \"\",\
\9\9\9\9\9context = string.format(\
\9\9\9\9\9\9\"The Promise at:\\n\\n%s\\n...Rejected because it was chained to the following Promise, which encountered an error:\\n\",\
\9\9\9\9\9\9self._source\
\9\9\9\9\9),\
\9\9\9\9}))\
\9\9\9end\
\
\9\9\9self:_reject(...)\
\9\9end)\
\
\9\9if promise._status == Promise.Status.Cancelled then\
\9\9\9self:cancel()\
\9\9elseif promise._status == Promise.Status.Started then\
\9\9\9-- Adopt ourselves into promise for cancellation propagation.\
\9\9\9self._parent = promise\
\9\9\9promise._consumers[self] = true\
\9\9end\
\
\9\9return\
\9end\
\
\9self._status = Promise.Status.Resolved\
\9self._valuesLength, self._values = pack(...)\
\
\9-- We assume that these callbacks will not throw errors.\
\9for _, callback in ipairs(self._queuedResolve) do\
\9\9coroutine.wrap(callback)(...)\
\9end\
\
\9self:_finalize()\
end\
\
function Promise.prototype:_reject(...)\
\9if self._status ~= Promise.Status.Started then\
\9\9return\
\9end\
\
\9self._status = Promise.Status.Rejected\
\9self._valuesLength, self._values = pack(...)\
\
\9-- If there are any rejection handlers, call those!\
\9if not isEmpty(self._queuedReject) then\
\9\9-- We assume that these callbacks will not throw errors.\
\9\9for _, callback in ipairs(self._queuedReject) do\
\9\9\9coroutine.wrap(callback)(...)\
\9\9end\
\9else\
\9\9-- At this point, no one was able to observe the error.\
\9\9-- An error handler might still be attached if the error occurred\
\9\9-- synchronously. We'll wait one tick, and if there are still no\
\9\9-- observers, then we should put a message in the console.\
\
\9\9local err = tostring((...))\
\
\9\9coroutine.wrap(function()\
\9\9\9Promise._timeEvent:Wait()\
\
\9\9\9-- Someone observed the error, hooray!\
\9\9\9if not self._unhandledRejection then\
\9\9\9\9return\
\9\9\9end\
\
\9\9\9-- Build a reasonable message\
\9\9\9local message = string.format(\"Unhandled Promise rejection:\\n\\n%s\\n\\n%s\", err, self._source)\
\
\9\9\9for _, callback in ipairs(Promise._unhandledRejectionCallbacks) do\
\9\9\9\9task.spawn(callback, self, unpack(self._values, 1, self._valuesLength))\
\9\9\9end\
\
\9\9\9if Promise.TEST then\
\9\9\9\9-- Don't spam output when we're running tests.\
\9\9\9\9return\
\9\9\9end\
\
\9\9\9warn(message)\
\9\9end)()\
\9end\
\
\9self:_finalize()\
end\
\
--[[\
\9Calls any :finally handlers. We need this to be a separate method and\
\9queue because we must call all of the finally callbacks upon a success,\
\9failure, *and* cancellation.\
]]\
function Promise.prototype:_finalize()\
\9for _, callback in ipairs(self._queuedFinally) do\
\9\9-- Purposefully not passing values to callbacks here, as it could be the\
\9\9-- resolved values, or rejected errors. If the developer needs the values,\
\9\9-- they should use :andThen or :catch explicitly.\
\9\9coroutine.wrap(callback)(self._status)\
\9end\
\
\9self._queuedFinally = nil\
\9self._queuedReject = nil\
\9self._queuedResolve = nil\
\
\9-- Clear references to other Promises to allow gc\
\9if not Promise.TEST then\
\9\9self._parent = nil\
\9\9self._consumers = nil\
\9end\
end\
\
--[=[\
\9Chains a Promise from this one that is resolved if this Promise is already resolved, and rejected if it is not resolved at the time of calling `:now()`. This can be used to ensure your `andThen` handler occurs on the same frame as the root Promise execution.\
\
\9```lua\
\9doSomething()\
\9\9:now()\
\9\9:andThen(function(value)\
\9\9\9print(\"Got\", value, \"synchronously.\")\
\9\9end)\
\9```\
\
\9If this Promise is still running, Rejected, or Cancelled, the Promise returned from `:now()` will reject with the `rejectionValue` if passed, otherwise with a `Promise.Error(Promise.Error.Kind.NotResolvedInTime)`. This can be checked with [[Error.isKind]].\
\
\9@param rejectionValue? any -- The value to reject with if the Promise isn't resolved\
\9@return Promise\
]=]\
function Promise.prototype:now(rejectionValue)\
\9local traceback = debug.traceback(nil, 2)\
\9if self._status == Promise.Status.Resolved then\
\9\9return self:_andThen(traceback, function(...)\
\9\9\9return ...\
\9\9end)\
\9else\
\9\9return Promise.reject(rejectionValue == nil and Error.new({\
\9\9\9kind = Error.Kind.NotResolvedInTime,\
\9\9\9error = \"This Promise was not resolved in time for :now()\",\
\9\9\9context = \":now() was called at:\\n\\n\" .. traceback,\
\9\9}) or rejectionValue)\
\9end\
end\
\
--[=[\
\9Repeatedly calls a Promise-returning function up to `times` number of times, until the returned Promise resolves.\
\
\9If the amount of retries is exceeded, the function will return the latest rejected Promise.\
\
\9```lua\
\9local function canFail(a, b, c)\
\9\9return Promise.new(function(resolve, reject)\
\9\9\9-- do something that can fail\
\
\9\9\9local failed, thing = doSomethingThatCanFail(a, b, c)\
\
\9\9\9if failed then\
\9\9\9\9reject(\"it failed\")\
\9\9\9else\
\9\9\9\9resolve(thing)\
\9\9\9end\
\9\9end)\
\9end\
\
\9local MAX_RETRIES = 10\
\9local value = Promise.retry(canFail, MAX_RETRIES, \"foo\", \"bar\", \"baz\") -- args to send to canFail\
\9```\
\
\9@since 3.0.0\
\9@param callback (...: P) -> Promise<T>\
\9@param times number\
\9@param ...? P\
]=]\
function Promise.retry(callback, times, ...)\
\9assert(isCallable(callback), \"Parameter #1 to Promise.retry must be a function\")\
\9assert(type(times) == \"number\", \"Parameter #2 to Promise.retry must be a number\")\
\
\9local args, length = { ... }, select(\"#\", ...)\
\
\9return Promise.resolve(callback(...)):catch(function(...)\
\9\9if times > 0 then\
\9\9\9return Promise.retry(callback, times - 1, unpack(args, 1, length))\
\9\9else\
\9\9\9return Promise.reject(...)\
\9\9end\
\9end)\
end\
\
--[=[\
\9Repeatedly calls a Promise-returning function up to `times` number of times, waiting `seconds` seconds between each\
\9retry, until the returned Promise resolves.\
\
\9If the amount of retries is exceeded, the function will return the latest rejected Promise.\
\
\9@since v3.2.0\
\9@param callback (...: P) -> Promise<T>\
\9@param times number\
\9@param seconds number\
\9@param ...? P\
]=]\
function Promise.retryWithDelay(callback, times, seconds, ...)\
\9assert(isCallable(callback), \"Parameter #1 to Promise.retry must be a function\")\
\9assert(type(times) == \"number\", \"Parameter #2 (times) to Promise.retry must be a number\")\
\9assert(type(seconds) == \"number\", \"Parameter #3 (seconds) to Promise.retry must be a number\")\
\
\9local args, length = { ... }, select(\"#\", ...)\
\
\9return Promise.resolve(callback(...)):catch(function(...)\
\9\9if times > 0 then\
\9\9\9Promise.delay(seconds):await()\
\
\9\9\9return Promise.retryWithDelay(callback, times - 1, seconds, unpack(args, 1, length))\
\9\9else\
\9\9\9return Promise.reject(...)\
\9\9end\
\9end)\
end\
\
--[=[\
\9Converts an event into a Promise which resolves the next time the event fires.\
\
\9The optional `predicate` callback, if passed, will receive the event arguments and should return `true` or `false`, based on if this fired event should resolve the Promise or not. If `true`, the Promise resolves. If `false`, nothing happens and the predicate will be rerun the next time the event fires.\
\
\9The Promise will resolve with the event arguments.\
\
\9:::tip\
\9This function will work given any object with a `Connect` method. This includes all Roblox events.\
\9:::\
\
\9```lua\
\9-- Creates a Promise which only resolves when `somePart` is touched\
\9-- by a part named `\"Something specific\"`.\
\9return Promise.fromEvent(somePart.Touched, function(part)\
\9\9return part.Name == \"Something specific\"\
\9end)\
\9```\
\
\9@since 3.0.0\
\9@param event Event -- Any object with a `Connect` method. This includes all Roblox events.\
\9@param predicate? (...: P) -> boolean -- A function which determines if the Promise should resolve with the given value, or wait for the next event to check again.\
\9@return Promise<P>\
]=]\
function Promise.fromEvent(event, predicate)\
\9predicate = predicate or function()\
\9\9return true\
\9end\
\
\9return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)\
\9\9local connection\
\9\9local shouldDisconnect = false\
\
\9\9local function disconnect()\
\9\9\9connection:Disconnect()\
\9\9\9connection = nil\
\9\9end\
\
\9\9-- We use shouldDisconnect because if the callback given to Connect is called before\
\9\9-- Connect returns, connection will still be nil. This happens with events that queue up\
\9\9-- events when there's nothing connected, such as RemoteEvents\
\
\9\9connection = event:Connect(function(...)\
\9\9\9local callbackValue = predicate(...)\
\
\9\9\9if callbackValue == true then\
\9\9\9\9resolve(...)\
\
\9\9\9\9if connection then\
\9\9\9\9\9disconnect()\
\9\9\9\9else\
\9\9\9\9\9shouldDisconnect = true\
\9\9\9\9end\
\9\9\9elseif type(callbackValue) ~= \"boolean\" then\
\9\9\9\9error(\"Promise.fromEvent predicate should always return a boolean\")\
\9\9\9end\
\9\9end)\
\
\9\9if shouldDisconnect and connection then\
\9\9\9return disconnect()\
\9\9end\
\
\9\9onCancel(disconnect)\
\9end)\
end\
\
--[=[\
\9Registers a callback that runs when an unhandled rejection happens. An unhandled rejection happens when a Promise\
\9is rejected, and the rejection is not observed with `:catch`.\
\
\9The callback is called with the actual promise that rejected, followed by the rejection values.\
\
\9@since v3.2.0\
\9@param callback (promise: Promise, ...: any) -- A callback that runs when an unhandled rejection happens.\
\9@return () -> () -- Function that unregisters the `callback` when called\
]=]\
function Promise.onUnhandledRejection(callback)\
\9table.insert(Promise._unhandledRejectionCallbacks, callback)\
\
\9return function()\
\9\9local index = table.find(Promise._unhandledRejectionCallbacks, callback)\
\
\9\9if index then\
\9\9\9table.remove(Promise._unhandledRejectionCallbacks, index)\
\9\9end\
\9end\
end\
\
return Promise\
", '@'.."RemoteSpy.include.Promise")) setfenv(fn, _env("RemoteSpy.include.Promise")) return fn() end)

_module("RuntimeLib", "ModuleScript", "RemoteSpy.include.RuntimeLib", "RemoteSpy.include", function () local fn = assert(loadstring("local Promise = require(script.Parent.Promise)\
\
local RunService = game:GetService(\"RunService\")\
local ReplicatedFirst = game:GetService(\"ReplicatedFirst\")\
\
local TS = {}\
\
TS.Promise = Promise\
\
local function isPlugin(object)\
\9return RunService:IsStudio() and object:FindFirstAncestorWhichIsA(\"Plugin\") ~= nil\
end\
\
function TS.getModule(object, scope, moduleName)\
\9if moduleName == nil then\
\9\9moduleName = scope\
\9\9scope = \"@rbxts\"\
\9end\
\
\9if RunService:IsRunning() and object:IsDescendantOf(ReplicatedFirst) then\
\9\9warn(\"roblox-ts packages should not be used from ReplicatedFirst!\")\
\9end\
\
\9-- ensure modules have fully replicated\
\9if RunService:IsRunning() and RunService:IsClient() and not isPlugin(object) and not game:IsLoaded() then\
\9\9game.Loaded:Wait()\
\9end\
\
\9local globalModules = script.Parent:FindFirstChild(\"node_modules\")\
\9if not globalModules then\
\9\9error(\"Could not find any modules!\", 2)\
\9end\
\
\9repeat\
\9\9local modules = object:FindFirstChild(\"node_modules\")\
\9\9if modules and modules ~= globalModules then\
\9\9\9modules = modules:FindFirstChild(\"@rbxts\")\
\9\9end\
\9\9if modules then\
\9\9\9local module = modules:FindFirstChild(moduleName)\
\9\9\9if module then\
\9\9\9\9return module\
\9\9\9end\
\9\9end\
\9\9object = object.Parent\
\9until object == nil or object == globalModules\
\
\9local scopedModules = globalModules:FindFirstChild(scope or \"@rbxts\");\
\9return (scopedModules or globalModules):FindFirstChild(moduleName) or error(\"Could not find module: \" .. moduleName, 2)\
end\
\
-- This is a hash which TS.import uses as a kind of linked-list-like history of [Script who Loaded] -> Library\
local currentlyLoading = {}\
local registeredLibraries = {}\
\
function TS.import(caller, module, ...)\
\9for i = 1, select(\"#\", ...) do\
\9\9module = module:WaitForChild((select(i, ...)))\
\9end\
\
\9if module.ClassName ~= \"ModuleScript\" then\
\9\9error(\"Failed to import! Expected ModuleScript, got \" .. module.ClassName, 2)\
\9end\
\
\9currentlyLoading[caller] = module\
\
\9-- Check to see if a case like this occurs:\
\9-- module -> Module1 -> Module2 -> module\
\
\9-- WHERE currentlyLoading[module] is Module1\
\9-- and currentlyLoading[Module1] is Module2\
\9-- and currentlyLoading[Module2] is module\
\
\9local currentModule = module\
\9local depth = 0\
\
\9while currentModule do\
\9\9depth = depth + 1\
\9\9currentModule = currentlyLoading[currentModule]\
\
\9\9if currentModule == module then\
\9\9\9local str = currentModule.Name -- Get the string traceback\
\
\9\9\9for _ = 1, depth do\
\9\9\9\9currentModule = currentlyLoading[currentModule]\
\9\9\9\9str = str .. \"  ⇒ \" .. currentModule.Name\
\9\9\9end\
\
\9\9\9error(\"Failed to import! Detected a circular dependency chain: \" .. str, 2)\
\9\9end\
\9end\
\
\9if not registeredLibraries[module] then\
\9\9if _G[module] then\
\9\9\9error(\
\9\9\9\9\"Invalid module access! Do you have two TS runtimes trying to import this? \" .. module:GetFullName(),\
\9\9\9\0092\
\9\9\9)\
\9\9end\
\
\9\9_G[module] = TS\
\9\9registeredLibraries[module] = true -- register as already loaded for subsequent calls\
\9end\
\
\9local data = require(module)\
\
\9if currentlyLoading[caller] == module then -- Thread-safe cleanup!\
\9\9currentlyLoading[caller] = nil\
\9end\
\
\9return data\
end\
\
function TS.instanceof(obj, class)\
\9-- custom Class.instanceof() check\
\9if type(class) == \"table\" and type(class.instanceof) == \"function\" then\
\9\9return class.instanceof(obj)\
\9end\
\
\9-- metatable check\
\9if type(obj) == \"table\" then\
\9\9obj = getmetatable(obj)\
\9\9while obj ~= nil do\
\9\9\9if obj == class then\
\9\9\9\9return true\
\9\9\9end\
\9\9\9local mt = getmetatable(obj)\
\9\9\9if mt then\
\9\9\9\9obj = mt.__index\
\9\9\9else\
\9\9\9\9obj = nil\
\9\9\9end\
\9\9end\
\9end\
\
\9return false\
end\
\
function TS.async(callback)\
\9return function(...)\
\9\9local n = select(\"#\", ...)\
\9\9local args = { ... }\
\9\9return Promise.new(function(resolve, reject)\
\9\9\9coroutine.wrap(function()\
\9\9\9\9local ok, result = pcall(callback, unpack(args, 1, n))\
\9\9\9\9if ok then\
\9\9\9\9\9resolve(result)\
\9\9\9\9else\
\9\9\9\9\9reject(result)\
\9\9\9\9end\
\9\9\9end)()\
\9\9end)\
\9end\
end\
\
function TS.await(promise)\
\9if not Promise.is(promise) then\
\9\9return promise\
\9end\
\
\9local status, value = promise:awaitStatus()\
\9if status == Promise.Status.Resolved then\
\9\9return value\
\9elseif status == Promise.Status.Rejected then\
\9\9error(value, 2)\
\9else\
\9\9error(\"The awaited Promise was cancelled\", 2)\
\9end\
end\
\
function TS.bit_lrsh(a, b)\
\9local absA = math.abs(a)\
\9local result = bit32.rshift(absA, b)\
\9if a == absA then\
\9\9return result\
\9else\
\9\9return -result - 1\
\9end\
end\
\
TS.TRY_RETURN = 1\
TS.TRY_BREAK = 2\
TS.TRY_CONTINUE = 3\
\
function TS.try(func, catch, finally)\
\9local err, traceback\
\9local success, exitType, returns = xpcall(\
\9\9func,\
\9\9function(errInner)\
\9\9\9err = errInner\
\9\9\9traceback = debug.traceback()\
\9\9end\
\9)\
\9if not success and catch then\
\9\9local newExitType, newReturns = catch(err, traceback)\
\9\9if newExitType then\
\9\9\9exitType, returns = newExitType, newReturns\
\9\9end\
\9end\
\9if finally then\
\9\9local newExitType, newReturns = finally()\
\9\9if newExitType then\
\9\9\9exitType, returns = newExitType, newReturns\
\9\9end\
\9end\
\9return exitType, returns\
end\
\
function TS.generator(callback)\
\9local co = coroutine.create(callback)\
\9return {\
\9\9next = function(...)\
\9\9\9if coroutine.status(co) == \"dead\" then\
\9\9\9\9return { done = true }\
\9\9\9else\
\9\9\9\9local success, value = coroutine.resume(co, ...)\
\9\9\9\9if success == false then\
\9\9\9\9\9error(value, 2)\
\9\9\9\9end\
\9\9\9\9return {\
\9\9\9\9\9value = value,\
\9\9\9\9\9done = coroutine.status(co) == \"dead\",\
\9\9\9\9}\
\9\9\9end\
\9\9end,\
\9}\
end\
\
return TS\
", '@'.."RemoteSpy.include.RuntimeLib")) setfenv(fn, _env("RemoteSpy.include.RuntimeLib")) return fn() end)

_instance("node_modules", "Folder", "RemoteSpy.include.node_modules", "RemoteSpy.include")

_instance("bin", "Folder", "RemoteSpy.include.node_modules.bin", "RemoteSpy.include.node_modules")

_module("out", "ModuleScript", "RemoteSpy.include.node_modules.bin.out", "RemoteSpy.include.node_modules.bin", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
--[[\
\9*\
\9* Tracks connections, instances, functions, and objects to be later destroyed.\
]]\
local Bin\
do\
\9Bin = setmetatable({}, {\
\9\9__tostring = function()\
\9\9\9return \"Bin\"\
\9\9end,\
\9})\
\9Bin.__index = Bin\
\9function Bin.new(...)\
\9\9local self = setmetatable({}, Bin)\
\9\9return self:constructor(...) or self\
\9end\
\9function Bin:constructor()\
\9end\
\9function Bin:add(item)\
\9\9local node = {\
\9\9\9item = item,\
\9\9}\
\9\9if self.head == nil then\
\9\9\9self.head = node\
\9\9end\
\9\9if self.tail then\
\9\9\9self.tail.next = node\
\9\9end\
\9\9self.tail = node\
\9\9return item\
\9end\
\9function Bin:destroy()\
\9\9while self.head do\
\9\9\9local item = self.head.item\
\9\9\9if type(item) == \"function\" then\
\9\9\9\9item()\
\9\9\9elseif typeof(item) == \"RBXScriptConnection\" then\
\9\9\9\9item:Disconnect()\
\9\9\9elseif item.destroy ~= nil then\
\9\9\9\9item:destroy()\
\9\9\9elseif item.Destroy ~= nil then\
\9\9\9\9item:Destroy()\
\9\9\9end\
\9\9\9self.head = self.head.next\
\9\9end\
\9end\
\9function Bin:isEmpty()\
\9\9return self.head == nil\
\9end\
end\
return {\
\9Bin = Bin,\
}\
", '@'.."RemoteSpy.include.node_modules.bin.out")) setfenv(fn, _env("RemoteSpy.include.node_modules.bin.out")) return fn() end)

_instance("compiler-types", "Folder", "RemoteSpy.include.node_modules.compiler-types", "RemoteSpy.include.node_modules")

_instance("types", "Folder", "RemoteSpy.include.node_modules.compiler-types.types", "RemoteSpy.include.node_modules.compiler-types")

_instance("flipper", "Folder", "RemoteSpy.include.node_modules.flipper", "RemoteSpy.include.node_modules")

_module("src", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src", "RemoteSpy.include.node_modules.flipper", function () local fn = assert(loadstring("local Flipper = {\13\
\9SingleMotor = require(script.SingleMotor),\13\
\9GroupMotor = require(script.GroupMotor),\13\
\13\
\9Instant = require(script.Instant),\13\
\9Linear = require(script.Linear),\13\
\9Spring = require(script.Spring),\13\
\9\13\
\9isMotor = require(script.isMotor),\13\
}\13\
\13\
return Flipper", '@'.."RemoteSpy.include.node_modules.flipper.src")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src")) return fn() end)

_module("BaseMotor", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.BaseMotor", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local RunService = game:GetService(\"RunService\")\13\
\13\
local Signal = require(script.Parent.Signal)\13\
\13\
local noop = function() end\13\
\13\
local BaseMotor = {}\13\
BaseMotor.__index = BaseMotor\13\
\13\
function BaseMotor.new()\13\
\9return setmetatable({\13\
\9\9_onStep = Signal.new(),\13\
\9\9_onStart = Signal.new(),\13\
\9\9_onComplete = Signal.new(),\13\
\9}, BaseMotor)\13\
end\13\
\13\
function BaseMotor:onStep(handler)\13\
\9return self._onStep:connect(handler)\13\
end\13\
\13\
function BaseMotor:onStart(handler)\13\
\9return self._onStart:connect(handler)\13\
end\13\
\13\
function BaseMotor:onComplete(handler)\13\
\9return self._onComplete:connect(handler)\13\
end\13\
\13\
function BaseMotor:start()\13\
\9if not self._connection then\13\
\9\9self._connection = RunService.RenderStepped:Connect(function(deltaTime)\13\
\9\9\9self:step(deltaTime)\13\
\9\9end)\13\
\9end\13\
end\13\
\13\
function BaseMotor:stop()\13\
\9if self._connection then\13\
\9\9self._connection:Disconnect()\13\
\9\9self._connection = nil\13\
\9end\13\
end\13\
\13\
BaseMotor.destroy = BaseMotor.stop\13\
\13\
BaseMotor.step = noop\13\
BaseMotor.getValue = noop\13\
BaseMotor.setGoal = noop\13\
\13\
function BaseMotor:__tostring()\13\
\9return \"Motor\"\13\
end\13\
\13\
return BaseMotor\13\
", '@'.."RemoteSpy.include.node_modules.flipper.src.BaseMotor")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.BaseMotor")) return fn() end)

_module("GroupMotor", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.GroupMotor", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local BaseMotor = require(script.Parent.BaseMotor)\13\
local SingleMotor = require(script.Parent.SingleMotor)\13\
\13\
local isMotor = require(script.Parent.isMotor)\13\
\13\
local GroupMotor = setmetatable({}, BaseMotor)\13\
GroupMotor.__index = GroupMotor\13\
\13\
local function toMotor(value)\13\
\9if isMotor(value) then\13\
\9\9return value\13\
\9end\13\
\13\
\9local valueType = typeof(value)\13\
\13\
\9if valueType == \"number\" then\13\
\9\9return SingleMotor.new(value, false)\13\
\9elseif valueType == \"table\" then\13\
\9\9return GroupMotor.new(value, false)\13\
\9end\13\
\13\
\9error((\"Unable to convert %q to motor; type %s is unsupported\"):format(value, valueType), 2)\13\
end\13\
\13\
function GroupMotor.new(initialValues, useImplicitConnections)\13\
\9assert(initialValues, \"Missing argument #1: initialValues\")\13\
\9assert(typeof(initialValues) == \"table\", \"initialValues must be a table!\")\13\
\9assert(not initialValues.step, \"initialValues contains disallowed property \\\"step\\\". Did you mean to put a table of values here?\")\13\
\13\
\9local self = setmetatable(BaseMotor.new(), GroupMotor)\13\
\13\
\9if useImplicitConnections ~= nil then\13\
\9\9self._useImplicitConnections = useImplicitConnections\13\
\9else\13\
\9\9self._useImplicitConnections = true\13\
\9end\13\
\13\
\9self._complete = true\13\
\9self._motors = {}\13\
\13\
\9for key, value in pairs(initialValues) do\13\
\9\9self._motors[key] = toMotor(value)\13\
\9end\13\
\13\
\9return self\13\
end\13\
\13\
function GroupMotor:step(deltaTime)\13\
\9if self._complete then\13\
\9\9return true\13\
\9end\13\
\13\
\9local allMotorsComplete = true\13\
\13\
\9for _, motor in pairs(self._motors) do\13\
\9\9local complete = motor:step(deltaTime)\13\
\9\9if not complete then\13\
\9\9\9-- If any of the sub-motors are incomplete, the group motor will not be complete either\13\
\9\9\9allMotorsComplete = false\13\
\9\9end\13\
\9end\13\
\13\
\9self._onStep:fire(self:getValue())\13\
\13\
\9if allMotorsComplete then\13\
\9\9if self._useImplicitConnections then\13\
\9\9\9self:stop()\13\
\9\9end\13\
\13\
\9\9self._complete = true\13\
\9\9self._onComplete:fire()\13\
\9end\13\
\13\
\9return allMotorsComplete\13\
end\13\
\13\
function GroupMotor:setGoal(goals)\13\
\9assert(not goals.step, \"goals contains disallowed property \\\"step\\\". Did you mean to put a table of goals here?\")\13\
\13\
\9self._complete = false\13\
\9self._onStart:fire()\13\
\13\
\9for key, goal in pairs(goals) do\13\
\9\9local motor = assert(self._motors[key], (\"Unknown motor for key %s\"):format(key))\13\
\9\9motor:setGoal(goal)\13\
\9end\13\
\13\
\9if self._useImplicitConnections then\13\
\9\9self:start()\13\
\9end\13\
end\13\
\13\
function GroupMotor:getValue()\13\
\9local values = {}\13\
\13\
\9for key, motor in pairs(self._motors) do\13\
\9\9values[key] = motor:getValue()\13\
\9end\13\
\13\
\9return values\13\
end\13\
\13\
function GroupMotor:__tostring()\13\
\9return \"Motor(Group)\"\13\
end\13\
\13\
return GroupMotor\13\
", '@'.."RemoteSpy.include.node_modules.flipper.src.GroupMotor")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.GroupMotor")) return fn() end)

_module("Instant", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.Instant", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local Instant = {}\13\
Instant.__index = Instant\13\
\13\
function Instant.new(targetValue)\13\
\9return setmetatable({\13\
\9\9_targetValue = targetValue,\13\
\9}, Instant)\13\
end\13\
\13\
function Instant:step()\13\
\9return {\13\
\9\9complete = true,\13\
\9\9value = self._targetValue,\13\
\9}\13\
end\13\
\13\
return Instant", '@'.."RemoteSpy.include.node_modules.flipper.src.Instant")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.Instant")) return fn() end)

_module("Linear", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.Linear", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local Linear = {}\13\
Linear.__index = Linear\13\
\13\
function Linear.new(targetValue, options)\13\
\9assert(targetValue, \"Missing argument #1: targetValue\")\13\
\9\13\
\9options = options or {}\13\
\13\
\9return setmetatable({\13\
\9\9_targetValue = targetValue,\13\
\9\9_velocity = options.velocity or 1,\13\
\9}, Linear)\13\
end\13\
\13\
function Linear:step(state, dt)\13\
\9local position = state.value\13\
\9local velocity = self._velocity -- Linear motion ignores the state's velocity\13\
\9local goal = self._targetValue\13\
\13\
\9local dPos = dt * velocity\13\
\13\
\9local complete = dPos >= math.abs(goal - position)\13\
\9position = position + dPos * (goal > position and 1 or -1)\13\
\9if complete then\13\
\9\9position = self._targetValue\13\
\9\9velocity = 0\13\
\9end\13\
\9\13\
\9return {\13\
\9\9complete = complete,\13\
\9\9value = position,\13\
\9\9velocity = velocity,\13\
\9}\13\
end\13\
\13\
return Linear", '@'.."RemoteSpy.include.node_modules.flipper.src.Linear")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.Linear")) return fn() end)

_module("Signal", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.Signal", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local Connection = {}\13\
Connection.__index = Connection\13\
\13\
function Connection.new(signal, handler)\13\
\9return setmetatable({\13\
\9\9signal = signal,\13\
\9\9connected = true,\13\
\9\9_handler = handler,\13\
\9}, Connection)\13\
end\13\
\13\
function Connection:disconnect()\13\
\9if self.connected then\13\
\9\9self.connected = false\13\
\13\
\9\9for index, connection in pairs(self.signal._connections) do\13\
\9\9\9if connection == self then\13\
\9\9\9\9table.remove(self.signal._connections, index)\13\
\9\9\9\9return\13\
\9\9\9end\13\
\9\9end\13\
\9end\13\
end\13\
\13\
local Signal = {}\13\
Signal.__index = Signal\13\
\13\
function Signal.new()\13\
\9return setmetatable({\13\
\9\9_connections = {},\13\
\9\9_threads = {},\13\
\9}, Signal)\13\
end\13\
\13\
function Signal:fire(...)\13\
\9for _, connection in pairs(self._connections) do\13\
\9\9connection._handler(...)\13\
\9end\13\
\13\
\9for _, thread in pairs(self._threads) do\13\
\9\9coroutine.resume(thread, ...)\13\
\9end\13\
\9\13\
\9self._threads = {}\13\
end\13\
\13\
function Signal:connect(handler)\13\
\9local connection = Connection.new(self, handler)\13\
\9table.insert(self._connections, connection)\13\
\9return connection\13\
end\13\
\13\
function Signal:wait()\13\
\9table.insert(self._threads, coroutine.running())\13\
\9return coroutine.yield()\13\
end\13\
\13\
return Signal", '@'.."RemoteSpy.include.node_modules.flipper.src.Signal")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.Signal")) return fn() end)

_module("SingleMotor", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.SingleMotor", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local BaseMotor = require(script.Parent.BaseMotor)\13\
\13\
local SingleMotor = setmetatable({}, BaseMotor)\13\
SingleMotor.__index = SingleMotor\13\
\13\
function SingleMotor.new(initialValue, useImplicitConnections)\13\
\9assert(initialValue, \"Missing argument #1: initialValue\")\13\
\9assert(typeof(initialValue) == \"number\", \"initialValue must be a number!\")\13\
\13\
\9local self = setmetatable(BaseMotor.new(), SingleMotor)\13\
\13\
\9if useImplicitConnections ~= nil then\13\
\9\9self._useImplicitConnections = useImplicitConnections\13\
\9else\13\
\9\9self._useImplicitConnections = true\13\
\9end\13\
\13\
\9self._goal = nil\13\
\9self._state = {\13\
\9\9complete = true,\13\
\9\9value = initialValue,\13\
\9}\13\
\13\
\9return self\13\
end\13\
\13\
function SingleMotor:step(deltaTime)\13\
\9if self._state.complete then\13\
\9\9return true\13\
\9end\13\
\13\
\9local newState = self._goal:step(self._state, deltaTime)\13\
\13\
\9self._state = newState\13\
\9self._onStep:fire(newState.value)\13\
\13\
\9if newState.complete then\13\
\9\9if self._useImplicitConnections then\13\
\9\9\9self:stop()\13\
\9\9end\13\
\13\
\9\9self._onComplete:fire()\13\
\9end\13\
\13\
\9return newState.complete\13\
end\13\
\13\
function SingleMotor:getValue()\13\
\9return self._state.value\13\
end\13\
\13\
function SingleMotor:setGoal(goal)\13\
\9self._state.complete = false\13\
\9self._goal = goal\13\
\13\
\9self._onStart:fire()\13\
\13\
\9if self._useImplicitConnections then\13\
\9\9self:start()\13\
\9end\13\
end\13\
\13\
function SingleMotor:__tostring()\13\
\9return \"Motor(Single)\"\13\
end\13\
\13\
return SingleMotor\13\
", '@'.."RemoteSpy.include.node_modules.flipper.src.SingleMotor")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.SingleMotor")) return fn() end)

_module("Spring", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.Spring", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local VELOCITY_THRESHOLD = 0.001\13\
local POSITION_THRESHOLD = 0.001\13\
\13\
local EPS = 0.0001\13\
\13\
local Spring = {}\13\
Spring.__index = Spring\13\
\13\
function Spring.new(targetValue, options)\13\
\9assert(targetValue, \"Missing argument #1: targetValue\")\13\
\9options = options or {}\13\
\13\
\9return setmetatable({\13\
\9\9_targetValue = targetValue,\13\
\9\9_frequency = options.frequency or 4,\13\
\9\9_dampingRatio = options.dampingRatio or 1,\13\
\9}, Spring)\13\
end\13\
\13\
function Spring:step(state, dt)\13\
\9-- Copyright 2018 Parker Stebbins (parker@fractality.io)\13\
\9-- github.com/Fraktality/Spring\13\
\9-- Distributed under the MIT license\13\
\13\
\9local d = self._dampingRatio\13\
\9local f = self._frequency*2*math.pi\13\
\9local g = self._targetValue\13\
\9local p0 = state.value\13\
\9local v0 = state.velocity or 0\13\
\13\
\9local offset = p0 - g\13\
\9local decay = math.exp(-d*f*dt)\13\
\13\
\9local p1, v1\13\
\13\
\9if d == 1 then -- Critically damped\13\
\9\9p1 = (offset*(1 + f*dt) + v0*dt)*decay + g\13\
\9\9v1 = (v0*(1 - f*dt) - offset*(f*f*dt))*decay\13\
\9elseif d < 1 then -- Underdamped\13\
\9\9local c = math.sqrt(1 - d*d)\13\
\13\
\9\9local i = math.cos(f*c*dt)\13\
\9\9local j = math.sin(f*c*dt)\13\
\13\
\9\9-- Damping ratios approaching 1 can cause division by small numbers.\13\
\9\9-- To fix that, group terms around z=j/c and find an approximation for z.\13\
\9\9-- Start with the definition of z:\13\
\9\9--    z = sin(dt*f*c)/c\13\
\9\9-- Substitute a=dt*f:\13\
\9\9--    z = sin(a*c)/c\13\
\9\9-- Take the Maclaurin expansion of z with respect to c:\13\
\9\9--    z = a - (a^3*c^2)/6 + (a^5*c^4)/120 + O(c^6)\13\
\9\9--    z ≈ a - (a^3*c^2)/6 + (a^5*c^4)/120\13\
\9\9-- Rewrite in Horner form:\13\
\9\9--    z ≈ a + ((a*a)*(c*c)*(c*c)/20 - c*c)*(a*a*a)/6\13\
\13\
\9\9local z\13\
\9\9if c > EPS then\13\
\9\9\9z = j/c\13\
\9\9else\13\
\9\9\9local a = dt*f\13\
\9\9\9z = a + ((a*a)*(c*c)*(c*c)/20 - c*c)*(a*a*a)/6\13\
\9\9end\13\
\13\
\9\9-- Frequencies approaching 0 present a similar problem.\13\
\9\9-- We want an approximation for y as f approaches 0, where:\13\
\9\9--    y = sin(dt*f*c)/(f*c)\13\
\9\9-- Substitute b=dt*c:\13\
\9\9--    y = sin(b*c)/b\13\
\9\9-- Now reapply the process from z.\13\
\13\
\9\9local y\13\
\9\9if f*c > EPS then\13\
\9\9\9y = j/(f*c)\13\
\9\9else\13\
\9\9\9local b = f*c\13\
\9\9\9y = dt + ((dt*dt)*(b*b)*(b*b)/20 - b*b)*(dt*dt*dt)/6\13\
\9\9end\13\
\13\
\9\9p1 = (offset*(i + d*z) + v0*y)*decay + g\13\
\9\9v1 = (v0*(i - z*d) - offset*(z*f))*decay\13\
\13\
\9else -- Overdamped\13\
\9\9local c = math.sqrt(d*d - 1)\13\
\13\
\9\9local r1 = -f*(d - c)\13\
\9\9local r2 = -f*(d + c)\13\
\13\
\9\9local co2 = (v0 - offset*r1)/(2*f*c)\13\
\9\9local co1 = offset - co2\13\
\13\
\9\9local e1 = co1*math.exp(r1*dt)\13\
\9\9local e2 = co2*math.exp(r2*dt)\13\
\13\
\9\9p1 = e1 + e2 + g\13\
\9\9v1 = e1*r1 + e2*r2\13\
\9end\13\
\13\
\9local complete = math.abs(v1) < VELOCITY_THRESHOLD and math.abs(p1 - g) < POSITION_THRESHOLD\13\
\9\13\
\9return {\13\
\9\9complete = complete,\13\
\9\9value = complete and g or p1,\13\
\9\9velocity = v1,\13\
\9}\13\
end\13\
\13\
return Spring", '@'.."RemoteSpy.include.node_modules.flipper.src.Spring")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.Spring")) return fn() end)

_module("isMotor", "ModuleScript", "RemoteSpy.include.node_modules.flipper.src.isMotor", "RemoteSpy.include.node_modules.flipper.src", function () local fn = assert(loadstring("local function isMotor(value)\13\
\9local motorType = tostring(value):match(\"^Motor%((.+)%)$\")\13\
\13\
\9if motorType then\13\
\9\9return true, motorType\13\
\9else\13\
\9\9return false\13\
\9end\13\
end\13\
\13\
return isMotor", '@'.."RemoteSpy.include.node_modules.flipper.src.isMotor")) setfenv(fn, _env("RemoteSpy.include.node_modules.flipper.src.isMotor")) return fn() end)

_instance("typings", "Folder", "RemoteSpy.include.node_modules.flipper.typings", "RemoteSpy.include.node_modules.flipper")

_instance("hax", "Folder", "RemoteSpy.include.node_modules.hax", "RemoteSpy.include.node_modules")

_instance("types", "Folder", "RemoteSpy.include.node_modules.hax.types", "RemoteSpy.include.node_modules.hax")

_module("make", "ModuleScript", "RemoteSpy.include.node_modules.make", "RemoteSpy.include.node_modules", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
--[[\
\9*\
\9* Returns a table wherein an object's writable properties can be specified,\
\9* while also allowing functions to be passed in which can be bound to a RBXScriptSignal.\
]]\
--[[\
\9*\
\9* Instantiates a new Instance of `className` with given `settings`,\
\9* where `settings` is an object of the form { [K: propertyName]: value }.\
\9*\
\9* `settings.Children` is an array of child objects to be parented to the generated Instance.\
\9*\
\9* Events can be set to a callback function, which will be connected.\
\9*\
\9* `settings.Parent` is always set last.\
]]\
local function Make(className, settings)\
\9local _binding = settings\
\9local children = _binding.Children\
\9local parent = _binding.Parent\
\9local instance = Instance.new(className)\
\9for setting, value in pairs(settings) do\
\9\9if setting ~= \"Children\" and setting ~= \"Parent\" then\
\9\9\9local _binding_1 = instance\
\9\9\9local prop = _binding_1[setting]\
\9\9\9if typeof(prop) == \"RBXScriptSignal\" then\
\9\9\9\9prop:Connect(value)\
\9\9\9else\
\9\9\9\9instance[setting] = value\
\9\9\9end\
\9\9end\
\9end\
\9if children then\
\9\9for _, child in ipairs(children) do\
\9\9\9child.Parent = instance\
\9\9end\
\9end\
\9instance.Parent = parent\
\9return instance\
end\
return Make\
", '@'.."RemoteSpy.include.node_modules.make")) setfenv(fn, _env("RemoteSpy.include.node_modules.make")) return fn() end)

_instance("node_modules", "Folder", "RemoteSpy.include.node_modules.make.node_modules", "RemoteSpy.include.node_modules.make")

_instance("@rbxts", "Folder", "RemoteSpy.include.node_modules.make.node_modules.@rbxts", "RemoteSpy.include.node_modules.make.node_modules")

_instance("compiler-types", "Folder", "RemoteSpy.include.node_modules.make.node_modules.@rbxts.compiler-types", "RemoteSpy.include.node_modules.make.node_modules.@rbxts")

_instance("types", "Folder", "RemoteSpy.include.node_modules.make.node_modules.@rbxts.compiler-types.types", "RemoteSpy.include.node_modules.make.node_modules.@rbxts.compiler-types")

_module("object-utils", "ModuleScript", "RemoteSpy.include.node_modules.object-utils", "RemoteSpy.include.node_modules", function () local fn = assert(loadstring("local HttpService = game:GetService(\"HttpService\")\
\
local Object = {}\
\
function Object.keys(object)\
\9local result = table.create(#object)\
\9for key in pairs(object) do\
\9\9result[#result + 1] = key\
\9end\
\9return result\
end\
\
function Object.values(object)\
\9local result = table.create(#object)\
\9for _, value in pairs(object) do\
\9\9result[#result + 1] = value\
\9end\
\9return result\
end\
\
function Object.entries(object)\
\9local result = table.create(#object)\
\9for key, value in pairs(object) do\
\9\9result[#result + 1] = { key, value }\
\9end\
\9return result\
end\
\
function Object.assign(toObj, ...)\
\9for i = 1, select(\"#\", ...) do\
\9\9local arg = select(i, ...)\
\9\9if type(arg) == \"table\" then\
\9\9\9for key, value in pairs(arg) do\
\9\9\9\9toObj[key] = value\
\9\9\9end\
\9\9end\
\9end\
\9return toObj\
end\
\
function Object.copy(object)\
\9local result = table.create(#object)\
\9for k, v in pairs(object) do\
\9\9result[k] = v\
\9end\
\9return result\
end\
\
local function deepCopyHelper(object, encountered)\
\9local result = table.create(#object)\
\9encountered[object] = result\
\
\9for k, v in pairs(object) do\
\9\9if type(k) == \"table\" then\
\9\9\9k = encountered[k] or deepCopyHelper(k, encountered)\
\9\9end\
\
\9\9if type(v) == \"table\" then\
\9\9\9v = encountered[v] or deepCopyHelper(v, encountered)\
\9\9end\
\
\9\9result[k] = v\
\9end\
\
\9return result\
end\
\
function Object.deepCopy(object)\
\9return deepCopyHelper(object, {})\
end\
\
function Object.deepEquals(a, b)\
\9-- a[k] == b[k]\
\9for k in pairs(a) do\
\9\9local av = a[k]\
\9\9local bv = b[k]\
\9\9if type(av) == \"table\" and type(bv) == \"table\" then\
\9\9\9local result = Object.deepEquals(av, bv)\
\9\9\9if not result then\
\9\9\9\9return false\
\9\9\9end\
\9\9elseif av ~= bv then\
\9\9\9return false\
\9\9end\
\9end\
\
\9-- extra keys in b\
\9for k in pairs(b) do\
\9\9if a[k] == nil then\
\9\9\9return false\
\9\9end\
\9end\
\
\9return true\
end\
\
function Object.toString(data)\
\9return HttpService:JSONEncode(data)\
end\
\
function Object.isEmpty(object)\
\9return next(object) == nil\
end\
\
function Object.fromEntries(entries)\
\9local entriesLen = #entries\
\
\9local result = table.create(entriesLen)\
\9if entries then\
\9\9for i = 1, entriesLen do\
\9\9\9local pair = entries[i]\
\9\9\9result[pair[1]] = pair[2]\
\9\9end\
\9end\
\9return result\
end\
\
return Object\
", '@'.."RemoteSpy.include.node_modules.object-utils")) setfenv(fn, _env("RemoteSpy.include.node_modules.object-utils")) return fn() end)

_instance("roact", "Folder", "RemoteSpy.include.node_modules.roact", "RemoteSpy.include.node_modules")

_module("src", "ModuleScript", "RemoteSpy.include.node_modules.roact.src", "RemoteSpy.include.node_modules.roact", function () local fn = assert(loadstring("--[[\
\9Packages up the internals of Roact and exposes a public API for it.\
]]\
\
local GlobalConfig = require(script.GlobalConfig)\
local createReconciler = require(script.createReconciler)\
local createReconcilerCompat = require(script.createReconcilerCompat)\
local RobloxRenderer = require(script.RobloxRenderer)\
local strict = require(script.strict)\
local Binding = require(script.Binding)\
\
local robloxReconciler = createReconciler(RobloxRenderer)\
local reconcilerCompat = createReconcilerCompat(robloxReconciler)\
\
local Roact = strict {\
\9Component = require(script.Component),\
\9createElement = require(script.createElement),\
\9createFragment = require(script.createFragment),\
\9oneChild = require(script.oneChild),\
\9PureComponent = require(script.PureComponent),\
\9None = require(script.None),\
\9Portal = require(script.Portal),\
\9createRef = require(script.createRef),\
\9forwardRef = require(script.forwardRef),\
\9createBinding = Binding.create,\
\9joinBindings = Binding.join,\
\9createContext = require(script.createContext),\
\
\9Change = require(script.PropMarkers.Change),\
\9Children = require(script.PropMarkers.Children),\
\9Event = require(script.PropMarkers.Event),\
\9Ref = require(script.PropMarkers.Ref),\
\
\9mount = robloxReconciler.mountVirtualTree,\
\9unmount = robloxReconciler.unmountVirtualTree,\
\9update = robloxReconciler.updateVirtualTree,\
\
\9reify = reconcilerCompat.reify,\
\9teardown = reconcilerCompat.teardown,\
\9reconcile = reconcilerCompat.reconcile,\
\
\9setGlobalConfig = GlobalConfig.set,\
\
\9-- APIs that may change in the future without warning\
\9UNSTABLE = {\
\9},\
}\
\
return Roact", '@'.."RemoteSpy.include.node_modules.roact.src")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src")) return fn() end)

_module("Binding", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.Binding", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local createSignal = require(script.Parent.createSignal)\
local Symbol = require(script.Parent.Symbol)\
local Type = require(script.Parent.Type)\
\
local config = require(script.Parent.GlobalConfig).get()\
\
local BindingImpl = Symbol.named(\"BindingImpl\")\
\
local BindingInternalApi = {}\
\
local bindingPrototype = {}\
\
function bindingPrototype:getValue()\
\9return BindingInternalApi.getValue(self)\
end\
\
function bindingPrototype:map(predicate)\
\9return BindingInternalApi.map(self, predicate)\
end\
\
local BindingPublicMeta = {\
\9__index = bindingPrototype,\
\9__tostring = function(self)\
\9\9return string.format(\"RoactBinding(%s)\", tostring(self:getValue()))\
\9end,\
}\
\
function BindingInternalApi.update(binding, newValue)\
\9return binding[BindingImpl].update(newValue)\
end\
\
function BindingInternalApi.subscribe(binding, callback)\
\9return binding[BindingImpl].subscribe(callback)\
end\
\
function BindingInternalApi.getValue(binding)\
\9return binding[BindingImpl].getValue()\
end\
\
function BindingInternalApi.create(initialValue)\
\9local impl = {\
\9\9value = initialValue,\
\9\9changeSignal = createSignal(),\
\9}\
\
\9function impl.subscribe(callback)\
\9\9return impl.changeSignal:subscribe(callback)\
\9end\
\
\9function impl.update(newValue)\
\9\9impl.value = newValue\
\9\9impl.changeSignal:fire(newValue)\
\9end\
\
\9function impl.getValue()\
\9\9return impl.value\
\9end\
\
\9return setmetatable({\
\9\9[Type] = Type.Binding,\
\9\9[BindingImpl] = impl,\
\9}, BindingPublicMeta), impl.update\
end\
\
function BindingInternalApi.map(upstreamBinding, predicate)\
\9if config.typeChecks then\
\9\9assert(Type.of(upstreamBinding) == Type.Binding, \"Expected arg #1 to be a binding\")\
\9\9assert(typeof(predicate) == \"function\", \"Expected arg #1 to be a function\")\
\9end\
\
\9local impl = {}\
\
\9function impl.subscribe(callback)\
\9\9return BindingInternalApi.subscribe(upstreamBinding, function(newValue)\
\9\9\9callback(predicate(newValue))\
\9\9end)\
\9end\
\
\9function impl.update(newValue)\
\9\9error(\"Bindings created by Binding:map(fn) cannot be updated directly\", 2)\
\9end\
\
\9function impl.getValue()\
\9\9return predicate(upstreamBinding:getValue())\
\9end\
\
\9return setmetatable({\
\9\9[Type] = Type.Binding,\
\9\9[BindingImpl] = impl,\
\9}, BindingPublicMeta)\
end\
\
function BindingInternalApi.join(upstreamBindings)\
\9if config.typeChecks then\
\9\9assert(typeof(upstreamBindings) == \"table\", \"Expected arg #1 to be of type table\")\
\
\9\9for key, value in pairs(upstreamBindings) do\
\9\9\9if Type.of(value) ~= Type.Binding then\
\9\9\9\9local message = (\
\9\9\9\9\9\"Expected arg #1 to contain only bindings, but key %q had a non-binding value\"\
\9\9\9\9):format(\
\9\9\9\9\9tostring(key)\
\9\9\9\9)\
\9\9\9\9error(message, 2)\
\9\9\9end\
\9\9end\
\9end\
\
\9local impl = {}\
\
\9local function getValue()\
\9\9local value = {}\
\
\9\9for key, upstream in pairs(upstreamBindings) do\
\9\9\9value[key] = upstream:getValue()\
\9\9end\
\
\9\9return value\
\9end\
\
\9function impl.subscribe(callback)\
\9\9local disconnects = {}\
\
\9\9for key, upstream in pairs(upstreamBindings) do\
\9\9\9disconnects[key] = BindingInternalApi.subscribe(upstream, function(newValue)\
\9\9\9\9callback(getValue())\
\9\9\9end)\
\9\9end\
\
\9\9return function()\
\9\9\9if disconnects == nil then\
\9\9\9\9return\
\9\9\9end\
\
\9\9\9for _, disconnect in pairs(disconnects) do\
\9\9\9\9disconnect()\
\9\9\9end\
\
\9\9\9disconnects = nil\
\9\9end\
\9end\
\
\9function impl.update(newValue)\
\9\9error(\"Bindings created by joinBindings(...) cannot be updated directly\", 2)\
\9end\
\
\9function impl.getValue()\
\9\9return getValue()\
\9end\
\
\9return setmetatable({\
\9\9[Type] = Type.Binding,\
\9\9[BindingImpl] = impl,\
\9}, BindingPublicMeta)\
end\
\
return BindingInternalApi", '@'.."RemoteSpy.include.node_modules.roact.src.Binding")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.Binding")) return fn() end)

_module("Component", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.Component", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local assign = require(script.Parent.assign)\
local ComponentLifecyclePhase = require(script.Parent.ComponentLifecyclePhase)\
local Type = require(script.Parent.Type)\
local Symbol = require(script.Parent.Symbol)\
local invalidSetStateMessages = require(script.Parent.invalidSetStateMessages)\
local internalAssert = require(script.Parent.internalAssert)\
\
local config = require(script.Parent.GlobalConfig).get()\
\
--[[\
\9Calling setState during certain lifecycle allowed methods has the potential\
\9to create an infinitely updating component. Rather than time out, we exit\
\9with an error if an unreasonable number of self-triggering updates occur\
]]\
local MAX_PENDING_UPDATES = 100\
\
local InternalData = Symbol.named(\"InternalData\")\
\
local componentMissingRenderMessage = [[\
The component %q is missing the `render` method.\
`render` must be defined when creating a Roact component!]]\
\
local tooManyUpdatesMessage = [[\
The component %q has reached the setState update recursion limit.\
When using `setState` in `didUpdate`, make sure that it won't repeat infinitely!]]\
\
local componentClassMetatable = {}\
\
function componentClassMetatable:__tostring()\
\9return self.__componentName\
end\
\
local Component = {}\
setmetatable(Component, componentClassMetatable)\
\
Component[Type] = Type.StatefulComponentClass\
Component.__index = Component\
Component.__componentName = \"Component\"\
\
--[[\
\9A method called by consumers of Roact to create a new component class.\
\9Components can not be extended beyond this point, with the exception of\
\9PureComponent.\
]]\
function Component:extend(name)\
\9if config.typeChecks then\
\9\9assert(Type.of(self) == Type.StatefulComponentClass, \"Invalid `self` argument to `extend`.\")\
\9\9assert(typeof(name) == \"string\", \"Component class name must be a string\")\
\9end\
\
\9local class = {}\
\
\9for key, value in pairs(self) do\
\9\9-- Roact opts to make consumers use composition over inheritance, which\
\9\9-- lines up with React.\
\9\9-- https://reactjs.org/docs/composition-vs-inheritance.html\
\9\9if key ~= \"extend\" then\
\9\9\9class[key] = value\
\9\9end\
\9end\
\
\9class[Type] = Type.StatefulComponentClass\
\9class.__index = class\
\9class.__componentName = name\
\
\9setmetatable(class, componentClassMetatable)\
\
\9return class\
end\
\
function Component:__getDerivedState(incomingProps, incomingState)\
\9if config.internalTypeChecks then\
\9\9internalAssert(Type.of(self) == Type.StatefulComponentInstance, \"Invalid use of `__getDerivedState`\")\
\9end\
\
\9local internalData = self[InternalData]\
\9local componentClass = internalData.componentClass\
\
\9if componentClass.getDerivedStateFromProps ~= nil then\
\9\9local derivedState = componentClass.getDerivedStateFromProps(incomingProps, incomingState)\
\
\9\9if derivedState ~= nil then\
\9\9\9if config.typeChecks then\
\9\9\9\9assert(typeof(derivedState) == \"table\", \"getDerivedStateFromProps must return a table!\")\
\9\9\9end\
\
\9\9\9return derivedState\
\9\9end\
\9end\
\
\9return nil\
end\
\
function Component:setState(mapState)\
\9if config.typeChecks then\
\9\9assert(Type.of(self) == Type.StatefulComponentInstance, \"Invalid `self` argument to `extend`.\")\
\9end\
\
\9local internalData = self[InternalData]\
\9local lifecyclePhase = internalData.lifecyclePhase\
\
\9--[[\
\9\9When preparing to update, rendering, or unmounting, it is not safe\
\9\9to call `setState` as it will interfere with in-flight updates. It's\
\9\9also disallowed during unmounting\
\9]]\
\9if lifecyclePhase == ComponentLifecyclePhase.ShouldUpdate or\
\9\9lifecyclePhase == ComponentLifecyclePhase.WillUpdate or\
\9\9lifecyclePhase == ComponentLifecyclePhase.Render or\
\9\9lifecyclePhase == ComponentLifecyclePhase.WillUnmount\
\9then\
\9\9local messageTemplate = invalidSetStateMessages[internalData.lifecyclePhase]\
\
\9\9local message = messageTemplate:format(tostring(internalData.componentClass))\
\
\9\9error(message, 2)\
\9end\
\
\9local pendingState = internalData.pendingState\
\
\9local partialState\
\9if typeof(mapState) == \"function\" then\
\9\9partialState = mapState(pendingState or self.state, self.props)\
\
\9\9-- Abort the state update if the given state updater function returns nil\
\9\9if partialState == nil then\
\9\9\9return\
\9\9end\
\9elseif typeof(mapState) == \"table\" then\
\9\9partialState = mapState\
\9else\
\9\9error(\"Invalid argument to setState, expected function or table\", 2)\
\9end\
\
\9local newState\
\9if pendingState ~= nil then\
\9\9newState = assign(pendingState, partialState)\
\9else\
\9\9newState = assign({}, self.state, partialState)\
\9end\
\
\9if lifecyclePhase == ComponentLifecyclePhase.Init then\
\9\9-- If `setState` is called in `init`, we can skip triggering an update!\
\9\9local derivedState = self:__getDerivedState(self.props, newState)\
\9\9self.state = assign(newState, derivedState)\
\
\9elseif lifecyclePhase == ComponentLifecyclePhase.DidMount or\
\9\9lifecyclePhase == ComponentLifecyclePhase.DidUpdate or\
\9\9lifecyclePhase == ComponentLifecyclePhase.ReconcileChildren\
\9then\
\9\9--[[\
\9\9\9During certain phases of the component lifecycle, it's acceptable to\
\9\9\9allow `setState` but defer the update until we're done with ones in flight.\
\9\9\9We do this by collapsing it into any pending updates we have.\
\9\9]]\
\9\9local derivedState = self:__getDerivedState(self.props, newState)\
\9\9internalData.pendingState = assign(newState, derivedState)\
\
\9elseif lifecyclePhase == ComponentLifecyclePhase.Idle then\
\9\9-- Pause parent events when we are updated outside of our lifecycle\
\9\9-- If these events are not paused, our setState can cause a component higher up the\
\9\9-- tree to rerender based on events caused by our component while this reconciliation is happening.\
\9\9-- This could cause the tree to become invalid.\
\9\9local virtualNode = internalData.virtualNode\
\9\9local reconciler = internalData.reconciler\
\9\9if config.tempFixUpdateChildrenReEntrancy then\
\9\9\9reconciler.suspendParentEvents(virtualNode)\
\9\9end\
\
\9\9-- Outside of our lifecycle, the state update is safe to make immediately\
\9\9self:__update(nil, newState)\
\
\9\9if config.tempFixUpdateChildrenReEntrancy then\
\9\9\9reconciler.resumeParentEvents(virtualNode)\
\9\9end\
\9else\
\9\9local messageTemplate = invalidSetStateMessages.default\
\
\9\9local message = messageTemplate:format(tostring(internalData.componentClass))\
\
\9\9error(message, 2)\
\9end\
end\
\
--[[\
\9Returns the stack trace of where the element was created that this component\
\9instance's properties are based on.\
\
\9Intended to be used primarily by diagnostic tools.\
]]\
function Component:getElementTraceback()\
\9return self[InternalData].virtualNode.currentElement.source\
end\
\
--[[\
\9Returns a snapshot of this component given the current props and state. Must\
\9be overridden by consumers of Roact and should be a pure function with\
\9regards to props and state.\
\
\9TODO (#199): Accept props and state as arguments.\
]]\
function Component:render()\
\9local internalData = self[InternalData]\
\
\9local message = componentMissingRenderMessage:format(\
\9\9tostring(internalData.componentClass)\
\9)\
\
\9error(message, 0)\
end\
\
--[[\
\9Retrieves the context value corresponding to the given key. Can return nil\
\9if a requested context key is not present\
]]\
function Component:__getContext(key)\
\9if config.internalTypeChecks then\
\9\9internalAssert(Type.of(self) == Type.StatefulComponentInstance, \"Invalid use of `__getContext`\")\
\9\9internalAssert(key ~= nil, \"Context key cannot be nil\")\
\9end\
\
\9local virtualNode = self[InternalData].virtualNode\
\9local context = virtualNode.context\
\
\9return context[key]\
end\
\
--[[\
\9Adds a new context entry to this component's context table (which will be\
\9passed down to child components).\
]]\
function Component:__addContext(key, value)\
\9if config.internalTypeChecks then\
\9\9internalAssert(Type.of(self) == Type.StatefulComponentInstance, \"Invalid use of `__addContext`\")\
\9end\
\9local virtualNode = self[InternalData].virtualNode\
\
\9-- Make sure we store a reference to the component's original, unmodified\
\9-- context the virtual node. In the reconciler, we'll restore the original\
\9-- context if we need to replace the node (this happens when a node gets\
\9-- re-rendered as a different component)\
\9if virtualNode.originalContext == nil then\
\9\9virtualNode.originalContext = virtualNode.context\
\9end\
\
\9-- Build a new context table on top of the existing one, then apply it to\
\9-- our virtualNode\
\9local existing = virtualNode.context\
\9virtualNode.context = assign({}, existing, { [key] = value })\
end\
\
--[[\
\9Performs property validation if the static method validateProps is declared.\
\9validateProps should follow assert's expected arguments:\
\9(false, message: string) | true. The function may return a message in the\
\9true case; it will be ignored. If this fails, the function will throw the\
\9error.\
]]\
function Component:__validateProps(props)\
\9if not config.propValidation then\
\9\9return\
\9end\
\
\9local validator = self[InternalData].componentClass.validateProps\
\
\9if validator == nil then\
\9\9return\
\9end\
\
\9if typeof(validator) ~= \"function\" then\
\9\9error((\"validateProps must be a function, but it is a %s.\\nCheck the definition of the component %q.\"):format(\
\9\9\9typeof(validator),\
\9\9\9self.__componentName\
\9\9))\
\9end\
\
\9local success, failureReason = validator(props)\
\
\9if not success then\
\9\9failureReason = failureReason or \"<Validator function did not supply a message>\"\
\9\9error((\"Property validation failed in %s: %s\\n\\n%s\"):format(\
\9\9\9self.__componentName,\
\9\9\9tostring(failureReason),\
\9\9\9self:getElementTraceback() or \"<enable element tracebacks>\"),\
\9\0090)\
\9end\
end\
\
--[[\
\9An internal method used by the reconciler to construct a new component\
\9instance and attach it to the given virtualNode.\
]]\
function Component:__mount(reconciler, virtualNode)\
\9if config.internalTypeChecks then\
\9\9internalAssert(Type.of(self) == Type.StatefulComponentClass, \"Invalid use of `__mount`\")\
\9\9internalAssert(Type.of(virtualNode) == Type.VirtualNode, \"Expected arg #2 to be of type VirtualNode\")\
\9end\
\
\9local currentElement = virtualNode.currentElement\
\9local hostParent = virtualNode.hostParent\
\
\9-- Contains all the information that we want to keep from consumers of\
\9-- Roact, or even other parts of the codebase like the reconciler.\
\9local internalData = {\
\9\9reconciler = reconciler,\
\9\9virtualNode = virtualNode,\
\9\9componentClass = self,\
\9\9lifecyclePhase = ComponentLifecyclePhase.Init,\
\9}\
\
\9local instance = {\
\9\9[Type] = Type.StatefulComponentInstance,\
\9\9[InternalData] = internalData,\
\9}\
\
\9setmetatable(instance, self)\
\
\9virtualNode.instance = instance\
\
\9local props = currentElement.props\
\
\9if self.defaultProps ~= nil then\
\9\9props = assign({}, self.defaultProps, props)\
\9end\
\
\9instance:__validateProps(props)\
\
\9instance.props = props\
\
\9local newContext = assign({}, virtualNode.legacyContext)\
\9instance._context = newContext\
\
\9instance.state = assign({}, instance:__getDerivedState(instance.props, {}))\
\
\9if instance.init ~= nil then\
\9\9instance:init(instance.props)\
\9\9assign(instance.state, instance:__getDerivedState(instance.props, instance.state))\
\9end\
\
\9-- It's possible for init() to redefine _context!\
\9virtualNode.legacyContext = instance._context\
\
\9internalData.lifecyclePhase = ComponentLifecyclePhase.Render\
\9local renderResult = instance:render()\
\
\9internalData.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren\
\9reconciler.updateVirtualNodeWithRenderResult(virtualNode, hostParent, renderResult)\
\
\9if instance.didMount ~= nil then\
\9\9internalData.lifecyclePhase = ComponentLifecyclePhase.DidMount\
\9\9instance:didMount()\
\9end\
\
\9if internalData.pendingState ~= nil then\
\9\9-- __update will handle pendingState, so we don't pass any new element or state\
\9\9instance:__update(nil, nil)\
\9end\
\
\9internalData.lifecyclePhase = ComponentLifecyclePhase.Idle\
end\
\
--[[\
\9Internal method used by the reconciler to clean up any resources held by\
\9this component instance.\
]]\
function Component:__unmount()\
\9if config.internalTypeChecks then\
\9\9internalAssert(Type.of(self) == Type.StatefulComponentInstance, \"Invalid use of `__unmount`\")\
\9end\
\
\9local internalData = self[InternalData]\
\9local virtualNode = internalData.virtualNode\
\9local reconciler = internalData.reconciler\
\
\9if self.willUnmount ~= nil then\
\9\9internalData.lifecyclePhase = ComponentLifecyclePhase.WillUnmount\
\9\9self:willUnmount()\
\9end\
\
\9for _, childNode in pairs(virtualNode.children) do\
\9\9reconciler.unmountVirtualNode(childNode)\
\9end\
end\
\
--[[\
\9Internal method used by setState (to trigger updates based on state) and by\
\9the reconciler (to trigger updates based on props)\
\
\9Returns true if the update was completed, false if it was cancelled by shouldUpdate\
]]\
function Component:__update(updatedElement, updatedState)\
\9if config.internalTypeChecks then\
\9\9internalAssert(Type.of(self) == Type.StatefulComponentInstance, \"Invalid use of `__update`\")\
\9\9internalAssert(\
\9\9\9Type.of(updatedElement) == Type.Element or updatedElement == nil,\
\9\9\9\"Expected arg #1 to be of type Element or nil\"\
\9\9)\
\9\9internalAssert(\
\9\9\9typeof(updatedState) == \"table\" or updatedState == nil,\
\9\9\9\"Expected arg #2 to be of type table or nil\"\
\9\9)\
\9end\
\
\9local internalData = self[InternalData]\
\9local componentClass = internalData.componentClass\
\
\9local newProps = self.props\
\9if updatedElement ~= nil then\
\9\9newProps = updatedElement.props\
\
\9\9if componentClass.defaultProps ~= nil then\
\9\9\9newProps = assign({}, componentClass.defaultProps, newProps)\
\9\9end\
\
\9\9self:__validateProps(newProps)\
\9end\
\
\9local updateCount = 0\
\9repeat\
\9\9local finalState\
\9\9local pendingState = nil\
\
\9\9-- Consume any pending state we might have\
\9\9if internalData.pendingState ~= nil then\
\9\9\9pendingState = internalData.pendingState\
\9\9\9internalData.pendingState = nil\
\9\9end\
\
\9\9-- Consume a standard update to state or props\
\9\9if updatedState ~= nil or newProps ~= self.props then\
\9\9\9if pendingState == nil then\
\9\9\9\9finalState = updatedState or self.state\
\9\9\9else\
\9\9\9\9finalState = assign(pendingState, updatedState)\
\9\9\9end\
\
\9\9\9local derivedState = self:__getDerivedState(newProps, finalState)\
\
\9\9\9if derivedState ~= nil then\
\9\9\9\9finalState = assign({}, finalState, derivedState)\
\9\9\9end\
\
\9\9\9updatedState = nil\
\9\9else\
\9\9\9finalState = pendingState\
\9\9end\
\
\9\9if not self:__resolveUpdate(newProps, finalState) then\
\9\9\9-- If the update was short-circuited, bubble the result up to the caller\
\9\9\9return false\
\9\9end\
\
\9\9updateCount = updateCount + 1\
\
\9\9if updateCount > MAX_PENDING_UPDATES then\
\9\9\9error(tooManyUpdatesMessage:format(tostring(internalData.componentClass)), 3)\
\9\9end\
\9until internalData.pendingState == nil\
\
\9return true\
end\
\
--[[\
\9Internal method used by __update to apply new props and state\
\
\9Returns true if the update was completed, false if it was cancelled by shouldUpdate\
]]\
function Component:__resolveUpdate(incomingProps, incomingState)\
\9if config.internalTypeChecks then\
\9\9internalAssert(Type.of(self) == Type.StatefulComponentInstance, \"Invalid use of `__resolveUpdate`\")\
\9end\
\
\9local internalData = self[InternalData]\
\9local virtualNode = internalData.virtualNode\
\9local reconciler = internalData.reconciler\
\
\9local oldProps = self.props\
\9local oldState = self.state\
\
\9if incomingProps == nil then\
\9\9incomingProps = oldProps\
\9end\
\9if incomingState == nil then\
\9\9incomingState = oldState\
\9end\
\
\9if self.shouldUpdate ~= nil then\
\9\9internalData.lifecyclePhase = ComponentLifecyclePhase.ShouldUpdate\
\9\9local continueWithUpdate = self:shouldUpdate(incomingProps, incomingState)\
\
\9\9if not continueWithUpdate then\
\9\9\9internalData.lifecyclePhase = ComponentLifecyclePhase.Idle\
\9\9\9return false\
\9\9end\
\9end\
\
\9if self.willUpdate ~= nil then\
\9\9internalData.lifecyclePhase = ComponentLifecyclePhase.WillUpdate\
\9\9self:willUpdate(incomingProps, incomingState)\
\9end\
\
\9internalData.lifecyclePhase = ComponentLifecyclePhase.Render\
\
\9self.props = incomingProps\
\9self.state = incomingState\
\
\9local renderResult = virtualNode.instance:render()\
\
\9internalData.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren\
\9reconciler.updateVirtualNodeWithRenderResult(virtualNode, virtualNode.hostParent, renderResult)\
\
\9if self.didUpdate ~= nil then\
\9\9internalData.lifecyclePhase = ComponentLifecyclePhase.DidUpdate\
\9\9self:didUpdate(oldProps, oldState)\
\9end\
\
\9internalData.lifecyclePhase = ComponentLifecyclePhase.Idle\
\9return true\
end\
\
return Component", '@'.."RemoteSpy.include.node_modules.roact.src.Component")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.Component")) return fn() end)

_module("ComponentLifecyclePhase", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.ComponentLifecyclePhase", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local Symbol = require(script.Parent.Symbol)\
local strict = require(script.Parent.strict)\
\
local ComponentLifecyclePhase = strict({\
\9-- Component methods\
\9Init = Symbol.named(\"init\"),\
\9Render = Symbol.named(\"render\"),\
\9ShouldUpdate = Symbol.named(\"shouldUpdate\"),\
\9WillUpdate = Symbol.named(\"willUpdate\"),\
\9DidMount = Symbol.named(\"didMount\"),\
\9DidUpdate = Symbol.named(\"didUpdate\"),\
\9WillUnmount = Symbol.named(\"willUnmount\"),\
\
\9-- Phases describing reconciliation status\
\9ReconcileChildren = Symbol.named(\"reconcileChildren\"),\
\9Idle = Symbol.named(\"idle\"),\
}, \"ComponentLifecyclePhase\")\
\
return ComponentLifecyclePhase", '@'.."RemoteSpy.include.node_modules.roact.src.ComponentLifecyclePhase")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.ComponentLifecyclePhase")) return fn() end)

_module("Config", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.Config", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Exposes an interface to set global configuration values for Roact.\
\
\9Configuration can only occur once, and should only be done by an application\
\9using Roact, not a library.\
\
\9Any keys that aren't recognized will cause errors. Configuration is only\
\9intended for configuring Roact itself, not extensions or libraries.\
\
\9Configuration is expected to be set immediately after loading Roact. Setting\
\9configuration values after an application starts may produce unpredictable\
\9behavior.\
]]\
\
-- Every valid configuration value should be non-nil in this table.\
local defaultConfig = {\
\9-- Enables asserts for internal Roact APIs. Useful for debugging Roact itself.\
\9[\"internalTypeChecks\"] = false,\
\9-- Enables stricter type asserts for Roact's public API.\
\9[\"typeChecks\"] = false,\
\9-- Enables storage of `debug.traceback()` values on elements for debugging.\
\9[\"elementTracing\"] = false,\
\9-- Enables validation of component props in stateful components.\
\9[\"propValidation\"] = false,\
\
\9-- Temporary config for enabling a bug fix for processing events based on updates to child instances\
\9-- outside of the standard lifecycle.\
\9[\"tempFixUpdateChildrenReEntrancy\"] = false,\
}\
\
-- Build a list of valid configuration values up for debug messages.\
local defaultConfigKeys = {}\
for key in pairs(defaultConfig) do\
\9table.insert(defaultConfigKeys, key)\
end\
\
local Config = {}\
\
function Config.new()\
\9local self = {}\
\
\9self._currentConfig = setmetatable({}, {\
\9\9__index = function(_, key)\
\9\9\9local message = (\
\9\9\9\9\"Invalid global configuration key %q. Valid configuration keys are: %s\"\
\9\9\9):format(\
\9\9\9\9tostring(key),\
\9\9\9\9table.concat(defaultConfigKeys, \", \")\
\9\9\9)\
\
\9\9\9error(message, 3)\
\9\9end\
\9})\
\
\9-- We manually bind these methods here so that the Config's methods can be\
\9-- used without passing in self, since they eventually get exposed on the\
\9-- root Roact object.\
\9self.set = function(...)\
\9\9return Config.set(self, ...)\
\9end\
\
\9self.get = function(...)\
\9\9return Config.get(self, ...)\
\9end\
\
\9self.scoped = function(...)\
\9\9return Config.scoped(self, ...)\
\9end\
\
\9self.set(defaultConfig)\
\
\9return self\
end\
\
function Config:set(configValues)\
\9-- Validate values without changing any configuration.\
\9-- We only want to apply this configuration if it's valid!\
\9for key, value in pairs(configValues) do\
\9\9if defaultConfig[key] == nil then\
\9\9\9local message = (\
\9\9\9\9\"Invalid global configuration key %q (type %s). Valid configuration keys are: %s\"\
\9\9\9):format(\
\9\9\9\9tostring(key),\
\9\9\9\9typeof(key),\
\9\9\9\9table.concat(defaultConfigKeys, \", \")\
\9\9\9)\
\
\9\9\9error(message, 3)\
\9\9end\
\
\9\9-- Right now, all configuration values must be boolean.\
\9\9if typeof(value) ~= \"boolean\" then\
\9\9\9local message = (\
\9\9\9\9\"Invalid value %q (type %s) for global configuration key %q. Valid values are: true, false\"\
\9\9\9):format(\
\9\9\9\9tostring(value),\
\9\9\9\9typeof(value),\
\9\9\9\9tostring(key)\
\9\9\9)\
\
\9\9\9error(message, 3)\
\9\9end\
\
\9\9self._currentConfig[key] = value\
\9end\
end\
\
function Config:get()\
\9return self._currentConfig\
end\
\
function Config:scoped(configValues, callback)\
\9local previousValues = {}\
\9for key, value in pairs(self._currentConfig) do\
\9\9previousValues[key] = value\
\9end\
\
\9self.set(configValues)\
\
\9local success, result = pcall(callback)\
\
\9self.set(previousValues)\
\
\9assert(success, result)\
end\
\
return Config", '@'.."RemoteSpy.include.node_modules.roact.src.Config")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.Config")) return fn() end)

_module("ElementKind", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.ElementKind", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Contains markers for annotating the type of an element.\
\
\9Use `ElementKind` as a key, and values from it as the value.\
\
\9\9local element = {\
\9\9\9[ElementKind] = ElementKind.Host,\
\9\9}\
]]\
\
local Symbol = require(script.Parent.Symbol)\
local strict = require(script.Parent.strict)\
local Portal = require(script.Parent.Portal)\
\
local ElementKind = newproxy(true)\
\
local ElementKindInternal = {\
\9Portal = Symbol.named(\"Portal\"),\
\9Host = Symbol.named(\"Host\"),\
\9Function = Symbol.named(\"Function\"),\
\9Stateful = Symbol.named(\"Stateful\"),\
\9Fragment = Symbol.named(\"Fragment\"),\
}\
\
function ElementKindInternal.of(value)\
\9if typeof(value) ~= \"table\" then\
\9\9return nil\
\9end\
\
\9return value[ElementKind]\
end\
\
local componentTypesToKinds = {\
\9[\"string\"] = ElementKindInternal.Host,\
\9[\"function\"] = ElementKindInternal.Function,\
\9[\"table\"] = ElementKindInternal.Stateful,\
}\
\
function ElementKindInternal.fromComponent(component)\
\9if component == Portal then\
\9\9return ElementKind.Portal\
\9else\
\9\9return componentTypesToKinds[typeof(component)]\
\9end\
end\
\
getmetatable(ElementKind).__index = ElementKindInternal\
\
strict(ElementKindInternal, \"ElementKind\")\
\
return ElementKind", '@'.."RemoteSpy.include.node_modules.roact.src.ElementKind")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.ElementKind")) return fn() end)

_module("ElementUtils", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.ElementUtils", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local Type = require(script.Parent.Type)\
local Symbol = require(script.Parent.Symbol)\
\
local function noop()\
\9return nil\
end\
\
local ElementUtils = {}\
\
--[[\
\9A signal value indicating that a child should use its parent's key, because\
\9it has no key of its own.\
\
\9This occurs when you return only one element from a function component or\
\9stateful render function.\
]]\
ElementUtils.UseParentKey = Symbol.named(\"UseParentKey\")\
\
--[[\
\9Returns an iterator over the children of an element.\
\9`elementOrElements` may be one of:\
\9* a boolean\
\9* nil\
\9* a single element\
\9* a fragment\
\9* a table of elements\
\
\9If `elementOrElements` is a boolean or nil, this will return an iterator with\
\9zero elements.\
\
\9If `elementOrElements` is a single element, this will return an iterator with\
\9one element: a tuple where the first value is ElementUtils.UseParentKey, and\
\9the second is the value of `elementOrElements`.\
\
\9If `elementOrElements` is a fragment or a table, this will return an iterator\
\9over all the elements of the array.\
\
\9If `elementOrElements` is none of the above, this function will throw.\
]]\
function ElementUtils.iterateElements(elementOrElements)\
\9local richType = Type.of(elementOrElements)\
\
\9-- Single child\
\9if richType == Type.Element then\
\9\9local called = false\
\
\9\9return function()\
\9\9\9if called then\
\9\9\9\9return nil\
\9\9\9else\
\9\9\9\9called = true\
\9\9\9\9return ElementUtils.UseParentKey, elementOrElements\
\9\9\9end\
\9\9end\
\9end\
\
\9local regularType = typeof(elementOrElements)\
\
\9if elementOrElements == nil or regularType == \"boolean\" then\
\9\9return noop\
\9end\
\
\9if regularType == \"table\" then\
\9\9return pairs(elementOrElements)\
\9end\
\
\9error(\"Invalid elements\")\
end\
\
--[[\
\9Gets the child corresponding to a given key, respecting Roact's rules for\
\9children. Specifically:\
\9* If `elements` is nil or a boolean, this will return `nil`, regardless of\
\9\9the key given.\
\9* If `elements` is a single element, this will return `nil`, unless the key\
\9\9is ElementUtils.UseParentKey.\
\9* If `elements` is a table of elements, this will return `elements[key]`.\
]]\
function ElementUtils.getElementByKey(elements, hostKey)\
\9if elements == nil or typeof(elements) == \"boolean\" then\
\9\9return nil\
\9end\
\
\9if Type.of(elements) == Type.Element then\
\9\9if hostKey == ElementUtils.UseParentKey then\
\9\9\9return elements\
\9\9end\
\
\9\9return nil\
\9end\
\
\9if typeof(elements) == \"table\" then\
\9\9return elements[hostKey]\
\9end\
\
\9error(\"Invalid elements\")\
end\
\
return ElementUtils", '@'.."RemoteSpy.include.node_modules.roact.src.ElementUtils")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.ElementUtils")) return fn() end)

_module("GlobalConfig", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.GlobalConfig", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Exposes a single instance of a configuration as Roact's GlobalConfig.\
]]\
\
local Config = require(script.Parent.Config)\
\
return Config.new()", '@'.."RemoteSpy.include.node_modules.roact.src.GlobalConfig")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.GlobalConfig")) return fn() end)

_module("Logging", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.Logging", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Centralized place to handle logging. Lets us:\
\9- Unit test log output via `Logging.capture`\
\9- Disable verbose log messages when not debugging Roact\
\
\9This should be broken out into a separate library with the addition of\
\9scoping and logging configuration.\
]]\
\
-- Determines whether log messages will go to stdout/stderr\
local outputEnabled = true\
\
-- A set of LogInfo objects that should have messages inserted into them.\
-- This is a set so that nested calls to Logging.capture will behave.\
local collectors = {}\
\
-- A set of all stack traces that have called warnOnce.\
local onceUsedLocations = {}\
\
--[[\
\9Indent a potentially multi-line string with the given number of tabs, in\
\9addition to any indentation the string already has.\
]]\
local function indent(source, indentLevel)\
\9local indentString = (\"\\t\"):rep(indentLevel)\
\
\9return indentString .. source:gsub(\"\\n\", \"\\n\" .. indentString)\
end\
\
--[[\
\9Indents a list of strings and then concatenates them together with newlines\
\9into a single string.\
]]\
local function indentLines(lines, indentLevel)\
\9local outputBuffer = {}\
\
\9for _, line in ipairs(lines) do\
\9\9table.insert(outputBuffer, indent(line, indentLevel))\
\9end\
\
\9return table.concat(outputBuffer, \"\\n\")\
end\
\
local logInfoMetatable = {}\
\
--[[\
\9Automatic coercion to strings for LogInfo objects to enable debugging them\
\9more easily.\
]]\
function logInfoMetatable:__tostring()\
\9local outputBuffer = {\"LogInfo {\"}\
\
\9local errorCount = #self.errors\
\9local warningCount = #self.warnings\
\9local infosCount = #self.infos\
\
\9if errorCount + warningCount + infosCount == 0 then\
\9\9table.insert(outputBuffer, \"\\t(no messages)\")\
\9end\
\
\9if errorCount > 0 then\
\9\9table.insert(outputBuffer, (\"\\tErrors (%d) {\"):format(errorCount))\
\9\9table.insert(outputBuffer, indentLines(self.errors, 2))\
\9\9table.insert(outputBuffer, \"\\t}\")\
\9end\
\
\9if warningCount > 0 then\
\9\9table.insert(outputBuffer, (\"\\tWarnings (%d) {\"):format(warningCount))\
\9\9table.insert(outputBuffer, indentLines(self.warnings, 2))\
\9\9table.insert(outputBuffer, \"\\t}\")\
\9end\
\
\9if infosCount > 0 then\
\9\9table.insert(outputBuffer, (\"\\tInfos (%d) {\"):format(infosCount))\
\9\9table.insert(outputBuffer, indentLines(self.infos, 2))\
\9\9table.insert(outputBuffer, \"\\t}\")\
\9end\
\
\9table.insert(outputBuffer, \"}\")\
\
\9return table.concat(outputBuffer, \"\\n\")\
end\
\
local function createLogInfo()\
\9local logInfo = {\
\9\9errors = {},\
\9\9warnings = {},\
\9\9infos = {},\
\9}\
\
\9setmetatable(logInfo, logInfoMetatable)\
\
\9return logInfo\
end\
\
local Logging = {}\
\
--[[\
\9Invokes `callback`, capturing all output that happens during its execution.\
\
\9Output will not go to stdout or stderr and will instead be put into a\
\9LogInfo object that is returned. If `callback` throws, the error will be\
\9bubbled up to the caller of `Logging.capture`.\
]]\
function Logging.capture(callback)\
\9local collector = createLogInfo()\
\
\9local wasOutputEnabled = outputEnabled\
\9outputEnabled = false\
\9collectors[collector] = true\
\
\9local success, result = pcall(callback)\
\
\9collectors[collector] = nil\
\9outputEnabled = wasOutputEnabled\
\
\9assert(success, result)\
\
\9return collector\
end\
\
--[[\
\9Issues a warning with an automatically attached stack trace.\
]]\
function Logging.warn(messageTemplate, ...)\
\9local message = messageTemplate:format(...)\
\
\9for collector in pairs(collectors) do\
\9\9table.insert(collector.warnings, message)\
\9end\
\
\9-- debug.traceback inserts a leading newline, so we trim it here\
\9local trace = debug.traceback(\"\", 2):sub(2)\
\9local fullMessage = (\"%s\\n%s\"):format(message, indent(trace, 1))\
\
\9if outputEnabled then\
\9\9warn(fullMessage)\
\9end\
end\
\
--[[\
\9Issues a warning like `Logging.warn`, but only outputs once per call site.\
\
\9This is useful for marking deprecated functions that might be called a lot;\
\9using `warnOnce` instead of `warn` will reduce output noise while still\
\9correctly marking all call sites.\
]]\
function Logging.warnOnce(messageTemplate, ...)\
\9local trace = debug.traceback()\
\
\9if onceUsedLocations[trace] then\
\9\9return\
\9end\
\
\9onceUsedLocations[trace] = true\
\9Logging.warn(messageTemplate, ...)\
end\
\
return Logging", '@'.."RemoteSpy.include.node_modules.roact.src.Logging")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.Logging")) return fn() end)

_module("None", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.None", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local Symbol = require(script.Parent.Symbol)\
\
-- Marker used to specify that the value is nothing, because nil cannot be\
-- stored in tables.\
local None = Symbol.named(\"None\")\
\
return None", '@'.."RemoteSpy.include.node_modules.roact.src.None")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.None")) return fn() end)

_module("NoopRenderer", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.NoopRenderer", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Reference renderer intended for use in tests as well as for documenting the\
\9minimum required interface for a Roact renderer.\
]]\
\
local NoopRenderer = {}\
\
function NoopRenderer.isHostObject(target)\
\9-- Attempting to use NoopRenderer to target a Roblox instance is almost\
\9-- certainly a mistake.\
\9return target == nil\
end\
\
function NoopRenderer.mountHostNode(reconciler, node)\
end\
\
function NoopRenderer.unmountHostNode(reconciler, node)\
end\
\
function NoopRenderer.updateHostNode(reconciler, node, newElement)\
\9return node\
end\
\
return NoopRenderer", '@'.."RemoteSpy.include.node_modules.roact.src.NoopRenderer")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.NoopRenderer")) return fn() end)

_module("Portal", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.Portal", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local Symbol = require(script.Parent.Symbol)\
\
local Portal = Symbol.named(\"Portal\")\
\
return Portal", '@'.."RemoteSpy.include.node_modules.roact.src.Portal")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.Portal")) return fn() end)

_instance("PropMarkers", "Folder", "RemoteSpy.include.node_modules.roact.src.PropMarkers", "RemoteSpy.include.node_modules.roact.src")

_module("Change", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.PropMarkers.Change", "RemoteSpy.include.node_modules.roact.src.PropMarkers", function () local fn = assert(loadstring("--[[\
\9Change is used to generate special prop keys that can be used to connect to\
\9GetPropertyChangedSignal.\
\
\9Generally, Change is indexed by a Roblox property name:\
\
\9\9Roact.createElement(\"TextBox\", {\
\9\9\9[Roact.Change.Text] = function(rbx)\
\9\9\9\9print(\"The TextBox\", rbx, \"changed text to\", rbx.Text)\
\9\9\9end,\
\9\9})\
]]\
\
local Type = require(script.Parent.Parent.Type)\
\
local Change = {}\
\
local changeMetatable = {\
\9__tostring = function(self)\
\9\9return (\"RoactHostChangeEvent(%s)\"):format(self.name)\
\9end,\
}\
\
setmetatable(Change, {\
\9__index = function(self, propertyName)\
\9\9local changeListener = {\
\9\9\9[Type] = Type.HostChangeEvent,\
\9\9\9name = propertyName,\
\9\9}\
\
\9\9setmetatable(changeListener, changeMetatable)\
\9\9Change[propertyName] = changeListener\
\
\9\9return changeListener\
\9end,\
})\
\
return Change\
", '@'.."RemoteSpy.include.node_modules.roact.src.PropMarkers.Change")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.PropMarkers.Change")) return fn() end)

_module("Children", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.PropMarkers.Children", "RemoteSpy.include.node_modules.roact.src.PropMarkers", function () local fn = assert(loadstring("local Symbol = require(script.Parent.Parent.Symbol)\
\
local Children = Symbol.named(\"Children\")\
\
return Children", '@'.."RemoteSpy.include.node_modules.roact.src.PropMarkers.Children")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.PropMarkers.Children")) return fn() end)

_module("Event", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.PropMarkers.Event", "RemoteSpy.include.node_modules.roact.src.PropMarkers", function () local fn = assert(loadstring("--[[\
\9Index into `Event` to get a prop key for attaching to an event on a Roblox\
\9Instance.\
\
\9Example:\
\
\9\9Roact.createElement(\"TextButton\", {\
\9\9\9Text = \"Hello, world!\",\
\
\9\9\9[Roact.Event.MouseButton1Click] = function(rbx)\
\9\9\9\9print(\"Clicked\", rbx)\
\9\9\9end\
\9\9})\
]]\
\
local Type = require(script.Parent.Parent.Type)\
\
local Event = {}\
\
local eventMetatable = {\
\9__tostring = function(self)\
\9\9return (\"RoactHostEvent(%s)\"):format(self.name)\
\9end,\
}\
\
setmetatable(Event, {\
\9__index = function(self, eventName)\
\9\9local event = {\
\9\9\9[Type] = Type.HostEvent,\
\9\9\9name = eventName,\
\9\9}\
\
\9\9setmetatable(event, eventMetatable)\
\
\9\9Event[eventName] = event\
\
\9\9return event\
\9end,\
})\
\
return Event\
", '@'.."RemoteSpy.include.node_modules.roact.src.PropMarkers.Event")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.PropMarkers.Event")) return fn() end)

_module("Ref", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.PropMarkers.Ref", "RemoteSpy.include.node_modules.roact.src.PropMarkers", function () local fn = assert(loadstring("local Symbol = require(script.Parent.Parent.Symbol)\
\
local Ref = Symbol.named(\"Ref\")\
\
return Ref", '@'.."RemoteSpy.include.node_modules.roact.src.PropMarkers.Ref")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.PropMarkers.Ref")) return fn() end)

_module("PureComponent", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.PureComponent", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9A version of Component with a `shouldUpdate` method that forces the\
\9resulting component to be pure.\
]]\
\
local Component = require(script.Parent.Component)\
\
local PureComponent = Component:extend(\"PureComponent\")\
\
-- When extend()ing a component, you don't get an extend method.\
-- This is to promote composition over inheritance.\
-- PureComponent is an exception to this rule.\
PureComponent.extend = Component.extend\
\
function PureComponent:shouldUpdate(newProps, newState)\
\9-- In a vast majority of cases, if state updated, something has updated.\
\9-- We don't bother checking in this case.\
\9if newState ~= self.state then\
\9\9return true\
\9end\
\
\9if newProps == self.props then\
\9\9return false\
\9end\
\
\9for key, value in pairs(newProps) do\
\9\9if self.props[key] ~= value then\
\9\9\9return true\
\9\9end\
\9end\
\
\9for key, value in pairs(self.props) do\
\9\9if newProps[key] ~= value then\
\9\9\9return true\
\9\9end\
\9end\
\
\9return false\
end\
\
return PureComponent", '@'.."RemoteSpy.include.node_modules.roact.src.PureComponent")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.PureComponent")) return fn() end)

_module("RobloxRenderer", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.RobloxRenderer", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Renderer that deals in terms of Roblox Instances. This is the most\
\9well-supported renderer after NoopRenderer and is currently the only\
\9renderer that does anything.\
]]\
\
local Binding = require(script.Parent.Binding)\
local Children = require(script.Parent.PropMarkers.Children)\
local ElementKind = require(script.Parent.ElementKind)\
local SingleEventManager = require(script.Parent.SingleEventManager)\
local getDefaultInstanceProperty = require(script.Parent.getDefaultInstanceProperty)\
local Ref = require(script.Parent.PropMarkers.Ref)\
local Type = require(script.Parent.Type)\
local internalAssert = require(script.Parent.internalAssert)\
\
local config = require(script.Parent.GlobalConfig).get()\
\
local applyPropsError = [[\
Error applying props:\
\9%s\
In element:\
%s\
]]\
\
local updatePropsError = [[\
Error updating props:\
\9%s\
In element:\
%s\
]]\
\
local function identity(...)\
\9return ...\
end\
\
local function applyRef(ref, newHostObject)\
\9if ref == nil then\
\9\9return\
\9end\
\
\9if typeof(ref) == \"function\" then\
\9\9ref(newHostObject)\
\9elseif Type.of(ref) == Type.Binding then\
\9\9Binding.update(ref, newHostObject)\
\9else\
\9\9-- TODO (#197): Better error message\
\9\9error((\"Invalid ref: Expected type Binding but got %s\"):format(\
\9\9\9typeof(ref)\
\9\9))\
\9end\
end\
\
local function setRobloxInstanceProperty(hostObject, key, newValue)\
\9if newValue == nil then\
\9\9local hostClass = hostObject.ClassName\
\9\9local _, defaultValue = getDefaultInstanceProperty(hostClass, key)\
\9\9newValue = defaultValue\
\9end\
\
\9-- Assign the new value to the object\
\9hostObject[key] = newValue\
\
\9return\
end\
\
local function removeBinding(virtualNode, key)\
\9local disconnect = virtualNode.bindings[key]\
\9disconnect()\
\9virtualNode.bindings[key] = nil\
end\
\
local function attachBinding(virtualNode, key, newBinding)\
\9local function updateBoundProperty(newValue)\
\9\9local success, errorMessage = xpcall(function()\
\9\9\9setRobloxInstanceProperty(virtualNode.hostObject, key, newValue)\
\9\9end, identity)\
\
\9\9if not success then\
\9\9\9local source = virtualNode.currentElement.source\
\
\9\9\9if source == nil then\
\9\9\9\9source = \"<enable element tracebacks>\"\
\9\9\9end\
\
\9\9\9local fullMessage = updatePropsError:format(errorMessage, source)\
\9\9\9error(fullMessage, 0)\
\9\9end\
\9end\
\
\9if virtualNode.bindings == nil then\
\9\9virtualNode.bindings = {}\
\9end\
\
\9virtualNode.bindings[key] = Binding.subscribe(newBinding, updateBoundProperty)\
\
\9updateBoundProperty(newBinding:getValue())\
end\
\
local function detachAllBindings(virtualNode)\
\9if virtualNode.bindings ~= nil then\
\9\9for _, disconnect in pairs(virtualNode.bindings) do\
\9\9\9disconnect()\
\9\9end\
\9end\
end\
\
local function applyProp(virtualNode, key, newValue, oldValue)\
\9if newValue == oldValue then\
\9\9return\
\9end\
\
\9if key == Ref or key == Children then\
\9\9-- Refs and children are handled in a separate pass\
\9\9return\
\9end\
\
\9local internalKeyType = Type.of(key)\
\
\9if internalKeyType == Type.HostEvent or internalKeyType == Type.HostChangeEvent then\
\9\9if virtualNode.eventManager == nil then\
\9\9\9virtualNode.eventManager = SingleEventManager.new(virtualNode.hostObject)\
\9\9end\
\
\9\9local eventName = key.name\
\
\9\9if internalKeyType == Type.HostChangeEvent then\
\9\9\9virtualNode.eventManager:connectPropertyChange(eventName, newValue)\
\9\9else\
\9\9\9virtualNode.eventManager:connectEvent(eventName, newValue)\
\9\9end\
\
\9\9return\
\9end\
\
\9local newIsBinding = Type.of(newValue) == Type.Binding\
\9local oldIsBinding = Type.of(oldValue) == Type.Binding\
\
\9if oldIsBinding then\
\9\9removeBinding(virtualNode, key)\
\9end\
\
\9if newIsBinding then\
\9\9attachBinding(virtualNode, key, newValue)\
\9else\
\9\9setRobloxInstanceProperty(virtualNode.hostObject, key, newValue)\
\9end\
end\
\
local function applyProps(virtualNode, props)\
\9for propKey, value in pairs(props) do\
\9\9applyProp(virtualNode, propKey, value, nil)\
\9end\
end\
\
local function updateProps(virtualNode, oldProps, newProps)\
\9-- Apply props that were added or updated\
\9for propKey, newValue in pairs(newProps) do\
\9\9local oldValue = oldProps[propKey]\
\
\9\9applyProp(virtualNode, propKey, newValue, oldValue)\
\9end\
\
\9-- Clean up props that were removed\
\9for propKey, oldValue in pairs(oldProps) do\
\9\9local newValue = newProps[propKey]\
\
\9\9if newValue == nil then\
\9\9\9applyProp(virtualNode, propKey, nil, oldValue)\
\9\9end\
\9end\
end\
\
local RobloxRenderer = {}\
\
function RobloxRenderer.isHostObject(target)\
\9return typeof(target) == \"Instance\"\
end\
\
function RobloxRenderer.mountHostNode(reconciler, virtualNode)\
\9local element = virtualNode.currentElement\
\9local hostParent = virtualNode.hostParent\
\9local hostKey = virtualNode.hostKey\
\
\9if config.internalTypeChecks then\
\9\9internalAssert(ElementKind.of(element) == ElementKind.Host, \"Element at given node is not a host Element\")\
\9end\
\9if config.typeChecks then\
\9\9assert(element.props.Name == nil, \"Name can not be specified as a prop to a host component in Roact.\")\
\9\9assert(element.props.Parent == nil, \"Parent can not be specified as a prop to a host component in Roact.\")\
\9end\
\
\9local instance = Instance.new(element.component)\
\9virtualNode.hostObject = instance\
\
\9local success, errorMessage = xpcall(function()\
\9\9applyProps(virtualNode, element.props)\
\9end, identity)\
\
\9if not success then\
\9\9local source = element.source\
\
\9\9if source == nil then\
\9\9\9source = \"<enable element tracebacks>\"\
\9\9end\
\
\9\9local fullMessage = applyPropsError:format(errorMessage, source)\
\9\9error(fullMessage, 0)\
\9end\
\
\9instance.Name = tostring(hostKey)\
\
\9local children = element.props[Children]\
\
\9if children ~= nil then\
\9\9reconciler.updateVirtualNodeWithChildren(virtualNode, virtualNode.hostObject, children)\
\9end\
\
\9instance.Parent = hostParent\
\9virtualNode.hostObject = instance\
\
\9applyRef(element.props[Ref], instance)\
\
\9if virtualNode.eventManager ~= nil then\
\9\9virtualNode.eventManager:resume()\
\9end\
end\
\
function RobloxRenderer.unmountHostNode(reconciler, virtualNode)\
\9local element = virtualNode.currentElement\
\
\9applyRef(element.props[Ref], nil)\
\
\9for _, childNode in pairs(virtualNode.children) do\
\9\9reconciler.unmountVirtualNode(childNode)\
\9end\
\
\9detachAllBindings(virtualNode)\
\
\9virtualNode.hostObject:Destroy()\
end\
\
function RobloxRenderer.updateHostNode(reconciler, virtualNode, newElement)\
\9local oldProps = virtualNode.currentElement.props\
\9local newProps = newElement.props\
\
\9if virtualNode.eventManager ~= nil then\
\9\9virtualNode.eventManager:suspend()\
\9end\
\
\9-- If refs changed, detach the old ref and attach the new one\
\9if oldProps[Ref] ~= newProps[Ref] then\
\9\9applyRef(oldProps[Ref], nil)\
\9\9applyRef(newProps[Ref], virtualNode.hostObject)\
\9end\
\
\9local success, errorMessage = xpcall(function()\
\9\9updateProps(virtualNode, oldProps, newProps)\
\9end, identity)\
\
\9if not success then\
\9\9local source = newElement.source\
\
\9\9if source == nil then\
\9\9\9source = \"<enable element tracebacks>\"\
\9\9end\
\
\9\9local fullMessage = updatePropsError:format(errorMessage, source)\
\9\9error(fullMessage, 0)\
\9end\
\
\9local children = newElement.props[Children]\
\9if children ~= nil or oldProps[Children] ~= nil then\
\9\9reconciler.updateVirtualNodeWithChildren(virtualNode, virtualNode.hostObject, children)\
\9end\
\
\9if virtualNode.eventManager ~= nil then\
\9\9virtualNode.eventManager:resume()\
\9end\
\
\9return virtualNode\
end\
\
return RobloxRenderer\
", '@'.."RemoteSpy.include.node_modules.roact.src.RobloxRenderer")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.RobloxRenderer")) return fn() end)

_module("SingleEventManager", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.SingleEventManager", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9A manager for a single host virtual node's connected events.\
]]\
\
local Logging = require(script.Parent.Logging)\
\
local CHANGE_PREFIX = \"Change.\"\
\
local EventStatus = {\
\9-- No events are processed at all; they're silently discarded\
\9Disabled = \"Disabled\",\
\
\9-- Events are stored in a queue; listeners are invoked when the manager is resumed\
\9Suspended = \"Suspended\",\
\
\9-- Event listeners are invoked as the events fire\
\9Enabled = \"Enabled\",\
}\
\
local SingleEventManager = {}\
SingleEventManager.__index = SingleEventManager\
\
function SingleEventManager.new(instance)\
\9local self = setmetatable({\
\9\9-- The queue of suspended events\
\9\9_suspendedEventQueue = {},\
\
\9\9-- All the event connections being managed\
\9\9-- Events are indexed by a string key\
\9\9_connections = {},\
\
\9\9-- All the listeners being managed\
\9\9-- These are stored distinctly from the connections\
\9\9-- Connections can have their listeners replaced at runtime\
\9\9_listeners = {},\
\
\9\9-- The suspension status of the manager\
\9\9-- Managers start disabled and are \"resumed\" after the initial render\
\9\9_status = EventStatus.Disabled,\
\
\9\9-- If true, the manager is processing queued events right now.\
\9\9_isResuming = false,\
\
\9\9-- The Roblox instance the manager is managing\
\9\9_instance = instance,\
\9}, SingleEventManager)\
\
\9return self\
end\
\
function SingleEventManager:connectEvent(key, listener)\
\9self:_connect(key, self._instance[key], listener)\
end\
\
function SingleEventManager:connectPropertyChange(key, listener)\
\9local success, event = pcall(function()\
\9\9return self._instance:GetPropertyChangedSignal(key)\
\9end)\
\
\9if not success then\
\9\9error((\"Cannot get changed signal on property %q: %s\"):format(\
\9\9\9tostring(key),\
\9\9\9event\
\9\9), 0)\
\9end\
\
\9self:_connect(CHANGE_PREFIX .. key, event, listener)\
end\
\
function SingleEventManager:_connect(eventKey, event, listener)\
\9-- If the listener doesn't exist we can just disconnect the existing connection\
\9if listener == nil then\
\9\9if self._connections[eventKey] ~= nil then\
\9\9\9self._connections[eventKey]:Disconnect()\
\9\9\9self._connections[eventKey] = nil\
\9\9end\
\
\9\9self._listeners[eventKey] = nil\
\9else\
\9\9if self._connections[eventKey] == nil then\
\9\9\9self._connections[eventKey] = event:Connect(function(...)\
\9\9\9\9if self._status == EventStatus.Enabled then\
\9\9\9\9\9self._listeners[eventKey](self._instance, ...)\
\9\9\9\9elseif self._status == EventStatus.Suspended then\
\9\9\9\9\9-- Store this event invocation to be fired when resume is\
\9\9\9\9\9-- called.\
\
\9\9\9\9\9local argumentCount = select(\"#\", ...)\
\9\9\9\9\9table.insert(self._suspendedEventQueue, { eventKey, argumentCount, ... })\
\9\9\9\9end\
\9\9\9end)\
\9\9end\
\
\9\9self._listeners[eventKey] = listener\
\9end\
end\
\
function SingleEventManager:suspend()\
\9self._status = EventStatus.Suspended\
end\
\
function SingleEventManager:resume()\
\9-- If we're already resuming events for this instance, trying to resume\
\9-- again would cause a disaster.\
\9if self._isResuming then\
\9\9return\
\9end\
\
\9self._isResuming = true\
\
\9local index = 1\
\
\9-- More events might be added to the queue when evaluating events, so we\
\9-- need to be careful in order to preserve correct evaluation order.\
\9while index <= #self._suspendedEventQueue do\
\9\9local eventInvocation = self._suspendedEventQueue[index]\
\9\9local listener = self._listeners[eventInvocation[1]]\
\9\9local argumentCount = eventInvocation[2]\
\
\9\9-- The event might have been disconnected since suspension started; in\
\9\9-- this case, we drop the event.\
\9\9if listener ~= nil then\
\9\9\9-- Wrap the listener in a coroutine to catch errors and handle\
\9\9\9-- yielding correctly.\
\9\9\9local listenerCo = coroutine.create(listener)\
\9\9\9local success, result = coroutine.resume(\
\9\9\9\9listenerCo,\
\9\9\9\9self._instance,\
\9\9\9\9unpack(eventInvocation, 3, 2 + argumentCount))\
\
\9\9\9-- If the listener threw an error, we log it as a warning, since\
\9\9\9-- there's no way to write error text in Roblox Lua without killing\
\9\9\9-- our thread!\
\9\9\9if not success then\
\9\9\9\9Logging.warn(\"%s\", result)\
\9\9\9end\
\9\9end\
\
\9\9index = index + 1\
\9end\
\
\9self._isResuming = false\
\9self._status = EventStatus.Enabled\
\9self._suspendedEventQueue = {}\
end\
\
return SingleEventManager", '@'.."RemoteSpy.include.node_modules.roact.src.SingleEventManager")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.SingleEventManager")) return fn() end)

_module("Symbol", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.Symbol", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9A 'Symbol' is an opaque marker type.\
\
\9Symbols have the type 'userdata', but when printed to the console, the name\
\9of the symbol is shown.\
]]\
\
local Symbol = {}\
\
--[[\
\9Creates a Symbol with the given name.\
\
\9When printed or coerced to a string, the symbol will turn into the string\
\9given as its name.\
]]\
function Symbol.named(name)\
\9assert(type(name) == \"string\", \"Symbols must be created using a string name!\")\
\
\9local self = newproxy(true)\
\
\9local wrappedName = (\"Symbol(%s)\"):format(name)\
\
\9getmetatable(self).__tostring = function()\
\9\9return wrappedName\
\9end\
\
\9return self\
end\
\
return Symbol", '@'.."RemoteSpy.include.node_modules.roact.src.Symbol")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.Symbol")) return fn() end)

_module("Type", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.Type", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Contains markers for annotating objects with types.\
\
\9To set the type of an object, use `Type` as a key and the actual marker as\
\9the value:\
\
\9\9local foo = {\
\9\9\9[Type] = Type.Foo,\
\9\9}\
]]\
\
local Symbol = require(script.Parent.Symbol)\
local strict = require(script.Parent.strict)\
\
local Type = newproxy(true)\
\
local TypeInternal = {}\
\
local function addType(name)\
\9TypeInternal[name] = Symbol.named(\"Roact\" .. name)\
end\
\
addType(\"Binding\")\
addType(\"Element\")\
addType(\"HostChangeEvent\")\
addType(\"HostEvent\")\
addType(\"StatefulComponentClass\")\
addType(\"StatefulComponentInstance\")\
addType(\"VirtualNode\")\
addType(\"VirtualTree\")\
\
function TypeInternal.of(value)\
\9if typeof(value) ~= \"table\" then\
\9\9return nil\
\9end\
\
\9return value[Type]\
end\
\
getmetatable(Type).__index = TypeInternal\
\
getmetatable(Type).__tostring = function()\
\9return \"RoactType\"\
end\
\
strict(TypeInternal, \"Type\")\
\
return Type", '@'.."RemoteSpy.include.node_modules.roact.src.Type")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.Type")) return fn() end)

_module("assertDeepEqual", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.assertDeepEqual", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9A utility used to assert that two objects are value-equal recursively. It\
\9outputs fairly nicely formatted messages to help diagnose why two objects\
\9would be different.\
\
\9This should only be used in tests.\
]]\
\
local function deepEqual(a, b)\
\9if typeof(a) ~= typeof(b) then\
\9\9local message = (\"{1} is of type %s, but {2} is of type %s\"):format(\
\9\9\9typeof(a),\
\9\9\9typeof(b)\
\9\9)\
\9\9return false, message\
\9end\
\
\9if typeof(a) == \"table\" then\
\9\9local visitedKeys = {}\
\
\9\9for key, value in pairs(a) do\
\9\9\9visitedKeys[key] = true\
\
\9\9\9local success, innerMessage = deepEqual(value, b[key])\
\9\9\9if not success then\
\9\9\9\9local message = innerMessage\
\9\9\9\9\9:gsub(\"{1}\", (\"{1}[%s]\"):format(tostring(key)))\
\9\9\9\9\9:gsub(\"{2}\", (\"{2}[%s]\"):format(tostring(key)))\
\
\9\9\9\9return false, message\
\9\9\9end\
\9\9end\
\
\9\9for key, value in pairs(b) do\
\9\9\9if not visitedKeys[key] then\
\9\9\9\9local success, innerMessage = deepEqual(value, a[key])\
\
\9\9\9\9if not success then\
\9\9\9\9\9local message = innerMessage\
\9\9\9\9\9\9:gsub(\"{1}\", (\"{1}[%s]\"):format(tostring(key)))\
\9\9\9\9\9\9:gsub(\"{2}\", (\"{2}[%s]\"):format(tostring(key)))\
\
\9\9\9\9\9return false, message\
\9\9\9\9end\
\9\9\9end\
\9\9end\
\
\9\9return true\
\9end\
\
\9if a == b then\
\9\9return true\
\9end\
\
\9local message = \"{1} ~= {2}\"\
\9return false, message\
end\
\
local function assertDeepEqual(a, b)\
\9local success, innerMessageTemplate = deepEqual(a, b)\
\
\9if not success then\
\9\9local innerMessage = innerMessageTemplate\
\9\9\9:gsub(\"{1}\", \"first\")\
\9\9\9:gsub(\"{2}\", \"second\")\
\
\9\9local message = (\"Values were not deep-equal.\\n%s\"):format(innerMessage)\
\
\9\9error(message, 2)\
\9end\
end\
\
return assertDeepEqual", '@'.."RemoteSpy.include.node_modules.roact.src.assertDeepEqual")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.assertDeepEqual")) return fn() end)

_module("assign", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.assign", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local None = require(script.Parent.None)\
\
--[[\
\9Merges values from zero or more tables onto a target table. If a value is\
\9set to None, it will instead be removed from the table.\
\
\9This function is identical in functionality to JavaScript's Object.assign.\
]]\
local function assign(target, ...)\
\9for index = 1, select(\"#\", ...) do\
\9\9local source = select(index, ...)\
\
\9\9if source ~= nil then\
\9\9\9for key, value in pairs(source) do\
\9\9\9\9if value == None then\
\9\9\9\9\9target[key] = nil\
\9\9\9\9else\
\9\9\9\9\9target[key] = value\
\9\9\9\9end\
\9\9\9end\
\9\9end\
\9end\
\
\9return target\
end\
\
return assign", '@'.."RemoteSpy.include.node_modules.roact.src.assign")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.assign")) return fn() end)

_module("createContext", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createContext", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local Symbol = require(script.Parent.Symbol)\
local createFragment = require(script.Parent.createFragment)\
local createSignal = require(script.Parent.createSignal)\
local Children = require(script.Parent.PropMarkers.Children)\
local Component = require(script.Parent.Component)\
\
--[[\
\9Construct the value that is assigned to Roact's context storage.\
]]\
local function createContextEntry(currentValue)\
\9return {\
\9\9value = currentValue,\
\9\9onUpdate = createSignal(),\
\9}\
end\
\
local function createProvider(context)\
\9local Provider = Component:extend(\"Provider\")\
\
\9function Provider:init(props)\
\9\9self.contextEntry = createContextEntry(props.value)\
\9\9self:__addContext(context.key, self.contextEntry)\
\9end\
\
\9function Provider:willUpdate(nextProps)\
\9\9-- If the provided value changed, immediately update the context entry.\
\9\9--\
\9\9-- During this update, any components that are reachable will receive\
\9\9-- this updated value at the same time as any props and state updates\
\9\9-- that are being applied.\
\9\9if nextProps.value ~= self.props.value then\
\9\9\9self.contextEntry.value = nextProps.value\
\9\9end\
\9end\
\
\9function Provider:didUpdate(prevProps)\
\9\9-- If the provided value changed, after we've updated every reachable\
\9\9-- component, fire a signal to update the rest.\
\9\9--\
\9\9-- This signal will notify all context consumers. It's expected that\
\9\9-- they will compare the last context value they updated with and only\
\9\9-- trigger an update on themselves if this value is different.\
\9\9--\
\9\9-- This codepath will generally only update consumer components that has\
\9\9-- a component implementing shouldUpdate between them and the provider.\
\9\9if prevProps.value ~= self.props.value then\
\9\9\9self.contextEntry.onUpdate:fire(self.props.value)\
\9\9end\
\9end\
\
\9function Provider:render()\
\9\9return createFragment(self.props[Children])\
\9end\
\
\9return Provider\
end\
\
local function createConsumer(context)\
\9local Consumer = Component:extend(\"Consumer\")\
\
\9function Consumer.validateProps(props)\
\9\9if type(props.render) ~= \"function\" then\
\9\9\9return false, \"Consumer expects a `render` function\"\
\9\9else\
\9\9\9return true\
\9\9end\
\9end\
\
\9function Consumer:init(props)\
\9\9-- This value may be nil, which indicates that our consumer is not a\
\9\9-- descendant of a provider for this context item.\
\9\9self.contextEntry = self:__getContext(context.key)\
\9end\
\
\9function Consumer:render()\
\9\9-- Render using the latest available for this context item.\
\9\9--\
\9\9-- We don't store this value in state in order to have more fine-grained\
\9\9-- control over our update behavior.\
\9\9local value\
\9\9if self.contextEntry ~= nil then\
\9\9\9value = self.contextEntry.value\
\9\9else\
\9\9\9value = context.defaultValue\
\9\9end\
\
\9\9return self.props.render(value)\
\9end\
\
\9function Consumer:didUpdate()\
\9\9-- Store the value that we most recently updated with.\
\9\9--\
\9\9-- This value is compared in the contextEntry onUpdate hook below.\
\9\9if self.contextEntry ~= nil then\
\9\9\9self.lastValue = self.contextEntry.value\
\9\9end\
\9end\
\
\9function Consumer:didMount()\
\9\9if self.contextEntry ~= nil then\
\9\9\9-- When onUpdate is fired, a new value has been made available in\
\9\9\9-- this context entry, but we may have already updated in the same\
\9\9\9-- update cycle.\
\9\9\9--\
\9\9\9-- To avoid sending a redundant update, we compare the new value\
\9\9\9-- with the last value that we updated with (set in didUpdate) and\
\9\9\9-- only update if they differ. This may happen when an update from a\
\9\9\9-- provider was blocked by an intermediate component that returned\
\9\9\9-- false from shouldUpdate.\
\9\9\9self.disconnect = self.contextEntry.onUpdate:subscribe(function(newValue)\
\9\9\9\9if newValue ~= self.lastValue then\
\9\9\9\9\9-- Trigger a dummy state update.\
\9\9\9\9\9self:setState({})\
\9\9\9\9end\
\9\9\9end)\
\9\9end\
\9end\
\
\9function Consumer:willUnmount()\
\9\9if self.disconnect ~= nil then\
\9\9\9self.disconnect()\
\9\9end\
\9end\
\
\9return Consumer\
end\
\
local Context = {}\
Context.__index = Context\
\
function Context.new(defaultValue)\
\9return setmetatable({\
\9\9defaultValue = defaultValue,\
\9\9key = Symbol.named(\"ContextKey\"),\
\9}, Context)\
end\
\
function Context:__tostring()\
\9return \"RoactContext\"\
end\
\
local function createContext(defaultValue)\
\9local context = Context.new(defaultValue)\
\
\9return {\
\9\9Provider = createProvider(context),\
\9\9Consumer = createConsumer(context),\
\9}\
end\
\
return createContext\
", '@'.."RemoteSpy.include.node_modules.roact.src.createContext")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createContext")) return fn() end)

_module("createElement", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createElement", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local Children = require(script.Parent.PropMarkers.Children)\
local ElementKind = require(script.Parent.ElementKind)\
local Logging = require(script.Parent.Logging)\
local Type = require(script.Parent.Type)\
\
local config = require(script.Parent.GlobalConfig).get()\
\
local multipleChildrenMessage = [[\
The prop `Roact.Children` was defined but was overriden by the third parameter to createElement!\
This can happen when a component passes props through to a child element but also uses the `children` argument:\
\
\9Roact.createElement(\"Frame\", passedProps, {\
\9\9child = ...\
\9})\
\
Instead, consider using a utility function to merge tables of children together:\
\
\9local children = mergeTables(passedProps[Roact.Children], {\
\9\9child = ...\
\9})\
\
\9local fullProps = mergeTables(passedProps, {\
\9\9[Roact.Children] = children\
\9})\
\
\9Roact.createElement(\"Frame\", fullProps)]]\
\
--[[\
\9Creates a new element representing the given component.\
\
\9Elements are lightweight representations of what a component instance should\
\9look like.\
\
\9Children is a shorthand for specifying `Roact.Children` as a key inside\
\9props. If specified, the passed `props` table is mutated!\
]]\
local function createElement(component, props, children)\
\9if config.typeChecks then\
\9\9assert(component ~= nil, \"`component` is required\")\
\9\9assert(typeof(props) == \"table\" or props == nil, \"`props` must be a table or nil\")\
\9\9assert(typeof(children) == \"table\" or children == nil, \"`children` must be a table or nil\")\
\9end\
\
\9if props == nil then\
\9\9props = {}\
\9end\
\
\9if children ~= nil then\
\9\9if props[Children] ~= nil then\
\9\9\9Logging.warnOnce(multipleChildrenMessage)\
\9\9end\
\
\9\9props[Children] = children\
\9end\
\
\9local elementKind = ElementKind.fromComponent(component)\
\
\9local element = {\
\9\9[Type] = Type.Element,\
\9\9[ElementKind] = elementKind,\
\9\9component = component,\
\9\9props = props,\
\9}\
\
\9if config.elementTracing then\
\9\9-- We trim out the leading newline since there's no way to specify the\
\9\9-- trace level without also specifying a message.\
\9\9element.source = debug.traceback(\"\", 2):sub(2)\
\9end\
\
\9return element\
end\
\
return createElement", '@'.."RemoteSpy.include.node_modules.roact.src.createElement")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createElement")) return fn() end)

_module("createFragment", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createFragment", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local ElementKind = require(script.Parent.ElementKind)\
local Type = require(script.Parent.Type)\
\
local function createFragment(elements)\
\9return {\
\9\9[Type] = Type.Element,\
\9\9[ElementKind] = ElementKind.Fragment,\
\9\9elements = elements,\
\9}\
end\
\
return createFragment", '@'.."RemoteSpy.include.node_modules.roact.src.createFragment")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createFragment")) return fn() end)

_module("createReconciler", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createReconciler", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local Type = require(script.Parent.Type)\
local ElementKind = require(script.Parent.ElementKind)\
local ElementUtils = require(script.Parent.ElementUtils)\
local Children = require(script.Parent.PropMarkers.Children)\
local Symbol = require(script.Parent.Symbol)\
local internalAssert = require(script.Parent.internalAssert)\
\
local config = require(script.Parent.GlobalConfig).get()\
\
local InternalData = Symbol.named(\"InternalData\")\
\
--[[\
\9The reconciler is the mechanism in Roact that constructs the virtual tree\
\9that later gets turned into concrete objects by the renderer.\
\
\9Roact's reconciler is constructed with the renderer as an argument, which\
\9enables switching to different renderers for different platforms or\
\9scenarios.\
\
\9When testing the reconciler itself, it's common to use `NoopRenderer` with\
\9spies replacing some methods. The default (and only) reconciler interface\
\9exposed by Roact right now uses `RobloxRenderer`.\
]]\
local function createReconciler(renderer)\
\9local reconciler\
\9local mountVirtualNode\
\9local updateVirtualNode\
\9local unmountVirtualNode\
\
\9--[[\
\9\9Unmount the given virtualNode, replacing it with a new node described by\
\9\9the given element.\
\
\9\9Preserves host properties, depth, and legacyContext from parent.\
\9]]\
\9local function replaceVirtualNode(virtualNode, newElement)\
\9\9local hostParent = virtualNode.hostParent\
\9\9local hostKey = virtualNode.hostKey\
\9\9local depth = virtualNode.depth\
\9\9local parent = virtualNode.parent\
\
\9\9-- If the node that is being replaced has modified context, we need to\
\9\9-- use the original *unmodified* context for the new node\
\9\9-- The `originalContext` field will be nil if the context was unchanged\
\9\9local context = virtualNode.originalContext or virtualNode.context\
\9\9local parentLegacyContext = virtualNode.parentLegacyContext\
\
\9\9unmountVirtualNode(virtualNode)\
\9\9local newNode = mountVirtualNode(newElement, hostParent, hostKey, context, parentLegacyContext)\
\
\9\9-- mountVirtualNode can return nil if the element is a boolean\
\9\9if newNode ~= nil then\
\9\9\9newNode.depth = depth\
\9\9\9newNode.parent = parent\
\9\9end\
\
\9\9return newNode\
\9end\
\
\9--[[\
\9\9Utility to update the children of a virtual node based on zero or more\
\9\9updated children given as elements.\
\9]]\
\9local function updateChildren(virtualNode, hostParent, newChildElements)\
\9\9if config.internalTypeChecks then\
\9\9\9internalAssert(Type.of(virtualNode) == Type.VirtualNode, \"Expected arg #1 to be of type VirtualNode\")\
\9\9end\
\
\9\9local removeKeys = {}\
\
\9\9-- Changed or removed children\
\9\9for childKey, childNode in pairs(virtualNode.children) do\
\9\9\9local newElement = ElementUtils.getElementByKey(newChildElements, childKey)\
\9\9\9local newNode = updateVirtualNode(childNode, newElement)\
\
\9\9\9if newNode ~= nil then\
\9\9\9\9virtualNode.children[childKey] = newNode\
\9\9\9else\
\9\9\9\9removeKeys[childKey] = true\
\9\9\9end\
\9\9end\
\
\9\9for childKey in pairs(removeKeys) do\
\9\9\9virtualNode.children[childKey] = nil\
\9\9end\
\
\9\9-- Added children\
\9\9for childKey, newElement in ElementUtils.iterateElements(newChildElements) do\
\9\9\9local concreteKey = childKey\
\9\9\9if childKey == ElementUtils.UseParentKey then\
\9\9\9\9concreteKey = virtualNode.hostKey\
\9\9\9end\
\
\9\9\9if virtualNode.children[childKey] == nil then\
\9\9\9\9local childNode = mountVirtualNode(\
\9\9\9\9\9newElement,\
\9\9\9\9\9hostParent,\
\9\9\9\9\9concreteKey,\
\9\9\9\9\9virtualNode.context,\
\9\9\9\9\9virtualNode.legacyContext\
\9\9\9\9)\
\
\9\9\9\9-- mountVirtualNode can return nil if the element is a boolean\
\9\9\9\9if childNode ~= nil then\
\9\9\9\9\9childNode.depth = virtualNode.depth + 1\
\9\9\9\9\9childNode.parent = virtualNode\
\9\9\9\9\9virtualNode.children[childKey] = childNode\
\9\9\9\9end\
\9\9\9end\
\9\9end\
\9end\
\
\9local function updateVirtualNodeWithChildren(virtualNode, hostParent, newChildElements)\
\9\9updateChildren(virtualNode, hostParent, newChildElements)\
\9end\
\
\9local function updateVirtualNodeWithRenderResult(virtualNode, hostParent, renderResult)\
\9\9if Type.of(renderResult) == Type.Element\
\9\9\9or renderResult == nil\
\9\9\9or typeof(renderResult) == \"boolean\"\
\9\9then\
\9\9\9updateChildren(virtualNode, hostParent, renderResult)\
\9\9else\
\9\9\9error((\"%s\\n%s\"):format(\
\9\9\9\9\"Component returned invalid children:\",\
\9\9\9\9virtualNode.currentElement.source or \"<enable element tracebacks>\"\
\9\9\9), 0)\
\9\9end\
\9end\
\
\9--[[\
\9\9Unmounts the given virtual node and releases any held resources.\
\9]]\
\9function unmountVirtualNode(virtualNode)\
\9\9if config.internalTypeChecks then\
\9\9\9internalAssert(Type.of(virtualNode) == Type.VirtualNode, \"Expected arg #1 to be of type VirtualNode\")\
\9\9end\
\
\9\9local kind = ElementKind.of(virtualNode.currentElement)\
\
\9\9if kind == ElementKind.Host then\
\9\9\9renderer.unmountHostNode(reconciler, virtualNode)\
\9\9elseif kind == ElementKind.Function then\
\9\9\9for _, childNode in pairs(virtualNode.children) do\
\9\9\9\9unmountVirtualNode(childNode)\
\9\9\9end\
\9\9elseif kind == ElementKind.Stateful then\
\9\9\9virtualNode.instance:__unmount()\
\9\9elseif kind == ElementKind.Portal then\
\9\9\9for _, childNode in pairs(virtualNode.children) do\
\9\9\9\9unmountVirtualNode(childNode)\
\9\9\9end\
\9\9elseif kind == ElementKind.Fragment then\
\9\9\9for _, childNode in pairs(virtualNode.children) do\
\9\9\9\9unmountVirtualNode(childNode)\
\9\9\9end\
\9\9else\
\9\9\9error((\"Unknown ElementKind %q\"):format(tostring(kind)), 2)\
\9\9end\
\9end\
\
\9local function updateFunctionVirtualNode(virtualNode, newElement)\
\9\9local children = newElement.component(newElement.props)\
\
\9\9updateVirtualNodeWithRenderResult(virtualNode, virtualNode.hostParent, children)\
\
\9\9return virtualNode\
\9end\
\
\9local function updatePortalVirtualNode(virtualNode, newElement)\
\9\9local oldElement = virtualNode.currentElement\
\9\9local oldTargetHostParent = oldElement.props.target\
\
\9\9local targetHostParent = newElement.props.target\
\
\9\9assert(renderer.isHostObject(targetHostParent), \"Expected target to be host object\")\
\
\9\9if targetHostParent ~= oldTargetHostParent then\
\9\9\9return replaceVirtualNode(virtualNode, newElement)\
\9\9end\
\
\9\9local children = newElement.props[Children]\
\
\9\9updateVirtualNodeWithChildren(virtualNode, targetHostParent, children)\
\
\9\9return virtualNode\
\9end\
\
\9local function updateFragmentVirtualNode(virtualNode, newElement)\
\9\9updateVirtualNodeWithChildren(virtualNode, virtualNode.hostParent, newElement.elements)\
\
\9\9return virtualNode\
\9end\
\
\9--[[\
\9\9Update the given virtual node using a new element describing what it\
\9\9should transform into.\
\
\9\9`updateVirtualNode` will return a new virtual node that should replace\
\9\9the passed in virtual node. This is because a virtual node can be\
\9\9updated with an element referencing a different component!\
\
\9\9In that case, `updateVirtualNode` will unmount the input virtual node,\
\9\9mount a new virtual node, and return it in this case, while also issuing\
\9\9a warning to the user.\
\9]]\
\9function updateVirtualNode(virtualNode, newElement, newState)\
\9\9if config.internalTypeChecks then\
\9\9\9internalAssert(Type.of(virtualNode) == Type.VirtualNode, \"Expected arg #1 to be of type VirtualNode\")\
\9\9end\
\9\9if config.typeChecks then\
\9\9\9assert(\
\9\9\9\9Type.of(newElement) == Type.Element or typeof(newElement) == \"boolean\" or newElement == nil,\
\9\9\9\9\"Expected arg #2 to be of type Element, boolean, or nil\"\
\9\9\9)\
\9\9end\
\
\9\9-- If nothing changed, we can skip this update\
\9\9if virtualNode.currentElement == newElement and newState == nil then\
\9\9\9return virtualNode\
\9\9end\
\
\9\9if typeof(newElement) == \"boolean\" or newElement == nil then\
\9\9\9unmountVirtualNode(virtualNode)\
\9\9\9return nil\
\9\9end\
\
\9\9if virtualNode.currentElement.component ~= newElement.component then\
\9\9\9return replaceVirtualNode(virtualNode, newElement)\
\9\9end\
\
\9\9local kind = ElementKind.of(newElement)\
\
\9\9local shouldContinueUpdate = true\
\
\9\9if kind == ElementKind.Host then\
\9\9\9virtualNode = renderer.updateHostNode(reconciler, virtualNode, newElement)\
\9\9elseif kind == ElementKind.Function then\
\9\9\9virtualNode = updateFunctionVirtualNode(virtualNode, newElement)\
\9\9elseif kind == ElementKind.Stateful then\
\9\9\9shouldContinueUpdate = virtualNode.instance:__update(newElement, newState)\
\9\9elseif kind == ElementKind.Portal then\
\9\9\9virtualNode = updatePortalVirtualNode(virtualNode, newElement)\
\9\9elseif kind == ElementKind.Fragment then\
\9\9\9virtualNode = updateFragmentVirtualNode(virtualNode, newElement)\
\9\9else\
\9\9\9error((\"Unknown ElementKind %q\"):format(tostring(kind)), 2)\
\9\9end\
\
\9\9-- Stateful components can abort updates via shouldUpdate. If that\
\9\9-- happens, we should stop doing stuff at this point.\
\9\9if not shouldContinueUpdate then\
\9\9\9return virtualNode\
\9\9end\
\
\9\9virtualNode.currentElement = newElement\
\
\9\9return virtualNode\
\9end\
\
\9--[[\
\9\9Constructs a new virtual node but not does mount it.\
\9]]\
\9local function createVirtualNode(element, hostParent, hostKey, context, legacyContext)\
\9\9if config.internalTypeChecks then\
\9\9\9internalAssert(renderer.isHostObject(hostParent) or hostParent == nil, \"Expected arg #2 to be a host object\")\
\9\9\9internalAssert(typeof(context) == \"table\" or context == nil, \"Expected arg #4 to be of type table or nil\")\
\9\9\9internalAssert(\
\9\9\9\9typeof(legacyContext) == \"table\" or legacyContext == nil,\
\9\9\9\9\"Expected arg #5 to be of type table or nil\"\
\9\9\9)\
\9\9end\
\9\9if config.typeChecks then\
\9\9\9assert(hostKey ~= nil, \"Expected arg #3 to be non-nil\")\
\9\9\9assert(\
\9\9\9\9Type.of(element) == Type.Element or typeof(element) == \"boolean\",\
\9\9\9\9\"Expected arg #1 to be of type Element or boolean\"\
\9\9\9)\
\9\9end\
\
\9\9return {\
\9\9\9[Type] = Type.VirtualNode,\
\9\9\9currentElement = element,\
\9\9\9depth = 1,\
\9\9\9parent = nil,\
\9\9\9children = {},\
\9\9\9hostParent = hostParent,\
\9\9\9hostKey = hostKey,\
\
\9\9\9-- Legacy Context API\
\9\9\9-- A table of context values inherited from the parent node\
\9\9\9legacyContext = legacyContext,\
\
\9\9\9-- A saved copy of the parent context, used when replacing a node\
\9\9\9parentLegacyContext = legacyContext,\
\
\9\9\9-- Context API\
\9\9\9-- A table of context values inherited from the parent node\
\9\9\9context = context or {},\
\
\9\9\9-- A saved copy of the unmodified context; this will be updated when\
\9\9\9-- a component adds new context and used when a node is replaced\
\9\9\9originalContext = nil,\
\9\9}\
\9end\
\
\9local function mountFunctionVirtualNode(virtualNode)\
\9\9local element = virtualNode.currentElement\
\
\9\9local children = element.component(element.props)\
\
\9\9updateVirtualNodeWithRenderResult(virtualNode, virtualNode.hostParent, children)\
\9end\
\
\9local function mountPortalVirtualNode(virtualNode)\
\9\9local element = virtualNode.currentElement\
\
\9\9local targetHostParent = element.props.target\
\9\9local children = element.props[Children]\
\
\9\9assert(renderer.isHostObject(targetHostParent), \"Expected target to be host object\")\
\
\9\9updateVirtualNodeWithChildren(virtualNode, targetHostParent, children)\
\9end\
\
\9local function mountFragmentVirtualNode(virtualNode)\
\9\9local element = virtualNode.currentElement\
\9\9local children = element.elements\
\
\9\9updateVirtualNodeWithChildren(virtualNode, virtualNode.hostParent, children)\
\9end\
\
\9--[[\
\9\9Constructs a new virtual node and mounts it, but does not place it into\
\9\9the tree.\
\9]]\
\9function mountVirtualNode(element, hostParent, hostKey, context, legacyContext)\
\9\9if config.internalTypeChecks then\
\9\9\9internalAssert(renderer.isHostObject(hostParent) or hostParent == nil, \"Expected arg #2 to be a host object\")\
\9\9\9internalAssert(\
\9\9\9\9typeof(legacyContext) == \"table\" or legacyContext == nil,\
\9\9\9\9\"Expected arg #5 to be of type table or nil\"\
\9\9\9)\
\9\9end\
\9\9if config.typeChecks then\
\9\9\9assert(hostKey ~= nil, \"Expected arg #3 to be non-nil\")\
\9\9\9assert(\
\9\9\9\9Type.of(element) == Type.Element or typeof(element) == \"boolean\",\
\9\9\9\9\"Expected arg #1 to be of type Element or boolean\"\
\9\9\9)\
\9\9end\
\
\9\9-- Boolean values render as nil to enable terse conditional rendering.\
\9\9if typeof(element) == \"boolean\" then\
\9\9\9return nil\
\9\9end\
\
\9\9local kind = ElementKind.of(element)\
\
\9\9local virtualNode = createVirtualNode(element, hostParent, hostKey, context, legacyContext)\
\
\9\9if kind == ElementKind.Host then\
\9\9\9renderer.mountHostNode(reconciler, virtualNode)\
\9\9elseif kind == ElementKind.Function then\
\9\9\9mountFunctionVirtualNode(virtualNode)\
\9\9elseif kind == ElementKind.Stateful then\
\9\9\9element.component:__mount(reconciler, virtualNode)\
\9\9elseif kind == ElementKind.Portal then\
\9\9\9mountPortalVirtualNode(virtualNode)\
\9\9elseif kind == ElementKind.Fragment then\
\9\9\9mountFragmentVirtualNode(virtualNode)\
\9\9else\
\9\9\9error((\"Unknown ElementKind %q\"):format(tostring(kind)), 2)\
\9\9end\
\
\9\9return virtualNode\
\9end\
\
\9--[[\
\9\9Constructs a new Roact virtual tree, constructs a root node for\
\9\9it, and mounts it.\
\9]]\
\9local function mountVirtualTree(element, hostParent, hostKey)\
\9\9if config.typeChecks then\
\9\9\9assert(Type.of(element) == Type.Element, \"Expected arg #1 to be of type Element\")\
\9\9\9assert(renderer.isHostObject(hostParent) or hostParent == nil, \"Expected arg #2 to be a host object\")\
\9\9end\
\
\9\9if hostKey == nil then\
\9\9\9hostKey = \"RoactTree\"\
\9\9end\
\
\9\9local tree = {\
\9\9\9[Type] = Type.VirtualTree,\
\9\9\9[InternalData] = {\
\9\9\9\9-- The root node of the tree, which starts into the hierarchy of\
\9\9\9\9-- Roact component instances.\
\9\9\9\9rootNode = nil,\
\9\9\9\9mounted = true,\
\9\9\9},\
\9\9}\
\
\9\9tree[InternalData].rootNode = mountVirtualNode(element, hostParent, hostKey)\
\
\9\9return tree\
\9end\
\
\9--[[\
\9\9Unmounts the virtual tree, freeing all of its resources.\
\
\9\9No further operations should be done on the tree after it's been\
\9\9unmounted, as indicated by its the `mounted` field.\
\9]]\
\9local function unmountVirtualTree(tree)\
\9\9local internalData = tree[InternalData]\
\9\9if config.typeChecks then\
\9\9\9assert(Type.of(tree) == Type.VirtualTree, \"Expected arg #1 to be a Roact handle\")\
\9\9\9assert(internalData.mounted, \"Cannot unmounted a Roact tree that has already been unmounted\")\
\9\9end\
\
\9\9internalData.mounted = false\
\
\9\9if internalData.rootNode ~= nil then\
\9\9\9unmountVirtualNode(internalData.rootNode)\
\9\9end\
\9end\
\
\9--[[\
\9\9Utility method for updating the root node of a virtual tree given a new\
\9\9element.\
\9]]\
\9local function updateVirtualTree(tree, newElement)\
\9\9local internalData = tree[InternalData]\
\9\9if config.typeChecks then\
\9\9\9assert(Type.of(tree) == Type.VirtualTree, \"Expected arg #1 to be a Roact handle\")\
\9\9\9assert(Type.of(newElement) == Type.Element, \"Expected arg #2 to be a Roact Element\")\
\9\9end\
\
\9\9internalData.rootNode = updateVirtualNode(internalData.rootNode, newElement)\
\
\9\9return tree\
\9end\
\
\9local function suspendParentEvents(virtualNode)\
\9\9local parentNode = virtualNode.parent\
\9\9while parentNode do\
\9\9\9if parentNode.eventManager ~= nil then\
\9\9\9\9parentNode.eventManager:suspend()\
\9\9\9end\
\
\9\9\9parentNode = parentNode.parent\
\9\9end\
\9end\
\
\9local function resumeParentEvents(virtualNode)\
\9\9local parentNode = virtualNode.parent\
\9\9while parentNode do\
\9\9\9if parentNode.eventManager ~= nil then\
\9\9\9\9parentNode.eventManager:resume()\
\9\9\9end\
\
\9\9\9parentNode = parentNode.parent\
\9\9end\
\9end\
\
\9reconciler = {\
\9\9mountVirtualTree = mountVirtualTree,\
\9\9unmountVirtualTree = unmountVirtualTree,\
\9\9updateVirtualTree = updateVirtualTree,\
\
\9\9createVirtualNode = createVirtualNode,\
\9\9mountVirtualNode = mountVirtualNode,\
\9\9unmountVirtualNode = unmountVirtualNode,\
\9\9updateVirtualNode = updateVirtualNode,\
\9\9updateVirtualNodeWithChildren = updateVirtualNodeWithChildren,\
\9\9updateVirtualNodeWithRenderResult = updateVirtualNodeWithRenderResult,\
\
\9\9suspendParentEvents = suspendParentEvents,\
\9\9resumeParentEvents = resumeParentEvents,\
\9}\
\
\9return reconciler\
end\
\
return createReconciler\
", '@'.."RemoteSpy.include.node_modules.roact.src.createReconciler")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createReconciler")) return fn() end)

_module("createReconcilerCompat", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createReconcilerCompat", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Contains deprecated methods from Reconciler. Broken out so that removing\
\9this shim is easy -- just delete this file and remove it from init.\
]]\
\
local Logging = require(script.Parent.Logging)\
\
local reifyMessage = [[\
Roact.reify has been renamed to Roact.mount and will be removed in a future release.\
Check the call to Roact.reify at:\
]]\
\
local teardownMessage = [[\
Roact.teardown has been renamed to Roact.unmount and will be removed in a future release.\
Check the call to Roact.teardown at:\
]]\
\
local reconcileMessage = [[\
Roact.reconcile has been renamed to Roact.update and will be removed in a future release.\
Check the call to Roact.reconcile at:\
]]\
\
local function createReconcilerCompat(reconciler)\
\9local compat = {}\
\
\9function compat.reify(...)\
\9\9Logging.warnOnce(reifyMessage)\
\
\9\9return reconciler.mountVirtualTree(...)\
\9end\
\
\9function compat.teardown(...)\
\9\9Logging.warnOnce(teardownMessage)\
\
\9\9return reconciler.unmountVirtualTree(...)\
\9end\
\
\9function compat.reconcile(...)\
\9\9Logging.warnOnce(reconcileMessage)\
\
\9\9return reconciler.updateVirtualTree(...)\
\9end\
\
\9return compat\
end\
\
return createReconcilerCompat", '@'.."RemoteSpy.include.node_modules.roact.src.createReconcilerCompat")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createReconcilerCompat")) return fn() end)

_module("createRef", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createRef", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9A ref is nothing more than a binding with a special field 'current'\
\9that maps to the getValue method of the binding\
]]\
local Binding = require(script.Parent.Binding)\
\
local function createRef()\
\9local binding, _ = Binding.create(nil)\
\
\9local ref = {}\
\
\9--[[\
\9\9A ref is just redirected to a binding via its metatable\
\9]]\
\9setmetatable(ref, {\
\9\9__index = function(self, key)\
\9\9\9if key == \"current\" then\
\9\9\9\9return binding:getValue()\
\9\9\9else\
\9\9\9\9return binding[key]\
\9\9\9end\
\9\9end,\
\9\9__newindex = function(self, key, value)\
\9\9\9if key == \"current\" then\
\9\9\9\9error(\"Cannot assign to the 'current' property of refs\", 2)\
\9\9\9end\
\
\9\9\9binding[key] = value\
\9\9end,\
\9\9__tostring = function(self)\
\9\9\9return (\"RoactRef(%s)\"):format(tostring(binding:getValue()))\
\9\9end,\
\9})\
\
\9return ref\
end\
\
return createRef", '@'.."RemoteSpy.include.node_modules.roact.src.createRef")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createRef")) return fn() end)

_module("createSignal", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createSignal", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9This is a simple signal implementation that has a dead-simple API.\
\
\9\9local signal = createSignal()\
\
\9\9local disconnect = signal:subscribe(function(foo)\
\9\9\9print(\"Cool foo:\", foo)\
\9\9end)\
\
\9\9signal:fire(\"something\")\
\
\9\9disconnect()\
]]\
\
local function createSignal()\
\9local connections = {}\
\9local suspendedConnections = {}\
\9local firing = false\
\
\9local function subscribe(self, callback)\
\9\9assert(typeof(callback) == \"function\", \"Can only subscribe to signals with a function.\")\
\
\9\9local connection = {\
\9\9\9callback = callback,\
\9\9\9disconnected = false,\
\9\9}\
\
\9\9-- If the callback is already registered, don't add to the suspendedConnection. Otherwise, this will disable\
\9\9-- the existing one.\
\9\9if firing and not connections[callback] then\
\9\9\9suspendedConnections[callback] = connection\
\9\9end\
\
\9\9connections[callback] = connection\
\
\9\9local function disconnect()\
\9\9\9assert(not connection.disconnected, \"Listeners can only be disconnected once.\")\
\
\9\9\9connection.disconnected = true\
\9\9\9connections[callback] = nil\
\9\9\9suspendedConnections[callback] = nil\
\9\9end\
\
\9\9return disconnect\
\9end\
\
\9local function fire(self, ...)\
\9\9firing = true\
\9\9for callback, connection in pairs(connections) do\
\9\9\9if not connection.disconnected and not suspendedConnections[callback] then\
\9\9\9\9callback(...)\
\9\9\9end\
\9\9end\
\
\9\9firing = false\
\
\9\9for callback, _ in pairs(suspendedConnections) do\
\9\9\9suspendedConnections[callback] = nil\
\9\9end\
\9end\
\
\9return {\
\9\9subscribe = subscribe,\
\9\9fire = fire,\
\9}\
end\
\
return createSignal\
", '@'.."RemoteSpy.include.node_modules.roact.src.createSignal")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createSignal")) return fn() end)

_module("createSpy", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.createSpy", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9A utility used to create a function spy that can be used to robustly test\
\9that functions are invoked the correct number of times and with the correct\
\9number of arguments.\
\
\9This should only be used in tests.\
]]\
\
local assertDeepEqual = require(script.Parent.assertDeepEqual)\
\
local function createSpy(inner)\
\9local self = {\
\9\9callCount = 0,\
\9\9values = {},\
\9\9valuesLength = 0,\
\9}\
\
\9self.value = function(...)\
\9\9self.callCount = self.callCount + 1\
\9\9self.values = {...}\
\9\9self.valuesLength = select(\"#\", ...)\
\
\9\9if inner ~= nil then\
\9\9\9return inner(...)\
\9\9end\
\9end\
\
\9self.assertCalledWith = function(_, ...)\
\9\9local len = select(\"#\", ...)\
\
\9\9if self.valuesLength ~= len then\
\9\9\9error((\"Expected %d arguments, but was called with %d arguments\"):format(\
\9\9\9\9self.valuesLength,\
\9\9\9\9len\
\9\9\9), 2)\
\9\9end\
\
\9\9for i = 1, len do\
\9\9\9local expected = select(i, ...)\
\
\9\9\9assert(self.values[i] == expected, \"value differs\")\
\9\9end\
\9end\
\
\9self.assertCalledWithDeepEqual = function(_, ...)\
\9\9local len = select(\"#\", ...)\
\
\9\9if self.valuesLength ~= len then\
\9\9\9error((\"Expected %d arguments, but was called with %d arguments\"):format(\
\9\9\9\9self.valuesLength,\
\9\9\9\9len\
\9\9\9), 2)\
\9\9end\
\
\9\9for i = 1, len do\
\9\9\9local expected = select(i, ...)\
\
\9\9\9assertDeepEqual(self.values[i], expected)\
\9\9end\
\9end\
\
\9self.captureValues = function(_, ...)\
\9\9local len = select(\"#\", ...)\
\9\9local result = {}\
\
\9\9assert(self.valuesLength == len, \"length of expected values differs from stored values\")\
\
\9\9for i = 1, len do\
\9\9\9local key = select(i, ...)\
\9\9\9result[key] = self.values[i]\
\9\9end\
\
\9\9return result\
\9end\
\
\9setmetatable(self, {\
\9\9__index = function(_, key)\
\9\9\9error((\"%q is not a valid member of spy\"):format(key))\
\9\9end,\
\9})\
\
\9return self\
end\
\
return createSpy", '@'.."RemoteSpy.include.node_modules.roact.src.createSpy")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.createSpy")) return fn() end)

_module("forwardRef", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.forwardRef", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local assign = require(script.Parent.assign)\
local None = require(script.Parent.None)\
local Ref = require(script.Parent.PropMarkers.Ref)\
\
local config = require(script.Parent.GlobalConfig).get()\
\
local excludeRef = {\
\9[Ref] = None,\
}\
\
--[[\
\9Allows forwarding of refs to underlying host components. Accepts a render\
\9callback which accepts props and a ref, and returns an element.\
]]\
local function forwardRef(render)\
\9if config.typeChecks then\
\9\9assert(typeof(render) == \"function\", \"Expected arg #1 to be a function\")\
\9end\
\
\9return function(props)\
\9\9local ref = props[Ref]\
\9\9local propsWithoutRef = assign({}, props, excludeRef)\
\
\9\9return render(propsWithoutRef, ref)\
\9end\
end\
\
return forwardRef", '@'.."RemoteSpy.include.node_modules.roact.src.forwardRef")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.forwardRef")) return fn() end)

_module("getDefaultInstanceProperty", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.getDefaultInstanceProperty", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Attempts to get the default value of a given property on a Roblox instance.\
\
\9This is used by the reconciler in cases where a prop was previously set on a\
\9primitive component, but is no longer present in a component's new props.\
\
\9Eventually, Roblox might provide a nicer API to query the default property\
\9of an object without constructing an instance of it.\
]]\
\
local Symbol = require(script.Parent.Symbol)\
\
local Nil = Symbol.named(\"Nil\")\
local _cachedPropertyValues = {}\
\
local function getDefaultInstanceProperty(className, propertyName)\
\9local classCache = _cachedPropertyValues[className]\
\
\9if classCache then\
\9\9local propValue = classCache[propertyName]\
\
\9\9-- We have to use a marker here, because Lua doesn't distinguish\
\9\9-- between 'nil' and 'not in a table'\
\9\9if propValue == Nil then\
\9\9\9return true, nil\
\9\9end\
\
\9\9if propValue ~= nil then\
\9\9\9return true, propValue\
\9\9end\
\9else\
\9\9classCache = {}\
\9\9_cachedPropertyValues[className] = classCache\
\9end\
\
\9local created = Instance.new(className)\
\9local ok, defaultValue = pcall(function()\
\9\9return created[propertyName]\
\9end)\
\
\9created:Destroy()\
\
\9if ok then\
\9\9if defaultValue == nil then\
\9\9\9classCache[propertyName] = Nil\
\9\9else\
\9\9\9classCache[propertyName] = defaultValue\
\9\9end\
\9end\
\
\9return ok, defaultValue\
end\
\
return getDefaultInstanceProperty", '@'.."RemoteSpy.include.node_modules.roact.src.getDefaultInstanceProperty")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.getDefaultInstanceProperty")) return fn() end)

_module("internalAssert", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.internalAssert", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local function internalAssert(condition, message)\
\9if not condition then\
\9\9error(message .. \" (This is probably a bug in Roact!)\", 3)\
\9end\
end\
\
return internalAssert", '@'.."RemoteSpy.include.node_modules.roact.src.internalAssert")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.internalAssert")) return fn() end)

_module("invalidSetStateMessages", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.invalidSetStateMessages", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9These messages are used by Component to help users diagnose when they're\
\9calling setState in inappropriate places.\
\
\9The indentation may seem odd, but it's necessary to avoid introducing extra\
\9whitespace into the error messages themselves.\
]]\
local ComponentLifecyclePhase = require(script.Parent.ComponentLifecyclePhase)\
\
local invalidSetStateMessages = {}\
\
invalidSetStateMessages[ComponentLifecyclePhase.WillUpdate] = [[\
setState cannot be used in the willUpdate lifecycle method.\
Consider using the didUpdate method instead, or using getDerivedStateFromProps.\
\
Check the definition of willUpdate in the component %q.]]\
\
invalidSetStateMessages[ComponentLifecyclePhase.WillUnmount] = [[\
setState cannot be used in the willUnmount lifecycle method.\
A component that is being unmounted cannot be updated!\
\
Check the definition of willUnmount in the component %q.]]\
\
invalidSetStateMessages[ComponentLifecyclePhase.ShouldUpdate] = [[\
setState cannot be used in the shouldUpdate lifecycle method.\
shouldUpdate must be a pure function that only depends on props and state.\
\
Check the definition of shouldUpdate in the component %q.]]\
\
invalidSetStateMessages[ComponentLifecyclePhase.Render] = [[\
setState cannot be used in the render method.\
render must be a pure function that only depends on props and state.\
\
Check the definition of render in the component %q.]]\
\
invalidSetStateMessages[\"default\"] = [[\
setState can not be used in the current situation, because Roact doesn't know\
which part of the lifecycle this component is in.\
\
This is a bug in Roact.\
It was triggered by the component %q.\
]]\
\
return invalidSetStateMessages", '@'.."RemoteSpy.include.node_modules.roact.src.invalidSetStateMessages")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.invalidSetStateMessages")) return fn() end)

_module("oneChild", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.oneChild", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("--[[\
\9Retrieves at most one child from the children passed to a component.\
\
\9If passed nil or an empty table, will return nil.\
\
\9Throws an error if passed more than one child.\
]]\
local function oneChild(children)\
\9if not children then\
\9\9return nil\
\9end\
\
\9local key, child = next(children)\
\
\9if not child then\
\9\9return nil\
\9end\
\
\9local after = next(children, key)\
\
\9if after then\
\9\9error(\"Expected at most child, had more than one child.\", 2)\
\9end\
\
\9return child\
end\
\
return oneChild", '@'.."RemoteSpy.include.node_modules.roact.src.oneChild")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.oneChild")) return fn() end)

_module("strict", "ModuleScript", "RemoteSpy.include.node_modules.roact.src.strict", "RemoteSpy.include.node_modules.roact.src", function () local fn = assert(loadstring("local function strict(t, name)\
\9name = name or tostring(t)\
\
\9return setmetatable(t, {\
\9\9__index = function(self, key)\
\9\9\9local message = (\"%q (%s) is not a valid member of %s\"):format(\
\9\9\9\9tostring(key),\
\9\9\9\9typeof(key),\
\9\9\9\9name\
\9\9\9)\
\
\9\9\9error(message, 2)\
\9\9end,\
\
\9\9__newindex = function(self, key, value)\
\9\9\9local message = (\"%q (%s) is not a valid member of %s\"):format(\
\9\9\9\9tostring(key),\
\9\9\9\9typeof(key),\
\9\9\9\9name\
\9\9\9)\
\
\9\9\9error(message, 2)\
\9\9end,\
\9})\
end\
\
return strict", '@'.."RemoteSpy.include.node_modules.roact.src.strict")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact.src.strict")) return fn() end)

_instance("roact-hooked", "Folder", "RemoteSpy.include.node_modules.roact-hooked", "RemoteSpy.include.node_modules")

_module("out", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out", "RemoteSpy.include.node_modules.roact-hooked", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local exports = {}\
local _with_hooks = TS.import(script, script, \"with-hooks\")\
local withHooks = _with_hooks.withHooks\
local withHooksPure = _with_hooks.withHooksPure\
for _k, _v in pairs(TS.import(script, script, \"hooks\")) do\
\9exports[_k] = _v\
end\
--[[\
\9*\
\9* `hooked` is a [higher-order component](https://reactjs.org/docs/higher-order-components.html) that turns your\
\9* Function Component into a [class component](https://roblox.github.io/roact/guide/components/).\
\9*\
\9* `hooked` allows you to hook into the Component's lifecycle through Hooks.\
\9*\
\9* @example\
\9* const MyComponent = hooked<Props>(\
\9*   (props) => {\
\9*     // render using props\
\9*   },\
\9* );\
\9*\
\9* @see https://reactjs.org/docs/hooks-intro.html\
]]\
local function hooked(functionComponent)\
\9return withHooks(functionComponent)\
end\
--[[\
\9*\
\9* `pure` is a [higher-order component](https://reactjs.org/docs/higher-order-components.html) that turns your\
\9* Function Component into a [PureComponent](https://roblox.github.io/roact/performance/reduce-reconciliation/#purecomponent).\
\9*\
\9* If your function component wrapped in `pure` has a {@link useState}, {@link useReducer} or {@link useContext} Hook\
\9* in its implementation, it will still rerender when state or context changes.\
\9*\
\9* @example\
\9* const MyComponent = pure<Props>(\
\9*   (props) => {\
\9*     // render using props\
\9*   },\
\9* );\
\9*\
\9* @see https://reactjs.org/docs/react-api.html\
\9* @see https://roblox.github.io/roact/performance/reduce-reconciliation/\
]]\
local function pure(functionComponent)\
\9return withHooksPure(functionComponent)\
end\
exports.hooked = hooked\
exports.pure = pure\
return exports\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out")) return fn() end)

_module("hooks", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", "RemoteSpy.include.node_modules.roact-hooked.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local exports = {}\
exports.useBinding = TS.import(script, script, \"use-binding\").useBinding\
exports.useCallback = TS.import(script, script, \"use-callback\").useCallback\
exports.useContext = TS.import(script, script, \"use-context\").useContext\
exports.useEffect = TS.import(script, script, \"use-effect\").useEffect\
exports.useMemo = TS.import(script, script, \"use-memo\").useMemo\
exports.useReducer = TS.import(script, script, \"use-reducer\").useReducer\
exports.useState = TS.import(script, script, \"use-state\").useState\
exports.useMutable = TS.import(script, script, \"use-mutable\").useMutable\
exports.useRef = TS.import(script, script, \"use-ref\").useRef\
return exports\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks")) return fn() end)

_module("use-binding", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-binding", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local createBinding = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src).createBinding\
local memoizedHook = TS.import(script, script.Parent.Parent, \"memoized-hook\").memoizedHook\
--[[\
\9*\
\9* `useBinding` returns a memoized *`Binding`*, a special object that Roact automatically unwraps into values. When a\
\9* binding is updated, Roact will only change the specific properties that are subscribed to it.\
\9*\
\9* The first value returned is a `Binding` object, which will typically be passed as a prop to a Roact host component.\
\9* The second is a function that can be called with a new value to update the binding.\
\9*\
\9* @example\
\9* const [binding, setBindingValue] = useBinding(initialValue);\
\9*\
\9* @param initialValue - Initialized as the `.current` property\
\9* @returns A memoized `Binding` object, and a function to update the value of the binding.\
\9*\
\9* @see https://roblox.github.io/roact/advanced/bindings-and-refs/#bindings\
]]\
local function useBinding(initialValue)\
\9return memoizedHook(function()\
\9\9local bindingSet = { createBinding(initialValue) }\
\9\9return bindingSet\
\9end).state\
end\
return {\
\9useBinding = useBinding,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-binding")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-binding")) return fn() end)

_module("use-callback", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-callback", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local useMemo = TS.import(script, script.Parent, \"use-memo\").useMemo\
--[[\
\9*\
\9* Returns a memoized version of the callback that only changes if one of the dependencies has changed.\
\9*\
\9* This is useful when passing callbacks to optimized child components that rely on reference equality to prevent\
\9* unnecessary renders.\
\9*\
\9* `useCallback(fn, deps)` is equivalent to `useMemo(() => fn, deps)`.\
\9*\
\9* @example\
\9* const memoizedCallback = useCallback(\
\9*   () => {\
\9*     doSomething(a, b);\
\9*   },\
\9*   [a, b],\
\9* );\
\9*\
\9* @param callback - An inline callback\
\9* @param deps - An array of dependencies\
\9* @returns A memoized version of the callback\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usecallback\
]]\
local function useCallback(callback, deps)\
\9return useMemo(function()\
\9\9return callback\
\9end, deps)\
end\
return {\
\9useCallback = useCallback,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-callback")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-callback")) return fn() end)

_module("use-context", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-context", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
--[[\
\9*\
\9* @see https://github.com/Kampfkarren/roact-hooks/blob/main/src/createUseContext.lua\
]]\
local _memoized_hook = TS.import(script, script.Parent.Parent, \"memoized-hook\")\
local memoizedHook = _memoized_hook.memoizedHook\
local resolveCurrentComponent = _memoized_hook.resolveCurrentComponent\
local useEffect = TS.import(script, script.Parent, \"use-effect\").useEffect\
local useState = TS.import(script, script.Parent, \"use-state\").useState\
local function copyComponent(component)\
\9return setmetatable({}, {\
\9\9__index = component,\
\9})\
end\
--[[\
\9*\
\9* Accepts a context object (the value returned from `Roact.createContext`) and returns the current context value, as\
\9* given by the nearest context provider for the given context.\
\9*\
\9* When the nearest `Context.Provider` above the component updates, this Hook will trigger a rerender with the latest\
\9* context value.\
\9*\
\9* If there is no Provider, `useContext` returns the default value of the context.\
\9*\
\9* @param context - The Context object to read from\
\9* @returns The latest context value of the nearest Provider\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usecontext\
]]\
local function useContext(context)\
\9local thisContext = context\
\9local _binding = memoizedHook(function()\
\9\9local consumer = copyComponent(resolveCurrentComponent())\
\9\9thisContext.Consumer.init(consumer)\
\9\9return consumer.contextEntry\
\9end)\
\9local contextEntry = _binding.state\
\9if contextEntry then\
\9\9local _binding_1 = useState(contextEntry.value)\
\9\9local value = _binding_1[1]\
\9\9local setValue = _binding_1[2]\
\9\9useEffect(function()\
\9\9\9return contextEntry.onUpdate:subscribe(setValue)\
\9\9end, {})\
\9\9return value\
\9else\
\9\9return thisContext.defaultValue\
\9end\
end\
return {\
\9useContext = useContext,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-context")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-context")) return fn() end)

_module("use-effect", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-effect", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local areDepsEqual = TS.import(script, script.Parent.Parent, \"utils\", \"are-deps-equal\").areDepsEqual\
local _memoized_hook = TS.import(script, script.Parent.Parent, \"memoized-hook\")\
local memoizedHook = _memoized_hook.memoizedHook\
local resolveCurrentComponent = _memoized_hook.resolveCurrentComponent\
local function scheduleEffect(effect)\
\9local _binding = resolveCurrentComponent()\
\9local effects = _binding.effects\
\9if effects.tail == nil then\
\9\9-- This is the first effect in the list\
\9\9effects.tail = effect\
\9\9effects.head = effects.tail\
\9else\
\9\9-- Append to the end of the list\
\9\9local _exp = effects.tail\
\9\9_exp.next = effect\
\9\9effects.tail = _exp.next\
\9end\
\9return effect\
end\
--[[\
\9*\
\9* Accepts a function that contains imperative, possibly effectful code. The function passed to `useEffect` will run\
\9* synchronously (thread-blocking) after the Roblox Instance is created and rendered.\
\9*\
\9* The clean-up function (returned by the effect) runs before the component is removed from the UI to prevent memory\
\9* leaks. Additionally, if a component renders multiple times, the **previous effect is cleaned up before executing\
\9* the next effect**.\
\9*\
\9*`useEffect` runs in the same phase as `didMount` and `didUpdate`. All cleanup functions are called on `willUnmount`.\
\9*\
\9* @example\
\9* useEffect(() => {\
\9*   // use value\
\9*   return () => {\
\9*     // cleanup\
\9*   }\
\9* }, [value]);\
\9*\
\9* useEffect(() => {\
\9*   // did update\
\9* });\
\9*\
\9* useEffect(() => {\
\9*   // did mount\
\9*   return () => {\
\9*     // will unmount\
\9*   }\
\9* }, []);\
\9*\
\9* @param callback - Imperative function that can return a cleanup function\
\9* @param deps - If present, effect will only activate if the values in the list change\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#useeffect\
]]\
local function useEffect(callback, deps)\
\9local hook = memoizedHook(nil)\
\9local _prevDeps = hook.state\
\9if _prevDeps ~= nil then\
\9\9_prevDeps = _prevDeps.deps\
\9end\
\9local prevDeps = _prevDeps\
\9if deps and areDepsEqual(deps, prevDeps) then\
\9\9return nil\
\9end\
\9hook.state = scheduleEffect({\
\9\9id = hook.id,\
\9\9callback = callback,\
\9\9deps = deps,\
\9})\
end\
return {\
\9useEffect = useEffect,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-effect")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-effect")) return fn() end)

_module("use-memo", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-memo", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local areDepsEqual = TS.import(script, script.Parent.Parent, \"utils\", \"are-deps-equal\").areDepsEqual\
local memoizedHook = TS.import(script, script.Parent.Parent, \"memoized-hook\").memoizedHook\
--[[\
\9*\
\9* `useMemo` will only recompute the memoized value when one of the `deps` has changed. This optimization helps to\
\9* avoid expensive calculations on every render.\
\9*\
\9* Remember that the function passed to `useMemo` runs during rendering. Don’t do anything there that you wouldn’t\
\9* normally do while rendering. For example, side effects belong in `useEffect`, not `useMemo`.\
\9*\
\9* If no array is provided, a new value will be computed on every render. This is usually a mistake, so `deps` must be\
\9* explicitly written as `undefined`.\
\9*\
\9* @example\
\9* const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);\
\9*\
\9* @param factory - A \"create\" function that computes a value\
\9* @param deps - An array of dependencies\
\9* @returns A memoized value\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usememo\
]]\
local function useMemo(factory, deps)\
\9local hook = memoizedHook(function()\
\9\9return {}\
\9end)\
\9local _binding = hook.state\
\9local prevValue = _binding[1]\
\9local prevDeps = _binding[2]\
\9if prevValue ~= nil and (deps and areDepsEqual(deps, prevDeps)) then\
\9\9return prevValue\
\9end\
\9local nextValue = factory()\
\9hook.state = { nextValue, deps }\
\9return nextValue\
end\
return {\
\9useMemo = useMemo,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-memo")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-memo")) return fn() end)

_module("use-mutable", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-mutable", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local memoizedHook = TS.import(script, script.Parent.Parent, \"memoized-hook\").memoizedHook\
-- Function overloads from https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/react/index.d.ts#L1061\
--[[\
\9*\
\9* `useMutable` returns a mutable object whose `.current` property is initialized to the argument `initialValue`.\
\9* The returned object will persist for the full lifetime of the component.\
\9*\
\9* `useMutable()` is handy for keeping any mutable value around similar to how you’d use instance fields in classes.\
\9*\
\9* This cannot be used as a [Roact Ref](https://roblox.github.io/roact/advanced/bindings-and-refs/#refs). If you want\
\9* to reference a Roblox Instance, refer to {@link useRef}.\
\9*\
\9* @example\
\9* const container = useMutable(initialValue);\
\9* useEffect(() => {\
\9*   container.current = value;\
\9* });\
\9*\
\9* @param initialValue - Initialized as the `.current` property\
\9* @returns A memoized, mutable object\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#useref\
]]\
--[[\
\9*\
\9* `useMutable` returns a mutable object whose `.current` property is initialized to the argument `initialValue`.\
\9* The returned object will persist for the full lifetime of the component.\
\9*\
\9* `useMutable()` is handy for keeping any mutable value around similar to how you’d use instance fields in classes.\
\9*\
\9* This cannot be used as a [Roact Ref](https://roblox.github.io/roact/advanced/bindings-and-refs/#refs). If you want\
\9* to reference a Roblox Instance, refer to {@link useRef}.\
\9*\
\9* @example\
\9* const container = useMutable(initialValue);\
\9* useEffect(() => {\
\9*   container.current = value;\
\9* });\
\9*\
\9* @param initialValue - Initialized as the `.current` property\
\9* @returns A memoized, mutable object\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#useref\
]]\
-- convenience overload for refs given as a ref prop as they typically start with a null value\
--[[\
\9*\
\9* `useMutable` returns a mutable object whose `.current` property is initialized to the argument `initialValue`.\
\9* The returned object will persist for the full lifetime of the component.\
\9*\
\9* `useMutable()` is handy for keeping any mutable value around similar to how you’d use instance fields in classes.\
\9*\
\9* This cannot be used as a [Roact Ref](https://roblox.github.io/roact/advanced/bindings-and-refs/#refs). If you want\
\9* to reference a Roblox Instance, refer to {@link useRef}.\
\9*\
\9* @example\
\9* const container = useMutable(initialValue);\
\9* useEffect(() => {\
\9*   container.current = value;\
\9* });\
\9*\
\9* @returns A memoized, mutable object\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#useref\
]]\
-- convenience overload for potentially undefined initialValue / call with 0 arguments\
-- has a default to stop it from defaulting to {} instead\
--[[\
\9*\
\9* `useMutable` returns a mutable object whose `.current` property is initialized to the argument `initialValue`.\
\9* The returned object will persist for the full lifetime of the component.\
\9*\
\9* `useMutable()` is handy for keeping any mutable value around similar to how you’d use instance fields in classes.\
\9*\
\9* This cannot be used as a [Roact Ref](https://roblox.github.io/roact/advanced/bindings-and-refs/#refs). If you want\
\9* to reference a Roblox Instance, refer to {@link useRef}.\
\9*\
\9* @example\
\9* const container = useMutable(initialValue);\
\9* useEffect(() => {\
\9*   container.current = value;\
\9* });\
\9*\
\9* @param initialValue - Initialized as the `.current` property\
\9* @returns A memoized, mutable object\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#useref\
]]\
local function useMutable(initialValue)\
\9return memoizedHook(function()\
\9\9return {\
\9\9\9current = initialValue,\
\9\9}\
\9end).state\
end\
return {\
\9useMutable = useMutable,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-mutable")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-mutable")) return fn() end)

_module("use-reducer", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-reducer", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local _memoized_hook = TS.import(script, script.Parent.Parent, \"memoized-hook\")\
local memoizedHook = _memoized_hook.memoizedHook\
local resolveCurrentComponent = _memoized_hook.resolveCurrentComponent\
--[[\
\9*\
\9* Accepts a reducer of type `(state, action) => newState`, and returns the current state paired with a `dispatch`\
\9* method.\
\9*\
\9* If a new state is the same value as the current state, this will bail out without rerendering the component.\
\9*\
\9* `useReducer` is usually preferable to `useState` when you have complex state logic that involves multiple sub-values.\
\9* It also lets you optimize performance for components that trigger deep updates because [you can pass `dispatch` down\
\9* instead of callbacks](https://reactjs.org/docs/hooks-faq.html#how-to-avoid-passing-callbacks-down).\
\9*\
\9* There are two different ways to initialize `useReducer` state. You can use the initial state as a second argument,\
\9* or [create the initial state lazily](https://reactjs.org/docs/hooks-reference.html#lazy-initialization). To do this,\
\9* you can pass an init function as the third argument. The initial state will be set to `initializer(initialArg)`.\
\9*\
\9* @param reducer - Function that returns a state given the current state and an action\
\9* @param initializerArg - State used during the initial render, or passed to `initializer` if provided\
\9* @param initializer - Optional function that returns an initial state given `initializerArg`\
\9* @returns The current state, and an action dispatcher\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usereducer\
]]\
-- overload where dispatch could accept 0 arguments.\
--[[\
\9*\
\9* Accepts a reducer of type `(state, action) => newState`, and returns the current state paired with a `dispatch`\
\9* method.\
\9*\
\9* If a new state is the same value as the current state, this will bail out without rerendering the component.\
\9*\
\9* `useReducer` is usually preferable to `useState` when you have complex state logic that involves multiple sub-values.\
\9* It also lets you optimize performance for components that trigger deep updates because [you can pass `dispatch` down\
\9* instead of callbacks](https://reactjs.org/docs/hooks-faq.html#how-to-avoid-passing-callbacks-down).\
\9*\
\9* There are two different ways to initialize `useReducer` state. You can use the initial state as a second argument,\
\9* or [create the initial state lazily](https://reactjs.org/docs/hooks-reference.html#lazy-initialization). To do this,\
\9* you can pass an init function as the third argument. The initial state will be set to `initializer(initialArg)`.\
\9*\
\9* @param reducer - Function that returns a state given the current state and an action\
\9* @param initializerArg - State used during the initial render, or passed to `initializer` if provided\
\9* @param initializer - Optional function that returns an initial state given `initializerArg`\
\9* @returns The current state, and an action dispatcher\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usereducer\
]]\
-- overload where dispatch could accept 0 arguments.\
--[[\
\9*\
\9* Accepts a reducer of type `(state, action) => newState`, and returns the current state paired with a `dispatch`\
\9* method.\
\9*\
\9* If a new state is the same value as the current state, this will bail out without rerendering the component.\
\9*\
\9* `useReducer` is usually preferable to `useState` when you have complex state logic that involves multiple sub-values.\
\9* It also lets you optimize performance for components that trigger deep updates because [you can pass `dispatch` down\
\9* instead of callbacks](https://reactjs.org/docs/hooks-faq.html#how-to-avoid-passing-callbacks-down).\
\9*\
\9* There are two different ways to initialize `useReducer` state. You can use the initial state as a second argument,\
\9* or [create the initial state lazily](https://reactjs.org/docs/hooks-reference.html#lazy-initialization). To do this,\
\9* you can pass an init function as the third argument. The initial state will be set to `initializer(initialArg)`.\
\9*\
\9* @param reducer - Function that returns a state given the current state and an action\
\9* @param initializerArg - State used during the initial render, or passed to `initializer` if provided\
\9* @param initializer - Optional function that returns an initial state given `initializerArg`\
\9* @returns The current state, and an action dispatcher\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usereducer\
]]\
-- overload for free \"I\"; all goes as long as initializer converts it into \"ReducerState<R>\".\
--[[\
\9*\
\9* Accepts a reducer of type `(state, action) => newState`, and returns the current state paired with a `dispatch`\
\9* method.\
\9*\
\9* If a new state is the same value as the current state, this will bail out without rerendering the component.\
\9*\
\9* `useReducer` is usually preferable to `useState` when you have complex state logic that involves multiple sub-values.\
\9* It also lets you optimize performance for components that trigger deep updates because [you can pass `dispatch` down\
\9* instead of callbacks](https://reactjs.org/docs/hooks-faq.html#how-to-avoid-passing-callbacks-down).\
\9*\
\9* There are two different ways to initialize `useReducer` state. You can use the initial state as a second argument,\
\9* or [create the initial state lazily](https://reactjs.org/docs/hooks-reference.html#lazy-initialization). To do this,\
\9* you can pass an init function as the third argument. The initial state will be set to `initializer(initialArg)`.\
\9*\
\9* @param reducer - Function that returns a state given the current state and an action\
\9* @param initializerArg - State used during the initial render, or passed to `initializer` if provided\
\9* @param initializer - Optional function that returns an initial state given `initializerArg`\
\9* @returns The current state, and an action dispatcher\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usereducer\
]]\
-- overload where \"I\" may be a subset of ReducerState<R>; used to provide autocompletion.\
-- If \"I\" matches ReducerState<R> exactly then the last overload will allow initializer to be omitted.\
--[[\
\9*\
\9* Accepts a reducer of type `(state, action) => newState`, and returns the current state paired with a `dispatch`\
\9* method.\
\9*\
\9* If a new state is the same value as the current state, this will bail out without rerendering the component.\
\9*\
\9* `useReducer` is usually preferable to `useState` when you have complex state logic that involves multiple sub-values.\
\9* It also lets you optimize performance for components that trigger deep updates because [you can pass `dispatch` down\
\9* instead of callbacks](https://reactjs.org/docs/hooks-faq.html#how-to-avoid-passing-callbacks-down).\
\9*\
\9* There are two different ways to initialize `useReducer` state. You can use the initial state as a second argument,\
\9* or [create the initial state lazily](https://reactjs.org/docs/hooks-reference.html#lazy-initialization). To do this,\
\9* you can pass an init function as the third argument. The initial state will be set to `initializer(initialArg)`.\
\9*\
\9* @param reducer - Function that returns a state given the current state and an action\
\9* @param initializerArg - State used during the initial render, or passed to `initializer` if provided\
\9* @param initializer - Optional function that returns an initial state given `initializerArg`\
\9* @returns The current state, and an action dispatcher\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usereducer\
]]\
-- Implementation matches a previous overload, is this required?\
local function useReducer(reducer, initializerArg, initializer)\
\9local currentComponent = resolveCurrentComponent()\
\9local hook = memoizedHook(function()\
\9\9if initializer then\
\9\9\9return initializer(initializerArg)\
\9\9else\
\9\9\9return initializerArg\
\9\9end\
\9end)\
\9local function dispatch(action)\
\9\9local nextState = reducer(hook.state, action)\
\9\9if hook.state ~= nextState then\
\9\9\9currentComponent:setHookState(hook.id, function()\
\9\9\9\9hook.state = nextState\
\9\9\9\9return hook.state\
\9\9\9end)\
\9\9end\
\9end\
\9return { hook.state, dispatch }\
end\
return {\
\9useReducer = useReducer,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-reducer")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-reducer")) return fn() end)

_module("use-ref", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-ref", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local createRef = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src).createRef\
local memoizedHook = TS.import(script, script.Parent.Parent, \"memoized-hook\").memoizedHook\
--[[\
\9*\
\9* `useRef` returns a memoized *`Ref`*, a special type of binding that points to Roblox Instance objects that are\
\9* created by Roact. The returned object will persist for the full lifetime of the component.\
\9*\
\9* `useMutable()` is handy for keeping any mutable value around similar to how you’d use instance fields in classes.\
\9*\
\9* This is not mutable like React's `useRef` hook. If you want to use a mutable object, refer to {@link useMutable}.\
\9*\
\9* @example\
\9* const ref = useRef<TextBox>();\
\9*\
\9* useEffect(() => {\
\9* \9const textBox = ref.getValue();\
\9* \9if (textBox) {\
\9* \9\9textBox.CaptureFocus();\
\9* \9}\
\9* }, []);\
\9*\
\9* return <textbox Ref={ref} />;\
\9*\
\9* @returns A memoized `Ref` object\
\9*\
\9* @see https://roblox.github.io/roact/advanced/bindings-and-refs/#refs\
]]\
local function useRef()\
\9return memoizedHook(function()\
\9\9return createRef()\
\9end).state\
end\
return {\
\9useRef = useRef,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-ref")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-ref")) return fn() end)

_module("use-state", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-state", "RemoteSpy.include.node_modules.roact-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local resolve = TS.import(script, script.Parent.Parent, \"utils\", \"resolve\").resolve\
local useReducer = TS.import(script, script.Parent, \"use-reducer\").useReducer\
--[[\
\9*\
\9* Returns a stateful value, and a function to update it.\
\9*\
\9* During the initial render, the returned state (`state`) is the same as the value passed as the first argument\
\9* (`initialState`).\
\9*\
\9* The `setState` function is used to update the state. It always knows the current state, so it's safe to omit from\
\9* the `useEffect` or `useCallback` dependency lists.\
\9*\
\9* If you update a State Hook to the same value as the current state, this will bail out without rerendering the\
\9* component.\
\9*\
\9* @example\
\9* const [state, setState] = useState(initialState);\
\9* const [state, setState] = useState(() => someExpensiveComputation());\
\9* setState(newState);\
\9* setState((prevState) => prevState + 1)\
\9*\
\9* @param initialState - State used during the initial render. Can be a function, which will be executed on initial render\
\9* @returns A stateful value, and an updater function\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usestate\
]]\
--[[\
\9*\
\9* Returns a stateful value, and a function to update it.\
\9*\
\9* During the initial render, the returned state (`state`) is the same as the value passed as the first argument\
\9* (`initialState`).\
\9*\
\9* The `setState` function is used to update the state. It always knows the current state, so it's safe to omit from\
\9* the `useEffect` or `useCallback` dependency lists.\
\9*\
\9* If you update a State Hook to the same value as the current state, this will bail out without rerendering the\
\9* component.\
\9*\
\9* @example\
\9* const [state, setState] = useState(initialState);\
\9* const [state, setState] = useState(() => someExpensiveComputation());\
\9* setState(newState);\
\9* setState((prevState) => prevState + 1)\
\9*\
\9* @param initialState - State used during the initial render. Can be a function, which will be executed on initial render\
\9* @returns A stateful value, and an updater function\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usestate\
]]\
--[[\
\9*\
\9* Returns a stateful value, and a function to update it.\
\9*\
\9* During the initial render, the returned state (`state`) is the same as the value passed as the first argument\
\9* (`initialState`).\
\9*\
\9* The `setState` function is used to update the state. It always knows the current state, so it's safe to omit from\
\9* the `useEffect` or `useCallback` dependency lists.\
\9*\
\9* If you update a State Hook to the same value as the current state, this will bail out without rerendering the\
\9* component.\
\9*\
\9* @example\
\9* const [state, setState] = useState(initialState);\
\9* const [state, setState] = useState(() => someExpensiveComputation());\
\9* setState(newState);\
\9* setState((prevState) => prevState + 1)\
\9*\
\9* @param initialState - State used during the initial render. Can be a function, which will be executed on initial render\
\9* @returns A stateful value, and an updater function\
\9*\
\9* @see https://reactjs.org/docs/hooks-reference.html#usestate\
]]\
local function useState(initialState)\
\9local _binding = useReducer(function(state, action)\
\9\9return resolve(action, state)\
\9end, nil, function()\
\9\9return resolve(initialState)\
\9end)\
\9local state = _binding[1]\
\9local dispatch = _binding[2]\
\9return { state, dispatch }\
end\
return {\
\9useState = useState,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-state")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.hooks.use-state")) return fn() end)

_module("memoized-hook", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.memoized-hook", "RemoteSpy.include.node_modules.roact-hooked.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local resolve = TS.import(script, script.Parent, \"utils\", \"resolve\").resolve\
local EXCEPTION_INVALID_HOOK_CALL = table.concat({ \"Invalid hook call. Hooks can only be called inside of the body of a function component.\", \"This is usually the result of conflicting versions of roact-hooked.\", \"See https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem.\" }, \"\\n\")\
local EXCEPTION_RENDER_NOT_DONE = \"Failed to render hook! (Another hooked component is rendering)\"\
local EXCEPTION_RENDER_OVERLAP = \"Failed to render hook! (Another hooked component rendered during this one)\"\
local currentHook\
local currentlyRenderingComponent\
--[[\
\9*\
\9* Prepares for an upcoming render.\
]]\
local function renderReady(component)\
\9local _arg0 = currentlyRenderingComponent == nil\
\9assert(_arg0, EXCEPTION_RENDER_NOT_DONE)\
\9currentlyRenderingComponent = component\
end\
--[[\
\9*\
\9* Cleans up hooks. Must be called after finishing a render!\
]]\
local function renderDone(component)\
\9local _arg0 = currentlyRenderingComponent == component\
\9assert(_arg0, EXCEPTION_RENDER_OVERLAP)\
\9currentlyRenderingComponent = nil\
\9currentHook = nil\
end\
--[[\
\9*\
\9* Returns the currently-rendering component. Throws an error if a component is not mid-render.\
]]\
local function resolveCurrentComponent()\
\9return currentlyRenderingComponent or error(EXCEPTION_INVALID_HOOK_CALL, 3)\
end\
--[[\
\9*\
\9* Gets or creates a new hook. Hooks are memoized for every component. See the original source\
\9* {@link https://github.com/facebook/react/blob/main/packages/react-reconciler/src/ReactFiberHooks.new.js#L619 here}.\
\9*\
\9* @param initialValue - Initial value for `Hook.state` and `Hook.baseState`.\
]]\
local function memoizedHook(initialValue)\
\9local currentlyRenderingComponent = resolveCurrentComponent()\
\9local nextHook\
\9if currentHook then\
\9\9nextHook = currentHook.next\
\9else\
\9\9nextHook = currentlyRenderingComponent.firstHook\
\9end\
\9if nextHook then\
\9\9-- The hook has already been created\
\9\9currentHook = nextHook\
\9else\
\9\9-- This is a new hook, should be from an initial render\
\9\9local state = resolve(initialValue)\
\9\9local id = 0\
\9\9if currentHook then\
\9\9\9id = currentHook.id + 1\
\9\9end\
\9\9local newHook = {\
\9\9\9id = id,\
\9\9\9state = state,\
\9\9\9baseState = state,\
\9\9}\
\9\9if not currentHook then\
\9\9\9-- This is the first hook in the list\
\9\9\9currentHook = newHook\
\9\9\9currentlyRenderingComponent.firstHook = currentHook\
\9\9else\
\9\9\9-- Append to the end of the list\
\9\9\9currentHook.next = newHook\
\9\9\9currentHook = currentHook.next\
\9\9end\
\9end\
\9return currentHook\
end\
return {\
\9renderReady = renderReady,\
\9renderDone = renderDone,\
\9resolveCurrentComponent = resolveCurrentComponent,\
\9memoizedHook = memoizedHook,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.memoized-hook")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.memoized-hook")) return fn() end)

_module("types", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.types", "RemoteSpy.include.node_modules.roact-hooked.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
-- Roact\
-- Reducers\
-- Utility types\
-- Hooks\
return nil\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.types")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.types")) return fn() end)

_instance("utils", "Folder", "RemoteSpy.include.node_modules.roact-hooked.out.utils", "RemoteSpy.include.node_modules.roact-hooked.out")

_module("are-deps-equal", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.utils.are-deps-equal", "RemoteSpy.include.node_modules.roact-hooked.out.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local function areDepsEqual(nextDeps, prevDeps)\
\9if prevDeps == nil then\
\9\9return false\
\9end\
\9if #nextDeps ~= #prevDeps then\
\9\9return false\
\9end\
\9do\
\9\9local i = 0\
\9\9local _shouldIncrement = false\
\9\9while true do\
\9\9\9if _shouldIncrement then\
\9\9\9\9i += 1\
\9\9\9else\
\9\9\9\9_shouldIncrement = true\
\9\9\9end\
\9\9\9if not (i < #nextDeps) then\
\9\9\9\9break\
\9\9\9end\
\9\9\9if nextDeps[i + 1] == prevDeps[i + 1] then\
\9\9\9\9continue\
\9\9\9end\
\9\9\9return false\
\9\9end\
\9end\
\9return true\
end\
return {\
\9areDepsEqual = areDepsEqual,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.utils.are-deps-equal")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.utils.are-deps-equal")) return fn() end)

_module("resolve", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.utils.resolve", "RemoteSpy.include.node_modules.roact-hooked.out.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local function resolve(fn, ...)\
\9local args = { ... }\
\9if type(fn) == \"function\" then\
\9\9return fn(unpack(args))\
\9else\
\9\9return fn\
\9end\
end\
return {\
\9resolve = resolve,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.utils.resolve")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.utils.resolve")) return fn() end)

_module("with-hooks", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.with-hooks", "RemoteSpy.include.node_modules.roact-hooked.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local exports = {}\
local _with_hooks = TS.import(script, script, \"with-hooks\")\
exports.withHooks = _with_hooks.withHooks\
exports.withHooksPure = _with_hooks.withHooksPure\
return exports\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.with-hooks")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.with-hooks")) return fn() end)

_module("component-with-hooks", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.with-hooks.component-with-hooks", "RemoteSpy.include.node_modules.roact-hooked.out.with-hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local _memoized_hook = TS.import(script, script.Parent.Parent, \"memoized-hook\")\
local renderDone = _memoized_hook.renderDone\
local renderReady = _memoized_hook.renderReady\
local ComponentWithHooks\
do\
\9ComponentWithHooks = {}\
\9function ComponentWithHooks:constructor()\
\9end\
\9function ComponentWithHooks:init()\
\9\9self.effects = {}\
\9\9self.effectHandles = {}\
\9end\
\9function ComponentWithHooks:setHookState(id, reducer)\
\9\9self:setState(function(state)\
\9\9\9return {\
\9\9\9\9[id] = reducer(state[id]),\
\9\9\9}\
\9\9end)\
\9end\
\9function ComponentWithHooks:render()\
\9\9renderReady(self)\
\9\9local _functionComponent = self.functionComponent\
\9\9local _props = self.props\
\9\9local _success, _valueOrError = pcall(_functionComponent, _props)\
\9\9local result = _success and {\
\9\9\9success = true,\
\9\9\9value = _valueOrError,\
\9\9} or {\
\9\9\9success = false,\
\9\9\9error = _valueOrError,\
\9\9}\
\9\9renderDone(self)\
\9\9if not result.success then\
\9\9\9error(\"(ComponentWithHooks) \" .. result.error)\
\9\9end\
\9\9return result.value\
\9end\
\9function ComponentWithHooks:didMount()\
\9\9self:flushEffects()\
\9end\
\9function ComponentWithHooks:didUpdate()\
\9\9self:flushEffects()\
\9end\
\9function ComponentWithHooks:willUnmount()\
\9\9self:unmountEffects()\
\9\9self.effects.head = nil\
\9end\
\9function ComponentWithHooks:flushEffectsHelper(effect)\
\9\9if not effect then\
\9\9\9return nil\
\9\9end\
\9\9local _effectHandles = self.effectHandles\
\9\9local _id = effect.id\
\9\9local _result = _effectHandles[_id]\
\9\9if _result ~= nil then\
\9\9\9_result()\
\9\9end\
\9\9local handle = effect.callback()\
\9\9if handle then\
\9\9\9local _effectHandles_1 = self.effectHandles\
\9\9\9local _id_1 = effect.id\
\9\9\9-- ▼ Map.set ▼\
\9\9\9_effectHandles_1[_id_1] = handle\
\9\9\9-- ▲ Map.set ▲\
\9\9else\
\9\9\9local _effectHandles_1 = self.effectHandles\
\9\9\9local _id_1 = effect.id\
\9\9\9-- ▼ Map.delete ▼\
\9\9\9_effectHandles_1[_id_1] = nil\
\9\9\9-- ▲ Map.delete ▲\
\9\9end\
\9\9self:flushEffectsHelper(effect.next)\
\9end\
\9function ComponentWithHooks:flushEffects()\
\9\9self:flushEffectsHelper(self.effects.head)\
\9\9self.effects.head = nil\
\9\9self.effects.tail = nil\
\9end\
\9function ComponentWithHooks:unmountEffects()\
\9\9-- This does not clean up effects by order of id, but it should not matter\
\9\9-- because this is on unmount\
\9\9local _effectHandles = self.effectHandles\
\9\9local _arg0 = function(handle)\
\9\9\9return handle()\
\9\9end\
\9\9-- ▼ ReadonlyMap.forEach ▼\
\9\9for _k, _v in pairs(_effectHandles) do\
\9\9\9_arg0(_v, _k, _effectHandles)\
\9\9end\
\9\9-- ▲ ReadonlyMap.forEach ▲\
\9\9-- ▼ Map.clear ▼\
\9\9table.clear(self.effectHandles)\
\9\9-- ▲ Map.clear ▲\
\9end\
end\
return {\
\9ComponentWithHooks = ComponentWithHooks,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.with-hooks.component-with-hooks")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.with-hooks.component-with-hooks")) return fn() end)

_module("with-hooks", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked.out.with-hooks.with-hooks", "RemoteSpy.include.node_modules.roact-hooked.out.with-hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.7\
local TS = _G[script]\
local ComponentWithHooks = TS.import(script, script.Parent, \"component-with-hooks\").ComponentWithHooks\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function componentWithHooksMixin(ctor)\
\9for k, v in pairs(ComponentWithHooks) do\
\9\9ctor[k] = v\
\9end\
end\
local function withHooks(functionComponent)\
\9local ComponentClass\
\9do\
\9\9ComponentClass = Roact.Component:extend(\"ComponentClass\")\
\9\9function ComponentClass:init()\
\9\9end\
\9\9ComponentClass.functionComponent = functionComponent\
\9end\
\9componentWithHooksMixin(ComponentClass)\
\9return ComponentClass\
end\
local function withHooksPure(functionComponent)\
\9local ComponentClass\
\9do\
\9\9ComponentClass = Roact.PureComponent:extend(\"ComponentClass\")\
\9\9function ComponentClass:init()\
\9\9end\
\9\9ComponentClass.functionComponent = functionComponent\
\9end\
\9componentWithHooksMixin(ComponentClass)\
\9return ComponentClass\
end\
return {\
\9withHooks = withHooks,\
\9withHooksPure = withHooksPure,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked.out.with-hooks.with-hooks")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked.out.with-hooks.with-hooks")) return fn() end)

_instance("roact-hooked-plus", "Folder", "RemoteSpy.include.node_modules.roact-hooked-plus", "RemoteSpy.include.node_modules")

_module("out", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out", "RemoteSpy.include.node_modules.roact-hooked-plus", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local exports = {}\
exports.arrayToMap = TS.import(script, script, \"utils\", \"array-to-map\").arrayToMap\
local _binding_utils = TS.import(script, script, \"utils\", \"binding-utils\")\
exports.asBinding = _binding_utils.asBinding\
exports.getBindingValue = _binding_utils.getBindingValue\
exports.isBinding = _binding_utils.isBinding\
exports.mapBinding = _binding_utils.mapBinding\
local _set_timeout = TS.import(script, script, \"utils\", \"set-timeout\")\
exports.Timeout = _set_timeout.Timeout\
exports.clearTimeout = _set_timeout.clearTimeout\
exports.setTimeout = _set_timeout.setTimeout\
local _set_interval = TS.import(script, script, \"utils\", \"set-interval\")\
exports.Interval = _set_interval.Interval\
exports.clearInterval = _set_interval.clearInterval\
exports.setInterval = _set_interval.setInterval\
local _flipper = TS.import(script, script, \"flipper\")\
exports.getBinding = _flipper.getBinding\
exports.useGoal = _flipper.useGoal\
exports.useInstant = _flipper.useInstant\
exports.useLinear = _flipper.useLinear\
exports.useMotor = _flipper.useMotor\
exports.useSpring = _flipper.useSpring\
exports.useAnimation = TS.import(script, script, \"use-animation\").useAnimation\
exports.useClickOutside = TS.import(script, script, \"use-click-outside\").useClickOutside\
exports.useDebouncedValue = TS.import(script, script, \"use-debounced-value\").useDebouncedValue\
exports.useDelayedEffect = TS.import(script, script, \"use-delayed-effect\").useDelayedEffect\
exports.useDelayedValue = TS.import(script, script, \"use-delayed-value\").useDelayedValue\
exports.useDidMount = TS.import(script, script, \"use-did-mount\").useDidMount\
exports.useEvent = TS.import(script, script, \"use-event\").useEvent\
exports.useForceUpdate = TS.import(script, script, \"use-force-update\").useForceUpdate\
exports.useGroupMotor = TS.import(script, script, \"use-group-motor\").useGroupMotor\
exports.useHotkeys = TS.import(script, script, \"use-hotkeys\").useHotkeys\
exports.useIdle = TS.import(script, script, \"use-idle\").useIdle\
exports.useInterval = TS.import(script, script, \"use-interval\").useInterval\
exports.useListState = TS.import(script, script, \"use-list-state\").useListState\
exports.useMouse = TS.import(script, script, \"use-mouse\").useMouse\
exports.usePromise = TS.import(script, script, \"use-promise\").usePromise\
exports.useSequenceCallback = TS.import(script, script, \"use-sequence-callback\").useSequenceCallback\
exports.useSequence = TS.import(script, script, \"use-sequence\").useSequence\
exports.useSetState = TS.import(script, script, \"use-set-state\").useSetState\
exports.useSingleMotor = TS.import(script, script, \"use-single-motor\").useSingleMotor\
exports.useToggle = TS.import(script, script, \"use-toggle\").useToggle\
exports.useViewportSize = TS.import(script, script, \"use-viewport-size\").useViewportSize\
return exports\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out")) return fn() end)

_module("flipper", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local exports = {}\
exports.getBinding = TS.import(script, script, \"get-binding\").getBinding\
exports.useGoal = TS.import(script, script, \"use-goal\").useGoal\
exports.useInstant = TS.import(script, script, \"use-instant\").useInstant\
exports.useLinear = TS.import(script, script, \"use-linear\").useLinear\
exports.useMotor = TS.import(script, script, \"use-motor\").useMotor\
exports.useSpring = TS.import(script, script, \"use-spring\").useSpring\
return exports\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper")) return fn() end)

_module("get-binding", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.get-binding", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local isMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).isMotor\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local AssignedBinding = setmetatable({}, {\
\9__tostring = function()\
\9\9return \"AssignedBinding\"\
\9end,\
})\
local function getBinding(motor)\
\9assert(motor, \"Missing argument #1: motor\")\
\9local _arg0 = isMotor(motor)\
\9assert(_arg0, \"Provided value is not a motor\")\
\9if motor[AssignedBinding] ~= nil then\
\9\9return motor[AssignedBinding]\
\9end\
\9local binding, setBindingValue = Roact.createBinding(motor:getValue())\
\9motor:onStep(setBindingValue)\
\9motor[AssignedBinding] = binding\
\9return binding\
end\
return {\
\9getBinding = getBinding,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.get-binding")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.get-binding")) return fn() end)

_module("use-goal", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-goal", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local getBinding = TS.import(script, script.Parent, \"get-binding\").getBinding\
local useMotor = TS.import(script, script.Parent, \"use-motor\").useMotor\
local function useGoal(goal)\
\9local motor = useMotor(goal._targetValue)\
\9motor:setGoal(goal)\
\9return getBinding(motor)\
end\
return {\
\9useGoal = useGoal,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-goal")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-goal")) return fn() end)

_module("use-instant", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-instant", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local Instant = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).Instant\
local useGoal = TS.import(script, script.Parent, \"use-goal\").useGoal\
local function useInstant(targetValue)\
\9return useGoal(Instant.new(targetValue))\
end\
return {\
\9useInstant = useInstant,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-instant")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-instant")) return fn() end)

_module("use-linear", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-linear", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local Linear = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).Linear\
local useGoal = TS.import(script, script.Parent, \"use-goal\").useGoal\
local function useLinear(targetValue, options)\
\9return useGoal(Linear.new(targetValue, options))\
end\
return {\
\9useLinear = useLinear,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-linear")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-linear")) return fn() end)

_module("use-motor", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-motor", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _flipper = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src)\
local GroupMotor = _flipper.GroupMotor\
local SingleMotor = _flipper.SingleMotor\
local useMemo = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useMemo\
local function createMotor(initialValue)\
\9if type(initialValue) == \"number\" then\
\9\9return SingleMotor.new(initialValue)\
\9elseif type(initialValue) == \"table\" then\
\9\9return GroupMotor.new(initialValue)\
\9else\
\9\9error(\"Invalid type for initialValue. Expected 'number' or 'table', got '\" .. (tostring(initialValue) .. \"'\"))\
\9end\
end\
local function useMotor(initialValue)\
\9return useMemo(function()\
\9\9return createMotor(initialValue)\
\9end, {})\
end\
return {\
\9useMotor = useMotor,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-motor")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-motor")) return fn() end)

_module("use-spring", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-spring", "RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local Spring = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).Spring\
local useGoal = TS.import(script, script.Parent, \"use-goal\").useGoal\
local function useSpring(targetValue, options)\
\9return useGoal(Spring.new(targetValue, options))\
end\
return {\
\9useSpring = useSpring,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-spring")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.flipper.use-spring")) return fn() end)

_module("use-animation", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-animation", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local Spring = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).Spring\
local _flipper = TS.import(script, script.Parent, \"flipper\")\
local getBinding = _flipper.getBinding\
local useMotor = _flipper.useMotor\
local _object = {}\
local _left = \"number\"\
local _arg0 = function(value, ctor, options)\
\9if options == nil then\
\9\9options = {}\
\9end\
\9local motor = useMotor(value)\
\9motor:setGoal(ctor.new(value, options))\
\9return getBinding(motor)\
end\
_object[_left] = _arg0\
local _left_1 = \"Color3\"\
local _arg0_1 = function(color, ctor, options)\
\9if options == nil then\
\9\9options = {}\
\9end\
\9local motor = useMotor({ color.R, color.G, color.B })\
\9motor:setGoal({ ctor.new(color.R, options), ctor.new(color.G, options), ctor.new(color.B, options) })\
\9return getBinding(motor):map(function(_param)\
\9\9local r = _param[1]\
\9\9local g = _param[2]\
\9\9local b = _param[3]\
\9\9return Color3.new(r, g, b)\
\9end)\
end\
_object[_left_1] = _arg0_1\
local _left_2 = \"UDim\"\
local _arg0_2 = function(udim, ctor, options)\
\9local motor = useMotor({ udim.Scale, udim.Offset })\
\9motor:setGoal({ ctor.new(udim.Scale, options), ctor.new(udim.Offset, options) })\
\9return getBinding(motor):map(function(_param)\
\9\9local s = _param[1]\
\9\9local o = _param[2]\
\9\9return UDim.new(s, o)\
\9end)\
end\
_object[_left_2] = _arg0_2\
local _left_3 = \"UDim2\"\
local _arg0_3 = function(udim2, ctor, options)\
\9local motor = useMotor({ udim2.X.Scale, udim2.X.Offset, udim2.Y.Scale, udim2.Y.Offset })\
\9motor:setGoal({ ctor.new(udim2.X.Scale, options), ctor.new(udim2.X.Offset, options), ctor.new(udim2.Y.Scale, options), ctor.new(udim2.Y.Offset, options) })\
\9return getBinding(motor):map(function(_param)\
\9\9local xS = _param[1]\
\9\9local xO = _param[2]\
\9\9local yS = _param[3]\
\9\9local yO = _param[4]\
\9\9return UDim2.new(xS, math.round(xO), yS, math.round(yO))\
\9end)\
end\
_object[_left_3] = _arg0_3\
local _left_4 = \"Vector2\"\
local _arg0_4 = function(vector2, ctor, options)\
\9local motor = useMotor({ vector2.X, vector2.Y })\
\9motor:setGoal({ ctor.new(vector2.X, options), ctor.new(vector2.Y, options) })\
\9return getBinding(motor):map(function(_param)\
\9\9local X = _param[1]\
\9\9local Y = _param[2]\
\9\9return Vector2.new(X, Y)\
\9end)\
end\
_object[_left_4] = _arg0_4\
local _left_5 = \"table\"\
local _arg0_5 = function(array, ctor, options)\
\9local motor = useMotor(array)\
\9local _fn = motor\
\9local _arg0_6 = function(value)\
\9\9return ctor.new(value, options)\
\9end\
\9-- ▼ ReadonlyArray.map ▼\
\9local _newValue = table.create(#array)\
\9for _k, _v in ipairs(array) do\
\9\9_newValue[_k] = _arg0_6(_v, _k - 1, array)\
\9end\
\9-- ▲ ReadonlyArray.map ▲\
\9_fn:setGoal(_newValue)\
\9return getBinding(motor)\
end\
_object[_left_5] = _arg0_5\
local motorHooks = _object\
local function useAnimation(value, ctor, options)\
\9local hook = motorHooks[typeof(value)]\
\9local _arg1 = \"useAnimation: Value of type \" .. (typeof(value) .. \" is not supported\")\
\9assert(hook, _arg1)\
\9return hook(value, (ctor or Spring), options)\
end\
return {\
\9useAnimation = useAnimation,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-animation")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-animation")) return fn() end)

_module("use-click-outside", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-click-outside", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useRef = _roact_hooked.useRef\
local UserInputService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).UserInputService\
local DEFAULT_INPUTS = { Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch }\
local function contains(object, mouse)\
\9return object.AbsolutePosition.X <= mouse.X and (object.AbsolutePosition.Y <= mouse.Y and (object.AbsolutePosition.X + object.AbsoluteSize.X >= mouse.X and object.AbsolutePosition.Y + object.AbsoluteSize.Y >= mouse.Y))\
end\
--[[\
\9*\
\9* @see https://mantine.dev/hooks/use-click-outside/\
]]\
local function useClickOutside(handler, inputs, instances)\
\9if inputs == nil then\
\9\9inputs = DEFAULT_INPUTS\
\9end\
\9local ref = useRef()\
\9useEffect(function()\
\9\9local listener = function(input)\
\9\9\9local instance = ref:getValue()\
\9\9\9if type(instances) == \"table\" then\
\9\9\9\9local _arg0 = function(obj)\
\9\9\9\9\9return obj ~= nil and not contains(obj, input.Position)\
\9\9\9\9end\
\9\9\9\9-- ▼ ReadonlyArray.every ▼\
\9\9\9\9local _result = true\
\9\9\9\9for _k, _v in ipairs(instances) do\
\9\9\9\9\9if not _arg0(_v, _k - 1, instances) then\
\9\9\9\9\9\9_result = false\
\9\9\9\9\9\9break\
\9\9\9\9\9end\
\9\9\9\9end\
\9\9\9\9-- ▲ ReadonlyArray.every ▲\
\9\9\9\9local shouldTrigger = _result\
\9\9\9\9if shouldTrigger then\
\9\9\9\9\9handler()\
\9\9\9\9end\
\9\9\9elseif instance ~= nil and not contains(instance, input.Position) then\
\9\9\9\9handler()\
\9\9\9end\
\9\9end\
\9\9local handle = UserInputService.InputBegan:Connect(function(input)\
\9\9\9local _userInputType = input.UserInputType\
\9\9\9if table.find(inputs, _userInputType) ~= nil then\
\9\9\9\9listener(input)\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9handle:Disconnect()\
\9\9end\
\9end, { ref, handler, instances })\
\9return ref\
end\
return {\
\9useClickOutside = useClickOutside,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-click-outside")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-click-outside")) return fn() end)

_module("use-debounced-value", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-debounced-value", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useMutable = _roact_hooked.useMutable\
local useState = _roact_hooked.useState\
local _set_timeout = TS.import(script, script.Parent, \"utils\", \"set-timeout\")\
local clearTimeout = _set_timeout.clearTimeout\
local setTimeout = _set_timeout.setTimeout\
--[[\
\9*\
\9* @see https://mantine.dev/hooks/use-debounced-value/\
]]\
local function useDebouncedValue(value, wait, options)\
\9if options == nil then\
\9\9options = {\
\9\9\9leading = false,\
\9\9}\
\9end\
\9local _binding = useState(value)\
\9local _value = _binding[1]\
\9local setValue = _binding[2]\
\9local mountedRef = useMutable(false)\
\9local timeoutRef = useMutable(nil)\
\9local cooldownRef = useMutable(false)\
\9local cancel = function()\
\9\9return clearTimeout(timeoutRef.current)\
\9end\
\9useEffect(function()\
\9\9if mountedRef.current then\
\9\9\9if not cooldownRef.current and options.leading then\
\9\9\9\9cooldownRef.current = true\
\9\9\9\9setValue(value)\
\9\9\9else\
\9\9\9\9cancel()\
\9\9\9\9timeoutRef.current = setTimeout(function()\
\9\9\9\9\9cooldownRef.current = false\
\9\9\9\9\9setValue(value)\
\9\9\9\9end, wait)\
\9\9\9end\
\9\9end\
\9end, { value, options.leading })\
\9useEffect(function()\
\9\9mountedRef.current = true\
\9\9return cancel\
\9end, {})\
\9return { _value, cancel }\
end\
return {\
\9useDebouncedValue = useDebouncedValue,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-debounced-value")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-debounced-value")) return fn() end)

_module("use-delayed-effect", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-delayed-effect", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local setTimeout = TS.import(script, script.Parent, \"utils\", \"set-timeout\").setTimeout\
local clearUpdates = TS.import(script, script.Parent, \"use-delayed-value\").clearUpdates\
local nextId = 0\
local function useDelayedEffect(effect, delayMs, deps)\
\9local updates = useMemo(function()\
\9\9return {}\
\9end, {})\
\9useEffect(function()\
\9\9local _original = nextId\
\9\9nextId += 1\
\9\9local id = _original\
\9\9local update = {\
\9\9\9timeout = setTimeout(function()\
\9\9\9\9effect()\
\9\9\9\9updates[id] = nil\
\9\9\9end, delayMs),\
\9\9\9resolveTime = os.clock() + delayMs,\
\9\9}\
\9\9-- Clear all updates that are later than the current one to prevent overlap\
\9\9clearUpdates(updates, update.resolveTime)\
\9\9updates[id] = update\
\9end, deps)\
\9useEffect(function()\
\9\9return function()\
\9\9\9return clearUpdates(updates)\
\9\9end\
\9end, {})\
end\
return {\
\9useDelayedEffect = useDelayedEffect,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-delayed-effect")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-delayed-effect")) return fn() end)

_module("use-delayed-value", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-delayed-value", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local useState = _roact_hooked.useState\
local _set_timeout = TS.import(script, script.Parent, \"utils\", \"set-timeout\")\
local clearTimeout = _set_timeout.clearTimeout\
local setTimeout = _set_timeout.setTimeout\
local function clearUpdates(updates, laterThan)\
\9for id, update in pairs(updates) do\
\9\9if laterThan == nil or update.resolveTime >= laterThan then\
\9\9\9updates[id] = nil\
\9\9\9clearTimeout(update.timeout)\
\9\9end\
\9end\
end\
local nextId = 0\
local function useDelayedValue(value, delayMs)\
\9local _binding = useState(value)\
\9local delayedValue = _binding[1]\
\9local setDelayedValue = _binding[2]\
\9local updates = useMemo(function()\
\9\9return {}\
\9end, {})\
\9useEffect(function()\
\9\9local _original = nextId\
\9\9nextId += 1\
\9\9local id = _original\
\9\9local update = {\
\9\9\9timeout = setTimeout(function()\
\9\9\9\9setDelayedValue(value)\
\9\9\9\9updates[id] = nil\
\9\9\9end, delayMs),\
\9\9\9resolveTime = os.clock() + delayMs,\
\9\9}\
\9\9-- Clear all updates that are later than the current one to prevent overlap\
\9\9clearUpdates(updates, update.resolveTime)\
\9\9updates[id] = update\
\9end, { value })\
\9useEffect(function()\
\9\9return function()\
\9\9\9return clearUpdates(updates)\
\9\9end\
\9end, {})\
\9return delayedValue\
end\
return {\
\9clearUpdates = clearUpdates,\
\9useDelayedValue = useDelayedValue,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-delayed-value")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-delayed-value")) return fn() end)

_module("use-did-mount", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-did-mount", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useMutable = _roact_hooked.useMutable\
local function useDidMount()\
\9local ref = useMutable(true)\
\9useEffect(function()\
\9\9ref.current = false\
\9end, {})\
\9return ref.current\
end\
return {\
\9useDidMount = useDidMount,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-did-mount")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-did-mount")) return fn() end)

_module("use-event", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-event", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local useEffect = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useEffect\
local function useEvent(event, callback, deps)\
\9if deps == nil then\
\9\9deps = {}\
\9end\
\9useEffect(function()\
\9\9local handle = event:Connect(callback)\
\9\9return function()\
\9\9\9return handle:Disconnect()\
\9\9end\
\9end, deps)\
end\
return {\
\9useEvent = useEvent,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-event")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-event")) return fn() end)

_module("use-force-update", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-force-update", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local useReducer = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useReducer\
local reducer = function(value)\
\9return (value + 1) % 1000000\
end\
local function useForceUpdate()\
\9local _binding = useReducer(reducer, 0)\
\9local update = _binding[2]\
\9return update\
end\
return {\
\9useForceUpdate = useForceUpdate,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-force-update")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-force-update")) return fn() end)

_module("use-group-motor", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-group-motor", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local GroupMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).GroupMotor\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useBinding = _roact_hooked.useBinding\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local function useGroupMotor(initialValue)\
\9local motor = useMemo(function()\
\9\9return GroupMotor.new(initialValue)\
\9end, {})\
\9local _binding = useBinding(motor:getValue())\
\9local binding = _binding[1]\
\9local setBinding = _binding[2]\
\9useEffect(function()\
\9\9motor:onStep(setBinding)\
\9end, {})\
\9local setGoal = function(goal)\
\9\9motor:setGoal(goal)\
\9end\
\9return { binding, setGoal, motor }\
end\
return {\
\9useGroupMotor = useGroupMotor,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-group-motor")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-group-motor")) return fn() end)

_module("use-hotkeys", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-hotkeys", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local useEffect = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useEffect\
local UserInputService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).UserInputService\
local function isHotkeyPressed(hotkey)\
\9local _exp = UserInputService:GetKeysPressed()\
\9local _arg0 = function(key)\
\9\9return key.KeyCode\
\9end\
\9-- ▼ ReadonlyArray.map ▼\
\9local _newValue = table.create(#_exp)\
\9for _k, _v in ipairs(_exp) do\
\9\9_newValue[_k] = _arg0(_v, _k - 1, _exp)\
\9end\
\9-- ▲ ReadonlyArray.map ▲\
\9local keysDown = _newValue\
\9local _arg0_1 = function(key)\
\9\9if type(key) == \"string\" then\
\9\9\9local _arg0_2 = Enum.KeyCode[key]\
\9\9\9return table.find(keysDown, _arg0_2) ~= nil\
\9\9else\
\9\9\9return table.find(keysDown, key) ~= nil\
\9\9end\
\9end\
\9-- ▼ ReadonlyArray.every ▼\
\9local _result = true\
\9for _k, _v in ipairs(hotkey) do\
\9\9if not _arg0_1(_v, _k - 1, hotkey) then\
\9\9\9_result = false\
\9\9\9break\
\9\9end\
\9end\
\9-- ▲ ReadonlyArray.every ▲\
\9return _result\
end\
local function useHotkeys(hotkeys)\
\9useEffect(function()\
\9\9local handle = UserInputService.InputBegan:Connect(function(input, gameProcessed)\
\9\9\9if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then\
\9\9\9\9local _arg0 = function(_param)\
\9\9\9\9\9local hotkey = _param[1]\
\9\9\9\9\9local event = _param[2]\
\9\9\9\9\9local _name = input.KeyCode.Name\
\9\9\9\9\9local _condition = table.find(hotkey, _name) ~= nil\
\9\9\9\9\9if _condition then\
\9\9\9\9\9\9_condition = isHotkeyPressed(hotkey)\
\9\9\9\9\9end\
\9\9\9\9\9if _condition then\
\9\9\9\9\9\9event()\
\9\9\9\9\9end\
\9\9\9\9end\
\9\9\9\9for _k, _v in ipairs(hotkeys) do\
\9\9\9\9\9_arg0(_v, _k - 1, hotkeys)\
\9\9\9\9end\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9handle:Disconnect()\
\9\9end\
\9end, { hotkeys })\
end\
return {\
\9useHotkeys = useHotkeys,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-hotkeys")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-hotkeys")) return fn() end)

_module("use-idle", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-idle", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useCallback = _roact_hooked.useCallback\
local useEffect = _roact_hooked.useEffect\
local useMutable = _roact_hooked.useMutable\
local useState = _roact_hooked.useState\
local UserInputService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).UserInputService\
local _set_timeout = TS.import(script, script.Parent, \"utils\", \"set-timeout\")\
local clearTimeout = _set_timeout.clearTimeout\
local setTimeout = _set_timeout.setTimeout\
local DEFAULT_INPUTS = { Enum.UserInputType.Keyboard, Enum.UserInputType.Touch, Enum.UserInputType.Gamepad1, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3 }\
local DEFAULT_OPTIONS = {\
\9inputs = DEFAULT_INPUTS,\
\9useWindowFocus = true,\
\9initialState = true,\
}\
local function useIdle(timeout, options)\
\9local _object = {}\
\9for _k, _v in pairs(DEFAULT_OPTIONS) do\
\9\9_object[_k] = _v\
\9end\
\9if type(options) == \"table\" then\
\9\9for _k, _v in pairs(options) do\
\9\9\9_object[_k] = _v\
\9\9end\
\9end\
\9local _binding = _object\
\9local inputs = _binding.inputs\
\9local useWindowFocus = _binding.useWindowFocus\
\9local initialState = _binding.initialState\
\9local _binding_1 = useState(initialState)\
\9local idle = _binding_1[1]\
\9local setIdle = _binding_1[2]\
\9local timer = useMutable()\
\9local handleInput = useCallback(function()\
\9\9setIdle(false)\
\9\9if timer.current then\
\9\9\9clearTimeout(timer.current)\
\9\9end\
\9\9timer.current = setTimeout(function()\
\9\9\9setIdle(true)\
\9\9end, timeout)\
\9end, { timeout })\
\9useEffect(function()\
\9\9local events = UserInputService.InputBegan:Connect(function(input)\
\9\9\9local _userInputType = input.UserInputType\
\9\9\9if table.find(inputs, _userInputType) ~= nil then\
\9\9\9\9handleInput()\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9events:Disconnect()\
\9\9end\
\9end, { handleInput })\
\9useEffect(function()\
\9\9if not useWindowFocus then\
\9\9\9return nil\
\9\9end\
\9\9local windowFocused = UserInputService.WindowFocused:Connect(handleInput)\
\9\9local windowFocusReleased = UserInputService.WindowFocusReleased:Connect(function()\
\9\9\9if timer.current then\
\9\9\9\9clearTimeout(timer.current)\
\9\9\9\9timer.current = nil\
\9\9\9end\
\9\9\9setIdle(true)\
\9\9end)\
\9\9return function()\
\9\9\9windowFocused:Disconnect()\
\9\9\9windowFocusReleased:Disconnect()\
\9\9end\
\9end, { useWindowFocus, handleInput })\
\9return idle\
end\
return {\
\9useIdle = useIdle,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-idle")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-idle")) return fn() end)

_module("use-interval", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-interval", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useMutable = _roact_hooked.useMutable\
local useState = _roact_hooked.useState\
local _set_interval = TS.import(script, script.Parent, \"utils\", \"set-interval\")\
local clearInterval = _set_interval.clearInterval\
local setInterval = _set_interval.setInterval\
--[[\
\9*\
\9* @see https://mantine.dev/hooks/use-interval/\
]]\
local function useInterval(fn, intervalMs)\
\9local _binding = useState(false)\
\9local active = _binding[1]\
\9local setActive = _binding[2]\
\9local intervalRef = useMutable()\
\9local start = function()\
\9\9if not active then\
\9\9\9setActive(true)\
\9\9\9intervalRef.current = setInterval(fn, intervalMs)\
\9\9end\
\9end\
\9local stop = function()\
\9\9setActive(false)\
\9\9clearInterval(intervalRef.current)\
\9end\
\9local toggle = function()\
\9\9if active then\
\9\9\9stop()\
\9\9else\
\9\9\9start()\
\9\9end\
\9end\
\9return {\
\9\9start = start,\
\9\9stop = stop,\
\9\9toggle = toggle,\
\9\9active = active,\
\9}\
end\
return {\
\9useInterval = useInterval,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-interval")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-interval")) return fn() end)

_module("use-list-state", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-list-state", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local useState = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useState\
local function slice(array, start, finish)\
\9if start == nil then\
\9\9start = 0\
\9end\
\9if finish == nil then\
\9\9finish = math.huge\
\9end\
\9local _arg0 = function(_, index)\
\9\9return index >= start and index < finish\
\9end\
\9-- ▼ ReadonlyArray.filter ▼\
\9local _newValue = {}\
\9local _length = 0\
\9for _k, _v in ipairs(array) do\
\9\9if _arg0(_v, _k - 1, array) == true then\
\9\9\9_length += 1\
\9\9\9_newValue[_length] = _v\
\9\9end\
\9end\
\9-- ▲ ReadonlyArray.filter ▲\
\9return _newValue\
end\
--[[\
\9*\
\9* @see https://mantine.dev/hooks/use-list-state/\
]]\
local function useListState(initialValue)\
\9if initialValue == nil then\
\9\9initialValue = {}\
\9end\
\9local _binding = useState(initialValue)\
\9local state = _binding[1]\
\9local setState = _binding[2]\
\9local append = function(...)\
\9\9local items = { ... }\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9local _currentLength = #current\
\9\9\9table.move(current, 1, _currentLength, _length + 1, _array)\
\9\9\9_length += _currentLength\
\9\9\9table.move(items, 1, #items, _length + 1, _array)\
\9\9\9return _array\
\9\9end)\
\9end\
\9local prepend = function(...)\
\9\9local items = { ... }\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9local _itemsLength = #items\
\9\9\9table.move(items, 1, _itemsLength, _length + 1, _array)\
\9\9\9_length += _itemsLength\
\9\9\9table.move(current, 1, #current, _length + 1, _array)\
\9\9\9return _array\
\9\9end)\
\9end\
\9local insert = function(index, ...)\
\9\9local items = { ... }\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9local _array_1 = slice(current, 0, index)\
\9\9\9local _Length = #_array_1\
\9\9\9table.move(_array_1, 1, _Length, _length + 1, _array)\
\9\9\9_length += _Length\
\9\9\9local _itemsLength = #items\
\9\9\9table.move(items, 1, _itemsLength, _length + 1, _array)\
\9\9\9_length += _itemsLength\
\9\9\9local _array_2 = slice(current, index)\
\9\9\9table.move(_array_2, 1, #_array_2, _length + 1, _array)\
\9\9\9return _array\
\9\9end)\
\9end\
\9local apply = function(fn)\
\9\9return setState(function(current)\
\9\9\9local _arg0 = function(item, index)\
\9\9\9\9return fn(item, index)\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.map ▼\
\9\9\9local _newValue = table.create(#current)\
\9\9\9for _k, _v in ipairs(current) do\
\9\9\9\9_newValue[_k] = _arg0(_v, _k - 1, current)\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.map ▲\
\9\9\9return _newValue\
\9\9end)\
\9end\
\9local remove = function(...)\
\9\9local indices = { ... }\
\9\9return setState(function(current)\
\9\9\9local _arg0 = function(_, index)\
\9\9\9\9return not (table.find(indices, index) ~= nil)\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.filter ▼\
\9\9\9local _newValue = {}\
\9\9\9local _length = 0\
\9\9\9for _k, _v in ipairs(current) do\
\9\9\9\9if _arg0(_v, _k - 1, current) == true then\
\9\9\9\9\9_length += 1\
\9\9\9\9\9_newValue[_length] = _v\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.filter ▲\
\9\9\9return _newValue\
\9\9end)\
\9end\
\9local pop = function()\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9table.move(current, 1, #current, _length + 1, _array)\
\9\9\9local cloned = _array\
\9\9\9cloned[#cloned] = nil\
\9\9\9return cloned\
\9\9end)\
\9end\
\9local shift = function()\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9table.move(current, 1, #current, _length + 1, _array)\
\9\9\9local cloned = _array\
\9\9\9table.remove(cloned, 1)\
\9\9\9return cloned\
\9\9end)\
\9end\
\9local reorder = function(_param)\
\9\9local from = _param.from\
\9\9local to = _param.to\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9table.move(current, 1, #current, _length + 1, _array)\
\9\9\9local cloned = _array\
\9\9\9local item = table.remove(cloned, from + 1)\
\9\9\9if item ~= nil then\
\9\9\9\9table.insert(cloned, to + 1, item)\
\9\9\9end\
\9\9\9return cloned\
\9\9end)\
\9end\
\9local setItem = function(index, item)\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9table.move(current, 1, #current, _length + 1, _array)\
\9\9\9local cloned = _array\
\9\9\9cloned[index + 1] = item\
\9\9\9return cloned\
\9\9end)\
\9end\
\9local setItemProp = function(index, prop, value)\
\9\9return setState(function(current)\
\9\9\9local _array = {}\
\9\9\9local _length = #_array\
\9\9\9table.move(current, 1, #current, _length + 1, _array)\
\9\9\9local cloned = _array\
\9\9\9local _object = {}\
\9\9\9local _spread = cloned[index + 1]\
\9\9\9if type(_spread) == \"table\" then\
\9\9\9\9for _k, _v in pairs(_spread) do\
\9\9\9\9\9_object[_k] = _v\
\9\9\9\9end\
\9\9\9end\
\9\9\9_object[prop] = value\
\9\9\9cloned[index + 1] = _object\
\9\9\9return cloned\
\9\9end)\
\9end\
\9local applyWhere = function(condition, fn)\
\9\9return setState(function(current)\
\9\9\9local _arg0 = function(item, index)\
\9\9\9\9if condition(item, index) then\
\9\9\9\9\9return fn(item, index)\
\9\9\9\9else\
\9\9\9\9\9return item\
\9\9\9\9end\
\9\9\9end\
\9\9\9-- ▼ ReadonlyArray.map ▼\
\9\9\9local _newValue = table.create(#current)\
\9\9\9for _k, _v in ipairs(current) do\
\9\9\9\9_newValue[_k] = _arg0(_v, _k - 1, current)\
\9\9\9end\
\9\9\9-- ▲ ReadonlyArray.map ▲\
\9\9\9return _newValue\
\9\9end)\
\9end\
\9return { state, {\
\9\9setState = setState,\
\9\9append = append,\
\9\9prepend = prepend,\
\9\9insert = insert,\
\9\9pop = pop,\
\9\9shift = shift,\
\9\9apply = apply,\
\9\9applyWhere = applyWhere,\
\9\9remove = remove,\
\9\9reorder = reorder,\
\9\9setItem = setItem,\
\9\9setItemProp = setItemProp,\
\9} }\
end\
return {\
\9slice = slice,\
\9useListState = useListState,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-list-state")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-list-state")) return fn() end)

_module("use-mouse", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-mouse", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useBinding = _roact_hooked.useBinding\
local useEffect = _roact_hooked.useEffect\
local UserInputService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).UserInputService\
local function useMouse(onChange)\
\9local _binding = useBinding(UserInputService:GetMouseLocation())\
\9local location = _binding[1]\
\9local setLocation = _binding[2]\
\9useEffect(function()\
\9\9local handle = UserInputService.InputChanged:Connect(function(input)\
\9\9\9if input.UserInputType == Enum.UserInputType.MouseMovement then\
\9\9\9\9local location = UserInputService:GetMouseLocation()\
\9\9\9\9setLocation(location)\
\9\9\9\9local _result = onChange\
\9\9\9\9if _result ~= nil then\
\9\9\9\9\9_result(location)\
\9\9\9\9end\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9handle:Disconnect()\
\9\9end\
\9end, {})\
\9return location\
end\
return {\
\9useMouse = useMouse,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-mouse")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-mouse")) return fn() end)

_module("use-promise", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-promise", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useReducer = _roact_hooked.useReducer\
-- https://github.com/bsonntag/react-use-promise\
local function resolvePromise(promise)\
\9if type(promise) == \"function\" then\
\9\9return promise()\
\9end\
\9return promise\
end\
local states = {\
\9pending = \"pending\",\
\9rejected = \"rejected\",\
\9resolved = \"resolved\",\
}\
local defaultState = {\
\9err = nil,\
\9result = nil,\
\9state = states.pending,\
}\
local function reducer(state, action)\
\9local _exp = action.type\
\9repeat\
\9\9if _exp == (states.pending) then\
\9\9\9return defaultState\
\9\9end\
\9\9if _exp == (states.resolved) then\
\9\9\9return {\
\9\9\9\9err = nil,\
\9\9\9\9result = action.payload,\
\9\9\9\9state = states.resolved,\
\9\9\9}\
\9\9end\
\9\9if _exp == (states.rejected) then\
\9\9\9return {\
\9\9\9\9err = action.payload,\
\9\9\9\9result = nil,\
\9\9\9\9state = states.rejected,\
\9\9\9}\
\9\9end\
\9\9return state\
\9until true\
end\
local function usePromise(promise, deps)\
\9if deps == nil then\
\9\9deps = {}\
\9end\
\9local _binding = useReducer(reducer, defaultState)\
\9local _binding_1 = _binding[1]\
\9local err = _binding_1.err\
\9local result = _binding_1.result\
\9local state = _binding_1.state\
\9local dispatch = _binding[2]\
\9useEffect(function()\
\9\9promise = resolvePromise(promise)\
\9\9if not promise then\
\9\9\9return nil\
\9\9end\
\9\9local canceled = false\
\9\9dispatch({\
\9\9\9type = states.pending,\
\9\9})\
\9\9local _arg0 = function(result)\
\9\9\9return not canceled and dispatch({\
\9\9\9\9payload = result,\
\9\9\9\9type = states.resolved,\
\9\9\9})\
\9\9end\
\9\9local _arg1 = function(err)\
\9\9\9return not canceled and dispatch({\
\9\9\9\9payload = err,\
\9\9\9\9type = states.rejected,\
\9\9\9})\
\9\9end\
\9\9promise:andThen(_arg0, _arg1)\
\9\9return function()\
\9\9\9canceled = true\
\9\9end\
\9end, deps)\
\9return { result, err, state }\
end\
return {\
\9usePromise = usePromise,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-promise")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-promise")) return fn() end)

_module("use-sequence-callback", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-sequence-callback", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local useMutable = _roact_hooked.useMutable\
local useDidMount = TS.import(script, script.Parent, \"use-did-mount\").useDidMount\
local resolve = TS.import(script, script.Parent, \"utils\", \"resolve\").resolve\
local _set_timeout = TS.import(script, script.Parent, \"utils\", \"set-timeout\")\
local clearTimeout = _set_timeout.clearTimeout\
local setTimeout = _set_timeout.setTimeout\
local function useSequenceCallback(sequence, onUpdate, deps)\
\9if deps == nil then\
\9\9deps = {}\
\9end\
\9local updates = useMemo(function()\
\9\9return resolve(sequence.updates)\
\9end, deps)\
\9local callback = useMutable(onUpdate)\
\9callback.current = onUpdate\
\9local didMount = useDidMount()\
\9useEffect(function()\
\9\9if didMount and sequence.ignoreMount then\
\9\9\9return nil\
\9\9end\
\9\9local timeout\
\9\9local index = 0\
\9\9local runNext\
\9\9runNext = function()\
\9\9\9if index < #updates then\
\9\9\9\9local _binding = updates[index + 1]\
\9\9\9\9local delay = _binding[1]\
\9\9\9\9local func = _binding[2]\
\9\9\9\9timeout = setTimeout(function()\
\9\9\9\9\9callback.current(func())\
\9\9\9\9\9runNext()\
\9\9\9\9end, delay)\
\9\9\9\9index += 1\
\9\9\9end\
\9\9end\
\9\9runNext()\
\9\9return function()\
\9\9\9return clearTimeout(timeout)\
\9\9end\
\9end, { updates, didMount })\
end\
return {\
\9useSequenceCallback = useSequenceCallback,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-sequence-callback")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-sequence-callback")) return fn() end)

_module("use-sequence", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-sequence", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local useState = _roact_hooked.useState\
local useDidMount = TS.import(script, script.Parent, \"use-did-mount\").useDidMount\
local resolve = TS.import(script, script.Parent, \"utils\", \"resolve\").resolve\
local _set_timeout = TS.import(script, script.Parent, \"utils\", \"set-timeout\")\
local clearTimeout = _set_timeout.clearTimeout\
local setTimeout = _set_timeout.setTimeout\
local function useSequence(sequence, deps)\
\9if deps == nil then\
\9\9deps = {}\
\9end\
\9local _binding = useState(sequence.initialState)\
\9local state = _binding[1]\
\9local setState = _binding[2]\
\9local updates = useMemo(function()\
\9\9return resolve(sequence.updates)\
\9end, deps)\
\9local didMount = useDidMount()\
\9useEffect(function()\
\9\9if didMount and sequence.ignoreMount then\
\9\9\9return nil\
\9\9end\
\9\9local timeout\
\9\9local index = 0\
\9\9local runNext\
\9\9runNext = function()\
\9\9\9if index < #updates then\
\9\9\9\9local _binding_1 = updates[index + 1]\
\9\9\9\9local delay = _binding_1[1]\
\9\9\9\9local func = _binding_1[2]\
\9\9\9\9timeout = setTimeout(function()\
\9\9\9\9\9setState(func())\
\9\9\9\9\9runNext()\
\9\9\9\9end, delay)\
\9\9\9\9index += 1\
\9\9\9end\
\9\9end\
\9\9runNext()\
\9\9return function()\
\9\9\9return clearTimeout(timeout)\
\9\9end\
\9end, { updates, didMount })\
\9return state\
end\
return {\
\9useSequence = useSequence,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-sequence")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-sequence")) return fn() end)

_module("use-set-state", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-set-state", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local useState = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useState\
local resolve = TS.import(script, script.Parent, \"utils\", \"resolve\").resolve\
--[[\
\9*\
\9* @see https://mantine.dev/hooks/use-set-state/\
]]\
local function useSetState(initialState)\
\9local _binding = useState(initialState)\
\9local state = _binding[1]\
\9local _setState = _binding[2]\
\9local setState = function(statePartial)\
\9\9return _setState(function(current)\
\9\9\9local _object = {}\
\9\9\9for _k, _v in pairs(current) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9for _k, _v in pairs(resolve(statePartial, current)) do\
\9\9\9\9_object[_k] = _v\
\9\9\9end\
\9\9\9return _object\
\9\9end)\
\9end\
\9return { state, setState }\
end\
return {\
\9useSetState = useSetState,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-set-state")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-set-state")) return fn() end)

_module("use-single-motor", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-single-motor", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local SingleMotor = TS.import(script, TS.getModule(script, \"@rbxts\", \"flipper\").src).SingleMotor\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useBinding = _roact_hooked.useBinding\
local useEffect = _roact_hooked.useEffect\
local useMemo = _roact_hooked.useMemo\
local function useSingleMotor(initialValue)\
\9local motor = useMemo(function()\
\9\9return SingleMotor.new(initialValue)\
\9end, {})\
\9local _binding = useBinding(motor:getValue())\
\9local binding = _binding[1]\
\9local setBinding = _binding[2]\
\9useEffect(function()\
\9\9motor:onStep(setBinding)\
\9end, {})\
\9local setGoal = function(goal)\
\9\9motor:setGoal(goal)\
\9end\
\9return { binding, setGoal, motor }\
end\
return {\
\9useSingleMotor = useSingleMotor,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-single-motor")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-single-motor")) return fn() end)

_module("use-toggle", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-toggle", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local useState = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useState\
--[[\
\9*\
\9* @see https://mantine.dev/hooks/use-toggle/\
]]\
local function useToggle(initialValue, options)\
\9local _binding = useState(initialValue)\
\9local state = _binding[1]\
\9local setState = _binding[2]\
\9local toggle = function(value)\
\9\9if value ~= nil then\
\9\9\9setState(value)\
\9\9else\
\9\9\9setState(function(current)\
\9\9\9\9if current == options[1] then\
\9\9\9\9\9return options[2]\
\9\9\9\9end\
\9\9\9\9return options[1]\
\9\9\9end)\
\9\9end\
\9end\
\9return { state, toggle }\
end\
--[[\
\9*\
\9* @see https://mantine.dev/hooks/use-toggle/\
]]\
local function useBooleanToggle(initialValue)\
\9if initialValue == nil then\
\9\9initialValue = false\
\9end\
\9return useToggle(initialValue, { true, false })\
end\
return {\
\9useToggle = useToggle,\
\9useBooleanToggle = useBooleanToggle,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-toggle")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-toggle")) return fn() end)

_module("use-viewport-size", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.use-viewport-size", "RemoteSpy.include.node_modules.roact-hooked-plus.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useBinding = _roact_hooked.useBinding\
local useEffect = _roact_hooked.useEffect\
local useState = _roact_hooked.useState\
local Workspace = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).Workspace\
--[[\
\9*\
\9* Returns a binding to the current screen size.\
\9* @param onChange Fires when the viewport size changes\
]]\
local function useViewportSize(onChange)\
\9local _binding = useState(Workspace.CurrentCamera)\
\9local camera = _binding[1]\
\9local setCamera = _binding[2]\
\9local _binding_1 = useBinding(camera.ViewportSize)\
\9local size = _binding_1[1]\
\9local setSize = _binding_1[2]\
\9useEffect(function()\
\9\9local handle = Workspace:GetPropertyChangedSignal(\"CurrentCamera\"):Connect(function()\
\9\9\9if Workspace.CurrentCamera then\
\9\9\9\9setCamera(Workspace.CurrentCamera)\
\9\9\9\9setSize(Workspace.CurrentCamera.ViewportSize)\
\9\9\9\9local _result = onChange\
\9\9\9\9if _result ~= nil then\
\9\9\9\9\9_result(Workspace.CurrentCamera.ViewportSize)\
\9\9\9\9end\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9handle:Disconnect()\
\9\9end\
\9end, {})\
\9useEffect(function()\
\9\9local handle = camera:GetPropertyChangedSignal(\"ViewportSize\"):Connect(function()\
\9\9\9setSize(camera.ViewportSize)\
\9\9\9local _result = onChange\
\9\9\9if _result ~= nil then\
\9\9\9\9_result(camera.ViewportSize)\
\9\9\9end\
\9\9end)\
\9\9return function()\
\9\9\9handle:Disconnect()\
\9\9end\
\9end, { camera })\
\9return size\
end\
return {\
\9useViewportSize = useViewportSize,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.use-viewport-size")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.use-viewport-size")) return fn() end)

_instance("utils", "Folder", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils", "RemoteSpy.include.node_modules.roact-hooked-plus.out")

_module("array-to-map", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.array-to-map", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function arrayToMap(array, callback)\
\9local map = {}\
\9local _arg0 = function(value, index)\
\9\9local _binding = callback(value, index, array)\
\9\9local k = _binding[1]\
\9\9local v = _binding[2]\
\9\9map[k] = v\
\9end\
\9for _k, _v in ipairs(array) do\
\9\9_arg0(_v, _k - 1, array)\
\9end\
\9return map\
end\
return {\
\9arrayToMap = arrayToMap,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.array-to-map")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.array-to-map")) return fn() end)

_module("binding-utils", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.binding-utils", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local function isBinding(value)\
\9return type(value) == \"table\" and value.getValue ~= nil\
end\
local function asBinding(value)\
\9if isBinding(value) then\
\9\9return value\
\9else\
\9\9return (Roact.createBinding(value))\
\9end\
end\
local function mapBinding(value, transform)\
\9if isBinding(value) then\
\9\9return value:map(transform)\
\9else\
\9\9return (Roact.createBinding(transform(value)))\
\9end\
end\
local function getBindingValue(value)\
\9if isBinding(value) then\
\9\9return value:getValue()\
\9else\
\9\9return value\
\9end\
end\
return {\
\9isBinding = isBinding,\
\9asBinding = asBinding,\
\9mapBinding = mapBinding,\
\9getBindingValue = getBindingValue,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.binding-utils")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.binding-utils")) return fn() end)

_module("resolve", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.resolve", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local function resolve(fn, ...)\
\9local args = { ... }\
\9if type(fn) == \"function\" then\
\9\9return fn(unpack(args))\
\9else\
\9\9return fn\
\9end\
end\
return {\
\9resolve = resolve,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.resolve")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.resolve")) return fn() end)

_module("set-interval", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.set-interval", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local TS = _G[script]\
local RunService = TS.import(script, TS.getModule(script, \"@rbxts\", \"services\")).RunService\
local Interval\
do\
\9Interval = setmetatable({}, {\
\9\9__tostring = function()\
\9\9\9return \"Interval\"\
\9\9end,\
\9})\
\9Interval.__index = Interval\
\9function Interval.new(...)\
\9\9local self = setmetatable({}, Interval)\
\9\9return self:constructor(...) or self\
\9end\
\9function Interval:constructor(callback, milliseconds, ...)\
\9\9local args = { ... }\
\9\9self.running = true\
\9\9task.defer(function()\
\9\9\9local clock = 0\
\9\9\9local hb\
\9\9\9hb = RunService.Heartbeat:Connect(function(step)\
\9\9\9\9clock += step\
\9\9\9\9if not self.running then\
\9\9\9\9\9hb:Disconnect()\
\9\9\9\9elseif clock >= milliseconds / 1000 then\
\9\9\9\9\9clock -= milliseconds / 1000\
\9\9\9\9\9callback(unpack(args))\
\9\9\9\9end\
\9\9\9end)\
\9\9end)\
\9end\
\9function Interval:clear()\
\9\9self.running = false\
\9end\
end\
local function setInterval(callback, milliseconds, ...)\
\9local args = { ... }\
\9return Interval.new(callback, milliseconds, unpack(args))\
end\
local function clearInterval(interval)\
\9local _result = interval\
\9if _result ~= nil then\
\9\9_result:clear()\
\9end\
end\
return {\
\9setInterval = setInterval,\
\9clearInterval = clearInterval,\
\9Interval = Interval,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.set-interval")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.set-interval")) return fn() end)

_module("set-timeout", "ModuleScript", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.set-timeout", "RemoteSpy.include.node_modules.roact-hooked-plus.out.utils", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.3.3\
local Timeout\
do\
\9Timeout = setmetatable({}, {\
\9\9__tostring = function()\
\9\9\9return \"Timeout\"\
\9\9end,\
\9})\
\9Timeout.__index = Timeout\
\9function Timeout.new(...)\
\9\9local self = setmetatable({}, Timeout)\
\9\9return self:constructor(...) or self\
\9end\
\9function Timeout:constructor(callback, milliseconds, ...)\
\9\9local args = { ... }\
\9\9self.running = true\
\9\9task.delay(milliseconds / 1000, function()\
\9\9\9if self.running then\
\9\9\9\9callback(unpack(args))\
\9\9\9end\
\9\9end)\
\9end\
\9function Timeout:clear()\
\9\9self.running = false\
\9end\
end\
local function setTimeout(callback, milliseconds, ...)\
\9local args = { ... }\
\9return Timeout.new(callback, milliseconds, unpack(args))\
end\
local function clearTimeout(timeout)\
\9timeout:clear()\
end\
return {\
\9setTimeout = setTimeout,\
\9clearTimeout = clearTimeout,\
\9Timeout = Timeout,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.set-timeout")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-hooked-plus.out.utils.set-timeout")) return fn() end)

_instance("roact-rodux-hooked", "Folder", "RemoteSpy.include.node_modules.roact-rodux-hooked", "RemoteSpy.include.node_modules")

_module("out", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out", "RemoteSpy.include.node_modules.roact-rodux-hooked", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
local TS = _G[script]\
local exports = {}\
exports.Provider = TS.import(script, script, \"components\", \"provider\").Provider\
exports.useDispatch = TS.import(script, script, \"hooks\", \"use-dispatch\").useDispatch\
exports.useSelector = TS.import(script, script, \"hooks\", \"use-selector\").useSelector\
exports.useStore = TS.import(script, script, \"hooks\", \"use-store\").useStore\
exports.shallowEqual = TS.import(script, script, \"helpers\", \"shallow-equal\").shallowEqual\
exports.RoactRoduxContext = TS.import(script, script, \"components\", \"context\").RoactRoduxContext\
return exports\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out")) return fn() end)

_instance("components", "Folder", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.components", "RemoteSpy.include.node_modules.roact-rodux-hooked.out")

_module("context", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.components.context", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
local TS = _G[script]\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
local RoactRoduxContext = Roact.createContext(nil)\
return {\
\9RoactRoduxContext = RoactRoduxContext,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out.components.context")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out.components.context")) return fn() end)

_module("provider", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.components.provider", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.components", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
local TS = _G[script]\
local RoactRoduxContext = TS.import(script, script.Parent, \"context\").RoactRoduxContext\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local hooked = _roact_hooked.hooked\
local useMemo = _roact_hooked.useMemo\
local Roact = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact\").src)\
--[[\
\9*\
\9* Makes the Rodux store available to the `useStore()` calls in the component hierarchy below.\
]]\
local Provider = hooked(function(_param)\
\9local store = _param.store\
\9local children = _param[Roact.Children]\
\9local contextValue = useMemo(function()\
\9\9return {\
\9\9\9store = store,\
\9\9}\
\9end, { store })\
\9local _ptr = {\
\9\9value = contextValue,\
\9}\
\9local _ptr_1 = {}\
\9local _length = #_ptr_1\
\9if children then\
\9\9for _k, _v in pairs(children) do\
\9\9\9if type(_k) == \"number\" then\
\9\9\9\9_ptr_1[_length + _k] = _v\
\9\9\9else\
\9\9\9\9_ptr_1[_k] = _v\
\9\9\9end\
\9\9end\
\9end\
\9return Roact.createElement(RoactRoduxContext.Provider, _ptr, _ptr_1)\
end)\
return {\
\9Provider = Provider,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out.components.provider")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out.components.provider")) return fn() end)

_instance("helpers", "Folder", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.helpers", "RemoteSpy.include.node_modules.roact-rodux-hooked.out")

_module("shallow-equal", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.helpers.shallow-equal", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.helpers", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
local TS = _G[script]\
local Object = TS.import(script, TS.getModule(script, \"@rbxts\", \"object-utils\"))\
--[[\
\9*\
\9* Compares two arbitrary values for shallow equality. Object values are compared based on their keys, i.e. they must\
\9* have the same keys and for each key the value must be equal.\
]]\
local function shallowEqual(left, right)\
\9if left == right then\
\9\9return true\
\9end\
\9if not (type(left) == \"table\") or not (type(right) == \"table\") then\
\9\9return false\
\9end\
\9local keysLeft = Object.keys(left)\
\9local keysRight = Object.keys(right)\
\9if #keysLeft ~= #keysRight then\
\9\9return false\
\9end\
\9local _arg0 = function(value, index)\
\9\9return value == right[index]\
\9end\
\9-- ▼ ReadonlyArray.every ▼\
\9local _result = true\
\9for _k, _v in ipairs(keysLeft) do\
\9\9if not _arg0(_v, _k - 1, keysLeft) then\
\9\9\9_result = false\
\9\9\9break\
\9\9end\
\9end\
\9-- ▲ ReadonlyArray.every ▲\
\9return _result\
end\
return {\
\9shallowEqual = shallowEqual,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out.helpers.shallow-equal")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out.helpers.shallow-equal")) return fn() end)

_instance("hooks", "Folder", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks", "RemoteSpy.include.node_modules.roact-rodux-hooked.out")

_module("use-dispatch", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-dispatch", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
local TS = _G[script]\
local useMutable = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useMutable\
local useStore = TS.import(script, script.Parent, \"use-store\").useStore\
--[[\
\9*\
\9* A hook to access the Rodux Store's `dispatch` method.\
\9*\
\9* @returns Rodux store's `dispatch` method\
\9*\
\9* @example\
\9* import Roact from \"@rbxts/roact\";\
\9* import { hooked } from \"@rbxts/roact-hooked\";\
\9* import { useDispatch } from \"@rbxts/roact-rodux-hooked\";\
\9* import type { RootStore } from \"./store\";\
\9*\
\9* export const CounterComponent = hooked(() => {\
\9*   const dispatch = useDispatch<RootStore>();\
\9*   return (\
\9*     <textlabel\
\9*       Text={\"Increase counter\"}\
\9*       Event={{\
\9*         Activated: () => dispatch({ type: \"increase-counter\" }),\
\9*       }}\
\9*     />\
\9*   );\
\9* });\
]]\
local function useDispatch()\
\9local store = useStore()\
\9return useMutable(function(action)\
\9\9return store:dispatch(action)\
\9end).current\
end\
return {\
\9useDispatch = useDispatch,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-dispatch")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-dispatch")) return fn() end)

_module("use-selector", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-selector", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
local TS = _G[script]\
local _roact_hooked = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out)\
local useEffect = _roact_hooked.useEffect\
local useMutable = _roact_hooked.useMutable\
local useReducer = _roact_hooked.useReducer\
local useStore = TS.import(script, script.Parent, \"use-store\").useStore\
--[[\
\9*\
\9* This interface allows you to easily create a hook that is properly typed for your store's root state.\
\9*\
\9* @example\
\9* interface RootState {\
\9*   property: string;\
\9* }\
\9*\
\9* const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;\
]]\
--[[\
\9*\
\9* A hook to access the Rodux Store's state. This hook takes a selector function as an argument. The selector is called\
\9* with the store state.\
\9*\
\9* This hook takes an optional equality comparison function as the second parameter that allows you to customize the\
\9* way the selected state is compared to determine whether the component needs to be re-rendered.\
\9*\
\9* @param selector - The selector function\
\9* @param equalityFn - The function that will be used to determine equality\
\9*\
\9* @returns The selected portion of the state\
\9*\
\9* @example\
\9* import Roact from \"@rbxts/roact\";\
\9* import { hooked } from \"@rbxts/roact-hooked\";\
\9* import { useSelector } from \"@rbxts/roact-rodux-hooked\";\
\9* import type { RootState } from \"./store\";\
\9*\
\9* export const CounterComponent = hooked(() => {\
\9*   const count = useSelector((state: RootState) => state.counter);\
\9*   return <textlabel Text={`Counter: ${count}`} />;\
\9* });\
]]\
local function useSelector(selector, equalityFn)\
\9if equalityFn == nil then\
\9\9equalityFn = function(a, b)\
\9\9\9return a == b\
\9\9end\
\9end\
\9local _binding = useReducer(function(s)\
\9\9return s + 1\
\9end, 0)\
\9local forceRender = _binding[2]\
\9local store = useStore()\
\9local latestSubscriptionCallbackError = useMutable()\
\9local latestSelector = useMutable()\
\9local latestStoreState = useMutable()\
\9local latestSelectedState = useMutable()\
\9local storeState = store:getState()\
\9local selectedState\
\9TS.try(function()\
\9\9local _value = selector ~= latestSelector.current or storeState ~= latestStoreState.current or latestSubscriptionCallbackError.current\
\9\9if _value ~= \"\" and _value then\
\9\9\9local newSelectedState = selector(storeState)\
\9\9\9-- ensure latest selected state is reused so that a custom equality function can result in identical references\
\9\9\9if latestSelectedState.current == nil or not equalityFn(newSelectedState, latestSelectedState.current) then\
\9\9\9\9selectedState = newSelectedState\
\9\9\9else\
\9\9\9\9selectedState = latestSelectedState.current\
\9\9\9end\
\9\9else\
\9\9\9selectedState = latestSelectedState.current\
\9\9end\
\9end, function(err)\
\9\9if latestSubscriptionCallbackError.current ~= nil then\
\9\9\9err ..= \"\\nThe error may be correlated with this previous error:\\n\" .. latestSubscriptionCallbackError.current .. \"\\n\\n\"\
\9\9end\
\9\9error(err)\
\9end)\
\9useEffect(function()\
\9\9latestSelector.current = selector\
\9\9latestStoreState.current = storeState\
\9\9latestSelectedState.current = selectedState\
\9\9latestSubscriptionCallbackError.current = nil\
\9end)\
\9useEffect(function()\
\9\9local function checkForUpdates(newStoreState)\
\9\9\9local _exitType, _returns = TS.try(function()\
\9\9\9\9-- Avoid calling selector multiple times if the store's state has not changed\
\9\9\9\9if newStoreState == latestStoreState.current then\
\9\9\9\9\9return TS.TRY_RETURN, {}\
\9\9\9\9end\
\9\9\9\9local newSelectedState = latestSelector.current(newStoreState)\
\9\9\9\9if equalityFn(newSelectedState, latestSelectedState.current) then\
\9\9\9\9\9return TS.TRY_RETURN, {}\
\9\9\9\9end\
\9\9\9\9latestSelectedState.current = newSelectedState\
\9\9\9\9latestStoreState.current = newStoreState\
\9\9\9end, function(err)\
\9\9\9\9-- we ignore all errors here, since when the component\
\9\9\9\9-- is re-rendered, the selectors are called again, and\
\9\9\9\9-- will throw again, if neither props nor store state\
\9\9\9\9-- changed\
\9\9\9\9latestSubscriptionCallbackError.current = err\
\9\9\9end)\
\9\9\9if _exitType then\
\9\9\9\9return unpack(_returns)\
\9\9\9end\
\9\9\9task.spawn(forceRender)\
\9\9end\
\9\9local subscription = store.changed:connect(checkForUpdates)\
\9\9checkForUpdates(store:getState())\
\9\9return function()\
\9\9\9return subscription:disconnect()\
\9\9end\
\9end, { store })\
\9return selectedState\
end\
return {\
\9useSelector = useSelector,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-selector")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-selector")) return fn() end)

_module("use-store", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-store", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
local TS = _G[script]\
local RoactRoduxContext = TS.import(script, script.Parent.Parent, \"components\", \"context\").RoactRoduxContext\
local useContext = TS.import(script, TS.getModule(script, \"@rbxts\", \"roact-hooked\").out).useContext\
--[[\
\9*\
\9* A hook to access the Rodux Store.\
\9*\
\9* @returns The Rodux store\
\9*\
\9* @example\
\9* import Roact from \"@rbxts/roact\";\
\9* import { hooked } from \"@rbxts/roact-hooked\";\
\9* import { useStore } from \"@rbxts/roact-rodux-hooked\";\
\9* import type { RootStore } from \"./store\";\
\9*\
\9* export const CounterComponent = hooked(() => {\
\9*   const store = useStore<RootStore>();\
\9*   return <textlabel Text={store.getState()} />;\
\9* });\
]]\
local function useStore()\
\9return useContext(RoactRoduxContext).store\
end\
return {\
\9useStore = useStore,\
}\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-store")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out.hooks.use-store")) return fn() end)

_module("types", "ModuleScript", "RemoteSpy.include.node_modules.roact-rodux-hooked.out.types", "RemoteSpy.include.node_modules.roact-rodux-hooked.out", function () local fn = assert(loadstring("-- Compiled with roblox-ts v1.2.3\
--[[\
\9*\
\9* A Roact Context\
]]\
return nil\
", '@'.."RemoteSpy.include.node_modules.roact-rodux-hooked.out.types")) setfenv(fn, _env("RemoteSpy.include.node_modules.roact-rodux-hooked.out.types")) return fn() end)

_instance("rodux", "Folder", "RemoteSpy.include.node_modules.rodux", "RemoteSpy.include.node_modules")

_module("src", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src", "RemoteSpy.include.node_modules.rodux", function () local fn = assert(loadstring("local Store = require(script.Store)\
local createReducer = require(script.createReducer)\
local combineReducers = require(script.combineReducers)\
local makeActionCreator = require(script.makeActionCreator)\
local loggerMiddleware = require(script.loggerMiddleware)\
local thunkMiddleware = require(script.thunkMiddleware)\
\
return {\
\9Store = Store,\
\9createReducer = createReducer,\
\9combineReducers = combineReducers,\
\9makeActionCreator = makeActionCreator,\
\9loggerMiddleware = loggerMiddleware.middleware,\
\9thunkMiddleware = thunkMiddleware,\
}\
", '@'.."RemoteSpy.include.node_modules.rodux.src")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src")) return fn() end)

_module("NoYield", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.NoYield", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("--!nocheck\
\
--[[\
\9Calls a function and throws an error if it attempts to yield.\
\
\9Pass any number of arguments to the function after the callback.\
\
\9This function supports multiple return; all results returned from the\
\9given function will be returned.\
]]\
\
local function resultHandler(co, ok, ...)\
\9if not ok then\
\9\9local message = (...)\
\9\9error(debug.traceback(co, message), 2)\
\9end\
\
\9if coroutine.status(co) ~= \"dead\" then\
\9\9error(debug.traceback(co, \"Attempted to yield inside changed event!\"), 2)\
\9end\
\
\9return ...\
end\
\
local function NoYield(callback, ...)\
\9local co = coroutine.create(callback)\
\
\9return resultHandler(co, coroutine.resume(co, ...))\
end\
\
return NoYield\
", '@'.."RemoteSpy.include.node_modules.rodux.src.NoYield")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.NoYield")) return fn() end)

_module("Signal", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.Signal", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("--[[\
\9A limited, simple implementation of a Signal.\
\
\9Handlers are fired in order, and (dis)connections are properly handled when\
\9executing an event.\
]]\
local function immutableAppend(list, ...)\
\9local new = {}\
\9local len = #list\
\
\9for key = 1, len do\
\9\9new[key] = list[key]\
\9end\
\
\9for i = 1, select(\"#\", ...) do\
\9\9new[len + i] = select(i, ...)\
\9end\
\
\9return new\
end\
\
local function immutableRemoveValue(list, removeValue)\
\9local new = {}\
\
\9for i = 1, #list do\
\9\9if list[i] ~= removeValue then\
\9\9\9table.insert(new, list[i])\
\9\9end\
\9end\
\
\9return new\
end\
\
local Signal = {}\
\
Signal.__index = Signal\
\
function Signal.new(store)\
\9local self = {\
\9\9_listeners = {},\
\9\9_store = store\
\9}\
\
\9setmetatable(self, Signal)\
\
\9return self\
end\
\
function Signal:connect(callback)\
\9if typeof(callback) ~= \"function\" then\
\9\9error(\"Expected the listener to be a function.\")\
\9end\
\
\9if self._store and self._store._isDispatching then\
\9\9error(\
\9\9\9'You may not call store.changed:connect() while the reducer is executing. ' ..\
\9\9\9\9'If you would like to be notified after the store has been updated, subscribe from a ' ..\
\9\9\9\9'component and invoke store:getState() in the callback to access the latest state. '\
\9\9)\
\9end\
\
\9local listener = {\
\9\9callback = callback,\
\9\9disconnected = false,\
\9\9connectTraceback = debug.traceback(),\
\9\9disconnectTraceback = nil\
\9}\
\
\9self._listeners = immutableAppend(self._listeners, listener)\
\
\9local function disconnect()\
\9\9if listener.disconnected then\
\9\9\9error((\
\9\9\9\9\"Listener connected at: \\n%s\\n\" ..\
\9\9\9\9\"was already disconnected at: \\n%s\\n\"\
\9\9\9):format(\
\9\9\9\9tostring(listener.connectTraceback),\
\9\9\9\9tostring(listener.disconnectTraceback)\
\9\9\9))\
\9\9end\
\
\9\9if self._store and self._store._isDispatching then\
\9\9\9error(\"You may not unsubscribe from a store listener while the reducer is executing.\")\
\9\9end\
\
\9\9listener.disconnected = true\
\9\9listener.disconnectTraceback = debug.traceback()\
\9\9self._listeners = immutableRemoveValue(self._listeners, listener)\
\9end\
\
\9return {\
\9\9disconnect = disconnect\
\9}\
end\
\
function Signal:fire(...)\
\9for _, listener in ipairs(self._listeners) do\
\9\9if not listener.disconnected then\
\9\9\9listener.callback(...)\
\9\9end\
\9end\
end\
\
return Signal", '@'.."RemoteSpy.include.node_modules.rodux.src.Signal")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.Signal")) return fn() end)

_module("Store", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.Store", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("local RunService = game:GetService(\"RunService\")\
\
local Signal = require(script.Parent.Signal)\
local NoYield = require(script.Parent.NoYield)\
\
local ACTION_LOG_LENGTH = 3\
\
local rethrowErrorReporter = {\
\9reportReducerError = function(prevState, action, errorResult)\
\9\9error(string.format(\"Received error: %s\\n\\n%s\", errorResult.message, errorResult.thrownValue))\
\9end,\
\9reportUpdateError = function(prevState, currentState, lastActions, errorResult)\
\9\9error(string.format(\"Received error: %s\\n\\n%s\", errorResult.message, errorResult.thrownValue))\
\9end,\
}\
\
local function tracebackReporter(message)\
\9return debug.traceback(tostring(message))\
end\
\
local Store = {}\
\
-- This value is exposed as a private value so that the test code can stay in\
-- sync with what event we listen to for dispatching the Changed event.\
-- It may not be Heartbeat in the future.\
Store._flushEvent = RunService.Heartbeat\
\
Store.__index = Store\
\
--[[\
\9Create a new Store whose state is transformed by the given reducer function.\
\
\9Each time an action is dispatched to the store, the new state of the store\
\9is given by:\
\
\9\9state = reducer(state, action)\
\
\9Reducers do not mutate the state object, so the original state is still\
\9valid.\
]]\
function Store.new(reducer, initialState, middlewares, errorReporter)\
\9assert(typeof(reducer) == \"function\", \"Bad argument #1 to Store.new, expected function.\")\
\9assert(middlewares == nil or typeof(middlewares) == \"table\", \"Bad argument #3 to Store.new, expected nil or table.\")\
\9if middlewares ~= nil then\
\9\9for i=1, #middlewares, 1 do\
\9\9\9assert(\
\9\9\9\9typeof(middlewares[i]) == \"function\",\
\9\9\9\9(\"Expected the middleware ('%s') at index %d to be a function.\"):format(tostring(middlewares[i]), i)\
\9\9\9)\
\9\9end\
\9end\
\
\9local self = {}\
\
\9self._errorReporter = errorReporter or rethrowErrorReporter\
\9self._isDispatching = false\
\9self._reducer = reducer\
\9local initAction = {\
\9\9type = \"@@INIT\",\
\9}\
\9self._actionLog = { initAction }\
\9local ok, result = xpcall(function()\
\9\9self._state = reducer(initialState, initAction)\
\9end, tracebackReporter)\
\9if not ok then\
\9\9self._errorReporter.reportReducerError(initialState, initAction, {\
\9\9\9message = \"Caught error in reducer with init\",\
\9\9\9thrownValue = result,\
\9\9})\
\9\9self._state = initialState\
\9end\
\9self._lastState = self._state\
\
\9self._mutatedSinceFlush = false\
\9self._connections = {}\
\
\9self.changed = Signal.new(self)\
\
\9setmetatable(self, Store)\
\
\9local connection = self._flushEvent:Connect(function()\
\9\9self:flush()\
\9end)\
\9table.insert(self._connections, connection)\
\
\9if middlewares then\
\9\9local unboundDispatch = self.dispatch\
\9\9local dispatch = function(...)\
\9\9\9return unboundDispatch(self, ...)\
\9\9end\
\
\9\9for i = #middlewares, 1, -1 do\
\9\9\9local middleware = middlewares[i]\
\9\9\9dispatch = middleware(dispatch, self)\
\9\9end\
\
\9\9self.dispatch = function(_self, ...)\
\9\9\9return dispatch(...)\
\9\9end\
\9end\
\
\9return self\
end\
\
--[[\
\9Get the current state of the Store. Do not mutate this!\
]]\
function Store:getState()\
\9if self._isDispatching then\
\9\9error((\"You may not call store:getState() while the reducer is executing. \" ..\
\9\9\9\"The reducer (%s) has already received the state as an argument. \" ..\
\9\9\9\"Pass it down from the top reducer instead of reading it from the store.\"):format(tostring(self._reducer)))\
\9end\
\
\9return self._state\
end\
\
--[[\
\9Dispatch an action to the store. This allows the store's reducer to mutate\
\9the state of the application by creating a new copy of the state.\
\
\9Listeners on the changed event of the store are notified when the state\
\9changes, but not necessarily on every Dispatch.\
]]\
function Store:dispatch(action)\
\9if typeof(action) ~= \"table\" then\
\9\9error((\"Actions must be tables. \" ..\
\9\9\9\"Use custom middleware for %q actions.\"):format(typeof(action)),\
\9\9\0092\
\9\9)\
\9end\
\
\9if action.type == nil then\
\9\9error(\"Actions may not have an undefined 'type' property. \" ..\
\9\9\9\"Have you misspelled a constant? \\n\" ..\
\9\9\9tostring(action), 2)\
\9end\
\
\9if self._isDispatching then\
\9\9error(\"Reducers may not dispatch actions.\")\
\9end\
\
\9local ok, result = pcall(function()\
\9\9self._isDispatching = true\
\9\9self._state = self._reducer(self._state, action)\
\9\9self._mutatedSinceFlush = true\
\9end)\
\
\9self._isDispatching = false\
\
\9if not ok then\
\9\9self._errorReporter.reportReducerError(\
\9\9\9self._state,\
\9\9\9action,\
\9\9\9{\
\9\9\9\9message = \"Caught error in reducer\",\
\9\9\9\9thrownValue = result,\
\9\9\9}\
\9\9)\
\9end\
\
\9if #self._actionLog == ACTION_LOG_LENGTH then\
\9\9table.remove(self._actionLog, 1)\
\9end\
\9table.insert(self._actionLog, action)\
end\
\
--[[\
\9Marks the store as deleted, disconnecting any outstanding connections.\
]]\
function Store:destruct()\
\9for _, connection in ipairs(self._connections) do\
\9\9connection:Disconnect()\
\9end\
\
\9self._connections = nil\
end\
\
--[[\
\9Flush all pending actions since the last change event was dispatched.\
]]\
function Store:flush()\
\9if not self._mutatedSinceFlush then\
\9\9return\
\9end\
\
\9self._mutatedSinceFlush = false\
\
\9-- On self.changed:fire(), further actions may be immediately dispatched, in\
\9-- which case self._lastState will be set to the most recent self._state,\
\9-- unless we cache this value first\
\9local state = self._state\
\
\9local ok, errorResult = xpcall(function()\
\9\9-- If a changed listener yields, *very* surprising bugs can ensue.\
\9\9-- Because of that, changed listeners cannot yield.\
\9\9NoYield(function()\
\9\9\9self.changed:fire(state, self._lastState)\
\9\9end)\
\9end, tracebackReporter)\
\
\9if not ok then\
\9\9self._errorReporter.reportUpdateError(\
\9\9\9self._lastState,\
\9\9\9state,\
\9\9\9self._actionLog,\
\9\9\9{\
\9\9\9\9message = \"Caught error flushing store updates\",\
\9\9\9\9thrownValue = errorResult,\
\9\9\9}\
\9\9)\
\9end\
\
\9self._lastState = state\
end\
\
return Store\
", '@'.."RemoteSpy.include.node_modules.rodux.src.Store")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.Store")) return fn() end)

_module("combineReducers", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.combineReducers", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("--[[\
\9Create a composite reducer from a map of keys and sub-reducers.\
]]\
local function combineReducers(map)\
\9return function(state, action)\
\9\9-- If state is nil, substitute it with a blank table.\
\9\9if state == nil then\
\9\9\9state = {}\
\9\9end\
\
\9\9local newState = {}\
\
\9\9for key, reducer in pairs(map) do\
\9\9\9-- Each reducer gets its own state, not the entire state table\
\9\9\9newState[key] = reducer(state[key], action)\
\9\9end\
\
\9\9return newState\
\9end\
end\
\
return combineReducers\
", '@'.."RemoteSpy.include.node_modules.rodux.src.combineReducers")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.combineReducers")) return fn() end)

_module("createReducer", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.createReducer", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("return function(initialState, handlers)\
\9return function(state, action)\
\9\9if state == nil then\
\9\9\9state = initialState\
\9\9end\
\
\9\9local handler = handlers[action.type]\
\
\9\9if handler then\
\9\9\9return handler(state, action)\
\9\9end\
\
\9\9return state\
\9end\
end\
", '@'.."RemoteSpy.include.node_modules.rodux.src.createReducer")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.createReducer")) return fn() end)

_module("loggerMiddleware", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.loggerMiddleware", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("-- We want to be able to override outputFunction in tests, so the shape of this\
-- module is kind of unconventional.\
--\
-- We fix it this weird shape in init.lua.\
local prettyPrint = require(script.Parent.prettyPrint)\
local loggerMiddleware = {\
\9outputFunction = print,\
}\
\
function loggerMiddleware.middleware(nextDispatch, store)\
\9return function(action)\
\9\9local result = nextDispatch(action)\
\
\9\9loggerMiddleware.outputFunction((\"Action dispatched: %s\\nState changed to: %s\"):format(\
\9\9\9prettyPrint(action),\
\9\9\9prettyPrint(store:getState())\
\9\9))\
\
\9\9return result\
\9end\
end\
\
return loggerMiddleware\
", '@'.."RemoteSpy.include.node_modules.rodux.src.loggerMiddleware")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.loggerMiddleware")) return fn() end)

_module("makeActionCreator", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.makeActionCreator", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("--[[\13\
\9A helper function to define a Rodux action creator with an associated name.\13\
]]\13\
local function makeActionCreator(name, fn)\13\
\9assert(type(name) == \"string\", \"Bad argument #1: Expected a string name for the action creator\")\13\
\13\
\9assert(type(fn) == \"function\", \"Bad argument #2: Expected a function that creates action objects\")\13\
\13\
\9return setmetatable({\13\
\9\9name = name,\13\
\9}, {\13\
\9\9__call = function(self, ...)\13\
\9\9\9local result = fn(...)\13\
\13\
\9\9\9assert(type(result) == \"table\", \"Invalid action: An action creator must return a table\")\13\
\13\
\9\9\9result.type = name\13\
\13\
\9\9\9return result\13\
\9\9end\13\
\9})\13\
end\13\
\13\
return makeActionCreator\13\
", '@'.."RemoteSpy.include.node_modules.rodux.src.makeActionCreator")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.makeActionCreator")) return fn() end)

_module("prettyPrint", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.prettyPrint", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("local indent = \"    \"\
\
local function prettyPrint(value, indentLevel)\
\9indentLevel = indentLevel or 0\
\9local output = {}\
\
\9if typeof(value) == \"table\" then\
\9\9table.insert(output, \"{\\n\")\
\
\9\9for tableKey, tableValue in pairs(value) do\
\9\9\9table.insert(output, indent:rep(indentLevel + 1))\
\9\9\9table.insert(output, tostring(tableKey))\
\9\9\9table.insert(output, \" = \")\
\
\9\9\9table.insert(output, prettyPrint(tableValue, indentLevel + 1))\
\9\9\9table.insert(output, \"\\n\")\
\9\9end\
\
\9\9table.insert(output, indent:rep(indentLevel))\
\9\9table.insert(output, \"}\")\
\9elseif typeof(value) == \"string\" then\
\9\9table.insert(output, string.format(\"%q\", value))\
\9\9table.insert(output, \" (string)\")\
\9else\
\9\9table.insert(output, tostring(value))\
\9\9table.insert(output, \" (\")\
\9\9table.insert(output, typeof(value))\
\9\9table.insert(output, \")\")\
\9end\
\
\9return table.concat(output, \"\")\
end\
\
return prettyPrint", '@'.."RemoteSpy.include.node_modules.rodux.src.prettyPrint")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.prettyPrint")) return fn() end)

_module("thunkMiddleware", "ModuleScript", "RemoteSpy.include.node_modules.rodux.src.thunkMiddleware", "RemoteSpy.include.node_modules.rodux.src", function () local fn = assert(loadstring("--[[\
\9A middleware that allows for functions to be dispatched.\
\9Functions will receive a single argument, the store itself.\
\9This middleware consumes the function; middleware further down the chain\
\9will not receive it.\
]]\
local function tracebackReporter(message)\
\9return debug.traceback(message)\
end\
\
local function thunkMiddleware(nextDispatch, store)\
\9return function(action)\
\9\9if typeof(action) == \"function\" then\
\9\9\9local ok, result = xpcall(function()\
\9\9\9\9return action(store)\
\9\9\9end, tracebackReporter)\
\
\9\9\9if not ok then\
\9\9\9\9-- report the error and move on so it's non-fatal app\
\9\9\9\9store._errorReporter.reportReducerError(store:getState(), action, {\
\9\9\9\9\9message = \"Caught error in thunk\",\
\9\9\9\9\9thrownValue = result,\
\9\9\9\9})\
\9\9\9\9return nil\
\9\9\9end\
\
\9\9\9return result\
\9\9end\
\
\9\9return nextDispatch(action)\
\9end\
end\
\
return thunkMiddleware\
", '@'.."RemoteSpy.include.node_modules.rodux.src.thunkMiddleware")) setfenv(fn, _env("RemoteSpy.include.node_modules.rodux.src.thunkMiddleware")) return fn() end)

_instance("roselect", "Folder", "RemoteSpy.include.node_modules.roselect", "RemoteSpy.include.node_modules")

_module("src", "ModuleScript", "RemoteSpy.include.node_modules.roselect.src", "RemoteSpy.include.node_modules.roselect", function () local fn = assert(loadstring("local function defaultEqualityCheck(a, b)\13\
\9return a == b\13\
end\13\
\13\
local function isDictionary(tbl)\13\
\9if type(value) ~= \"table\" then\13\
\9\9return false\13\
\9end\13\
\13\
\9for k, _ in pairs(tbl) do\13\
\9\9if type(k) ~= \"number\" then\13\
\9\9\9return true\13\
\9\9end\13\
\9end\13\
\9\13\
\9return false\13\
end\13\
\13\
local function isDependency(value)\13\
\9return type(value) == \"table\" and isDictionary(value) == false and value[\"dependencies\"] == nil\13\
end\13\
\13\
local function reduce(tbl, callback, initialValue)\13\
        tbl = tbl or {}\13\
\9local value = initialValue or tbl[1]\13\
\13\
\9for i, v in ipairs(tbl) do\13\
\9\9value = callback(value, v, i)\13\
\9end\13\
\13\
\9return value\13\
end\13\
\13\
local function areArgumentsShallowlyEqual(equalityCheck, prev, nextValue)\13\
\9if prev == nil or nextValue == nil or #prev ~= #nextValue then\13\
\9\9return false\13\
\9end\13\
\13\
\9for i = 1, #prev do\13\
\9\9if equalityCheck(prev[i], nextValue[i]) == false then\13\
\9\9\9return false\13\
\9\9end\13\
\9end\13\
\13\
\9return true\13\
end\13\
\13\
local function defaultMemoize(func, equalityCheck)\13\
\9if equalityCheck == nil then\13\
\9\9equalityCheck = defaultEqualityCheck\13\
\9end\13\
\13\
\9local lastArgs\13\
\9local lastResult\13\
\13\
\9return function(...)\13\
\9\9local args = {...}\13\
\13\
\9\9if areArgumentsShallowlyEqual(equalityCheck, lastArgs, args) == false then\13\
\9\9\9lastResult = func(unpack(args))\13\
\9\9end\13\
\13\
\9\9lastArgs = args\13\
\9\9return lastResult\13\
\9end\13\
end\13\
\13\
local function getDependencies(funcs)\13\
\9local dependencies = if isDependency(funcs[1]) then funcs[1] else funcs\13\
\13\
\9for _, dep in ipairs(dependencies) do\13\
\9\9if isDependency(dep) then\13\
\9\9\9error(\"Selector creators expect all input-selectors to be functions.\", 2)\13\
\9\9end\13\
\9end\13\
\13\
\9return dependencies\13\
end\13\
\13\
local function createSelectorCreator(memoize, ...)\13\
\9local memoizeOptions = {...}\13\
\13\
\9return function(...)\13\
\9\9local funcs = {...}\13\
\13\
\9\9local recomputations = 0\13\
\9\9local resultFunc = table.remove(funcs, #funcs)\13\
\9\9local dependencies = getDependencies(funcs)\13\
\13\
\9\9local memoizedResultFunc = memoize(\13\
\9\9\9function(...)\13\
\9\9\9\9recomputations += 1\13\
\9\9\9\9return resultFunc(...)\13\
\9\9\9end,\13\
\9\9\9unpack(memoizeOptions)\13\
\9\9)\13\
\13\
\9\9local selector = setmetatable({\13\
\9\9\9resultFunc = resultFunc,\13\
\9\9\9dependencies = dependencies,\13\
\9\9\9recomputations = function()\13\
\9\9\9\9return recomputations\13\
\9\9\9end,\13\
\9\9\9resetRecomputations = function()\13\
\9\9\9\9recomputations = 0\13\
\9\9\9\9return recomputations\13\
\9\9\9end\13\
\9\9}, {\13\
\9\9\9__call = memoize(function(self, ...)\13\
\9\9\9\9local params = {}\13\
\13\
\9\9\9\9for i = 1, #dependencies do\13\
\9\9\9\9\9table.insert(params, dependencies[i](...))\13\
\9\9\9\9end\13\
\13\
\9\9\9\9return memoizedResultFunc(unpack(params))\13\
\9\9\9end)\13\
\9\9})\13\
\13\
\9\9return selector\13\
\9end\13\
end\13\
\13\
local createSelector = createSelectorCreator(defaultMemoize)\13\
\13\
local function createStructuredSelector(selectors, selectorCreator)\13\
\9if type(selectors) ~= \"table\" then\13\
\9\9error((\13\
\9\9\9\"createStructuredSelector expects first argument to be an object where each property is a selector, instead received a %s\"\13\
\9\9):format(type(selectors)), 2)\13\
\9elseif selectorCreator == nil then\13\
\9\9selectorCreator = createSelector\13\
\9end\13\
\13\
\9local keys = {}\13\
\9for key, _ in pairs(selectors) do\13\
\9\9table.insert(keys, key)\13\
\9end\13\
\13\
\9local funcs = table.create(#keys)\13\
\9for _, key in ipairs(keys) do\13\
\9\9table.insert(funcs, selectors[key])\13\
\9end\13\
\13\
\9return selectorCreator(\13\
\9\9funcs,\13\
\9\9function(...)\13\
\9\9\9return reduce({...}, function(composition, value, index)\13\
\9\9\9\9composition[keys[index]] = value\13\
\9\9\9\9return composition\13\
\9\9\9end)\13\
\9\9end\13\
\9)\13\
end\13\
\13\
return {\13\
\9defaultMemoize = defaultMemoize,\13\
\9reduce = reduce,\13\
\9createSelectorCreator = createSelectorCreator,\13\
\9createSelector = createSelector,\13\
\9createStructuredSelector = createStructuredSelector,\13\
}", '@'.."RemoteSpy.include.node_modules.roselect.src")) setfenv(fn, _env("RemoteSpy.include.node_modules.roselect.src")) return fn() end)

_module("services", "ModuleScript", "RemoteSpy.include.node_modules.services", "RemoteSpy.include.node_modules", function () local fn = assert(loadstring("return setmetatable({}, {\
\9__index = function(self, serviceName)\
\9\9local service = game:GetService(serviceName)\
\9\9self[serviceName] = service\
\9\9return service\
\9end,\
})\
", '@'.."RemoteSpy.include.node_modules.services")) setfenv(fn, _env("RemoteSpy.include.node_modules.services")) return fn() end)

_instance("types", "Folder", "RemoteSpy.include.node_modules.types", "RemoteSpy.include.node_modules")

_instance("include", "Folder", "RemoteSpy.include.node_modules.types.include", "RemoteSpy.include.node_modules.types")

_instance("generated", "Folder", "RemoteSpy.include.node_modules.types.include.generated", "RemoteSpy.include.node_modules.types.include")

start()
