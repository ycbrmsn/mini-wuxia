-- 橘一刀
Juyidao = MyActor:new(MyConstant.JUYIDAO_ACTOR_ID)

function Juyidao:new ()
  local o = {
    objid = 4382796216,
    targetObjid = nil,  -- 攻击对象
    alertObjids = {}, -- 警告对象
    initPosition = MyPosition:new(65.5, 7.5, 45.5), -- 橘山
    areaSize = {
      MyPosition:new(20, 8, 20), MyPosition:new(30, 10, 30)
    }, -- 内外圈区域大小
    isBattle = false, -- 是否在战斗
    battleType = 1, -- 战斗方式
    battleProgress = 1, -- 战斗阶段
    defaultSpeed = 200,
    speed = { 800, 1200, 2000 } -- 移动速度
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
      self:checkAreaPlayer()
      return false
    end, 1)
  end
  return initSuc
end

function Juyidao:collidePlayer (playerid, isPlayerInFront) end
function Juyidao:candleEvent (myPlayer, candle) end
function Juyidao:defaultPlayerClickEvent (objid) end
function Juyidao:defaultCollidePlayerEvent (playerid, isPlayerInFront) end

-- 检测区域内的玩家
function Juyidao:checkAreaPlayer ()
  -- 搜索外圈玩家
  local pos = self:getMyPosition()
  local playerids = MyAreaHelper:getAllPlayersArroundPos(pos, self.areaSize[2])
  if (#playerids > 0) then
    -- 如果玩家没被警告，就警告他
    for i, v in ipairs(playerids) do
      local alerted = false
      for ii, vv in ipairs(self.alertObjids) do
        if (v == vv) then
          alerted = true
          break
        end
      end
      if (not(alerted)) then -- 未被警告
        table.insert(self.alertObjids, v)
        self:alertTo(v)
      end
    end
    -- 搜索内圈玩家
    local playerids2 = MyAreaHelper:getAllPlayersArroundPos(pos, self.areaSize[1])
    if (#playerids2 > 0) then
      -- 内圈有玩家，则找最近的内圈玩家
      local minDis, minDisPlayerid -- 距离，最近玩家
      for i, v in ipairs(playerids2) do
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
      self:startBattle(minDisPlayerid)
    end
  else -- 身边没有玩家
    -- 清空警告对象
    if (#self.alertObjids > 0) then
      self.alertObjids = {}
    end
    if (self.isBattle) then -- 如果在战斗，就停止战斗
      self:finishBattle()
    end
  end
end

-- 警告
function Juyidao:alertTo (objid)
  if (not(self.isBattle)) then
    -- 停止移动
    self:wantDontMove('alert')
    -- 看向玩家
    MyTimeHelper:callFnFastRuns(function ()
      self:lookAt(objid)
    end, 1)
  end
  -- 说话
  self:speakTo(objid, 0, '来者何人，速速退去。')
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
    local pos = MyActorHelper:getMyPosition(self.targetObjid) -- 玩家位置
    local selfPos = self:getMyPosition() -- 橘一刀位置
    local distance = MathHelper:getDistance(selfPos, pos)
    local desPos = MathHelper:getPos2PosInLineDistancePosition(selfPos, pos, 4) -- 目标位置
    self:runAndAttack(distance, desPos)
  elseif (self.battleType == 2) then
    self:runCircleAndAttack()
  elseif (self.battleType == 3) then
    self:jumpAndAttack()
  end
end

-- 冲刺一刀
function Juyidao:runAndAttack (distance, pos)
  if (self.battleProgress == 1) then -- 冲刺
    if (distance > 15) then -- 15米外速度
      MonsterHelper:runTo(self.objid, pos, self.speed[1])
    elseif (distance > 10) then -- 10米外速度
      MonsterHelper:runTo(self.objid, pos, self.speed[2])
    elseif (distance > 5) then -- 5米外速度
      MonsterHelper:runTo(self.objid, pos, self.speed[3])
    else -- 发动攻击
      self.battleProgress = 2
      self:runAndAttack()
    end
  elseif (self.battleProgress == 2) then -- 来一刀
    if (not(distance) or distance < 5) then
      self:openAI()
    else
      self.battleProgress = 1
      self:runBattle()
    end
  else -- 后退
    local targetPos = MyActorHelper:getMyPosition(self.targetObjid)
    local dstPos = MathHelper:getPos2PosInLineDistancePosition(self:getMyPosition(), targetPos, 10) -- 目标位置
    MonsterHelper:runTo(self.objid, dstPos, self.speed[3])
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

function Juyidao:changeMotion (actormotion)
  LogHelper:debug('橘一刀当前行为 ', actormotion)
end