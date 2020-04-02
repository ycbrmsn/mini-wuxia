 -- 我的剧情工具类
MyStoryHelper = {
  mainIndex = 1,
  mainProgress = 1
}

-- function MyStoryHelper:initStories ()
--   for i, v in ipairs(myStories) do
--     v.maxProgress = #v.tips
--   end
-- end

-- 剧情前进
function MyStoryHelper:forward (isBranch)
  if (isBranch) then -- 支线，暂未设计
    
  else
    self.mainProgress = self.mainProgress + 1
    if (self.mainProgress > #myStories[self.mainIndex].tips) then
      self.mainIndex = self.mainIndex + 1
      self.mainProgress = 1
    end
  end
  if (type(logPaper) == 'nil') then
    logPaper = LogPaper:new()
  end
  logPaper.isChange = true
end

-- 获得主线剧情序号
function MyStoryHelper:getMainStoryIndex ()
  return self.mainIndex
end

function MyStoryHelper:getMainStoryProgress ()
  return self.mainProgress
end

-- 获得主线剧情信息
function MyStoryHelper:getMainStoryInfo ()
  return myStories[self:getMainStoryIndex()]
end

-- 获得剧情标题和内容
function MyStoryHelper:getMainStoryTitleAndTip ()
  local story = self:getMainStoryInfo()
  return story.title, story.tips[self:getMainStoryProgress()]
end

-- 推进剧情相关的事件
function MyStoryHelper:playerAddItem (itemid, itemnum)
  if (itemid == coinId) then -- 获得铜板
    local mainIndex = self:getMainStoryIndex()
    if (mainIndex == 1) then -- 剧情一
      if (itemnum == 3 or itemnum == 7) then
        self:forward()
      end
    end
  end
end