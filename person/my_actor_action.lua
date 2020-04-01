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
function MyActorAction:runTo (pos)
  return ActorHelper:tryMoveToPos(self.myActor.objid, pos.x, pos.y, pos.z)
end

-- 传送到指定地点
function MyActorAction:transmitTo (pos)
  return self.myActor:setPosition(pos.x, pos.y, pos.z)
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
      CreatureHelper:setWalkSpeed(self.myActor.objid, 0)
      self:runTo(want.lookPos)
    end
  else
    if (want.style == 'move' or want.style == 'patrol' or want.style == 'freeInArea') then -- 如果生物想移动/巡逻，则让生物移动/巡逻
      CreatureHelper:setWalkSpeed(self.myActor.objid, -1)
      if (self.myActor.cantMoveTime > self.maxCantMoveTime) then
        self:transmitTo(want.toPos)
        self.myActor.cantMoveTime = 0
      else
        self:runTo(want.toPos)
      end
    elseif (want.style == 'dontMove') then -- 如果生物想原地不动，则不让生物移动

    elseif (want.style == 'sleep') then
      want.style = 'sleeping'
      self:playSleep()
    else -- 生物不想做什么，则生物自由安排
      -- do nothing
    end
  end
end

-- 生物说话
function MyActorAction:speak (content, targetuin)
  ChatHelper:sendSystemMsg(self.myActor.actorname .. '：#W' .. content, targetuin)
end

-- 生物心想
function MyActorAction:speakInHeart (content, targetuin)
  ChatHelper:sendSystemMsg(self.myActor.actorname .. '：#W（' .. content .. '）', targetuin)
end