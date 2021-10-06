local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Knit)
-- local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
-- local RemoteProperty = require(Knit.Util.Remote.RemoteProperty)

local DrawPileService = Knit.CreateService {
    Name = "DrawPileService";
    DrawPile = {};
    Client = {
        GiveMeDomino = RemoteSignal.new();
    };
}

function DrawPileService:removeDomino(domino)
    self.DrawPile[domino] = nil
end

function DrawPileService:init()
    local Pip = workspace.Pip
    local move = CFrame.new(Pip.Size.X,0,0)
    local cf = Pip.CFrame
    local Domino = require(ServerScriptService.Server.Domino)
    local highestPipValue = 6
    for i = 0,highestPipValue do
        for j = i,highestPipValue do
            Domino.new(i,j)
            local pip = Pip:clone()
            cf *= move
            pip.CFrame = cf
            pip.Name = "Pip_" .. i .. "_" .. j
            pip.Parent = workspace
        end
    end
end

-- Initialize
function DrawPileService:KnitInit()

    -- Give player random amount of points:
    self.Client.GiveMeDomino:Connect(function(player,domino)
        self:removeDomino(domino)
        player:giveDomino(domino)
    end)

    -- Clean up data when player leaves:
    game:GetService("Players").PlayerRemoving:Connect(function(player)
    end)

end

return DrawPileService