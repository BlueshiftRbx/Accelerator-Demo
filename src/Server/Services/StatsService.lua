-- Literally the most useless service, but yeah...

local StatsService = {Client={}}

function StatsService.Client:Ping()
	return true;
end

function StatsService:Start()
	self.ServerStartTimestamp = tick();

	local serverAge = game:GetService("ReplicatedStorage"):WaitForChild("ServerStats"):WaitForChild("Age")
	while wait(1) do
		serverAge.Value = math.floor(tick() - self.ServerStartTimestamp)
	end
end

return StatsService
