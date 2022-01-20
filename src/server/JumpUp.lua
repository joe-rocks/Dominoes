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

function JumpUp:getGoal()
    local goal = {
        CFrame = self.goalPosition * self.goalRotation
    }
    return goal
end

function JumpUp:getTweenCompleted()
	local tweenCompleted = function()
		self.IsRunning = false
	end
	return tweenCompleted
end

function JumpUp:getTweenObject()
    local tween = TweenService:Create(
        self.part,
        self:getTweenInfo(),
        self:getGoal()
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
    self.TweenTime = 50
    self.RepeatCount = 0
    self.EasingStyle = Enum.EasingStyle.Sine
    self.EasingDirection = Enum.EasingDirection.InOut
    self.IsTweenReverse = false
    self.IsRunning = false
    self.goalPosition = CFrame.new(0,self.part.Size.X,0)
    self.goalRotation = CFrame.Angles(math.rad(-90),0,0)
    return self
end

return JumpUp
