local Domino = {}

function Domino:new(pip1,pip2)
    self.isDouble = pip1 == pip2
    self.isPointingInward = false
    self.pip1 = pip1
    self.pip2 = pip2
end

function Domino:getOutwardValue()
    if self.isDouble then
        return self.pip1 * 2
    elseif self.isPointingInward then
        return self.pip1
    else
        return self.pip2
    end
end

function Domino:getOutwardPipValue()
    if self.isDouble or self.isPointingInward then
        return self.pip1
    else
        return self.pip2
    end
end

return Domino