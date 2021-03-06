-- 我的角色工具类
MyActorHelper = {
  speakDim = MyPosition:new(20, 10, 20)
}

-- 初始化actors
function MyActorHelper:init ()
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
    TimeHelper:initActor(v)
    -- LogHelper:debug('创建', v:getName(), '完成')
  end
  LogHelper:debug('创建人物完成')
end

-- 事件

-- 生物被创建
function MyActorHelper:actorCreate (objid, toobjid)
  ActorHelper:actorCreate(objid, toobjid)
  MyStoryHelper:actorCreate(objid, toobjid)
end

-- actor进入区域
function MyActorHelper:actorEnterArea (objid, areaid)
  ActorHelper:actorEnterArea(objid, areaid)
  MyStoryHelper:actorEnterArea(objid, areaid)
end

-- actor离开区域
function MyActorHelper:actorLeaveArea (objid, areaid)
  ActorHelper:actorLeaveArea(objid, areaid)
  MyStoryHelper:actorLeaveArea(objid, areaid)
end

-- 生物碰撞
function MyActorHelper:actorCollide (objid, toobjid)
  ActorHelper:actorCollide(objid, toobjid)
  MyStoryHelper:actorCollide(objid, toobjid)
  -- body
end

-- 生物攻击命中
function MyActorHelper:actorAttackHit (objid, toobjid)
  ActorHelper:actorAttackHit(objid, toobjid)
  MyStoryHelper:actorAttackHit(objid, toobjid)
end

-- 生物击败目标
function MyActorHelper:actorBeat (objid, toobjid)
  ActorHelper:actorBeat(objid, toobjid)
  MyStoryHelper:actorBeat(objid, toobjid)
  -- body
  if (ActorHelper:isPlayer(toobjid)) then -- 目标是玩家
    local player = PlayerHelper:getPlayer(toobjid)
    player.beatBy = CreatureHelper:getActorID(objid)
    TimeHelper:callFnFastRuns(function ()
      player.beatBy = nil
    end, 4)
  end
end

-- 生物行为改变
function MyActorHelper:actorChangeMotion (objid, actormotion)
  ActorHelper:actorChangeMotion(objid, actormotion)
  MyStoryHelper:actorChangeMotion(objid, actormotion)
  -- body
  if (actormotion == CREATUREMOTION.ATK_MELEE) then -- 近战攻击
    local monsterModel = MyMonsterHelper:getMonsterModel(objid)
    if (monsterModel and monsterModel.attackSpeak) then
      TimeHelper:callFnCanRun(monsterModel.actorid, 'atk', function ()
        local pos = ActorHelper:getMyPosition(objid)
        if (pos) then
          local playerids = ActorHelper:getAllPlayersArroundPos(pos, self.speakDim, objid)
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
end

-- 生物受到伤害
function MyActorHelper:actorBeHurt (objid, toobjid, hurtlv)
  ActorHelper:actorBeHurt(objid, toobjid, hurtlv)
  MyStoryHelper:actorBeHurt(objid, toobjid, hurtlv)
  -- body
end

-- 生物死亡
function MyActorHelper:actorDie (objid, toobjid)
  ActorHelper:actorDie(objid, toobjid)
  MyStoryHelper:actorDie(objid, toobjid)
end

-- 生物获得状态效果
function MyActorHelper:actorAddBuff (objid, buffid, bufflvl)
  ActorHelper:actorAddBuff(objid, buffid, bufflvl)
  MyStoryHelper:actorAddBuff(objid, buffid, bufflvl)
  -- body
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      -- actor:setSealed(true)
    else
      MonsterHelper:sealMonster(objid)
    end
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      -- actor:setImprisoned(true)
    else
      MonsterHelper:imprisonMonster(objid)
    end
  end
end

-- 生物失去状态效果
function MyActorHelper:actorRemoveBuff (objid, buffid, bufflvl)
  ActorHelper:actorRemoveBuff(objid, buffid, bufflvl)
  MyStoryHelper:actorRemoveBuff(objid, buffid, bufflvl)
  -- body
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      -- actor:setSealed(false)
    else
      MonsterHelper:cancelSealMonster(objid)
    end
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      -- actor:setImprisoned(false)
    else
      MonsterHelper:cancelImprisonMonster(objid)
    end
  end
end

-- 生物属性变化
function MyActorHelper:actorChangeAttr (objid, actorattr)
  ActorHelper:actorChangeAttr(objid, actorattr)
  MyStoryHelper:actorChangeAttr(objid, actorattr)
end