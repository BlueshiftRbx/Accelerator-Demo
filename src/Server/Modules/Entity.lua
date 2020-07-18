local Entity = {};
Entity.__index = Entity;

function Entity.new(entityObject)
	local self = setmetatable({
		Model = entityObject;
	}, Entity)

	self.Info = self.Shared.EntityInfo[entityObject.Name]

	return self
end

function Entity:Step()

end

return Entity;
