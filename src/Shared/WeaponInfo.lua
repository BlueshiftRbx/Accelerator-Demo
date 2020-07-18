local WeaponInfo = {
	--[[EXAMPLE DATA
	["Gun"] = {
		Config = {
			ClipSize
			FireMode
			FireRate
		};

		Anims = {
			HoldAnim
			FiringAnim
		};

		Sounds = {
			EquipSound
			FiringSound
			ReloadSound
		};
	}
	--]]
	["SMG"] = {
		Config = {
			ClipSize = 30;
			FireMode = "Automatic";
			FireRate = 0.05;
		};

		Anims = {
			HoldAnim = "rbxassetid://5368735024";
			FiringAnim = "rbxassetid://5368738423";
		};

		Sounds = {
			FiringSound = "rbxassetid://5363102727";
			ReloadSound = "";
		};
	};

	["Pistol"] = {
		Config = {
			ClipSize = 12;
			FireMode = "Semi";
			FireRate = 1;
		};

		Anims = {
			HoldAnim = "";
			FiringAnim = "";
		};

		Sounds = {
			FiringSound = "";
			ReloadSound = "";
		};
	};
}

return WeaponInfo
