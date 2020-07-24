local AIService = {
	Entities = {};
}

AIService.ENTITY_LIMIT = 1;
AIService.ENTITY_SPAWN_DELAY = 2;
AIService.PATH_UPDATE_DELAY = 5;
AIService.STEP_DELAY = 5;

local Assets;
local Entity;
local EntityInfo;
local Thread;

function AIService:Spawn(entityName)
	local entityModel = Assets:GetEntity(entityName)
	local entityInfo = EntityInfo:GetInfo(entityName)

	if entityModel and entityInfo then
		self.Entities[#self.Entities+1] = Entity.new(entityModel, entityInfo)
	end
end

function AIService:Start()
	Thread.Spawn(function() --> Spawn loop
		while wait(self.ENTITY_SPAWN_DELAY) do
			if #self.Entities < self.ENTITY_LIMIT then
				self:Spawn("Zombie")
			end
		end
	end)

	Thread.Spawn(function() --> Pathfinding update loop
		while wait(self.PATH_UPDATE_DELAY) do
			for _, entity in next, self.Entities do
				entity:UpdatePath()
			end
		end
	end)

	Thread.Spawn(function() --> Step loop
		while wait(self.STEP_DELAY) do
			for i=#self.Entities, 1, -1 do
				local entity = self.Entities[i]
				if entity._Destroyed then
					table.remove(self.Entities, i);
				end
			end
		end
	end)
end

function AIService:Init()
	Entity = self.Modules.Entity;
	EntityInfo = self.Shared.EntityInfo;
	Assets = self.Shared.Assets;
	Thread = self.Shared.Thread;
end

return AIService
