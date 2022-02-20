
local function createGui(parent)
    local gui = Instance.new("SurfaceGui")
    gui.Name = "gui"
    gui.Face = "Top"
    gui.CanvasSize = Vector2.new(200,200)
    gui.Parent = parent
    return gui
end

local function createText(parent)
    local text = Instance.new("TextLabel")
    text.Name = "text"
    text.Text = "?"
    text.TextSize = 14
    text.TextScaled = true
    text.BorderSizePixel = 0
    text.BackgroundTransparency = 0.75
    text.Size = UDim2.new(0.5,0,0.5,0)
    text.Position = UDim2.new(0.25,0,0.25,0)
    text.Parent = parent
    return text
end

local function createColor(pipValue, highestPipValue)
    local red = (highestPipValue-pipValue) / highestPipValue
    local green = 0
    local blue = pipValue / highestPipValue
    return Color3.new( red, green, blue )
end

local function createHalfDomino(pipValue, highestPipValue)
    local part = workspace.Pip:Clone()
    part.Color = createColor(pipValue, highestPipValue)
    part.Name = "Pip_" .. pipValue
    part.Anchored = false
    local gui = createGui(part)
    local text = createText(gui)
    text.Text = pipValue
    return part
end

local function createWeld(model, part1, part2)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = part1
    WeldConstraint.Part1 = part2
    WeldConstraint.Parent = model
end

local function createDomino(part1, part2, pipValue1, pipValue2)
    local model = Instance.new("Model")
    model.Name = "Domino_" .. pipValue1 .. "_" .. pipValue2
    model.PrimaryPart = part1
    part1.Parent = model
    part2.Parent = model
    return model
end

local ColorDomino = {}
ColorDomino.__index = ColorDomino

function ColorDomino.new(pipValue1, pipValue2, highestPipValue)
    local part1 = createHalfDomino(pipValue1, highestPipValue)
    local part2 = createHalfDomino(pipValue2, highestPipValue)
    local domino = createDomino(part1, part2, pipValue1, pipValue2)
    createWeld(domino, part1, part2)
    part1.Parent = domino
    part2.Parent = domino
    domino.Parent = workspace
    part2.Position = part1.Position + Vector3.new( 0, 0, part1.Size.Z )
    return domino
end

return ColorDomino
