local Cursor = {};
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UserInput, Mouse;

local WIDTH = 4

function Cursor:SetEnabled(enabled)
	self.Right.Visible = enabled
	self.Left.Visible = enabled
	self.Top.Visible = enabled
	self.Bottom.Visible = enabled
end

function Cursor:SetGap(gap)
	self.Right.Position = UDim2.new(1, gap, 0.5, 0)
	self.Left.Position = UDim2.new(0, -gap, 0.5, 0)
	self.Top.Position = UDim2.new(0.5, 0, 0, -gap)
	self.Bottom.Position = UDim2.new(0.5, 0, 1, gap)
end

function Cursor:SetLength(length)
	self.Center.Size = UDim2.new(0, WIDTH, 0, WIDTH)
	self.Right.Size = UDim2.new(0, length, 0, WIDTH)
	self.Left.Size = UDim2.new(0, length, 0, WIDTH)
	self.Top.Size = UDim2.new(0, WIDTH, 0, length)
	self.Bottom.Size = UDim2.new(0, WIDTH, 0, length)
end

function Cursor:Start()
	Mouse = UserInput:Get("Mouse")

	UserInputService.MouseIconEnabled = false;
	self:SetEnabled(false)
	self:SetLength(10)

	RunService.RenderStepped:Connect(function()
		local pos = Mouse:GetPosition()
		self.Center.Position = UDim2.new(0, pos.X, 0, pos.Y)
	end)
end

function Cursor:Init()
	UserInput = self.Controllers.UserInput

	self.CursorUI = self.UI:WaitForChild("GameMenu"):WaitForChild("Cursor")

	self.Center = self.CursorUI.Center;
	self.Right = self.Center.Right;
	self.Left = self.Center.Left;
	self.Top = self.Center.Top;
	self.Bottom = self.Center.Bottom;
end

return Cursor;
