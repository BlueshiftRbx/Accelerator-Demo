local EntityInfo = {};

for _, entity in next, script:GetChildren() do
	EntityInfo[entity.Name] = require(entity)
end

return EntityInfo
