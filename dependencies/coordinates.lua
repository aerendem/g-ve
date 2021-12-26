local coordinates = {}
coordinates.__index = coordinates

require("love")

function coordinates.New(x, y)
   local self = setmetatable({}, coordinates)

   self.__index = self
   self.x = x or nil
   self.y = y or nil

   return self
end

function coordinates:GetX()
    return self.x
end

function coordinates:GetY()
    return self.y
end

function coordinates:UnionWith()

end

return coordinates