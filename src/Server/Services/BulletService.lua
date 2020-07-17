-- Services
local Players = game:GetService("Players")

local BulletService = {
	Client = {};
}

function BulletService.Client:Replicate(owner, origin, destination)
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= owner then
			self.Server:FireClient("OnBulletReplicate", player, owner, origin, destination)
		end
	end
end

function BulletService:Init()
	self:RegisterClientEvent("OnBulletReplicate")
end

return BulletService;
