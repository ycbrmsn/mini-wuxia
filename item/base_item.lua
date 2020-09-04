-- 道具类
BaseItem = {}

function BaseItem:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  if (o.id) then
    ItemHelper:register(o)
  end
  return o
end

-- 创建道具
function BaseItem:newItem (playerid, num, disableThrow)
  num = num or 1
  BackpackHelper:addItem(playerid, self.id, num)
  if (disableThrow) then -- 不可丢弃
    PlayerHelper:setItemDisableThrow(playerid, self.id)
  end
end

-- 是否有道具
function BaseItem:hasItem (playerid, containEquip)
  return BackpackHelper:hasItem(playerid, self.id, containEquip)
end

-- 更新道具数量
function BaseItem:updateNum (playerid, num, disableThrow)
  local curNum, arr1, arr2 = BackpackHelper:getItemNumAndGrid(playerid, self.id)
  if (num == curNum) then -- 数量相同则不作处理
    return
  else
    if (num > curNum) then -- 比当前多
      self:newItem(playerid, num - curNum, disableThrow)
    else -- 比当前少
      BackpackHelper:removeGridItemByItemID(playerid, self.id, curNum - num)
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
  setmetatable(o, self)
  self.__index = self
  o:newLevels()
  return o
end

function MyWeapon:newLevel (id, level)
  local o = {
    id = id,
    level = level,
    attack = self.attack + math.floor(self.addAttPerLevel * level),
    defense = self.defense + math.floor(self.addDefPerLevel * level)
  }
  setmetatable(o, self)
  self.__index = self
  if (o.id) then
    ItemHelper:register(o)
  end
  return o
end

function MyWeapon:newLevels ()
  for i, v in ipairs(self.levelIds) do
    self:newLevel(v, i - 1)
  end
end

function MyWeapon:pickUp (objid)
  local player = PlayerHelper:getPlayer(objid)
  player:changeAttr(self.attack, self.defense)
end

function MyWeapon:putDown (objid)
  local player = PlayerHelper:getPlayer(objid)
  player:changeAttr(-self.attack, -self.defense)
end

function MyWeapon:useItem (objid)
  if (self.skillname) then
    local player = PlayerHelper:getPlayer(objid)
    if (not(player:ableUseSkill(self.skillname))) then
      return
    end
  end
  if (self.cd) then
    local ableUseSkill = ItemHelper:ableUseSkill(objid, self.id, self.cd)
    if (not(ableUseSkill)) then
      self.cdReason = self.cdReason or '技能冷却中'
      ChatHelper:sendSystemMsg(self.cdReason, objid)
      return
    end
  end
  if (self.useItem1) then
    self:useItem1(objid)
  end
end

function MyWeapon:useItem2 (objid)
  if (self.skillname) then
    local player = PlayerHelper:getPlayer(objid)
    if (not(player:ableUseSkill(self.skillname))) then
      return
    end
  end
  if (self.cd) then
    local ableUseSkill = ItemHelper:ableUseSkill(objid, self.id, self.cd)
    if (not(ableUseSkill)) then
      self.cdReason = self.cdReason or '技能冷却中'
      ChatHelper:sendSystemMsg(self.cdReason, objid)
      return
    end
  end
  if (self.useItem3) then
    self:useItem3(objid)
  end
end

-- 减少体力
function MyWeapon:reduceStrength (objid)
  local player = PlayerHelper:getPlayer(objid)
  player:reduceStrength(self.strength)
end
