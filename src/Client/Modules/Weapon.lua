-- Services
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

-- Controllers
local Cursor
local ProjectileController
local UserInput
local AmmoUI

-- Modules
local Assets
local Maid

-- References
local Player
local Mouse

local Weapon = {}

Weapon.__index = Weapon

function Weapon.new(tool, info)
	local self = setmetatable({}, Weapon)

	-- Object properties
	self.Tool = tool
	self.Handle = tool:WaitForChild("_Handle")
	self.Barrel = self.Handle:WaitForChild("BarrelAttachment")
	self.Humanoid = Player.Character:WaitForChild("Humanoid")

	-- Data properties
	self.ClipSize = info.Config.ClipSize
	self.Ammo = info.Config.ClipSize
	self.FireRate = info.Config.FireRate
	self.FireMode = info.Config.FireMode

	-- Asset properties
	self.HoldAnim = Assets:GetAnimation(info.Anims.HoldAnim)
	self.FiringAnim = Assets:GetAnimation(info.Anims.FiringAnim)

	self.HoldAnim = self.Humanoid:LoadAnimation(self.HoldAnim)

	self.HoldAnim.Name = info.Anims.HoldAnim
	self.HoldAnim.Priority = Enum.AnimationPriority.Movement
	self.HoldAnim.Looped = true

	self.FiringAnim = self.Humanoid:LoadAnimation(self.FiringAnim)

	self.FiringAnim.Name = info.Anims.FiringAnim
	self.FiringAnim.Priority = Enum.AnimationPriority.Action
	self.FiringAnim.Looped = false


	self.FiringSound = Assets:GetSound(info.Sounds.FiringSound)

	self.FiringSound.Parent = self.Handle

	self.ReloadSound = Assets:GetSound(info.Sounds.ReloadSound)

	self.ReloadSound.Parent = self.Handle

	self.FireFX = info.Particles.FireFX

	-- State properties
	self.Busy = false
	self.IsReloading = false

	-- Other properties
	self.Maid = Maid.new()

	-- Setup
	self.Maid:GiveTask(tool.Activated:Connect(function()
		if self.Humanoid.Health > 0 then
			if self.FireMode == "Automatic" then
				local mouse = UserInput:Get("Mouse")

				while mouse:IsButtonPressed(Enum.UserInputType.MouseButton1) do
					if self.Ammo <= 0 then
						break
					end

					if Player.Character then
						if not self.Tool:IsDescendantOf(Player.Character) then
							break
						end
					end

					if self.Humanoid.Health <= 0 then
						break
					end

					self:Fire()

					wait()
				end
			elseif self.FireMode == "Semi" then
				self:Fire()
			end
		end
	end))

	self.Maid:GiveTask(tool.Equipped:Connect(function()
		Cursor:SetEnabled(true)
		AmmoUI:SetAmmo(self.Ammo)
		AmmoUI:SetEnabled(true)

		if not self.HoldAnim.IsPlaying then
			self.HoldAnim:Play()
		end
	end))

	self.Maid:GiveTask(tool.Unequipped:Connect(function()
		Cursor:SetEnabled(false)
		AmmoUI:SetEnabled(false)

		if self.HoldAnim.IsPlaying then
			self.HoldAnim:Stop()
		end
	end))

	self.Maid:GiveTask(UserInput:Get("Keyboard").KeyDown:Connect(function(keycode)
		if keycode == Enum.KeyCode.R then
			self:Reload()
		end
	end))

	return self
end

function Weapon:Fire()
	if not self.Busy and not self.IsReloading and self.Ammo > 0 then
		self.Busy = true

		self.Ammo -= 1
		AmmoUI:SetAmmo(self.Ammo)

		self.FiringAnim:Play()

		if self.FireFX then
			local effect = Assets:GetParticle(self.FireFX)

			if effect then
				Debris:AddItem(effect, effect.Lifetime.Max)

				effect.Parent = self.Barrel

				effect:Emit(3)
			end
		end

		-- NOTE Playing a sound normally sometimes restarts it (SoundService fixes it)
		SoundService:PlayLocalSound(self.FiringSound)

		ProjectileController:CreateProjectile(Player, self.Barrel.WorldPosition, Mouse.Hit.p, self.Tool.Name)

		wait(self.FireRate)

		self.Busy = false
	end
end

function Weapon:Reload()
	if not self.IsReloading and self.Ammo < self.ClipSize then
		self.IsReloading = true

		AmmoUI:SetAmmo("--")
		self.ReloadSound:Play()

		self.ReloadSound.Ended:Wait()

		self.Ammo = self.ClipSize
		AmmoUI:SetAmmo(self.Ammo)

		self.IsReloading = false
	end
end

function Weapon:GetTool()
	return self.Tool
end

function Weapon:Destroy()
	self.Maid:DoCleaning()
end

function Weapon:Init()
	Cursor = self.Controllers.UI.UIControllers.Cursor
	ProjectileController = self.Controllers.ProjectileController
	UserInput = self.Controllers.UserInput
	Assets = self.Shared.Assets
	Maid = self.Shared.Maid
	Player = self.Player
	Mouse = self.Player:GetMouse()
	AmmoUI = self.Controllers.UI.UIControllers.Ammo
end

return Weapon
