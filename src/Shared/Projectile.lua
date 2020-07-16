local Projectile = {};
Projectile.__index = Projectile

local RunService = game:GetService("RunService")
local Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets")

local VELOCITY = 60;
local GRAVITY = 9.81
local MASS = 0.01


function Projectile.new(owner, origin, goal)
	assert(typeof(owner) == "Instance" and owner:IsA('Player'), "Owner has to be of Player Instance.")
	assert(typeof(origin) == "Vector3", "Origin has to be of Vector3 type.")
	assert(typeof(goal) == "Vector3", "Goal has to be of Vector3 type.")

	local self = setmetatable({}, Projectile)

	self.Origin = origin;
	self.Goal = goal;
	self.Position = self.Origin;
	self.LastPosition = self.Origin;

	self.Velocity = VELOCITY;

	self.LookVector = CFrame.new(origin, goal).LookVector

	if (RunService:IsClient()) then -- If client then create visual representation of the bullet.
		self.Bullet = Assets.Effects.Bullet:Clone();
		self.Bullet.CFrame = CFrame.new(self.Origin)
		self.Bullet.Parent = workspace.Bullets
	end

	return self
end

function Projectile:Step(dt)
	local newPosition = self.Position + self.LookVector * (self.Velocity * dt) - Vector3.new(0, GRAVITY * dt * MASS, 0);

	local didHit, raycastData = self:_Raycast(self.Position, newPosition)
	if didHit then
		return true
	else
		self.LookVector = CFrame.new(self.Position, newPosition).LookVector
		self.LastPosition = self.Position
		self.Position = newPosition

		local magnitude = (self.LastPosition - self.Position).Magnitude
		self.Bullet.Size = Vector3.new(0.2, 0.2, magnitude)
		self.Bullet.CFrame = CFrame.new(self.LastPosition+self.LookVector*(magnitude/2), self.Position)
	end
end

function Projectile:_Raycast(a, b)
	local ray = Ray.new(a, (b - a).unit * (b - a).magnitude)

	local hit, position, normal = workspace:FindPartOnRayWithIgnoreList(ray, {workspace.Characters, workspace.Bullets}, true, true)

	return hit~=nil, {
		Hit = hit; Position = position; Normal = normal
	}
end

function Projectile:Destroy()
	if self.Bullet then self.Bullet:Destroy() end
end

return Projectile;
