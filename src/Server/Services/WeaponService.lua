-- Services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local DataService

-- Modules
local Weld

-- References
local assetsFolder = ServerStorage.Assets
local toolsFolder = assetsFolder.Tools

-- Methods
function GetTool(toolName)
	if toolName then
		local tool = toolsFolder:FindFirstChild(toolName)

		if tool and tool:IsA("Tool") then
			return tool:Clone()
		end
	end
end

local WeaponService = {}

function WeaponService:Start()
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			repeat wait() until DataService.Cache[player.UserId]

			local backpack = player:WaitForChild("Backpack")
			local data = DataService.Cache[player.UserId]

			if data then
				local loadout = data.Loadout

				if loadout then
					local primaryTool = GetTool(loadout.Primary)
					local secondaryTool = GetTool(loadout.Secondary)

					if primaryTool then
						CollectionService:AddTag(primaryTool, "Weapon")
						CollectionService:AddTag(primaryTool, "Primary")

						Weld(primaryTool)
						Weld(primaryTool._Handle, character:FindFirstChild("RightHand"))

						primaryTool.Parent = backpack
					end

					if secondaryTool then
						CollectionService:AddTag(secondaryTool, "Weapon")
						CollectionService:AddTag(secondaryTool, "Secondary")

						Weld(secondaryTool)
						Weld(secondaryTool._Handle, character:FindFirstChild("RightHand"))

						secondaryTool.Parent = backpack
					end
				end
			end
		end)
	end)
end

function WeaponService:Init()
	DataService = self.Services.DataService
	Weld = self.Shared.Weld
end

return WeaponService
