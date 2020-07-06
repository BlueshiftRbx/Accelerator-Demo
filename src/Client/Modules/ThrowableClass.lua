-- Throwable Class
-- metaprogramming
-- July 6, 2020



local ThrowableClass = {}
ThrowableClass.__index = ThrowableClass


function ThrowableClass.new()

	local self = setmetatable({}, ThrowableClass)

	return self

end


return ThrowableClass
