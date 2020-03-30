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

-- 新增actor
function MyActorHelper:add (o)
  self.actors[o['objid']] = o
end

-- 根据objid删除actor
function MyActorHelper:delByObjid (objid)
  self.actors[objid] = nil
end

-- 根据actorid删除actor
function MyActorHelper:delByActorid (actorid)
  for k, v in pairs(self.actors) do
    if (v.actorid == actorid) then
      LogHelper:debug('删除actorid: ' .. actorid)
      self.actors[k] = nil
    end
  end
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
  -- if (myActor) then
  --   LogHelper:debug(myActor.actorname .. '进入区域' .. areaid)
  -- else
  --   LogHelper:debug('有生物进入区域' .. areaid)
  -- end
  local doorPos = allDoorAreas[areaid]
  if (doorPos) then -- 如果门位置存在，说明这是门区域，则打开这个门
    BlockHelper:openDoor(doorPos)
  end
  if (myActor and myActor.wants) then -- 找到了一个actor，并且这个actor有想法
    local want = myActor.wants[1]
    if (want.toAreaId == areaid) then -- 如果是该actor的终点区域，则判断actor是仅仅前往还是巡逻
      if (want.style == 'move') then -- 如果是仅仅前往，则变更想法，并且停下来
        -- LogHelper:debug(myActor.actorname .. '进入了终点区域' .. areaid)
        AreaHelper:destroyArea(want.toAreaId) -- 清除终点区域
        local pos = MyActorActionHelper:getNextPos(want)
        if (pos) then -- 有下一个行动位置
          want.toPos = pos
          MyActorActionHelper:createToPos(want)
          -- LogHelper:debug('向下一个位置出发')
        elseif (myActor.wants[2]) then
          table.remove(myActor.wants, 1)
          local nextWant = myActor.wants[1]
          if (nextWant.style == 'move' or nextWant.style == 'patrol') then
            MyActorActionHelper:createToPos(nextWant)
            -- LogHelper:debug('开始巡逻')
          elseif (nextWant.style == 'freeInArea') then
            nextWant.toPos = MyActorActionHelper:getFreeInAreaPos(myActor.freeInAreaIds)
            MyActorActionHelper:createToPos(nextWant)
            LogHelper:debug(myActor.actorname .. '开始闲逛')
          end
        else
          myActor:defaultWant()
          myActor:wantStayForAWhile()
        end
      elseif (want.style == 'patrol') then -- 如果是巡逻，则停下来并设定前往目的地
        AreaHelper:destroyArea(want.toAreaId) -- 清除终点区域
        want.currentRestTime = want.restTime
        want.toPos = MyActorActionHelper:getNextPos(want)
        -- LogHelper:debug('下一个位置' .. type(want.toPos))
        MyActorActionHelper:createToPos(want)
      elseif (want.style == 'freeInArea') then -- 区域内自由移动
        AreaHelper:destroyArea(want.toAreaId) -- 清除终点区域
        want.currentRestTime = want.restTime
        want.toPos = MyActorActionHelper:getFreeInAreaPos(myActor.freeInAreaIds)
        MyActorActionHelper:createToPos(want)
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

-- actor离开区域
function MyActorHelper:leaveArea (objid, areaid)
  local doorPos = allDoorAreas[areaid]
  if (doorPos) then -- 如果门位置存在，说明这是门区域，则判断该区域内是否还有其他生物
    local creaturelist = AreaHelper:getAreaCreatures(areaid)
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
    -- 生物停下来看向玩家
    myActor:wantStayForAWhile()
    local x, y, z = ActorHelper:getPosition(objid)
    myActor:runTo({ x = x, y = y, z = z })
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