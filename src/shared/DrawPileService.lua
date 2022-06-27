local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
-- local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
-- local RemoteProperty = require(Knit.Util.Remote.RemoteProperty)
local JumpUp = require(ServerScriptService.Server.JumpUp)
local DominoService = require(script.Parent.DominoService)

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

function DrawPileService:shuffle()
    for _,domino in ipairs(DominoService.Dominoes) do
        domino.owner = "DrawPile"
        table.insert(self.DrawPile, domino)
    end

    local seed = 5
    self.rand = Random.new(seed)
    local n = #self.DrawPile
    for _ = 0,42 do
        -- Get two random dominoes
		local r1,r2 = self.rand:NextInteger(1,n), self.rand:NextInteger(1,n)
        local x,y = self.DrawPile[r1], self.DrawPile[r2]
        -- Swap the domino objects
        x.object, y.object = y.object, x.object
        -- Swap the domino parts
        local a,b = x.model.PrimaryPart, y.model.PrimaryPart
		a.CFrame,b.CFrame = b.CFrame,a.CFrame
    end

    -- for _,v in ipairs(self.DrawPile) do
    --     local j = JumpUp.new(v.model.PrimaryPart)
    --     j:activate()
    -- end

end

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