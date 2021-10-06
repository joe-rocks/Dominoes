local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Knit)

local PointsService = require(ReplicatedStorage.Common.PointsService)
print(PointsService)

local DrawPileService = require(ReplicatedStorage.Common.DrawPileService)
DrawPileService:init()

Knit.Start():Catch(warn)

--------------------------------------------------------------------------------------------------- 

local function runTests()
    local TestEZ = require(game.ReplicatedStorage.TestEZ)

    -- add any other root directory folders here that might have tests 
    local testLocations = {
        game.ServerScriptService.Server,
    }
    local reporter = TestEZ.TextReporter
    --local reporter = TestEZ.TextReporterQuiet -- use this one if you only want to see failing tests
     
    TestEZ.TestBootstrap:run(testLocations, reporter)
end

runTests()
