local Player = game:GetService("Players").LocalPlayer;
local StarterGui = game:GetService("StarterGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local temporaryBlackscreen = Instance.new('ScreenGui')
temporaryBlackscreen.IgnoreGuiInset = true
local temporaryBlackscreenFrame = Instance.new("Frame", temporaryBlackscreen)
temporaryBlackscreenFrame.Size = UDim2.new(1,0,1,0)
temporaryBlackscreenFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
temporaryBlackscreen.Parent = Player:WaitForChild("PlayerGui")

ReplicatedFirst:RemoveDefaultLoadingScreen();
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)


repeat wait() until _G.Aero
local Aero = _G.Aero;

Aero.Controllers.Fade:Out(0)
Aero.Controllers.UI:Start()
