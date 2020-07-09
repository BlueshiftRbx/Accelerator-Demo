return {
	-- NOTE Hub & Session
	Class = "Commando";

	Levels = {
		--[[ EXAMPLE LEVEL
			Class = {
				Level = 1
				XPRatio = 0 (between 0 and 1)
			}
		]]
	};

	-- NOTE Hub related
	Credits = 0; -- Shop currency
	Trophies = 0; -- maps completed.

	Inventory = {
		Skins = {};
		Perks = {};
	};

	__SESSIONDATA = {

	};

	-- NOTE doesn't replicate to the client.
	__SERVER = {
		Analytics = {};
		BanData = {
			--[[ EXAMPLE BAN
				Reason = "Ban Example";
				Timestamp = 0;
				Duration = "";
			--]]
		};
	};

	-- NOTE Session related
	Equipped = {
		Skins = {};
		Perks = {};
	};
}
