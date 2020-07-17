local Weld = {}

function Weld:WeldRelative(i1, i2)
	local weld = Instance.new("Weld")
	weld.Part0 = i1;
	weld.Part1 = i2;
	weld.C0 = i1.CFrame:inverse();
	weld.C1 = i2.CFrame:inverse();
	weld.Parent = i1;

	return weld
end

function Weld:Weld(i1, i2)
	local weld = Instance.new("Weld")
	weld.Part0 = i1;
	weld.Part1 = i2;
	weld.Parent = i1;

	return weld
end

function Weld:WeldRelative_Model(model)
	local handle = model:FindFirstChild("Handle") or model:FindFirstChildWhichIsA("BasePart", true);

	for i,v in pairs(model:GetDescendants()) do
		if v:IsA('BasePart') and not v == handle then
			self:WeldRelative(handle, v)
		end
	end
end

return setmetatable(Weld, {
	__call = function(_, instance1, instance2, relative)
		if instance1:IsA('Model') then
			rawget(self, "WeldRelative_Model")(instance1)
		elseif instance1:IsA('Part') and instance2:IsA('Part') then
			if relative then
				rawget(self, "WeldRelative")(instance1, instance2)
			else
				rawget(self, "Weld")(instance1, instance2)
			end
		end
	end;
})
