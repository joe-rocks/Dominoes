local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Knit)
-- local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
-- local RemoteProperty = require(Knit.Util.Remote.RemoteProperty)

local DrawPileService = Knit.CreateService {
    Name = "DrawPileService";
    DrawPile = {};
    Client = {
        GiveMeDomino = RemoteSignal.new();
    };
}

function DrawPileService:removeDomino(domino)
    self.DrawPile[domino] = nil
end

function DrawPileService:init()
    local Pip = workspace.Pip
    local gui = Instance.new("SurfaceGui")
    gui.Name = "gui"
    gui.Face = "Top"
    gui.CanvasSize = Vector2.new(200,200)
    gui.Parent = Pip
    local text = Instance.new("TextLabel")
    text.Name = "text"
    text.Text = "?"
    text.TextSize = 14
    text.TextScaled = true
    text.BorderSizePixel = 0
    text.BackgroundTransparency = 0.75
    text.Size = UDim2.new(0.5,0,0.5,0)
    text.Position = UDim2.new(0.25,0,0.25,0)
    text.Parent = gui

    local moveRight = CFrame.new(Pip.Size.X,0,0)
    local moveForward = CFrame.new(0,0,Pip.Size.Z)
    local currentPipPosition = Pip.CFrame

    local Domino = require(ServerScriptService.Server.Domino)
    local highestPipValue = 6
    local seed = 5
    local r = Random.new(seed)

    for i = 0,highestPipValue do
        for j = i,highestPipValue do
            Domino.new(i,j)

            local singleDomino = Instance.new("Model")
            local pip = Pip:clone()
            local pip2 = Pip:clone()

            singleDomino.Name = "Domino_" .. i .. "_" .. j
            singleDomino.PrimaryPart = pip

            pip.gui.text.Text = i
            pip2.gui.text.Text = j

            currentPipPosition = currentPipPosition * moveRight
            pip.CFrame = currentPipPosition
            pip2.CFrame = currentPipPosition * moveForward

            pip.Color = Color3.new( (highestPipValue-i)/highestPipValue, 0, i/highestPipValue )
            pip2.Color = Color3.new( (highestPipValue-j)/highestPipValue, 0, j/highestPipValue )

            pip.Name = "Pip_" .. i .. "_" .. j
            pip2.Name = "Pip2_" .. i .. "_" .. j

            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = pip
            WeldConstraint.Part1 = pip2
            WeldConstraint.Parent = WeldConstraint.Part0

            local function pipTouched(part)
                if part.Parent ~= nil
                and part.Parent:FindFirstChild("Humanoid")
                then
                    if pip.AssemblyLinearVelocity == Vector3.zero then
                        local x = r:NextNumber(-1,1)
                        local z = r:NextNumber(-1,1)
                        local force = Vector3.new( 200*x, 2000, 200*z )
                        print(force)
                        pip:ApplyImpulse(force)
                    end
                end
            end
            pip.Touched:Connect(pipTouched)
            pip2.Touched:Connect(pipTouched)

            pip.Anchored = false
            pip2.Anchored = false
            pip.Parent = singleDomino
            pip2.Parent = singleDomino
            singleDomino.Parent = workspace
        end --j = i,highestPipValue
    end --i = 0,highestPipValue

end

-- Initialize
function DrawPileService:KnitInit()

    -- Give player random amount of points:
    self.Client.GiveMeDomino:Connect(function(player,domino)
        self:removeDomino(domino)
        player:giveDomino(domino)
    end)

    -- Clean up data when player leaves:
    game:GetService("Players").PlayerRemoving:Connect(function(player)
    end)

end

return DrawPileService