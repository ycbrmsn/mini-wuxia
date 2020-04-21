-- 道具类
MyItem = {}

function MyItem:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
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

-- 江湖日志类
local logPaperData = {
  id = MyConstant.LOG_PAPER_ID,
  title = '江湖经历:',
  content = '',
  isChange = true -- 日志是否改变
}

LogPaper = MyItem:new(logPaperData)

function LogPaper:new (mainIndex, branchIndex)
  mainIndex, branchIndex = mainIndex or 1, branchIndex or 1
  local o = {
    mainIndex = mainIndex,
    branchIndex = branchIndex
  }
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
function LogPaper:showContent (targetuin)
  ChatHelper:sendSystemMsg(self:getContent(), targetuin)
end
