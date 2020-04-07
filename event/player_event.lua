-- 玩家事件

-- 参数 eventobjid, areaid
local playerEnterArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:info('玩家进入区域' .. areaid)
  LogHelper:call(function (p)
    MyAreaHelper:playerEnterArea(p.objid, p.areaid)
  end, { objid = objid, areaid = areaid })
end

-- 参数 eventobjid, areaid
local playerLeaveArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug('玩家离开区域' .. areaid)
end

-- 参数 eventobjid, blockid, x, y, z
local clickBlock = function (eventArgs)
  local objid = eventArgs['eventobjid']
  -- wenyu:wantDoNothing()
  -- wenyu:lookAt(MyPlayerHelper:getHostPlayer().objid)
  -- local story2 = MyStoryHelper:getStory(2)
  -- LogHelper:call(function (p)
  --   wenyu:exchangeBed()
  --   yexiaolong:goToBed()
  -- end, {objid = objid})
  -- local myPlayer = MyPlayerHelper:getPlayer(objid)
  -- yexiaolong:setPosition(eventArgs.x, eventArgs.y, eventArgs.z)
  -- yexiaolong:wantMove('goToCollege', story2.movePositions1)
  -- MyTimeHelper:callFnAfterSecond (function (p)
  --   MyPlayerHelper:everyPlayerRunTo(story2.movePositions2, function (v)
  --     MyStoryHelper:teacherLeaveForAWhile(v)
  -- end, p.myPlayer)
  -- end, 3, { myPlayer = myPlayer })
  
  -- MyPlayerHelper:everyPlayerRunTo(eventPosition2.x, eventPosition2.y, eventPosition2.z)
  -- ActorHelper:addBuff(yexiaolong.objid, ActorHelper.BUFF.FASTER_RUN, 4, 6000)
  -- MyPlayerHelper:everyPlayerAddBuff(ActorHelper.BUFF.FASTER_RUN, 4, 6000)
  -- local eventPosition1 = { x = 0, y = 8, z = 280 }
  -- yexiaolong:wantMove('goToCollege', { eventPosition1 })

  -- local data = BlockHelper:getBlockData(eventArgs.x, eventArgs.y, eventArgs.z)
  -- LogHelper:debug('men' .. data)

  -- LogHelper:debug('销毁江枫')
  -- ActorHelper:clearActorWithId(jiangfeng.actorid)
  -- local areaid = AreaHelper:getAreaByPos({ x = eventArgs.x, y = eventArgs.y, z = eventArgs.z })
  -- local objids = AreaHelper:getAllCreaturesInAreaId(areaid)
  
  -- wenyu.lastBedHeadPosition = wenyu.currentBedHeadPosition
  -- yexiaolong:setPosition(eventArgs.x, eventArgs.y + 1, eventArgs.z)
  -- yexiaolong:goToBed()

  -- ActorHelper:tryNavigationToPos (jiangfeng.objid, eventArgs.x, eventArgs.y, eventArgs.z, true)
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
  
  LogHelper:call(function (p)
    -- local myActor = MyActorHelper:getActorByObjid(p.toobjid)
    -- LogHelper:info(myActor:getName(), '的想法是：', myActor.wants[1].style)
    MyActorHelper:playerClickActor(p.objid, p.toobjid)
  end, { objid = objid, toobjid = toobjid })
  
end

-- 参数 eventobjid, toobjid, itemid, itemnum
local playerAddItem = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  local itemid = eventArgs['itemid']
  local itemnum = eventArgs['itemnum']
  -- LogHelper:info(objid, ',', toobjid, ',', itemid, ',', itemnum)
  LogHelper:call(function (p)
    MyStoryHelper:playerAddItem(p.objid, p.itemid, p.itemnum)
  end, { objid = objid, itemid = itemid, itemnum = itemnum })
end

-- 参数 eventobjid, toobjid
local playerDamageActor = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  LogHelper:call(function (p)
    MyPlayerHelper:playerDamageActor(p.objid, p.toobjid)
  end, { objid = objid, toobjid = toobjid })
end

ScriptSupportEvent:registerEvent([=[Player.AreaIn]=], playerEnterArea) -- 玩家进入区域
ScriptSupportEvent:registerEvent([=[Player.AreaOut]=], playerLeaveArea) -- 玩家离开区域
ScriptSupportEvent:registerEvent([=[Player.ClickBlock]=], clickBlock) -- 点击方块
ScriptSupportEvent:registerEvent([=[Player.UseItem]=], playerUseItem) -- 玩家使用物品
ScriptSupportEvent:registerEvent([=[Player.ClickActor]=], playerClickActor) -- 玩家点击生物
ScriptSupportEvent:registerEvent([=[Player.AddItem]=], playerAddItem) -- 玩家新增道具
ScriptSupportEvent:registerEvent([=[Player.DamageActor]=], playerDamageActor) -- 玩家给对方造成伤害
