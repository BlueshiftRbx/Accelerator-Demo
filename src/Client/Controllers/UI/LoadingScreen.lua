local LoadingScreen = {}
local DataController;
local UserInput;

local Maid;

function LoadingScreen:SetVisible(visibility)
	self.LoadingMenu.Visible = visibility
end

function LoadingScreen:SetTitleText(text)
	self.LoadingMenu.Task.Text = text
end

function LoadingScreen:End()
	self.Controllers.Fade:Out(1)
	self:SetVisible(false)
	wait(0.5)
	self.Controllers.Fade:In(1)
end

function LoadingScreen:Start()
	self:SetVisible(true)
	wait(1)
	self.Controllers.Fade:In(2)

	wait(0.5)
	self:SetTitleText("Waiting for data..")

	repeat wait(0.2) until DataController.DataReady;
	self:SetTitleText("Data ready!")

	wait(1)

	--// Wait for user input
	self:SetTitleText("Click anywhere to continue")
	local keyboard = UserInput:Get("Keyboard")
	local mouse = UserInput:Get("Mouse")

	local e1, e2 --> Events to be disconnected
	e1 = keyboard.KeyDown:Connect(function()
		e1:Disconnect(); e2:Disconnect();
		self:End()
	end)

	e2 = mouse.LeftDown:Connect(function()
		e1:Disconnect(); e2:Disconnect();
		self:End()
	end)
end

function LoadingScreen:Init()
	DataController = self.Controllers.Data
	UserInput = self.Controllers.UserInput
	Maid = self.Shared.Maid

	self.Maid = Maid.new()

	self.LoadingMenu = self.UI:WaitForChild("LoadingMenu")
end

return LoadingScreen
