local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Knit)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local Board = require(ServerScriptService.Server.Board)

local BoardService = Knit.CreateService {
    Name = "BoardService";
    Board = Board.new();
    Client = {
        AddDomino = RemoteSignal.new();
    };
}

local function createBoard()
    local board = Instance.new("Part")
end

-- Initialize
function BoardService:KnitInit()

    self.Client.AddDomino:Connect(function(player,domino,location)
        if self.Board:AddDomino(domino,location) then
            print(player," played",domino," at ",location)
        end
    end)

    -- Clean up data when player leaves:
    game:GetService("Players").PlayerRemoving:Connect(function(player)
    end)

end

return BoardService