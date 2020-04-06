-- 剧情类
MyStory = {
  data = {
    title = nil,
    name = nil,
    desc = nil,
    tips = nil
  }
}

function MyStory:new ()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyStory:setData (data)
  if (not(data)) then
    LogHelper:debug('剧情数据为空')
  elseif (not(data.title)) then
    LogHelper:debug('剧情标题为空')
  elseif (not(data.name)) then
    LogHelper:debug(data.title, '剧情名称为空')
  elseif (not(data.desc)) then
    LogHelper:debug(data.title, '剧情描述为空')
  elseif (not(data.tips)) then
    LogHelper:debug(data.title, '剧情提示为空')
  end
  self.data = data
end

function MyStory:getData ()
  local data = {
    title = self.data.title,
    name = self.data.name,
    desc = self.data.desc,
    tips = self.data.tips
  }
  return data
end
