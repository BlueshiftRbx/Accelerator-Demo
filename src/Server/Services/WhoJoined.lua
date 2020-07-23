local WhoJoined = {}
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/735827147133812788/mzoVNw-lxM8vjpwrokloiDE6Qd6CTKMxWD6E1-kRNtAldsfVVyGF47C6l-6uWJtst12m"

function Log(player)
	if RunService:IsStudio() == false then
		local data = {
			["content"] = ("%s has joined the game. :wave:"):format(player.Name)
		}
		HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data))
	end
end

function WhoJoined:Start()
	local players = game:GetService("Players")
	players.PlayerAdded:Connect(Log)
	for _,player in pairs(players:GetPlayers()) do Log(player) end
end

return WhoJoined
