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

function MyPlayerAction:runTo (positions, callback, param)
  if (positions and #positions > 0) then
    self.myActor.moveMotion = {
      positions = positions,
      index = 0,
      callback = callback,
      param = param
    }
    self:runAction()
  end
end

function MyPlayerAction:runAction ()
  local moveMotion = self.myActor.moveMotion
  moveMotion.index = moveMotion.index + 1
  if (moveMotion.index > #moveMotion.positions) then
    if (moveMotion.callback) then
      moveMotion.callback(moveMotion.param)
    end
  else
    local pos = moveMotion.positions[moveMotion.index]
    self.myActor.toAreaId = AreaHelper:createMovePosArea(pos)
    ActorHelper:tryNavigationToPos(self.myActor.objid, pos.x, pos.y, pos.z, false)
  end
end

function MyPlayerAction:playAct (act, afterSeconds)
  if (afterSeconds) then
    MyTimeHelper:callFnAfterSecond (function (p)
      PlayerHelper:playAct(self.myActor.objid, act)
    end, afterSeconds)
  else
    PlayerHelper:playAct(self.myActor.objid, act)
  end
end