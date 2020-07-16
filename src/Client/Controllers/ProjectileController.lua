local ProjectileController = {
	Projectiles = {};
};
local RunService = game:GetService("RunService")

local BulletService;
local Projectile;

function ProjectileController:CreateProjectile(owner, origin, goal)
	local newProjectile = Projectile.new(owner, origin, goal)

	table.insert(self.Projectiles, newProjectile)
end

function ProjectileController:Start()
	BulletService.OnBulletReplicate:Connect(function(owner, origin, goal)
		print(owner, origin, goal)
		self:CreateProjectile(owner, origin, goal)
	end)

	RunService.Stepped:Connect(function(_, dt)
		for i=#self.Projectiles, 1, -1 do
			local projectile = self.Projectiles[i]
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
