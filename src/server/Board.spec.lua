return function()
    local Domino = require(script.Parent.Domino)
    local Board = require(script.Parent.Board)
    
    describe("Board", function()
        it("should add a double to a blank board", function()
            local domino = Domino.new(6,6)
            local board = Board.new()
            board:addDomino(domino,"Spinner")
            expect(board.currentState).to.equal("Spinner")
        end)
        
        it("should not add a regular domino to a blank board", function()
            local domino = Domino.new(2,3)
            local board = Board.new()
            board:addDomino(domino,"Spinner")
            expect(board.currentState).to.equal("StartWithSpinner")
        end)
        
        
   end)
end