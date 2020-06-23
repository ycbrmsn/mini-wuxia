-- 游戏工具类
GameHelper = {}

-- 封装原始接口

-- 设置脚本参数
function GameHelper:setScriptVar (index, val)
  local onceFailMessage = '设置脚本参数失败一次'
  local finillyFailMessage = StringHelper:concat('设置脚本参数失败，参数：index=', index)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Game:setScriptVar(index, val)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取脚本参数
function GameHelper:getScriptVar (index)
  local onceFailMessage = '获取脚本参数失败一次'
  local finillyFailMessage = StringHelper:concat('获取脚本参数失败，参数：index=', index)
  return CommonHelper:callOneResultMethod(function (p)
    return Game:getScriptVar(index)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 上传设置好的脚本参数
function GameHelper:sendScriptVars2Client ()
  local onceFailMessage = '上传设置好的脚本参数失败一次'
  local finillyFailMessage = StringHelper:concat('上传设置好的脚本参数失败')
  return CommonHelper:callIsSuccessMethod(function (p)
    return Game:sendScriptVars2Client()
  end, nil, onceFailMessage, finillyFailMessage)
end