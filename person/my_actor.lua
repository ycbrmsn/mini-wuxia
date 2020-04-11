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
  wants = nil
}

function MyActor:new (actorid)
  if (not(actorid)) then
    LogHelper:error('初始化生物的actorid为：', actorid)
  end
  local o = {
    actorid = actorid
  }
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

-- 获取生物位置
function MyActor:getPosition ()
  return ActorHelper:getPosition(self.objid)
end

-- 设置生物位置
function MyActor:setPosition (x, y, z)
  if (type(x) == 'table') then
    return ActorHelper:setPosition(self.objid, x.x, x.y, x.z)
  else
    return ActorHelper:setPosition(self.objid, x, y, z)
  end
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
  local index = self:putOutCandle(true, candlePositions)
  self:goToBed(index == 1)
end

-- 生物想向指定位置移动
function MyActor:wantMove (think, positions, isNegDir, index, restTime)
  MyAreaHelper:removeToArea(self)
  MyActorHelper:closeAI(self.objid)
  self.think = think
  local want = MyActorActionHelper:getMoveData(think, positions, isNegDir, index, restTime)
  self.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createMoveToPos(want)
end

function MyActor:wantApproach (think, positions, isNegDir, index, restTime)
  MyAreaHelper:removeToArea(self)
  MyActorHelper:closeAI(self.objid)
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
  MyActorHelper:closeAI(self.objid)
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
  MyActorHelper:openAI(self.objid)
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
  MyActorHelper:closeAI(self.objid)
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
  MyActorHelper:closeAI(self.objid)
  self.think = think
  self.wants = { MyActorActionHelper:getDoNothingData(think) }
end

function MyActor:wantLookAt (think, myPosition, restTime)
  MyActorHelper:closeAI(self.objid)
  if (self:isWantsExist()) then
    think = think or self.think
    local want = MyActorActionHelper:getLookAtData(think, myPosition, restTime)
    if (self.wants[1].style == 'lookAt') then
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

function MyActor:playClickAct ()
  self.action:playFree2(2)
end

function MyActor:playerClickEvent (objid)
  self:playClickAct()
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
    local areaid = AreaHelper:getAreaByPos(initPosition)
    -- 加入蜡烛台数据
    if (self.candlePositions and #self.candlePositions > 0) then
      for i, v in ipairs(self.candlePositions) do
        MyBlockHelper:addCandle(v)
      end
    end
    -- 清除木围栏
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