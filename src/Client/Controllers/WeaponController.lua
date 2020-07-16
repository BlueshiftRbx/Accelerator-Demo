-- Services
local CollectionService = game:GetService("CollectionService")

-- Controllers
local DataController

-- Modules
local Weapon
local Projectile
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
end

function WeaponController:Init()
	DataController = self.Controllers.DataController

	Weapon = self.Modules.Weapon

	Projectile = self.Shared.Projectile
	WeaponInfo = self.Shared.WeaponInfo

	self.Backpack = self.Player:WaitForChild("Backpack")

	self:RegisterEvent("ToolEquipped")
	self:RegisterEvent("ToolUnequipped")
end

function WeaponController:CreateWeapon(tool)
	local info = WeaponInfo[tool.Name]

	if info then
		local weapon = Weapon.new(tool, info)

		if CollectionService:HasTag(tool, PRIMARY_TAG) then
			self._Weapons.Primary = weapon

			if not self._Current then
				self:Equip("Primary")
			end
		elseif CollectionService:HasTag(tool, SECONDARY_TAG) then
			self._Weapons.Secondary = weapon
		end
	end
end
