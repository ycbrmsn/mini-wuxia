-- 我的角色工具类
MyActorHelper = {
  speakDim = MyPosition:new(20, 10, 20)
}

-- 初始化actors
function MyActorHelper.init ()
  wenyu = Wenyu:new()
  jiangfeng = Jiangfeng:new()
  jiangyu = Jiangyu:new()
  wangdali = Wangdali:new()
  miaolan = Miaolan:new()
  yangwanli = Yangwanli:new()
  huaxiaolou = Huaxiaolou:new()
  yexiaolong = Yexiaolong:new()

  daniu = Daniu:new()
  erniu = Erniu:new()
  qianbingwei = Qianbingwei:new()
  ludaofeng = Ludaofeng:new()
  sunkongwu = Sunkongwu:new()
  limiaoshou = Limiaoshou:new()
  qianduo = Qianduo:new()
  murongxiaotian = Murongxiaotian:new()
  gaoxiaohu = Gaoxiaohu:new()
  yuewushuang = Yuewushuang:new()
  jianghuo = Jianghuo:new()
  juyidao = Juyidao:new()
  local myActors = { jiangfeng, jiangyu, wangdali, miaolan, wenyu, yangwanli, huaxiaolou, yexiaolong, daniu, 
      erniu, qianbingwei, ludaofeng, sunkongwu, limiaoshou, qianduo, murongxiaotian, gaoxiaohu, juyidao,
      yuewushuang, jianghuo, }
  for i, v in ipairs(myActors) do
    TimeHelper.initActor(v)
    -- LogHelper.debug('创建', v:getName(), '完成')
  end
  LogHelper.debug('创建人物完成')
end

function MyActorHelper.updateHp (objid)
  local offset
  local monsterModel = MonsterHelper.getMonsterModel(objid)
  if (monsterModel) then
    offset = monsterModel.offset
  else
    offset = 110
  end
  ActorHelper.updateHp(objid, offset)
end

-- 事件

-- 生物被创建
EventHelper.addEvent('actorCreate', function (objid, toobjid)
  MyActorHelper.updateHp(objid)
end)

-- 生物击败目标
EventHelper.addEvent('actorBeat', function (objid, toobjid)
  if (ActorHelper.isPlayer(toobjid)) then -- 目标是玩家
    local player = PlayerHelper.getPlayer(toobjid)
    player.beatBy = CreatureHelper.getActorID(objid)
    TimeHelper.callFnFastRuns(function ()
      player.beatBy = nil
    end, 4)
  end
end)

-- 生物行为改变
EventHelper.addEvent('actorChangeMotion', function (objid, actormotion)
  if (actormotion == CREATUREMOTION.ATK_MELEE) then -- 近战攻击
    local monsterModel = MyMonsterHelper.getMonsterModel(objid)
    if (monsterModel and monsterModel.attackSpeak) then
      TimeHelper.callFnCanRun(monsterModel.actorid, 'atk', function ()
        local pos = ActorHelper.getMyPosition(objid)
        if (pos) then
          local playerids = ActorHelper.getAllPlayersArroundPos(pos, self.speakDim, objid)
          if (playerids and #playerids > 0) then
            for i, v in ipairs(playerids) do
              if (monsterModel.attackSpeak) then
                monsterModel:attackSpeak(v)
              end
            end
          end
        end
      end, 10)
    end
  end
end)

-- 生物获得状态效果
EventHelper.addEvent('actorAddBuff', function (objid, buffid, bufflvl)
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      -- actor:setSealed(true)
    else
      MonsterHelper.sealMonster(objid)
    end
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      -- actor:setImprisoned(true)
    else
      MonsterHelper.imprisonMonster(objid)
    end
  end
end)

-- 生物失去状态效果
EventHelper.addEvent('actorRemoveBuff', function (objid, buffid, bufflvl)
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      -- actor:setSealed(false)
    else
      MonsterHelper.cancelSealMonster(objid)
    end
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      -- actor:setImprisoned(false)
    else
      MonsterHelper.cancelImprisonMonster(objid)
    end
  end
end)

-- 生物属性变化
EventHelper.addEvent('actorChangeAttr', function (objid, actorattr)
  if (actorattr == CREATUREATTR.CUR_HP) then
    MyActorHelper.updateHp(objid)
  end
end)