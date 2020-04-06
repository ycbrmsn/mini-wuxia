-- 强盗小头目
QiangdaoXiaotoumu = MyActor:new(MyConstant.QIANGDAO_XIAOTOUMU_ACTOR_ID)

function QiangdaoXiaotoumu:new ()
  local o = {
    objid = MyConstant.QIANGDAO_XIAOTOUMU_ACTOR_ID,
    initPosition = { x = 20, y = 7, z = 45 },
    toPosition = { x = -363, y = 7, z = 556 },
    monsters = {}
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function QiangdaoXiaotoumu:init ()
  local areaid = AreaHelper:getAreaByPos(self.initPosition)
  local objids = AreaHelper:getAllCreaturesInAreaId(areaid)
  if (objids and #objids > 0) then
    self.action = MyActorAction:new(self)
    for i, v in ipairs(objids) do
      table.insert(self.monsters, v)
    end
    self:setPositions({self.toPosition})
    -- 清除木围栏
    AreaHelper:clearAllWoodenFence(areaid)
    return true
  else
    return false
  end
end

function QiangdaoXiaotoumu:setPositions (positions)
  if (positions and #positions > 0) then
    if (#positions == 1) then
      local pos = positions[1]
      for i, v in ipairs(self.monsters) do
        ActorHelper:setPosition(v, pos.x, pos.y, pos.z)
      end
    else
      for i, v in ipairs(self.monsters) do
        local pos = positions[i]
        if (pos) then
          ActorHelper:setPosition(v, pos.x, pos.y, pos.z)
        else
          break
        end
      end
    end
  end
end

function QiangdaoXiaotoumu:enableMove (enable)
  local speed
  if (enable) then
    speed = -1
  else
    speed = 0
  end
  for i, v in ipairs(self.monsters) do
    -- ActorHelper:setEnableMoveState(v, enable)
    CreatureHelper:setWalkSpeed(v, speed)
  end
end

function QiangdaoXiaotoumu:getName ()
  if (not(self.actorname)) then
    self.actorname = '强盗小头目'
  end
  return self.actorname
end