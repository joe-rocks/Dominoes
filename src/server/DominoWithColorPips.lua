local DominoWithColorPips = {}
DominoWithColorPips.__index = DominoWithColorPips

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Knit)
local Promise = require(Knit.Util.Promise)

local function createDominoBody(position)
    local part = Instance.new("Part")
    part.Size = Vector3.new(8, 1, 4)
    part.Position = position
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
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, dominoBody.Size.z / 8))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 8))
        color = BrickColor.new("Bright red")
    elseif numPips == 3 then
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 2 / 8, 0, 0))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 4))
        color = BrickColor.new("Plum")
    elseif numPips == 4 then
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, -dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, dominoBody.Size.z / 4))
        color = BrickColor.new("Electric blue")
    elseif numPips == 5 then
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, -dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x / 4, 0, 0))
        color = BrickColor.new("Camo")
    elseif numPips == 6 then
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 1 / 8, 0, -dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 2 / 8, 0, dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 2 / 8, 0, -dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, -dominoBody.Size.z / 4))
        table.insert(positions, Vector3.new(dominoBody.Size.x * 3 / 8, 0, dominoBody.Size.z / 4))
        color = BrickColor.new("Hot pink")
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

local function unionPcall(unionType, target, partsToUnion, isUpdatePosition)
    return Promise.new(function(resolve, reject)
        local success, newUnion = pcall(function()
            return target[unionType](target, partsToUnion)
        end)
    
		if success then
            if isUpdatePosition then
                newUnion.Position = target.Position
            end
            target:Destroy()
			resolve(newUnion)
		else
            reject(newUnion)
		end
	end)
end

local function negate(target, partsToNegate)
    return unionPcall("SubtractAsync", target, partsToNegate)
end

local function union(target, partsToUnion)
    return unionPcall("UnionAsync", target, partsToUnion)
end

function DominoWithColorPips.new(pipValue1, pipValue2, position)
    local startTime = os.time()
    local body = createDominoBody(position)
    local bar = createBar(body)
    local pips = createPips(body, pipValue1, pipValue2)
    local partsToUnion = { bar, table.unpack(pips) }
    local self = {}

    negate(body, partsToUnion)
    :andThen(function(newUnion)
        print(pipValue2,pipValue1,"negate")
        if #pips == 0 then
            newUnion.Anchored = false
            newUnion.Parent = game.Workspace
            newUnion.Position = position
            self.union = newUnion
            return
        end

        union(newUnion, partsToUnion)
        :andThen(function(newUnion2)
            newUnion2.Anchored = false
            newUnion2.Parent = game.Workspace
            newUnion2.Position = position
            for _,v in ipairs(partsToUnion) do
                v:Destroy()
            end
    
            local elapsedTime = os.time() - startTime
            print(pipValue2,pipValue1,elapsedTime)
            self.union = newUnion2
        end)
    end)

    return self
end

return DominoWithColorPips
