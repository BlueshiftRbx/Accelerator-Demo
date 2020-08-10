-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Modules
local Assets
local Maid

-- References
local zombiesFolder = Workspace:WaitForChild("Zombies")

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

function UpdateAnimForDampening(humanoid, anim, speed)
	local scaledSpeed = ((speed/16.0)*1.25)/(humanoid.HipHeight/1.35)
	local baseWeight = 0.001

	if anim.Speed ~= scaledSpeed then
		if scaledSpeed < 0.33 then
			anim:AdjustWeight(baseWeight)
		elseif scaledSpeed < 0.66 then
			local weight = (scaledSpeed - 0.33) / 0.33
			anim:AdjustWeight(baseWeight + weight)
		else
			anim:AdjustWeight(1.0)
		end

		anim:AdjustSpeed(scaledSpeed)
	end
end

-- Module
local Entity = {}
Entity.__index = Entity

function Entity.new(entityObject, info)
	local self = setmetatable({}, Entity)

	self.Maid = Maid.new()

	self.Character = entityObject
	self.Humanoid = entityObject:WaitForChild("Humanoid")

	self.Target = nil

	self.AttackDistance = info.Config.AttackDistance
	self.AttackDamage = info.Config.AttackDamage
	self.WalkSpeed = info.Config.WalkSpeed

	self.IsInSpawn = true
	self.IsAttacking = false
	self.IsMoving = false
	self.IsDestroyed = false

	-- Cleanup
	self.Maid:GiveTask(self.Character)

	-- Initialize
	self.Humanoid.MaxHealth = info.Config.Health
	self.Humanoid.Health = info.Config.Health
	self.Humanoid.WalkSpeed = info.Config.WalkSpeed

	self.Character.Parent = zombiesFolder

	-- Animations
	self.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	self.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	self.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)

	self.IdleAnim = Assets:GetAnimation(info.Animations.IdleAnim)
	self.RunAnim = Assets:GetAnimation(info.Animations.RunAnim)
	self.JumpAnim = Assets:GetAnimation(info.Animations.JumpAnim)
	self.FallAnim = Assets:GetAnimation(info.Animations.FallAnim)
	self.AttackAnim = Assets:GetAnimation(info.Animations.AttackAnim)

	self.IdleAnim = self.Humanoid:LoadAnimation(self.IdleAnim)
	self.RunAnim = self.Humanoid:LoadAnimation(self.RunAnim)
	self.JumpAnim = self.Humanoid:LoadAnimation(self.JumpAnim)
	self.FallAnim = self.Humanoid:LoadAnimation(self.FallAnim)
	self.AttackAnim = self.Humanoid:LoadAnimation(self.AttackAnim)

	self.IdleAnim.Name = "IdleAnim"
	self.RunAnim.Name = "RunAnim"
	self.JumpAnim.Name = "JumpAnim"
	self.FallAnim.Name = "FallAnim"
	self.AttackAnim.Name = "AttackAnim"

	self.IdleAnim.Priority = Enum.AnimationPriority.Idle
	self.RunAnim.Priority = Enum.AnimationPriority.Movement
	self.JumpAnim.Priority = Enum.AnimationPriority.Action
	self.FallAnim.Priority = Enum.AnimationPriority.Movement
	self.AttackAnim.Priority = Enum.AnimationPriority.Action

	self.IdleAnim.Looped = true
	self.RunAnim.Looped = true
	self.JumpAnim.Looped = false
	self.FallAnim.Looped = true
	self.AttackAnim.Looped = false

	self.IdleAnim:Play()

	self.Maid:GiveTask(self.Humanoid.Jumping:Connect(function(isJumping)
		if isJumping then
			if not self.JumpAnim.IsPlaying then
				self.JumpAnim:Play()
			end
		elseif not isJumping then
			if self.JumpAnim.IsPlaying then
				self.JumpAnim:Stop()
			end
		end
	end))

	self.Maid:GiveTask(self.Humanoid.FreeFalling:Connect(function(isFalling)
		if isFalling then
			if not self.FallAnim.IsPlaying then
				self.FallAnim:Play()
			end
		elseif not isFalling then
			if self.FallAnim.IsPlaying then
				self.FallAnim:Stop()
			end
		end
	end))

	self.Maid:GiveTask(self.Humanoid.Running:Connect(function(speed)
		if speed > 0 or speed < 0 then
			if not self.RunAnim.IsPlaying then
				self.RunAnim:Play()
				UpdateAnimForDampening(self.Humanoid, self.RunAnim, speed)
			end
		elseif speed == 0 then
			if self.RunAnim.IsPlaying then
				self.RunAnim:Stop()
			end
		end
	end))

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

				self.Maid["MoveToFinished"] = self.Humanoid.MoveToFinished:Connect(function()
					self.Maid["MoveToFinished"] = nil

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
								if magnitude <= self.AttackDistance then
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

			self.Humanoid.WalkSpeed = (self.WalkSpeed - (self.WalkSpeed / 4))

			self.AttackAnim:Play()

			self.Maid[self.AttackAnim] = self.AttackAnim.Stopped:Connect(function()
				self.Maid[self.AttackAnim] = nil

				targetHum:TakeDamage(self.AttackDamage)

				self.Humanoid.WalkSpeed = self.WalkSpeed

				self.IsAttacking = false
			end)
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
