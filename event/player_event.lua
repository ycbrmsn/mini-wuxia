-- 玩家事件

-- eventobjid, areaid
local playerEnterArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:info('玩家进入区域' .. areaid)
  LogHelper:call(function ()
    MyAreaHelper:playerEnterArea(objid, areaid)
  end)
end

-- eventobjid, areaid
local playerLeaveArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug('玩家离开区域' .. areaid)
  LogHelper:call(function ()
    MyAreaHelper:playerLeaveArea(objid, areaid)
  end)
end

-- eventobjid, blockid, x, y, z
local clickBlock = function (eventArgs)
  local objid = eventArgs['eventobjid']
  LogHelper:call(function ()
    local myPosition = MyPosition:new(eventArgs)
    MyBlockHelper:check(myPosition, objid)
  end)
end

-- eventobjid toobjid itemid itemnum
local playerUseItem = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local itemid = eventArgs['itemid']
  LogHelper:call(function ()
    MyItemHelper:useItem(objid, itemid)
  end)
end

-- eventobjid, toobjid
local playerClickActor = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  -- local actorid = CreatureHelper:getActorID(toobjid)
  LogHelper:call(function ()
    MyActorHelper:playerClickActor(objid, toobjid)
  end)
  
end

-- eventobjid, toobjid, itemid, itemnum
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

-- eventobjid, toobjid
local playerAttackHit = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  LogHelper:call(function ()
    MyPlayerHelper:playerAttackHit(objid, toobjid)
  end)
end

-- eventobjid, toobjid
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

-- eventobjid, toobjid, itemid, itemnum
local playerSelectShortcut = function (eventArgs)
  local objid = eventArgs['eventobjid']
  LogHelper:call(function ()
    local player = MyPlayerHelper:getPlayer(objid)
    player:holdItem()
  end)
end

-- eventobjid, toobjid, itemid, itemnum
local playerShortcutChange = function (eventArgs)
  local objid = eventArgs['eventobjid']
  LogHelper:call(function ()
    local player = MyPlayerHelper:getPlayer(objid)
    player:holdItem()
  end)
end

-- eventobjid, playermotion
local playerMotionStateChange = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local playermotion = eventArgs['playermotion']
  LogHelper:call(function ()
    if (playermotion == PLAYERMOTION.SNEAK) then -- 潜行
      MyItemHelper:useItem2(objid)
    end
  end)
end

-- eventobjid, toobjid
local playerMoveOneBlockSize = function (eventArgs)
  local objid = eventArgs['eventobjid']
  LogHelper:call(function ()
    MyActorHelper:resumeClickActor(objid)
  end)
end

ScriptSupportEvent:registerEvent([=[Player.AreaIn]=], playerEnterArea) -- 玩家进入区域
ScriptSupportEvent:registerEvent([=[Player.AreaOut]=], playerLeaveArea) -- 玩家离开区域
ScriptSupportEvent:registerEvent([=[Player.ClickBlock]=], clickBlock) -- 点击方块
ScriptSupportEvent:registerEvent([=[Player.UseItem]=], playerUseItem) -- 玩家使用物品
ScriptSupportEvent:registerEvent([=[Player.ClickActor]=], playerClickActor) -- 玩家点击生物
ScriptSupportEvent:registerEvent([=[Player.AddItem]=], playerAddItem) -- 玩家新增道具
ScriptSupportEvent:registerEvent([=[Player.AttackHit]=], playerAttackHit) -- 玩家攻击命中
ScriptSupportEvent:registerEvent([=[Player.DamageActor]=], playerDamageActor) -- 玩家给对方造成伤害
-- ScriptSupportEvent:registerEvent([=[Player.ChangeAttr]=], playerChangeAttr) -- 属性变化
ScriptSupportEvent:registerEvent([=[Player.DefeatActor]=], playerDefeatActor) -- 打败目标
ScriptSupportEvent:registerEvent([=[Player.BeHurt]=], playerBeHurt) -- 受到伤害
ScriptSupportEvent:registerEvent([=[Player.SelectShortcut]=], playerSelectShortcut) -- 选择快捷栏
ScriptSupportEvent:registerEvent([=[Player.ShortcutChange]=], playerShortcutChange) -- 快捷栏变化
ScriptSupportEvent:registerEvent([=[Player.MotionStateChange]=], playerMotionStateChange) -- 运动状态改变
ScriptSupportEvent:registerEvent([=[Player.MoveOneBlockSize]=], playerMoveOneBlockSize) -- 移动一格
