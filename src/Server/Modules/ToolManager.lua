local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local toolsFolder = ServerStorage.Tools

local ToolManager = {}

ToolManager.__index = ToolManager

function ToolManager.new(player, toolData)
	local self = setmetatable({}, ToolManager)

	-- Properties
	self._Character = player.Character
	self._Backpack = player:WaitForChild("Backpack")
	self._Primary = toolData.Primary
	self._Secondary = toolData.Secondary
	self._Equipment = toolData.Equipment
	self._CurrentTool = nil

	-- Initialize
	CollectionService:AddTag(self._Primary, "Primary")
	CollectionService:AddTag(self._Secondary, "Secondary")
	CollectionService:AddTag(self._Equipment, "Equipment")

	return self
end

function ToolManager:EquipPrimary()
	if self._Primary then
	end
end

function ToolManager:EquipSecondary()
	if self._Secondary then
	end
end

function ToolManager:EquipEquipment()
	if self._Equipment then
	end
end

ServerStorage = nil

return ToolManager
