local Entity = {}
Entity.__index = Entity

local Players = game:GetService("Players")

function Entity.new(entityObject, info)
    local self = setmetatable({}, Entity)

    self.Model = entityObject
    self.Humanoid = entityObject:WaitForChild("Humanoid")
    self.Root = entityObject:WaitForChild("HumanoidRootPart")
    self.Info = info;

    self.Model:SetPrimaryPartCFrame(self:FindSpawnLocation())
    self.Model.Parent = workspace:WaitForChild("Zombies")

    spawn(function()
        while not self._Destroyed do
            wait(0.25)
            self:Step()
        end
    end)

    return self
end

function Entity:FindSpawnLocation()
    return CFrame.new(-77, 8.439, 69)
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

local Functions = {
    ["%*%*([^%*]*)%*%*"] = "<b>%s</b>";
    ["__([^%*]*)__"] = "<b>%s</b>";
    ["%*([^%*]*)%*"] = "<i>%s</i>";
    ["_([^%*]*)_"] = "<b>%s</b>";
    ["~([^%*]*)~"] = "<s>%s</s>";
}

function Format(text)
    for i,v in pairs(Functions) do
        text = text:gsub(i, function(text)
            return v:format(text)
        end)
    end
    return text
end

print(

    loc
    ("**text**"):gsub("", function(word)
        return ("<b>%s</b>"):format(word)
    end)
)

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
                    local nMagnitude = (root.Position - self.Root.Position).Magnitude
                    if nMagnitude < self.Info.FollowDistance then
                        closestPlayer = player;
                        magnitude = nMagnitude
                    end
                else
                    local nMagnitude = (root.Position - self.Root.Position).Magnitude
                    if nMagnitude < magnitude and nMagnitude < self.Info.FollowDistance then
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

        if magnitude < self.Info.AttackDistance then
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
