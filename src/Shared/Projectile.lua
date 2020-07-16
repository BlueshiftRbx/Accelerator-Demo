local Projectile = {};
local RunService = game:GetService("RunService")
local Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets")

local VELOCITY = 125;
local GRAVITY = Vector3.new(0,1,0) * 9.81


function Projectile.new(owner, origin, goal)
	assert(typeof(owner) == "Instance" and owner:IsA('Player'), "Owner has to be of Player Instance.")
	assert(typeof(origin) == "Vector3", "Origin has to be of Vector3 type.")
	assert(typeof(goal) == "Vector3", "Goal has to be of Vector3 type.")

	if (RunService:IsClient()) then -- If client then create visual representation of the bullet.
		self.Bullet = Assets.Effects.Bullet:Clone();
		self.Bullet.Parent = workspace.Bullets
	end

	local self = setmetatable({}, Projectile)

	self.Origin = origin;
	self.Goal = goal;
	self.Position = self.Origin;
	self.LastPosition = self.Origin;

	self.Velocity = VELOCITY;
	self.Mass = MASS;
	self.Gravity = GRAVITY;

	self.LookVector = (goal-origin).unit

	return self
end

function Projectile:Step(dt)
	local newGoal = self.Origin + self.LookVector * (self.Velocity * dt) - Vector3.new(0,(GRAVITY*dt),0)
	local didHit, raycastData = self:_Raycast(self.Position, newGoal)

	if not didHit then
		self.LookVector = (newGoal - self.Position).unit
		self.LastPosition = self.Position
		self.Position = newGoal

		local magnitude = (self.Position - self.LastPosition).Magnitude
		self.Bullet.Size = Vector3.new(0.2, 0.2, magnitude) --> Set bullet size to path crossed in step so it gives impression of speed
		self.Bullet.CFrame = CFrame.new(self.LastPosition + (self.LookVector * magnitude/2), self.Position)
	else
		warn("reached something i guess")
	end
end

function Projectile:_Raycast(origin, goal)
	local ray = Ray.new(a, (b - a).unit * (b - a).magnitude)

	local hit, position, normal = workspace:FindPartOnRayWithIgnoreList(ray, {workspace.Characters, workspace.Bullets}, true, true)

	return (not (not hit), {
		Hit = hit; Position = position; Normal = normal
	})
end

return Projectile;
