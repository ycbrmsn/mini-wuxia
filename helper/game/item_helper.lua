-- 道具工具类
ItemHelper = {}

-- 封装原始接口

-- 获取itemid
function ItemHelper:getItemId (objid)
  local onceFailMessage = '获取itemid失败一次'
  local finillyFailMessage = StringHelper:concat('获取itemid失败，参数objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Item:getItemId(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end
