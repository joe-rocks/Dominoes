local Knit = require(game:GetService("ReplicatedStorage").Knit)
-- local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
-- local RemoteProperty = require(Knit.Util.Remote.RemoteProperty)

local BoardService = Knit.CreateService {
    Name = "BoardService";
    Client = {
        AddDomino = RemoteSignal.new();
    };
}


-- Initialize
function BoardService:KnitInit()

    self.Client.AddDomino:Connect(function(player,domino,location)
        local dominoList = self.Locations[location]
        if location == "Spinner" and not dominoList then
            dominoList = domino
            self.PipValues[location] = domino:getPipValue()
        elseif dominoList then
            table.insert( dominoList, domino )
            if self.PipValues[location] == domino:getPipValue() then
                self.PipValues[location] = "foo"
            end
        end
    end)

    -- Clean up data when player leaves:
    game:GetService("Players").PlayerRemoving:Connect(function(player)
    end)

end

return BoardService