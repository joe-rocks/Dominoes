return function()
    local Domino = require(script.Parent.Domino)
    
    describe("Domino", function()
        it("should not be double", function()
            local result = Domino.new(2,3)
            expect(result.isDouble).to.equal(false)
        end)
        
        it("should be double", function()
            local result = Domino.new(6,6)
            expect(result.isDouble).to.equal(true)
        end)
        
   end)
end