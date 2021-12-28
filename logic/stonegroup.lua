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
    local groupLiberties = self:CalculateLiberties()

    if #groupLiberties == 0 then
        print(#groupLiberties)
        pprint("self.liberties", self.liberties)
        pprint("self.owner", self.owner)
        self:CaptureGroup()
    end
end

function stoneGroup:FindLiberties()
    local liberties = {}
    for _,v in ipairs(self.stones) do

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

    self:CalculateLiberties()
    return self 
end

function stoneGroup:Destroy()
    self = nil
end

return stoneGroup