-- 人物基类
MyActor = {
  objid = nil,
  actorid = nil,
  x = nil,
  y = nil,
  z = nil,
  cantMoveTime = 0, -- 无法移动的时间
  freeInAreaId = nil, -- 自由活动区域id
  timername = 'myActorTimer',
  wants = nil,
  isAIOpened = true,
  sealTimes = 0 -- 封魔叠加次数
}

function MyActor:new (actorid, objid)
  if (not(actorid)) then
    LogHelper:error('初始化生物的actorid为：', actorid)
  end
  local o = {
    actorid = actorid
  }
  if (objid) then
    o.objid = objid
    o.action = MyActorAction:new(o)
    MyActorHelper:addPerson(o) -- 生物加入集合中
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 创建一个新生物
function MyActor:newActor (x, y, z, isSingleton)
  if (isSingleton and self.objid and self.actorid) then
    ActorHelper:clearActorWithId (self.actorid)
    MyActorHelper:delPersonByActorid(self.actorid)
  end
  if (not(self.action)) then -- 如果生物的行为属性不存在，则创建一个
    self.action = MyActorAction:new(self)
  end
  local objids = WorldHelper:spawnCreature(x, y, z, self.actorid, 1)
  if (objids and #objids > 0) then
    self.objid = objids[1]
    MyActorHelper:addPerson(self) -- 生物加入集合中
  end
end

function MyActor:newMonster (x, y, z, num, isSingleton)
  if (isSingleton) then
    MonsterHelper:delMonstersByActorid(self.actorid)
  end
  if (not(self.action)) then
    self.action = MyActorAction:new(self)
  end
  local objids = WorldHelper:spawnCreature(x, y, z, self.actorid, num)
  -- if (objids and #objids > 0) then
  --   for i, v in ipairs(objids) do
  --     MonsterHelper:addMonster(v, self) -- 怪物加入集合中
  --   end
  -- end
end

-- 重生一个生物
function MyActor:recoverActor ()
  MyActorHelper:delPersonByObjid(self.objid)
  if (not(self.x)) then
    self.x, self.y, self.z = self.initPosition.x, self.initPosition.y, self.initPosition.z
  end
  local objids = WorldHelper:spawnCreature(self.x, self.y, self.z, self.actorid, 1)
  self.objid = objids[1]
  MyActorHelper:addPerson(self)
  MyActorActionHelper:updateActionState(self)
end

-- 更新生物位置，如果获取位置失败，则重生一个生物
function MyActor:updatePosition ()
  local x, y, z = ActorHelper:getPosition(self.objid)
  if (x) then
    -- self.pos.x, self.pos.y, self.pos.z = x, y, z -- 如此修改的父类数据，所有类数据相同
    self:updateCantMoveTime(x, y, z)
    -- if (self:getName() == '王大力') then
    --   LogHelper:debug('x=', x, ',y=', y, ',z=', z)
    -- end
    self.x, self.y, self.z = x, y, z
  else
    self:recoverActor()
  end
end

-- 更新不能移动时间
function MyActor:updateCantMoveTime (x, y, z)
  if (self.x) then
    if (self.x == x and self.y == y and self.z == z and self.action:isForceMove()) then
      self.cantMoveTime = self.cantMoveTime + 1
    else
      self.cantMoveTime = 0
    end
  end
end

-- 设置生物是否可移动
function MyActor:enableMove (switch)
  local s = ActorHelper:getEnableMoveState(self.objid)
  if (switch ~= s) then -- 如果新设置与原设置不同，则设置
    return ActorHelper:setEnableMoveState(self.objid, switch)
  else -- 
    return true 
  end
end

function MyActor:openAI ()
  MyActorHelper:openAI(self.objid)
  self.isAIOpened = true
end

function MyActor:closeAI ()
  MyActorHelper:closeAI(self.objid)
  self.isAIOpened = false
end

function MyActor:stopRun ()
  self.action:stopRun()
end

-- 获取生物位置
function MyActor:getPosition ()
  return ActorHelper:getPosition(self.objid)
end

function MyActor:getMyPosition ()
  return MyPosition:new(self:getPosition())
end

-- 设置生物位置
function MyActor:setPosition (x, y, z)
  return MyActorHelper:setPosition(self.objid, x, y, z)
end

function MyActor:getDistancePosition (distance)
  return MyActorHelper:getDistancePosition(self.objid, distance)
end

function MyActor:setDistancePosition (objid, distance)
  self:setPosition(MyActorHelper:getDistancePosition(objid, distance))
end

function MyActor:getFaceYaw ()
  return ActorHelper:getFaceYaw(self.objid)
end

function MyActor:setFaceYaw (yaw)
  return ActorHelper:setFaceYaw(self.objid, yaw)
end

function MyActor:setFacePitch (pitch)
  return ActorHelper:setFacePitch(self.objid, pitch)
end

-- 看向某人/某处
function MyActor:lookAt (objid)
  local x, y, z
  if (type(objid) == 'table') then
    x, y, z = objid.x, objid.y, objid.z
  else
    x, y, z = ActorHelper:getPosition(objid)
    y = y + ActorHelper:getEyeHeight(objid) - 1
  end
  local x0, y0, z0 = ActorHelper:getPosition(self.objid)
  y0 = y0 + ActorHelper:getEyeHeight(self.objid) - 1 -- 生物位置y是地面上一格，所以要减1
  local myVector3 = MyVector3:new(x0, y0, z0, x, y, z)
  local faceYaw = MathHelper:getActorFaceYaw(myVector3)
  local facePitch = MathHelper:getActorFacePitch(myVector3)
  self:setFaceYaw(faceYaw)
  self:setFacePitch(facePitch)
end

function MyActor:speak (afterSeconds, ...)
  if (afterSeconds > 0) then
    self.action:speakToAllAfterSecond(afterSeconds, ...)
  else
    self.action:speakToAll(...)
  end
end

function MyActor:speakTo (playerids, afterSeconds, ...)
  if (type(playerids) == 'number') then
    if (afterSeconds > 0) then
      self.action:speakAfterSecond(playerids, afterSeconds, ...)
    else
      self.action:speak(playerids, ...)
    end
  elseif (type(playerids) == 'table') then
    for i, v in ipairs(playerids) do
      self:speakTo(v)
    end
  end
end

function MyActor:thinks (afterSeconds, ...)
  if (afterSeconds > 0) then
    self.action:speakInHeartToAllAfterSecond(afterSeconds, ...)
  else
    self.action:speakInHeartToAll(...)
  end
end

function MyActor:thinkTo (playerids, afterSeconds, ...)
  if (type(playerids) == 'number') then
    if (afterSeconds > 0) then
      self.action:speakInHeartAfterSecond(playerids, afterSeconds, ...)
    else
      self.action:speakInHeart(playerids, ...)
    end
  elseif (type(playerids) == 'table') then
    for i, v in ipairs(playerids) do
      self:thinkTo(v)
    end
  end
end

function MyActor:goToBed (isNow)
  if (isNow) then
    self:wantGoToSleep(self.bedData)
  else
    self:nextWantGoToSleep(self.bedData)
  end
end

function MyActor:lightCandle (think, isNow, candlePositions)
  candlePositions = candlePositions or self.candlePositions
  local index = 1
  for i, v in ipairs(candlePositions) do
    local candle = MyBlockHelper:getCandle(v)
    if (not(candle) or not(candle.isLit)) then
      if (index == 1 and isNow) then
        self:toggleCandle(think, v, true, true)
      else
        self:toggleCandle(think, v, true)
      end
      index = index + 1
    end
  end
  return index
end

function MyActor:putOutCandle (think, isNow, candlePositions)
  candlePositions = candlePositions or self.candlePositions
  local index = 1
  for i, v in ipairs(candlePositions) do
    local candle = MyBlockHelper:getCandle(v)
    if (not(candle) or candle.isLit) then
      if (index == 1 and isNow) then
        self:toggleCandle(think, v, false, true)
      else
        self:toggleCandle(think, v, false)
      end
      index = index + 1
    end
  end
  return index
end

function MyActor:putOutCandleAndGoToBed (candlePositions)
  local index = self:putOutCandle('putOutCandle', true, candlePositions)
  self:goToBed(index == 1)
end

-- 生物想向指定位置移动
function MyActor:wantMove (think, positions, isNegDir, index, restTime)
  MyAreaHelper:removeToArea(self)
  self:closeAI()
  self.think = think
  local want = MyActorActionHelper:getMoveData(think, positions, isNegDir, index, restTime)
  self.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createMoveToPos(want)
  self.action:runTo(want.toPos)
end

function MyActor:wantApproach (think, positions, isNegDir, index, restTime)
  MyAreaHelper:removeToArea(self)
  self:closeAI()
  self.think = think
  local want = MyActorActionHelper:getApproachData(think, positions, isNegDir, index, restTime)
  self.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createApproachToPos(want)
end

-- 生物想原地不动
function MyActor:wantDontMove (think)
  MyAreaHelper:removeToArea(self)
  think = think or 'dontMove'
  self.think = think
  self.wants = { MyActorActionHelper:getDontMoveData(think) }
end

-- 生物想停留一会儿
function MyActor:wantStayForAWhile(second)
  second = second or 5 -- 默认休息5秒
  if (not(self.wants)) then -- 如果生物没有想法，则给他一个原始的想法
    self:defaultWant()
  end
  self.wants[1].currentRestTime = second
  self.action:stopRun()
end

-- 生物想巡逻
function MyActor:wantPatrol (think, positions, isNegDir, index, restTime)
  MyAreaHelper:removeToArea(self)
  -- LogHelper:debug(self:getName() .. '想巡逻')
  self:closeAI()
  self.think = think
  local want = MyActorActionHelper:getPatrolData(think, positions, isNegDir, index, restTime)
  self.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createMoveToPos(want)
end

-- 生物想自由活动
function MyActor:wantFreeTime (think)
  MyAreaHelper:removeToArea(self)
  think = think or 'free'
  self:openAI()
  self.think = think
  self.wants = { MyActorActionHelper:getFreeTimeData(think) }
end

-- 生物想在区域内自由活动，think可选
function MyActor:wantFreeInArea (think, posPairs)
  MyAreaHelper:removeToArea(self)
  if (not(posPairs)) then
    posPairs = think
    think = 'free'
  end
  self:closeAI()
  self.think = think
  local want = MyActorActionHelper:setFreeInArea(think, self, posPairs)
  want.toPos = MyActorActionHelper:getFreeInAreaPos(self.freeInAreaIds)
  -- 创建当前前往区域
  MyActorActionHelper:createMoveToPos(want)
end

-- 生物默认想法，可重写
function MyActor:defaultWant ()
  self:wantFreeTime()
end

-- 生物想不做事
function MyActor:wantDoNothing (think)
  MyAreaHelper:removeToArea(self)
  think = think or 'doNothing'
  self:closeAI()
  self.think = think
  self.wants = { MyActorActionHelper:getDoNothingData(think) }
end

function MyActor:wantLookAt (think, myPosition, restTime)
  restTime = restTime or 5
  self:closeAI()
  if (self:isWantsExist()) then
    think = think or self.think
    local want = MyActorActionHelper:getLookAtData(think, myPosition, restTime)
    if (self.wants[1].style == 'lookAt' or self.wants[1].style == 'lookingAt') then
      self.wants[1] = want
    else
      table.insert(self.wants, 1, want)
    end
  else
    think = think or 'lookAt'
    local want = MyActorActionHelper:getLookAtData(think, myPosition, restTime)
    self.wants = { want }
  end
  self.think = think
end

function MyActor:wantGoToSleep (bedData)
  MyAreaHelper:removeToArea(self)
  self:wantMove('sleep', { bedData[1] })
  self:nextWantSleep('sleep', bedData[2])
end

-- 强制不能做什么，用于受技能影响
function MyActor:forceDoNothing (think)
  self:closeAI()
  if (self:isWantsExist()) then
    if (self.wants[1].style == 'forceDoNothing') then -- 如果已经存在，则次数叠加
      self.wants[1].times = self.wants[1].times + 1
    else
      think = think or self.think
      local want = MyActorActionHelper:getForceDoNothing(think)
      table.insert(self.wants, 1, want)
    end
  else
    think = think or 'forceDoNothing'
    local want = MyActorActionHelper:getForceDoNothing(think)
    self.wants = { want }
  end
  self.think = think
end

function MyActor:toggleCandle (think, myPosition, isLitCandle, isNow)
  if (not(think)) then
    if (isLitCandle) then
      think = 'lightCandle'
    else
      think = 'putOutCandle'
    end
  end
  if (isNow) then
    self:wantApproach(think, { myPosition })
  else
    self:nextWantApproach(think, { myPosition })
  end
  self:nextWantToggleCandle(think, isLitCandle)
end

function MyActor:isWantsExist ()
  return self.wants and #self.wants > 0
end

function MyActor:nextWantMove (think, positions, isNegDir, index, restTime)
  if (self:isWantsExist()) then
    local want = MyActorActionHelper:getMoveData(think, positions, isNegDir, index, restTime)
    table.insert(self.wants, want)
  else
    self:wantMove(think, positions, isNegDir, index, restTime)
  end
end

function MyActor:nextWantApproach (think, positions, isNegDir, index, restTime)
  if (self:isWantsExist()) then
    local want = MyActorActionHelper:getApproachData(think, positions, isNegDir, index, restTime)
    table.insert(self.wants, want)
  else
    self:wantApproach(think, positions, isNegDir, index, restTime)
  end
end

-- 生物接下来想巡逻
function MyActor:nextWantPatrol (think, positions, isNegDir, index, restTime)
  if (self:isWantsExist()) then
    local want = MyActorActionHelper:getPatrolData(think, positions, isNegDir, index, restTime)
    table.insert(self.wants, want)
  else
    self:wantPatrol(think, positions, isNegDir, index, restTime)
  end
end

-- 生物接下来想在区域内自由活动
function MyActor:nextWantFreeInArea (think, posPairs)
  if (self:isWantsExist()) then
    if (not(posPairs)) then
      posPairs = think
      think = 'free'
    end
    MyActorActionHelper:setFreeInArea(think, self, posPairs, true)
  else
    self:wantFreeInArea(think, posPairs)
  end
end

function MyActor:nextWantDoNothing (think)
  if (self:isWantsExist()) then
    think = think or 'doNothing'
    table.insert(self.wants, MyActorActionHelper:getDoNothingData(think))
  else
    self:wantDoNothing(think)
  end
end

function MyActor:nextWantLookAt (think, pos, restTime)
  restTime = restTime or 5
  if (self:isWantsExist()) then
    think = think or self.wants[#self.wants].think or 'lookAt'
    table.insert(self.wants, MyActorActionHelper:getLookAtData(think, pos, restTime))
  else
    self:wantLookAt(think, pos, restTime)
  end
end

function MyActor:nextWantSleep (think, faceYaw)
  self:nextWantWait(think, 2)
  table.insert(self.wants, MyActorActionHelper:getSleepData(think, faceYaw))
end

function MyActor:nextWantWait (think, second)
  table.insert(self.wants, MyActorActionHelper:getWaitData(think, second))
end

function MyActor:nextWantGoToSleep (bedData)
  if (self:isWantsExist()) then
    self:nextWantMove('sleep', { bedData[1] })
    self:nextWantSleep('sleep', bedData[2])
  else
    self:wantGoToSleep(bedData)
  end
end

function MyActor:nextWantToggleCandle (think, isLitCandle)
  table.insert(self.wants, MyActorActionHelper:getToggleCandleData(think, isLitCandle))
end

-- 生物固定时间点想做什么
function MyActor:wantAtHour (hour)
  -- 各个生物重写此方法内容
end

-- 一般重写此方法
function MyActor:playerClickEvent (objid)
  self.action:playFree2(2)
end

function MyActor:defaultPlayerClickEvent (objid)
  self.action:stopRun()
  self:wantLookAt(nil, objid, 60)
  self:playerClickEvent(objid)
end

function MyActor:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  self.action:speak(myPlayer.objid, nickname, '，你搞啥呢')
end

function MyActor:getName ()
  if (not(self.actorname)) then
    self.actorname = CreatureHelper:getActorName(self.objid)
  end
  return self.actorname
end

function MyActor:getWalkSpeed ()
  if (not(self.walkSpeed)) then
    self.walkSpeed = CreatureHelper:getWalkSpeed(self.objid)
  end
  return self.walkSpeed
end

-- 速度与原速度不同就改变速度
function MyActor:setWalkSpeed (speed)
  local currentSpeed = self:getWalkSpeed()
  if (currentSpeed) then
    if (currentSpeed == speed) then -- 速度相同就不改变
      return true
    else
      if (CreatureHelper:setWalkSpeed(self.objid, speed)) then
        self.walkSpeed = speed
        return true
      else
        return false
      end
    end
  else -- 取不到速度，那么设置速度也不会成功，就不做了
    LogHelper:debug('设置速度失败')
    return false
  end
end

-- 初始化人物行为
function MyActor:init (hour)
  -- body
end

function MyActor:initActor (initPosition)
  local actorid = CreatureHelper:getActorID(self.objid)
  if (actorid and actorid == self.actorid) then
  -- if (self.objid) then
    self.action = MyActorAction:new(self)
    MyActorHelper:addPerson(self) -- 生物加入集合中
    -- 加入蜡烛台数据
    if (self.candlePositions and #self.candlePositions > 0) then
      for i, v in ipairs(self.candlePositions) do
        MyBlockHelper:addCandle(v)
      end
    end
    -- 清除木围栏
    local areaid = AreaHelper:getAreaByPos(initPosition)
    AreaHelper:clearAllWoodenFence(areaid)
    return true
  else
    -- self:newActor(initPosition.x, initPosition.y, initPosition.z, true)
    return false
  end
end

function MyActor:collidePlayer (playerid, isPlayerInFront)
  -- body
end

function MyActor:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  self.action:stopRun()
  self:collidePlayer(playerid, isPlayerInFront)
  self:wantLookAt(nil, playerid)
end

-- 设置囚禁状态
function MyActor:setImprisoned (active)
  if (active) then
    self:forceDoNothing()
  else
    return self:freeForceDoNothing()
  end
end

-- 解除囚禁状态，返回true表示已不是囚禁状态
function MyActor:freeForceDoNothing ()
  if (self:isWantsExist() and self.wants[1].style == 'forceDoNothing') then
    if (self.wants[1].times > 1) then
      self.wants[1].times = self.wants[1].times - 1
      return false
    else
      MyActorHelper:handleNextWant(self)
    end
  end
  return true
end

-- 设置封魔状态
function MyActor:setSealed (active)
  if (active) then
    self.sealTimes = self.sealTimes + 1
  else
    self.sealTimes = self.sealTimes - 1
    return self.sealTimes <= 0
  end
end