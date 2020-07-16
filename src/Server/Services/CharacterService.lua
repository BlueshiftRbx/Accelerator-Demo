local CharacterService = {}
local Players = game:GetService("Players")

function CharacterService:CharacterAdded(player, character)
	if character then
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