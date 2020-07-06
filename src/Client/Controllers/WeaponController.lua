-- Weapon Controller
-- metaprogramming
-- July 6, 2020

-- Classes
local Gun
local Melee
local Throwable

-- Modules
local WeaponInfo

-- Controller
local WeaponController = {
	Primary = nil;
	Secondary = nil;
	Equipment = nil;
	Grenade = nil;
	SpecialGrenade = nil;
}

function WeaponController:Start()

end


function WeaponController:Init()
	Gun = self.Modules.GunClass
	Melee = self.Modules.MeleeClass
	Throwable = self.Modules.ThrowableClass

	WeaponInfo = self.Shared.WeaponInfo

	self:RegisterEvent("WeaponChanged")
	self:RegisterEvent("WeaponEquipped")
	self:RegisterEvent("WeaponUnequipped")
end

function WeaponController:SetPrimary(weaponName)
	local info = WeaponInfo:GetInfo(weaponName)
	if info then
		-- do stuff
		self:FireEvent("WeaponChanged", "Primary")
	end
end

function WeaponController:SetSecondary(weaponName)
	local info = WeaponInfo:GetInfo(weaponName)
	if info then
		-- do stuff
		self:FireEvent("WeaponChanged", "Secondary")
	end
end

function WeaponController:SetEquipment(equipmentName)
	local info = WeaponInfo:GetInfo(equipmentName)
	if info then
		-- do stuff
		self:FireEvent("WeaponChanged", "Equipment")
	end
end

function WeaponController:SetGrenade(grenadeName)
	local info = WeaponInfo:GetInfo(grenadeName)
	if info then
		-- do stuff
		self:FireEvent("WeaponChanged", "Grenade")
	end
end

function WeaponController:SetSpecialGrenade(grenadeName)
	local info = WeaponInfo:GetInfo(grenadeName)
	if info then
		-- do stuff
		self:FireEvent("WeaponChanged", "SpecialGrenade")
	end
end

return WeaponController
