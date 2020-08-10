-- Services
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

-- Modules
local UserInput
local Weapon
local WeaponInfo
local Maid

local WeaponController = {
	_Current = nil;

	_Weapons = {
		Primary = nil;
		Secondary = nil;
	};

	Character = nil;
	Humanoid = nil;
}

function WeaponController:RegisterWeapon(tool)
	if not CollectionService:HasTag(tool, "Registered") then
		if CollectionService:HasTag(tool, "Primary") then
			local info = WeaponInfo:GetInfo(tool.Name)

			if info then
				CollectionService:AddTag(tool, "Registered")

				local weapon = Weapon.new(tool, info)

				self._Weapons.Primary = weapon

				Maid:GiveTask(weapon)

				if not self._Current then
					--self:Equip("Primary")
				end
			end
		elseif CollectionService:HasTag(tool, "Secondary") then
			local info = WeaponInfo:GetInfo(tool.Name)

			if info then
				CollectionService:AddTag(tool, "Registered")

				local weapon = Weapon.new(tool, info)

				self._Weapons.Secondary = weapon

				Maid:GiveTask(weapon)

				if not self._Current then
					--self:Equip("Secondary")
				end
			end
		end
	end
end

function WeaponController:Equip(slot)
	if slot and slot ~= self._Current then
		local weapon = self._Weapons[slot]
		if weapon then
			self._LastEquipped = slot
			if self._Current then
				self:Unequip()
			end

			local tool = weapon:GetTool()
			self._Current = slot
			if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
				self.Humanoid:EquipTool(tool)

				-- weapon:OnEquipped()

				self:FireEvent("ToolEquipped")
			end
		end
	end
end

function WeaponController:GetCurrentWeapon()
	if self._Current then
		local weapon = self._Weapons[self._Current]

		return weapon
	end
end

function WeaponController:Unequip()
	local weapon = self:GetCurrentWeapon()

	if weapon then
		self._Current = nil
		if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
			self.Humanoid:UnequipTools()

			-- weapon:OnUnequipped()

			self:FireEvent("ToolUnequipped")
		end
	end
end

function WeaponController:CharacterAdded(newCharacter)
	Maid:DoCleaning()
	if newCharacter then
		self.Character = newCharacter
		self.Humanoid = self.Character:WaitForChild("Humanoid")
		self.Backpack = self.Player:WaitForChild("Backpack")

		--// Tool recognition
		Maid:GiveTask(self.Backpack.ChildAdded:Connect(function(child)
			if child:IsA("Tool") and CollectionService:HasTag(child, "Weapon") then
				self:RegisterWeapon(child)
			end
		end))

		for _, child in pairs(self.Backpack:GetChildren()) do
			if child:IsA("Tool") and CollectionService:HasTag(child, "Weapon") then
				self:RegisterWeapon(child)
			end
		end
	end
end

function WeaponController:Start()
	Maid = Maid.new()

	local keyboard = UserInput:Get("Keyboard")
	keyboard.KeyDown:Connect(function(key)
		--print(key)
		if key == Enum.KeyCode.Backquote then
			if self._Current then
				self:Unequip()
			else
				if self._LastEquipped then
					self:Equip(self._LastEquipped)
				else
					if self._Weapons.Primary then
						self:Equip("Primary")
					elseif self._Weapons.Secondary then
						self:Equip("Secondary")
					end
				end
			end
		end
	end)

	self.Player.CharacterAdded:Connect(function(newCharacter)
		self:CharacterAdded(newCharacter)
	end)
	self:CharacterAdded(self.Player.Character)
end

function WeaponController:Init()
	UserInput = self.Controllers.UserInput
	Weapon = self.Modules.Weapon
	WeaponInfo = self.Shared.WeaponInfo
	Maid = self.Shared.Maid

	self:RegisterEvent("ToolEquipped")
	self:RegisterEvent("ToolUnequipped")
end

return WeaponController
