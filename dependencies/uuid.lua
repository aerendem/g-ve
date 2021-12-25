uuid = {}
uuid.__index = uuid

function uuid.New()
    local self = setmetatable({}, uuid)
    self.__index = self

    local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    
    self.uuid = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)

    print(self.uuid)

    return self
end

return uuid