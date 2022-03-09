local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Knit)

require(ReplicatedStorage.Common.PointsService)
require(ReplicatedStorage.Common.DominoService)
local DrawPile = require(ReplicatedStorage.Common.DrawPileService)

Knit.Start():Catch(warn)

wait(2)
DrawPile:shuffle()

local ServerScriptService = game:GetService("ServerScriptService")
local DominoWithColorPips = require(ServerScriptService.Server.DominoWithColorPips)


---------------------------------------------------------------------------------------------------

local function runTests()
    local TestEZ = require(game.ReplicatedStorage.TestEZ)

    -- add any other root directory folders here that might have tests
    local testLocations = {
        game.ServerScriptService.Server,
    }
    -- local reporter = TestEZ.TextReporter
    local reporter = TestEZ.TextReporterQuiet -- use this one if you only want to see failing tests

    TestEZ.TestBootstrap:run(testLocations, reporter)
end

runTests()

local test
for i = 1,50 do
    test = DominoWithColorPips.new(1,2,6)
    if test then
        print(i .. " success")
        break
    end

    print(i .. " failed")
    wait(1)
end

