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
  local myPlayer = MyPlayerHelper:getPlayer(objid)
  if (areaid == myPlayer.toAreaId) then -- 玩家前往地点
    AreaHelper:destroyArea(areaid)
    myPlayer.action:runAction()
  elseif (areaid == self.wolfAreas[3]) then -- 进入恶狼谷
    self:playerEnterWolfMountain(objid)
  elseif (areaid == myStories[1].areaid) then -- 文羽通知事件
    MyStoryHelper:noticeEvent(areaid)
  elseif (areaid == self.playerInHomeAreaId) then -- 主角进入家中
    local mainIndex = MyStoryHelper:getMainStoryIndex()
    local mainProgress = MyStoryHelper:getMainStoryProgress()
    if (mainIndex == 1 and mainProgress == #myStories[1].tips and not(myStories[1].isFasterTime)) then -- 主角回家休息
      -- 时间快速流逝
      myStories[1].isFasterTime = true
      MyTimeHelper:repeatUtilSuccess(666, 'fasterTime', function ()
        local storyRemainDays = MyStoryHelper:getMainStoryRemainDays()
        local hour = MyTimeHelper:getHour()
        if (storyRemainDays > 0) then
          if (hour < 23) then
            hour = hour + 1
          else
            hour = 0
          end
          MyTimeHelper:setHour(hour)
          return false
        else
          if (hour < 8) then
            hour = hour + 1
            MyTimeHelper:setHour(hour)
            return false
          else
            MyTimeHelper:setHour(9)
            return true
          end
        end
      end, 1)
    end
  end
end

function MyAreaHelper:creatureEnterArea (objid)
  
end