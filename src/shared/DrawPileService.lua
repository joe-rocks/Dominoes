local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)
-- local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
-- local RemoteProperty = require(Knit.Util.Remote.RemoteProperty)
local Domino = require(ServerScriptService.Server.Domino)
local JumpUp = require(ServerScriptService.Server.JumpUp)

local DrawPileService = Knit.CreateService {
    Name = "DrawPileService";
    DrawPile = {};
    Client = {
        GiveMeDomino = RemoteSignal.new();
    };
}

DrawPileService.highestPipValue = 6

function DrawPileService:removeDomino(domino)
    self.DrawPile[domino] = nil
end

function DrawPileService:shuffle()
    local dp = self.DrawPile
    local n = #dp
    for i = 0,self.highestPipValue*self.highestPipValue do
		local x = self.rand:NextInteger(1,n)
		local y = self.rand:NextInteger(1,n)
        print(i,x,y)

        local a = dp[x].model.PrimaryPart
        local b = dp[y].model.PrimaryPart
		a.CFrame,b.CFrame = b.CFrame,a.CFrame
    end
end

function DrawPileService:singleTween()
    local part = Instance.new("Part")
    part.Anchored = true
    part.Position += Vector3.new(0,10,-10)
    part.Parent = workspace
    local ti = TweenInfo.new(
        1,
        Enum.EasingStyle.Bounce,
        Enum.EasingDirection.In,
        20,
        false
    )
    local goalPosition = CFrame.new(0,part.Size.X,0)
    local goalRotation = CFrame.Angles(0,0,math.rad(-90))
    local goal = {
        CFrame = part.CFrame:ToWorldSpace(goalPosition * goalRotation)
    }
    local tween = game:GetService("TweenService"):Create(
        part,
        ti,
        goal
    )
    tween:Play()
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

    local seed = 5
    self.rand = Random.new(seed)

    for i = 0,DrawPileService.highestPipValue do
        for j = i,DrawPileService.highestPipValue do
            local domino = {}
            domino.object = Domino.new(i,j)

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

            pip.Color = Color3.new( (DrawPileService.highestPipValue-i)/DrawPileService.highestPipValue, 0, i/DrawPileService.highestPipValue )
            pip2.Color = Color3.new( (DrawPileService.highestPipValue-j)/DrawPileService.highestPipValue, 0, j/DrawPileService.highestPipValue )

            pip.Name = "Pip_" .. i .. "_" .. j
            pip2.Name = "Pip2_" .. i .. "_" .. j

            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = pip
            WeldConstraint.Part1 = pip2
            WeldConstraint.Parent = WeldConstraint.Part0

            local touchedPart = nil
            local pipTouched,pipTouchEnded
            local touchedSignal,touchedSignal2
            local touchEndedSignal,touchEndedSignal2
            local function launchDomino()
                local x = self.rand:NextNumber(-1,1)
                local z = self.rand:NextNumber(-1,1)
                local force = Vector3.new( 200*x, 2000, 200*z )
                print(j,i,force)
                pip:ApplyImpulse(force)
            end
            pipTouched = function (part)
                if not touchedPart
                and part.Parent ~= nil
                and part.Parent:FindFirstChild("Humanoid")
                and pip.AssemblyLinearVelocity == Vector3.zero then
                    touchedPart = part
                    touchedSignal:Disconnect()
                    touchedSignal2:Disconnect()
                    touchEndedSignal = pip.TouchEnded:Connect(pipTouchEnded)
                    touchEndedSignal2 = pip2.TouchEnded:Connect(pipTouchEnded)
                end
            end
            pipTouchEnded = function (part)
                if touchedPart == part then
                    touchedPart = nil
                    touchEndedSignal:Disconnect()
                    touchEndedSignal2:Disconnect()
                    touchedSignal = pip.Touched:Connect(pipTouched)
                    touchedSignal2 = pip2.Touched:Connect(pipTouched)
                    -- launchDomino()
                end
            end
            touchedSignal = pip.Touched:Connect(pipTouched)
            touchedSignal2 = pip2.Touched:Connect(pipTouched)

            pip.Anchored = false
            pip2.Anchored = false
            pip.Parent = singleDomino
            pip2.Parent = singleDomino
            singleDomino.Parent = workspace
            domino.model = singleDomino--should be called "model"?
            table.insert(self.DrawPile, domino)
        end --j = i,highestPipValue
    end --i = 0,highestPipValue

    self:shuffle()

    wait(5)
    for _,v in ipairs(self.DrawPile) do
        local j = JumpUp.new(v.model.PrimaryPart)
        j:activate()
    end

    self:singleTween()
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