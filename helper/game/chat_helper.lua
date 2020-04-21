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

-- 背包工具类
BackpackHelper = {}

-- 玩家背包里是否有某道具
function BackpackHelper:hasItem (playerid, itemid, containEquip)
  local r1 = BackpackHelper:hasItemByBackpackBar(playerid, BACKPACK_TYPE.SHORTCUT, itemid) -- 快捷栏
  if (r1) then
    return r1, BACKPACK_TYPE.SHORTCUT
  else
    local r2 = BackpackHelper:hasItemByBackpackBar(playerid, BACKPACK_TYPE.INVENTORY, itemid) -- 存储栏
    if (r2) then
      return r2, BACKPACK_TYPE.INVENTORY
    else
      if (containEquip) then
        return BackpackHelper:hasItemByBackpackBar(playerid, BACKPACK_TYPE.EQUIP, itemid), BACKPACK_TYPE.EQUIP -- 装备栏
      else
        return false
      end
    end
  end
end

-- 单一背包栏道具总数及背包格数组
function BackpackHelper:getItemNum (playerid, itemid, containEquip)
  local r, bartype = self:hasItem(playerid, itemid, containEquip)
  if (r) then
    return self:getItemNumByBackpackBar(playerid, bartype, itemid)
  else
    return 0, {}
  end
end

-- 封装原始接口

-- 检测背包是否持有某个道具
function BackpackHelper:hasItemByBackpackBar (playerid, bartype, itemid)
  return Backpack:hasItemByBackpackBar(playerid, bartype, itemid) == ErrorCode.OK
end

-- 获取背包持有某个道具总数量，同时返回装有道具的背包格数组
function BackpackHelper:getItemNumByBackpackBar (playerid, bartype, itemid)
  local onceFailMessage = '获取背包持有某个道具总数量失败一次'
  local finillyFailMessage = StringHelper:concat('获取背包持有某个道具总数量失败，参数：playerid=', playerid, ',bartype=', bartype, ', itemid=', itemid)
  return CommonHelper:callTwoResultMethod(function (p)
    return Backpack:getItemNumByBackpackBar(p.playerid, p.bartype, p.itemid)
  end, { playerid = playerid, bartype = bartype, itemid = itemid }, onceFailMessage, finillyFailMessage)
end

-- 交换背包道具
function BackpackHelper:swapGridItem (playerid, gridsrc, griddst)
  local onceFailMessage = '交换背包道具失败一次'
  local finillyFailMessage = StringHelper:concat('交换背包道具失败，参数：playerid=', playerid, ',gridsrc=', gridsrc, ',griddst=', griddst)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Backpack:swapGridItem(playerid, gridsrc, griddst)
  end, {}, onceFailMessage, finillyFailMessage)
end
