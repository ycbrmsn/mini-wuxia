-- 道具基类
MyItem = {}

function MyItem:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 创建道具
function MyItem:newItem (playerid, num)
  num = num or 1
  Backpack:addItem(playerid, self.id, num)
end