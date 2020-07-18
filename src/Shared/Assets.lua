-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local ServerStorage

-- Modules
local WeaponInfo

-- Shared references
local assetsFolder = ReplicatedStorage:WaitForChild("Assets")
local particlesFolder = assetsFolder:WaitForChild("Particles")
local soundsFolder = assetsFolder:WaitForChild("Sounds")

-- Server references
local entityFolder
local toolsFolder

local Assets = {}

function Assets:GetParticle(name, duration)
	assert(type(name) == "string", "Name must be a string")

	local particle = particlesFolder:FindFirstChild(name)

	if particle then
		particle = particle:Clone()

		if duration then
			Debris:AddItem(particle, duration)
		end

		return particle
	end
end

function Assets:GetSound(name, duration)
	assert(type(name) == "string", "Name must be a string")

	local sound = soundsFolder:FindFirstChild(name)

	if sound then
		sound = sound:Clone()

		if duration then
			Debris:AddItem(sound, duration)
		end

		return sound
	end
end

function Assets:GetAnimation(name, duration)
	assert(type(name) == "string", "Name must be a string")
end

function Assets:GetEntity(name, duration)
	assert(type(name) == "string", "Name must be a string")
	assert(RunService:IsServer() == true, "Assets:GetEntity must be called on the server")

	local entity = entityFolder:FindFirstChild(name)

	if entity then
		entity = entity:Clone()

		if duration then
			Debris:AddItem(entity, duration)
		end

		return entity
	end
end

function Assets:GetTool(name)
	assert(type(name) == "string", "Name must be a string")
	assert(RunService:IsServer() == true, "Assets:GetTool must be called on the server")

	local tool = toolsFolder:FindFirstChild(name)

	if tool then
		tool = tool:Clone()

		return tool
	end
end

function Assets:Init()
	WeaponInfo = self.Shared.WeaponInfo

	if RunService:IsServer() then
		ServerStorage = game:GetService("ServerStorage")

		entityFolder = ServerStorage:WaitForChild("Entities")
		toolsFolder = ServerStorage:WaitForChild("Tools")
	end
end

return Assets
