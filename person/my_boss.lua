-- boss

-- 橘一刀
Juyidao = BaseActor:new(MyMap.ACTOR.JUYIDAO_ACTOR_ID)

function Juyidao:new ()
  local o = {
    objid = 4382796216,
    unableBeKilled = true,
    immuneFall = true,
    targetObjid = nil,  -- 攻击对象
    targetPlayer = nil, -- 攻击玩家
    alertObjids = {}, -- 警告对象
    initPosition = MyPosition:new(328.5, 26.5, 686.5), -- 橘山
    areaSize = {
      MyPosition:new(15, 8, 15), MyPosition:new(20, 10, 20)
    }, -- 内外圈区域大小
    resetSize = { x = 40, y = 40, z = 40 }, -- 周围没有玩家重置位置
    isBattle = false, -- 是否在战斗
    battleType = 1, -- 战斗方式
    battleProgress = 1, -- 战斗阶段
    defaultSpeed = 200,
    speed = { 500, 1200, 2000 }, -- 移动速度
    fallSpeed = { 0.07, 0.5 }, -- 阻力
    circleRadius = 5, -- 跑圈半径
    tall = 2, -- 高度
    dontDo = true, -- 没有做
    resumed = true, -- 已恢复，可继续战斗
    isImprisoning = false, -- 慑魂中
    attackTimes = 0, -- 攻击次数
    noAttackTime = 0, -- 攻击时间
  }
  self.__index = self
  setmetatable(o, self)
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
  if initSuc then
    TimeHelper.repeatUtilSuccess(function ()
      self:checkAreaPlayer()
      return false
    end, 1, self.actorid .. 'alert')
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
  if not pos or not self.resumed or self.isImprisoning then -- 没找到玩家 或 没有恢复 或 被禁魔中
    return
  end
  local playerids = ActorHelper.getAllPlayersArroundPos(pos, self.areaSize[2])
  if #playerids > 0 then
    -- 如果玩家没被警告，就警告他
    for i, v in ipairs(playerids) do
      local alerted = false
      for ii, vv in ipairs(self.alertObjids) do
        if v == vv then
          alerted = true
          break
        end
      end
      if not alerted then -- 未被警告
        table.insert(self.alertObjids, v)
        self:alertTo(v)
      end
    end
    -- 搜索内圈玩家
    local playerids2 = ActorHelper.getAllPlayersArroundPos(pos, self.areaSize[1])
    if #playerids2 > 0 then
      -- 内圈有玩家，则找最近的内圈玩家
      local minDis, minDisPlayerid -- 距离，最近玩家
      for i, v in ipairs(playerids2) do
        if self.targetObjid and self.targetObjid == v then
          minDisPlayerid = v
          break
        end
        local player = PlayerHelper.getPlayer(v)
        local distance = MathHelper.getDistance(player:getMyPosition(), self:getMyPosition())
        if not minDis or minDis > distance then -- 未初始化 或 不是最小值
          minDis = distance
          minDisPlayerid = v
        end
      end
      self.targetObjid = minDisPlayerid
      self.targetPlayer = PlayerHelper.getPlayer(self.targetObjid)
      self:startBattle()
      self.noAttackTime = self.noAttackTime + 1
      if self.noAttackTime > 7 then
        self:chooseBattleType(3)
      end
    end
  else -- 身边没有玩家
    if #self.alertObjids > 0 then
      self.alertObjids = {} -- 清空警告对象
      self:finishBattle()
    end
  end
end

-- 警告
function Juyidao:alertTo (objid)
  if not self.isBattle then
    -- 停止移动
    self:wantDontMove('alert')
    -- 看向玩家
    self:lookAt(objid)
    TimeHelper.callFnFastRuns(function ()
      self:lookAt(objid)
    end, 1)
  end
  -- 说话
  self:speakTo(objid, 0, '来者何人，速速退去。')
end

-- 开始战斗
function Juyidao:startBattle ()
  if self.isBattle then -- 在战斗中
    -- self:chooseBattleType()
    -- self:runBattle()
  else -- 未战斗
    self.isBattle = true
    MonsterHelper.addBoss(self)
    self:chooseBattleType()
    self:wantBattle()
    -- self:runBattle()
  end
end

-- 结束战斗
function Juyidao:finishBattle ()
  if self.isBattle then
    self.isBattle = false
    self.targetObjid = nil
    self.targetPlayer = nil
    MonsterHelper.delBoss(self.objid)
  end
  self:stopRun()
  self:wantFreeAndAlert()
  -- 周围没有玩家时重置位置
  local pos = self:getMyPosition()
  if pos then
    local objids = ActorHelper.getAllPlayersArroundPos(pos, self.resetSize)
    if not objids or #objids == 0 then -- 没有找到玩家
      self:setPosition(self.initPosition)
    end
  end
end

-- 被击败
function Juyidao:beBeat ()
  self.isBattle = false
  self.targetObjid = nil
  self.targetPlayer = nil
  -- todo
end

-- 选择战斗方式
function Juyidao:chooseBattleType (battleType)
  self.battleType = battleType or math.random(1, 3)
  self.battleProgress = 1
  self:openAI()
  if self.battleType > 0 then
    local playerids = ActorHelper.getAllPlayersArroundPos(self:getMyPosition(), self.areaSize[2])
    local skillname
    if self.battleType == 1 then
      skillname = '疾风斩'
    elseif self.battleType == 2 then
      skillname = '旋风斩'
      self.attackTimes = 0
    elseif self.battleType == 3 then
      skillname = '坠风斩'
    end
    for i, v in ipairs(playerids) do
      self:speakTo(v, 0, skillname)
    end
  end
  self.noAttackTime = 0
end

-- 执行战斗
function Juyidao:runBattle ()
  if self.battleType == 0 then
    self:normalAttack()
  elseif self.battleType == 1 then
    local pos = ActorHelper.getMyPosition(self.targetObjid) -- 玩家位置
    local selfPos = self:getMyPosition() -- 橘一刀位置
    local distance = MathHelper.getDistance(selfPos, pos)
    local desPos = MathHelper.getPos2PosInLineDistancePosition(selfPos, pos, 3) -- 目标位置
    self:runAndAttack(distance, desPos)
  elseif self.battleType == 2 then
    self:runCircleAndAttack()
  elseif self.battleType == 3 then
    self:jumpAndAttack()
  end
end

-- 普通攻击
function Juyidao:normalAttack ()
  local pos = ActorHelper.getMyPosition(self.targetObjid) -- 玩家位置
  MonsterHelper.runTo(self.objid, pos, self.speed[1])
end

-- 冲刺一刀
function Juyidao:runAndAttack (distance, pos)
  if self.battleProgress == 1 then -- 冲刺
    if distance > 12 then -- 15米外速度
      MonsterHelper.runTo(self.objid, pos, self.speed[1])
    elseif distance > 9 then -- 10米外速度
      MonsterHelper.runTo(self.objid, pos, self.speed[2])
    elseif distance > 6 then -- 5米外速度
      MonsterHelper.runTo(self.objid, pos, self.speed[3])
    end
  else -- 后退
    local targetPos = ActorHelper.getMyPosition(self.targetObjid)
    local dstPos = MathHelper.getPos2PosInLineDistancePosition(self:getMyPosition(), targetPos, 15) -- 目标位置
    MonsterHelper.runTo(self.objid, dstPos, self.speed[3])
    if self.dontDo then
      self.dontDo = false
      TimeHelper.callFnFastRuns(function ()
        self.dontDo = true
        self:chooseBattleType()
      end, 2)
    end
  end
end

-- 绕圈一刀
function Juyidao:runCircleAndAttack ()
  if self.battleProgress == 1 then
    local angle = MathHelper.getRelativePlayerAngle(self.targetObjid, self.objid)
    if angle > -150 and angle < 0 then
      local pos = self.targetPlayer:getDistancePosition(self.circleRadius, angle - 20)
      MonsterHelper.runTo(self.objid, pos, self.speed[2])
    elseif angle >= 0 and angle < 150 then
      local pos = self.targetPlayer:getDistancePosition(self.circleRadius, angle + 20)
      MonsterHelper.runTo(self.objid, pos, self.speed[2])
    else
      self.battleProgress = 2
    end
  elseif self.battleProgress == 2 then
    if self.dontDo then
      self.dontDo = false
      local pos = self.targetPlayer:getMyPosition()
      local selfPos = self:getMyPosition()
      pos.y = selfPos.y
      ActorHelper.appendFixedSpeed(self.objid, 2, pos)
      TimeHelper.callFnFastRuns(function ()
        self:chooseBattleType()
        self.dontDo = true
      end, 1)
    end
  end
end

-- 凌空一刀
function Juyidao:jumpAndAttack ()
  if self.battleProgress == 1 then
    if self.dontDo then
      self.dontDo = false
      TimeHelper.callFnFastRuns(function ()
        self.dontDo = true
        self.battleProgress = 2
      end, 0.5)
      Actor:appendSpeed(self.objid, 0, self.fallSpeed[2], 0)
    end
    Actor:appendSpeed(self.objid, 0, self.fallSpeed[1], 0)
  elseif self.battleProgress == 2 then
    if self.dontDo then
      self.dontDo = false
      if self.targetPlayer then
        local pos = self.targetPlayer:getDistancePosition(2)
        pos.y = pos.y + self.tall
        self:setPosition(pos)
      end
    end
    Actor:appendSpeed(self.objid, 0, self.fallSpeed[1], 0)
  elseif self.battleProgress == 3 then
    if self.dontDo then
      self.dontDo = false
      TimeHelper.callFnFastRuns(function ()
        self.dontDo = true
        self:chooseBattleType()
      end, 2)
    end
  end
end

-- 攻击命中
function Juyidao:attackHit (toobjid)
  if self.battleType == 0 then -- 普通攻击
    ActorHelper.damageActor(self.objid, toobjid, 5)
  elseif self.battleType == 1 then -- 迎风
    self.battleProgress = 2
    self:closeAI()
    ActorHelper.appendFixedSpeed(toobjid, 1, self:getMyPosition())
    ActorHelper.damageActor(self.objid, toobjid, 11)
  elseif self.battleType == 2 then -- 旋风
    self.attackTimes = self.attackTimes + 1
    if self.attackTimes % 10 == 5 then
      self.battleProgress = 2
    end
    ActorHelper.damageActor(self.objid, toobjid, 6)
  elseif self.battleType == 3 then -- 坠风
    self.dontDo = true
    self.battleProgress = 3
    local player = PlayerHelper.getPlayer(toobjid)
    local pos = player:getMyPosition()
    local selfPos = self:getMyPosition()
    selfPos.y = pos.y
    ActorHelper.appendFixedSpeed(toobjid, 2, selfPos)
    ActorHelper.damageActor(self.objid, toobjid, 12)
  end
  self.noAttackTime = 0
end

function Juyidao:changeMotion (actormotion)
  LogHelper.debug('橘一刀当前行为 ', actormotion)
end

-- 受到伤害
function Juyidao:beHurt (toobjid, hurtlv)
  if not self.isBattle and self.resumed then -- 没有在战斗 且 已恢复
    self:speakAround(nil, 0, '何方鼠辈！')
    TimeHelper.callFnFastRuns(function ()
      ActorHelper.playAndStopBodyEffectById(self.objid, BaseConstant.BODY_EFFECT.LIGHT26)
      CreatureHelper.resetHp(self.objid)
    end, 1)
  end
  local hp = CreatureHelper.getHp(self.objid)
  if hp == 1 then
    if self.resumed then
      self.resumed = false
      self:spawnItems()
      self:finishBattle()
      self:speakAround(nil, 0, '你赢了，这个给你。')
      TimeHelper.callFnFastRuns(function ()
        self.resumed = true
        self.recoverNow = true
      end, 60)
    else
      self:speakAround(nil, 0, '东西都给你了，你还打……')
    end
  end
end

-- 获得状态
function Juyidao:addBuff (buffid, bufflvl)
  if buffid == MyMap.BUFF.SEAL_ID then -- 封魔
    if self.isBattle then
      self:chooseBattleType(0)
    end
    self:speakAround(nil, 0, '嗯？')
  elseif buffid == MyMap.BUFF.IMPRISON_ID then -- 慑魂
    self:forceDoNothing()
    self.isImprisoning = true
    self:speakAround(nil, 0, '你做了什么？')
  end
end

-- 移除状态
function Juyidao:removeBuff (buffid, bufflvl)
  if buffid == MyMap.BUFF.SEAL_ID then -- 封魔
    if self.isBattle then
      self:chooseBattleType()
    end
  elseif buffid == MyMap.BUFF.IMPRISON_ID then -- 慑魂
    self.isImprisoning = false
    if self.isBattle then
      self:chooseBattleType()
      self:wantBattle()
    else
      self:defaultWant()
    end
  end
end

function Juyidao:spawnItems ()
  local level
  local levelRandom = math.random(1, 10)
  if levelRandom < 7 then
    level = 1
  elseif levelRandom < 10 then
    level = 2
  else
    level = 3
  end
  local itemids = {
    MyWeaponAttr.strongAttackSword.levelIds[level],
    MyWeaponAttr.rejuvenationKnife.levelIds[level],
    MyWeaponAttr.overlordSpear.levelIds[level],
    MyWeaponAttr.fallStarBow.levelIds[level],
  }
  local itemId = itemids[math.random(1, 4)]
  local pos = self:getMyPosition()
  WorldHelper.spawnItem(pos.x, pos.y, pos.z, itemId, 1)
end