local WeaponInfo = {
	--[[EXAMPLE DATA
	["Gun"] = {
		ClipSize
		FireRate
		ReloadTime // NOTE the time it'll take to reload

		Anims = {
			HoldAnim
			FiringAnim
			ReloadingAnim
		}
	}
	--]]
	["SMG"] = {
		ClipSize = 30;
		FireRate = 0.05;
		ReloadSpeed = 1;

		Anims = {
			HoldAnim = "";
			FiringAnim = "";
			ReloadingAnim = "";
		};
	};

	["Pistol"] = {
		ClipSize = 12;
		FireRate = 1;

		Anims = {
			HoldAnim = "";
			FiringAnim = "";
			ReloadingAnim = "";
		};
	};
}

return WeaponInfo
