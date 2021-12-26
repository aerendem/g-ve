board = {}
board.__index = board

require("love")
require("UI")
require("dependencies/table")

local instance

function board.New(boardLines)
   local self = setmetatable({}, board)

   self.__index = self
   self.showBoard = false
   self.boardLines = boardLines
   self.stones = {}

   return self
end

function board.GetInstance(boardLines)
   if instance == nil then
      instance =  board.New(boardLines)
   end
   return instance
end

function board:AddStoneToBoard(stone)
   table.insert(self.stones, stone)
end

function board:RemoveStoneFromBoard(stone)
   self.stones[table.find(self.stones, stone)] = nil
end

function board:DrawBoard()
   if self.showBoard == true then
      UI:DrawBoard()

      for i,v in ipairs(self.stones) do
         UI:DrawPiece(v.row, v.column, v.owner.color)
      end
   end

end

function board:UpdateBoard()
   -- HashSet<Coord> neigh = GetNeighbours(coord); // Get the neighboouring coords.

   -- var g = new Group(GetNextGroupId(), coord, color, GetColoredNeighbour(neigh, State.None),
   --                   GetColoredNeighbour(neigh, opponent)); //Create the group
   -- _groups.Add(g.GetId(), g); // Add the group to the board
   -- _gridGroups[coord.Column, coord.Row] = g.GetId(); //Add group to grid

   -- foreach (Coord pos in neigh) //Merge adjacent groups of same color into this group.
   -- {
   --     int groupId = _gridGroups[pos.Column, pos.Row];
   --     if (!_groups.ContainsKey(groupId) || groupId == g.GetId()) // If there is no group of the ID do nothing
   --     {
   --         continue;
   --     }
   --     AbGroup ng = _groups[_gridGroups[pos.Column, pos.Row]];
   --     if (ng?.GetColor() == color) // If the group is of the same collor merge the groups
   --     {
   --         MergeGroupGrid(g, ng);
   --         MergeGroup(g, ng);
   --         g.AddStone(coord);
   --     }
   --     else if (ng?.GetColor() == opponent) // If the gorup is of the opponent
   --     {
   --         ng.AddStone(coord);
   --         if (ng.GetLiberties().Count == 0) // If we removed the last liberty capture the group
   --         {
   --             Capture(ng, color);
   --         }
   --     }
   -- }

   -- // These methods prints the board and some debugg information in the output.
   -- WriteGroupBoard();
   -- WriteGroupLiberties();
end

function board:CleanBoard()
   table.clear(self.stones)
end

return board