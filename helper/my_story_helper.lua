-- 我的剧情工具类
MyStoryHelper = {
  mainIndex = 1,
  mainProgress = 1,
  progressNames = {},
  storyRemainDays = 0, -- 当前剧情剩余天数
  stories = {}
}

-- 剧情前进
function MyStoryHelper:forward (progressName, isBranch)
  if (self:isProgressNameExist(progressName)) then
    return
  end
  if (isBranch) then -- 支线，暂未设计
    
  else
    table.insert(self.progressNames, progressName)
    self.mainProgress = self.mainProgress + 1
    if (self.mainProgress > #self.stories[self.mainIndex].tips) then
      self.mainIndex = self.mainIndex + 1
      self.mainProgress = 1
    end
    local hostPlayer = MyPlayerHelper:getHostPlayer()
    GameDataHelper:updateGameData(hostPlayer)
  end
  logPaper.isChange = true
end

function MyStoryHelper:isProgressNameExist (progressName)
  for i, v in ipairs(self.progressNames) do
    if (v == progressName) then
      return true
    end
  end
  return false
end

-- 获得主线剧情序号
function MyStoryHelper:getMainStoryIndex ()
  return self.mainIndex
end

function MyStoryHelper:getMainStoryProgress ()
  return self.mainProgress
end

function MyStoryHelper:getMainStoryRemainDays ()
  return self.storyRemainDays
end

-- 获得主线剧情信息
function MyStoryHelper:getMainStoryInfo ()
  return self.stories[self:getMainStoryIndex()]
end

-- 获得剧情标题和内容
function MyStoryHelper:getMainStoryTitleAndTip ()
  local story = self:getMainStoryInfo()
  return story.title, story.tips[self:getMainStoryProgress()]
end

function MyStoryHelper:reduceRemainDay ()
  if (self.storyRemainDays > 0) then
    self.storyRemainDays = self.storyRemainDays - 1
  end
end

function MyStoryHelper:getStory (index)
  index = index or self.mainIndex
  return self.stories[index]
end

function MyStoryHelper:run (hour)
  if (hour == 0) then
    self:reduceRemainDay()
  end
  if (hour == 9) then
    if (self.mainIndex == 1 and self.mainProgress == #self.stories[1].tips) then
      self:forward('出发，前往学院')
      Story2:goToCollege()
    end
  end
end

function MyStoryHelper:init ()
  self.stories = { Story1:init(), Story2:init() }
end

-- 推进剧情相关的事件
function MyStoryHelper:playerAddItem (objid, itemid, itemnum)
  local mainIndex = self:getMainStoryIndex()
  if (mainIndex == 1) then -- 剧情一
    if (itemid == MyConstant.ITEM.WENYU_PACKAGE_ID) then -- 文羽包裹
      self:forward('文羽通知学院招生')
    elseif (itemid == MyConstant.ITEM.YANGWANLI_PACKAGE_ID) then -- 村长包裹
      self:forward('村长告知先生位置')
    elseif (itemid == MyConstant.ITEM.TOKEN_ID) then -- 风颖城通行令牌
      PlayerHelper:setItemDisableThrow(objid, itemid)
      self:forward('得到风颖城通行令牌')
      Story1:finishNoticeEvent(objid)
    end
  end
end

function MyStoryHelper:playerEnterArea (objid, areaid)
  if (areaid == self:getStory(1).areaid) then -- 文羽通知事件
    Story1:noticeEvent(areaid)
  elseif (areaid == MyAreaHelper.playerInHomeAreaId) then -- 主角进入家中
    Story1:fasterTime()
  end
end

function MyStoryHelper:playerLeaveArea (objid, areaid)
  local mainIndex = self:getMainStoryIndex()
  local mainProgress = self:getMainStoryProgress()
  if (areaid == self:getStory(2).areaid and mainIndex == 2 and mainProgress == 3) then -- 跑出强盗区域
    Story2:comeBack(objid, areaid)
  end
end

function MyStoryHelper:actorLeaveArea (objid, areaid)
  local mainIndex = self:getMainStoryIndex()
  local mainProgress = self:getMainStoryProgress()
  if (areaid == self:getStory(2).areaid and mainIndex == 2 and mainProgress == 3) then
    local actorid = CreatureHelper:getActorID(objid)
    if (actorid == QiangdaoLouluo.actorid or actorid == QiangdaoXiaotoumu.actorid) then
      Story2:comeBack(objid, areaid)
    end
  end
end

function MyStoryHelper:playerBadHurt (objid)
  local mainIndex = self:getMainStoryIndex()
  local mainProgress = self:getMainStoryProgress()
  -- 检测技能是否正在释放
  if (MyItemHelper:isDelaySkillUsing(objid, '坠星')) then -- 技能释放中
    FallStarBow:cancelSkill(objid)
    return
  end
  if (mainIndex == 1) then -- 在落叶村受重伤
    Story1:playerBadHurt(objid)
  elseif (mainIndex == 2 and mainProgress == 3) then -- 杀强盗受重伤
    Story2:playerBadHurt(objid)
  end
end

function MyStoryHelper:actorDieEvent (objid)
  if (self:getMainStoryIndex() == 2) then
    Story2:showMessage(objid)
  end
end

-- 重新进入游戏时恢复剧情
function MyStoryHelper:recover ()
  local mainIndex = self:getMainStoryIndex()
  local mainProgress = self:getMainStoryProgress()
  if (mainIndex == 1) then

  elseif (mainIndex == 2) then

  end
end