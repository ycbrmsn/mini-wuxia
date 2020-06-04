-- 我的道具工具类
MyItemHelper = {
  item = {}, -- 特殊自定义道具
  projectiles = {} -- 投掷物
}

function MyItemHelper:register (item)
  self.item[item.id] = item
end

function MyItemHelper:getItem (itemid)
  return self.item[itemid]
end

function MyItemHelper:changeHold (objid, itemid1, itemid2)
  local item1 = self:getItem(itemid1)
  local item2 = self:getItem(itemid2)
  local foundItem = false
  if (item1) then -- 之前手持物是自定义特殊道具
    item1:putDown(objid)
    foundItem = true
  end
  if (item2) then -- 当前手持物是自定义特殊道具
    item2:pickUp(objid)
    foundItem = true
  end
  return foundItem
end

function MyItemHelper:useItem (objid, itemid)
  local item = self:getItem(itemid)
  if (item) then -- 使用自定义特殊道具
    item:useItem(objid)
  end
end

function MyItemHelper:useItem2 (objid)
  local itemid = PlayerHelper:getCurToolID(objid)
  local item = self:getItem(itemid)
  if (item) then -- 使用自定义特殊道具
    item:useItem2(objid)
  end
end

-- 记录投掷物伤害
function MyItemHelper:recordProjectile (projectileid, objid, item, hurt)
  self.projectiles[projectileid] = { objid = objid, item = item, hurt = hurt }
  -- 一定时间后清除数据
  MyTimeHelper:callFnAfterSecond(function ( ... )
    self.projectiles[projectileid] = nil
  end, 30)
end

function MyItemHelper:projectileHit (projectileid, toobjid, blockid, x, y, z)
  local projectileInfo = self.projectiles[projectileid]
  if (projectileInfo) then
    local item = projectileInfo.item
    item:projectileHit(objid, toobjid, blockid, x, y, z)
  end
end