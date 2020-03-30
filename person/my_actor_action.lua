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

-- 播放动作
function MyActorAction:playAct (actid)
  Chat:sendSystemMsg('actid: ' .. actid .. ', result: ' .. result)
  local result = Actor:playAct(self.myActor.objid, actid)
  return result == ErrorCode.OK
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
  else
    CreatureHelper:setWalkSpeed(self.myActor.objid, -1)
    if (want.style == 'move' or want.style == 'patrol' or want.style == 'freeInArea') then -- 如果生物想移动/巡逻，则让生物移动/巡逻
      if (self.myActor.cantMoveTime > self.maxCantMoveTime) then
        self:transmitTo(want.toPos)
        self.myActor.cantMoveTime = 0
      else
        self:runTo(want.toPos)
      end
    elseif (want.style == 'dontMove') then -- 如果生物想原地不动，则不让生物移动
      
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