-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- References
local assetsFolder = ReplicatedStorage:WaitForChild("Assets")
local UIFolder = assetsFolder:WaitForChild("UI")
local mainHUD = UIFolder:WaitForChild("MainUI")

local UI = {
	__aeroPreventStart = true;

	UIControllers = {};
}

function UI:Init()

	self.UI = mainHUD:Clone()
	self.UI.Parent = self.Player:WaitForChild("PlayerGui")

	for _,x in pairs(script:GetChildren()) do
		local r = require(x)
		self.UIControllers[x.Name] = r
		setmetatable(r, {__index = UI})
	end

	for _, controller in pairs(self.UIControllers) do
		local initFunc = rawget(controller, "Init")
		if initFunc then
			initFunc(controller)
		end
	end
end

function UI:Start()
	for _, controller in pairs(self.UIControllers) do
		local startFunc = rawget(controller, "Start")
		if startFunc then
			startFunc(controller)
		end
	end
end

return UI;
