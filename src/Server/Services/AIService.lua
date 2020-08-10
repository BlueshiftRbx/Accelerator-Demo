-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- References
local spawnFolder = Workspace:WaitForChild("Spawns")

-- Modules
local Entity
local EntityInfo
local Assets

-- Constants
local UNIT_LIMIT = 20

-- Variables
local spawnDB = {} -- NOTE prevents entities from being spawned at the same time

-- Service
local AIService = {Units = {}}

function AIService:Spawn(entityName)
	local info = EntityInfo:GetInfo(entityName)

	if info then
		local bodyModel = Assets:GetEntity(entityName)

		if bodyModel then
			local spawns = spawnFolder:GetChildren()

			if #spawns > 0 then
				local spawnLoc = spawns[math.random(#spawns)]

				if spawnLoc:IsA("BasePart") and not spawnDB[spawnLoc] then
					spawnDB[spawnLoc] = true

					local spawnOffset = Vector3.new(0, spawnLoc.Size.Y/2, 0)
					local bodyOffset = Vector3.new(0, bodyModel:GetExtentsSize().Y/2, 0)

					bodyModel:SetPrimaryPartCFrame(spawnLoc.CFrame + spawnOffset + bodyOffset)

					local entity = Entity.new(bodyModel, info)

					table.insert(self.Units, entity)

					coroutine.wrap(function()
						wait(1)
						spawnDB[spawnLoc] = nil
					end)()
				end
			end
		end
	end
end

function AIService:GetClosestPlayer(entity)
	if not entity.IsDestroyed then
		local closest

		for _, player in next, Players:GetPlayers() do
			if player.Character then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				if humanoid and humanoid.RootPart and humanoid.RootPart:IsDescendantOf(Workspace) and humanoid.Health > 0 then
					local dist = (entity.Humanoid.RootPart.Position - humanoid.RootPart.Position).Magnitude

					if closest and closest.Distance > dist then
						closest = {
							Target = player.Character;
							Distance = dist;
						}
					elseif not closest then
						closest = {
							Target = player.Character;
							Distance = dist;
						}
					end
				end
			end
		end

		return closest
	end
end

function AIService:Start()
	while true do
		if #self.Units < UNIT_LIMIT then
			self:Spawn("Zombie")
		end

		for i,unit in next, self.Units do
			if unit and unit.Humanoid.Health > 0 and unit.Character:IsDescendantOf(Workspace) then
				local targetData = self:GetClosestPlayer(unit)

				if targetData and targetData.Target ~= unit.Target then
					unit:SetTarget(targetData.Target)
				end

				unit:Step()
			else
				if not unit.IsDestroyed then
					unit:Destroy()
				end
				table.remove(self.Units, i)
			end
		end
		wait(0.1)
	end
end

function AIService:Init()
	Entity = self.Modules.Entity
	EntityInfo = self.Shared.EntityInfo
	Assets = self.Shared.Assets
end

return AIService
