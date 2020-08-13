-- Controller
---@type AeroController
local Ammo = {};

function Ammo:SetAmmo(ammo)
	self.AmmoUI.Text = tostring(ammo).. " / ∞"
end

function Ammo:SetEnabled(enabled)
	self.AmmoUI.Visible = enabled;
end

function Ammo:Init()
	self.AmmoUI = self.UI:WaitForChild("GameMenu"):WaitForChild("Ammo")
end

return Ammo;
