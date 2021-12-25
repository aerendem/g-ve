local stoneGroup = {}
stoneGroup.__index = stoneGroup

require("love")
require("dependencies/uuid")
require("UI")
require("dependencies/table")

function stoneGroup.New(owner, row, column)
   local self = setmetatable({}, stoneGroup)

   self.__index = self
   self.id = uuid.New().uuid
   self.owner = owner
   self.color = column
   self.stones = {}
   self.liberties = {}
   self.adjacents = {}

   return self
end

function stoneGroup:GetLiberties()
    return self.liberties
end

function stoneGroup:GetStones()
    return self.stones
end

function stoneGroup:AddStone(stone)
    table.insert(self.stones, stone)
end

function stoneGroup:RemoveStone()
    self.stones[table.find(self.stones, stone)] = nil
end

function stoneGroup:MergeGroup()
    -- _stones.UnionWith(slaveGroup.GetStones());
    -- _liberties.UnionWith(slaveGroup.GetLiberties());
    -- _adjacent.UnionWith(slaveGroup.GetAdjacent());

    -- foreach (Coord coord in _stones)
    -- {
    --     _liberties.RemoveWhere(c => c.Row == coord.Row && c.Column == coord.Column);
    -- }
end

function stoneGroup:Destroy()
    self = nil
end

return stoneGroup