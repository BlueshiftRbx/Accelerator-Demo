local UI = {
	Controllers = {};
};
UI.__index = UI;

function UI:Init()
	for _,x in pairs(script:GetChildren()) do
		local r = require(x)

		setmetatable(r, UI)
		self.Controllers[x.Name] = r

	end

	for _, controller in pairs(UI.Controllers) do
		local r, e = pcall(function()
			controller:Init()
		end)
		if not r then warn(e) end
	end
end

function UI:Start()
	for _, controller in pairs(self.Controllers) do
		local r, e = pcall(function()
			controller:Start()
		end
		if not r then warn(e) end
	end
end

return UI;
