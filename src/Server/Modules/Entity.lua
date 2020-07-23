local Entity = {}
Entity.__index = Entity

local Players = game:GetService("Players")

function Entity.new(entityObject, info)
    local self = setmetatable({}, Entity)

    self.Model = entityObject
    self.Humanoid = entityObject:WaitForChild("Humanoid")
    self.Root = entityObject:WaitForChild("HumanoidRootPart")

    self.Model.Parent = workspace:WaitForChild("")

    spawn(function()
        while not self._Destroyed do
            wait(0.25)
            self:Step()
        end
    end)

    return self
end

function Entity:TakeDamage(damage)
    if damage > 0 then
        self.Health = self.Health - math.clamp(damage, 0, self.Health);

        if self.Health == 0 then
            self:Destroy()
        end
    end
end

function Entity:Destroy()
    -- Play death animation
    -- Ragdoll?
    -- Delete after X seconds

    self._Destroyed = true
end

function Entity:Step()
    -- Actual game will have flock movements to make sure NPCs dont hit eachother and to lessen the server stress
    -- Maybe also add "aggro" so that the most damage-dealing player gets priority of getting eaten

    local function getClosestPlayer()
        local closestPlayer, magnitude;

        for _,player in pairs(Players:GetPlayers()) do
            local character = player.Character;
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if character and root then
                if closestPlayer == nil then
                    closestPlayer = player; magnitude = (root.Position - self.Root.Position).Magnitude
                else
                    local nMagnitude = (root.Position - self.Root.Position).Magnitude
                    if nMagnitude < magnitude then
                        closestPlayer = player;
                        magnitude = nMagnitude;
                    end
                end
            end
        end

        return closestPlayer, magnitude
    end;

    local closestPlayer, magnitude = getClosestPlayer();
    if closestPlayer then

        if magnitude < 5 then
            -- Attack
        else
            local closestPlayerRoot = (closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart"))
            self.Humanoid:MoveTo(
                closestPlayerRoot.Position
            )
        end
    end
end

return Entity
