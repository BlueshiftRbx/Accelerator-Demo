local Topbar = {}

function Topbar:SetText(text)
	self.Topbar.TextLabel.Text = text
end

function Topbar:Init()
	self.Topbar = self.UI.Topbar
end

return Topbar
