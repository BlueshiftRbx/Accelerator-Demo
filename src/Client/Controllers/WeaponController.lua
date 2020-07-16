-- Services
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

-- Controllers
local DataController

-- Modules
local Weapon
local ProjectileController
local WeaponInfo

-- Variables
local WEAPON_TAG = "Weapon"
local PRIMARY_TAG = "Primary"
local SECONDARY_TAG = "Secondary"

local WeaponController = {
	_Current = nil;

	_Weapons = {
		Primary = nil;
		Secondary = nil;
	};
}

function WeaponController:Start()
	self.Backpack.ChildAdded:Connect(function(obj)
		if obj:IsA("Tool") and CollectionService:HasTag(obj, WEAPON_TAG) then
			WeaponController:CreateWeapon(obj)
		end
	end)

	self.Player.CharacterAdded:Connect(function(character)
		self.Humanoid = character:WaitForChild("Humanoid")
		self:EquipLast()
	end)
end

function WeaponController:Init()
	DataController = self.Controllers.DataController

	Weapon = self.Modules.Weapon

	ProjectileController = self.Controllers.ProjectileController
	WeaponInfo = self.Shared.WeaponInfo

	self.Backpack = self.Player:WaitForChild("Backpack")

	local character = self.Player.Character or self.Player.CharacterAdded:Wait()

	self.Humanoid = character:WaitForChild("Humanoid")

	self:RegisterEvent("ToolEquipped")
	self:RegisterEvent("ToolUnequipped")
end

function WeaponController:CreateWeapon(tool)
	local info = WeaponInfo[tool.Name]

	if info then
		local weapon = Weapon.new(tool, info)

		if CollectionService:HasTag(tool, PRIMARY_TAG) then
			if not self._Weapons.Primary then
				self._Weapons.Primary = weapon

				if not self._Current then
					self:Equip("Primary")
				end
			end
		elseif CollectionService:HasTag(tool, SECONDARY_TAG) then
			if not self._Weapons.Secondary then
				self._Weapons.Secondary = weapon
			end
		end
	end
end

function WeaponController:Equip(slotName)
	if self._Current then
		self:UnequipCurrent()
	end

	local weapon = self._Weapons[slotName]

	if weapon then
		local tool = weapon:GetTool()

		if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
			self.Humanoid:EquipTool(tool)

			self:FireEvent("ToolEquipped")
		end
	end
end

function WeaponController:UnequipCurrent()
	if self._Current then
		local weapon = self._Weapons[self._Current]

		if weapon then
			local tool = weapon:GetTool()

			if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
				self.Humanoid:UnequipTools()

				self:FireEvent("ToolUnequipped")
			end
		end
	end
end

return WeaponController
