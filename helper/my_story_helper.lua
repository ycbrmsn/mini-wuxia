 -- 我的剧情工具类
MyStoryHelper = {
  mainIndex = 1,
  mainProgress = 1
}

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
function MyStoryHelper:playerAddItem (objid, itemid, itemnum)
  if (itemid == coinId) then -- 获得铜板
    local mainIndex = self:getMainStoryIndex()
    if (mainIndex == 1) then -- 剧情一
      if (itemnum == 3 or itemnum == 7) then
        self:forward()
      end
    end
  elseif (itemid == tokenId) then -- 风颖城通行令牌
    PlayerHelper:setItemDisableThrow(objid, itemid)
    self:forward()
    self:finishNoticeEvent(objid)
  end
end

-- 文羽通知事件
function MyStoryHelper:noticeEvent (areaid)
  AreaHelper:destroyArea(areaid)
    wenyu:setPosition(myStories[1].createPos.x, myStories[1].createPos.y, myStories[1].createPos.z)
    wenyu:wantMove('notice', { myStories[1].movePos })
    local content = StringHelper:join(allPlayers, '、', 'nickname')
    local subject = '你'
    if (#allPlayers > 1) then 
      subject = '你们'
    end
    content = content .. '，' .. subject .. '在家吗？我有一个好消息要告诉' .. subject .. '。'
    wenyu.action:speak(content)
end

function MyStoryHelper:finishNoticeEvent (objid)
  local hour = WorldHelper:getHours()

end