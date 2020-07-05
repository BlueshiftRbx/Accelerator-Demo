local UI = {
	UIControllers = {};
};
UI.__aeroPreventStart = true; -- Start is ran by ReplicatedFirst script!

function UI:Init()

	self.UI = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("MainUI"):Clone()
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
