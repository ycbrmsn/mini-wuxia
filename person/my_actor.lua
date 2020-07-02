-- 人物基类
MyActor = {
  objid = nil,
  actorid = nil,
  x = nil,
  y = nil,
  z = nil,
  defaultSpeed = 300, -- 默认移动速度
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
    MyActorHelper:addPerson(o) -- 生物加入集合中
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyActor:newMonster (x, y, z, num, isSingleton)
  if (isSingleton) then
    MonsterHelper:delMonstersByActorid(self.actorid)
  end
  if (not(self.action)) then
    self.action = MyActorAction:new(self)
    self.want = MyActorWant:new(self)
  end
  local objids = WorldHelper:spawnCreature(x, y, z, self.actorid, num)
end

-- 生物是否有效
function MyActor:isActive ()
  local x, y, z = ActorHelper:getPosition(self.objid)
  if (x) then
    self:updateCantMoveTime(x, y, z)
    self.x, self.y, self.z = x, y, z
    return true
  else
    return false
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
  return ActorHelper:setEnableMoveState(self.objid, switch)
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

function MyActor:getDistancePosition (distance, angle)
  return MyActorHelper:getDistancePosition(self.objid, distance, angle)
end

function MyActor:setDistancePosition (objid, distance, angle)
  self:setPosition(MyActorHelper:getDistancePosition(objid, distance, angle))
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
  self.action:lookAt(objid)
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
  self.action:goToBed(isNow)
end

function MyActor:lightCandle (think, isNow, candlePositions)
  return self.action:lightCandle(think, isNow, candlePositions)
end

function MyActor:putOutCandle (think, isNow, candlePositions)
  return self.action:putOutCandle(think, isNow, candlePositions)
end

function MyActor:putOutCandleAndGoToBed (candlePositions)
  self.action:putOutCandleAndGoToBed(candlePositions)
end

function MyActor:toggleCandle (think, myPosition, isLitCandle, isNow)
  self.action:toggleCandle(think, myPosition, isLitCandle, isNow)
end

-- 生物想向指定位置移动
function MyActor:wantMove (think, positions, isNegDir, index, restTime, speed)
  self.want:wantMove(think, positions, isNegDir, index, restTime, speed)
end

function MyActor:wantApproach (think, positions, isNegDir, index, restTime)
  self.want:wantApproach(think, positions, isNegDir, index, restTime)
end

-- 生物想原地不动
function MyActor:wantDontMove (think)
  self.want:wantDontMove(think)
end

-- 生物想停留一会儿
function MyActor:wantStayForAWhile(second)
  self.want:wantStayForAWhile(second)
end

-- 生物想巡逻
function MyActor:wantPatrol (think, positions, isNegDir, index, restTime)
  self.want:wantPatrol(think, positions, isNegDir, index, restTime)
end

-- 生物想自由活动
function MyActor:wantFreeTime (think)
  self.want:wantFreeTime(think)
end

function MyActor:wantFreeAndAlert (think)
  self.want:wantFreeAndAlert(think)
end

-- 生物想在区域内自由活动，think可选
function MyActor:wantFreeInArea (think, posPairs)
  self.want:wantFreeInArea(think, posPairs)
end

-- 生物默认想法，可重写
function MyActor:defaultWant ()
  self:wantFreeTime()
end

-- 生物想不做事
function MyActor:wantDoNothing (think)
  self.want:wantDoNothing(think)
end

function MyActor:wantLookAt (think, myPosition, restTime)
  self.want:wantLookAt(think, myPosition, restTime)
end

function MyActor:wantGoToSleep (bedData)
  self.want:wantGoToSleep(bedData)
end

function MyActor:wantBattle (think)
  self.want:wantBattle(think)
end

function MyActor:isWantsExist ()
  return self.wants and #self.wants > 0
end

function MyActor:nextWantMove (think, positions, isNegDir, index, restTime, speed)
  self.want:nextWantMove(think, positions, isNegDir, index, restTime, speed)
end

function MyActor:nextWantApproach (think, positions, isNegDir, index, restTime)
  self.want:nextWantApproach(think, positions, isNegDir, index, restTime)
end

-- 生物接下来想巡逻
function MyActor:nextWantPatrol (think, positions, isNegDir, index, restTime)
  self.want:nextWantPatrol(think, positions, isNegDir, index, restTime)
end

-- 生物接下来想在区域内自由活动
function MyActor:nextWantFreeInArea (think, posPairs)
  self.want:nextWantFreeInArea(think, posPairs)
end

function MyActor:nextWantDoNothing (think)
  self.want:nextWantDoNothing(think)
end

function MyActor:nextWantLookAt (think, pos, restTime)
  self.want:nextWantLookAt(think, pos, restTime)
end

function MyActor:nextWantSleep (think, faceYaw)
  self.want:nextWantSleep(think, faceYaw)
end

function MyActor:nextWantWait (think, second)
  self.want:nextWantWait(think, second)
end

function MyActor:nextWantGoToSleep (bedData)
  self.want:nextWantGoToSleep(bedData)
end

function MyActor:nextWantToggleCandle (think, isLitCandle)
  self.want:nextWantToggleCandle(think, isLitCandle)
end

-- 强制不能做什么，用于受技能影响
function MyActor:forceDoNothing (think)
  self.want:forceDoNothing(think)
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
  if (CreatureHelper:setWalkSpeed(self.objid, speed)) then
    self.walkSpeed = speed
    return true
  else
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
    self:wantAtHour()
    return true
  else
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

-- 攻击命中
function MyActor:attackHit (toobjid)
  -- body
end

-- 行为改变
function MyActor:changeMotion (actormotion)
  -- body
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