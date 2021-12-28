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
   self.id = uuid.New().uuid

   self.stoneGroup = nil

   self:AttachGroupOnCreation()

   return self
end

function stone:AttachGroupOnCreation()
   local nearbyGroups = self:GetNearbyGroupToAttach()
   if nearbyGroups == false then
      self:AttachToNewStoneGroup()
   else
      self:AttachToExistingStoneGroup(nearbyGroups)
   end
end

function stone:AttachToExistingStoneGroup(groups)
   if #groups == 1 then
      groups[1]:AddStone(self)
   elseif #groups > 1 then
      self.stoneGroup:MergeWithOtherGroups(groups)
   end
end

function stone:AttachToNewStoneGroup()
   self.stoneGroup = stoneGroup.New(owner, self)
   self.stoneGroup:CalculateLiberties()
end

function stone:GetNearbyGroupToAttach()
   local onBoardStones = board:GetStones()

   local connectedGroups = {}
   local connectedStones = {}

   local left, right = self.coordinates:GetX() - 1, self.coordinates:GetX() + 1
   local up, down = self.coordinates:GetY() - 1, self.coordinates:GetY() + 1

   for index, otherStone in ipairs(onBoardStones) do
      
      if otherStone.owner == self.owner then
         if (otherStone.coordinates.col == left or otherStone.coordinates.col == right) and otherStone.coordinates.row == self.coordinates:GetY() then
            table.insert(connectedStones, otherStone)
         elseif (otherStone.coordinates.row == up or otherStone.coordinates.row == down) and otherStone.coordinates.col == self.coordinates:GetX() then
            table.insert(connectedStones, otherStone)
         end
      end
   end

   if table.empty(connectedStones) == true then
      return false
   end

   for index, connectedStone in ipairs(connectedStones) do
      if table.find(connectedGroups, connectedStone.stoneGroup) == nil then
         table.insert(connectedGroups, connectedStone.stoneGroup)
      end
   end

   if table.empty(connectedGroups) == true then
      return false
   end

   return connectedGroups
end


function stone:Destroy()
   self.stoneGroup:Destroy()
   self = nil
end

return stone