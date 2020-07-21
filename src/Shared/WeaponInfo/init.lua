local WeaponInfo = {
	_Weapons = {};
}

function WeaponInfo:GetInfo(name)
	return self._Weapons[name]
end

function WeaponInfo:Init()
	for _,mod in next, script:GetChildren() do
		self._Weapons[mod.Name] = require(mod)
	end
end

return WeaponInfo
