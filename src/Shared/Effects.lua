-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

-- References
local assetsFolder = ReplicatedStorage:WaitForChild("Assets")
local particles = assetsFolder:WaitForChild("Particles")

-- Methods
function GetEffect(name)
	for _,obj in next, particles:GetChildren() do
		if obj.Name == name then
			return obj:Clone()
		end
	end
end

local Effects = {}

function Effects:GetEffect(name)
	local effect = GetEffect(name)

	if effect then
		Debris:AddItem(effect, effect.Lifetime.Max)

		return effect
	end
end

return Effects
