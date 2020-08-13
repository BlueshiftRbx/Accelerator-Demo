-- Services
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local DataService

-- Modules
local Assets

-- Service
---@type AeroService
local WeaponService = {}

function WeaponService:Start()
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			repeat wait() until DataService.Cache[player.UserId]

			local backpack = player:WaitForChild("Backpack")
			local data = DataService.Cache[player.UserId]

			if data then
				local loadout = data.Loadout

				if loadout then
					local primaryTool = Assets:GetTool(loadout.Primary)
					local secondaryTool = Assets:GetTool(loadout.Secondary)

					if primaryTool then
						CollectionService:AddTag(primaryTool, "Weapon")
						CollectionService:AddTag(primaryTool, "Primary")

						primaryTool.Parent = backpack
					end

					if secondaryTool then
						CollectionService:AddTag(secondaryTool, "Weapon")
						CollectionService:AddTag(secondaryTool, "Secondary")

						secondaryTool.Parent = backpack
					end
				end
			end
		end)
	end)
end

function WeaponService:Init()
	DataService = self.Services.DataService
	Assets = self.Shared.Assets
end

return WeaponService
