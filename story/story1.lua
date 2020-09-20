-- 剧情一
Story1 = MyStory:new()

function Story1:new ()
  local data = {
    title = '序章',
    name = '学院招生通知',
    desc = '文羽前来通知我说风颖城的武术学院开始招生了',
    tips = {
      '今天又是晴朗的一天。这么好的天气，出门去逛逛吧。',
      '好像听到文羽在叫我。我得去问问他到底发生了什么。',
      '文羽告诉我风颖城的武术学院又要开始招生了，让我去问问村长。记得村长家在村中央，门对面就是喷泉。',
      '村长说学院的先生在客栈，不知道我能不能入先生的法眼呢。客栈我知道，就在喷泉旁边，有竹栅栏围着的。',
      '我完成了任务，先生给了我一块令牌。',
      '明日巳时，我就要跟着先生向着学院出发了。今天我还可以四处逛逛，或者回家睡一觉。',
      '今日巳时，就要出发了。想想还真有点迫不及待。'
    },
    posBeg = { x = 29, y = 8, z = 1 },
    posEnd = { x = 31, y = 9, z = 1 },
    createPos = { x = 28, y = 7, z = -28 },
    movePos = { x = 31, y = 8, z = 1 }
  }
  self:checkData(data)

  if (StoryHelper:getMainStoryIndex() == 1 and StoryHelper:getMainStoryProgress() == 1) then -- 剧情1
    local areaid = AreaHelper:createAreaRectByRange(data.posBeg, data.posEnd)
    data.areaid = areaid
  end
  setmetatable(data, self)
  self.__index = self
  return data
end

-- 文羽通知事件
function Story1:noticeEvent (areaid)
  AreaHelper:destroyArea(areaid)
  local createPos = story1.createPos
  wenyu:setPosition(createPos.x, createPos.y, createPos.z)
  wenyu:wantMove('notice', { story1.movePos })
  local content = StringHelper:join(PlayerHelper:getAllPlayerNames(), '、')
  local subject = '你'
  if (#PlayerHelper:getAllPlayers() > 1) then 
    subject = '你们'
  end
  content = StringHelper:concat(content, '，', subject, '在家吗？我有一个好消息要告诉', subject, '。')
  wenyu:speak(0, content)
  StoryHelper:forward(1, 1)
end

-- 时间快速流逝
function Story1:fasterTime ()
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 1 and mainProgress == (#self.tips - 1) and not(self.isFasterTime)) then -- 主角回家休息
    -- 时间快速流逝
    self.isFasterTime = true
    TimeHelper:repeatUtilSuccess(666, 'fasterTime', function ()
      local hour = TimeHelper:getHour()
      if (StoryHelper:getMainStoryProgress() < #self.tips) then
        hour = 0
        TimeHelper:setHour(hour)
        return false
      else
        if (hour < 8) then
          hour = hour + 1
          TimeHelper:setHour(hour)
          return false
        else
          TimeHelper:setHour(9)
          return true
        end
      end
    end, 1)
  end
end

-- 结束通知事件
function Story1:finishNoticeEvent (objid)
  -- 设置对话人物不可移动
  local player = PlayerHelper:getPlayer(objid)
  player:enableMove(false, true)
  yexiaolong:enableMove(false)
  yexiaolong:wantStayForAWhile(100)
  -- 开始对话
  local ws = WaitSeconds:new(1)
  yexiaolong:speak(ws:use(3), '你顺利地通过了考验，不错。嗯……')
  yexiaolong:thinks(ws:get(), '我的任务是至少招一名学员，应该可以了。')
  yexiaolong.action:playThink(ws:use(2))
  yexiaolong:speak(ws:get(), '这是风颖城的通行令牌，你收好，没有它可是进不了风颖城的。')
  yexiaolong.action:playStand(ws:use(3))
  local hour = WorldHelper:getHours()
  local hourName = StringHelper:getHourName(hour)
  if (hour < 9) then
    yexiaolong:speak(ws:use(), '现在才', hourName, '。这样，收拾一下，巳时在村门口集合出发。')
  else
    yexiaolong:speak(ws:use(), '现在已经', hourName, '了，就先休整一天。明天巳时，在村门口集合出发。')
  end
  player:speak(ws:use(), '好的。')
  yexiaolong.action:playHi(ws:get())
  yexiaolong:speak(ws:get(), '嗯，那去准备吧。')
  TimeHelper:callFnAfterSecond (function ()
    player:enableMove(true, true)
    yexiaolong:wantStayForAWhile(1)
    yexiaolong:enableMove(true)
    StoryHelper:forward(1, 5)
    if (hour < 9) then
      StoryHelper:forward(1, self.tips - 1)
    end
  end, ws:get())
end

-- 事件废弃
function Story1:playerBadHurt (objid)
  local player = PlayerHelper:getPlayer(objid)
  local pos
  for i, v in ipairs(miaolan.firstFloorBedPositions) do
    pos = v
    if (AreaHelper:isAirArea(v)) then
      break
    end
  end
  player:setPosition(pos)
  PlayerHelper:rotateCamera(objid, ActorHelper.FACE_YAW.SOUTH, 0)
  player.action:playDown(1)
  PlayerHelper:changeViewMode(objid)
  player:thinkTo(objid, 0, '没想到我又受重伤了。')
end

function Story1:recover (player)
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainProgress == 5) then
    story1:finishNoticeEvent(player.objid)
  elseif (mainProgress > 5) then
    player:enableMove(true)
  end
end