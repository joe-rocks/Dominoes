-- From a LocalScript
local Knit = require(game:GetService("ReplicatedStorage").Knit)
local PointsService = Knit.GetService("PointsService")

local function PointsChanged(points)
    print("My points:", points)
end

-- Get points and listen for changes:
local initialPoints = PointsService:GetPoints()
PointsChanged(initialPoints)
PointsService.PointsChanged:Connect(PointsChanged)

-- Ask server to give points randomly:
PointsService.GiveMePoints:Fire()

-- Grab MostPoints value:
local mostPoints = PointsService.MostPoints:Get()

-- Keep MostPoints value updated:
PointsService.MostPoints.Changed:Connect(function(newMostPoints)
    mostPoints = newMostPoints
end)

-- Advanced example, using promises to get points:
PointsService:GetPointsPromise():Then(function(points)
    print("Got points:", points)
end)