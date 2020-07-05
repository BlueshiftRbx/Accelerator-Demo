local LoadingScreen = {}

function LoadingScreen:Start()
	print(self.Controllers)
	self.Controllers.Fade:In(0)
end

return LoadingScreen
