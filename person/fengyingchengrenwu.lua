-- 风颖城人物

-- 陆道风
Ludaofeng = BaseActor:new(MyMap.ACTOR.LUDAOFENG_ACTOR_ID)

function Ludaofeng:new ()
  local o = {
    objid = 4334703245,
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
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Ludaofeng:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Ludaofeng:wantAtHour (hour)
  if (hour == 6) then
    self:lightCandle('free', true, { self.candlePositions[3] })
    self:nextWantFreeInArea({ self.studyAreaPositions })
  elseif (hour == 8) then
    self:putOutCandle('free', true, { self.candlePositions[3] })
    self:nextWantMove('free', self.movePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, { self.candlePositions[1], self.candlePositions[2] })
    self:nextWantFreeInArea({ self.bedroomAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed({ self.candlePositions[1], self.candlePositions[2] })
  end
end

function Ludaofeng:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 8) then
    self:wantAtHour(6)
  elseif (hour >= 8 and hour < 19) then
    self:wantAtHour(8)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Ludaofeng:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Ludaofeng:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '你找我可有要事？')
end

function Ludaofeng:candleEvent (myPlayer, candle)
  
end

-- 千兵卫
Qianbingwei = BaseActor:new(MyMap.ACTOR.QIANBINGWEI_ACTOR_ID)

function Qianbingwei:new ()
  local o = {
    objid = 4334903620,
    initPosition = { x = -19.5, y = 7.5, z = 527.5 },
    bedData = {
      { x = -55.5, y = 7.5, z = 529.5 }, -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-54.5, 8.5, 531.5) -- 蜡烛台
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Qianbingwei:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Qianbingwei:wantAtHour (hour)
  if (hour == 6) then
    self:defaultWant()
  elseif (hour == 21) then
    self:putOutCandleAndGoToBed()
  end
end

function Qianbingwei:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 21) then
    self:wantAtHour(6)
  else
    self:wantAtHour(21)
  end
end

-- 初始化
function Qianbingwei:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Qianbingwei:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, '请注意不要随便撞人。')
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, '你是想被抓起来吗？')
  else
    self:speakTo(playerid, 0, '请不要影响我。')
  end
end

function Qianbingwei:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, '我……')
    else
      self:speakTo(myPlayer.objid, 0, '我……')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    TimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end

-- 叶小龙
Yexiaolong = BaseActor:new(MyMap.ACTOR.YEXIAOLONG_ACTOR_ID)

function Yexiaolong:new ()
  local o = {
    objid = 4315385631,
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
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Yexiaolong:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Yexiaolong:wantAtHour (hour)
  local mainIndex = StoryHelper:getMainStoryIndex()
  if (mainIndex == 1) then
    if (hour == 7) then
      self:wantFreeInArea({ self.homeAreaPositions })
    elseif (hour == 19) then
      self:lightCandle(nil, true)
      self:nextWantFreeInArea({ self.homeAreaPositions })
    elseif (hour == 22) then
      self:putOutCandleAndGoToBed()
    end
  end
end

function Yexiaolong:doItNow ()
  local mainIndex = StoryHelper:getMainStoryIndex()
  if (mainIndex == 1) then
    local hour = TimeHelper:getHour()
    if (hour >= 7 and hour < 19) then
      self:wantAtHour(7)
    elseif (hour >= 19 and hour < 22) then
      self:wantAtHour(19)
    else
      self:wantAtHour(22)
    end
  end
end

-- 初始化
function Yexiaolong:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Yexiaolong:collidePlayer (playerid, isPlayerInFront)
  local nickname
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 1 and mainProgress < 5) then
    nickname = '年轻人'
  else
    nickname = PlayerHelper:getNickname(playerid)
  end
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，你撞我是想试试你的实力吗？')
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，不要惹我哟。')
  else
    self:speakTo(playerid, 0, nickname, '，找我有事吗？')
  end
end

function Yexiaolong:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local mainIndex = StoryHelper:getMainStoryIndex()
  if (mainIndex ~= 2) then
    self.action:stopRun()
    self:collidePlayer(playerid, isPlayerInFront)
    self:wantLookAt(nil, playerid)
  end
end

function Yexiaolong:candleEvent (myPlayer, candle)
  local nickname
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 1 and mainProgress < 5) then
    nickname = '年轻人'
  else
    nickname = myPlayer:getName()
  end
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, nickname, '，你想吃棍子吗？不要碰蜡烛。')
    else
      self:speakTo(myPlayer.objid, 0, nickname, '，我要睡觉了，离蜡烛远点。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playAngry(1)
    TimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end

-- 孙孔武
Sunkongwu = BaseActor:new(MyMap.ACTOR.SUNKONGWU_ACTOR_ID)

function Sunkongwu:new ()
  local o = {
    objid = 4368929599,
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
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Sunkongwu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Sunkongwu:wantAtHour (hour)
  if (hour == 6) then
    self:toSell()
  elseif (hour == 20) then
    self:goSecondFloor()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Sunkongwu:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 20) then
    self:wantAtHour(6)
  elseif (hour >= 20 and hour < 22) then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Sunkongwu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
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
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想买点什么？')
end

function Sunkongwu:candleEvent (myPlayer, candle)
  
end

-- 李妙手
Limiaoshou = BaseActor:new(MyMap.ACTOR.LIMIAOSHOU_ACTOR_ID)

function Limiaoshou:new ()
  local o = {
    objid = 4369329639,
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
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Limiaoshou:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Limiaoshou:wantAtHour (hour)
  if (hour == 6) then
    self:toSell()
  elseif (hour == 20) then
    self:goSecondFloor()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Limiaoshou:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 20) then
    self:wantAtHour(6)
  elseif (hour >= 20 and hour < 22) then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Limiaoshou:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
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
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想买点什么？')
end

function Limiaoshou:candleEvent (myPlayer, candle)
  
end

-- 钱多
Qianduo = BaseActor:new(MyMap.ACTOR.QIANDUO_ACTOR_ID)

function Qianduo:new ()
  local o = {
    objid = 4369930009,
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
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Qianduo:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Qianduo:wantAtHour (hour)
  if (hour == 6) then
    self:toSell()
  elseif (hour == 20) then
    self:freeInHome()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Qianduo:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 20) then
    self:wantAtHour(6)
  elseif (hour >= 20 and hour < 22) then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Qianduo:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
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
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想买点什么？')
end

function Qianduo:candleEvent (myPlayer, candle)
  
end

-- 大牛
Daniu = BaseActor:new(MyMap.ACTOR.DANIU_ACTOR_ID)

function Daniu:new ()
  local o = {
    objid = 4367229311,
    initPosition = MyPosition:new(-48.5, 9.5, 504.5), -- 马厩招待处
    doorPosition = MyPosition:new(-46.5, 8.5, 501.5), -- 门口位置
    bedData = {
      MyPosition:new(-47.5, 8.5, 507.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-48.5, 9.5, 503.5)
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Daniu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Daniu:wantAtHour (hour)
  if (hour == 6) then
    self:lightCandle('toSell', true)
    self:nextWantMove('toSell', { self.initPosition })
    self:nextWantLookAt(nil, self.doorPosition, 1)
    self:nextWantDoNothing('sell')
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Daniu:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 22) then
    self:wantAtHour(6)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Daniu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Daniu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想去哪里？')
end

function Daniu:candleEvent (myPlayer, candle)
  
end

-- 二牛
Erniu = BaseActor:new(MyMap.ACTOR.ERNIU_ACTOR_ID)

function Erniu:new ()
  local o = {
    objid = 4372230256,
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
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Erniu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Erniu:wantAtHour (hour)
  if (hour == 6) then
    self:lightCandle('free', true)
    self:nextWantFreeInArea({ self.bedroomAreaPositions })
  elseif (hour == 8) then
    self:putOutCandle('free', true)
    self:nextWantFreeInArea({ self.roomAreaPositions1, self.roomAreaPositions2 })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Erniu:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 8) then
    self:wantAtHour(6)
  elseif (hour >= 8 and hour < 22) then
    self:wantAtHour(8)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Erniu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Erniu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '买好票之后拿着它给我就好了。')
end

function Erniu:candleEvent (myPlayer, candle)
  
end

function Erniu:playerClickEvent (objid)
  local itemid = PlayerHelper:getCurToolID(objid)
  if (itemid == MyMap.ITEM.CARRIAGE_LUOYECUN_ID) then -- 落叶村车票
    ItemHelper:removeCurTool(objid)
    self:speakTo(objid, 0, '这是去往落叶村的车票。我这就送你过去。')
    TimeHelper:callFnFastRuns(function ()
      local player = PlayerHelper:getPlayer(objid)
      player:setMyPosition(PositionHelper.luoyecunPos)
    end, 2)
  elseif (itemid == MyMap.ITEM.CARRIAGE_PINGFENGZHAI_ID) then -- 平风寨车票
    ItemHelper:removeCurTool(objid)
    self:speakTo(objid, 0, '这是去往平风寨的车票。我这就送你过去。')
    TimeHelper:callFnFastRuns(function ()
      local player = PlayerHelper:getPlayer(objid)
      player:setMyPosition(PositionHelper.pingfengzhaiPos)
    end, 2)
  end
end