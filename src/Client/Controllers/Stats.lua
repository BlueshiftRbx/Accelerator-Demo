local RunService = game:GetService("RunService")
local RobloxStats = game:GetService("Stats")
local ServerStats;

local Stats = {};
local StatsService
local Topbar

local STATS_STRING = "%dFPS   PING:%dms   PHYSX:%dms   LUA_MEM:%dMB   MEM:%dMB   %s"

function Stats:FormatTime(seconds)
	local function format(int)
		return string.format("%02i", int)
	end

	local minutes = (seconds - seconds%60)/60
	seconds = seconds - minutes*60
	local hours = (minutes - minutes%60)/60
	minutes = minutes - hours*60
	return format(hours)..":"..format(minutes)..":"..format(seconds)
end

function Stats:GetPing()
	local t = tick()
	StatsService:Ping()
	return (tick()-t)/2 * 1000
end

function Stats:Start()
	while wait(1) do
		local fps = math.floor((1/RunService.RenderStepped:Wait()))
		local physx = RobloxStats.PhysicsStepTimeMs
		local scriptMem = RobloxStats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Script)
		local totalMem = RobloxStats:GetTotalMemoryUsageMb()
		Topbar:SetText(STATS_STRING:format(fps, self:GetPing(), physx, scriptMem, totalMem, self:FormatTime(ServerStats.Age.Value)))
	end
end

function Stats:Init()
	StatsService = self.Services.StatsService
	ServerStats = game:GetService("ReplicatedStorage"):WaitForChild("ServerStats")
	Topbar = self.Controllers.UI.UIControllers.Topbar
end

return Stats;
