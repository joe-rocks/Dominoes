return function()
    local Domino = require(script.Parent.Domino)
    local Board = require(script.Parent.Board)
    
    describe("Add", function()
        it("should add a double to a blank board", function()
            local board = Board.new()
            board:addDomino(Domino.new(6,6),"Spinner")
            expect(board.currentState).to.equal("Spinner")
        end)
        
        it("should not add a regular domino to a blank board", function()
            local board = Board.new()
            board:addDomino(Domino.new(2,3),"Spinner")
            expect(board.currentState).to.equal("StartWithSpinner")
        end)

        it("should fill the board", function()
            local board = Board.new()
            board:addDomino(Domino.new(6,6),"Spinner")
            board:addDomino(Domino.new(6,3),"North")
            board:addDomino(Domino.new(6,5),"South")
            board:addDomino(Domino.new(6,2),"East")
            board:addDomino(Domino.new(6,0),"West")
            expect(board.currentState).to.equal("Full")
        end)
        
        it("should not accept invalid spinner", function()
            local board = Board.new()
            local result = board:addDomino(Domino.new(6,3),"Spinner")
            expect(result).to.equal(false)
            board:addDomino(Domino.new(6,6),"Spinner")
            result = board:addDomino(Domino.new(5,5),"Spinner")
            expect(result).to.equal(false)
        end)
        
        it("should handle dominoes without spinner", function()
            local board = Board.new("StartWithAny")
            board:addDomino(Domino.new(6,4),"North")
            board:addDomino(Domino.new(4,3),"North")
            local result = board:addDomino(Domino.new(6,2),"North")
            expect(result).to.equal(false)
            result = board:addDomino(Domino.new(6,2),"South")
            expect(result).to.equal(true)
            expect(board.currentState).to.equal("North")
        end)
        
    end)

    describe("Score", function()
        it("should score 0", function()
            local board = Board.new()
            board:addDomino(Domino.new(6,6),"Spinner")
            expect(board:getScore()).to.equal(0)
        end)
        
        it("should score 15", function()
            local board = Board.new()
            board:addDomino(Domino.new(6,6),"Spinner")
            board:addDomino(Domino.new(6,3),"North")
            expect(board:getScore()).to.equal(15)
        end)
        
    end)
end