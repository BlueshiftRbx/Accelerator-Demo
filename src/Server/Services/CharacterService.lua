-- Services
local Players = game:GetService("Players")

local CharacterService = {}

function CharacterService:CharacterAdded(player, character)
	if character then
		repeat wait() until character.Parent == workspace;
		wait(0.1)
		character.Parent = workspace.Characters
	end
end

function CharacterService:PlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		self:CharacterAdded(player, character)
	end)
	self:CharacterAdded(player, player.Character)
end

function CharacterService:Start()
	Players.PlayerAdded:Connect(function(player)
		self:PlayerAdded(player)
	end)
	for _, player in pairs(Players:GetPlayers()) do self:PlayerAdded(player) end
end


return CharacterService
