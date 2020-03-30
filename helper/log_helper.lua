-- 日志工具类
LogHelper = {
  level = 'debug' -- debug info error
}

function LogHelper:debug (message)
  if (self.level == 'debug') then
    ChatHelper:sendSystemMsg('debug: ' .. message)
  end
end

function LogHelper:info (message)
  if (self.level == 'debug' or self.level == 'info') then
    ChatHelper:sendSystemMsg('info: ' .. message)
  end
end

function LogHelper:error (message)
  ChatHelper:sendSystemMsg('error: ' .. message)
end

function LogHelper:call (f, p)
  xpcall(f, function (err)
    self:error(err)
  end, p)
end
