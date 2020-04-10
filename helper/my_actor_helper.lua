-- 人物工具类
MyActorHelper = {
  actors = {} -- objid -> actor
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
          -- LogHelper:debug('向下一个位置出发')
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
end

-- 玩家点击生物
function MyActorHelper:playerClickActor (objid, toobjid)
  local myActor = self:getActorByObjid(toobjid)
  if (myActor) then
    if (myActor.wants and myActor.wants[1].style == 'sleeping') then
      myActor.wants[1].style = 'wake'
    end
    myActor.action:stopRun()
    myActor:wantLookAt(nil, objid)
    myActor:playClickAct()
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
      actor1.action:stopRun()
      actor1:collidePlayer(toobjid, PositionHelper:isTwoInFrontOfOne(objid, toobjid))
      actor1:wantLookAt(nil, toobjid)
      -- actor1:wantStayForAWhile()
      -- LogHelper:info('执行了')
    else
      local actor2 = MyActorHelper:getActorByObjid(toobjid)
      if (actor2) then
        -- 先简单处理为actorid小的停下来
        if (actor1.actorid < actor2.actorid) then
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
      LogHelper:call(function (myActor)
        myActor:updatePosition()
        myActor.action:execute()
      end, v)
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