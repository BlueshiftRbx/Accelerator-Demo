local LoadingScreen = {}
local Data;

function LoadingScreen:SetVisible(visibility)
	self.LoadingMenu.Visible = visibility
end

function LoadingScreen:SetTitleText(text)
	self.LoadingMenu.Task.Text = text
end

function LoadingScreen:Start()
	wait(1)
	self.Controllers.Fade:In(2)

	wait(0.5)
	self:SetTitleText("Waiting for data..")

	repeat wait(0.2) until Data.DataReady;
	self:SetTitleText("Data ready!")

	wait(1)
	self.Controllers.Fade:Out(1)
	self:SetVisible(false)
	wait(0.5)
	self.Controllers.Fade:In(1)
end

function LoadingScreen:Init()
	Data = self.Controllers.Data

	self.LoadingMenu = self.UI:WaitForChild("LoadingMenu")
end

return LoadingScreen
