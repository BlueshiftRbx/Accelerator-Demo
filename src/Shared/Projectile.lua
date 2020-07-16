local Projectile = {};
Projectile.__index = Projectile

local RunService = game:GetService("RunService")
local Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets")

local VELOCITY = 100;
local GRAVITY = 9.81


function Projectile.new(owner, origin, goal)
	assert(typeof(owner) == "Instance" and owner:IsA('Player'), "Owner has to be of Player Instance.")
	assert(typeof(origin) == "Vector3", "Origin has to be of Vector3 type.")
	assert(typeof(goal) == "Vector3", "Goal has to be of Vector3 type.")

	local self = setmetatable({}, Projectile)

	if (RunService:IsClient()) then -- If client then create visual representation of the bullet.
		print('is client')
		self.Bullet = Assets.Effects.BulletA:Clone();
		self.Bullet.Parent = workspace.Bullets
	end

	self.Origin = origin;
	self.Goal = goal;
	self.Position = self.Origin;
	self.LastPosition = self.Origin;

	self.Velocity = VELOCITY;
	self.Mass = MASS;
	self.Gravity = GRAVITY;

	self.LookVector = CFrame.new(origin, goal).LookVector

	return self
end

function Projectile:Step(dt)
	local newPoint = self.Position + self.LookVector * (self.Velocity * dt) - Vector3.new(0, GRAVITY * dt, 0);
	self.Position = newPoint
	self.Bullet.CFrame = CFrame.new(self.Position)
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
