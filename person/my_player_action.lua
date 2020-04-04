-- 我的玩家行为类
MyPlayerAction = MyActorAction:new()

function MyPlayerAction:new (player)
  local o = {
    myActor = player
  }
  setmetatable(o, self)
  self.__index = self
  return o
end