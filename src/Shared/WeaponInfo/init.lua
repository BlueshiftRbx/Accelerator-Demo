local WeaponInfo = {};

for _, weapon in next, script:GetChildren() do
	WeaponInfo[weapon.Name] = require(weapon)
end

return WeaponInfo
