-- 卫兵
Guard = MyActor:new(MyConstant.GUARD_ACTOR_ID)

function Guard:new ()
  local o = {
    objid = MyConstant.GUARD_ACTOR_ID,
    expData = {
      level = 10,
      exp = 60
    },
    fallOff = {
      { 12003, 1, 20 }, -- 短剑
      { MyConstant.COIN_ID, 15, 20 } -- 铜板
    },
    initPositions = {
      { x = -39.5, y = 7, z = 478.5 }, -- 南城门卫兵位置
      { x = -32.5, y = 7, z = 478.5 }, -- 南城门卫兵位置
      { x = 37.5, y = 7, z = 548.5 }, -- 东城门卫兵位置
      { x = 37.5, y = 7, z = 555.5 }, -- 东城门卫兵位置
      { x = -32.5, y = 7, z = 625.5 }, -- 北城门卫兵位置
      { x = -39.5, y = 7, z = 625.5 }, -- 北城门卫兵位置
      { x = -109.5, y = 7, z = 555.5 }, -- 西城门卫兵位置
      { x = -109.5, y = 7, z = 548.5 }, -- 西城门卫兵位置
      { x = -50.5, y = 7, z = 529.5 } -- 城主府卫兵位置
    },
    initPositions2 = {
      { x = -32.5, y = 7, z = 479.5 }, -- 南门
      { x = 36.5, y = 7, z = 555.5 }, -- 东门
      { x = -39.5, y = 7, z = 624.5 }, -- 北门
      { x = -108.5, y = 7, z = 548.5 } -- 西门
    },
    initAreas = {},  -- 进城区域，对象数组
    initAreas2 = {}, -- 进城后区域，数值数组
    lordHousePositions = {
      { x = -42.5, y = 7, z = 528.5 }, -- 城主府门口卫兵位置
      { x = -29.5, y = 7, z = 528.5 } -- 城主府门口卫兵位置
    },
    lordHousePatrolPositions = {
      { x = -21, y = 7, z = 531 }, -- 城主府卫兵巡逻位置
      { x = -51, y = 7, z = 531 }, -- 城主府卫兵巡逻位置
      { x = -51, y = 7, z = 572 }, -- 城主府卫兵巡逻位置
      { x = -21, y = 7, z = 572 } -- 城主府卫兵巡逻位置
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
  MyTimeHelper:repeatUtilSuccess(self.actorid, 'initGuard', function ()
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
      MyActorHelper:closeAI(v)
      if (i == 1) then
        MyActorHelper:setPosition(v, self.lordHousePositions[i])
        MyActorHelper:lookToward(v, 'E')
      elseif (i == 2) then
        MyActorHelper:setPosition(v, self.lordHousePositions[i])
        MyActorHelper:lookToward(v, 'W')
      else
        MyActorHelper:setPosition(v, self.lordHousePatrolPositions[i - 2])
        local g = MyActor:new(MyConstant.GUARD_ACTOR_ID, v)
        g:wantPatrol('patrol', self.lordHousePatrolPositions, false, i - 2)
        table.insert(self.patrolGuards, g)
      end
    end
  end
  if (index < 5) then
    for i, v in ipairs(objids) do
      MyActorHelper:closeAI(v)
      MyActorHelper:setPosition(v, self.initPositions[(index - 1) * 2 + i])
      MyActorHelper:lookToward(v, dir)
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