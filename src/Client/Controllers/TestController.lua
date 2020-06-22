	-- Test Controller
-- Username
-- June 22, 2020

--// Make sure to do something, testing the Codestream

local TestController = {}


function TestController:Start()
	print("yeehaw")
	warn("Help")
end


function TestController:Init()
	self.SomeValue = true
end


return TestController
