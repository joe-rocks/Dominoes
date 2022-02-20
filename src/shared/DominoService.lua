local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
local Domino = require(ServerScriptService.Server.Domino)
local ColorDomino = require(ServerScriptService.Server.ColorDomino)

local DominoService = Knit.CreateService {
    Name = "DominoService";
    Dominoes = {};
    highestPipValue = 6;
}

function DominoService:KnitInit()
    local moveRight = CFrame.new( workspace.Pip.Size.X * 1.2, 0, 0 )
    local startPosition = CFrame.new( 0, 3, -10 )
    local currentPosition = startPosition

    for i = 0,self.highestPipValue do
        for j = i,self.highestPipValue do
            local object = Domino.new(i,j)
            local model = ColorDomino.new(i, j, self.highestPipValue)
            local domino = { object=object, model=model }
            table.insert(self.Dominoes, domino)
            model.PrimaryPart.CFrame = currentPosition
            currentPosition *= moveRight
        end
    end
end

return DominoService