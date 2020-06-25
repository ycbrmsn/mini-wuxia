-- 人物想法类
MyActorWant = {}

function MyActorWant:new (myActor)
  local o = {
    myActor = myActor
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyActorWant:wantMove (think, positions, isNegDir, index, restTime, speed)
  MyAreaHelper:removeToArea(self.myActor)
  self.myActor:closeAI()
  self.myActor.think = think
  local want = MyActorActionHelper:getMoveData(think, positions, isNegDir, index, restTime, speed)
  self.myActor.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createMoveToPos(want)
  self.myActor.action:runTo(want.toPos)
end

function MyActorWant:wantApproach (think, positions, isNegDir, index, restTime)
  MyAreaHelper:removeToArea(self.myActor)
  self.myActor:closeAI()
  self.myActor.think = think
  local want = MyActorActionHelper:getApproachData(think, positions, isNegDir, index, restTime)
  self.myActor.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createApproachToPos(want)
end

function MyActorWant:wantDontMove (think)
  MyAreaHelper:removeToArea(self.myActor)
  think = think or 'dontMove'
  self.myActor.think = think
  self.myActor.wants = { MyActorActionHelper:getDontMoveData(think) }
end

function MyActorWant:wantStayForAWhile(second)
  second = second or 5 -- 默认休息5秒
  if (not(self.myActor.wants)) then -- 如果生物没有想法，则给他一个原始的想法
    self.myActor:defaultWant()
  end
  self.myActor.wants[1].currentRestTime = second
  self.myActor.action:stopRun()
end

function MyActorWant:wantPatrol (think, positions, isNegDir, index, restTime)
  MyAreaHelper:removeToArea(self.myActor)
  -- LogHelper:debug(self:getName() .. '想巡逻')
  self.myActor:closeAI()
  self.myActor.think = think
  local want = MyActorActionHelper:getPatrolData(think, positions, isNegDir, index, restTime)
  self.myActor.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createMoveToPos(want)
end

function MyActorWant:wantFreeTime (think)
  MyAreaHelper:removeToArea(self.myActor)
  think = think or 'free'
  self.myActor:closeAI()
  self.myActor.think = think
  local want = MyActorActionHelper:getFreeTimeData(think)
  self.myActor.wants = { want }
  self.myActor.action:freeTime(want)
end

function MyActorWant:wantFreeInArea (think, posPairs)
  MyAreaHelper:removeToArea(self.myActor)
  if (not(posPairs)) then
    posPairs = think
    think = 'free'
  end
  self.myActor:closeAI()
  self.myActor.think = think
  local want = MyActorActionHelper:setFreeInArea(think, self.myActor, posPairs)
  want.toPos = MyActorActionHelper:getFreeInAreaPos(self.myActor.freeInAreaIds)
  -- 创建当前前往区域
  MyActorActionHelper:createMoveToPos(want)
end

function MyActorWant:wantDoNothing (think)
  MyAreaHelper:removeToArea(self.myActor)
  think = think or 'doNothing'
  self.myActor:closeAI()
  self.myActor.think = think
  self.myActor.wants = { MyActorActionHelper:getDoNothingData(think) }
end

function MyActorWant:wantLookAt (think, myPosition, restTime)
  restTime = restTime or 5
  self.myActor:closeAI()
  if (self.myActor:isWantsExist()) then
    think = think or self.myActor.think
    local want = MyActorActionHelper:getLookAtData(think, myPosition, restTime)
    if (self.myActor.wants[1].style == 'lookAt' or self.myActor.wants[1].style == 'lookingAt') then
      self.myActor.wants[1] = want
    else
      table.insert(self.myActor.wants, 1, want)
    end
  else
    think = think or 'lookAt'
    local want = MyActorActionHelper:getLookAtData(think, myPosition, restTime)
    self.myActor.wants = { want }
  end
  self.myActor.think = think
end

function MyActorWant:wantGoToSleep (bedData)
  MyAreaHelper:removeToArea(self.myActor)
  self:wantMove('sleep', { bedData[1] })
  self:nextWantSleep('sleep', bedData[2])
end

function MyActorWant:nextWantMove (think, positions, isNegDir, index, restTime, speed)
  if (self.myActor:isWantsExist()) then
    local want = MyActorActionHelper:getMoveData(think, positions, isNegDir, index, restTime, speed)
    table.insert(self.myActor.wants, want)
  else
    self:wantMove(think, positions, isNegDir, index, restTime, speed)
  end
end

function MyActorWant:nextWantApproach (think, positions, isNegDir, index, restTime)
  if (self.myActor:isWantsExist()) then
    local want = MyActorActionHelper:getApproachData(think, positions, isNegDir, index, restTime)
    table.insert(self.myActor.wants, want)
  else
    self:wantApproach(think, positions, isNegDir, index, restTime)
  end
end

function MyActorWant:nextWantPatrol (think, positions, isNegDir, index, restTime)
  if (self.myActor:isWantsExist()) then
    local want = MyActorActionHelper:getPatrolData(think, positions, isNegDir, index, restTime)
    table.insert(self.myActor.wants, want)
  else
    self:wantPatrol(think, positions, isNegDir, index, restTime)
  end
end

function MyActorWant:nextWantFreeInArea (think, posPairs)
  if (self.myActor:isWantsExist()) then
    if (not(posPairs)) then
      posPairs = think
      think = 'free'
    end
    MyActorActionHelper:setFreeInArea(think, self.myActor, posPairs, true)
  else
    self:wantFreeInArea(think, posPairs)
  end
end

function MyActorWant:nextWantDoNothing (think)
  if (self.myActor:isWantsExist()) then
    think = think or 'doNothing'
    table.insert(self.myActor.wants, MyActorActionHelper:getDoNothingData(think))
  else
    self:wantDoNothing(think)
  end
end

function MyActorWant:nextWantLookAt (think, pos, restTime)
  restTime = restTime or 5
  if (self.myActor:isWantsExist()) then
    think = think or self.myActor.wants[#self.myActor.wants].think or 'lookAt'
    table.insert(self.myActor.wants, MyActorActionHelper:getLookAtData(think, pos, restTime))
  else
    self:wantLookAt(think, pos, restTime)
  end
end

function MyActorWant:nextWantSleep (think, faceYaw)
  self:nextWantWait(think, 2)
  table.insert(self.myActor.wants, MyActorActionHelper:getSleepData(think, faceYaw))
end

function MyActorWant:nextWantWait (think, second)
  table.insert(self.myActor.wants, MyActorActionHelper:getWaitData(think, second))
end

function MyActorWant:nextWantGoToSleep (bedData)
  if (self.myActor:isWantsExist()) then
    self:nextWantMove('sleep', { bedData[1] })
    self:nextWantSleep('sleep', bedData[2])
  else
    self:wantGoToSleep(bedData)
  end
end

function MyActorWant:nextWantToggleCandle (think, isLitCandle)
  table.insert(self.myActor.wants, MyActorActionHelper:getToggleCandleData(think, isLitCandle))
end

function MyActorWant:forceDoNothing (think)
  self.myActor:closeAI()
  if (self.myActor:isWantsExist()) then
    if (self.myActor.wants[1].style == 'forceDoNothing') then -- 如果已经存在，则次数叠加
      self.myActor.wants[1].times = self.myActor.wants[1].times + 1
    else
      think = think or self.myActor.think
      local want = MyActorActionHelper:getForceDoNothing(think)
      table.insert(self.myActor.wants, 1, want)
    end
  else
    think = think or 'forceDoNothing'
    local want = MyActorActionHelper:getForceDoNothing(think)
    self.myActor.wants = { want }
  end
  self.myActor.think = think
end