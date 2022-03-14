local DominoWithColorPips = {}
DominoWithColorPips.__index = DominoWithColorPips

local function createDominoBody()
    local part = Instance.new("Part")
    part.Size = Vector3.new(8, 1, 4)
    part.Position = Vector3.new(0, 8, -15)
    part.Anchored = true
    part.Parent = game.Workspace
    return part
end

local function createBar(dominoBody)
    local bar = Instance.new("Part")
    local barSizeX = dominoBody.Size.x / 40
    bar.Size = Vector3.new(barSizeX, barSizeX, dominoBody.Size.z)
    local barPosY = dominoBody.Size.y / 2
    bar.Position = dominoBody.Position + Vector3.new(0, barPosY, 0)
    bar.Anchored = true
    bar.Parent = game.Workspace
    return bar
end

local function createPip(dominoBody)
    local pip = Instance.new("Part")
    pip.Shape = Enum.PartType.Ball
    local pipSizeX = dominoBody.Size.x / 8
    pip.Size = Vector3.new(pipSizeX)
    local pipPosX = dominoBody.Size.x / 4
	local pipPosY = dominoBody.Size.y / 2
    pip.Position = dominoBody.Position + Vector3.new(pipPosX, pipPosY, 0)
    pip.Anchored = true
    pip.Parent = game.Workspace
    return pip
end

function DominoWithColorPips.new(pipValue1, pipValue2, highestPipValue)
    print(pipValue1,pipValue2,highestPipValue)
    local body = createDominoBody()
    local bar = createBar(body)
    local pip = createPip(body)

    local partsToSubtract = {pip, bar}
    local success, newUnion = pcall(function()
        return body:SubtractAsync(partsToSubtract)
    end)

    if not success then
        warn("no success")
    elseif newUnion then
        newUnion.Position = body.Position
        newUnion.Anchored = false
        newUnion.Parent = game.Workspace
        -- Remove original parts
        body:Destroy()
        for _,v in ipairs(partsToSubtract) do
            v:Destroy()
        end
        return newUnion
    end

    return nil
end

return DominoWithColorPips
