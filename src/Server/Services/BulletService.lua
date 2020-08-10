-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Modules
local WeaponInfo

-- Service
local BulletService = {
	Client = {};
}

function BulletService.Client:Replicate(owner, origin, destination, weaponName)
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= owner then
			self.Server:FireClient("OnBulletReplicate", player, owner, origin, destination, weaponName)
		end
	end
end

function BulletService:Start()
	self:ConnectClientEvent("OnTargetHit", function(player, weaponName, hitLimb)
		if type(weaponName) == "string" and typeof(hitLimb) == "Instance" and hitLimb:IsDescendantOf(Workspace) then
			local enemyModel = hitLimb.Parent
			local targetHumanoid = enemyModel:FindFirstChildOfClass("Humanoid")

			if targetHumanoid then
				local info = WeaponInfo:GetInfo(weaponName)

				if info then
					targetHumanoid:TakeDamage(info.Config.Damage)
				end
			end
		end
	end)
end

function BulletService:Init()
	WeaponInfo = self.Shared.WeaponInfo

	self:RegisterClientEvent("OnBulletReplicate")
	self:RegisterClientEvent("OnTargetHit")
end

return BulletService;
