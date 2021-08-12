local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local RemoteProperty = require(Knit.Util.Remote.RemoteProperty)

local PointsService = Knit.CreateService {
    Name = "PointsService";
    PointsPerPlayer = {};
    PointsChanged = Signal.new();
    Client = {
        PointsChanged = RemoteSignal.new();
		GiveMePoints = RemoteSignal.new();
		MostPoints = RemoteProperty.new(0);
    };
}

-- Client exposed GetPoints method:
function PointsService.Client:GetPoints(player)
    return self.Server:GetPoints(player)
end

-- Add Points:
function PointsService:AddPoints(player, amount)
    local points = self:GetPoints(player)
    points = points + amount
    self.PointsPerPlayer[player] = points
    if amount ~= 0 then
        self.PointsChanged:Fire(player, points)
        self.Client.PointsChanged:Fire(player, points)
    end
    if points > self.Client.MostPoints:Get() then
        self.Client.MostPoints:Set(points)
    end
end
-- Get Points:
function PointsService:GetPoints(player)
    local points = self.PointsPerPlayer[player]
    return points or 0
end

-- Initialize
function PointsService:KnitInit()

    local rng = Random.new()

    -- Give player random amount of points:
    self.Client.GiveMePoints:Connect(function(player)
        local points = rng:NextInteger(0, 10)
        self:AddPoints(player, points)
        print("Gave " .. player.Name .. " " .. points .. " points")
    end)

    -- Clean up data when player leaves:
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        self.PointsPerPlayer[player] = nil
    end)

end

return PointsService