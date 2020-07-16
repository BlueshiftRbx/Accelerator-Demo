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
		for i=#self.Projectiles, 1, -1 do
			local projectile = self.Projectiles[i]
			local completed = projectile:Step(0.1)
			if completed then
				projectile:Destroy()
				table.remove(self.Projectiles, i)
			end
		end
	end)
end

function ProjectileController:Init()
	Projectile = self.Shared.Projectile
end

return ProjectileController
