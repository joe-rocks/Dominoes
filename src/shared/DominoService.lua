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
}

function DominoService:KnitInit()
    local startPosition = Vector3.new(0, 8, -15)
    local moveBackward = Vector3.new(0, 0, -5)
    local currentPosition = startPosition

    for i = 0,self.highestPipValue do
        for j = i,self.highestPipValue do
            local object = Domino.new(i,j)
            local plainDomino = ColorDomino.new(i, j, currentPosition)
            local domino = { object=object, model=plainDomino }
            table.insert(self.Dominoes, domino)
            currentPosition += moveBackward
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