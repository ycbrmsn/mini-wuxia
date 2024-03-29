-- 道具类
BaseItem = {}

function BaseItem:new (o)
  o = o or {}
  if o.id then
    ItemHelper.register(o) -- 注册道具
  end
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 创建道具
function BaseItem:newItem (playerid, num, disableThrow)
  num = num or 1
  BackpackHelper.gainItem(playerid, self.id, num)
  if disableThrow then -- 不可丢弃
    PlayerHelper.setItemDisableThrow(playerid, self.id)
  end
end

-- 是否有道具
function BaseItem:hasItem (playerid, containEquip)
  return BackpackHelper.hasItem(playerid, self.id, containEquip)
end

-- 更新道具数量
function BaseItem:updateNum (playerid, num, disableThrow)
  local curNum, arr1, arr2 = BackpackHelper.getItemNumAndGrid(playerid, self.id)
  if num == curNum then -- 数量相同则不作处理
    return
  else
    if num > curNum then -- 比当前多
      self:newItem(playerid, num - curNum, disableThrow)
    else -- 比当前少
      BackpackHelper.removeGridItemByItemID(playerid, self.id, curNum - num)
    end
  end
end

-- 拿起道具(手上)
function BaseItem:pickUp (objid)
  -- body
end

-- 放下道具(手上)
function BaseItem:putDown (objid)
  -- body
end

-- 使用道具
function BaseItem:useItem (objid)
  -- body
end

-- 进入潜行
function BaseItem:useItem2 (objid)
  -- body
end

-- 选择道具
function BaseItem:selectItem (objid, index)
  -- body
end

-- 手持道具点击方块
function BaseItem:clickBlock (objid, blockid, x, y, z)
  -- body
end

-- 投掷物命中
function BaseItem:projectileHit(projectileInfo, toobjid, blockid, pos)
  -- body
end

-- 攻击命中
function BaseItem:attackHit (objid, toobjid)
  -- body
end

-- 武器类
MyWeapon = BaseItem:new()

function MyWeapon:new (o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  o:newLevels()
  return o
end

function MyWeapon:newLevel (id, level)
  local o = {
    id = id,
    level = level
  }
  -- 攻击
  local addAttack -- 用于保存不同等级的武器具有的额外攻击力(在0级的基础上)
  if self.addAttPerLevel then
    addAttack = math.floor(self.addAttPerLevel * level)
  else
    addAttack = 0
  end
  if self.meleeAttack then
    o.meleeAttack = self.meleeAttack + addAttack -- 近战攻击
  end
  if self.remoteAttack then
    o.remoteAttack = self.remoteAttack + addAttack -- 远程攻击
  end
  -- 防御
  local addDefense -- 用于保存不同等级的武器具有的额外防御力(在0级的基础上)
  if self.addDefPerLevel then
    addDefense = math.floor(self.addDefPerLevel * level)
  else
    addDefense = 0
  end
  if self.meleeDefense then
    o.meleeDefense = self.meleeDefense + addDefense -- 近战防御
  end
  if self.remoteDefense then
    o.remoteDefense = self.remoteDefense + addDefense -- 远程防御
  end
  if o.id then
    ItemHelper.register(o) -- 注册道具
  end
  self.__index = self
  setmetatable(o, self)
  return o
end

function MyWeapon:newLevels ()
  for i, v in ipairs(self.levelIds) do
    self:newLevel(v, i - 1)
  end
end

-- 武器被拿起
function MyWeapon:pickUp (objid)
  local player = PlayerHelper.getPlayer(objid)
  player:changeAttr(self.meleeAttack, self.remoteAttack, self.meleeDefense, self.remoteDefense)
end

-- 武器被放下
function MyWeapon:putDown (objid)
  local player = PlayerHelper.getPlayer(objid)
  player:changeAttr(self.meleeAttack, self.remoteAttack, self.meleeDefense, self.remoteDefense, true)
end

function MyWeapon:useItem (objid)
  if self.skillname then -- 武器技能有名字，表示是特殊技能
    local player = PlayerHelper.getPlayer(objid) -- 获取玩家实例
    if not player:ableUseSkill(self.skillname) then -- 如果玩家当前不能使用该技能（禁魔、封魔等状态），则不执行下面的行为
      return
    end
  end
  if self.cd then -- 技能如果有冷却时间
    local ableUseSkill = ItemHelper.ableUseSkill(objid, self.id, self.cd) -- 是否冷却结束
    if not ableUseSkill then -- 冷却未结束
      self.cdReason = self.cdReason or '技能冷却中'
      ChatHelper.sendSystemMsg(self.cdReason, objid) -- 聊天框提示玩家
      return
    end
  end
  -- 后面是武器的具体效果
  if self.useItem1 then
    self:useItem1(objid)
  end
end

function MyWeapon:useItem2 (objid)
  if self.skillname then
    local player = PlayerHelper.getPlayer(objid)
    if not player:ableUseSkill(self.skillname) then -- 不能使用技能
      return
    end
  end
  if self.cd then
    local ableUseSkill = ItemHelper.ableUseSkill(objid, self.id, self.cd)
    if not ableUseSkill then
      self.cdReason = self.cdReason or '技能冷却中'
      ChatHelper.sendSystemMsg(self.cdReason, objid)
      return
    end
  end
  if self.useItem3 then
    self:useItem3(objid)
  end
end

-- 减少体力
function MyWeapon:reduceStrength (objid)
  local player = PlayerHelper.getPlayer(objid)
  player:reduceStrength(self.strength)
end
