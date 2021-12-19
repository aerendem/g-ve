local stone = {}
stone.__index = stone

require("love")

function stone.new(owner,position)
   local self = setmetatable({}, stone)

   self.__index = self
   self.owner = owner
   self.position = position
   return self
end

function stone:place()

end

function stone:move()

end

return stone