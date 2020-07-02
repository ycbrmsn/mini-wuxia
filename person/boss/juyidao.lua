-- 橘一刀
Juyidao = MyActor:new(MyConstant.JUYIDAO_ACTOR_ID)

function Juyidao:new ()
  local o = {
    objid = 4382796216,
    targetObjid = nil,
    initPosition = MyPosition:new(65.5, 7.5, 45.5), -- 橘山
    areaSize = {
      MyPosition:new(20, 8, 20), MyPosition:new(30, 10, 30)
    }, -- 内外圈区域大小
    innerArea = nil, -- 内圈区域
    outerArea = nil, -- 外圈区域
    isBattle = false, -- 是否在战斗
    battleType = 1, -- 战斗方式
    battleProgress = 1, -- 战斗阶段
    speed = { 200, 400, 600 } -- 移动速度
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Juyidao:defaultWant ()
  self:wantFreeAndAlert()
end

-- 在几点想做什么
function Juyidao:wantAtHour (hour)
  
end

function Juyidao:doItNow ()
  self:runBattle()
end

-- 初始化
function Juyidao:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    MyTimeHelper:repeatUtilSuccess(self.actorid, 'alert', function ()
      self:createAlertArea()
      self:checkAreaPlayer()
      return false
    end, 60)
  end
  return initSuc
end

function Juyidao:collidePlayer (playerid, isPlayerInFront)
  
end

function Juyidao:candleEvent (myPlayer, candle)
  
end

-- 创建警戒区域
function Juyidao:createAlertArea ()
  if (self.innerArea) then
    AreaHelper:destroyArea(self.innerArea)
    self.innerArea = nil
  end
  if (self.outerArea) then
    AreaHelper:destroyArea(self.outerArea)
    self.outerArea = nil
  end
  local pos = self:getMyPosition()
  if (pos) then
    self.innerArea = AreaHelper:createAreaRect(pos, self.areaSize[1])
    self.outerArea = AreaHelper:createAreaRect(pos, self.areaSize[2])
  end
end

-- 检测区域内的玩家
function Juyidao:checkAreaPlayer ()
  if (self.outerArea) then -- 检测外圈
    local playerids = AreaHelper:getAllPlayersInAreaId(self.innerArea)
    if (#playerids > 0) then
      local minDis, minDisPlayerid -- 距离，最近玩家
      for i, v in ipairs(playerids) do
        if (self.targetObjid and self.targetObjid == v) then
          minDisPlayerid = v
          break
        end
        local player = MyPlayerHelper:getPlayer(v)
        local distance = MathHelper:getDistance(player:getMyPosition(), self:getMyPosition())
        if (not(minDis) or minDis > distance) then
          minDis = distance
          minDisPlayerid = v
        end
      end
      if (self.isBattle) then -- 如果在战斗中，切换目标
        self:startBattle(minDisPlayerid)
      end
    else -- 身边没有玩家
      if (self.isBattle) then -- 如果在战斗，就停止战斗
        self:finishBattle()
      end
    end
  end
end

-- 检测警戒区域
function Juyidao:checkAlertArea (objid, areaid)
  if (self.innerArea and self.innerArea == areaid) then -- 进入内圈
    self:startBattle(objid)
    return true
  elseif (self.outerArea and self.outerArea == areaid) then -- 进入外圈
    -- 停止移动
    self:wantDontMove('alert')
    -- 看向玩家
    self:nextWantLookAt(nil, objid, 10)
    -- 说话
    self:speakTo(objid, 0, '来者何人，扰吾静修。如不退去，小命必丢。')
    return true
  else
    return false
  end
end

-- 开始战斗
function Juyidao:startBattle (objid)
  if (not(objid)) then
    self:chooseBattleType()
    self:runBattle()
  elseif (self.isBattle) then -- 在战斗中
    if (self.targetObjid ~= objid) then -- 切换目标
      self.targetObjid = objid
    end
  else -- 未战斗
    self.isBattle = true
    self.targetObjid = objid
    self:chooseBattleType()
    self:wantBattle()
    self:runBattle()
  end
end

-- 结束战斗
function Juyidao:finishBattle ()
  if (self.isBattle) then
    self.isBattle = false
    self.targetObjid = nil
    self:stopRun()
    self:wantFreeAndAlert()
  end
end

-- 被击败
function Juyidao:beBeat ()
  self.isBattle = false
  self.targetObjid = nil
  -- todo
end

-- 选择战斗方式
function Juyidao:chooseBattleType ()
  self.battleType = math.random(1, 1)
  self.battleProgress = 1
end

-- 执行战斗
function Juyidao:runBattle ()
  if (self.battleType == 1) then
    local pos = MyActorHelper:getMyPosition(self.targetObjid)
    local distance = MathHelper:getDistance(self:getMyPosition(), pos)
    self:runAndAttack(pos, distance)
  elseif (self.battleType == 2) then
    self:runCircleAndAttack()
  elseif (self.battleType == 3) then
    self:jumpAndAttack()
  end
end

-- 冲刺一刀
function Juyidao:runAndAttack (pos, distance)
  if (self.battleProgress == 1) then -- 冲刺
    if (distance > 10) then -- 10米外速度1
      MonsterHelper:runTo(self.objid, pos, self.speed[1])
    elseif (distance > 5) then -- 5米外速度2
      MonsterHelper:runTo(self.objid, pos, self.speed[2])
    else -- 发动攻击
      self.battleProgress = 2
      self:runAndAttack()
    end
  elseif (self.battleProgress == 2) then -- 来一刀
    if (distance >= 5) then
      self.battleProgress = 1
      self:runAndAttack()
    else
      self:openAI()
    end
  else -- 后退
    local disPos = MyPlayerHelper:getPlayer(self.targetObjid):getDistancePosition(10)
    MonsterHelper:runTo(self.objid, disPos, self.speed[2])
    MyTimeHelper:callFnFastRuns(function ()
      self:startBattle()
    end, 2)
  end
end

-- 绕圈一刀
function Juyidao:runCircleAndAttack ()
  if (self.battleProgress == 1) then

  elseif (self.battleProgress == 2) then
    
  end
end

-- 凌空一刀
function Juyidao:jumpAndAttack ()
  if (self.battleProgress == 1) then

  elseif (self.battleProgress == 2) then
    
  end
end

-- 攻击命中
function Juyidao:attackHit (toobjid)
  if (self.battleType == 1) then
    self.battleProgress = 3
    self:closeAI()
    self:runBattle()
  end
end