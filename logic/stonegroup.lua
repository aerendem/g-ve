-------------------------
--Declaration
-------------------------
local stoneGroup = {}
stoneGroup.__index = stoneGroup

-------------------------
--Dependencies
-------------------------
require("love")
require("dependencies/uuid")
require("UI")
require("dependencies/table")
require("logic/board")
local pprint = require("dependencies/pprint")
local coordinates = require("dependencies/coordinates")

-------------------------
--Constructor
-------------------------
function stoneGroup.New(owner, firstStone)
   local self = setmetatable({}, stoneGroup)

   self.__index = self
   self.id = uuid.New().uuid
   self.owner = owner
   self.stones = {firstStone}
   self.liberties = {} --Coordinate data of liberties of stone group
   self.adjacents = {}

   return self
end

---Used to get liberties of stone group
function stoneGroup:GetLiberties()
    return self.liberties
end

---Used to get stones in stone group
function stoneGroup:GetStones()
    return self.stones
end

---Used to add stone in stone group
function stoneGroup:AddStone(stone)
    if table.find(self.stones, stone) == nil then
        table.insert(self.stones, stone)
    end
   
    stone.stoneGroup = self
end

---Used to remove stone from stone group
function stoneGroup:RemoveStone()
    self.stones[table.find(self.stones, stone)] = nil
end

---Used to check liberties of stone group and if there is none, calls capturing function for stone group
function stoneGroup:CheckForCapture()
    local groupLiberties = self:FindLiberties()

    if groupLiberties == nil then
        return false
    end

    if #groupLiberties == 0 then
        local removedStoneCount = self:CaptureGroup()
        return true, removedStoneCount
    else
        return false
    end
end

---Used to find liberties of each stone in stone group
function stoneGroup:FindLiberties()
    table.clear(self.liberties)

    local groupLiberties = {}

    for _,v in ipairs(self.stones) do
       local farthestLeftCoordinate =  self:GetFarthestLiberty(v.coordinates,"Left",v)
       local farthestRightCoordinate =  self:GetFarthestLiberty(v.coordinates,"Right",v)
       local farthestUpCoordinate =  self:GetFarthestLiberty(v.coordinates,"Up",v)
       local farthestDownCoordinate =  self:GetFarthestLiberty(v.coordinates,"Down",v)

        if farthestLeftCoordinate ~= false then
            table.insert(groupLiberties,farthestLeftCoordinate)
        end
        if farthestRightCoordinate ~= false then
            table.insert(groupLiberties,farthestRightCoordinate)
        end
        if farthestUpCoordinate ~= false then
            table.insert(groupLiberties,farthestUpCoordinate)
        end
        if farthestDownCoordinate ~= false then
            table.insert(groupLiberties,farthestDownCoordinate)
        end
    end

    for _,v in ipairs(groupLiberties) do
        if table.find(self.liberties, v) == nil then
            table.insert(self.liberties, v)
        end
    end

    return self.liberties
end

---Used to find farthest liberty of stone with controlling 4 sides of stone recursively
function stoneGroup:GetFarthestLiberty(startingPos,destination,stone, returnArg)
    local board = board.GetInstance()
    local onBoardStones = board:GetStones()
    local returnValue   
    local stone = stone

    if returnArg ~= nil then
        returnValue = returnArg
    else
        returnValue = false
    end
    
    if destination == "Left" then
        local leftCoordinates = coordinates.New(startingPos.col - 1, startingPos.row)
        if startingPos.col > 1 then
            for i,boardStone in ipairs(onBoardStones) do
                if leftCoordinates:Compare(boardStone.coordinates) == false and boardStone.owner ~= stone.owner then
                    if returnArg ~= nil and board:GetSameCoordinateStone(startingPos) == false then
                        return startingPos
                    end
                    
                    return false
                end

                if boardStone.coordinates:Compare(leftCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                    stone = boardStone
                end
            end
            returnValue = self:GetFarthestLiberty(leftCoordinates ,"Left", stone, returnValue) 
        
        else
            if stone.coordinates.col == 1 then
                return false
            else
                local liberty = coordinates.New(stone.coordinates.col-1,stone.coordinates.row)

                for _,boardStone in ipairs(onBoardStones) do
                    if leftCoordinates:Compare(boardStone.coordinates) == false  then
                        return false
                    end
                end

                return liberty
            end
        end

    elseif destination == "Right" then
        local rightCoordinates = coordinates.New(startingPos.col + 1, startingPos.row)
        if startingPos.col < 9 then
            
            for i,boardStone in ipairs(onBoardStones) do
                if rightCoordinates:Compare(boardStone.coordinates) == false and boardStone.owner ~= stone.owner then
                    if returnArg ~= nil and board:GetSameCoordinateStone(startingPos) == false then
                        return startingPos
                    end
                    return false
                end

                if boardStone.coordinates:Compare(rightCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                    stone = boardStone
                end
            end
            returnValue =  self:GetFarthestLiberty(rightCoordinates,"Right",stone, returnValue) 
            
        else
            if stone.coordinates.col == 9 then
                return false
            else
                local liberty = coordinates.New(stone.coordinates.col+1,stone.coordinates.row)
                for _,boardStone in ipairs(onBoardStones) do
                    if rightCoordinates:Compare(boardStone.coordinates) == false  then
                        return false
                    end
                end
                return liberty
            end
        end

    elseif destination == "Up" then
        local upCoordinates  = coordinates.New(startingPos.col, startingPos.row - 1)
        if startingPos.row > 1 then
            for i,boardStone in ipairs(onBoardStones) do
                if upCoordinates:Compare(boardStone.coordinates) == false and boardStone.owner ~= stone.owner then
                    if returnArg ~= nil and board:GetSameCoordinateStone(startingPos) == false then
                        return startingPos
                    end

                    return false
                end

                if boardStone.coordinates:Compare(upCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                    stone = boardStone
                end
            end
            returnValue = self:GetFarthestLiberty(upCoordinates,"Up",stone, returnValue) 
            
        else
            if stone.coordinates.row == 1 then
                return false
            else
                local liberty = coordinates.New(stone.coordinates.col,stone.coordinates.row - 1)
                for _,boardStone in ipairs(onBoardStones) do
                    if upCoordinates:Compare(boardStone.coordinates) == false  then
                        return false
                    end
                end
                return liberty
            end
        end

    elseif destination == "Down" then
        local  downCoordinates = coordinates.New(startingPos.col, startingPos.row + 1)
        if startingPos.row < 9 then
            for i,boardStone in ipairs(onBoardStones) do
                if downCoordinates:Compare(boardStone.coordinates) == false and boardStone.owner ~= stone.owner then
                    if returnArg ~= nil and board:GetSameCoordinateStone(startingPos) == false then
                        return startingPos
                    end
                    return false
                end

                if boardStone.coordinates:Compare(downCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                    stone = boardStone
                end
            end
            returnValue = self:GetFarthestLiberty(downCoordinates,"Down",stone, returnValue) 
            
        else
            if stone.coordinates.row == 9 then
                return false
            else
                local liberty = coordinates.New(stone.coordinates.col,stone.coordinates.row + 1)
                for _,boardStone in ipairs(onBoardStones) do
                    if downCoordinates:Compare(boardStone.coordinates) == false  then
                        return false
                    end
                end
                return liberty
            end
        end
    end

    return returnValue 
end

---Used to remove each stone in captured group
function stoneGroup:CaptureGroup()
    local board = board.GetInstance()
    local removedStoneCount = 0
    for _,v in ipairs(self.stones) do
        board:RemoveStoneFromBoard(v)
        removedStoneCount = removedStoneCount + 1
    end

    return removedStoneCount
end

---Used to merge different groups and remove empty groups
function stoneGroup:MergeWithOtherGroups(otherGroups)
    for _, otherGroup in ipairs(otherGroups) do
        if otherGroup ~= self and self.owner == otherGroup.owner then
            for _,stone in ipairs(otherGroup.stones) do
                stone.stoneGroup = self
                self:AddStone(stone)
            end
            otherGroup:Destroy()
        end
    end

    self:FindLiberties()

    return self 
end

---Used destroy stone group
function stoneGroup:Destroy()
    self = nil
end

return stoneGroup