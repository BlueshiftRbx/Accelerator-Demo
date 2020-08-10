-- Services
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local BulletService

-- Controllers
local WeaponController

-- Modules
local Projectile
local WeaponInfo
local Assets
local Maid

-- Constants
local MAX_STUDS_ALLOWED = 3000

-- Controller
local ProjectileController = {
	Projectiles = {};
}

function ProjectileController:CreateProjectile(owner, origin, goal, weaponName)
	local newProjectile = Projectile.new(owner, origin, goal, weaponName)

	table.insert(self.Projectiles, newProjectile)

	return newProjectile
end

function ProjectileController:Start()
	self.Maid = Maid.new()

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

							self.Maid[firingSound] = firingSound.Stopped:Connect(function()
								self.Maid[firingSound] = nil

								firingSound:Destroy()
							end)
						end
					end
				end
			end
		end
	end)

	RunService.Heartbeat:Connect(function(dt)
		for i=#self.Projectiles, 1, -1 do
			local projectile = self.Projectiles[i]

			if (projectile.Origin - projectile.Position).Magnitude > MAX_STUDS_ALLOWED then
				projectile:Destroy()

				table.remove(self.Projectiles, i)

				continue
			end

			local castResult = projectile:Step(dt)

			if castResult then
				projectile:Destroy()

				table.remove(self.Projectiles, i)

				BulletService.OnTargetHit:Fire(projectile.WeaponName, castResult.Instance)
			end
		end
	end)
end

function ProjectileController:Init()
	BulletService = self.Services.BulletService
	WeaponController = self.Controllers.WeaponController
	Projectile = self.Shared.Projectile
	WeaponInfo = self.Shared.WeaponInfo
	Assets = self.Shared.Assets
	Maid = self.Shared.Maid
end

return ProjectileController
