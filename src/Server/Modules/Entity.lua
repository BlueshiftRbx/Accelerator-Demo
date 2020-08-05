-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Modules
local Assets
local Maid

-- References
local zombiesFolder = Workspace:WaitForChild("Zombies")

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

	self.Character = entityObject
	self.Humanoid = entityObject:WaitForChild("Humanoid")
	self.Info = info

	self.Target = nil
	self.IsAttacking = false
	self.IsMoving = false
	self.IsDestroyed = false

	-- Cleanup
	self.Maid:GiveTask(self.Humanoid)
	self.Maid:GiveTask(self.Character)

	-- Initialize
	self.Humanoid.MaxHealth = info.Health
	self.Humanoid.Health = info.Health

	self.Character.Parent = zombiesFolder

	-- Animations
	self.AttackAnim = Assets:GetAnimation(self.Info.Animations.AttackAnim)

	self.AttackAnim = self.Humanoid:LoadAnimation(self.AttackAnim)

	self.AttackAnim.Name = "AttackAnim"
	self.AttackAnim.Priority = Enum.AnimationPriority.Action
	self.AttackAnim.Looped = false

	return self
end

function Entity:SetTarget(newTarget)
	if newTarget and newTarget:IsA("Model") then
		if self.Target ~= newTarget then
			if self.isMoving then
				self.isMoving = false
			end

			self.Target = newTarget
		end
	end
end

function Entity:Step()
	self:MoveTo()
end

function Entity:MoveTo()
	if self.Target and self.Target:IsDescendantOf(Workspace) then
		if self.Humanoid and self.Humanoid:IsDescendantOf(Workspace) then
			local humanoid = self.Target:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.Health > 0 then
				if self.IsMoving then
					self.IsMoving = false
				end

				self.IsMoving = true

				self.Humanoid:MoveTo(humanoid.RootPart.Position)

				local signal

				signal = self.Humanoid.MoveToFinished:Connect(function()
					signal:Disconnect()
					self.IsMoving = false
				end)

				coroutine.wrap(function()
					while self.IsMoving and not self.IsDestroyed do
						local castResult = Raycast(
							self.Humanoid.RootPart.Position,
							humanoid.RootPart.Position,
							self.Target
						)

						-- Jump if there's something blocking the path
						if castResult then
							local magnitude = (castResult.Position - self.Humanoid.RootPart.Position).Magnitude
							if castResult.Instance:IsDescendantOf(self.Target) then
								if magnitude <= self.Info.AttackDistance then
									self:Attack(humanoid)
								end
							elseif not castResult.Instance:IsDescendantOf(self.Target) then
								if magnitude <= 1 then
									self.Humanoid.Jump = true
								end
							end
						end
						if castResult and not castResult.Instance:IsDescendantOf(self.Target) then
							local magnitude = (castResult.Position - self.Humanoid.RootPart.Position).Magnitude

							if magnitude <= 1 then
								self.Humanoid.Jump = true
							end
						end

						wait(0.1)
					end
				end)()
			end
		end
	end
end

function Entity:Attack(targetHum)
	if targetHum and targetHum.Health > 0 then
		if not self.IsAttacking then
			self.IsAttacking = true

			self.AttackAnim:Play()

			wait(self.AttackAnim.Length)

			targetHum:TakeDamage(self.Info.AttackDamage)

			self.IsAttacking = false
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
	Maid = self.Shared.Maid
	Assets = self.Shared.Assets
end

return Entity
