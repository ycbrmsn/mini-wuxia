-- 位置类
MyPosition = {
  TYPE = 'POS'
}

function MyPosition:new (x, y, z)
  local o
  if (type(x) == 'table') then
    o = { x = x.x, y = x.y, z = x.z }
  else
    o = { x = x, y = y, z = z }
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyPosition:floor ()
  return MyPosition:new(math.floor(self.x), math.floor(self.y), math.floor(self.z))
end

function MyPosition:get ()
  return self.x, self.y, self.z
end

function MyPosition:isPosition (pos)
  return pos and pos.TYPE and pos.TYPE == self.TYPE
end

function MyPosition:equals (myPosition)
  if (type(myPosition) ~= 'table') then
    return false
  end
  return myPosition.x == self.x and myPosition.y == self.y and myPosition.z == self.z
end

-- 从右起每四位代表一个坐标值
function MyPosition:toNumber ()
  return self.x * 100000000 + self.y * 10000 + self.z
end

function MyPosition:toString ()
  return StringHelper:concat('{x=', self.x, ',y=', self.y, ',z=', self.z, '}')
end