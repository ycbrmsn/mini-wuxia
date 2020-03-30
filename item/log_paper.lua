-- 江湖日志类
local data = {
  id = logPaperId,
  title = '江湖经历:',
  mainIndex = 1,
  mainContent = {
    '又是新的一天，不知道会不会发生什么呢。',
    '听文羽说风颖城的武术学院又要开始招生了，我也想前去学习。不过听说有入学考核，我得先准备一番。'
  },
  branchIndex = 1,
  branchContent = {},
  content = '',
  isChange = true -- 日志是否改变
}

LogPaper = MyItem:new(data)

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
  self.content = self.title .. '\n\t\t' .. self.mainContent[self.mainIndex]
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

-- 玩家是否有江湖日志
function LogPaper:hasItem (playerid)
  -- Chat:sendSystemMsg('hasItem')
  local r1 = Backpack:hasItemByBackpackBar(playerid, BACKPACK_TYPE.SHORTCUT, self.id) -- 快捷栏
  if (r1 == ErrorCode.OK) then
    return true
  else
    local r2 = Backpack:hasItemByBackpackBar(playerid, BACKPACK_TYPE.INVENTORY, self.id) -- 存储栏
    return r2 == ErrorCode.OK
  end
end

-- 剧情前进
function LogPaper:forward (isBranch)
  if (isBranch) then
    self.branchIndex = self.branchIndex + 1
  else
    self.mainIndex = self.mainIndex + 1
  end
  self.isChange = true
end