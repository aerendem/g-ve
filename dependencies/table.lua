local _cache = {}

--- Basic table operations that every Lua programmer needs to know.
-- @module _table
-- @alias table
local _table = {}

--- Checks if the given table is empty.
-- @tparam table t Table that will be checked
-- @treturn boolean True if empty or false otherwise
function _table.empty(t)
  return next(t) == nil
end

--- Removes all values from the given table.
-- @tparam table t The table that will be cleared
function _table.clear(t)
  for i in pairs(t) do
    local object = t[i]
    object = nil
    t[i] = nil
  end
end

--- Counts the number of elements in a table.
-- Optionally counts the number of occurrences of a specific value.
-- @tparam table haystack The table that will be searched
-- @param[opt] needle Search value
-- @treturn number Number of occurrences (when the optional value is specified)
-- @treturn number Total number of elements
function _table.count(t, s)
  local n = 0
  if s == nil then
    -- count all values
    for _ in pairs(t) do
      n = n + 1
    end
    return n
  else
    -- count specific value
    local d = 0
    for _, v in pairs(t) do
      if v == s then
        d = d + 1
      end
      n = n + 1
    end
    return d, n
  end
end

--- Checks for duplicate elements in a table.
-- @tparam table t The table that will be checked
-- @treturn boolean True if all elements are unique
function _table.unique(t)
  local u = true
  for _, v in pairs(t) do
    if _cache[v] then
      u = false
      break
    end
    _cache[v] = true
  end
  -- clear the cache
  _table.clear(_cache)
  return u
end

--- Reverses all of the elements in a table.
-- @tparam table src Numerically-indexed table
-- @tparam[opt] table dest Destination table
-- @treturn table Reversed table
function _table.reverse(t, r)
  r = r or t
  local n = #t
  if t == r then
    -- reverse in place
    for i = 1, n/2 do
      local i2 = n - i + 1
      r[i], r[i2] = r[i2], r[i]
    end
  else
    -- reverse copy
    for i = 1, n do
      r[n - i + 1] = t[i]
    end
  end
  return r
end

local rand = math.random
--- Randomly shuffles the elements in a table.
-- @tparam table src Numerically-indexed table
-- @tparam[opt] table dest Destination table
-- @treturn table Shuffled table
function _table.shuffle(t, r)
  r = r or t
  local n = #t
  -- shuffle copy
  if t ~= r then
    for i = 1, n do
      r[i] = t[i]
    end
  end
  -- shuffle in place
  for i = n, 1, -1 do
    local j = rand(n)
    r[i], r[j] = r[j], r[i]
  end
  return r
end

--- Returns a random element from a table.
-- @tparam table t Numerically-indexed table
-- @return Random element
-- @treturn number Index of the random element
function _table.random(t)
  local n = #t
  if n > 0 then
    local i = rand(n)
    return t[i], i
  end
end

--- Finds the first occurrence of a given value in a table.
-- @tparam table haystack Numerically-indexed table
-- @param needle Search value
-- @tparam[opt=1] number offset Starting index
-- @treturn number Numeric index or nil
function _table.find(t, s, o)
  o = o or 1
  assert(s ~= nil, "second argument cannot be nil")
  for i = o, #t do
    if t[i] == s then
      return i
    end
  end
end

--- Finds the last occurrence of a given value in a table.
-- @tparam table haystack Numerically-indexed table
-- @param needle Search value
-- @tparam number offset Starting index
-- @treturn number Numeric index or nil
function _table.rfind(t, s, o)
  o = o or #t
  assert(s ~= nil, "second argument cannot be nil")
  -- iterate in reverse
  for i = o, 1, -1 do
    if t[i] == s then
      return i
    end
  end
end

local function dcopy(s, d)
  -- copy elements from the source table
  for k, v in pairs(s) do
    if type(v) == "table" then
      if _cache[v] then
        -- reference cycle
        d[k] = _cache[v]
      else
        -- recursive copy
        local d2 = d[k]
        if d2 == nil then
          d2 = {}
          d[k] = d2
        end
        _cache[v] = d2
        dcopy(v, d2)
      end
    else
      d[k] = v
    end
  end
end

--- Copies the contents from one table to another.
-- Overwrites existing elements in the destination table.
-- Preserves table cycles
-- @tparam table src Source table
-- @tparam[opt] table dest Destination table
-- @treturn table Resulting table
function _table.copy(s, d)
  d = d or {}
  assert(s ~= d, "source and destination tables must be different")
  -- deep copy
  dcopy(s, d)
  -- clear the cache
  _table.clear(_cache)
  return d
end

-- Inject in the table module
_table.copy(_table, table)

return _table