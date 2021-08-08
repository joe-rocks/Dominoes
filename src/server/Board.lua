local States = require(script.Parent.BoardStates)
-- local Domino = require(script.Parent.Domino)

local Board = {}
Board.__index = Board

function Board.new()
    local self = setmetatable({},Board)
    self.currentState = "StartWithSpinner"
    return self
end

function Board:addDomino(domino,location)
    local state = States[self.currentState]
    local nextState = state.NextState[location]

    if not nextState then
        return false
    end

    if location == "Spinner" then
        if domino.isDouble then
            self.currentState = nextState
            return
        end
    end

    if nextState == self.currentState then
        local pip = self:getOutwardPipValue(location)
        return pip == domino.pip1 or pip == domino.pip2
    end
end

return Board