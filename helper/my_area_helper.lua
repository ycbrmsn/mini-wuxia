-- 我的区域工具类
MyAreaHelper = {
  playerInHomePos = { x = 31, y = 9, z = 3 },
  wolfAreas = {},
  maxRandomTimes = 10,
  showToastAreas = {} -- { areaid1 = { areaid2, name }, ... }
}

function MyAreaHelper:removeToArea (myActor)
  if (myActor and myActor.wants) then
    local want = myActor.wants[1]
    if (want.toAreaId) then
      AreaHelper:destroyArea(want.toAreaId)
    end
  end
end

function MyAreaHelper:isAirArea (pos)
  return BlockHelper:isAirBlock(pos.x, pos.y, pos.z) and BlockHelper:isAirBlock(pos.x, pos.y + 1, pos.z)
end

function MyAreaHelper:getRandomAirPositionInArea (areaid)
  local pos = AreaHelper:getRandomPos(areaid)
  local times = 1
  while (not(self:isAirArea(pos)) and times < self.maxRandomTimes) do
    pos = AreaHelper:getRandomPos(areaid)
    times = times + 1
  end
  return pos
end

function MyAreaHelper:initAreas ()
  self.playerInHomeAreaId = AreaHelper:getAreaByPos(self.playerInHomePos)
end

function MyAreaHelper:initShowToastAreas ()
  local arr = { wolf, qiangdaoLouluo }
  for i, v in ipairs(arr) do
    self.showToastAreas[v.areaids[2]] = { v.areaids[1], v.areaName }
  end
  for i, v in ipairs(guard.initAreas) do
    if (i >= 5) then
      break
    end
    self.showToastAreas[guard.initAreas2[i]] = { v.areaid, '风颖城' }
  end
end

function MyAreaHelper:showToastArea (objid, areaid)
  for k, v in pairs(self.showToastAreas) do
    if (k == areaid) then
      local player = MyPlayerHelper:getPlayer(objid)
      if (player.prevAreaId and player.prevAreaId == v[1]) then
        MyPlayerHelper:showToast(objid, v[2])
      end
      break
    end
  end
end

function MyAreaHelper:playerEnterArea (objid, areaid)
  MyStoryHelper:playerEnterArea(objid, areaid)
  local myPlayer = MyPlayerHelper:getPlayer(objid)
  if (areaid == myPlayer.toAreaId) then -- 玩家自动前往地点
    AreaHelper:destroyArea(areaid)
    myPlayer.action:runAction()
  elseif (guard:checkTokenArea(objid, areaid)) then
  else
    self:showToastArea(objid, areaid)
  end
  myPlayer.prevAreaId = areaid
end

function MyAreaHelper:playerLeaveArea (objid, areaid)
  MyStoryHelper:playerLeaveArea(objid, areaid)
end

function MyAreaHelper:creatureEnterArea (objid)
  
end