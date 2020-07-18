-- Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage

-- Shared references
local sharedAssetsFolder = ReplicatedStorage:WaitForChild("Assets")
local animationsFolder = sharedAssetsFolder:WaitForChild("Animations")
local particlesFolder = sharedAssetsFolder:WaitForChild("Particles")
local soundsFolder = sharedAssetsFolder:WaitForChild("Sounds")

-- Server references
local serverAssetsFolder
local entityFolder
local toolsFolder

local Assets = {}

function Assets:GetParticle(name)
	assert(type(name) == "string", "Name must be a string")

	local particle = particlesFolder:FindFirstChild(name)

	if particle then
		particle = particle:Clone()

		return particle
	end
end

function Assets:GetSound(name)
	assert(type(name) == "string", "Name must be a string")

	local sound = soundsFolder:FindFirstChild(name)

	if sound then
		sound = sound:Clone()

		return sound
	end
end

function Assets:GetAnimation(name)
	assert(type(name) == "string", "Name must be a string")

	local animation = animationsFolder:FindFirstChild(name)

	if animation then
		animation = animation:Clone()

		return animation

	end
end

function Assets:GetEntity(name)
	assert(type(name) == "string", "Name must be a string")
	assert(RunService:IsServer() == true, "Assets:GetEntity must be called on the server")

	local entity = entityFolder:FindFirstChild(name)

	if entity then
		entity = entity:Clone()

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
	if RunService:IsServer() then
		ServerStorage = game:GetService("ServerStorage")

		serverAssetsFolder = ServerStorage:WaitForChild("Assets")
		entityFolder = serverAssetsFolder:WaitForChild("Entities")
		toolsFolder = serverAssetsFolder:WaitForChild("Tools")
	end
end

return Assets
