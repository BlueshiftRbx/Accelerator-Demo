local Entity = {}
Entity.__index = Entity

Entity.STEP_DELAY = 0.5

local VALID_PATHFINDING_STATUS = {
    [Enum.PathStatus.Success] = true;
	[Enum.PathStatus.ClosestNoPath] = true;
	[Enum.PathStatus.ClosestOutOfRange] = true;
}

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")

local Maid;
local Thread;

function Entity.new(entityModel, entityInfo)
    local self = setmetatable({
        Path = {
            Nodes = {};
            Index = 1;

            Discriminator = 1;
        };
        Target = nil;

        Character = entityModel;
        Humanoid = entityModel:WaitForChild("Humanoid");
        Root = entityModel:WaitForChild("HumanoidRootPart");

        Maid = Maid.new();
    }, Entity)

    self:Spawn();

    return self
end

function Entity:Spawn()
    self.Character:SetPrimaryPartCFrame(
        workspace.TestSpawn.CFrame + Vector3.new(0,5,0)
    )
    self.Character.Parent = workspace.Zombies;
end

function Entity:GetClosestPlayer()
    local closestPlayer, magnitude;

    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if character and root then
            local newMagnitude = (root.Position - self.Root.Position).Magnitude
            if newMagnitude < (magnitude or math.huge) then
                closestPlayer = character;
                magnitude = newMagnitude
            end
        end
    end

    return closestPlayer, magnitude
end

function Raycast(position1, position2, target)
	if position1 and position2 and target then
		local position = position1
		local direction = (position2 - position1).Unit * (position2 - position1).Magnitude

		local noneTargetPlayers = {}

		for _,player in next, Players:GetPlayers() do
			if player.Character and player.Character ~= target then
				table.insert(noneTargetPlayers, player.Character)
			end
		end

		local rayParams = RaycastParams.new()

		rayParams.FilterDescendantsInstances = {zombiesFolder ,unpack(noneTargetPlayers)}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist
		rayParams.IgnoreWater = true

		local castResult = Workspace:Raycast(position, direction, rayParams)

		return castResult
	end
end

function Entity:UpdatePath()
    local target, magnitude = self:GetClosestPlayer()

    if target then
        self.Path.Discriminator += 1

        self.Target = target

        local castResult = Raycast(self.Root.Position, target.PrimaryPart.Position, target)

        if castResult and castResult.Instance:IsDescendantOf(self.Target) then
            self.Path.Nodes = {self.Target.PrimaryPart};
            self.Path.Index = 1;

            self:MoveToNext();
            return;
        else

            local path = PathfindingService:CreatePath({
                AgentRadius = 2;
                AgentHeight = 5;
                AgentCanJump = false;
            });

            path:ComputeAsync(self.Root.Position, target.PrimaryPart and target.PrimaryPart.Position)

            if VALID_PATHFINDING_STATUS[path.Status] then
                self.Path.Nodes = {};
                self.Path.Index = 1;

                for i,wp in pairs(path:GetWaypoints()) do self.Path.Nodes[i]=wp.Position end;

                self:MoveToNext();
                return
            end
        end
    end

    self.Target = nil;
    self.Path.Nodes = {};
    self.Path.Index = 0
end

function Entity:MoveToNext()
    if self.Target then
        local path = self.Path

        local currentDiscriminator = path.Discriminator

        path.Index += 1
        if path.Index > #path.Nodes then path.Index = #path.Nodes end

        if path.Nodes and #path.Nodes > 0 then
            if #path.Nodes >= path.Index then
                local next = path.Nodes[path.Index]
                if typeof(next) == 'Instance' then
                    self.Humanoid:MoveTo(next.Position, next)
                else
                    self.Humanoid:MoveTo(next);
                    self.Humanoid.MoveToFinished:Wait()
                    if self.Discriminator == currentDiscriminator then
                        self:MoveToNext()
                    end
                end
            end
        end
    end
end

function Entity:Init()
    Maid = self.Shared.Maid;
    Thread = self.Shared.Thread;
end

return Entity
