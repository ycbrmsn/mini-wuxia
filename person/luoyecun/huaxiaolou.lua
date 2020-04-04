-- 花小楼
Huaxiaolou = MyActor:new(MyConstant.HUAXIAOLOU_ACTOR_ID)

function Huaxiaolou:new ()
  local o = {
    objid = 4301071935,
    initPosition = { x = 10, y = 10, z = -43 }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Huaxiaolou:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Huaxiaolou:wantAtHour (hour)

end

-- 初始化
function Huaxiaolou:init ()
  self:initActor(self.initPosition)
end


function Huaxiaolou:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self.action:speak(playerid, nickname, '，你撞我我也不给你好吃的。')
end