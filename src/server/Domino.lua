local Domino = {}
Domino.__index = Domino

function Domino.new(pip1,pip2)
    local self = setmetatable({},Domino)
    self.isDouble = pip1 == pip2
    self.isInverted = false
    self.pip1 = pip1
    self.pip2 = pip2
    return self
end

function Domino:getOutwardValue()
    if self.isDouble then
        return self.pip1 * 2
    elseif self.isInverted then
        return self.pip1
    else
        return self.pip2
    end
end

function Domino:getOutwardPipValue()
    if self.isDouble or self.isInverted then
        return self.pip1
    else
        return self.pip2
    end
end

return Domino