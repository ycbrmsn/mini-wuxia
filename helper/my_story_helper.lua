 -- 我的剧情工具类
MyStoryHelper = {
  mainIndex = 1,
  mainProgress = 1,
  progressNames = {},
  storyRemainDays = 0 -- 当前剧情剩余天数
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
  return myStories[self:getMainStoryIndex()]
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

function MyStoryHelper:run (hour)
  if (hour == 0) then
    self:reduceRemainDay()
  end
  if (hour == 9) then
    if (self.storyRemainDays == 0 and self.mainIndex == 1 and self.mainProgress == #myStories[1].tips) then
      self:forward('出发，前往学院')
      self:goToCollege()
    end
  end
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
      if (itemnum == 3) then
        self:forward('文羽通知学院招生')
      elseif (itemnum == 7) then
        self:forward('村长告知先生位置')
      end
    end
  elseif (itemid == MyConstant.TOKEN_ID) then -- 风颖城通行令牌
    PlayerHelper:setItemDisableThrow(objid, itemid)
    self:forward('得到风颖城通行令牌')
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
  self:forward('文羽找我有事')
end

-- 结束通知事件
function MyStoryHelper:finishNoticeEvent (objid)
  -- 设置对话人物不可移动
  local myPlayer = MyPlayerHelper:getPlayer(objid)
  myPlayer:enableMove(false)
  yexiaolong:enableMove(false)
  yexiaolong:wantStayForAWhile(100)
  -- 开始对话
  yexiaolong.action:speakToAll('你顺利地通过了考验，不错。嗯……')
  yexiaolong.action:speakInHeartToAllAfterSecond(3, '我的任务是至少招一名学员，应该可以了。')
  local hour = WorldHelper:getHours()
  local hourName = StringHelper:getHourName(hour)
  if (hour < 9) then
    self.storyRemainDays = 0
    yexiaolong.action:speakToAllAfterSecond(6, '现在才', hourName, '。这样，收拾一下，巳时在村门口集合出发。')
  else
    self.storyRemainDays = 1
    yexiaolong.action:speakToAllAfterSecond(6, '现在已经', hourName, '了，就先休整一天。明天巳时，在村门口集合出发。')
  end
  myPlayer.action:speakToAllAfterSecond (8, '好的。')
  yexiaolong.action:speakToAllAfterSecond(10, '嗯，那去准备吧。')
  MyTimeHelper:callFnAfterSecond (function (p)
    p.myPlayer:enableMove(true)
    yexiaolong:wantStayForAWhile(1)
    yexiaolong:enableMove(true)
  end, 10, { myPlayer = myPlayer })
end

-- 前往学院
function MyStoryHelper:goToCollege ()
  MyPlayerHelper:everyPlayerNotify('到了约定的时间了')
  -- 初始化所有人位置
  local playerPosition = { x = 0, y = 7, z = 16 }
  local yexiaolongPosition = { x = 0, y = 7, z = 20 }
  yexiaolong:setPosition(yexiaolongPosition.x, yexiaolongPosition.y, yexiaolongPosition.z)
  for i, v in ipairs(MyPlayerHelper.players) do
    PlayerHelper:setPosition(v.objid, playerPosition.x, playerPosition.y, playerPosition.z)
  end
  -- 说话
  yexiaolong.action:speakToAllAfterSecond(1, '不错，所有人都到齐了。那我们出发吧。')
  MyPlayerHelper:everyPlayerSpeakToAllAfterSecond (3, '出发咯!')
end