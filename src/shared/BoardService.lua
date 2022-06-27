local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Knit)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)

local server = ServerScriptService.Server
local Board = require(server.Board)

local shared = ReplicatedStorage.Common
local DominoService = require(shared.DominoService)

local dh = DominoService.DominoHeight
local dw = DominoService.DominoWidth

local function createBoard()
    local boardPart = Instance.new("Part")
    boardPart.Position = Vector3.new( -12, 3, -30 )
    boardPart.Size = Vector3.new(
        dh * 4 + 2 + dh * 4,
        0.5,
        dw * 7 + 2 + dh * 4)
    boardPart.BrickColor = BrickColor.new("Parsley green")
    boardPart.Name = "Board"
    boardPart.Parent = workspace
    return boardPart
end

local BoardService = Knit.CreateService {
    Name = "BoardService";
    BoardObject = Board.new();
    BoardPart = createBoard();
    Client = {
        AddDomino = RemoteSignal.new();
    };
}

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