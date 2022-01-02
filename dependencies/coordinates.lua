-------------------------
--Declaration
-------------------------
local coordinates = {}
coordinates.__index = coordinates

-------------------------
--Dependencies
-------------------------
require("love")

-------------------------
--Constructor
-------------------------
function coordinates.New(x, y)
   local self = setmetatable({}, coordinates)

   self.__index = self
   self.col = x or nil --Column
   self.row = y or nil --Row

   return self
end

--Returns X position, column
function coordinates:GetX()
    return self.col
end

--Returns Y position, row
function coordinates:GetY()
    return self.row
end

--Compares two coordinates and returns false if it's same
function coordinates:Compare(otherCoordinate)
    if otherCoordinate == nil then
        return true
    end

    if self.col == otherCoordinate.col and self.row == otherCoordinate.row then
        return false
    end

    return true
end

return coordinates