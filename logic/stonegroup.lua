local stoneGroup = {}
stoneGroup.__index = stoneGroup

require("love")
require("dependencies/uuid")
require("UI")
require("dependencies/table")
require("logic/board")
local pprint = require("dependencies/pprint")
local coordinates = require("dependencies/coordinates")

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

function stoneGroup:GetLiberties()
    return self.liberties
end

function stoneGroup:GetStones()
    return self.stones
end

function stoneGroup:AddStone(stone)
    if table.find(self.stones, stone) == nil then
        table.insert(self.stones, stone)
    end
   
    stone.stoneGroup = self
end

function stoneGroup:RemoveStone()
    self.stones[table.find(self.stones, stone)] = nil
end

function stoneGroup:CheckForCapture()
    --local groupLiberties = self:CalculateLiberties()
    local groupLiberties = self:FindLiberties()

    if groupLiberties == nil then
        return 
    end

    if #groupLiberties == 0 then
        print(#groupLiberties)
        pprint("self.liberties", self.liberties)
        pprint("self.owner", self.owner)
        self:CaptureGroup()
    end
end

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

    pprint("************************************************************")
    pprint(self.liberties)
    return self.liberties
end

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
                    return false
                end

                if boardStone.coordinates:Compare(leftCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                    stone = boardStone
                end
            end
            returnValue = self:GetFarthestLiberty(leftCoordinates ,"Left", stone, returnValue) 
        
        else
            print("Checked last col")
            if stone.coordinates.col == 1 then
                print("last stone is in col 1")
                return false
            else
                print("LAST STONE FOUND", liberty)
                local liberty = coordinates.New(stone.coordinates.col-1,stone.coordinates.row)

                for _,boardStone in ipairs(onBoardStones) do
                    if leftCoordinates:Compare(boardStone.coordinates) == false  then
                        return false
                    end
                end

                return liberty
            end
            -- leftCoordinates = coordinates.New(1, startingPos.row)
            -- foundLeft = true
        end
    elseif destination == "Right" then
        local rightCoordinates = coordinates.New(startingPos.col + 1, startingPos.row)
        if startingPos.col < 9 then
            
            for i,boardStone in ipairs(onBoardStones) do
                if rightCoordinates:Compare(boardStone.coordinates) == false and boardStone.owner ~= stone.owner then
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
            -- leftCoordinates = coordinates.New(1, startingPos.row)
            -- foundLeft = true
        end

    elseif destination == "Up" then
        local upCoordinates  = coordinates.New(startingPos.col, startingPos.row - 1)
        if startingPos.row > 1 then
            for i,boardStone in ipairs(onBoardStones) do
                if upCoordinates:Compare(boardStone.coordinates) == false and boardStone.owner ~= stone.owner then
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
            -- leftCoordinates = coordinates.New(1, startingPos.row)
            -- foundLeft = true
        end
    elseif destination == "Down" then
        local  downCoordinates = coordinates.New(startingPos.col, startingPos.row + 1)
        if startingPos.row < 9 then
            for i,boardStone in ipairs(onBoardStones) do
                if downCoordinates:Compare(boardStone.coordinates) == false and boardStone.owner ~= stone.owner then
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
            -- leftCoordinates = coordinates.New(1, startingPos.row)
            -- foundLeft = true
        end
    end

    return returnValue 
end

function getFarthestLiberty(startingPos, stone)
    local board = board.GetInstance()
    local onBoardStones = board:GetStones()
    local returnValues = {}
    local foundLeft = false
    local foundRight = false
    local foundUp = false
    local foundDown = false
    local leftCoordinates, rightCoordinates, upCoordinates, downCoordinates

    if startingPos.col > 1 then
        leftCoordinates = coordinates.New(tartingPos.col - 1, startingPos.row)
        for i,boardStone in ipairs(onBoardStones) do
            if boardStone.coordinates:Compare(leftCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                stone = boardStone
            end
        end
        getFarthestLiberty(leftCoordinates,stone) 
        
    else
        if stone.coordinates.col == 1 then
            return false
        else
            local liberty = coordinates.New(stone.coordinates.col-1,stone.coordinates.row)
            return liberty
        end
        leftCoordinates = coordinates.New(1, startingPos.row)
        foundLeft = true
    end

    if startingPos.col < 9 then
        rightCoordinates = coordinates.New(tartingPos.col + 1, startingPos.row)
        for i,boardStone in ipairs(onBoardStones) do
            if boardStone.coordinates:Compare(rightCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                stone = boardStone
            end
        end
        getFarthestLiberty(rightCoordinates,stone)
    else
        rightCoordinates = coordinates.New(9, startingPos.row)
        foundRight = true
    end

    if startingPos.row > 1 then
        upCoordinates = coordinates.New(tartingPos.col , startingPos.row-1)
        for i,boardStone in ipairs(onBoardStones) do
            if boardStone.coordinates:Compare(upCoordinates) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                stone = boardStone
            end
        end
        getFarthestLiberty(upCoordinates,stone) 
    else
        upCoordinates = coordinates.New(tartingPos.col , startingPos.row-1)
        foundUp = true
    end

    local downCoordinates
    if startingPos.col < 9 then
        local newCordinate = coordinates.New(tartingPos.col , startingPos.row + 1)
        for i,boardStone in ipairs(onBoardStones) do
            if boardStone.coordinates:Compare(newCordinate) == false and boardStone.owner == stone.owner and stone.stoneGroup.id == boardStone.stoneGroup.id then
                stone = boardStone
            end
        end
        getFarthestLiberty(newCordinate,stone) 
    else
        
       foundDown = true
    end

    
end

function stoneGroup:CalculateLiberties()
    local board = board.GetInstance()
    local onBoardStones = board:GetStones()

    table.clear(self.liberties)

    for i,groupStone in ipairs(self.stones) do
        local stoneLiberties = {}

        local left, up, right, down = groupStone.coordinates.col - 1, groupStone.coordinates.row - 1, groupStone.coordinates.col + 1, groupStone.coordinates.row + 1
        local isLeftEmpty = true
        local isRightEmpty = true
        local isUpEmpty = true
        local isDownEmpty = true

        for i, sameGroupStone in ipairs(self.stones) do
            if sameGroupStone ~= groupStone then
                if sameGroupStone.coordinates.col == left then
                    isLeftEmpty = false
                elseif sameGroupStone.coordinates.col == right then
                    isRightEmpty = false
                end
                if sameGroupStone.coordinates.row == up then
                    isUpEmpty = false
                elseif sameGroupStone.coordinates.row == down then
                    isDownEmpty = false
                end
            end
        end

        for index, stone in ipairs(onBoardStones) do
            if stone ~= groupStone then
                if stone.coordinates.col == left then
                    isLeftEmpty = false
                end
                if stone.coordinates.col == right then
                    isRightEmpty = false
                end
                if stone.coordinates.row == up then
                    isUpEmpty = false
                end
                if stone.coordinates.row == down then
                    isDownEmpty = false
                end
            end
        end

        if isLeftEmpty then
            local coordinates = coordinates.New(left, groupStone.coordinates.row)
            table.insert(stoneLiberties, coordinates)
        end

        if isRightEmpty then
            local coordinates = coordinates.New(right, groupStone.coordinates.row)
            table.insert(stoneLiberties, coordinates)
        end

        if isUpEmpty then
            local coordinates = coordinates.New(groupStone.coordinates.col, up)
            table.insert(stoneLiberties, coordinates)
        end

        if isDownEmpty then
            local coordinates = coordinates.New(groupStone.coordinates.col, down)
            table.insert(stoneLiberties, coordinates)
        end

        for _,v in ipairs(stoneLiberties) do
            table.insert(self.liberties, v)
        end
    end

    return self.liberties
end

function stoneGroup:CaptureGroup()
    local board = board.GetInstance()

    for _,v in ipairs(self.stones) do
        board:RemoveStoneFromBoard(v)
    end
end

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

    --self:CalculateLiberties()
    self:FindLiberties()
    return self 
end

function stoneGroup:Destroy()
    self = nil
end

return stoneGroup