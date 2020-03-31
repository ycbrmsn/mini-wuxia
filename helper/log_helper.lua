-- 日志工具类
LogHelper = {
  level = 'debug' -- debug info error
}

function LogHelper:debug (message)
  if (self.level == 'debug') then
    message = StringHelper:toString(message)
    ChatHelper:sendSystemMsg('debug: ' .. message)
  end
end

function LogHelper:info (message)
  if (self.level == 'debug' or self.level == 'info') then
    message = StringHelper:toString(message)
    ChatHelper:sendSystemMsg('info: ' .. message)
  end
end

function LogHelper:error (message)
  message = StringHelper:toString(message)
  ChatHelper:sendSystemMsg('error: ' .. message)
end

function LogHelper:call (f, p)
  xpcall(f, function (err)
    self:error(err)
  end, p)
end
