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

local function createPipPositions(dominoBody, numPips)
    local positions = {}
    if numPips == 1 then
        table.insert(positions, Vector3.new(dominoBody.Size.x / 4, 0, 0))
    elseif numPips == 2 then
        table.insert(positions, Vector3.new(dominoBody.Size.x / 8, 0, dominoBody.Size.z / 8))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 8))
    end
    return positions
end

local function createPip(dominoBody, positionOffset)
    local pip = Instance.new("Part")
    pip.Shape = Enum.PartType.Ball
    local pipSizeX = dominoBody.Size.x / 8
    pip.Size = Vector3.new(pipSizeX)
	local pipPosY = dominoBody.Size.y / 2
    pip.Position = dominoBody.Position + Vector3.new(0, pipPosY, 0) + positionOffset
    pip.Anchored = true
    pip.Parent = game.Workspace
    return pip
end

function DominoWithColorPips.new(pipValue1, pipValue2)
    local body = createDominoBody()
    local bar = createBar(body)
    local partsToSubtract = {bar}

    for _,offset in ipairs(createPipPositions(body, pipValue1)) do
        local pip = createPip(body, offset)
        table.insert(partsToSubtract, pip)
    end
    for _,offset in ipairs(createPipPositions(body, pipValue2)) do
        local pip = createPip(body, -offset)
        table.insert(partsToSubtract, pip)
    end

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
