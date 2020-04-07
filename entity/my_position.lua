-- 位置实体类
MyPosition = {}

function MyPosition:new (x, y, z)
  local o = { x = x, y = y, z = z }
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyPosition:get ()
  return self.x, self.y, self.z
end
