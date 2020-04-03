-- 我的区域工具类
MyAreaHelper = {
  wolfAreas = {}
}

function MyAreaHelper:initAreas ()
  self:initWolfAreas()
end

function MyAreaHelper:initWolfAreas()
  wolf = Wolf:new()
  self.wolfAreas[1] = AreaHelper:getAreaByPos(wolf.initPosition1)
  self.wolfAreas[2] = AreaHelper:getAreaByPos(wolf.initPosition2)
  self.wolfAreas[3] = AreaHelper:getAreaByPos(wolf.ravinePosition)
end

-- 玩家进入恶狼谷，先给个提示，然后检查两个区域内的恶狼数量，少于10只则补充到10只
function MyAreaHelper:playerEnterWolfMountain (objid)
  PlayerHelper:notifyGameInfo2Self(objid, '恶狼谷')
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
  if (areaid == self.wolfAreas[3]) then -- 进入恶狼谷
    self:playerEnterWolfMountain(objid)
  elseif (areaid == myStories[1].areaid) then -- 文羽通知事件
    MyStoryHelper:noticeEvent(areaid)
  end
end

function MyAreaHelper:creatureEnterArea (objid)
  
end