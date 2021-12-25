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
   self.id = uuid.New().uuid

   return self
end

function stone:Place()

end

function stone:Remove()

end

return stone