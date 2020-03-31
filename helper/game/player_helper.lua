-- 玩家工具类
PlayerHelper = {}

-- 封装原始接口

-- 获取玩家昵称
function PlayerHelper:getNickname (objid)
  local onceFailMessage = '获取玩家昵称失败一次'
  local finillyFailMessage = StringHelper:concat('获取玩家昵称失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getNickname(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end