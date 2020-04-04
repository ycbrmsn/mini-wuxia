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

function MyStoryHelper:init ()
  if (self:getMainStoryIndex() == 1) then -- 剧情1
    local areaid = AreaHelper:createAreaRectByRange(myStories[1].posBeg, myStories[1].posEnd)
    myStories[1].areaid = areaid
  end
end

-- 推进剧情相关的事件
function MyStoryHelper:playerAddItem (objid, itemid, itemnum)
  if (itemid == MyConstant.COIN_ID) then -- 获得铜板
    local mainIndex = self:getMainStoryIndex()
    if (mainIndex == 1) then -- 剧情一
      if (itemnum == 3 or itemnum == 7) then
        self:forward()
      end
    end
  elseif (itemid == MyConstant.TOKEN_ID) then -- 风颖城通行令牌
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
  local content = StringHelper:join(MyPlayerHelper:getAllPlayerNames(), '、')
  local subject = '你'
  if (#MyPlayerHelper:getAllPlayers() > 1) then 
    subject = '你们'
  end
  content = StringHelper:concat(content, '，', subject, '在家吗？我有一个好消息要告诉', subject, '。')
  wenyu.action:speakToAll(content)
end

-- 结束通知事件
function MyStoryHelper:finishNoticeEvent (objid)
  yexiaolong.action:speakToAll('你顺利地通过了考验，不错。嗯……')
  yexiaolong.action:speakInHeartToAllAfterSecond(1, '我的任务是至少招一名学员，应该可以了。')
  local hour = WorldHelper:getHours()
  local hourName = StringHelper:getHourName(hour)
  if (hour < 9) then
    yexiaolong.action:speakToAllAfterSecond(2, '现在才', hourName, '。这样，收拾一下，巳时在村门口集合出发。')
  else
    yexiaolong.action:speakToAllAfterSecond(2, '现在已经', hourName, '了，就先休整一天。明天巳时，在村门口集合出发。')
  end
end

-- 前往学院
function MyStoryHelper:goToCollege ()
  -- 初始化所有人位置
  local playerPosition = { x = 0, y = 0, z = 0 }
  local yexiaolongPosition = { x = 0, y = 0, z = 0 }
  yexiaolong:setPosition(yexiaolongPosition.x, yexiaolongPosition.y, yexiaolongPosition.z)
  for i, v in ipairs(MyPlayerHelper.players) do
    PlayerHelper:setPosition(v.objid, playerPosition.x, playerPosition.y, playerPosition.z)
  end
  -- 说话
  yexiaolong:speakToAllAfterSecond(1, '不错，所有人都到齐了。那我们出发吧。')

end