-- Services
local RunService = game:GetService("RunService")
local BulletService

-- Modules
local Projectile

-- Constants
local MAX_STUDS_ALLOWED = 3000 -- The max amount of studs a projectile is allowed to travel before it is automatically deleted

local ProjectileController = {
	Projectiles = {};
}

function ProjectileController:CreateProjectile(owner, origin, goal)
	local newProjectile = Projectile.new(owner, origin, goal)

	table.insert(self.Projectiles, newProjectile)
end

function ProjectileController:Start()
	BulletService.OnBulletReplicate:Connect(function(owner, origin, goal)
		print(owner, origin, goal)
		self:CreateProjectile(owner, origin, goal)
	end)

	RunService.Heartbeat:Connect(function(dt)
		for i=#self.Projectiles, 1, -1 do
			local projectile = self.Projectiles[i]

			if (projectile.Origin - projectile.Position).Magnitude > MAX_STUDS_ALLOWED then
				projectile:Destroy()
				table.remove(self.Projectiles, i)

				continue
			end

			local completed = projectile:Step(dt)
			if completed then
				projectile:Destroy()
				table.remove(self.Projectiles, i)
			end
		end
	end)
end

function ProjectileController:Init()
	BulletService = self.Services.BulletService
	Projectile = self.Shared.Projectile
end

return ProjectileController
