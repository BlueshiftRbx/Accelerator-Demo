local ProjectileController = {
	Projectiles = {};
};
local RunService = game:GetService("RunService")
local Projectile;

function ProjectileController:CreateProjectile(player, origin, goal)
	local newProjectile = Projectile.new(player, origin, goal)

	table.insert(self.Projectiles, newProjectile)
end

function ProjectileController:Start()
	RunService.Stepped:Connect(function(dt)
		for _, projectile in pairs(self.Projectiles) do
			projectile:Step(dt)
		end
	end)
end

function ProjectileController:Init()
	Projectile = self.Shared.Projectile
end

return ProjectileController
