local Entity = {}
Entity.__index = Entity

function Entity.new(entityObject, info)
    local self = setmetatable({}, Entity)

    self.Model = entityObject
    self.Humanoid = entityObject:WaitForChild("Humanoid")

    return self
end

function Entity:TakeDamage(damage)
    if damage > 0 then

    end
end

function Entity:Step()

end

return Entity
