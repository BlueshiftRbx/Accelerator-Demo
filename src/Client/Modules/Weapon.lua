-- Controllers
local Cursor
local ProjectileController
local UserInput

-- Modules
local Maid

-- References
local Player
local Mouse

local Weapon = {}

Weapon.__index = Weapon

function Weapon.new(tool, weaponInfo)
	local self = setmetatable({}, Weapon)

	-- Object properties
	self.Tool = tool
	self.Handle = tool.Handle
	self.Barrel = tool.Handle.BarrelAttachment

	-- Data properties
	self.ClipSize = weaponInfo.ClipSize
	self.Ammo = weaponInfo.ClipSize
	self.FireRate = weaponInfo.FireRate

	-- State properties
	self.Busy = false
	self.IsReloading = false

	-- Other properties
	self.Maid = Maid.new()

	-- Setup
	tool.Activated:Connect(function()
		self:Fire()
	end)

	tool.Deactivated:Connect(function()

	end)

	tool.Equipped:Connect(function()
		Cursor:SetEnabled(true)
	end)

	tool.Unequipped:Connect(function()
		Cursor:SetEnabled(false)
	end)

	return self
end

function Weapon:Fire()
	if not self.IsReloading and self.Ammo > 0 then
		if not self.Busy then
			self.Busy = true

			self.Ammo -= 1

			ProjectileController:CreateProjectile(Player, self.Barrel.WorldPosition, Mouse.Hit.p)

			wait()

			self.Busy = false
		end
	end
end

function Weapon:Reload()
	if not self.IsReloading and self.Ammo < self.ClipSize then
		self.IsReloading = true

		self.Ammo = self.ClipSize

		self.IsReloading = false
	end
end

function Weapon:GetTool()
	return self.Tool
end

function Weapon:Destroy()
	self.Tool = nil
	self.ClipSize = nil
	self.Ammo = nil
	self.FireRate = nil
	self.Maid:DoCleaning()
	self.Maid = nil
end

function Weapon:Init()
	Cursor = self.Controllers.UI.UIControllers.Cursor
	ProjectileController = self.Controllers.ProjectileController
	UserInput = self.Controllers.UserInput
	Maid = self.Shared.Maid
	Player = self.Player
	Mouse = self.Player:GetMouse()
end

return Weapon
