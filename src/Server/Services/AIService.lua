-- Modules
local Entity
local EntityInfo
local Assets

-- Constants
local UNIT_LIMIT = 80

local AIService = {Units = {}}

function AIService:Spawn(entityName)
    if #self.Units < UNIT_LIMIT then
        local info = EntityInfo:GetInfo(entityName)

        if info then
            local bodyModel = Assets:GetEntity(entityName)

            local entity = Entity.new(bodyModel, info)

            table.insert(self.Units, entity)
        end
    end
end

function AIService:Start()
end

function AIService:Init()
    Entity = self.Modules.Entity
    EntityInfo = self.Shared.EntityInfo
    Assets = self.Shared.Assets
end

return AIService
