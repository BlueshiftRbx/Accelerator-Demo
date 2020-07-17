-- Controllers
local Cursor
local ProjectileController
local UserInput

-- Modules
local Maid

local Weapon = {}

Weapon.__index = Weapon

function Weapon.new(tool, weaponInfo)
	local self = setmetatable({}, Weapon)

	-- Object properties
	self.Tool = tool

	-- Data properties
	self.ClipSize = weaponInfo.ClipSize
	self.Ammo = weaponInfo.ClipSize
	self.FireRate = weaponInfo.FireRate

	-- State properties
	self.IsReloading = false

	-- Other properties
	self.Maid = Maid.new()

	-- Setup
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
		self.Ammo -= 1
	end
end

function Weapon:Reload()
	if not self.IsReloading and self.Ammo < self.ClipSize then
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
end

return Weapon
