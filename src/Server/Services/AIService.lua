-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- References
local spawnFolder = Workspace:WaitForChild("Spawns")

-- Modules
local EntityInfo
local Entity
local Maid
local Assets

-- Constants
local UNIT_LIMIT = 20

-- Variables
local spawnLock = {}

-- Service
local AIService = {Units = {}}

function AIService:Spawn(entityName)
	local info = EntityInfo:GetInfo(entityName)

	if info then
		local bodyModel = Assets:GetEntity(entityName)

		if bodyModel then
			local chosenSpawn

			for _,spawnLoc in next, spawnFolder:GetChildren() do
				if not spawnLock[spawnLoc] then
					spawnLock[spawnLoc] = true

					chosenSpawn = spawnLoc
				end
			end

			if chosenSpawn then
				local entity = Entity.new(bodyModel, info)

				coroutine.wrap(function()
					if chosenSpawn:IsA("Model") then
						local start = chosenSpawn:FindFirstChild("Start")
						local finish = chosenSpawn:FindFirstChild("Finish")

						if start and finish then
							local spawnOffset = Vector3.new(0, start.Size.Y/2, 0)
							local sizeOffset = Vector3.new(0, entity.Character:GetExtentsSize().Y/2, 0)

							entity.Humanoid.RootPart.CFrame = start.CFrame + spawnOffset + sizeOffset

							entity.Humanoid:MoveTo(finish.Position)

							self.Maid[entity] = entity.Humanoid.MoveToFinished:Connect(function()
								self.Maid[entity] = nil

								entity.IsInSpawn = false
							end)

							wait(2)
						end
					elseif chosenSpawn:IsA("Part") then
						local tInfo = TweenInfo.new(
							1,
							Enum.EasingStyle.Quad,
							Enum.EasingDirection.Out
						)

						local spawnOffset = Vector3.new(0, chosenSpawn.Size.Y/2, 0)
						local sizeOffset = Vector3.new(0, entity.Character:GetExtentsSize().Y/2, 0)
						local rootPart = entity.Humanoid.RootPart

						local props = {
							["CFrame"] = chosenSpawn.CFrame + spawnOffset + sizeOffset
						}

						local tween = TweenService:Create(rootPart, tInfo, props)

						rootPart.CFrame = chosenSpawn.CFrame - spawnOffset - sizeOffset

						rootPart.Anchored = true

						tween:Play()

						self.Maid[tween] = tween.Completed:Connect(function()
							self.Maid[tween] = nil

							rootPart.Anchored = false

							entity.IsInSpawn = false
						end)

						wait(2)
					end

					spawnLock[chosenSpawn] = nil
				end)()

				table.insert(self.Units, entity)
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

				if humanoid and humanoid.Health > 0 and humanoid.RootPart and humanoid.RootPart:IsDescendantOf(Workspace) then
					if entity.Humanoid and entity.Humanoid.Health > 0 and entity.Humanoid.RootPart and entity.Humanoid.RootPart:IsDescendantOf(Workspace) then
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
		end

		return closest
	end
end

function AIService:Start()
	self.Maid = Maid.new()

	while true do
		if #self.Units < UNIT_LIMIT then
			self:Spawn("Zombie")
		end

		for i,unit in next, self.Units do
			if unit and unit.Humanoid.Health > 0 and unit.Character:IsDescendantOf(Workspace) then
				if not unit.IsInSpawn then
					local targetData = self:GetClosestPlayer(unit)

					if targetData and targetData.Target ~= unit.Target then
						unit:SetTarget(targetData.Target)
					end

					unit:Step()
				end
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
	EntityInfo = self.Shared.EntityInfo
	Entity = self.Modules.Entity
	Maid = self.Shared.Maid
	Assets = self.Shared.Assets
end

return AIService
