-- Controllers
local Cursor
local ProjectileController
local UserInput
local AmmoUI

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
	self.FireMode = weaponInfo.FireMode

	-- State properties
	self.Busy = false
	self.IsReloading = false

	-- Other properties
	self.Maid = Maid.new()

	-- Setup
	self.Maid:GiveTask(tool.Activated:Connect(function()
		if self.FireMode == "Automatic" then
			local mouse = UserInput:Get("Mouse")

			while mouse:IsButtonPressed(Enum.UserInputType.MouseButton1) do
				if self.Ammo <= 0 then
					break
				end

				self:Fire()

				wait()
			end
		elseif self.FireMode == "Semiautomatic" then
			self:Fire()
		end
	end))

	self.Maid:GiveTask(tool.Equipped:Connect(function()
		Cursor:SetEnabled(true)
		AmmoUI:SetAmmo(self.Ammo)
		AmmoUI:SetEnabled(true)
	end)

	self.Maid:GiveTask(tool.Unequipped:Connect(function()
		Cursor:SetEnabled(false)
		AmmoUI:SetEnabled(false)
	end)

	return self
end

function Weapon:Fire()
	if not self.Busy and not self.IsReloading and self.Ammo > 0 then
		self.Busy = true

		self.Ammo -= 1
		AmmoUI:SetAmmo(self.Ammo)

		ProjectileController:CreateProjectile(Player, self.Barrel.WorldPosition, Mouse.Hit.p)

		wait(self.FireRate)

		self.Busy = false
	end
end

function Weapon:Reload()
	if not self.IsReloading and self.Ammo < self.ClipSize then
		self.IsReloading = true

		self.Ammo = self.ClipSize
		AmmoUI:SetAmmo(self.Ammo)

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
	AmmoUI = self.Controllers.UI.UIControllers.Ammo
end

return Weapon
