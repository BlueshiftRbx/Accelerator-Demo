-- Melee Class
-- metaprogramming
-- July 6, 2020



local MeleeClass = {}
MeleeClass.__index = MeleeClass


function MeleeClass.new()

	local self = setmetatable({}, MeleeClass)

	return self

end


return MeleeClass
