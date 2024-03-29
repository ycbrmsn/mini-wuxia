-- 玩家基类
BasePlayer = {
  objid = nil,
  nickname = nil,
  action = nil,
  wants = nil,  -- 想做什么
  moveMotion = nil,
  prevAreaId = nil, -- 上一进入区域id
  hold = nil, -- 手持物品
  clickActor = nil, -- 最近点击的actor
  active = true, -- 是否活跃，即未离开房间
  talkWithActor = nil, -- 与生物交谈
  whichChoose = nil, -- 在选择什么
  runTime = 0, -- 自动寻路时间，超时后直接移动过去
  yawDiff = -180, -- 朝向与镜头角度差值
}

function BasePlayer:new (o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end

function BasePlayer:init ()
  self.hold = PlayerHelper.getCurToolID(self.objid)
  self.attr.level = PlayerHelper.getLevel(self.objid) or 0
  self:initMyPlayer()
  -- body
end

-- 初始化方法，用于重写
function BasePlayer:initMyPlayer ()
  -- body
end

-- 是否是房主
function BasePlayer:isHostPlayer ()
  return PlayerHelper.isMainPlayer(self.objid)
end

function BasePlayer:speak (afterSeconds, ...)
  if afterSeconds > 0 then
    self.action:speakAfterSeconds(afterSeconds, ...)
  else
    self.action:speakToAll(...)
  end
end

function BasePlayer:speakTo (playerids, afterSeconds, ...)
  if type(playerids) == 'number' then
    if afterSeconds > 0 then
      self.action:speakToAfterSeconds(playerids, afterSeconds, ...)
    else
      self.action:speak(playerids, ...)
    end
  elseif type(playerids) == 'table' then
    for i, v in ipairs(playerids) do
      self:speakTo(v)
    end
  end
end

function BasePlayer:speakSelf (afterSeconds, ...)
  self:speakTo(self.objid, afterSeconds, ...)
end

function BasePlayer:thinks (afterSeconds, ...)
  if afterSeconds > 0 then
    self.action:thinkAfterSeconds(afterSeconds, ...)
  else
    self.action:think(...)
  end
end

function BasePlayer:thinkTo (playerids, afterSeconds, ...)
  if type(playerids) == 'number' then
    if afterSeconds > 0 then
      self.action:thinkToAfterSeconds(playerids, afterSeconds, ...)
    else
      self.action:thinkTo(playerids, ...)
    end
  elseif type(playerids) == 'table' then
    for i, v in ipairs(playerids) do
      self:thinkTo(v, afterSeconds, ...)
    end
  end
end

function BasePlayer:thinkSelf (afterSeconds, ...)
  self:thinkTo(self.objid, afterSeconds, ...)
end

function BasePlayer:updatePositions ()
  self.attr:updatePositions()
end

function BasePlayer:getName ()
  if not self.nickname then
    self.nickname = PlayerHelper.getNickname(self.objid)
  end
  return self.nickname
end

function BasePlayer:isActive ()
  return self.active
end

function BasePlayer:setActive (isActive)
  self.active = isActive
end

function BasePlayer:getPrevLevel ()
  return self.attr.level
end

function BasePlayer:setPrevLevel (level)
  self.attr.level = level
end

function BasePlayer:getLevel ()
  return PlayerHelper.getLevel(self.objid)
end

function BasePlayer:setLevel (level)
  return PlayerHelper.setLevel(self.objid, level)
end

function BasePlayer:getExp ()
  return PlayerHelper.getExp(self.objid)
end

function BasePlayer:setExp (exp)
  return PlayerHelper.setExp(self.objid, exp)
end

-- 玩家被击败的基础经验
function BasePlayer:getBaseExp ()
  return self.attr.expData.exp
end

function BasePlayer:enableMove (enable, showMsg)
  self.attr:enableMove(enable, showMsg)
end

function BasePlayer:enableBeAttacked (enable)
  return PlayerHelper.setPlayerEnableBeAttacked(self.objid, enable)
end

function BasePlayer:getPosition (notUseCache)
  if notUseCache then
    return ActorHelper.getPosition(self.objid)
  else
    return CacheHelper.getPosition(self.objid)
  end
end

function BasePlayer:getMyPosition (notUseCache)
  if notUseCache then
    return ActorHelper.getMyPosition(self.objid)
  else
    return CacheHelper.getMyPosition(self.objid)
  end
end

function BasePlayer:setPosition (x, y, z)
  return ActorHelper.setMyPosition(self.objid, x, y, z)
end

function BasePlayer:setMyPosition (x, y, z)
  return self:setPosition(x, y, z)
  -- return ActorHelper.setMyPosition(self.objid, pos.x, pos.y, pos.z)
end

function BasePlayer:getDistancePosition (distance, angle)
  return ActorHelper.getDistancePosition(self.objid, distance, angle)
end

function BasePlayer:setDistancePosition (objid, distance, angle)
  self:setPosition(ActorHelper.getDistancePosition(objid, distance, angle))
end

function BasePlayer:getFaceYaw ()
  return ActorHelper.getFaceYaw(self.objid)
end

function BasePlayer:getFacePitch ()
  return ActorHelper.getFacePitch(self.objid)
end

-- 获取准星位置
function BasePlayer:getAimPos ()
  return MyPosition:new(PlayerHelper.getAimPos(self.objid))
end

function BasePlayer:gainExp (exp)
  self.attr:gainExp(exp)
end

-- 获得被击败经验
function BasePlayer:gainDefeatedExp ()
  self.attr:gainDefeatedExp()
end

function BasePlayer:upgrade (addLevel)
  return self.attr:upgrade(addLevel)
end

-- 玩家看向，默认会旋转镜头
function BasePlayer:lookAt (toobjid, needRotateCamera)
  if type(needRotateCamera) == 'nil' then
    needRotateCamera = true
  end
  ActorHelper.lookAt(self.objid, toobjid, needRotateCamera)
end

function BasePlayer:wantLookAt (objid, seconds)
  TimeHelper.callFnContinueRuns(function ()
    self:lookAt(objid)
  end, seconds)
end

-- 背包数量及背包格数组
function BasePlayer:getItemNum (itemid, containEquip)
  return BackpackHelper.getItemNum(self.objid, itemid, containEquip)
end

-- 拿出道具
function BasePlayer:takeOutItem (itemid, containEquip)
  local num, arr = self:getItemNum(itemid, containEquip)
  if num == 0 then
    return false
  else
    local grid = BackpackHelper.getCurShotcutGrid(self.objid)
    return BackpackHelper.swapGridItem(self.objid, arr[1], grid)
  end
end

function BasePlayer:holdItem ()
  local itemid = PlayerHelper.getCurToolID(self.objid)
  if itemid then
    if not self.hold and itemid == 0 then  -- 变化前后都没有拿东西
      -- do nothing
    elseif not self.hold then -- 之前没有拿东西
      self:changeHold(itemid)
    elseif itemid == 0 then -- 之后没有拿东西
      self:changeHold(itemid)
    elseif self.hold ~= itemid then -- 换了一件东西拿
      self:changeHold(itemid)
    end -- else是没有换东西，略去
  end
end

function BasePlayer:changeHold (itemid)
  local foundItem, item1, item2 = ItemHelper.changeHold(self.objid, self.hold, itemid)
  self.hold = itemid
  if foundItem then
    -- self:showAttr(true) -- 目前默认显示近程攻击
    self:changeMyItem(item1, item2)
  end
end

-- 手持物改变（改变前后至少有一件是自定义道具）, item1、item2分别为改变前后的自定义道具，为nil表示不是自定义道具
function BasePlayer:changeMyItem (item1, item2)
  -- body
end

-- 改变攻防属性
function BasePlayer:changeAttr (meleeAttack, remoteAttack, meleeDefense, remoteDefense, isMinus)
  self.attr:changeAttr(meleeAttack, remoteAttack, meleeDefense, remoteDefense, isMinus)
end

-- 显示攻防属性变化
function BasePlayer:showAttr ()
  self.attr:showAttr()
end

-- 重置生命值
function BasePlayer:resetHp (hp)
  hp = hp or PlayerHelper.getMaxHp(objid)
  return PlayerHelper.setHp(objid, hp)
end

--[[
  恢复/扣除生命
  @param    {number} hp 生命值，为正表示加血，为负表示扣血，为nil表示加满血
  @return   {boolean} 表示生命值是否发生了变化
  @author   莫小仙
  @datetime 2021-10-10 17:13:57
]]
function BasePlayer:recoverHp (hp)
  self.attr:recoverHp(hp)
end

-- 恢复饱食度（加/减饱食度）
function BasePlayer:recoverFoodLevel(foodLevel)
  self.attr:recoverFoodLevel(foodLevel)
end

-- 减体力
function BasePlayer:reduceStrength (strength)
  self.attr:reduceStrength(strength)
end

-- 伤害生物
function BasePlayer:damageActor (toobjid, val, item)
  self.attr:damageActor(toobjid, val, item)
end

-- 设置囚禁状态
function BasePlayer:setImprisoned (active)
  return self.attr:setImprisoned(active)
end

-- 设置封魔状态
function BasePlayer:setSeal (active)
  return self.attr:setSeal(active)
end

-- 是否能够使用技能
function BasePlayer:ableUseSkill (skillname)
  return self.attr:ableUseSkill(skillname)
end

-- 玩家击败actor
function BasePlayer:defeatActor (objid)
  self.attr:defeatActor(objid)
end

-- 击败玩家获得经验
function BasePlayer:getDefeatExp (objid)
  return self.attr:getDefeatExp(objid)
end

-- 被击败获得经验
function BasePlayer:getDefeatedExp (objid)
  return self.attr:getDefeatedExp(objid)
end

-- 设置点击的生物
function BasePlayer:setClickActor (actor)
  self.clickActor = actor
end

-- 获取点击的生物
function BasePlayer:getClickActor ()
  return self.clickActor
end

function BasePlayer:runTo (positions, callback, param)
  self.action:runTo(positions, callback, param)
end

-- 对话相关

-- 继续对话或选择选项
function BasePlayer:choose ()
  local actor = self:getClickActor()
  if self.whichChoose then -- 当前是选项
    if self.whichChoose == 'talk' then -- 对话选项
      if actor then -- 选择过特定生物
        TalkHelper.chooseTalk(self.objid, actor)
      end
    else -- 自定义选项
      local whichChoose = self.whichChoose
      local chooseItems = MyOptionHelper.optionMap[whichChoose]
      if chooseItems then
        local index = PlayerHelper.getCurShotcut(self.objid) + 1
        if index <= #chooseItems then
          chooseItems[index][2](self)
          if whichChoose == self.whichChoose then -- 选项未变则自动置空
            self.whichChoose = nil
          end
        end
      end
    end
  else -- 当前不是选项
    if actor then -- 选择过特定生物
      PlayerHelper.playerClickActor(self.objid, actor.objid, true)
      -- TalkHelper.talkWith(self.objid, actor)
    end
  end
end

-- 中止对话
function BasePlayer:breakTalk ()
  local actor = self:getClickActor()
  if not actor then -- 没有点击特殊生物
    return
  end
  local index = TalkHelper.getTalkIndex(self.objid, actor)
  if index ~= 1 then -- 表示对话在进行中
    TalkHelper.resetTalkIndex(self.objid, actor)
    TalkHelper.showBreakSeparate(self.objid)
  end
end

-- 结束对话
function BasePlayer:finishTalk ()
  local actor = self:getClickActor()
  if not actor then -- 没有点击特殊生物
    return
  end
  local index = TalkHelper.getTalkIndex(self.objid, actor)
  if index ~= 1 then -- 表示对话在进行中
    TalkHelper.resetTalkIndex(self.objid, actor)
    TalkHelper.showEndSeparate(self.objid)
  end
end

-- 重置对话序数
function BasePlayer:resetTalkIndex (index)
  local actor = self:getClickActor()
  if actor then
    TalkHelper.resetTalkIndex(self.objid, actor, index)
  end
end

-- 新增对话任务，用于改变对话内容
function BasePlayer:addTalkTask (taskid)
  if type(taskid) == 'table' then
    taskid = taskid.id
  end
  TaskHelper.addTempTask(self.objid, taskid)
  self:resetTalkIndex(0)
end