-- 王大力
Wangdali = MyActor:new(MyConstant.WANGDALI_ACTOR_ID)

function Wangdali:new ()
  local o = {
    objid = 4315385568,
    initPosition = { x = -30, y = 9, z = -45 }, -- 屋内
    bedData = {
      { x = -26, y = 10, z = -47 }, -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candles = {
      MyBlockHelper:addCandle(-32, 10, -42) -- 蜡烛台
    },
    bedTailPointPosition = { x = -26, y = 10, z = -44 }, -- 床尾指向位置
    movePositions = {
      { x = -30, y = 9, z = -45 }, -- 屋内
      { x = -30, y = 9, z = -34 }, -- 门外
      { x = -22, y = 9, z = -35 }, -- 屋外楼梯上
      { x = -21, y = 9, z = -44 } -- 铁匠炉旁边
    },
    outDoorPositions = {
      { x = -17, y = 9, z = -49 }, -- 亭口角
      { x = -23, y = 9, z = -37 } -- 亭口对角
    },
    homePositions = {
      { x = -33, y = 9, z = -39 }, -- 进门口右角落
      { x = -27, y = 9, z = -47 } -- 对角床上
    },
    doorPosition = { x = -30, y = 9, z = -36 } -- 门外位置
  }
  setmetatable(o, self)
  self.__index = self
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

-- 初始化
function Wangdali:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    local hour = MyTimeHelper:getHour()
    if (hour >= 7 and hour < 19) then
      self:goOutDoor()
    else
      self:goHome()
    end
  end
  return initSuc
end

-- 外出
function Wangdali:goOutDoor ()
  self:wantMove('goOut', self.movePositions)
  self:nextWantFreeInArea({ self.outDoorPositions })
end

-- 回家
function Wangdali:goHome ()
  self:wantMove('goHome', { self.doorPosition })
  self:lightCandle()
  self:nextWantFreeInArea({ self.homePositions })
end

-- 铁匠这个模型没有此动作
function Wangdali:goToBed ()
  
end

function Wangdali:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，你撞我做什么?')
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，你想买点装备吗？')
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我要回家了，不要挡路。有事进屋里再说。')
    else
      self.action:speak(playerid, nickname, '，你怎么能撞人呢。算了，天色不早了，我先回家了。')
    end
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，有事明天再说。')
  end
end