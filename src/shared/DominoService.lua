local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DominoWithColorPips = require(ServerScriptService.Server.DominoWithColorPips)

local Knit = require(ReplicatedStorage.Knit)
local Domino = require(ServerScriptService.Server.Domino)
local ColorDomino = require(ServerScriptService.Server.ColorDomino)

local DominoService = Knit.CreateService {
    Name = "DominoService";
    Dominoes = {};
    highestPipValue = 6;
    DominoHeight = 9;
    DominoWidth = 5;
}

function DominoService:KnitInit()
    local startPosition = Vector3.new(0, 8, -15)

    local folder = Instance.new("Folder")
    folder.Name = "DominoParts"
    folder.Parent = workspace

    local row, numRows = 0, (self.highestPipValue + 2) / 2
    local col, numColumns = 0, self.highestPipValue + 1

    for i = 0,self.highestPipValue do
        for j = i,self.highestPipValue do
            row += 1
            if row == numRows then
                row = 0
            end
            col += 1
            if col == numColumns then
                col = 0
            end
            local pos = startPosition + Vector3.new(-self.DominoHeight*row, 0, -self.DominoWidth*col)

            local object = Domino.new(i,j)
            local plainDomino = ColorDomino.new(i, j, pos)
            local domino = { object=object, model=plainDomino }
            table.insert(self.Dominoes, domino)
        end
    end

    -- currentPosition = startPosition + Vector3.new(10)
    -- for _,domino in ipairs(self.Dominoes) do
    --     local fancyDomino = DominoWithColorPips.new(
    --         domino.object.pip1,
    --         domino.object.pip2,
    --         currentPosition)
    --     domino.model = fancyDomino
    --     currentPosition += moveBackward
    -- end
end

return DominoService