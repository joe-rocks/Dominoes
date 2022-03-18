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
    local barSizeZ = dominoBody.Size.z * 0.9
    bar.Size = Vector3.new(barSizeX, barSizeX, barSizeZ)
    local barPosY = dominoBody.Size.y / 2
    bar.Position = dominoBody.Position + Vector3.new(0, barPosY, 0)
    bar.BrickColor = BrickColor.Black()
    bar.Anchored = true
    bar.Parent = game.Workspace
    return bar
end

local function createPipPositions(dominoBody, numPips)
    local positions = {}
    local color = BrickColor.new("Gold")
    if numPips == 1 then
        table.insert(positions, Vector3.new(dominoBody.Size.x / 4, 0, 0))
        color = BrickColor.new("Gold")
    elseif numPips == 2 then
        table.insert(positions, Vector3.new(dominoBody.Size.x / 8, 0, dominoBody.Size.z / 8))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 8))
        color = BrickColor.new("Lime green")
    elseif numPips == 3 then
        table.insert(positions, Vector3.new(dominoBody.Size.x / 8, 0, dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x / 4, 0, 0))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 4))
        color = BrickColor.new("Plum")
    end
    return positions, color
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

local function createPips(body, pipValue1, pipValue2)
    local pips = {}

    local positions, color = createPipPositions(body, pipValue1)
    for _,offset in ipairs(positions) do
        local pip = createPip(body, offset)
        pip.BrickColor = color
        table.insert(pips, pip)
    end

    positions, color = createPipPositions(body, pipValue2)
    for _,offset in ipairs(positions) do
        local pip = createPip(body, -offset)
        pip.BrickColor = color
        table.insert(pips, pip)
    end

    return pips
end

function DominoWithColorPips.new(pipValue1, pipValue2)
    local body = createDominoBody()
    local bar = createBar(body)
    local pips = createPips(body, pipValue1, pipValue2)

    local partsToUnion = { bar, table.unpack(pips) }

    local success, newUnion = pcall(function()
        return body:SubtractAsync(partsToUnion)
    end)

    if #pips == 0 then
        newUnion.Position = body.Position
        newUnion.Anchored = false
        newUnion.Parent = game.Workspace
        return newUnion
    end

    if not success then
        error("no success")
    elseif newUnion then
        -- Remove original parts
        body:Destroy()
   end

    local success2, newUnion2 = pcall(function()
        return newUnion:UnionAsync(partsToUnion)
    end)

    if not success2 then
        error("no success")
    elseif newUnion2 then
        newUnion2.Position = body.Position
        newUnion2.Anchored = false
        newUnion2.Parent = game.Workspace
        -- Remove original parts
        newUnion:Destroy()
        for _,v in ipairs(partsToUnion) do
            v:Destroy()
        end
    end

    return newUnion2
end

return DominoWithColorPips
