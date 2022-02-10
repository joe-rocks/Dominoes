--Take a domino that is laying down and have it jump up onto its "feet"

local JumpUp = {}
JumpUp.__index = JumpUp

local TweenService = game:GetService("TweenService")

function JumpUp:getTweenInfo()
    local ti = TweenInfo.new(
        self.TweenTime,
        self.EasingStyle,
        self.EasingDirection,
        self.RepeatCount,
        self.IsTweenReverse
    )
    return ti
end

function JumpUp:getTweenCompleted()
	local tweenCompleted = function()
		self.IsRunning = false
        self.part.CFrame = self.goal
        self.part.Anchored = true
	end
	return tweenCompleted
end

function JumpUp:getTweenObject()
    local tween = TweenService:Create(
        self.CFrame,
        self:getTweenInfo(),
        { Value = self.goal }
    )
	-- On tween completion, make object clickable again
	tween.Completed:Connect(self:getTweenCompleted())
    return tween
end

function JumpUp:activate()
	-- If the object is tweening, prevent it from being tweened again
	if self.IsRunning then
		return
	end

	-- Create a tween and play 
    local tweenObject = self:getTweenObject()
	tweenObject:Play()
	self.IsRunning = true

end

function JumpUp.new(part)
    local self = setmetatable({},JumpUp)
    self.part = part
    self.TweenTime = 2
    self.RepeatCount = 0
    self.EasingStyle = Enum.EasingStyle.Linear
    self.EasingDirection = Enum.EasingDirection.Out
    self.IsTweenReverse = false
    self.IsRunning = false

    self.CFrame = Instance.new("CFrameValue")
    self.CFrame.Value = self.part.CFrame
    self.CFrame:GetPropertyChangedSignal("Value"):Connect(function()
        -- local distance = (self.part.CFrame.Position - self.CFrame.Value.Position).Magnitude
        -- if distance > 10000 then
        --     print(distance)
        -- end
        self.part.CFrame = self.CFrame.Value
    end)

    --Troubleshoot why eventually lands way far out: 6595266.5, 11761833, 462782.75
    local goalPosition = CFrame.new(0,self.part.Size.X,0)
    local goalRotation = CFrame.Angles(math.rad(-90),0,math.rad(-90))
    local relativeGoal = goalPosition * goalRotation
    self.goal = part.CFrame * relativeGoal

    return self
end

return JumpUp
