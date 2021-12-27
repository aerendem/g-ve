local coordinates = {}
coordinates.__index = coordinates

require("love")

function coordinates.New(x, y)
   local self = setmetatable({}, coordinates)

   self.__index = self
   self.col = x or nil
   self.row = y or nil

   return self
end

function coordinates:GetX()
    return self.col
end

function coordinates:GetY()
    return self.row
end

function coordinates:Compare(otherCoordinate)
    if self.col == otherCoordinate.col and self.row == otherCoordinate.row then
        return false
    end

    return true
end

function coordinates:UnionWith()

end

return coordinates