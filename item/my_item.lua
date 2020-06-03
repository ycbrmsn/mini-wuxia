-- 道具类
MyItem = {}

function MyItem:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  if (o.id) then
    MyItemHelper:register(o)
  end
  return o
end

-- 创建道具
function MyItem:newItem (playerid, num, disableThrow)
  num = num or 1
  Backpack:addItem(playerid, self.id, num)
  if (disableThrow) then -- 不可丢弃
    PlayerHelper:setItemDisableThrow(playerid, self.id)
  end
end

-- 是否有道具
function MyItem:hasItem (playerid, containEquip)
  return BackpackHelper:hasItem(playerid, self.id, containEquip)
end

-- 拿起道具(手上)
function MyItem:pickUp (objid)
  -- body
end

-- 放下道具(手上)
function MyItem:putDown (objid)
  -- body
end

-- 使用道具
function MyItem:useItem (objid)
  -- body
end

-- 投掷物命中
function MyItem:projectileHit(objid, toobjid, blockid, x, y, z)
  -- body
end

-- 武器类
MyWeapon = MyItem:new()

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
    MyItemHelper:register(o)
  end
  return o
end

function MyWeapon:pickUp (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  player:changeAttr(self.attack, self.defense)
end

function MyWeapon:putDown (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  player:changeAttr(-self.attack, -self.defense)
end

-- 江湖日志类
local logPaperData = {
  id = MyConstant.ITEM.LOG_PAPER_ID,
  title = '江湖经历:',
  content = '',
  isChange = true -- 日志是否改变
}

LogPaper = MyItem:new(logPaperData)

function LogPaper:new ()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 更新日志 self.title .. 
function LogPaper:updateLogs ()
  local title, content = MyStoryHelper:getMainStoryTitleAndTip()
  self.content = title .. '\n\t\t' .. content
  self.isChange = false
end

-- 获取日志
function LogPaper:getContent ()
  if (self.isChange) then
    self:updateLogs()
  end
  return self.content
end

-- 显示日志
function LogPaper:showContent (objid)
  ChatHelper:sendSystemMsg(self:getContent(), objid)
end

function LogPaper:useItem (objid)
  self:showContent(objid)
end
