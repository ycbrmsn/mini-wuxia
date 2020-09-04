-- 卫兵
Guard = BaseActor:new(MyMap.ACTOR.GUARD_ACTOR_ID)

function Guard:new ()
  local o = {
    objid = MyMap.ACTOR.GUARD_ACTOR_ID,
    expData = {
      level = 10,
      exp = 60
    },
    fallOff = {
      { 12003, 1, 20 }, -- 短剑
      { MyMap.ITEM.COIN_ID, 15, 20 } -- 铜板
    },
    initPositions = {
      MyPosition:new(-39.5, 7, 478.5), -- 南城门卫兵位置
      MyPosition:new(-32.5, 7, 478.5), -- 南城门卫兵位置
      MyPosition:new(37.5, 7, 548.5), -- 东城门卫兵位置
      MyPosition:new(37.5, 7, 555.5), -- 东城门卫兵位置
      MyPosition:new(-32.5, 7, 625.5), -- 北城门卫兵位置
      MyPosition:new(-39.5, 7, 625.5), -- 北城门卫兵位置
      MyPosition:new(-109.5, 7, 555.5), -- 西城门卫兵位置
      MyPosition:new(-109.5, 7, 548.5), -- 西城门卫兵位置
      MyPosition:new(-50.5, 7, 529.5) -- 城主府卫兵位置
    },
    initPositions2 = {
      MyPosition:new(-32.5, 7, 479.5), -- 南门
      MyPosition:new(36.5, 7, 555.5), -- 东门
      MyPosition:new(-39.5, 7, 624.5), -- 北门
      MyPosition:new(-108.5, 7, 548.5) -- 西门
    },
    initAreas = {},  -- 进城区域，对象数组长度5
    initAreas2 = {}, -- 进城后区域，数值数组长度4
    savePositions = {
      MyPosition:new(-35.5, 8.5, 464.5), -- 南
      MyPosition:new(52.5, 8.5, 552.5), -- 东
      MyPosition:new(-36.5, 8.5, 640.5), -- 北
      MyPosition:new(-122.5, 8.5, 551.5) -- 西
    }, -- 安全地点，未持有令牌前往地点
    lordHousePositions = {
      MyPosition:new(-42.5, 7, 528.5), -- 城主府门口卫兵位置
      MyPosition:new(-29.5, 7, 528.5) -- 城主府门口卫兵位置
    },
    lordHousePatrolPositions = {
      MyPosition:new(-21, 7, 531), -- 城主府卫兵巡逻位置
      MyPosition:new(-51, 7, 531), -- 城主府卫兵巡逻位置
      MyPosition:new(-51, 7, 572), -- 城主府卫兵巡逻位置
      MyPosition:new(-21, 7, 572) -- 城主府卫兵巡逻位置
    },
    patrolGuards = {}
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Guard:init ()
  for i, v in ipairs(self.initPositions) do
    if (i % 2 == 1) then
      table.insert(self.initAreas, { areaid = AreaHelper:getAreaByPos(v), isOk = false })
    end
  end
  for i, v in ipairs(self.initPositions2) do
    table.insert(self.initAreas2, AreaHelper:getAreaByPos(v))
  end
  self.action = BaseActorAction:new(self)
  TimeHelper:repeatUtilSuccess(self.actorid, 'initGuard', function ()
    local isAllOk = true
    for i, v in ipairs(self.initAreas) do
      if (not(v.isOk)) then
        local objids = AreaHelper:getAllCreaturesInAreaId(v.areaid)
        if (objids and #objids > 0) then
          self:initCityGuard(i, v, objids)
        else
          isAllOk = false
        end
      end
    end
    return isAllOk
  end, 10)
end

function Guard:initCityGuard (index, o, objids)
  o.objids = objids
  local dir
  if (index == 1) then -- 南
    dir = 'S'
  elseif (index == 2) then -- 东
    dir = 'E'
  elseif (index == 3) then -- 北
    dir = 'N'
  elseif (index == 4) then -- 西
    dir = 'W'
  else
    for i, v in ipairs(objids) do
      ActorHelper:closeAI(v)
      if (i == 1) then
        ActorHelper:setPosition(v, self.lordHousePositions[i])
        ActorHelper:lookToward(v, 'E')
      elseif (i == 2) then
        ActorHelper:setPosition(v, self.lordHousePositions[i])
        ActorHelper:lookToward(v, 'W')
      else
        ActorHelper:setPosition(v, self.lordHousePatrolPositions[i - 2])
        local g = BaseActor:new(MyMap.ACTOR.GUARD_ACTOR_ID, v)
        g:wantPatrol('patrol', self.lordHousePatrolPositions, false, i - 2)
        table.insert(self.patrolGuards, g)
      end
    end
  end
  if (index < 5) then
    for i, v in ipairs(objids) do
      ActorHelper:closeAI(v)
      ActorHelper:setPosition(v, self.initPositions[(index - 1) * 2 + i])
      ActorHelper:lookToward(v, dir)
    end
  end
  AreaHelper:clearAllWoodenFence(o.areaid)
  o.isOk = true
end

function Guard:getName ()
  if (not(self.actorname)) then
    self.actorname = '卫兵'
  end
  return self.actorname
end

function Guard:toPatrol ()
  -- body
end

function Guard:checkTokenArea (objid, areaid)
  local isEnter = false
  for i, v in ipairs(self.initAreas) do
    if (i < 5 and v.areaid == areaid) then
      local player = PlayerHelper:getPlayer(objid)
      if (not(player:takeOutItem(MyMap.ITEM.TOKEN_ID))) then
        self:speakTo(objid, 0, '出示令牌。强闯者，捕。')
        TimeHelper:callFnCanRun(objid, 'checkToken', function ()
          MonsterHelper:wantLookAt (v.objids, objid, 5)
        end, 5)
        local xt, yt, zt = 0, 0, 0
        if (i == 1) then
          zt = -0.5
        elseif (i == 2) then
          xt = 0.5
        elseif (i == 3) then
          zt = 0.5
        else
          xt = -0.5
        end
        ActorHelper:appendSpeed(objid, xt, yt, zt)
        player.action:runTo({ self.savePositions[i] }, function ()
          player:thinkTo(objid, 0, '还是不要乱跑比较好。')
        end)
      end
      isEnter = true
      break
    end
  end
  return isEnter
end