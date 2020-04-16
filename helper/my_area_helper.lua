-- 我的区域工具类
MyAreaHelper = {
  playerInHomePos = { x = 31, y = 9, z = 3 },
  wolfAreas = {},
  maxRandomTimes = 10
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

function MyAreaHelper:playerEnterArea (objid, areaid)
  MyStoryHelper:playerEnterArea(objid, areaid)
  local myPlayer = MyPlayerHelper:getPlayer(objid)
  if (areaid == myPlayer.toAreaId) then -- 玩家自动前往地点
    AreaHelper:destroyArea(areaid)
    myPlayer.action:runAction()
  elseif (areaid == wolf.areaid) then -- 进入恶狼谷
    PlayerHelper:notifyGameInfo2Self(objid, '恶狼谷')
  elseif (areaid == qiangdaoLouluo.areaid) then -- 进入强盗营地
    PlayerHelper:notifyGameInfo2Self(objid, '强盗营地')
  end
end

function MyAreaHelper:playerLeaveArea (objid, areaid)
  MyStoryHelper:playerLeaveArea(objid, areaid)
end

function MyAreaHelper:creatureEnterArea (objid)
  
end