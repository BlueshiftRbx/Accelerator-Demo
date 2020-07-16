local ProjectileTest = {};
local ProjectileController
local UserInput


function ProjectileTest:Start()
	local Mouse = UserInput:Get("Mouse")

	Mouse.LeftDown:Connect(function()
		ProjectileController:CreateProjectile(self.Player, self.Player.Character.Head.Position, Mouse:GetPosition())
	end)
end

function ProjectileTest:Init()
	ProjectileController = self.Controllers.ProjectileController
	UserInput = self.Controllers.UserInput
end

return ProjectileTest;
