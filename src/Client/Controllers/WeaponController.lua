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
	_Weapons = {
		Primary = nil;
		Secondary = nil;
	};
}

function OnChildAdded(obj)
	if obj:IsA("Tool") and CollectionService:HasTag(obj, WEAPON_TAG) then
		if CollectionService:HasTag(obj, PRIMARY_TAG) then
			WeaponController:CreateWeapon(tool)
		elseif CollectionService:HasTag(obj, SECONDARY_TAG) then
			WeaponController:CreateWeapon(tool)
		end
	end
end

function WeaponController:Start()
	self.Backpack.ChildAdded:Connect(OnChildAdded)
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
		elseif CollectionService:HasTag(tool, SECONDARY_TAG) then
			self._Weapons.Secondary = weapon
		end
	end
end
