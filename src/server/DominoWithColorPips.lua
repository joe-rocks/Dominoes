local DominoWithColorPips = {}
DominoWithColorPips.__index = DominoWithColorPips

local function createDominoBody()
    local part = workspace.Pip:Clone()
    part.Size += Vector3.new(part.Size.X)
    return part
end

local function createPip()
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Position += Vector3.new(2,1,2)
    return sphere
end

function DominoWithColorPips.new(pipValue1, pipValue2, highestPipValue)
    local body = createDominoBody()
    local pip = createPip()

    local success, newUnion = pcall(function()
        return body:SubtractAsync({pip})
    end)

    if not success then
        print("no success")
    elseif newUnion then
        newUnion.Position = body.Position
        newUnion.Anchored = true
        newUnion.Parent = game.Workspace
        -- Remove original parts
        body:Destroy()
        pip:Destroy()
        return newUnion
    end

    return nil
end

return DominoWithColorPips
