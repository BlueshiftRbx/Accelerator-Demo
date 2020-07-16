local Cursor = {};

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
	self.Right.Size = UDim2.new(0, length, 0, 2)
	self.Left.Size = UDim2.new(0, length, 0, 2)
	self.Top.Size = UDim2.new(0, 2, 0, length)
	self.Bottom.Size = UDim2.new(0, 2, 0, length)
end

function Cursor:Init()
	self.CursorUI = self.UI:WaitForChild("GameMenu"):WaitForChild("Cursor")

	self.Center = self.CursorUI.Center;
	self.Right = self.Center.Right;
	self.Left = self.Center.Left;
	self.Top = self.Center.Top;
	self.Bottom = self.Center.Bottom;
end

return Cursor;
