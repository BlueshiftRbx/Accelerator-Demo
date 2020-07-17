-- Modules
local Maid

local Weapon = {}

Weapon.__index = Weapon

function Weapon.new(tool, weaponInfo)
	local self = setmetatable({}, Weapon)

	self.Tool = tool

	self.ClipSize = weaponInfo.ClipSize
	self.Ammo = weaponInfo.ClipSize
	self.FireRate = weaponInfo.FireRate

	return self
end

function Weapon:GetTool()
	return self.Tool
end

function Weapon:Destroy()

end

function Weapon:Init()
	Maid = self.Shared.Maid
end

return Weapon
