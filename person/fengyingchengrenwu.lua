-- 风颖城人物

-- 陆道风
Ludaofeng = BaseActor:new(MyMap.ACTOR.LUDAOFENG_ACTOR_ID)

function Ludaofeng:new ()
  local o = {
    objid = 4334703245,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-36, 8, 557), -- 议事厅
    movePositions = {
      MyPosition:new(-46.5, 16.5, 545.5), -- 楼梯口
      MyPosition:new(-36.5, 8.5, 545.5) -- 议事厅门口
    }, 
    bedData = {
      MyPosition:new(-28.5, 17.5, 546.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-32.5, 17.5, 543.5), -- 大桌
      MyPosition:new(-27.5, 17.5, 544.5), -- 床旁边
      MyPosition:new(-41.5, 17.5, 546.5) -- 书房
    },
    hallAreaPositions = {
      MyPosition:new(-38.5, 8.5, 549.5), -- 进门左边茶几旁
      MyPosition:new(-33.5, 8.5, 558.5) -- 尽头椅子旁
    },
    bedroomAreaPositions = {
      MyPosition:new(-34.5, 16.5, 546.5), -- 门旁
      MyPosition:new(-29.5, 16.5, 540.5) -- 柜子旁
    },
    studyAreaPositions = {
      MyPosition:new(-38.5, 16.5, 546.5), -- 门旁
      MyPosition:new(-43.5, 16.5, 540.5) -- 茶几旁
    },
    defaultTalkMsg = '公务繁忙，不便见客。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Ludaofeng:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Ludaofeng:wantAtHour (hour)
  if hour == 6 then
    self:lightCandle('free', true, { self.candlePositions[3] })
    self:nextWantFreeInArea({ self.studyAreaPositions })
  elseif hour == 8 then
    self:putOutCandle('free', true, { self.candlePositions[3] })
    self:nextWantMove('free', self.movePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif hour == 19 then
    self:lightCandle('free', true, { self.candlePositions[1], self.candlePositions[2] })
    self:nextWantFreeInArea({ self.bedroomAreaPositions })
  elseif hour == 22 then
    self:putOutCandleAndGoToBed({ self.candlePositions[1], self.candlePositions[2] })
  end
end

function Ludaofeng:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 8 then
    self:wantAtHour(6)
  elseif hour >= 8 and hour < 19 then
    self:wantAtHour(8)
  elseif hour >= 19 and hour < 22 then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Ludaofeng:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Ludaofeng:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '你找我可有要事？')
  self:toastSpeak('你找我可有要事？')
end

function Ludaofeng:candleEvent (player, candle)
  
end

-- 千兵卫
Qianbingwei = BaseActor:new(MyMap.ACTOR.QIANBINGWEI_ACTOR_ID)

function Qianbingwei:new ()
  local o = {
    objid = 4334903620,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = { x = -19.5, y = 7.5, z = 527.5 },
    bedData = {
      { x = -55.5, y = 7.5, z = 529.5 }, -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-54.5, 8.5, 531.5) -- 蜡烛台
    },
    talkInfos = qianbingweiTalkInfos,
    defaultTalkMsg = '城里还是很安全的，出了城可要注意。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Qianbingwei:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Qianbingwei:wantAtHour (hour)
  if hour == 6 then
    self:defaultWant()
  elseif hour == 21 then
    self:putOutCandleAndGoToBed()
  end
end

function Qianbingwei:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 21 then
    self:wantAtHour(6)
  else
    self:wantAtHour(21)
  end
end

-- 初始化
function Qianbingwei:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Qianbingwei:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if self.wants and self.wants[1].currentRestTime > 0 then
    -- self:speakTo(playerid, 0, '请注意不要随便撞人。')
    self:toastSpeak('请注意不要随便撞人。')
  elseif self.think == 'sleep' then
    -- self:speakTo(playerid, 0, '你是想被抓起来吗？')
    self:toastSpeak('你是想被抓起来吗？')
  else
    -- self:speakTo(playerid, 0, '请不要影响我。')
    self:toastSpeak('请不要影响我。')
  end
end

function Qianbingwei:candleEvent (player, candle)
  local nickname = player:getName()
  if self.think == 'sleep' and candle.isLit then
    self.action:stopRun()
    if self.wants[1].style == 'sleeping' then
      -- self:speakTo(player.objid, 0, '我……')
      self:toastSpeak('我……')
    else
      -- self:speakTo(player.objid, 0, '我……')
      self:toastSpeak('我……')
    end
    self:wantLookAt('sleep', player.objid, 4)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end

-- 叶小龙
Yexiaolong = BaseActor:new(MyMap.ACTOR.YEXIAOLONG_ACTOR_ID)

function Yexiaolong:new ()
  local o = {
    objid = 4315385631,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(27.5, 9.5, -34.5), -- 客栈客房内
    bedData = {
      MyPosition:new(28.5, 10.5, -34.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向南
    },
    candlePositions = {
      MyPosition:new(25.5, 10.5, -37.5) -- 客栈中蜡烛台
    },
    homeAreaPositions = {
      MyPosition:new(27.5, 10.5, -37.5), -- 衣柜旁
      MyPosition:new(25.5, 10.5, -33.5) -- 柜子上
    },
    -- 剧情三
    story3InitPosition = MyPosition:new(-17, 7.5, 593),
    bedData2 = {
      MyPosition:new(5.5, 8.5, 608.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向南
    },
    candlePositions2 = {
      MyPosition:new(12.5, 8.5, 609.5),
      MyPosition:new(12.5, 8.5, 604.5),
      MyPosition:new(5.5, 8.5, 604.5),
    },
    trainAreaPositions = {
      MyPosition:new(3.5, 7.5, 592.5), -- 演武场墙角
      MyPosition:new(-14.5, 7.5, 609.5) -- 演武场墙角
    },
    classroomAreaPositions = {
      MyPosition:new(6.5, 8.5, 604.5), -- 门口蜡烛旁
      MyPosition:new(11.5, 8.5, 609.5) -- 墙内蜡烛旁
    },
    classRoomPos = MyPosition:new(5.5, 7.5, 606.5), -- 教室里位置
    talkInfos = yexiaolongTalkInfos,
    defaultTalkMsg = '盘龙棍法，一棒打俩。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Yexiaolong:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Yexiaolong:wantAtHour (hour)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainIndex == 1 then
    if hour == 7 then
      self:wantFreeInArea({ self.homeAreaPositions })
    elseif hour == 19 then
      self:lightCandle(nil, true)
      self:nextWantFreeInArea({ self.homeAreaPositions })
    elseif hour == 22 then
      self:putOutCandleAndGoToBed()
    end
  elseif mainIndex == 2 and mainProgress == #story2.tips then
    self:wantMove('init', { self.story3InitPosition })
  elseif mainIndex == 3 and mainProgress >= 3 or mainIndex > 3 then
    self.candlePositions = self.candlePositions2
    if hour == 6 then
      self:wantFreeInArea({ self.classroomAreaPositions })
    elseif hour == 8 then
      self:stayInClass()
    elseif hour == 12 then
      self:wantFreeTime()
    elseif hour == 14 then
      self:wantFreeInArea({ self.trainAreaPositions })
    elseif hour == 20 then
      self:lightCandle(nil, true)
      self:nextWantFreeInArea({ self.classroomAreaPositions })
    elseif hour == 22 then
      self.bedData = self.bedData2
      self:putOutCandleAndGoToBed()
    end
  end
end

function Yexiaolong:doItNow ()
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainIndex == 1 then
    local hour = TimeHelper.getHour()
    if hour >= 7 and hour < 19 then
      self:wantAtHour(7)
    elseif hour >= 19 and hour < 22 then
      self:wantAtHour(19)
    else
      self:wantAtHour(22)
    end
  elseif mainIndex == 3 and mainProgress >= 3 or mainIndex > 3 then
    local hour = TimeHelper.getHour()
    if hour >= 6 and hour < 8 then
      self:wantAtHour(6)
    elseif hour >= 8 and hour < 12 then
      self:wantAtHour(8)
    elseif hour >= 12 and hour < 14 then
      self:wantAtHour(12)
    elseif hour >= 14 and hour < 20 then
      self:wantAtHour(14)
    elseif hour >= 20 and hour < 22 then
      self:wantAtHour(20)
    else
      self:wantAtHour(22)
    end
  end
end

-- 初始化
function Yexiaolong:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

-- 呆在教室
function Yexiaolong:stayInClass ()
  self:wantMove('class', { self.classRoomPos })
  self:nextWantLookAt(nil, self.candlePositions[2], 1)
end

function Yexiaolong:collidePlayer (playerid, isPlayerInFront)
  local nickname
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainIndex == 1 then
    if mainProgress < 5 then
      nickname = '年轻人'
    else
      nickname = PlayerHelper.getNickname(playerid)
    end
    if self.wants and self.wants[1].currentRestTime > 0 then
      -- self:speakTo(playerid, 0, nickname, '，你撞我是想试试你的实力吗？')
      self:toastSpeak(nickname, '，你撞我是想试试你的实力吗？')
    elseif self.think == 'sleep' then
      -- self:speakTo(playerid, 0, nickname, '，我要睡觉了，不要惹我哟。')
      self:toastSpeak(nickname, '，我要睡觉了，不要惹我哟。')
    else
      -- self:speakTo(playerid, 0, nickname, '，找我有事吗？')
      self:toastSpeak(nickname, '，找我有事吗？')
    end
  elseif mainIndex == 3 and mainProgress >= 3 or mainIndex > 3 then
    -- self:speakTo(playerid, 0, '武术修为，也不是一蹴而就的。')
    self:toastSpeak('武术修为，也不是一蹴而就的。')
  end
end

function Yexiaolong:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local mainIndex = StoryHelper.getMainStoryIndex()
  if mainIndex ~= 2 then
    self.action:stopRun()
    self:collidePlayer(playerid, isPlayerInFront)
    self:wantLookAt(nil, playerid)
  end
end

function Yexiaolong:playerClickEvent (objid)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainIndex == 1 and mainProgress == #story1.tips - 1 then
    -- self:speakTo(objid, 0, '你先去准备准备，我们明日#G辰时#n出发。')
    self:toastSpeak('你先去准备准备，我们明日#G辰时#n出发。')
  elseif mainIndex == 1 and mainProgress == #story1.tips then
    -- self:speakTo(objid, 0, '准备得怎么样了，我们#G辰时#n就要出发了。')
    self:toastSpeak('准备得怎么样了，我们#G辰时#n就要出发了。')
  elseif mainIndex == 3 and mainProgress >= 3 and mainProgress <= 5 then
    -- self:speakTo(objid, 0, '你先去找小高，我要歇一歇。')
    self:toastSpeak('你先去找小高，我要歇一歇。')
  elseif mainProgress == 3 and mainProgress == 6 then
    -- self:speakTo(objid, 0, '目前没有什么事情。')
    self:toastSpeak('目前没有什么事情。')
  end
end

function Yexiaolong:candleEvent (player, candle)
  local nickname
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainIndex == 1 then
    if mainProgress < 5 then
      nickname = '年轻人'
    else
      nickname = player:getName()
    end
    if self.think == 'sleep' and candle.isLit then
      self.action:stopRun()
      if self.wants[1].style == 'sleeping' then
        -- self:speakTo(player.objid, 0, nickname, '，你想吃棍子吗？不要碰蜡烛。')
        self:toastSpeak(nickname, '，你想吃棍子吗？不要碰蜡烛。')
      else
        -- self:speakTo(player.objid, 0, nickname, '，我要睡觉了，离蜡烛远点。')
        self:toastSpeak(nickname, '，我要睡觉了，离蜡烛远点。')
      end
      self:wantLookAt('sleep', player.objid, 4)
      self.action:playAngry(1)
      TimeHelper.callFnAfterSecond (function (p)
        self:doItNow()
      end, 3)
    end
  elseif mainIndex == 3 and mainProgress >= 3 or mainIndex > 3 then
    if self.think == 'sleep' and candle.isLit then
      -- self:speakTo(player.objid, 0, '……')
      self:toastSpeak('……')
    end
  end
end

-- 孙孔武
Sunkongwu = BaseActor:new(MyMap.ACTOR.SUNKONGWU_ACTOR_ID)

function Sunkongwu:new ()
  local o = {
    objid = 4368929599,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(8.5, 9.5, 566.5), -- 售货处
    doorPosition = MyPosition:new(7.5, 8.5, 559.5), -- 门口位置
    movePositions = {
      MyPosition:new(6.5, 8.5, 566.5), -- 门口
      MyPosition:new(5.5, 8.5, 566.5), -- 门后
      MyPosition:new(3.5, 12.5, 562.5), -- 楼梯上
      MyPosition:new(7.5, 12.5, 563.5) -- 蜡烛台旁
    },
    bedData = {
      MyPosition:new(8.5, 13.5, 561.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(9.5, 9.5, 565.5), -- 楼下烛台
      MyPosition:new(7.5, 13.5, 564.5) -- 楼上烛台
    },
    secondFloorPositions = {
      MyPosition:new(6.5, 12.5, 565.5), -- 楼梯口
      MyPosition:new(10.5, 12.5, 562.5) -- 门旁边
    },
    defaultTalkMsg = '客人可有想买的？',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Sunkongwu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Sunkongwu:wantAtHour (hour)
  if hour == 6 then
    self:toSell()
  elseif hour == 20 then
    self:goSecondFloor()
  elseif hour == 22 then
    self:putOutCandleAndGoToBed()
  end
end

function Sunkongwu:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 20 then
    self:wantAtHour(6)
  elseif hour >= 20 and hour < 22 then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Sunkongwu:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Sunkongwu:toSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

-- 上二楼
function Sunkongwu:goSecondFloor ()
  self:wantMove('free', self.movePositions)
  self:lightCandle('free', false, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.secondFloorPositions })
end

function Sunkongwu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '客人想买点什么？')
  self:toastSpeak('客官想买点什么？')
end

function Sunkongwu:candleEvent (player, candle)
  
end

-- 李妙手
Limiaoshou = BaseActor:new(MyMap.ACTOR.LIMIAOSHOU_ACTOR_ID)

function Limiaoshou:new ()
  local o = {
    objid = 4369329639,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(17.5, 9.5, 566.5), -- 售货处
    doorPosition = MyPosition:new(18.5, 8.5, 560.5), -- 门口位置
    bedData = {
      MyPosition:new(16.5, 13.5, 562.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(16.5, 9.5, 565.5), -- 楼下烛台
      MyPosition:new(15.5, 13.5, 565.5) -- 楼上烛台
    },
    secondFloorPositions = {
      MyPosition:new(19.5, 12.5, 566.5), -- 楼梯口
      MyPosition:new(17.5, 12.5, 562.5) -- 门旁边
    },
    defaultTalkMsg = '出门远行，没药不行。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Limiaoshou:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Limiaoshou:wantAtHour (hour)
  if hour == 6 then
    self:toSell()
  elseif hour == 20 then
    self:goSecondFloor()
  elseif hour == 22 then
    self:putOutCandleAndGoToBed()
  end
end

function Limiaoshou:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 20 then
    self:wantAtHour(6)
  elseif hour >= 20 and hour < 22 then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Limiaoshou:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Limiaoshou:toSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

-- 上二楼
function Limiaoshou:goSecondFloor ()
  self:lightCandle('free', true, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.secondFloorPositions })
end

function Limiaoshou:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '客人想买点什么？')
  self:toastSpeak('客官想买点什么？')
end

function Limiaoshou:candleEvent (player, candle)
  
end

-- 钱多
Qianduo = BaseActor:new(MyMap.ACTOR.QIANDUO_ACTOR_ID)

function Qianduo:new ()
  local o = {
    objid = 4369930009,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(5.5, 9.5, 574.5), -- 售货处
    doorPosition = MyPosition:new(6.5, 8.5, 579.5), -- 门口位置
    bedData = {
      MyPosition:new(16.5, 9.5, 575.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(4.5, 9.5, 575.5), -- 大厅烛台
      MyPosition:new(14.5, 9.5, 575.5) -- 屋内烛台
    },
    homeAreaPositions = {
      MyPosition:new(12.5, 8.5, 572.5), -- 门口
      MyPosition:new(15.5, 8.5, 576.5) -- 床旁边
    },
    talkInfos = qianduoTalkInfos,
    defaultTalkMsg = '匣中真宝，莫不言好。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Qianduo:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Qianduo:wantAtHour (hour)
  if hour == 6 then
    self:toSell()
  elseif hour == 20 then
    self:freeInHome()
  elseif hour == 22 then
    self:putOutCandleAndGoToBed()
  end
end

function Qianduo:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 20 then
    self:wantAtHour(6)
  elseif hour >= 20 and hour < 22 then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Qianduo:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Qianduo:toSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

-- 屋内自由活动
function Qianduo:freeInHome ()
  self:lightCandle('free', true, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.homeAreaPositions })
end

function Qianduo:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '客人想买点什么？')
  self:toastSpeak('客官想买点什么？')
end

function Qianduo:candleEvent (player, candle)
  
end

-- 大牛
Daniu = BaseActor:new(MyMap.ACTOR.DANIU_ACTOR_ID)

function Daniu:new ()
  local o = {
    objid = 4367229311,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-48.5, 9.5, 504.5), -- 马厩招待处
    doorPosition = MyPosition:new(-46.5, 8.5, 501.5), -- 门口位置
    bedData = {
      MyPosition:new(-47.5, 8.5, 507.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-48.5, 9.5, 503.5)
    },
    defaultTalkMsg = '交钱拿票，转瞬即到。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Daniu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Daniu:wantAtHour (hour)
  if hour == 6 then
    self:lightCandle('toSell', true)
    self:nextWantMove('toSell', { self.initPosition })
    self:nextWantLookAt(nil, self.doorPosition, 1)
    self:nextWantDoNothing('sell')
  elseif hour == 22 then
    self:putOutCandleAndGoToBed()
  end
end

function Daniu:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 22 then
    self:wantAtHour(6)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Daniu:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Daniu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '客人想去哪里？')
  self:toastSpeak('客官想去哪里？')
end

function Daniu:candleEvent (player, candle)
  
end

-- 二牛
Erniu = BaseActor:new(MyMap.ACTOR.ERNIU_ACTOR_ID)

function Erniu:new ()
  local o = {
    objid = 4372230256,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-53.5, 9.5, 494.5), -- 马厩小房间
    bedData = {
      MyPosition:new(-51.5, 8.5, 494.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(-53.5, 9.5, 497.5)
    },
    bedroomAreaPositions = {
      MyPosition:new(-51.5, 8.5, 496.5), -- 衣柜旁
      MyPosition:new(-54.5, 8.5, 493.5) -- 柜子上
    },
    roomAreaPositions1 = {
      MyPosition:new(-59.5, 8.5, 495.5), -- 门旁
      MyPosition:new(-59.5, 8.5, 507.5) -- 转弯处
    },
    roomAreaPositions2 = {
      MyPosition:new(-59.5, 8.5, 507.5), -- 转弯处
      MyPosition:new(-53.5, 8.5, 507.5) -- 尽头
    },
    defaultTalkMsg = '我每天就喂喂马，送送人。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Erniu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Erniu:wantAtHour (hour)
  if hour == 6 then
    self:lightCandle('free', true)
    self:nextWantFreeInArea({ self.bedroomAreaPositions })
  elseif hour == 8 then
    self:putOutCandle('free', true)
    self:nextWantFreeInArea({ self.roomAreaPositions1, self.roomAreaPositions2 })
  elseif hour == 22 then
    self:putOutCandleAndGoToBed()
  end
end

function Erniu:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 8 then
    self:wantAtHour(6)
  elseif hour >= 8 and hour < 22 then
    self:wantAtHour(8)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Erniu:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Erniu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '买好票之后拿着它给我就好了。')
  self:toastSpeak('买好票之后拿着它给我就好了。')
end

function Erniu:candleEvent (player, candle)
  
end

function Erniu:playerClickEvent (objid)
  local itemid = PlayerHelper.getCurToolID(objid)
  if itemid == MyMap.ITEM.CARRIAGE_LUOYECUN_ID then -- 落叶村车票
    -- 防止多车票时重复点击
    TimeHelper.callFnCanRun(function ()
      ItemHelper.removeCurTool(objid)
      -- self:speakTo(objid, 0, '这是去往落叶村的车票。我这就送你过去。')
      self:toastSpeak('这是去往落叶村的车票。我这就送你过去。')
      TimeHelper.callFnFastRuns(function ()
        local player = PlayerHelper.getPlayer(objid)
        player:setMyPosition(MyAreaHelper.luoyecunPos)
      end, 2)
    end, 10, objid .. 'showTicket')
    return true
  elseif itemid == MyMap.ITEM.CARRIAGE_PINGFENGZHAI_ID then -- 平风寨车票
    -- 防止多车票时重复点击
    TimeHelper.callFnCanRun(function ()
      ItemHelper.removeCurTool(objid)
      -- self:speakTo(objid, 0, '这是去往平风寨的车票。我这就送你过去。')
      self:toastSpeak('这是去往平风寨的车票。我这就送你过去。')
      TimeHelper.callFnFastRuns(function ()
        local player = PlayerHelper.getPlayer(objid)
        player:setMyPosition(MyAreaHelper.pingfengzhaiPos)
      end, 2)
    end, 10, objid .. 'showTicket')
    return true
  elseif itemid == MyMap.ITEM.CARRIAGE_PANJUNYINGDI_ID then -- 叛军营地
    -- 防止多车票时重复点击
    TimeHelper.callFnCanRun(function ()
      ItemHelper.removeCurTool(objid)
      -- self:speakTo(objid, 0, '这是去往叛军营地的车票。我这就送你过去。')
      self:toastSpeak('这是去往叛军营地的车票。我这就送你过去。')
      TimeHelper.callFnFastRuns(function ()
        local player = PlayerHelper.getPlayer(objid)
        player:setMyPosition(MyAreaHelper.panjunyingdiPos)
      end, 2)
    end, 10, objid .. 'showTicket')
    return true
  elseif itemid == MyMap.ITEM.CARRIAGE_JUSHAN_ID then -- 橘山
    -- 防止多车票时重复点击
    TimeHelper.callFnCanRun(function ()
      ItemHelper.removeCurTool(objid)
      -- self:speakTo(objid, 0, '这是去往橘山的车票。我这就送你过去。')
      self:toastSpeak('这是去往橘山的车票。我这就送你过去。')
      TimeHelper.callFnFastRuns(function ()
        local player = PlayerHelper.getPlayer(objid)
        player:setMyPosition(MyAreaHelper.jushanPos)
      end, 2)
    end, 10, objid .. 'showTicket')
    return true
  end
end

-- 慕容笑天
Murongxiaotian = BaseActor:new(MyMap.ACTOR.MURONGXIAOTIAN_ACTOR_ID)

function Murongxiaotian:new ()
  local o = {
    objid = 4398848435,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(12.5, 8.5, 506.5), -- 慕容府大厅
    bedData = {
      MyPosition:new(8.5, 9.5, 505.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(8.5, 9.5, 507.5)
    },
    hallAreaPositions = {
      MyPosition:new(11.5, 8.5, 511.5), -- 门口
      MyPosition:new(14.5, 8.5, 505.5) -- 尽头沙发旁
    },
    studyAreaPositions = {
      MyPosition:new(6.5, 8.5, 509.5), -- 凳子旁
      MyPosition:new(4.5, 8.5, 510.5) -- 书架旁
    },
    defaultTalkMsg = '风起于青萍之末，浪成于微澜之间。日行一善，他日亦能名扬天下。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Murongxiaotian:defaultWant ()
  self:wantFreeInArea({ self.hallAreaPositions })
end

-- 在几点想做什么
function Murongxiaotian:wantAtHour (hour)
  if hour == 6 then
    self:wantFreeInArea({ self.studyAreaPositions })
  elseif hour == 8 then
    self:wantFreeInArea({ self.hallAreaPositions })
  elseif hour == 19 then
    self:wantFreeInArea({ self.studyAreaPositions })
  elseif hour == 22 then
    self:putOutCandleAndGoToBed({ self.candlePositions[1] })
  end
end

function Murongxiaotian:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 8 then
    self:wantAtHour(6)
  elseif hour >= 8 and hour < 19 then
    self:wantAtHour(8)
  elseif hour >= 19 and hour < 22 then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Murongxiaotian:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Murongxiaotian:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '来者是客，不如坐下聊一聊。')
  self:toastSpeak('来者是客，不如坐下聊一聊。')
end

function Murongxiaotian:candleEvent (player, candle)
  
end

-- 高小虎
Gaoxiaohu = BaseActor:new(MyMap.ACTOR.GAOXIAOHU_ACTOR_ID)

function Gaoxiaohu:new ()
  local o = {
    objid = 4399954659,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-16, 7.5, 594), -- 学院大门口内
    bedData = {
      MyPosition:new(5.5, 8.5, 593.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(12.5, 8.5, 592.5), -- 最里面的蜡烛
      MyPosition:new(12.5, 8.5, 597.5),
      MyPosition:new(5.5, 8.5, 597.5),
    },
    trainAreaPositions = {
      MyPosition:new(3.5, 7.5, 592.5), -- 演武场墙角
      MyPosition:new(-14.5, 7.5, 609.5) -- 演武场墙角
    },
    classroomAreaPositions = {
      MyPosition:new(6.5, 8.5, 597.5), -- 门口蜡烛旁
      MyPosition:new(11.5, 8.5, 592.5) -- 墙内蜡烛旁
    },
    classRoomPos = MyPosition:new(5.5, 7.5, 595.5), -- 教室里位置
    talkInfos = gaoxiaohuTalkInfos,
    defaultTalkMsg = '感觉我的拳法最近没有精进。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Gaoxiaohu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Gaoxiaohu:wantAtHour (hour)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainIndex == 3 and mainProgress < 3 or mainIndex < 3 then
    self:wantDoNothing()
  else
    if hour == 6 then
      self:wantFreeInArea({ self.classroomAreaPositions })
    elseif hour == 8 then
      self:stayInClass()
    elseif hour == 12 then
      self:wantFreeTime()
    elseif hour == 14 then
      self:wantFreeInArea({ self.trainAreaPositions })
    elseif hour == 20 then
      self:lightCandle(nil, true)
      self:nextWantFreeInArea({ self.classroomAreaPositions })
    elseif hour == 22 then
      self:putOutCandleAndGoToBed()
    end
  end
end

function Gaoxiaohu:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 8 then
    self:wantAtHour(6)
  elseif hour >= 8 and hour < 12 then
    self:wantAtHour(8)
  elseif hour >= 12 and hour < 14 then
    self:wantAtHour(12)
  elseif hour >= 14 and hour < 20 then
    self:wantAtHour(14)
  elseif hour >= 20 and hour < 22 then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Gaoxiaohu:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Gaoxiaohu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '做做任务，也会有所收获。')
  self:toastSpeak('做做任务，也会有所收获。')
end

function Gaoxiaohu:candleEvent (player, candle)
  if self.think == 'sleep' and candle.isLit then
    -- self:speakTo(player.objid, 0, '……')
    self:toastSpeak('……')
  end
end

-- 呆在教室
function Gaoxiaohu:stayInClass ()
  self:wantMove('class', { self.classRoomPos })
  self:nextWantLookAt(nil, self.candlePositions[2], 1)
end

function Gaoxiaohu:playerClickEvent (objid)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainProgress == 3 and mainProgress == 4 then
    -- self:speakTo(objid, 0, '真宝阁就在学院斜对面。')
    self:toastSpeak('真宝阁就在学院斜对面。')
  end
end

-- 月无双
Yuewushuang = BaseActor:new(MyMap.ACTOR.YUEWUSHUANG_ACTOR_ID)

function Yuewushuang:new ()
  local o = {
    objid = 4401861750,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-16, 7.5, 595.5), -- 学院大门口内
    bedData = {
      MyPosition:new(21.5, 8.5, 596.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(14.5, 8.5, 597.5), -- 门口蜡烛
      MyPosition:new(14.5, 8.5, 592.5), -- 内墙蜡烛
    },
    trainAreaPositions = {
      MyPosition:new(3.5, 7.5, 592.5), -- 演武场墙角
      MyPosition:new(-14.5, 7.5, 609.5) -- 演武场墙角
    },
    dormitoryAreaPositions = {
      MyPosition:new(15.5, 8.5, 592.5), -- 宿舍蜡烛旁
      MyPosition:new(21.5, 8.5, 597.5) -- 宿舍角落
    },
    defaultTalkMsg = '我要努力学习，变得更加厉害。'
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Yuewushuang:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Yuewushuang:wantAtHour (hour)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if mainIndex == 3 and mainProgress < 3 or mainIndex < 3 then
    self:wantDoNothing()
  else
    if hour == 6 then
      self:wantFreeInArea({ self.dormitoryAreaPositions })
    elseif hour == 8 then
      self:wantFreeAttack({ self.trainAreaPositions })
    elseif hour == 12 then
      self:wantFreeTime()
    elseif hour == 14 then
      self:wantFreeAttack({ self.trainAreaPositions })
    elseif hour == 20 then
      self:lightCandle(nil, true)
      self:nextWantFreeInArea({ self.dormitoryAreaPositions })
    elseif hour == 22 then
      self:putOutCandleAndGoToBed()
    end
  end
end

function Yuewushuang:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 8 then
    self:wantAtHour(6)
  elseif hour >= 8 and hour < 12 then
    self:wantAtHour(8)
  elseif hour >= 12 and hour < 14 then
    self:wantAtHour(12)
  elseif hour >= 14 and hour < 20 then
    self:wantAtHour(14)
  elseif hour >= 20 and hour < 22 then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Yuewushuang:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Yuewushuang:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '我也刚来学院，希望能够变得很厉害。')
  self:toastSpeak('我也刚来学院，希望能够变得很厉害。')
end

function Yuewushuang:candleEvent (player, candle)
  if self.think == 'sleep' and candle.isLit then
    -- self:speakTo(player.objid, 0, '明天还要训练呢，早点休息。')
    self:toastSpeak('明天还要训练呢，早点休息。')
  end
end

-- 江火
Jianghuo = BaseActor:new(MyMap.ACTOR.JIANGHUO_ACTOR_ID)

function Jianghuo:new ()
  local o = {
    objid = 4402063235,
    isSingleton = true, -- 唯一
    unableBeKilled = true, -- 不可被杀死
    teamid = 1, -- 红队
    initPosition = MyPosition:new(-5.5, 7.5, 599.5), -- 学院演武场内
    bedData = {
      MyPosition:new(17.5, 8.5, 608.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(14.5, 8.5, 604.5), -- 门口蜡烛
      MyPosition:new(14.5, 8.5, 609.5), -- 内墙蜡烛
    },
    trainAreaPositions = {
      MyPosition:new(3.5, 7.5, 592.5), -- 演武场墙角
      MyPosition:new(-14.5, 7.5, 609.5) -- 演武场墙角
    },
    dormitoryAreaPositions = {
      MyPosition:new(15.5, 8.5, 609.5), -- 宿舍蜡烛旁
      MyPosition:new(21.5, 8.5, 604.5) -- 宿舍角落
    },
    attr = {
      isTesting = false, -- 正在考试
      dodgeCD = 2, -- 表示每被攻击几次后会进行躲避
      dodgeIndex = 0, -- 躲避能量，被攻击加1
    }, -- 特殊属性
    talkInfos = jianghuoTalkInfos,
    currentTalkMsg = nil,
    defaultTalkMsg = '我感觉我出拳的速度似乎更快了。',
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Jianghuo:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Jianghuo:wantAtHour (hour)
  if self:isTesting() then -- 正在考试
    return
  end
  if hour == 6 then
    self:wantFreeInArea({ self.dormitoryAreaPositions })
  elseif hour == 8 then
    self:wantFreeAttack({ self.trainAreaPositions })
  elseif hour == 12 then
    self:wantFreeTime()
  elseif hour == 14 then
    self:wantFreeAttack({ self.trainAreaPositions })
  elseif hour == 20 then
    self:lightCandle(nil, true)
    self:nextWantFreeInArea({ self.dormitoryAreaPositions })
  elseif hour == 22 then
    self:putOutCandleAndGoToBed()
  end
end

function Jianghuo:doItNow ()
  local hour = TimeHelper.getHour()
  if hour >= 6 and hour < 8 then
    self:wantAtHour(6)
  elseif hour >= 8 and hour < 12 then
    self:wantAtHour(8)
  elseif hour >= 12 and hour < 14 then
    self:wantAtHour(12)
  elseif hour >= 14 and hour < 20 then
    self:wantAtHour(14)
  elseif hour >= 20 and hour < 22 then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Jianghuo:init ()
  local initSuc = self:initActor(self.initPosition)
  if initSuc then
    self:doItNow()
  end
  return initSuc
end

function Jianghuo:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  -- self:speakTo(playerid, 0, '我来学院没多久，就觉得自己厉害了许多。')
  self:toastSpeak('我来学院没多久，就觉得自己厉害了许多。')
end

function Jianghuo:candleEvent (player, candle)
  if self.think == 'sleep' and candle.isLit then
    -- self:speakTo(player.objid, 0, '睡觉睡觉，明天再闹。')
    self:toastSpeak('睡觉睡觉，明天再闹。')
  end
end

--[[
  受到伤害
  @param    {number} toobjid 攻击生物的玩家/生物id
  @param    {number} hurtlv 伤害
  @author   莫小仙
  @datetime 2021-10-06 18:58:37
]]
function Jianghuo:beHurt (toobjid, hurtlv)
  local player = PlayerHelper.getPlayer(toobjid)
  story3:checkIfTest(player, self)
end

--[[
  设置是否在考试标记
  @param    {boolean} isTesting 是否在考试中
  @author   莫小仙
  @datetime 2021-10-06 22:57:43
]]
function Jianghuo:setTesting (isTesting)
  self.attr.isTesting = isTesting
end

--[[
  是否在考试
  @return   {boolean} 是否在考试
  @author   莫小仙
  @datetime 2021-10-06 22:59:08
]]
function Jianghuo:isTesting ()
  return self.attr.isTesting
end

--[[
  尝试在区域内躲避，当躲避能量满了则进行躲避
  @param    {table} posBeg 区域起点
  @param    {table} posEnd 区域终点
  @author   莫小仙
  @datetime 2021-10-06 20:57:00
]]
function Jianghuo:tryDodge (posBeg, posEnd)
  local attr = self.attr
  attr.dodgeIndex = attr.dodgeIndex + 1
  if attr.dodgeIndex >= attr.dodgeCD then -- 躲避能量满了，则进行躲避
    attr.dodgeIndex = 0 -- 重置能量
    local pos = self:getMyPosition()
    pos.y = pos.y + 1
    WorldHelper.playAndStopBodyEffectById(pos, BaseConstant.BODY_EFFECT.SMOG1) -- 地面显示烟雾
    self:setPosition(MathHelper.getRandomPos(posBeg, posEnd)) -- 移动到区域内的一个随机位置
  end
end

--[[
  开始命中
  @param    {number} toobjid 玩家/生物id
  @author   莫小仙
  @datetime 2021-10-07 01:25:05
]]
function Jianghuo:attack (toobjid)
  self:toastSpeak('邦邦一拳。')
end