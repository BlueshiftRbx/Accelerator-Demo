-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local PathfindingService = game:GetService("PathfindingService")
local AIService

-- Modules
local Maid

-- References
local zombiesFolder = Workspace:WaitForChild("Zombies")

-- Constants
local VALID_STATUS = {
	[Enum.PathStatus.Success] = true;
	[Enum.PathStatus.ClosestNoPath] = true;
	[Enum.PathStatus.ClosestOutOfRange] = true;
}

-- Methods
function Raycast(position1, position2, target)
	if position1 and position2 and target then
		local position = position1
		local direction = (position2 - position1).Unit * (position2 - position1).Magnitude

		local noneTargetPlayers = {}

		for _,player in next, Players:GetPlayers() do
			if player.Character and player.Character ~= target then
				table.insert(noneTargetPlayers, player.Character)
			end
		end

		local rayParams = RaycastParams.new()

		rayParams.FilterDescendantsInstances = {zombiesFolder ,unpack(noneTargetPlayers)}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist
		rayParams.IgnoreWater = true

		local castResult = Workspace:Raycast(position, direction, rayParams)

		return castResult
	end
end

local Entity = {}
Entity.__index = Entity

function Entity.new(entityObject, info)
	local self = setmetatable({}, Entity)

	self.Maid = Maid.new()

	self.Path = PathfindingService:CreatePath({
		AgentRadius = 2;
		AgentHeight = 5;
		AgentCanJump = false;
	})

	self.Character = entityObject
	self.Humanoid = entityObject:WaitForChild("Humanoid")
	self.Info = info

	self.Target = nil
	self.IsMoving = false
	self.IsDestroyed = false

	self.Maid:GiveTask(self.Path)
	self.Maid:GiveTask(self.Humanoid)
	self.Maid:GiveTask(self.Character)

	-- Initialize
	self.Character.Parent = zombiesFolder

	return self
end

function Entity:SetTarget(newTarget)
	if newTarget and newTarget:IsA("Model") then
		if self.Target ~= newTarget then
			if self.isMoving then
				self.isMoving = false
			end

			print("New target:", newTarget)

			self.Target = newTarget
		end
	end
end

function Entity:Step()
	self:DeterminePath()
end

function Entity:DeterminePath()
	if self.Target and self.Target:IsDescendantOf(Workspace) then
		local humanoid = self.Target:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health > 0 then
			local castResult = Raycast(self.Humanoid.RootPart.Position, humanoid.RootPart.Position, self.Target)

			if castResult and castResult.Instance:IsDescendantOf(self.Target) then
				self:MoveTo()
			else
				self:TravelPath()
			end
		end
	end
end

function Entity:MoveTo()
	if self.Target and self.Target:IsDescendantOf(Workspace) then
		if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
			local humanoid = self.Target:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.Health > 0 then
				self.IsMoving = true

				self.Humanoid:MoveTo(humanoid.RootPart.Position)
			end
		end
	end
end

function Entity:TravelPath()
	if self.Target and self.Target:IsDescendantOf(Workspace) then
		if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
			local humanoid = self.Target:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.Health > 0 then
				self.Path:ComputeAsync(self.Humanoid.RootPart.Position, humanoid.RootPart.Position)
				if VALID_STATUS[self.Path.Status] then
					print("Valid path status")
					self.IsMoving = true

					for _,waypoint in next, self.Path:GetWaypoints() do
						if not self.IsMoving then
							break
						end

						self.Humanoid:MoveTo(waypoint.Position)
						self.Humanoid.MoveToFinished:Wait()
					end

					self.IsMoving  = false
				end
			end
		end
	end
end

function Entity:TakeDamage(damage)
	if damage > 0 then
		self.Humanoid:TakeDamage(damage)

		if self.Humanoid.Health <= 0 then
			self:Destroy()
		end
	end
end

function Entity:Destroy()
	if not self.IsDestroyed then
		self.IsDestroyed = true
		-- Play death animation
		-- Ragdoll?
		-- Delete after X seconds
		self.Maid:DoCleaning()
	end
end

function Entity:Init()
	AIService = self.Services.AIService
	Maid = self.Shared.Maid
end

return Entity
