local Domino = {}

function Domino:new(firstPip,secondPip)
    self.isDouble = firstPip == secondPip
    self.firstPip = firstPip
    self.secondPip = secondPip
end

return Domino