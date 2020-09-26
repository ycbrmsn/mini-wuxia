-- 剧情工具类
StoryHelper = {
  mainIndex = 1,
  mainProgress = 1,
  stories = {},
  initKey = {}, -- 剧情重新加载时校验使用
  alreadyLoad = false, -- 是否已经加载了
}

-- 剧情前进
function StoryHelper:forward (mainIndex, mainProgress, endProgress)
  if (mainIndex ~= self.mainIndex or mainProgress ~= self.mainProgress) then
    return false
  end
  StoryHelper:setLoad(true)
  if (endProgress) then
    self.mainProgress = self.endProgress + 1
  else
    self.mainProgress = self.mainProgress + 1
  end
  if (self.mainProgress > #self.stories[self.mainIndex].tips) then
    self.mainIndex = self.mainIndex + 1
    self.mainProgress = 1
  end
  local hostPlayer = PlayerHelper:getHostPlayer()
  GameDataHelper:updateGameData(hostPlayer)
  return true
end

-- 获得主线剧情序号
function StoryHelper:getMainStoryIndex ()
  return self.mainIndex
end

-- 更新主线剧情序号
function StoryHelper:setMainStoryIndex (mainIndex)
  self.mainIndex = mainIndex
end

-- 获得主线剧情进度序号
function StoryHelper:getMainStoryProgress ()
  return self.mainProgress
end

-- 更新主线剧情进度序号
function StoryHelper:setMainStoryProgress (mainProgress)
  self.mainProgress = mainProgress
end

-- 获得剧情标题和内容
function StoryHelper:getMainStoryTitleAndTip ()
  local story = self:getStory()
  return story.title, story.tips[self:getMainStoryProgress()]
end

-- 获取剧情
function StoryHelper:getStory (index)
  index = index or self:getMainStoryIndex()
  return self.stories[index]
end

-- 新增剧情
function StoryHelper:addStory (story)
  table.insert(self.stories, story)
end

-- 设置剧情
function StoryHelper:setStorys (stories)
  self.stories = stories
end

-- 玩家重新进入游戏时恢复剧情
function StoryHelper:recover (player)
  if (#self.stories == 0) then
    MyStoryHelper:init()
  end
  if (player and PlayerHelper:isMainPlayer(player.objid)) then
    local story = self:getStory()
    if (story) then -- 如果存在剧情
      if (StoryHelper:isLoad()) then
        return false
      else
        StoryHelper:setLoad(true)
        story:recover(player)
        return true
      end
    end
  end
end

-- 剧情是否已经加载过
function StoryHelper:isLoad ()
  return self.alreadyLoad
end

-- 设置剧情加载情况
function StoryHelper:setLoad (isLoad)
  self.alreadyLoad = isLoad
end

-- 显示初始化剧情错误
function StoryHelper:showInitError (key, name)
  key = key or 'defaultInitKey'
  name = name or '必需角色'
  self.initKey[key] = self.initKey[key] or 1
  if (self.initKey[key] % 30 == 5) then
    ChatHelper:sendMsg(nil, '地图错误：', name, '未找到，找到', name, '后方可继续后续剧情')
  end
  self.initKey[key] = self.initKey[key] + 1
end

-- 进入未加载提示
function StoryHelper:loadTip (objid, seconds)
  seconds = seconds or 30
  if (not(StoryHelper:isLoad())) then
    ChatHelper:sendMsg(objid, '当前游戏进度未加载，请加载进度')
    TimeHelper:callFnAfterSecond(function ()
      StoryHelper:loadTip(objid, seconds)
    end, seconds)
  end
end

-- 事件

-- 世界时间到[n]点
function StoryHelper:atHour (hour)
  -- body
end