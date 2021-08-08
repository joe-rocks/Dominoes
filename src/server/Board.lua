local States = require(script.Parent.BoardStates)
-- local Domino = require(script.Parent.Domino)

local Board = {}
Board.__index = Board

function Board.new()
    local self = setmetatable({},Board)
    self.currentState = "StartWithSpinner"
    self.Spinner = nil
    self.North = {}
    self.South = {}
    self.East = {}
    self.West = {}
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
            self.Spinner = domino
            return true
        end
    end

    local pip = nil
    if nextState == self.currentState then
        pip = self:getOutwardPipValue(location)
    elseif self.Spinner then
        pip = self.Spinner.pip1
    end

    if not pip then
        return false
    end

    if pip == domino.pip1 then
        self.currentState = nextState
        table.insert(self[location], domino)
        return true
    elseif pip == domino.pip2 then
        self.currentState = nextState
        table.insert(self[location], domino)
        domino.isInverted = true
        return true
    else
        return false
    end
end

return Board