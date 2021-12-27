local stone = {}
stone.__index = stone

require("love")
require("dependencies/uuid")
require("UI")
require("logic/board")

local pprint = require("dependencies/pprint")
local stoneGroup = require("logic/stonegroup")
local coordinates = require("dependencies/coordinates")

function stone.New(owner, row, column)
   local self = setmetatable({}, stone)

   self.__index = self
   self.owner = owner
   self.coordinates = coordinates.New(column, row)
   self.liberties = 4 -- All stones will have an inital liberties of 4.
   self.stoneGroup = nil --No group is associated to the stone from the beginning.
   self.id = uuid.New().uuid

   self.stoneGroup = stoneGroup.New(owner, self)

   --Check for stone groups
   self:JoinGroup()

   return self
end


function stone:JoinGroup()
   local onBoardStones = board:GetStones()

   local connectedGroups = {}
   local connectedStones = {}

   local left, right = self.coordinates:GetX() - 1, self.coordinates:GetX() + 1
   local up, down = self.coordinates:GetY() - 1, self.coordinates:GetY() + 1

   for index, otherStone in ipairs(onBoardStones) do
      
      if otherStone.owner == self.owner then
         if (otherStone.coordinates.col == left or otherStone.coordinates.col == right) and otherStone.coordinates.row == self.coordinates:GetY() then
            table.insert(connectedStones, otherStone)
            print("INSERTED TO TABLE")
         elseif (otherStone.coordinates.row == up or otherStone.coordinates.row == down) and otherStone.coordinates.col == self.coordinates:GetX() then
            table.insert(connectedStones, otherStone)
            print("INSERTED TO TABLE")
         end
      end
   end

   if table.empty(connectedStones) == true then
      print("EMPTY CONNECTED STONES")
      return
   end

   for index, connectedStone in ipairs(connectedStones) do
      table.insert(connectedGroups, connectedStone.stoneGroup)
   end

   if table.empty(connectedGroups) == true then
      print("EMPTY CONNECTED GROUPS")
      return
   end

   self.stoneGroup:MergeGroups(connectedGroups)
end

function stone:LeaveGroup()
   if self.stoneGroup == nil then
      return
   end


end

function stone:Place()

end

function stone:Destroy()
   self.stoneGroup:Destroy()
   self = nil
end

return stone