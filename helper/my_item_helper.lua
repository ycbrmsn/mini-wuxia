-- 我的道具工具类
MyItemHelper = {
  item = {}, -- 特殊自定义道具 itemid -> item
  projectiles = {}, -- 投掷物 projectileid -> info
  itemcds = {}, -- 道具cd objid -> { itemid -> time }
  delaySkills = {} -- 当前技能 objid - > { 'time' -> time, 'index' -> index }
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

-- 记录投掷物伤害 投掷物id、人物id、道具、伤害
function MyItemHelper:recordProjectile (projectileid, objid, item, o)
  o = o or {}
  o.projectileid = projectileid
  o.objid = objid
  o.item = item
  self.projectiles[projectileid] = o
  -- 一定时间后清除数据
  MyTimeHelper:callFnAfterSecond(function ()
    self.projectiles[projectileid] = nil
  end, 30)
end

function MyItemHelper:projectileHit (projectileid, toobjid, blockid, pos)
  local projectileInfo = self.projectiles[projectileid]
  if (projectileInfo) then
    local item = projectileInfo.item
    item:projectileHit(projectileInfo, toobjid, blockid, pos)
  end
end

-- 记录使用技能
function MyItemHelper:recordUseSkill (objid, itemid, cd, dontSetCD)
  if (objid and itemid and cd) then
    if (not(self.itemcds[objid])) then
      self.itemcds[objid] = {}
    end
    self.itemcds[objid][itemid] = os.time()
    if (not(dontSetCD)) then
      PlayerHelper:setSkillCD(objid, itemid, cd)
    end
  else
    if (not(objid)) then
      LogHelper:debug('objid不存在')
    elseif (not(itemid)) then
      LogHelper:debug('itemid不存在')
    else
      LogHelper:debug('cd不存在')
    end
  end
end

-- 是否能够使用技能
function MyItemHelper:ableUseSkill (objid, itemid, cd)
  if (not(cd) or cd <= 0) then -- cd值有误
    return true
  end
  if (objid and itemid) then
    local info = self.itemcds[objid]
    if (not(info)) then -- 玩家未使用过技能
      return true
    else
      local time = info[itemid]
      if (not(time)) then -- 该技能未使用过
        return true
      else -- 技能使用过
        local remainingTime = cd + time - os.time()
        if (remainingTime <= 0) then
          return true
        else
          return false, remainingTime
        end
      end
    end
  else
    if (objid) then
      LogHelper:debug('itemid不存在')
    else
      LogHelper:debug('objid不存在')
    end
    return true
  end
end

-- 记录延迟技能
function MyItemHelper:recordDelaySkill (objid, time, index, name)
  self.delaySkills[objid] = { time = time, index = index, name = name }
end

-- 延迟技能是否正在释放
function MyItemHelper:isDelaySkillUsing (objid, name)
  if (self.delaySkills[objid] and self.delaySkills[objid].name == name) then
    return true
  else
    return false
  end
end

-- 删除延迟技能记录
function MyItemHelper:delDelaySkillRecord (objid)
  self.delaySkills[objid] = nil
end

-- 取消延迟技能
function MyItemHelper:cancelDelaySkill (objid)
  local delaySkillInfo = self.delaySkills[objid]
  if (delaySkillInfo and delaySkillInfo.index) then
    MyTimeHelper:delFn(delaySkillInfo.time, delaySkillInfo.index)
    self:delDelaySkillRecord(objid)
    ChatHelper:sendSystemMsg('取消' .. delaySkillInfo.name .. '技能', objid)
  end
end