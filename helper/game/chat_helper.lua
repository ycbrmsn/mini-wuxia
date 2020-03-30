-- 聊天工具类
ChatHelper = {}

-- 封装原始接口

-- 发送系统消息，默认发送给所有玩家
function ChatHelper:sendSystemMsg (content, targetuin)
  targetuin = targetuin or 0
  local onceFailMessage = '发送系统消息失败一次'
  local finillyFailMessage = '发送系统消息失败'
  return CommonHelper:callIsSuccessMethod(function (p)
    return Chat:sendSystemMsg(p.content, p.targetuin)
  end, { content = content, targetuin = targetuin }, onceFailMessage, finillyFailMessage)
end