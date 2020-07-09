local Players = game:GetService("Players")

local DataService
local ToolManager

local ToolService = {}

function ToolService:Start()
end

function ToolService:Init()
	local DataService = self.Services.DataService
	local ToolManager = self.Modules.ToolManager

	Players.PlayerAdded:Connect(function(player)
		local playerData = self:WaitForEvent("DataReady")
		-- Represents fake data for the sake of testing
		local fakeData = {Primary = nil, Secondary = "Pistol", Equipment = nil}
		local tManager = ToolManager.new(player, fakeData)

		player.CharacterAdded:Connect(function(character)
			tManager:EquipSecondary()
		end)
	end)
end

return ToolService
