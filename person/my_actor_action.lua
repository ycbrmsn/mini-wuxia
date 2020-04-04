-- 人物行为类
MyActorAction = {
  myActor = nil,
  maxCantMoveTime = 5
}

function MyActorAction:new (myActor)
  local o = {
    myActor = myActor
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 生物是否是强制移动，强制移动即用脚本让他移动
function MyActorAction:isForceMove ()
  if (not(self.myActor.wants) or not(self.myActor.wants[1])) then -- 没有想法，则不是
    return false
  end
  local want = self.myActor.wants[1]
  if (want.currentRestTime > 0) then -- 如果在休息，也不是
    return false
  end
  return (want.style == 'move' or want.style == 'patrol' or want.style == 'freeInArea')
end

-- 跑到指定地点
function MyActorAction:runTo (pos, objid)
  if (not(objid)) then
    objid = self.myActor.objid
  end
  return ActorHelper:tryMoveToPos(objid, pos.x + 0.5, pos.y, pos.z + 0.5)
end

-- 传送到指定地点
function MyActorAction:transmitTo (pos)
  return self.myActor:setPosition(pos.x + 0.5, pos.y, pos.z + 0.5)
end

function MyActorAction:playDown ()
  return ActorHelper:playAct(self.myActor.objid, ActorHelper.ACT.DOWN)
end

function MyActorAction:playSleep ()
  return ActorHelper:playAct(self.myActor.objid, ActorHelper.ACT.SLEEP)
end

function MyActorAction:playSit ()
  return ActorHelper:playAct(self.myActor.objid, ActorHelper.ACT.SIT)
end

function MyActorAction:playAttack ()
  return ActorHelper:playAct(self.myActor.objid, ActorHelper.ACT.ATTACK)
end

-- 生物行动
function MyActorAction:execute ()
  local want
  if (not(self.myActor.wants) or not(self.myActor.wants[1])) then -- 如果生物没有想法，则给他一个原始的想法，然后再行动
    self.myActor:defaultWant()
  end
  want = self.myActor.wants[1]
  -- LogHelper:debug('action: ' .. want.currentRestTime)
  if (want.currentRestTime > 0) then -- 如果生物还想休息，则让生物继续休息
    want.currentRestTime = want.currentRestTime - 1
    if (want.style == 'sleep') then
      self.myActor:setWalkSpeed(0)
      self:runTo(want.lookPos)
    end
  else
    if (want.style == 'move' or want.style == 'patrol' or want.style == 'freeInArea') then -- 如果生物想移动/巡逻，则让生物移动/巡逻
      self.myActor:setWalkSpeed(-1)
      if (self.myActor.cantMoveTime > self.maxCantMoveTime) then
        self:transmitTo(want.toPos)
        self.myActor.cantMoveTime = 0
      else
        self:runTo(want.toPos)
      end
    elseif (want.style == 'dontMove') then -- 如果生物想原地不动，则不让生物移动

    elseif (want.style == 'freeTime') then -- 自由活动
      self.myActor:setWalkSpeed(-1)
    elseif (want.style == 'sleep') then
      want.style = 'sleeping'
      self:playSleep()
    elseif (want.style == 'wake') then
      self.myActor:goToBed()
    else -- 生物不想做什么，则生物自由安排
      -- do nothing
    end
  end
end

-- 生物表达
function MyActorAction:express (targetuin, startStr, finishStr, ...)
  local content = StringHelper:concat(...)
  local message = StringHelper:concat(self.myActor:getName(), startStr, content, finishStr)
  ChatHelper:sendSystemMsg(message, targetuin)
end

-- 生物说话
function MyActorAction:speak (targetuin, ...)
  self:express(targetuin, '：#W', '', ...)
end

function MyActorAction:speakToAll (...)
  self:speak(nil, ...)
end

-- 生物心想
function MyActorAction:speakInHeart (targetuin, ...)
  self:express(targetuin, '：#W（', '#W）', ...)
end

function MyActorAction:speakInHeartToAll (targetuin, ...)
  self:speakInHeart(nil, ...)
end

-- 生物几秒后表达
function MyActorAction:expressAfterSecond (targetuin, startStr, finishStr, second, ...)
  local content = StringHelper:concat(...)
  local message = StringHelper:concat(self.myActor:getName(), startStr, content, finishStr)
  MyTimeHelper:runFnAfterSecond (function (p)
    ChatHelper:sendSystemMsg(p.message, p.targetuin)
  end, second, { targetuin = targetuin, message = message })
end

-- 生物几秒后说话
function MyActorAction:speakAfterSecond (targetuin, second, ...)
  self:expressAfterSecond(targetuin, '：#W', '', second, ...)
end

function MyActorAction:speakToAllAfterSecond (second, ...)
  self:speakAfterSecond(nil, second, ...)
end

-- 生物几秒后心想
function MyActorAction:speakInHeartAfterSecond (targetuin, second, ...)
  self:expressAfterSecond(targetuin, '：#W（', '#W）', second, ...)
end

function MyActorAction:speakInHeartToAllAfterSecond (second, ...)
  self:speakInHeartAfterSecond(nil, second, ...)
end