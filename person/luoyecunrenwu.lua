-- 落叶村人物

-- 杨万里
Yangwanli = BaseActor:new(MyMap.ACTOR.YANGWANLI_ACTOR_ID)

function Yangwanli:new ()
  local o = {
    objid = 4315385574,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-11.5, 8.5, -10.5), -- 屋内
    bedData = {
      MyPosition:new(-6.5, 9.5, -10.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-17.5, 9.5, -9.5), -- 屋角落蜡烛台
      MyPosition:new(-10.5, 9.5, -13.5) -- 屋中央蜡烛台
    },
    homeAreaPositions = {
      MyPosition:new(-17.5, 9.5, -18.5), -- 屋门口边上
      MyPosition:new(-6.5, 9.5, -10.5) -- 床
    },
    doorPosition = MyPosition:new(-11.5, 8.5, -21.5), -- 门外位置
    talkInfos = yangwanliTalkInfos,
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Yangwanli:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Yangwanli:wantAtHour (hour)
  if (hour == 7) then
    self:wantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 19) then
    self:lightCandle(nil, true)
    self:nextWantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Yangwanli:doItNow ()
  local hour = TimeHelper.getHour()
  if (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Yangwanli:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 回家
function Yangwanli:goHome ()
  self:wantMove('goHome', { self.doorPosition }) -- 门外
end

-- free提一提背上酒壶 free2扔酒壶喝酒 poss喝酒
function Yangwanli:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，你怎么能撞老人家呢？')
    self.action:playFree(2)
  elseif (self.think == 'free') then
    self:speakTo(playerid, 0, nickname, '，找我有事吗？')
    self.action:playFree2(2) -- 扔酒壶
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我要回家。不要挡住老人家的路啊。')
      self.action:playFree(2)
    else
      self:speakTo(playerid, 0, nickname, '，有事去我屋里说。不要随便撞人啊')
      self.action:playFree(2)
    end
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，不要打搅我。要尊老知不知道。')
    self.action:playAngry(2)
  elseif (self.think == 'lightCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，不要挡着老人家点蜡烛。')
      self.action:playFree2(2)
    else
      self:speakTo(playerid, 0, nickname, '，不要影响我去点蜡烛，多危险知道不？')
      self.action:playFree2(2)
    end
  elseif (self.think == 'putOutCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，让一让，老人家要熄蜡烛去了。')
      self.action:playFree2(2)
    else
      self:speakTo(playerid, 0, nickname, '，我去熄蜡烛了，有事等下再说。')
      self.action:playFree2(2)
    end
  end
end

function Yangwanli:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, nickname, '，老人家在睡觉，你点蜡烛做什么!')
    else
      self:speakTo(myPlayer.objid, 0, nickname, '，老人家要睡觉了，你还点蜡烛做什么!')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playAngry(1)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end

-- 王大力
Wangdali = BaseActor:new(MyMap.ACTOR.WANGDALI_ACTOR_ID)

function Wangdali:new ()
  local o = {
    objid = 4339145592,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-29.5, 9.5, -44.5), -- 屋内
    bedData = {
      MyPosition:new(-25.5, 10.5, -46.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(-31.5, 10.5, -41.5) -- 蜡烛台
    },
    bedTailPointPosition = MyPosition:new(-25.5, 10.5, -43.5), -- 床尾指向位置
    movePositions = {
      MyPosition:new(-29.5, 9, -36.5), -- 屋内
      MyPosition:new(-29.5, 9.5, -35.5) -- 门外
      -- MyPosition:new(-21.5, 9.5, -34.5), -- 屋外楼梯上
      -- MyPosition:new(-20.5, 9.5, -43.5) -- 铁匠炉旁边
    },
    outDoorPositions = {
      MyPosition:new(-15.5, 9.5, -48.5), -- 亭口角
      MyPosition:new(-22.5, 9.5, -36.5) -- 亭口对角
    },
    homePositions = {
      MyPosition:new(-32.5, 9.5, -38.5), -- 进门口右角落
      MyPosition:new(-26.5, 9.5, -46.5) -- 对角床上
    },
    doorPosition = MyPosition:new(-29.5, 9.5, -35.5) -- 门外位置
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Wangdali:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Wangdali:wantAtHour (hour)
  -- 发现王大力好像出不了一格的门，方法就暂时不用
  if (hour == 7) then
    self:goOutDoor()
  elseif (hour == 19) then
    self:goHome()
  end
end

function Wangdali:doItNow ()
  local hour = TimeHelper.getHour()
  if (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  else
    self:wantAtHour(19)
  end
end

-- 初始化
function Wangdali:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 外出
function Wangdali:goOutDoor ()
  self:putOutCandle(nil, true)
  self:nextWantMove('goOut', self.movePositions)
  self:nextWantFreeInArea({ self.outDoorPositions })
end

-- 回家
function Wangdali:goHome ()
  if (self.think == 'atHome') then
    self:lightCandle(nil, true)
    self:nextWantFreeInArea('atHome', { self.homePositions })
  else
    self:wantMove('goHome', { self.doorPosition })
    self:lightCandle()
    self:nextWantFreeInArea('atHome', { self.homePositions })
  end
end

-- 铁匠这个模型没有此动作
function Wangdali:goToBed ()
  
end

function Wangdali:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，你撞我做什么?')
  elseif (self.think == 'free' or self.think == 'atHome') then
    self:speakTo(playerid, 0, nickname, '，你想买点装备吗？')
  elseif (self.think == 'goOut') then
    self:speakTo(playerid, 0, nickname, '，有事先出去再说。')
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我要回家了，不要挡路。有事进屋里再说。')
    else
      self:speakTo(playerid, 0, nickname, '，你怎么能撞人呢。算了，天色不早了，我先回家了。')
    end
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，有事明天再说。')
  end
end

function Wangdali:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'atHome') then
    self.action:stopRun()
    self:speakTo(myPlayer.objid, 0, nickname, '，别熄蜡烛。')
    self:wantLookAt(nil, myPlayer.objid, 4)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end

-- 苗兰
Miaolan = BaseActor:new(MyMap.ACTOR.MIAOLAN_ACTOR_ID)

function Miaolan:new ()
  local o = {
    objid = 4314184974,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(-33.5, 8.5, -13.5), -- 药店柜台后
    bedData = {
      MyPosition:new(-29.5, 14.5, -14.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向南
    },
    candlePositions = {
      MyPosition:new(-31.5, 9.5, -14.5), -- 楼下蜡烛台
      MyPosition:new(-27.5, 14.5, -13.5) -- 楼上蜡烛台
    },
    firstFloorDoorPosition = MyPosition:new(-29.5, 8.5, -21.5),
    firstFloorBedPositions = {
      MyPosition:new(-24.5, 9.5, -13.5),
      MyPosition:new(-26.5, 9.5, -13.5),
      MyPosition:new(-28.5, 9.5, -13.5)
    },
    secondFloorPosition = MyPosition:new(-28.5, 13.5, -13.5), -- 二楼床旁边
    secondFloorPositions1 = {
      MyPosition:new(-25.5, 14.5, -14.5), -- 楼梯口
      MyPosition:new(-28.5, 14.5, -13.5) -- 床旁边
    },
    secondFloorPositions2 = {
      MyPosition:new(-28.5, 13.5, -15.5), -- 靠近床旁边
      MyPosition:new(-29.5, 13.5, -18.5) -- 门口
    }
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Miaolan:defaultWant ()
  self:wantFreeTime()
end

function Miaolan:wantAtHour (hour)
  if (hour == 7) then
    self:goToSell()
  elseif (hour == 19) then
    self:goSecondFloor()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Miaolan:doItNow ()
  local hour = TimeHelper.getHour()
  if (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Miaolan:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 卖东西
function Miaolan:goToSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantLookAt(nil, self.firstFloorDoorPosition, 1)
  self:nextWantDoNothing('sell')
end

-- 上二楼
function Miaolan:goSecondFloor ()
  self:lightCandle('free', true, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.secondFloorPositions1, self.secondFloorPositions2 })
end

function Miaolan:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，要爱护身体，不要撞来撞去。')
  elseif (self.think == 'free') then
    self:speakTo(playerid, 0, nickname, '，这么晚过来，你受伤了吗？')
  elseif (self.think == 'toSell') then
    self:speakTo(playerid, 0, nickname, '，我要去卖药了。')
  elseif (self.think == 'sell') then
    self:speakTo(playerid, 0, nickname, '，要抓点药吗？')
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，不要闹。')
  end
end

function Miaolan:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.pos:equals(self.candlePositions[2]) and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, nickname, '，睡眠是很重要的，知道吗？不要点蜡烛了。')
    else
      self:speakTo(myPlayer.objid, 0, nickname, '，你也该去睡觉了，不要点蜡烛了。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playFree2(1)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  elseif ((self.think == 'toSell' or self.think == 'sell') and candle.pos:equals(self.candlePositions[1]) and not(candle.isLit)) then
    self.action:stopRun()
    self:speakTo(myPlayer.objid, 0, nickname, '，熄了蜡烛光线不好呢。')
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playFree2(1)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end

function Miaolan:playerClickEvent (objid)
  local myPlayer = PlayerHelper.getPlayer(objid)
  local hp = PlayerHelper.getHp(objid)
  local maxHp = PlayerHelper.getMaxHp(objid)
  if (hp < maxHp) then
    TimeHelper.callFnCanRun (objid, '苗兰疗伤', function ()
      self:speakTo(objid, 0, myPlayer:getName(), '，你受伤了。来我给你治疗一下。')
      self.action:playAttack()
      self.action:playAttack(1)
      self.action:playAttack(2)
      TimeHelper.callFnAfterSecond (function (p)
        ActorHelper.playBodyEffectById(objid, BaseConstant.BODY_EFFECT.LIGHT26, 1)
        PlayerHelper.setHp(objid, maxHp)
        myPlayer:speakTo(objid, 0, '谢谢苗大夫，我觉得舒服多了。')
        self:speakTo(objid, 1, '不用谢。要爱护身体哦。')
        myPlayer:speakTo(objid, 2, '我知道了。')
      end, 3)
    end, 5)
  else
    -- self:speakTo(objid, 0, '如果你受伤了，我可以给你免费治疗。')
    self.action:playFree2(2)
  end
end

-- 花小楼
Huaxiaolou = BaseActor:new(MyMap.ACTOR.HUAXIAOLOU_ACTOR_ID)

function Huaxiaolou:new ()
  local o = {
    objid = 4301071935,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(10.5, 9.5, -42.5),
    bedData = {
      MyPosition:new(9.5, 10.5, -41.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(11.5, 10.5, -40.5), -- 柜台上的蜡烛台
      MyPosition:new(18.5, 10.5, -42.5), -- 大厅中的蜡烛台
      MyPosition:new(28.5, 10.5, -39.5) -- 走廊上的蜡烛台
    },
    doorPosition = MyPosition:new(16.5, 9.5, -38.5)
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Huaxiaolou:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Huaxiaolou:wantAtHour (hour)
  if (hour == 6) then
    self:goToSell(not(self:lightAndPutOutCandles(self.candlePositions)))
  elseif (hour == 7) then
    self:goToSell(not(self:lightAndPutOutCandles({ self.candlePositions[1], self.candlePositions[2] }, { self.candlePositions[3] })))
  elseif (hour == 19) then
    self:goToSell(not(self:lightAndPutOutCandles(self.candlePositions)))
  elseif (hour == 22) then
    self:goToBed(not(self:lightAndPutOutCandles({ self.candlePositions[1], self.candlePositions[2] }, { self.candlePositions[3] })))
  end
end

function Huaxiaolou:doItNow ()
  local hour = TimeHelper.getHour()
  if (hour >= 6 and hour < 7) then
    self:wantAtHour(6)
  elseif (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Huaxiaolou:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 卖东西
function Huaxiaolou:goToSell (isNow)
  if (isNow) then
    self:wantMove('toSell', { self.initPosition })
  else
    self:nextWantMove('toSell', { self.initPosition })
  end
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

function Huaxiaolou:lightAndPutOutCandles (lightCandles, putOutCandles)
  local index = 1
  local lcs = {}
  if (lightCandles and #lightCandles > 0) then
    for i, v in ipairs(lightCandles) do
      local candle = BlockHelper.getCandle(v)
      if (not(candle.isLit)) then
        table.insert(lcs, v)
      end
    end
  end
  if (#lcs > 0) then
    self:lightCandle(nil, true, lcs)
    index = index + 1
  end
  local pocs = {}
  if (putOutCandles and #putOutCandles > 0) then
    for i, v in ipairs(putOutCandles) do
      local candle = BlockHelper.getCandle(v)
      if (candle.isLit) then
        table.insert(pocs, v)
      end
    end
  end
  if (#pocs > 0) then
    if (index == 1) then
      self:putOutCandle(nil, true, pocs)
    else
      self:putOutCandle(nil, false, pocs)
    end
    index = index + 1
  end
  return index ~= 1
end

function Huaxiaolou:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，你撞我我也不给你好吃的。')
  elseif (self.think == 'lightCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，让一让，我点灯去了。')
    else
      self:speakTo(playerid, 0, nickname, '，不要推丫，万一房子点燃了怎么办。')
    end
  elseif (self.think == 'putOutCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，让一让，我熄灯去了。')
    else
      self:speakTo(playerid, 0, nickname, '，你再打扰我，浪费的灯油你来出哟。')
    end
  elseif (self.think == 'goToSell') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，你要买食物吗？')
    else
      self:speakTo(playerid, 0, nickname, '，我背后没有食物啦。')
    end
  end
end

function Huaxiaolou:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  self.action:stopRun()
  self:speakTo(myPlayer.objid, 0, nickname, '，不要来捣乱哦。')
  self:wantLookAt('sleep', myPlayer.objid, 4)
  self.action:playFree2(1)
  TimeHelper.callFnAfterSecond (function (p)
    self:doItNow()
  end, 3)
end

-- 江枫
Jiangfeng = BaseActor:new(MyMap.ACTOR.JIANGFENG_ACTOR_ID)

function Jiangfeng:new ()
  local o = {
    objid = 4313483881,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(8.5, 8.5, -17.5),
    bedData = {
      MyPosition:new(6.5, 9.5, -12.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(9.5, 9.5, -10.5) -- 蜡烛台
    },
    patrolPositions = {
      MyPosition:new(10.5, 11.5, 12.5), -- 落叶松旁的城上
      MyPosition:new(-9.5, 11.5, 12.5) -- 庄稼地旁的城上
    },
    doorPositions = {
      MyPosition:new(9.5, 8.5, -21.5) -- 门外
    },
    homeAreaPositions = {
      MyPosition:new(7.5, 8.5, -18.5), -- 屋门口边上
      MyPosition:new(11.5, 8.5, -11.5) -- 屋内小柜子旁，避开桌椅
    }
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Jiangfeng:defaultWant ()
  self:wantFreeInArea({ self.homeAreaPositions })
end

-- 在几点想做什么
function Jiangfeng:wantAtHour (hour)
  if (hour == 6) then
    self:defaultWant()
  elseif (hour == 7) then
    self:toPatrol()
  elseif (hour == 19) then
    self:goHome()
  elseif (hour == 21) then
    self:putOutCandleAndGoToBed()
  end
end

function Jiangfeng:doItNow ()
  local hour = TimeHelper.getHour()
  if (hour >= 6 and hour < 7) then
    self:wantAtHour(6)
  elseif (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 21) then
    self:wantAtHour(19)
  else
    self:wantAtHour(21)
  end
end

-- 初始化
function Jiangfeng:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 去巡逻
function Jiangfeng:toPatrol ()
  self:wantMove('toPatrol', { self.patrolPositions[1] })
  self:nextWantPatrol('patrol', self.patrolPositions)
end

-- 回家
function Jiangfeng:goHome ()
  self:wantMove('goHome', self.doorPositions)
  self:lightCandle()
  self:nextWantFreeInArea({ self.homeAreaPositions })
end

function Jiangfeng:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，撞人是不对的哦。')
  elseif (self.think == 'free') then
    self:speakTo(playerid, 0, nickname, '，找我有事吗？')
  elseif (self.think == 'toPatrol') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我要去巡逻了，不要挡住路。')
    else
      self:speakTo(playerid, 0, nickname, '，我要去巡逻了，不要干扰我。')
    end
  elseif (self.think == 'patrol') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我在巡逻呢，不要挡路。')
    else
      self:speakTo(playerid, 0, nickname, '，我在巡逻呢，不要闹。')
    end
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我刚巡逻完，累死了，正要回家呢。不要挡路。')
    else
      self:speakTo(playerid, 0, nickname, '，我刚巡逻完，累死了，正要回家呢。不要闹。')
    end
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，不要闹。')
  end
end

function Jiangfeng:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, nickname, '，我在睡觉呢，不要点蜡烛。')
    else
      self:speakTo(myPlayer.objid, 0, nickname, '，我要睡觉了，不要点蜡烛了。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playDown(1)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  elseif (jiangyu.think == 'sleep' and candle.isLit) then
    jiangyu.action:stopRun()
    if (jiangyu.wants[1].style == 'sleeping') then
      jiangyu:speakTo(myPlayer.objid, 0, nickname, '，我在睡觉，离蜡烛远点。')
    else
      jiangyu:speakTo(myPlayer.objid, 0, nickname, '，我要睡觉了，不要碰我家的蜡烛。')
    end
    jiangyu:wantLookAt('sleep', myPlayer.objid, 4)
    jiangyu.action:playAngry(1)
    TimeHelper.callFnAfterSecond (function (p)
      jiangyu:doItNow()
    end, 3)
  end
end

-- 江渔
Jiangyu = BaseActor:new(MyMap.ACTOR.JIANGYU_ACTOR_ID)

function Jiangyu:new ()
  local o = {
    objid = 4313483879,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(10.5, 8.5, -13.5),
    bedData = {
      MyPosition:new(12.5, 9.5, -12.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(8.5, 12.5, 13.5), -- 最东边蜡烛台
      MyPosition:new(0.5, 12.5, 13.5), -- 中央蜡烛台
      MyPosition:new(-7.5, 12.5, 13.5) -- 最西边蜡烛台
    },
    patrolPositions = jiangfeng.patrolPositions,
    doorPositions = jiangfeng.doorPositions,
    homeAreaPositions = jiangfeng.homeAreaPositions
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Jiangyu:defaultWant ()
  self:wantFreeInArea({ self.homeAreaPositions })
end

-- 在几点想做什么
function Jiangyu:wantAtHour (hour)
  if (hour == 6) then
    self:putOutCandle('patrol', true, { self.candlePositions[3], self.candlePositions[2], self.candlePositions[1] })
    self:nextWantPatrol('patrol', self.patrolPositions)
  elseif (hour == 7) then
    self:goHome()
  elseif (hour == 9) then
    self:putOutCandleAndGoToBed(jiangfeng.candlePositions)
  elseif (hour == 18) then
    self:defaultWant()
  elseif (hour == 19) then
    self:toPatrol()
  end
end

function Jiangyu:doItNow ()
  local hour = TimeHelper.getHour()
  if (hour >= 6 and hour < 7) then
    self:wantAtHour(6)
  elseif (hour >= 7 and hour < 9) then
    self:wantAtHour(7)
  elseif (hour >= 9 and hour < 18) then
    self:wantAtHour(9)
  elseif (hour >= 18 and hour < 19) then
    self:wantAtHour(18)
  else
    self:wantAtHour(19)
  end
end

-- 初始化
function Jiangyu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 去巡逻
function Jiangyu:toPatrol ()
  if (self.think == 'patrol') then
    self:patrol(true)
  else
    self:wantMove('toPatrol', { self.patrolPositions[1] })
    self:patrol()
  end
end

function Jiangyu:patrol (isNow)
  self:lightCandle('patrol', isNow)
  self:nextWantPatrol('patrol', self.patrolPositions)
end

-- 回家
function Jiangyu:goHome ()
  local index = self:putOutCandle(nil, true, { self.candlePositions[3], self.candlePositions[2], self.candlePositions[1] })
  if (index == 1) then
    self:wantMove('goHome', self.doorPositions)
  else
    self:nextWantMove('goHome', self.doorPositions)
  end
  self:nextWantFreeInArea({ self.homeAreaPositions })
end

function Jiangyu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，你撞我好玩吗？')
  elseif (self.think == 'free') then
    self:speakTo(playerid, 0, nickname, '，找我有什么事吗？')
  elseif (self.think == 'toPatrol') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我要去巡逻了，让开哟。')
    else
      self:speakTo(playerid, 0, nickname, '，我要去巡逻了，别蹭我。')
    end
  elseif (self.think == 'patrol') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我在巡逻，别站在我前面。')
    else
      self:speakTo(playerid, 0, nickname, '，我在巡逻，不要影响我。')
    end
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，累死了，别挡着我回家的路。')
    else
      self:speakTo(playerid, 0, nickname, '，累死了，不要降低我回家的速度。')
    end
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，让开哟。')
  end
end

function Jiangyu:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'patrol' and not(candle.isLit)) then
    self.action:stopRun()
    self:speakTo(myPlayer.objid, 0, nickname, '，离蜡烛远点，影响到我巡逻要你好看。')
    self:wantLookAt('patrol', myPlayer.objid, 4)
    self.action:playAngry(1)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end

-- 文羽
Wenyu = BaseActor:new(MyMap.ACTOR.WENYU_ACTOR_ID)

function Wenyu:new ()
  local o = {
    objid = 4315385572,
    isSingleton = true,
    unableBeKilled = true,
    initPosition = MyPosition:new(24.5, 8.5, -9.5), -- 屋内
    bedData1 = {
      MyPosition:new(20.5, 9.5, -8.5), -- 床尾位置1
      ActorHelper.FACE_YAW.EAST -- 床尾朝向东
    },
    bedData2 = {
      MyPosition:new(20.5, 9.5, -11.5), -- 床尾位置2
      ActorHelper.FACE_YAW.EAST -- 床尾朝向东
    },
    candlePositions = {
      MyPosition:new(25.5, 9.5, -21.5), -- 门口蜡烛台
      MyPosition:new(23.5, 9.5, -11.5) -- 里屋蜡烛台
    },
    lastBedData = nil, -- 上一次睡的床尾位置
    currentBedData = nil, -- 当前睡的床尾位置
    homeAreaPositions1 = {
      MyPosition:new(28.5, 8.5, -22.5), -- 壁炉旁
      MyPosition:new(25.5, 8.5, -12.5) -- 转角处
    },
    homeAreaPositions2 = {
      MyPosition:new(28.5, 9.5, -11.5), -- 未转角凳子旁
      MyPosition:new(21.5, 9.5, -8.5) -- 床旁边
    },
    doorPosition = MyPosition:new(23.5, 8.5, -18.5), -- 门外位置
    talkInfos = wenyuTalkInfos,
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 默认想法
function Wenyu:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Wenyu:wantAtHour (hour)
  if (hour == 7) then
    self:exchangeBed()
    self:wantFreeTime()
  elseif (hour == 19) then
    self:goHome()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Wenyu:doItNow ()
  local hour = TimeHelper.getHour()
  if (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Wenyu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 回家
function Wenyu:goHome ()
  self:wantMove('goHome', { self.doorPosition }) -- 门口
  self:lightCandle()
  self:nextWantFreeInArea({ self.homeAreaPositions1, self.homeAreaPositions2 })
end

function Wenyu:exchangeBed ()
  self.lastBedData = self.currentBedData
end

function Wenyu:putOutCandleAndGoToBed ()
  local index = 1
  for i, v in ipairs(self.candlePositions) do
    local candle = BlockHelper.getCandle(v)
    if (not(candle) or candle.isLit) then
      if (index == 1) then
        self:toggleCandle('sleep', v, false, true)
      else
        self:toggleCandle('sleep', v, false)
      end
      index = index + 1
    end
  end
  self:goToBed(index == 1)
end

-- 睡觉
function Wenyu:goToBed (isNow)
  if (self.lastBedData and self.lastBedData == self.bedData1) then
    -- 睡二号床
    if (isNow) then
      self:wantGoToSleep(self.bedData2)
    else
      self:nextWantGoToSleep(self.bedData2)
    end
    self.currentBedData = self.bedData2
  else
    -- 睡一号床
    if (isNow) then
      self:wantGoToSleep(self.bedData1)
    else
      self:nextWantGoToSleep(self.bedData1)
    end
    self.currentBedData = self.bedData1
  end
end

function Wenyu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper.getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，不要撞我嘛。')
    self.action:playFree(2)
  elseif (self.think == 'free') then
    self:speakTo(playerid, 0, nickname, '，要不要来玩丫？')
    self.action:playFree2(2)
  elseif (self.think == 'notice') then
    self:speakTo(playerid, 0, nickname, '，有好消息告诉你哦。')
    self.action:playHi(2)
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我要回家了。不要站在路前面，好嘛。')
      self.action:playFree2(2)
    else
      self:speakTo(playerid, 0, nickname, '，我要回家了。明天再玩吧。')
      self.action:playFree2(2)
    end
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，明天再玩吧。')
    self.action:playFree2(2)
  elseif (self.think == 'lightCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，我看不清路了，要去点蜡烛。')
      self.action:playFree2(2)
    else
      self:speakTo(playerid, 0, nickname, '，你要帮我点蜡烛吗？')
      self.action:playFree2(2)
    end
  elseif (self.think == 'putOutCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，让一让嘛，我要熄蜡烛去了。')
      self.action:playFree2(2)
    else
      self:speakTo(playerid, 0, nickname, '，你要帮我熄蜡烛吗？')
      self.action:playFree2(2)
    end
  end
end

function Wenyu:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.pos:equals(self.candlePositions[2]) and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, nickname, '，我在睡觉呢，不要点蜡烛啦。')
    else
      self:speakTo(myPlayer.objid, 0, nickname, '，我要睡觉了，不要点蜡烛啦。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playFree2(1)
    TimeHelper.callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end