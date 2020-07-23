-- Services
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local BulletService

-- Modules
local Assets

-- References
local charactersFolder = Workspace:WaitForChild("Characters")
local bulletsFolder = Workspace:WaitForChild("Bullets")
local Player

-- Constants
local VELOCITY = 1000
local GRAVITY = 9.81
local MASS = 0.025

-- Methods
function LookAtCF(origin, direction) -- NOTE Creates a CFrame object from origin looking at direction
	assert(typeof(origin) == "Vector3", "Origin must be a Vector3")
	assert(typeof(direction) == "Vector3", "Direction must be a Vector3")

	local frontVect = (direction - origin).Unit
	local upVect = Vector3.new(0, 1, 0)
	local rightVect = frontVect:Cross(upVect)
	local upVect2 = rightVect:Cross(frontVect)

	return CFrame.fromMatrix(direction, rightVect, upVect2, rightVect:Cross(upVect2).Unit)
end

local Projectile = {}
Projectile.__index = Projectile

function Projectile.new(owner, origin, goal)
	assert(typeof(owner) == "Instance" and owner:IsA('Player'), "Owner has to be of Player Instance.")
	assert(typeof(origin) == "Vector3", "Origin has to be of Vector3 type.")
	assert(typeof(goal) == "Vector3", "Goal has to be of Vector3 type.")

	local self = setmetatable({}, Projectile)

	self.Origin = origin
	self.Goal = goal
	self.Position = self.Origin
	self.LastPosition = self.Origin

	self.Velocity = VELOCITY

	self.LookVector = LookAtCF(origin, goal).LookVector

	if (RunService:IsClient()) then -- If client then create visual representation of the bullet.
		self.Bullet = Assets:GetBullet("Bullet")
		self.Bullet.CFrame = CFrame.new(self.Origin)
		self.Bullet.Parent = bulletsFolder
	end

	if (Player and Player == owner) then
		BulletService:Replicate(origin, goal)
	end

	return self
end

function Projectile:Step(dt)
	local newPosition = self.Position + self.LookVector * (self.Velocity * dt) - Vector3.new(0, GRAVITY * dt * MASS, 0)

	local castResult = self:Raycast(self.Position, newPosition)

	if castResult then
		return castResult
	else
		self.LookVector = LookAtCF(self.Position, newPosition).LookVector
		self.LastPosition = self.Position
		self.Position = newPosition

		local magnitude = (self.LastPosition - self.Position).Magnitude

		self.Bullet.Size = Vector3.new(0.2, 0.2, magnitude)
		self.Bullet.CFrame = LookAtCF(self.LastPosition + self.LookVector * (magnitude/2), self.Position)
		self.Bullet.StartAttachment.Position = Vector3.new(0, 0, -magnitude/2)
		self.Bullet.EndAttachment.Position = Vector3.new(0, 0, magnitude/2)

		return false
	end
end

function Projectile:Raycast(position1, position2)
	local position = position1
	local direction = (position2 - position1).Unit * (position2 - position1).Magnitude

	local rayParams = RaycastParams.new()

	rayParams.FilterDescendantsInstances = {charactersFolder, bulletsFolder}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	rayParams.IgnoreWater = true

	local castResult = Workspace:Raycast(position, direction, rayParams)

	return castResult
end

function Projectile:Destroy()
	if self.Bullet then
		self.Bullet:Destroy()
	end
end

function Projectile:Init()
	BulletService = self.Services.BulletService
	Assets = self.Shared.Assets

	if RunService:IsClient() then
		Player = self.Player
	end
end

return Projectile
