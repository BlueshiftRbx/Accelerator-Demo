local Data = {
	Cached = {};
	DataReady = false;
}
local DataService;

--// Callback whenever server updates a key
function Data:OnUpdate(path, key, value)
	if self.DataReady == false then return end

	local currentRepo = Data.Cached

	--// Go through Cache until you find end of path
	for branch in path:gmatch("[^//]+") do
		if currentRepo ~= nil then
			local newRepo = currentRepo[branch]
			if newRepo then
				currentRepo = newRepo
			else
				currentRepo = nil
			end
		end
	end

	--// If repo exists, set value to it
	if currentRepo then
		currentRepo[key] = value
		self:FireEvent("DataChanged", path, key, value)
	else
		warn("Data mismatch, recaching!")
		self:Recache(); --> It didn't find repo somewhere, recache so it fetches whole thing.
	end
end

--// Recaches whole Cache instantaneously
function Data:Recache()
	local newData = DataService:FetchData();
	if newData then
		Data.Cached = newData

		return true
	end
	return false
end

function Data:Start()


	DataService.DataChanged:Connect(function(path, key, value)
		self:OnUpdate(path, key, value)
	end)

	--// Keep requesting data until you get it
	local success do
		repeat success=Data:Recache(); wait(2) until success;
	end

	self.DataReady = true
	self:FireEvent("DataReady")
end

function Data:Init()
	DataService = self.Services.DataService

	self:RegisterEvent("DataReady")
	self:RegisterEvent("DataChanged")
end

return Data
