-- Services
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Controllers
local DataController

-- Modules
local UserInput
local Maid

local SKIP_INTRO = RunService:IsStudio()


local LoadingScreen = {}

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
	if SKIP_INTRO and RunService:IsStudio() then
		self:SetVisible(false)
		self.Controllers.Fade:In(0)
		return
	end

	--// Preload sound and icon;
	local introSound = ReplicatedStorage.Assets.Sounds.Intro
	ContentProvider:PreloadAsync({
		introSound, self.LoadingMenu.Background, self.LoadingMenu.Logo
	})

	--// Show intro
	self:SetVisible(true)
	wait(0.5);

	SoundService:PlayLocalSound(introSound)
	wait(0.05)
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
	DataController = self.Controllers.DataController
	UserInput = self.Controllers.UserInput
	Maid = self.Shared.Maid

	self.Maid = Maid.new()

	self.LoadingMenu = self.UI:WaitForChild("LoadingMenu")
end

return LoadingScreen
