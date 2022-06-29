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

local function createPlayerHand(player, board, position, rotation)
    local playerHandPart = Instance.new("Part")
    playerHandPart.Anchored = true
    playerHandPart.Position = position
    playerHandPart.Rotation = Vector3.new(0, rotation)
    playerHandPart.Size = Vector3.new(dh, 0.5, dw*7)
    playerHandPart.BrickColor = BrickColor.new("Olivine")
    playerHandPart.Name = "PlayerHand" .. player
    playerHandPart.Transparency = 0.5
    playerHandPart.Parent = board
    return playerHandPart
end

local function createPlayerHands(board)
    local x = { 0, 1,  0, -1 }
    local y = { 1, 0, -1,  0 }
    local radius = board.Size.Z / 2 - dh / 2
    for i = 1,4 do
        local position = board.Position + Vector3.new(x[i] * radius, 0.5, y[i] * radius)
        createPlayerHand(i, board, position, 90*i)
    end
end

local function createBoard()
    local boardPart = Instance.new("Part")
    boardPart.Anchored = true
    boardPart.Position = Vector3.new( -12, 3, -30 )
    local x = dh*4 + 2 + dh*4
    local z = dw*7 + 3 + dh*4
    print("x,z",x,z)
    boardPart.Size = Vector3.new(x, 0.5, z)
    boardPart.BrickColor = BrickColor.new("Parsley green")
    boardPart.Name = "Board"
    createPlayerHands(boardPart)
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