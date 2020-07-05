-- Data Service
-- Legoracer
-- July 5, 2020

local DataService = {
	Client = {};
	ProxyCache = {}; --// ProxyCache fires metamethods!
	Cache = {}; --// Cache doesn't fire metamethods!
}
local DefaultData
local TableUtil
local Event

function DataService.Client:FetchData(player)
	local data = self.Cache[player.UserId]
	if data then
		return data
	end
end

--// Fired whenever data has changed up.
function DataService:DataChanged(player, path, key, value)

end

--// Creates a proxy table which listens to metamethods;
--// Listens to __index to make sure it constructs correct path to key/value.
--// Listens to __newindex to make sure it fires whenever a value has been changed/added/removed.
--// Returns a proxy table and event which is fired on every change with: path, key and value.
function DataService:CreateProxyTable(data)
	local function proxyItUp(data, event, path)
		local proxy = setmetatable({}, {

			__index = function(_, k)
				local v = rawget(data, k);
				if v then
					if typeof(v) == "table" then
						local newPath = (path.."//%s"):format(k)
						return proxyItUp(v, event, )
					else
						return v;
					end
				end
			end;

			__newindex = function(_, k, v)
				rawset(data, k, v);
				event:Fire(path, k, v)
			end

			__call = function(_)
				return event
			end
		})

		return proxy
	end

	local event = Event.new()
	local wrappedData = proxyItUp(data, event, "");

	return wrappedData, event
end

function DataService:SaveData(player)
	--// topkek
end

function DataService:LoadData(player)
	local playerData = TableUtil.Copy(DefaultData);
	local proxyData, changedEvent = self:CreateProxyTable(playerData)

	self.ProxyCache[player.UserId] = proxyData;
	self.Cache[player.UserId] = playerData;

	changedEvent:Connect(function(path, key, value)
		self:DataChanged(player, path, key, value)
	end)
end

function DataService:PlayerAdded(player)
	self:LoadData();
end

function DataService:PlayerRemoving(player)
	self:SaveData();

	--// Clear up their stuff
	self.Cache[player.UserId] = nil;
	self.ProxyCache[player.UserId]():Destroy(); -- Destroy the event;
	self.ProxyCache[player.UserId] = nil;
end

function DataService:Start()
	local players = game:GetService("Players")

	--// Setup player events
	players.PlayerAdded:Connect(function(player)
		self:PlayerAdded(player)
	end)

	-- In case a player has joined before the event was connected.
	for _, player in pairs(players:GetPlayers())) do
		self:PlayerAdded(player)
	end

	-- Doubt player will leave before the event is connected, so this should be enough...
	-- + They cant earn anything if the services arent initialized yet so topkek
	players.PlayerRemoving:Connect(function(player)
		self:PlayerRemoving(player)
	end)
end

function DataService:Init()
	DefaultData = self.Modules.DefaultData
	TableUtil = self.Shared.TableUtil
end

return DataService
