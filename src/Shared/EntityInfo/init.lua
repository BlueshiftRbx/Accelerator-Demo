local EntityInfo = {
	_Entities = {};
}

function EntityInfo:GetInfo(name)
	return self._Entities[name]
end

function EntityInfo:Init()
	for _,mod in next, script:GetChildren() do
		self._Entities[mod.Name] = require(mod)
	end
end

return EntityInfo
