-- 三维向量实体类
MyVector3 = {}

function MyVector3:new (x0, y0, z0, x1, y1, z1)
  local o = {
    x = x1 - x0,
    y = y1 - y0,
    z = z1 - z0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyVector3:get ()
  return self.x, self.y, self.z
end