local stone = {}
stone.__index = stone

require("love")
require("dependencies/uuid")
require("UI")

function stone.New(owner, row, column)
   local self = setmetatable({}, stone)

   self.__index = self
   self.owner = owner
   self.row = row
   self.column = column
   self.liberties = 4 -- All stones will have an inital liberties of 4.
   self.stoneGroup = nil --No group is associated to the stone from the beginning.
   self.id = uuid.New().uuid

   return self
end

function stone:Place()

end

function stone:Remove()

end

return stone