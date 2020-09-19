-- 剧情工具类
StoryHelper = {
  mainIndex = 1,
  mainProgress = 1,
  stories = {}
}

-- 剧情前进
function StoryHelper:forward (mainIndex, mainProgress)
  if (mainIndex ~= self.mainIndex or mainProgress ~= self.mainProgress) then
    return
  end
  self.mainProgress = self.mainProgress + 1
  if (self.mainProgress > #self.stories[self.mainIndex].tips) then
    self.mainIndex = self.mainIndex + 1
    self.mainProgress = 1
  end
  local hostPlayer = PlayerHelper:getHostPlayer()
  GameDataHelper:updateGameData(hostPlayer)
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
  local story = self:getStory()
  if (story) then -- 如果存在剧情
    story:recover(player)
  end
end

-- 事件

-- 世界时间到[n]点
function StoryHelper:atHour (hour)
  if (hour == 0) then
    StoryHelper:forward(1, #story1.tips - 1)
  end
end