-- 我的道具类

-- 江湖日志类
LogPaper = BaseItem:new({ id = MyMap.ITEM.LOG_PAPER_ID })

-- 获取日志
function LogPaper:getContent ()
  local title, content = StoryHelper:getMainStoryTitleAndTip()
  return title .. '\n\t\t' .. content
end

-- 显示日志
function LogPaper:showContent (objid)
  ChatHelper:sendSystemMsg(self:getContent(), objid)
end

function LogPaper:useItem (objid)
  self:showContent(objid)
end