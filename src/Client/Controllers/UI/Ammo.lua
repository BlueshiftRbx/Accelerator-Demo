local Ammo = {};

function Ammo:SetAmmo(ammo)
	self.AmmoUI.Text = ("%d / ∞"):format(ammo)
end

function Ammo:SetVisible(visible)
	self.AmmoUI.Visible = visible;
end

function Ammo:Init()
	self.AmmoUI = self.UI:WaitForChild("GameMenu"):WaitForChild("Ammo")
end

return Ammo;
