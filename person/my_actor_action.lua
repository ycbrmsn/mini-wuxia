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
  return (want.style == 'move' or want.style == 'patrol' or want.style == 'freeInArea' or want.style == 'approach')
end

-- 跑到指定地点
function MyActorAction:runTo (pos)
  local x, y, z = math.floor(pos.x) + 0.5, math.floor(pos.y) + 0.5, math.floor(pos.z) + 0.5
  return ActorHelper:tryMoveToPos(self.myActor.objid, x, y, z)
end

-- 传送到指定地点
function MyActorAction:transmitTo (pos)
  return self.myActor:setPosition(pos.x, pos.y, pos.z)
end

function MyActorAction:stopRun ()
  self.myActor:closeAI()
  self:runTo(MyPosition:new(self.myActor:getPosition()))
end

function MyActorAction:playHi (afterSeconds)
  self:playAct(ActorHelper.ACT.HI, afterSeconds)
end

function MyActorAction:playDown (afterSeconds)
  self:playAct(ActorHelper.ACT.DOWN, afterSeconds)
end

function MyActorAction:playSleep (afterSeconds)
  self:playAct(ActorHelper.ACT.SLEEP, afterSeconds)
end

function MyActorAction:playSit (afterSeconds)
  self:playAct(ActorHelper.ACT.SIT, afterSeconds)
end

function MyActorAction:playAttack (afterSeconds)
  self:playAct(ActorHelper.ACT.ATTACK, afterSeconds)
end

function MyActorAction:playFree (afterSeconds)
  self:playAct(ActorHelper.ACT.FREE, afterSeconds)
end

function MyActorAction:playFree2 (afterSeconds)
  self:playAct(ActorHelper.ACT.FREE2, afterSeconds)
end

function MyActorAction:playPoss (afterSeconds)
  self:playAct(ActorHelper.ACT.POSE, afterSeconds)
end

function MyActorAction:playAngry (afterSeconds)
  self:playAct(ActorHelper.ACT.ANGRY, afterSeconds)
end

function MyActorAction:playThink (afterSeconds)
  self:playAct(ActorHelper.ACT.THINK, afterSeconds)
end

function MyActorAction:playDie (afterSeconds)
  self:playAct(ActorHelper.ACT.DIE, afterSeconds)
end

function MyActorAction:playStand (afterSeconds)
  self:playAct(ActorHelper.ACT.STAND, afterSeconds)
end

function MyActorAction:playHappy (afterSeconds)
  self:playAct(ActorHelper.ACT.HAPPY, afterSeconds)
end

function MyActorAction:playAct (act, afterSeconds)
  if (afterSeconds) then
    MyTimeHelper:callFnAfterSecond (function (p)
      ActorHelper:playAct(self.myActor.objid, act)
    end, afterSeconds)
  else
    ActorHelper:playAct(self.myActor.objid, act)
  end
end

-- 生物行动
function MyActorAction:execute ()
  local want
  if (not(self.myActor.wants) or not(self.myActor.wants[1])) then -- 如果生物没有想法，则给他一个原始的想法，然后再行动
    self.myActor:defaultWant()
  end
  want = self.myActor.wants[1]
  if (want.currentRestTime > 0) then -- 如果生物还想休息，则让生物继续休息
    want.currentRestTime = want.currentRestTime - 1
    if (want.style == 'sleep') then
      self.myActor:setFaceYaw(want.faceYaw)
    elseif (want.style == 'lookAt') then
      want.style = 'lookingAt'
      MyTimeHelper:callFnContinueRuns(function ()
        self.myActor:lookAt(want.dst)
      end, want.restTime, self.myActor.objid .. 'lookat')
    elseif (want.style == 'forceDoNothing') then
      self.myActor:stopRun()
    end
  else
    if (want.style == 'move' or want.style == 'patrol' or want.style == 'freeInArea' or want.style == 'approach') then -- 如果生物想移动/巡逻，则让生物移动/巡逻
      if (self.myActor.cantMoveTime > self.maxCantMoveTime) then
        self:transmitTo(want.toPos)
        self.myActor.cantMoveTime = 0
      else
        -- if (self.myActor.cantMoveTime > 0) then
        --   self.myActor:setWalkSpeed(-1)
        -- end
        self:runTo(want.toPos)
      end
    elseif (want.style == 'dontMove') then -- 如果生物想原地不动，则不让生物移动

    elseif (want.style == 'freeTime') then -- 自由活动
      -- self.myActor:setWalkSpeed(-1)
    elseif (want.style == 'sleep') then
      want.style = 'sleeping'
      self:playSleep()
    elseif (want.style == 'wake') then
      self.myActor:doItNow()
      -- self.myActor:putOutCandleAndGoToBed()
    elseif (want.style == 'lightCandle' or want.style == 'putOutCandle') then
      self.myActor:lookAt(want.toPos)
    elseif (want.style == 'lookingAt') then
      if (self.myActor.wants[2]) then
        MyActorHelper:handleNextWant(self.myActor)
      else -- 没有想法
        -- self.myActor:openAI()
      end
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

function MyActorAction:speakInHeartToAll (...)
  self:speakInHeart(nil, ...)
end

-- 生物几秒后表达
function MyActorAction:expressAfterSecond (targetuin, startStr, finishStr, second, ...)
  local content = StringHelper:concat(...)
  local message = StringHelper:concat(self.myActor:getName(), startStr, content, finishStr)
  MyTimeHelper:callFnAfterSecond (function (p)
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