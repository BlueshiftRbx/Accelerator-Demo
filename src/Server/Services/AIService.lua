local AIService = {};
local Assets;
local Entity;

local SpawnedUnits = {};

function AIService:Spawn(entityName)
	local entity = Assets:GetEntity(entityName)

end

function AIService:Start()

end

function AIService:Init()
	Assets = self.Shared.Assets
end

return AIService;
