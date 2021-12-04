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
    gui.Parent = Pip
    local text = Instance.new("TextLabel")
    text.Name = "text"
    text.Text = "?"
    text.Size = UDim2.new(0,100,0,100)
    text.Position = UDim2.new(0.5,0,0.5,0)
    text.Parent = gui

    local moveRight = CFrame.new(Pip.Size.X,0,0)
    local moveForward = CFrame.new(0,0,Pip.Size.Z)
    local currentPipPosition = Pip.CFrame

    local Domino = require(ServerScriptService.Server.Domino)
    local highestPipValue = 6

    for i = 0,highestPipValue do
        for j = i,highestPipValue do
            Domino.new(i,j)
            local pip = Pip:clone()
            local pip2 = Pip:clone()

            pip.gui.text.Text = i
            pip2.gui.text.Text = j

            currentPipPosition = currentPipPosition * moveRight
            pip.CFrame = currentPipPosition
            pip2.CFrame = currentPipPosition * moveForward

            pip.Color = Color3.new((highestPipValue-i)/highestPipValue,0,i/highestPipValue)
            pip2.Color = Color3.new((highestPipValue-j)/highestPipValue,0,j/highestPipValue)

            pip.Name = "Pip_" .. i .. "_" .. j
            pip2.Name = "Pip2_" .. i .. "_" .. j

            pip.Parent = workspace
            pip2.Parent = workspace
        end
    end
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