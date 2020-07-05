local UI = {
	Controllers = {};
};
UI.__aeroPreventStart = true; -- Start is ran by ReplicatedFirst script!

function UI:Init()
	for _,x in pairs(script:GetChildren()) do
		local r = require(x)
		self.Controllers[x.Name] = r
		setmetatable(r, {__index = UI})
	end

	for _, controller in pairs(self.Controllers) do
		local r, e = pcall(function()
			rawget(controller, "Init")(controller)
		end)
		if not r then warn(e) end
	end
end

function UI:Start()
	for _, controller in pairs(self.Controllers) do
		local r, e = pcall(function()
			rawget(controller, "Start")(controller)
		end)
		if not r then warn(e) end
	end
end

return UI;
