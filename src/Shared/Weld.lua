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
	local handle = model.PrimaryPart or model:FindFirstChild("Handle") or model:FindFirstChild("_Handle") or model:FindFirstChildWhichIsA("BasePart", true);

	for i,v in pairs(model:GetDescendants()) do
		if v:IsA('BasePart') and not v == handle then
			self:WeldRelative(handle, v)
		end
	end
end

function Weld:WeldRelative_Tool(tool)
	print(tool)
	local handle = tool:FindFirstChild("Handle") or tool:FindFirstChild("_Handle") or tool:FindFirstChildWhichIsA("BasePart", true);

	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA('BasePart') and not v == handle then
			self:WeldRelative(handle, v)
		end
	end
end

return setmetatable(Weld, {
	__call = function(_, instance1, instance2, relative)
		if instance1:IsA('Tool') then
			rawget(Weld, "WeldRelative_Tool")(Weld, instance1)
		elseif instance1:IsA('Part') and instance2:IsA('Part') then
			if relative then
				rawget(Weld, "WeldRelative")(Weld, instance1, instance2)
			else
				rawget(Weld, "Weld")(Weld, instance1, instance2)
			end
		else
			rawget(Weld, "WeldRelative_Model")(Weld, instance1)
		end
	end;
})
