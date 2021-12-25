local stone = {}
rules.__index = rules

require("love")

function rules.new()
   local self = setmetatable({}, rules)

   self.__index = self

   return self
end

function rules:checkGameOver()

end

function rules:checkKills()

end

function rules:checkKills()

end

return rules