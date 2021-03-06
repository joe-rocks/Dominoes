local States = require(script.Parent.BoardStates)
-- local Domino = require(script.Parent.Domino)

local Board = {}
Board.__index = Board

function Board.new(start)
    local self = setmetatable({},Board)
    self.currentState = start or "StartWithSpinner"
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

    if self.currentState == "StartWithAny" then
        table.insert(self.North, domino)
        self.currentState = nextState
        return true
    end

    if location == "Spinner" then
        if domino.isDouble then
            self.currentState = nextState
            self.Spinner = domino
            return true
        end
	elseif self.currentState == "North" and location == "South" then
		local southDomino = self.North[1]
        local southPip = southDomino.isInverted and southDomino.pip2 or southDomino.pip1
        if southPip == domino.pip1 then
            table.insert(self[location], 1, domino)
            domino.isInverted = true
            return true
        elseif southPip == domino.pip2 then
            table.insert(self[location], 1, domino)
            return true
        else
            return false
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

function Board:getOutwardPipValue(location)
    local domino = self:getLastDomino(location)
    return domino:getOutwardPipValue()
end

function Board:getScore(location)
    if not location then
        local score = 0
        local state = States[self.currentState]
        local scoreLocations = state.Score
        for _,loc in ipairs(scoreLocations) do
            score += self:getScore(loc)
        end
        if score % 5 ~= 0 then
            print("No score"..score)
            score = 0
        end
        return score
    end

    local domino = self:getLastDomino(location)
    return domino:getOutwardValue()
end

function Board:getLastDomino(location)
    local dominoList = self[location]
    if not dominoList or location == "Spinner" then
        return dominoList
    end

    if #dominoList == 0 then
        return nil
    else
        return dominoList[#dominoList]
    end
end

return Board