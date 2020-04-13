-- 我的区域工具类
MyAreaHelper = {
  playerInHomePos = { x = 31, y = 9, z = 3 },
  wolfAreas = {}
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

function MyAreaHelper:initAreas ()
  self:initWolfAreas()
  self.playerInHomeAreaId = AreaHelper:getAreaByPos(self.playerInHomePos)
end

function MyAreaHelper:initWolfAreas()
  wolf = Wolf:new()
  self.wolfAreas[1] = AreaHelper:getAreaByPos(wolf.initPosition1)
  self.wolfAreas[2] = AreaHelper:getAreaByPos(wolf.initPosition2)
  self.wolfAreas[3] = AreaHelper:getAreaByPos(wolf.ravinePosition)
end

-- 玩家进入恶狼谷
function MyAreaHelper:playerEnterWolfMountain (objid)
  PlayerHelper:notifyGameInfo2Self(objid, '恶狼谷')
  self:createWolves()
  MyTimeHelper:callFnAfterSecond(function ()
    self:createWolves()
  end, 30)
  MyTimeHelper:callFnAfterSecond(function ()
    self:createWolves()
  end, 60)
end

-- 检查两个区域内的恶狼数量，少于10只则补充到10只
function MyAreaHelper:createWolves ()
  local objids1 = AreaHelper:getAllCreaturesInAreaId(self.wolfAreas[1])
  local objids2 = AreaHelper:getAllCreaturesInAreaId(self.wolfAreas[2])
  if (objids1 and objids2) then
    if (#objids1 < 10) then
      wolf:createInPosition1(10 - #objids1)
    end
    if (#objids2 < 10) then
      wolf:createInPosition2(10 - #objids2)
    end
  end
end

function MyAreaHelper:playerEnterArea (objid, areaid)
  MyStoryHelper:playerEnterArea(objid, areaid)
  local myPlayer = MyPlayerHelper:getPlayer(objid)
  if (areaid == myPlayer.toAreaId) then -- 玩家自动前往地点
    AreaHelper:destroyArea(areaid)
    myPlayer.action:runAction()
  elseif (areaid == self.wolfAreas[3]) then -- 进入恶狼谷
    self:playerEnterWolfMountain(objid)
  end
end

function MyAreaHelper:playerLeaveArea (objid, areaid)
  MyStoryHelper:playerLeaveArea(objid, areaid)
end

function MyAreaHelper:creatureEnterArea (objid)
  
end