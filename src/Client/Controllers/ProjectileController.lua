-- Services
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local BulletService

-- Modules
local Projectile
local WeaponInfo
local Assets

-- Constants
local MAX_STUDS_ALLOWED = 3000 -- The max amount of studs a projectile is allowed to travel before it is automatically deleted

local ProjectileController = {
	Projectiles = {};
}

function ProjectileController:CreateProjectile(owner, origin, goal, weaponName)
	local newProjectile = Projectile.new(owner, origin, goal, weaponName)

	table.insert(self.Projectiles, newProjectile)
end

function ProjectileController:Start()
	BulletService.OnBulletReplicate:Connect(function(owner, origin, goal, weaponName)
		self:CreateProjectile(owner, origin, goal, weaponName)

		local character = owner.Character

		if character then
			local weapon = character:FindFirstChild(weaponName)

			if weapon and weapon:IsA("Tool") then
				local handle = weapon:FindFirstChild("_Handle")

				if handle then
					local info = WeaponInfo:GetInfo(weaponName)

					if info then
						local firingSound = Assets:GetSound(info.Sounds.FiringSound)

						if firingSound then
							firingSound.Parent = handle

							SoundService:PlayLocalSound(firingSound)

							local signal

							signal = firingSound.Stopped:Connect(function()
								signal:Disconnect()

								firingSound:Destroy()
							end)
						end
					end
				end
			end
		end
	end)

	RunService.Stepped:Connect(function(_, dt)
		for i=#self.Projectiles, 1, -1 do
			local projectile = self.Projectiles[i]

			if (projectile.Origin - projectile.Position).Magnitude > MAX_STUDS_ALLOWED then
				projectile:Destroy()
				table.remove(self.Projectiles, i)

				continue
			end

			local castResult = projectile:Step(dt)

			if castResult then
				BulletService.OnTargetHit:Fire(projectile.WeaponName, castResult.Instance)

				projectile:Destroy()
				table.remove(self.Projectiles, i)
			end
		end
	end)
end

function ProjectileController:Init()
	BulletService = self.Services.BulletService
	Projectile = self.Shared.Projectile
	WeaponInfo = self.Shared.WeaponInfo
	Assets = self.Shared.Assets
end

return ProjectileController
