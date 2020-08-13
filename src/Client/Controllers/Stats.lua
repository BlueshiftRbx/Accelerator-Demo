-- Services
local RunService = game:GetService("RunService")
local RobloxStats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatsService

-- References
local ServerStats = ReplicatedStorage:WaitForChild("ServerStats")

-- Constants
local STATS_STRING = "%dFPS   PING:%dms   PHYSX:%dms   MEM:%dMB   LUA_MEM:%dMB   %s"

-- Controllers
local Topbar

-- Controller
---@type AeroController
local Stats = {}

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
		local serverAge = ServerStats:WaitForChild("Age")
		Topbar:SetText(STATS_STRING:format(fps, self:GetPing(), physx, totalMem, scriptMem, self:FormatTime(serverAge.Value)))
	end
end

function Stats:Init()
	StatsService = self.Services.StatsService
	Topbar = self.Controllers.UI.UIControllers.Topbar
end

return Stats;
