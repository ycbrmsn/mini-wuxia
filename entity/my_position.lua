-- 位置实体类
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

function MyPosition:get ()
  return self.x, self.y, self.z
end

function MyPosition:isPosition (pos)
  return pos.TYPE and pos.TYPE == self.TYPE
end

-- 从右起每四位代表一个坐标值
function MyPosition:toNumber ()
  return self.x * 100000000 + self.y * 10000 + self.z
end