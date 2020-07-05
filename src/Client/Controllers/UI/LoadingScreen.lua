local LoadingScreen = {}

function LoadingScreen:Start()
	wait(1)
	self.Controllers.Fade:In(2)
	wait(0.5)
	self.LoadingMenu.Task.Text = "Waiting for data..."
end

function LoadingScreen:Init()
	self.LoadingMenu = self.UI:WaitForChild("LoadingMenu")
end

return LoadingScreen
