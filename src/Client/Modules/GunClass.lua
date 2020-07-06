-- Gun Class
-- metaprogramming
-- July 6, 2020



local GunClass = {}
GunClass.__index = GunClass


function GunClass.new()

	local self = setmetatable({}, GunClass)

	return self

end


return GunClass
