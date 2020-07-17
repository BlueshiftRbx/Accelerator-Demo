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
		FireMode = "Automatic";
		FireRate = 0.05;

		Anims = {
			HoldAnim = "";
			FiringAnim = "";
			ReloadingAnim = "";
		};
	};

	["Pistol"] = {
		ClipSize = 12;
		FireMode = "Semiautomatic";
		FireRate = 1;

		Anims = {
			HoldAnim = "";
			FiringAnim = "";
			ReloadingAnim = "";
		};
	};
}

return WeaponInfo
