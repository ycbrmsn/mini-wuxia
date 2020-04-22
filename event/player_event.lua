-- 玩家事件

-- 参数 eventobjid, areaid
local playerEnterArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:info('玩家进入区域' .. areaid)
  LogHelper:call(function ()
    MyAreaHelper:playerEnterArea(objid, areaid)
  end)
end

-- 参数 eventobjid, areaid
local playerLeaveArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug('玩家离开区域' .. areaid)
  LogHelper:call(function ()
    MyAreaHelper:playerLeaveArea(objid, areaid)
  end)
end

-- 参数 eventobjid, blockid, x, y, z
local clickBlock = function (eventArgs)
  local objid = eventArgs['eventobjid']
  LogHelper:call(function ()
    local myPosition = MyPosition:new(eventArgs)
    MyBlockHelper:check(myPosition, objid)
  end)
end

-- 参数 eventobjid toobjid itemid itemnum
local playerUseItem = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local itemid = eventArgs['itemid']
  if(itemid == logPaper.id) then -- 如果使用江湖日志，则显示日志内容
    logPaper:showContent(objid)
  end
end

-- 参数 eventobjid, toobjid
local playerClickActor = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  -- local actorid = CreatureHelper:getActorID(toobjid)
  LogHelper:call(function ()
    MyActorHelper:playerClickActor(objid, toobjid)
  end)
  
end

-- 参数 eventobjid, toobjid, itemid, itemnum
local playerAddItem = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  local itemid = eventArgs['itemid']
  local itemnum = eventArgs['itemnum']
  -- LogHelper:info(objid, ',', toobjid, ',', itemid, ',', itemnum)
  LogHelper:call(function ()
    MyStoryHelper:playerAddItem(objid, itemid, itemnum)
  end)
end

-- 参数 eventobjid, toobjid
local playerDamageActor = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  LogHelper:call(function ()
    MyPlayerHelper:playerDamageActor(objid, toobjid)
  end)
end

-- eventobjid, toobjid
local playerDefeatActor = function (eventArgs)
  LogHelper:call(function ()
    MyPlayerHelper:playerDefeatActor(eventArgs.eventobjid, eventArgs.toobjid)
  end)
end

-- eventobjid, toobjid
local playerBeHurt = function (eventArgs)
  local objid = eventArgs['eventobjid']
  LogHelper:call(function ()
    local hp = PlayerHelper:getHp(objid)
    if (hp == 1) then
      MyStoryHelper:playerBadHurt(objid)
    end
  end)
end

ScriptSupportEvent:registerEvent([=[Player.AreaIn]=], playerEnterArea) -- 玩家进入区域
ScriptSupportEvent:registerEvent([=[Player.AreaOut]=], playerLeaveArea) -- 玩家离开区域
ScriptSupportEvent:registerEvent([=[Player.ClickBlock]=], clickBlock) -- 点击方块
ScriptSupportEvent:registerEvent([=[Player.UseItem]=], playerUseItem) -- 玩家使用物品
ScriptSupportEvent:registerEvent([=[Player.ClickActor]=], playerClickActor) -- 玩家点击生物
ScriptSupportEvent:registerEvent([=[Player.AddItem]=], playerAddItem) -- 玩家新增道具
ScriptSupportEvent:registerEvent([=[Player.DamageActor]=], playerDamageActor) -- 玩家给对方造成伤害
-- ScriptSupportEvent:registerEvent([=[Player.ChangeAttr]=], playerChangeAttr) -- 属性变化
ScriptSupportEvent:registerEvent([=[Player.DefeatActor]=], playerDefeatActor) -- 打败目标
ScriptSupportEvent:registerEvent([=[Player.BeHurt]=], playerBeHurt) -- 打败目标
