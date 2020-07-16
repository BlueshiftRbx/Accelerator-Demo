local BulletService = {
	Client = {};
}
local Players = game:GetService("Players")

function BulletService.Client:Replicate(owner, origin, destination)
	for _, player in pairs(Players:GetPlayers()) do
		self.Server:FireClient("OnBulletReplicate", player, owner, origin, destination)
	end
end

function BulletService:Init()
	self:RegisterClientEvent("OnBulletReplicate")
end

return BulletService;
