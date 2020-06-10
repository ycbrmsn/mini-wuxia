-- 人物工具类
MyActorHelper = {
  actors = {}, -- objid -> actor
  clickActors = {} -- 玩家点击的actor：objid -> actor
}

function MyActorHelper:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 新增person
function MyActorHelper:addPerson (o)
  self.actors[o['objid']] = o
end

-- 根据objid删除actor
function MyActorHelper:delPersonByObjid (objid)
  self.actors[objid] = nil
end

-- 根据actorid删除actor
function MyActorHelper:delPersonByActorid (actorid)
  for k, v in pairs(self.actors) do
    if (v.actorid == actorid) then
      self.actors[k] = nil
    end
  end
end

function MyActorHelper:getAllActors ()
  return self.actors
end

-- 根据objid查询actor
function MyActorHelper:getActorByObjid (objid)
  return self.actors[objid]
end

function MyActorHelper:closeAI (objid)
  return CreatureHelper:setAIActive(objid, false)
end

function MyActorHelper:openAI (objid)
  return CreatureHelper:setAIActive(objid, true)
end

function MyActorHelper:getMyPosition (objid)
  return MyPosition:new(ActorHelper:getPosition(objid))
end

function MyActorHelper:setPosition (objid, x, y, z)
  local pos
  if (type(x) == 'table') then
    pos = x 
  elseif (type(x) == 'number') then
    pos = MyPosition:new(x, y, z)
  else
    LogHelper:debug('设置位置参数类型为：', type(x))
    return false
  end
  if (ActorHelper:isPlayer(objid)) then
    return PlayerHelper:setPosition(objid, pos.x, pos.y, pos.z)
  else
    return ActorHelper:setPosition(objid, pos.x, pos.y, pos.z)
  end
end

function MyActorHelper:getDistancePosition (objid, distance)
  local pos = self:getMyPosition(objid)
  local angle = ActorHelper:getFaceYaw(objid)
  return MathHelper:getDistancePosition(pos, angle, distance)
end

function MyActorHelper:stopRun (objid)
  self:closeAI(objid)
  local pos = self:getMyPosition(objid)
  ActorHelper:tryMoveToPos(objid, pos.x, pos.y, pos.z)
end

function MyActorHelper:lookToward (objid, dir)
  dir = string.upper(dir)
  local yaw
  if (dir == 'N') then
    yaw = ActorHelper.FACE_YAW.NORTH
  elseif (dir == 'S') then
    yaw = ActorHelper.FACE_YAW.SOUTH
  elseif (dir == 'W') then
    yaw = ActorHelper.FACE_YAW.WEST
  else
    yaw = ActorHelper.FACE_YAW.EAST
  end
  ActorHelper:setFaceYaw(objid, yaw)
end

-- actor进入区域
function MyActorHelper:enterArea (objid, areaid)
  local myActor = self:getActorByObjid(objid)
  local doorPos = AreaHelper.allDoorAreas[areaid]
  if (doorPos) then -- 如果门位置存在，说明这是门区域，则打开这个门
    BlockHelper:openDoor(doorPos)
  end
  if (myActor and myActor.wants) then -- 找到了一个actor，并且这个actor有想法
    local want = myActor.wants[1]
    if (want.toAreaId == areaid) then -- 如果是该actor的终点区域，则判断actor是仅仅前往还是巡逻
      if (want.style == 'move' or want.style == 'approach') then -- 如果是仅仅前往，则变更想法，并且停下来
        -- LogHelper:debug(myActor:getName() .. '进入了终点区域' .. areaid)
        AreaHelper:destroyArea(want.toAreaId) -- 清除终点区域
        local pos = MyActorActionHelper:getNextPos(want)
        -- LogHelper:debug(myActor:getName(), pos)
        if (pos) then -- 有下一个行动位置
          want.toPos = pos
          MyActorActionHelper:createMoveToPos(want)
          myActor.action:execute()
          -- LogHelper:debug(myActor:getName(), '向下一个位置出发')
        elseif (myActor.wants[2]) then
          self:handleNextWant(myActor)
        else
          myActor:defaultWant()
          myActor:wantStayForAWhile()
        end
      elseif (want.style == 'patrol') then -- 如果是巡逻，则停下来并设定前往目的地
        AreaHelper:destroyArea(want.toAreaId) -- 清除终点区域
        want.currentRestTime = want.restTime
        want.toPos = MyActorActionHelper:getNextPos(want)
        -- LogHelper:debug('下一个位置' .. type(want.toPos))
        MyActorActionHelper:createMoveToPos(want)
      elseif (want.style == 'freeInArea') then -- 区域内自由移动
        AreaHelper:destroyArea(want.toAreaId) -- 清除终点区域
        want.currentRestTime = want.restTime
        want.toPos = MyActorActionHelper:getFreeInAreaPos(myActor.freeInAreaIds)
        MyActorActionHelper:createMoveToPos(want)
      else -- 其他情况，不明
        -- do nothing
      end
    else -- 不是该actor的终点区域，则和该actor没有关系
      -- do nothing
    end
  else -- 没有找到actor，或者该actor没有想法，则不做什么
    -- do nothing
  end
end

function MyActorHelper:handleNextWant (myActor)
  local want = myActor.wants[1]
  table.remove(myActor.wants, 1)
  local nextWant = myActor.wants[1]
  -- LogHelper:debug('下一个行为：', nextWant.style)
  myActor.think = nextWant.think
  if (nextWant.style == 'move' or nextWant.style == 'patrol') then
    MyActorActionHelper:createMoveToPos(nextWant)
    myActor.action:execute()
    -- LogHelper:debug('开始移动')
  elseif (nextWant.style == 'approach') then
    MyActorActionHelper:createApproachToPos(nextWant)
    myActor.action:execute()
  elseif (nextWant.style == 'freeInArea') then
    nextWant.toPos = MyActorActionHelper:getFreeInAreaPos(myActor.freeInAreaIds)
    MyActorActionHelper:createMoveToPos(nextWant)
    -- LogHelper:debug(myActor:getName() .. '开始闲逛')
  elseif (nextWant.style == 'freeTime') then
    myActor:openAI()
  elseif (nextWant.style == 'wait') then
    local restTime = nextWant.restTime
    table.remove(myActor.wants, 1)
    nextWant = myActor.wants[1]
    nextWant.currentRestTime = restTime
    -- LogHelper:debug('wait')
  elseif (nextWant.style == 'lightCandle' or nextWant.style == 'putOutCandle') then
    nextWant.toPos = want.toPos
    -- 2秒后看，攻击，移除想法
    MyTimeHelper:callFnAfterSecond (function (p)
      p.myActor:lookAt(p.pos)
      p.myActor.action:playAttack()
    end, 2, { pos = want.toPos, myActor = myActor })
    -- 3秒后蜡烛台变化，并执行下一个动作
    MyTimeHelper:callFnAfterSecond (function (p)
      MyBlockHelper:handleCandle(p.pos, p.isLit)
      if (p.myActor.wants[2]) then
        self:handleNextWant(p.myActor)
      end
    end, 3, { pos = want.toPos, isLit = nextWant.style == 'lightCandle', myActor = myActor })
  end
end

-- actor离开区域
function MyActorHelper:leaveArea (objid, areaid)
  local doorPos = AreaHelper.allDoorAreas[areaid]
  if (doorPos) then -- 如果门位置存在，说明这是门区域，则判断该区域内是否还有其他生物
    local creaturelist = AreaHelper:getAllCreaturesInAreaId(areaid)
    if (creaturelist and #creaturelist > 0) then -- 如果区域内还有其他生物，则不关门
      -- do nothing
    else
      BlockHelper:closeDoor(doorPos)
    end
  end
  MyStoryHelper:actorLeaveArea(objid, areaid)
end

-- 玩家点击生物
function MyActorHelper:playerClickActor (objid, toobjid)
  local myActor = self:getActorByObjid(toobjid)
  if (myActor) then
    self:recordClickActor(objid, myActor)
    if (myActor.wants and myActor.wants[1].style == 'sleeping') then
      myActor.wants[1].style = 'wake'
    end
    myActor:defaultPlayerClickEvent(objid)
  end
end

-- 记录点击的玩家与被点击的生物之间的一对一关系
function MyActorHelper:recordClickActor (objid, myActor)
  for k, v in pairs(self.clickActors) do
    if (v == myActor) then -- 有其他玩家点击过，则替换为当前玩家点击
      self.clickActors[k] = nil
      break
    end
  end
  self.clickActors[objid] = myActor
end

-- 准备恢复被点击的生物之前的行为
function MyActorHelper:resumeClickActor (objid)
  local myActor = self.clickActors[objid]
  if (myActor) then
    if (myActor.wants and #myActor.wants > 0) then
      local want = myActor.wants[1]
      if (want.style == 'lookingAt') then
        want.currentRestTime = 5
        MyTimeHelper:delFnContinueRuns(myActor.objid .. 'lookat')
      end
    end
    self.clickActors[objid] = nil
  end
end

function MyActorHelper:actorCollide (objid, toobjid)
  local actor1 = MyActorHelper:getActorByObjid(objid)
  -- LogHelper:info('碰撞了', actor1:getName())
  if (actor1) then -- 生物是特定生物
    if (ActorHelper:isPlayer(toobjid)) then -- 是玩家
      if (actor1.wants and actor1.wants[1].style == 'sleeping') then
        actor1.wants[1].style = 'wake'
      end
      actor1:defaultCollidePlayerEvent(toobjid, PositionHelper:isTwoInFrontOfOne(objid, toobjid))
    else
      local actor2 = MyActorHelper:getActorByObjid(toobjid)
      if (actor2) then
        -- 先简单处理为actorid小的停下来
        if (actor1.actorid == actor2.actorid) then
          if (objid < toobjid) then
            actor1:wantStayForAWhile()
          else
            actor2:wantStayForAWhile()
          end
        elseif (actor1.actorid < actor2.actorid) then
          actor1:wantStayForAWhile()
        else
          actor2:wantStayForAWhile()
        end
      end
    end
  end
end

-- actor计时器变化
function MyActorHelper:changeTimer (timerid, timername)
  if (timername == MyActor.timername) then -- 生物计时器，则找出生物开始行动
    for k, v in pairs(self.actors) do
      LogHelper:call(function ()
        v:updatePosition()
        v.action:execute()
      end)
    end
  else -- 其他计时器
    -- do nothing
  end
end

-- 时间到了
function MyActorHelper:atHour (hour)
  for k, v in pairs(self.actors) do
    v:wantAtHour(hour)
  end
end

-- 是否是同队生物
function MyActorHelper:isTheSameTeamActor (objid1, objid2)
  local teamid1, teamid2
  if (ActorHelper:isPlayer(objid1)) then -- 是玩家
    teamid1 = PlayerHelper:getTeam(objid1)
  else
    teamid1 = CreatureHelper:getTeam(objid1)
  end
  if (ActorHelper:isPlayer(objid2)) then -- 是玩家
    teamid2 = PlayerHelper:getTeam(objid2)
  else
    teamid2 = CreatureHelper:getTeam(objid2)
  end
  if (not(teamid1) or not(teamid2)) then -- 如果有生物没有队伍，则不是同队
    return false
  end
  return teamid1 == teamid2
end

-- 获得区域内所有敌对生物
function MyActorHelper:getAllOtherTeamActorsInAreaId (objid, areaid)
  local objids1, objids2 = AreaHelper:getAllCreaturesAndPlayersInAreaId(areaid)
  local objids = {}
  if (ActorHelper:isPlayer(objid)) then -- 是玩家
    local teamid = PlayerHelper:getTeam(objid)
    if (objids1 and #objids1 > 0) then -- 发现生物，排除同队生物
      for i, v in ipairs(objids1) do
        local tid = CreatureHelper:getTeam(v)
        if (tid ~= teamid) then -- 非同队生物
          table.insert(objids, v)
        end
      end
    end
    if (objids2 and #objids2 > 0) then -- 发现玩家，排除同队玩家
      for i, v in ipairs(objids2) do
        if (v ~= objid) then -- 非当前玩家
          local tid = PlayerHelper:getTeam(v)
          if (tid ~= teamid) then -- 非同队玩家
            table.insert(objids, v)
          end
        end
      end
    end
  else -- 是生物
    local teamid = CreatureHelper:getTeam(objid)
    if (objids1 and #objids1 > 0) then -- 发现生物，排除同队生物
      for i, v in ipairs(objids1) do
        if (v ~= objid) then -- 非当前生物
          local tid = CreatureHelper:getTeam(v)
          if (tid ~= teamid) then -- 非同队生物
            table.insert(objids, v)
          end
        end
      end
    end
    if (objids2 and #objids2 > 0) then -- 发现玩家，排除同队玩家
      for i, v in ipairs(objids2) do
        local tid = PlayerHelper:getTeam(v)
        if (tid ~= teamid) then -- 非同队玩家
          table.insert(objids, v)
        end
      end
    end
  end
  return objids
end

function MyActorHelper:playBodyEffectById (objid, particleId, scale)
  scale = scale or 1
  return ActorHelper:playBodyEffectById(objid, particleId, scale)
end

-- 播放人物特效然后关闭
function MyActorHelper:playAndStopBodyEffectById (objid, particleId, scale, time)
  time = time or 3
  self:playBodyEffectById(objid, particleId, scale)
  MyTimeHelper:callFnLastRun(objid, objid .. 'stopBodyEffect' .. particleId, function ()
    ActorHelper:stopBodyEffectById(objid, particleId)
  end, time)
end

-- 播放人物音效
function MyActorHelper:playSoundEffectById (objid, soundId, isLoop)
  return ActorHelper:playSoundEffectById(objid, soundId, 100, 1, isLoop)
end

-- 播放人物音效然后关闭
function MyActorHelper:playAndStopSoundEffectById (objid, soundId, isLoop, time)
  time = time or 3
  self:playSoundEffectById(objid, soundId, isLoop)
  MyTimeHelper:callFnLastRun(objid, objid .. 'stopSoundEffect' .. soundId, function ()
    ActorHelper:stopSoundEffectById(objid, soundId)
  end, time)
end

-- 给对象增加一个速度 id、速度大小、起始位置、目标位置
function MyActorHelper:appendSpeed (objid, speed, srcPos, dstPos)
  dstPos = dstPos or MyActorHelper:getMyPosition(objid)
  local speedVector3 = MathHelper:getSpeedVector3(srcPos, dstPos, speed)
  ActorHelper:appendSpeed(objid, speedVector3.x, speedVector3.y, speedVector3.z)
end

-- 囚禁actor，用于慑魂枪效果
function MyActorHelper:imprisonActor (objid)
  MyActorHelper:playBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT22)
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = MyPlayerHelper:getPlayer(objid)
    player:setImprisoned(true)
  else
    local actor = self:getActorByObjid(objid)
    if (actor) then
      actor:setImprisoned(true)
    else
      MonsterHelper:imprisonMonster(objid)
    end
  end
end

-- 取消囚禁actor
function MyActorHelper:cancelImprisonActor (objid)
  local canCancel
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = MyPlayerHelper:getPlayer(objid)
    canCancel = player:setImprisoned(false)
  else
    local actor = self:getActorByObjid(objid)
    if (actor) then
      canCancel = actor:setImprisoned(false)
    else
      canCancel = MonsterHelper:cancelImprisonMonster(objid)
    end
  end
  if (canCancel) then
    ActorHelper:stopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT22)
  end
end

-- 封魔actor
function MyActorHelper:sealActor (objid)
  MyActorHelper:playBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT47)
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = MyPlayerHelper:getPlayer(objid)
    player:setSeal(true)
  else
    local actor = self:getActorByObjid(objid)
    if (actor) then
      actor:setSealed(true)
    else
      MonsterHelper:sealMonster(objid)
    end
  end
end

-- 取消封魔actor
function MyActorHelper:cancelSealActor (objid)
  local canCancel
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = MyPlayerHelper:getPlayer(objid)
    canCancel = player:setSeal(false)
  else
    local actor = self:getActorByObjid(objid)
    if (actor) then
      canCancel = actor:setSealed(false)
    else
      canCancel = MonsterHelper:cancelSealMonster(objid)
    end
  end
  if (canCancel) then
    ActorHelper:stopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT47)
  end
end