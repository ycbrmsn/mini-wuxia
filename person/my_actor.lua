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

function MyActor:new (actorid, actorname)
  actorname = actorname or '神秘人'
  local o = {
    actorname = actorname
  }
  if (actorid) then
    o['actorid'] = actorid
  end
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 创建一个新生物
function MyActor:newActor (x, y, z, isSingleton)
  if (isSingleton and self.objid) then
    ActorHelper:clearActorWithId (self.actorid)
    MyActorHelper:delByActorid(self.actorid)
  end
  if (not (self.action)) then -- 如果生物的行为属性不存在，则创建一个
    self.action = MyActorAction:new(self)
  end
  local objids = WorldHelper:spawnCreature(x, y, z, self.actorid, 1)
  if (objids and #objids > 0) then
    self.objid = objids[1]
    MyActorHelper:add(self) -- 生物加入集合中
  end
end

-- 重生一个生物
function MyActor:recoverActor ()
  MyActorHelper:delByObjid(self.objid)
  local objids = WorldHelper:spawnCreature(self.x, self.y, self.z, self.actorid, 1)
  self.objid = objids[1]
  MyActorHelper:add(self)
  MyActorActionHelper:updateActionState(self)
end

-- 更新生物位置，如果获取位置失败，则重生一个生物
function MyActor:updatePosition ()
  local x, y, z = ActorHelper:getPosition(self.objid)
  if (x) then
    -- self.pos.x, self.pos.y, self.pos.z = x, y, z -- 如此修改的父类数据，所有类数据相同
    self:updateCantMoveTime(x, y, z)
    self.x, self.y, self.z = x, y, z
  else
    LogHelper:debug('重生' .. self.actorname)
    self:recoverActor()
  end
end

-- 更新不能移动时间
function MyActor:updateCantMoveTime (x, y, z)
  -- LogHelper:debug('更新不能移动时间')
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
  return ActorHelper:setPosition(self.objid, x, y, z)
end

-- 生物想向指定位置移动
function MyActor:wantMove (positions, isNegDir, index, restTime)
  MyActorHelper:closeAI(self.objid)
  local want = MyActorActionHelper:getMoveData(positions, isNegDir, index, restTime)
  self.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createToPos(want)
end

-- 生物想原地不动
function MyActor:wantDontMove ()
  self.wants = { MyActorActionHelper:getDontMoveData() }
end

-- 生物想停留一会儿
function MyActor:wantStayForAWhile(second)
  second = second or 5 -- 默认休息5秒
  if (not(self.wants)) then -- 如果生物没有想法，则给他一个原始的想法
    self:defaultWant()
  end
  self.wants[1].currentRestTime = second
  CreatureHelper:setWalkSpeed(self.objid, 0)
end

-- 生物想巡逻
function MyActor:wantPatrol (positions, isNegDir, index, restTime)
  -- LogHelper:debug(self.actorname .. '想巡逻')
  MyActorHelper:closeAI(self.objid)
  local want = MyActorActionHelper:getPatrolData(positions, isNegDir, index, restTime)
  self.wants = { want }
  -- 创建当前前往区域
  MyActorActionHelper:createToPos(want)
end

-- 生物想自由活动
function MyActor:wantFreeTime ()
  MyActorHelper:openAI(self.objid)
  self.wants = { MyActorActionHelper:getFreeTimeData() }
end

-- 生物想在区域内自由活动
function MyActor:wantFreeInArea (posPairs)
  MyActorHelper:closeAI(self.objid)
  local want = MyActorActionHelper:setFreeInArea(self, posPairs)
  want.toPos = MyActorActionHelper:getFreeInAreaPos(self.freeInAreaIds)
  -- 创建当前前往区域
  MyActorActionHelper:createToPos(want)
end

-- 生物默认想法，可重写
function MyActor:defaultWant ()
  self:wantFreeTime()
end

-- 生物想不做事
function MyActor:wantDoNothing ()
  MyActorHelper:closeAI(self.objid)
  self.wants = { MyActorActionHelper:getDoNothingData() }
end

-- 生物接下来想巡逻
function MyActor:nextWantPatrol (positions, isNegDir, index, restTime)
  local want = MyActorActionHelper:getPatrolData(positions, isNegDir, index, restTime)
  table.insert(self.wants, want)
end

-- 生物接下来想在区域内自由活动
function MyActor:nextWantFreeInArea (posPairs)
  MyActorActionHelper:setFreeInArea(self, posPairs, true)
end

function MyActor:nextWantDoNothing ()
  table.insert(self.wants, MyActorActionHelper:getDoNothingData())
end

-- 生物固定时间点想做什么
function MyActor:wantAtHour (hour)
  -- 各个生物重写此方法内容
end

-- 初始化人物行为
function MyActor:init (hour)
  -- body
end