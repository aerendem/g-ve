-------------------------
--Declaration
-------------------------
local stone = {}
stone.__index = stone

-------------------------
--Dependencies
-------------------------
require("love")
require("dependencies/uuid")
require("UI")
require("logic/board")
local stoneGroup = require("logic/stonegroup")
local coordinates = require("dependencies/coordinates")

-------------------------
--Constructor
-------------------------
function stone.New(owner, row, column)
   local self = setmetatable({}, stone)

   self.__index = self

   --Player object that acts as owner of stone
   self.owner = owner

   --Coordinates of stone that been put on the board
   self.coordinates = coordinates.New(column, row)

   --Vacant points that adjacent to stone in a orthogonal direction, starts with 4
   self.liberties = 4

   --Unique id, aka GUID(Globally Unique Identifier)
   self.id = uuid.New().uuid

   --Attributed stone group, can be the only member
   self.stoneGroup = stoneGroup.New(self.owner, self)

   --Attaches group to stone
   self:AttachGroupOnCreation()

   return self
end

---Attaches stone to nearby adjacent group or calls function to create a new group for stone
function stone:AttachGroupOnCreation()
   local nearbyGroups = self:GetNearbyGroupToAttach()
   if nearbyGroups == false or nearbyGroups == nil then
      self:AttachToNewStoneGroup()
   else
      self:AttachToExistingStoneGroup(nearbyGroups)
   end
end

---Attaches(merges) to adjacent groups
function stone:AttachToExistingStoneGroup(groups)
   if #groups == 1 then
      groups[1]:AddStone(self)
   elseif #groups > 1 then
      self.stoneGroup:MergeWithOtherGroups(groups)
   end
end

---Creates a new stone group via stoneGroup class
function stone:AttachToNewStoneGroup()
   self.stoneGroup = stoneGroup.New(owner, self)
   self.stoneGroup:FindLiberties()
end

---Returns adjacent stone groups to stone if there is
function stone:GetNearbyGroupToAttach()
   local onBoardStones = board:GetStones()

   local connectedGroups = {}
   local connectedStones = {}

   --Directions to go
   local left, right = self.coordinates:GetX() - 1, self.coordinates:GetX() + 1
   local up, down = self.coordinates:GetY() - 1, self.coordinates:GetY() + 1

   --Iterates over all the stones on the board
   for index, otherStone in ipairs(onBoardStones) do
      if otherStone.owner == self.owner then
         if (otherStone.coordinates.col == left or otherStone.coordinates.col == right) and otherStone.coordinates.row == self.coordinates:GetY() then
            table.insert(connectedStones, otherStone)
         elseif (otherStone.coordinates.row == up or otherStone.coordinates.row == down) and otherStone.coordinates.col == self.coordinates:GetX() then
            table.insert(connectedStones, otherStone)
         end
      end
   end

   --Return false if there is no connected/adjacent stones
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

---Destroyer method
function stone:Destroy()
   self.stoneGroup:Destroy()
   self = nil
end

return stone