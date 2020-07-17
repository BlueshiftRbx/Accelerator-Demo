-- Services
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

-- Modules
local Weapon
local WeaponInfo
local Maid

local WeaponController = {
	_Current = nil;

	_Weapons = {
		Primary = nil;
		Secondary = nil;
	};
}

function WeaponController:Start()
	Maid = Maid.new()

	self.Backpack.ChildAdded:Connect(function(obj)
		if obj:IsA("Tool") and CollectionService:HasTag(obj, "Weapon") then
			WeaponController:RegisterWeapon(obj)
		end
	end)

	self.Player.CharacterAdded:Connect(function(character)
		self.Humanoid = character:WaitForChild("Humanoid")

		self.Humanoid.Died:Connect(function()
			self._Current = nil
			self._Weapons.Primary = nil
			self._Weapons.Secondary = nil
			self.Humanoid = nil

			Maid:DoCleaning()
		end)
	end)
end

function WeaponController:Init()
	Weapon = self.Modules.Weapon

	WeaponInfo = self.Shared.WeaponInfo

	Maid = self.Shared.Maid

	self.Backpack = self.Player:WaitForChild("Backpack")

	local character = self.Player.Character or self.Player.CharacterAdded:Wait()

	self.Humanoid = character:WaitForChild("Humanoid")

	self:RegisterEvent("ToolEquipped")
	self:RegisterEvent("ToolUnequipped")
end

function WeaponController:RegisterWeapon(tool)
	if CollectionService:HasTag(tool, "Primary") then
		local info = WeaponInfo[tool.Name]

		if info then
			local weapon = Weapon.new(tool, info)

			self._Weapons.Primary = weapon

			Maid:GiveTask(weapon)

			if not self._Current then
				self:Equip("Primary")
			end
		end
	elseif CollectionService:HasTag(tool, "Secondary") then
		local info = WeaponInfo[tool.Name]

		if info then
			local weapon = Weapon.new(tool, info)

			self._Weapons.Secondary = weapon

			Maid:GiveTask(weapon)

			if not self._Current then
				self:Equip("Secondary")
			end
		end
	end
end

function WeaponController:Equip(slot)
	if slot and slot ~= self._Current then
		local weapon = self._Weapons[slot]

		if weapon then
			if self._Current then
				self:Unequip()
			end

			local tool = weapon:GetTool()

			if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
				self.Humanoid:Equip(tool)

				self:FireEvent("ToolEquipped")
			end
		end
	end
end

function WeaponController:Unequip()
	if self._Current then
		local weapon = self._Weapons[self._Current]

		if weapon then
			if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
				self.Humanoid:UnequipTools()

				self:FireEvent("ToolUnequipped")
			end
		end
	end
end

return WeaponController
