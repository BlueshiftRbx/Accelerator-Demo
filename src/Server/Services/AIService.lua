local AIService = {};
local Assets;
local Entity;

local SpawnedUnits = {};

function AIService:Spawn(entityName, ...)
	local entity = Assets:GetEntity(entityName)
	entity.new(...)
end

function AIService:Start()

end

function AIService:Init()
	Assets = self.Shared.Assets
end

return AIService;
