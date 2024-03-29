-- 玩家工具类
PlayerHelper = {
  PLAYERATTR = {
    MAX_HP = 1,
    CUR_HP = 2,
    MAX_HUNGER = 5,
    CUR_HUNGER = 6
  },
  players = {}, -- { objid -> MyPlayer }
  defeatActors = {}, -- 击败的生物
}

-- 如果玩家信息不存在则添加玩家信息
function PlayerHelper.addPlayer (objid)
  local player = MyPlayer:new(objid)
  table.insert(PlayerHelper.getAllPlayers(), player)
  return player
end

-- 移除玩家信息
function PlayerHelper.removePlayer (objid)
  for i, v in ipairs(PlayerHelper.getAllPlayers()) do
    if v.objid == objid then -- 找到对应玩家
      table.remove(PlayerHelper.getAllPlayers(), i)
      break
    end
  end
end

-- 获取玩家信息
function PlayerHelper.getPlayer (objid)
  for i, v in ipairs(PlayerHelper.getAllPlayers()) do
    if v.objid == objid then -- 找到对应玩家
      return v
    end
  end
  return nil
end

-- 获取房主信息
function PlayerHelper.getHostPlayer ()
  local objid = PlayerHelper.getMainPlayerUin()
  if objid then -- 找到房主id
    return PlayerHelper.getPlayer(objid)
  else
    return nil
  end
end

-- 获取所有玩家信息
function PlayerHelper.getAllPlayers ()
  return PlayerHelper.players
end

-- 获取有效玩家
function PlayerHelper.getActivePlayers ()
  local players = {}
  for i, v in ipairs(PlayerHelper.getAllPlayers()) do
    if v:isActive() then -- 活跃玩家，表示还在房间中
      table.insert(players, v)
    end
  end
  return players
end

-- 获取所有玩家名字
function PlayerHelper.getAllPlayerNames ()
  local names = {}
  for i, v in ipairs(PlayerHelper.getAllPlayers()) do
    table.insert(names, v:getName())
  end
  return names
end

-- 是否是玩家
function PlayerHelper.isPlayer (objid)
  local player = PlayerHelper.getPlayer(objid)
  return player and true or false
end

-- 记录死亡生物，5秒后清除数据
function PlayerHelper.recordDefeatActor (objid)
  PlayerHelper.defeatActors[objid] = true
  TimeHelper.callFnAfterSecond(function ()
    PlayerHelper.defeatActors[objid] = nil
  end, 5)
end

-- 获取被击败的actor
function PlayerHelper.getDefeatActor (objid)
  return PlayerHelper.defeatActors[objid]
end

-- 显示飘窗信息
function PlayerHelper.showToast (objid, ...)
  local info = StringHelper.concat(...)
  TimeHelper.callFnInterval(function ()
    PlayerHelper.notifyGameInfo2Self(objid, info)
  end, 2, objid .. 'toast')
end

-- 显示actor当前生命值
function PlayerHelper.showActorHp (objid, toobjid, msg)
  msg = msg or ''
  local actorname, hp
  if ActorHelper.isPlayer(toobjid) then -- 生物是玩家
    local player = PlayerHelper.getPlayer(toobjid)
    actorname = player:getName()
    hp = PlayerHelper.getHp(toobjid)
  else
    actorname = CreatureHelper.getActorName(toobjid)
    hp = CreatureHelper.getHp(toobjid)
  end
  local t = 'showActorHp' .. toobjid
  TimeHelper.delFnFastRuns(t)
  TimeHelper.callFnFastRuns(function ()
    if hp then -- 获取到玩家/生物的当前生命
      if hp <= 0 then -- 表示已死亡
        PlayerHelper.showToast(objid, StringHelper.concat('击败', actorname, msg))
      else
        -- 因为目前可以看到生物的生命值，所以暂时不显示生物剩余生命了
        -- hp = math.ceil(hp)
        -- PlayerHelper.showToast(objid, StringHelper.concat(actorname, '剩余生命：', 
        --   StringHelper.number2String(hp)))
      end
    end
  end, 0.1, t)
end

-- actor行动
function PlayerHelper.runPlayers ()
  for k, v in pairs(PlayerHelper.players) do
    LogHelper.call(function ()
      v.action:execute()
    end)
  end
end

function PlayerHelper.generateDamageKey (objid, toobjid)
  return objid .. 'damage' .. toobjid
end

-- 所有玩家做某事
function PlayerHelper.everyPlayerDoSomeThing (f, afterSeconds)
  if type(f) ~= 'function' then -- 不是函数
    return
  end
  if afterSeconds then -- 需要延时
    TimeHelper.callFnAfterSecond (function ()
      for i, v in ipairs(PlayerHelper.getAllPlayers()) do
        f(v)
      end
    end, afterSeconds)
  else
    for i, v in ipairs(PlayerHelper.getAllPlayers()) do
      f(v)
    end
  end
end

-- 更新所有玩家位置信息
function PlayerHelper.updateEveryPlayerPositions ()
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:updatePositions()
  end)
end

-- 改变所有玩家位置
function PlayerHelper.setEveryPlayerPosition (x, y, z, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:setPosition(x, y, z)
  end, afterSeconds)
end

-- 所有玩家自己说
function PlayerHelper.everyPlayerSpeakToSelf (second, ...)
  for i, v in ipairs(PlayerHelper.getAllPlayers()) do
    v.action:speakToAfterSeconds(v.objid, second, ...)
  end
end

-- 所有玩家说
function PlayerHelper.everyPlayerSpeak (second, ...)
  for i, v in ipairs(PlayerHelper.getAllPlayers()) do
    v.action:speakAfterSeconds(second, ...)
  end
end

-- 所有玩家想
function PlayerHelper.everyPlayerThinkToSelf (second, ...)
  for i, v in ipairs(PlayerHelper.getAllPlayers()) do
    v.action:thinkToAfterSeconds(v.objid, second, ...)
  end
end

-- 飘窗提示所有玩家
function PlayerHelper.everyPlayerNotify (info, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    PlayerHelper.notifyGameInfo2Self(player.objid, info)
  end, afterSeconds)
end

-- 所有玩家可移动控制
function PlayerHelper.everyPlayerEnableMove (enable, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    local msg = enable and true or '剧情中'
    player:enableMove(enable, msg)
  end, afterSeconds)
end

-- 所有玩家跑去
function PlayerHelper.everyPlayerRunTo (positions, callback, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:runTo(positions, callback, player)
  end, afterSeconds)
end

-- 所有玩家加buff
function PlayerHelper.everyPlayerAddBuff (buffid, bufflv, customticks, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    ActorHelper.addBuff(player.objid, buffid, bufflv, customticks)
  end, afterSeconds)
end

-- 所有玩家看向
function PlayerHelper.everyPlayerLookAt (toobjid, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:lookAt(toobjid)
  end, afterSeconds)
end

-- 所有玩家比动作
function PlayerHelper.everyPlayerPlayAct (act, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playAct(act)
  end, afterSeconds)
end

-- 所有玩家恢复生命
function PlayerHelper.everyPlayerRecoverHp (hp, afterSeconds)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:recoverHp(hp)
  end, afterSeconds)
end

-- 改变玩家视角模式
function PlayerHelper.changeVMode (objid, viewmode, islock)
  viewmode = viewmode or VIEWPORTTYPE.BACKVIEW
  if not objid then -- 不存在，表示是对所有玩家执行
    PlayerHelper.everyPlayerDoSomeThing(function (player)
      PlayerHelper.changeViewMode(player.objid, viewmode, islock)
    end)
  elseif type(objid) == 'number' then -- 是数字，表示对一个玩家执行
    PlayerHelper.changeViewMode(objid, viewmode, islock)
  else -- 剩下的应该是数组，表示对这一群玩家执行
    for i, v in ipairs(objid) do
      PlayerHelper.changeViewMode(v, viewmode, islock)
    end
  end
end

-- 设置道具不可丢弃
function PlayerHelper.setItemDisableThrow (objid, itemid)
  return PlayerHelper.setItemAttAction(objid, itemid, PLAYERATTR.ITEM_DISABLE_THROW, true)
end

-- 设置玩家是否可以移动
function PlayerHelper.setPlayerEnableMove (objid, enable)
  return PlayerHelper.setActionAttrState(objid, PLAYERATTR.ENABLE_MOVE, enable)
end

-- 查询玩家是否可被杀死
function PlayerHelper.getPlayerEnableBeKilled (objid)
  return PlayerHelper.checkActionAttrState(objid, PLAYERATTR.ENABLE_BEKILLED)
end

-- 设置玩家是否可被杀死
function PlayerHelper.setPlayerEnableBeKilled (objid, enable)
  return PlayerHelper.setActionAttrState(objid, PLAYERATTR.ENABLE_BEKILLED, enable)
end

-- 设置玩家是否可被攻击
function PlayerHelper.setPlayerEnableBeAttacked (objid, enable)
  return PlayerHelper.setActionAttrState(objid, PLAYERATTR.ENABLE_BEATTACKED, enable)
end

-- 设置玩家是否可破坏方块
function PlayerHelper.setPlayerEnableDestroyBlock (objid, enable)
  return PlayerHelper.setActionAttrState(objid, PLAYERATTR.ENABLE_DESTROYBLOCK, enable)
end

-- 是否满血 返回nil表示玩家不存在
function PlayerHelper.isHpFull (objid)
  local maxHp = PlayerHelper.getMaxHp(objid)
  local hp = PlayerHelper.getHp(objid)
  return maxHp and hp and maxHp == hp
end

function PlayerHelper.getHp (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.CUR_HP)
end

function PlayerHelper.getMaxHp (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.MAX_HP)
end

function PlayerHelper.getLevel (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.LEVEL)
end

function PlayerHelper.setHp (objid, hp)
  return PlayerHelper.setAttr(objid, PLAYERATTR.CUR_HP, hp)
end

function PlayerHelper.setMaxHp (objid, hp)
  return PlayerHelper.setAttr(objid, PLAYERATTR.MAX_HP, hp)
end

function PlayerHelper.getExp (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.CUR_LEVELEXP)
end

function PlayerHelper.setExp (objid, exp)
  return PlayerHelper.setAttr(objid, PLAYERATTR.CUR_LEVELEXP, exp)
end

function PlayerHelper.getLevel (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.CUR_LEVEL)
end

function PlayerHelper.setLevel (objid, level)
  return PlayerHelper.setAttr(objid, PLAYERATTR.CUR_LEVEL, level)
end

-- 氧气
function PlayerHelper.getOxygen (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.CUR_OXYGEN)
end

-- 移动速度
function PlayerHelper.setWalkSpeed (objid, speed)
  return PlayerHelper.setAttr(objid, PLAYERATTR.WALK_SPEED, speed)
end

-- 奔跑速度
function PlayerHelper.setRunSpeed (objid, speed)
  return PlayerHelper.setAttr(objid, PLAYERATTR.RUN_SPEED, speed)
end

-- 游泳速度
function PlayerHelper.setSwimSpeed (objid, speed)
  return PlayerHelper.setAttr(objid, PLAYERATTR.SWIN_SPEED, speed)
end

-- 跳跃力
function PlayerHelper.setJumpPower (objid, jumpPower)
  return PlayerHelper.setAttr(objid, PLAYERATTR.JUMP_POWER, jumpPower)
end

-- 大小
function PlayerHelper.getDimension (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.DIMENSION)
end

function PlayerHelper.setDimension (objid, dimension)
  return PlayerHelper.setAttr(objid, PLAYERATTR.DIMENSION, dimension)
end

-- 设置当前饥饿度
function PlayerHelper.setHunger (objid, hunger)
  return PlayerHelper.setAttr(objid, PLAYERATTR.CUR_HUNGER, hunger)
end

-- 获取最大饥饿度 2020-11-24 测试无效
function PlayerHelper.getMaxHunger (objid)
  return PlayerHelper.getAttr(objid, PLAYERATTR.MAX_HUNGER)
end

-- 设置最大饥饿度 2020-11-18 测试依然无效
function PlayerHelper.setMaxHunger (objid, hunger)
  return PlayerHelper.setAttr(objid, PLAYERATTR.MAX_HUNGER, hunger)
end

function PlayerHelper.addAttr (objid, attrtype, addVal)
  local curVal = PlayerHelper.getAttr(objid, attrtype)
  return PlayerHelper.setAttr(objid, attrtype, curVal + addVal)
end

function PlayerHelper.addExp (objid, exp)
  return PlayerHelper.addAttr(objid, PLAYERATTR.CUR_LEVELEXP, exp)
end

function PlayerHelper.recoverAttr (objid, attrtype)
  return PlayerHelper.setAttr(objid, attrtype + 1, PlayerHelper.getAttr(objid, attrtype))
end

-- 事件

-- 玩家进入游戏 是否之前已存在
function PlayerHelper.playerEnterGame (objid)
  local player = PlayerHelper.getPlayer(objid)
  if not player then -- 玩家信息不存在
    player = PlayerHelper.addPlayer(objid)
    player:init()
    return false
  else -- 存在，表示之前玩家进入过房间
    player:init()
    player:setActive(true)
    return true
  end
end

-- 玩家离开游戏
function PlayerHelper.playerLeaveGame (objid)
  -- PlayerHelper.removePlayer(objid)
  -- 设置玩家不活跃
  local player = PlayerHelper.getPlayer(objid)
  player:setActive(false)
end

-- 玩家进入区域
function PlayerHelper.playerEnterArea (objid, areaid)
  local player = PlayerHelper.getPlayer(objid)
  if areaid == player.toAreaId then -- 玩家自动前往地点
    AreaHelper.destroyArea(areaid)
    -- player.action:runAction()
    player.action:doNext()
  elseif AreaHelper.showToastArea(objid, areaid) then -- 显示提示区域检测
  end
end

-- 玩家离开区域
function PlayerHelper.playerLeaveArea (objid, areaid)
  -- body
end

-- 玩家点击方块
function PlayerHelper.playerClickBlock (objid, blockid, x, y, z)
  local pos = MyPosition:new(x, y, z)
  if BlockHelper.checkCandle(objid, blockid, pos) then -- 如果是点蜡烛
    return
  end
  ItemHelper.clickBlock(objid, blockid, x, y, z)
  local player = PlayerHelper.getPlayer(objid)
  -- 暂时点击方块不会终止对话，以免玩家误点而导致中止对话
  -- player:breakTalk()
end

-- 玩家点击生物 simulatedClick(true表示模拟点击，不是真实点击生物)
function PlayerHelper.playerClickActor (objid, toobjid, simulatedClick)
  local actor = ActorHelper.getActor(toobjid)
  if actor then -- 如果是特定生物
    local want = actor:getFirstWant()
    LogHelper.debug(not want or want.think, not want or want.style)
    if want and string.find(want.think, 'noClick') then -- 此时点击生物无反应
    elseif actor:isPlayerClickEffective(objid) then -- 当前玩家点击有效
      ActorHelper.recordClickActor(objid, actor)
      return actor:defaultPlayerClickEvent(objid, simulatedClick)
    end
  else -- 如果没找到，判断一下是不是没有初始化
    actor = ActorHelper.getNeedInitActor(toobjid)
    if actor then -- 找到了，则表示因为某种原因，该actor没有被初始化
      actor:init()
    end
  end
end

-- 玩家获得道具
function PlayerHelper.playerAddItem (objid, itemid, itemnum)
  -- body
end

-- 玩家背包栏变化
function PlayerHelper.playerBackPackChange (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家使用道具
function PlayerHelper.playerUseItem (objid, toobjid, itemid, itemnum)
  ItemHelper.useItem(objid, itemid)
end

-- 玩家消耗道具
function PlayerHelper.playerConsumeItem (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家丢弃道具
function PlayerHelper.playerDiscardItem (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家拾取道具
function PlayerHelper.playerPickUpItem (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家攻击命中
function PlayerHelper.playerAttackHit (objid, toobjid)
  local itemid = PlayerHelper.getCurToolID(objid)
  local item = ItemHelper.getItem(itemid)
  if item then -- 自定义道具
    item:attackHit(objid, toobjid)
    if objid ~= toobjid then -- 不是击中自己
      -- PlayerHelper.showActorHp(objid, toobjid)
    end
  end
end

-- 玩家造成伤害
function PlayerHelper.playerDamageActor (objid, toobjid, hurtlv)
  local key = PlayerHelper.generateDamageKey(objid, toobjid)
  TimeHelper.setFrameInfo(key, hurtlv)
  -- PlayerHelper.showActorHp(objid, toobjid)
end

-- 玩家击败目标
function PlayerHelper.playerDefeatActor (playerid, objid)
  if PlayerHelper.getDefeatActor(objid) then -- 该生物已死亡
    return false
  else
    PlayerHelper.recordDefeatActor(objid)
    local player = PlayerHelper.getPlayer(playerid)
    player:defeatActor(objid)
    return true
  end
end

-- 玩家受到伤害
function PlayerHelper.playerBeHurt (objid, toobjid, hurtlv)
  -- body
end

-- 玩家死亡
function PlayerHelper.playerDie (objid, toobjid)
  -- 检测技能是否正在释放
  if ItemHelper.isDelaySkillUsing(objid, '坠星') then -- 技能释放中
    FallStarBow:cancelSkill(objid)
  end
end

-- 玩家复活
function PlayerHelper.playerRevive (objid, toobjid)
  local player = PlayerHelper.getPlayer(objid)
  player:gainDefeatedExp()
end

-- 玩家选择快捷栏
function PlayerHelper.playerSelectShortcut (objid, toobjid, itemid, itemnum)
  local player = PlayerHelper.getPlayer(objid)
  player:holdItem()
  ItemHelper.selectItem(objid, itemid)
  player:choose()
end

-- 玩家快捷栏变化
function PlayerHelper.playerShortcutChange (objid, toobjid, itemid, itemnum)
  local player = PlayerHelper.getPlayer(objid)
  player:holdItem()
end

-- 玩家运动状态改变
function PlayerHelper.playerMotionStateChange (objid, playermotion)
  if playermotion == PLAYERMOTION.WALK then -- 行走
    ActorHelper.resumeClickActor(objid)
  elseif playermotion == PLAYERMOTION.SNEAK then -- 潜行
    if not TalkHelper.talkAround(objid) then -- 附近没有可对话NPC
      ItemHelper.useItem2(objid) -- 使用武器技能
    end
  end
end

-- 玩家移动一格
function PlayerHelper.playerMoveOneBlockSize (objid, toobjid)
  -- body
end

-- 骑乘
function PlayerHelper.playerMountActor (objid, toobjid)
  -- body
end

-- 取消骑乘
function PlayerHelper.playerDismountActor (objid, toobjid)
  -- body
end

-- 聊天输出界面变化
function PlayerHelper.playerInputContent (objid, content)
  -- body
end

-- 输入字符串
function PlayerHelper.playerNewInputContent (objid, content)
  if content == '关闭日志' then
    if LogHelper.level ~= 'no' then -- 日志未关闭
      LogHelper.level = 'no'
      ChatHelper.sendMsg(nil, '关闭日志成功')
    else -- 反之
      ChatHelper.sendMsg(nil, '日志已关闭')
    end
  elseif content == '开启日志' then
    LogHelper.level = 'error'
    ChatHelper.sendMsg(nil, '日志已开启')
  elseif content == '切换日志1' then
    LogHelper.level = 'error'
    ChatHelper.sendMsg(nil, '日志切换为错误级别')
  elseif content == '切换日志2' then
    LogHelper.level = 'info'
    ChatHelper.sendMsg(nil, '日志切换为信息级别')
  elseif content == '切换日志3' then
    LogHelper.level = 'debug'
    ChatHelper.sendMsg(nil, '日志切换为调试级别')
  elseif content == '错误信息' then
    LogHelper.showErrorRecords(objid)
  elseif content == '停止错误信息' then
    LogHelper.stopErrorRecords(objid)
  end
end

-- 按键被按下
function PlayerHelper.playerInputKeyDown (objid, vkey)
  -- body
end

-- 按键处于按下状态
function PlayerHelper.playerInputKeyOnPress (objid, vkey)
  -- body
end

-- 按键松开
function PlayerHelper.playerInputKeyUp (objid, vkey)
  -- body
  -- if vkey == 'SPACE' then
  --   aaa = aaa + 1
  --   if aaa >= 16 then
  --     aaa = 0
  --   end
  --   LogHelper.debug('aaa: ', aaa)
  -- end
end

-- 等级发生变化
function PlayerHelper.playerLevelModelUpgrade (objid, toobjid)
  local player = PlayerHelper.getPlayer(objid)
  local prevLevel = player:getPrevLevel()
  local level = player:getLevel()
  if level then -- 获取到等级信息
    player:upgrade(level - prevLevel)
    -- 升级暂时不再提示
    -- local map = { level = level }
    -- local msg = StringHelper.getTemplateResult(MyTemplate.UPGRADE_MSG, map)
    -- ChatHelper.sendMsg(objid, msg)
  end
  -- body
end

-- 属性变化
function PlayerHelper.playerChangeAttr (objid, playerattr)
  -- body
end

-- 玩家获得状态效果
function PlayerHelper.playerAddBuff (objid, buffid, bufflvl)
  -- 自定义buff处理
  local buff = ActorHelper.getBuff(buffid)
  if buff then
    buff:afterAdd(objid)
  end
  -- body
end

-- 玩家失去状态效果
function PlayerHelper.playerRemoveBuff (objid, buffid, bufflvl)
  -- 自定义buff处理
  local buff = ActorHelper.getBuff(buffid)
  if buff then
    buff:afterRemove(objid)
  end
  -- body
end

-- 封装原始接口

-- 获取玩家昵称
function PlayerHelper.getNickname (objid)
  return CommonHelper.callOneResultMethod(function ()
    return Player:getNickname(objid)
  end, '获取玩家昵称', 'objid=', objid)
end

-- 对玩家显示飘窗文字
function PlayerHelper.notifyGameInfo2Self (objid, info)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:notifyGameInfo2Self(objid, info)
  end, '对玩家显示飘窗文字', 'objid=', objid, ',info=', info)
end

-- 设置玩家道具设置属性
function PlayerHelper.setItemAttAction (objid, itemid, attrtype, switch)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setItemAttAction(objid, itemid, attrtype, switch)
  end, '设置玩家道具设置属性', 'objid=', objid, ',itemid=', itemid, ',attrtype=',
    attrtype, ',switch=', switch)
end

-- 设置玩家位置
function PlayerHelper.setPosition (objid, x, y, z)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setPosition(objid, x, y, z)
  end, '设置玩家位置', 'objid=', objid, ',x=', x, ',y=', y, ',z=', z)
end

-- 获取玩家特殊属性的状态
function PlayerHelper.checkActionAttrState (objid, actionattr)
  return Player:checkActionAttrState(objid, actionattr) == ErrorCode.OK
end

-- 设置玩家行为属性状态
function PlayerHelper.setActionAttrState (objid, actionattr, switch)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setActionAttrState(objid, actionattr, switch)
  end, '设置玩家行为属性状态', 'objid=', objid, ',actionattr=', actionattr,
    ',switch=', switch)
end

-- 旋转玩家镜头
function PlayerHelper.rotateCamera (objid, yaw, pitch)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:rotateCamera(objid, yaw, pitch)
  end, '旋转玩家镜头', 'objid=', objid, ',yaw=', yaw, ',pitch=', pitch)
end

-- 玩家属性获取
function PlayerHelper.getAttr (objid, attrtype)
  return CommonHelper.callOneResultMethod(function ()
    return Player:getAttr(objid, attrtype)
  end, '玩家属性获取', 'objid=', objid, ',attrtype=', attrtype)
end

-- 玩家属性设置
function PlayerHelper.setAttr (objid, attrtype, val)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setAttr(objid, attrtype, val)
  end, '玩家属性设置', 'objid=', objid, ',attrtype=', attrtype, ',val=', val)
end

-- 获取玩家队伍
function PlayerHelper.getTeam (objid)
  return CommonHelper.callOneResultMethod(function ()
    return Player:getTeam(objid)
  end, '获取玩家队伍', 'objid=', objid)
end

-- 设置玩家队伍（数据变了，但是好像没起作用）
function PlayerHelper.setTeam (objid, teamid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setTeam(objid, teamid)
  end, '设置玩家队伍', 'objid=', objid, ',teamid=', teamid)
end

-- 玩家播放动画
function PlayerHelper.playAct (objid, actid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:playAct(objid, actid)
  end, '玩家播放动画', 'objid=', objid, ',actid=', actid)
end

-- 改变玩家视角模式
function PlayerHelper.changeViewMode (objid, viewmode, islock)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:changeViewMode(objid, viewmode, islock)
  end, '改变玩家视角模式', 'objid=', objid, ',viewmode=', viewmode, ',islock=', islock)
end

-- 获取当前所用快捷栏键 0~7
function PlayerHelper.getCurShotcut (objid)
  return CommonHelper.callOneResultMethod(function ()
    return Player:getCurShotcut(objid)
  end, '获取当前所用快捷栏键', 'objid=', objid)
end

-- 获取当前饱食度
function PlayerHelper.getFoodLevel (objid)
  return CommonHelper.callOneResultMethod(function ()
    return Player:getFoodLevel(objid)
  end, '获取当前饱食度', 'objid=', objid)
end

-- 设置玩家饱食度
function PlayerHelper.setFoodLevel (objid, foodLevel)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setFoodLevel(objid, foodLevel)
  end, '设置玩家饱食度', 'objid=', objid, ',foodLevel=', foodLevel)
end

-- 获取玩家当前手持的物品id，空手是0
function PlayerHelper.getCurToolID (objid)
  return CommonHelper.callOneResultMethod(function ()
    return Player:getCurToolID(objid)
  end, '获取玩家当前手持的物品id', 'objid=', objid)
end

-- 设置技能CD，该技能CD为工具原生技能的CD，添加的技能CD与此无关，因此，此方法没什么用
function PlayerHelper.setSkillCD (objid, itemid, cd)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setSkillCD(objid, itemid, cd)
  end, '设置技能CD', 'objid=', objid, ',itemid=', itemid, ',cd=', cd)
end

-- 获取player准星位置
function PlayerHelper.getAimPos (objid)
  return CommonHelper.callThreeResultMethod(function ()
    return Player:getAimPos(objid)
  end, '获取player准星位置', 'objid=', objid)
end

-- 传送玩家到出生点
function PlayerHelper.teleportHome (objid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:teleportHome(objid)
  end, '传送玩家到出生点', 'objid=', objid)
end

-- 使玩家获得游戏胜利
function PlayerHelper.setGameWin (objid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setGameWin(objid)
  end, '使玩家获得游戏胜利', 'objid=', objid)
end

-- 对玩家播放背景音乐
function PlayerHelper.playMusic (objid, musicid, volume, pitch, isLoop)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:playMusic(objid, musicid, volume, pitch, isLoop)
  end, '对玩家播放背景音乐', 'objid=', objid, ',musicid=', musicid, ',volume=',
    volume, ',pitch=', pitch, ',isLoop=', isLoop)
end

-- 停止播放玩家背景音乐
function PlayerHelper.stopMusic (objid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:stopMusic(objid)
  end, '停止播放玩家背景音乐', 'objid=', objid)
end

-- 改变玩家复活点位置
function PlayerHelper.setRevivePoint (objid, x, y, z)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setRevivePoint(objid, x, y, z)
  end, '改变玩家复活点位置', 'objid=', objid, ',x=', x, ',y=', y, ',z=', z)
end

-- 是否是本地玩家
function PlayerHelper.isMainPlayer (objid)
  return Player:isMainPlayer(objid) == ErrorCode.OK
end

-- 获取本地玩家的uin
function PlayerHelper.getMainPlayerUin ()
  return CommonHelper.callOneResultMethod(function ()
    return Player:getMainPlayerUin()
  end, '获取本地玩家的uin')
end

-- 获取玩家比赛结果 0游戏中 1游戏胜利 2游戏结束
function PlayerHelper.getGameResults (objid)
  return CommonHelper.callOneResultMethod(function ()
    return Player:getGameResults(objid)
  end, '获取玩家比赛结果', 'objid=', objid)
end

-- 设置玩家比赛结果 0游戏中 1游戏胜利 2游戏结束
function PlayerHelper.setGameResults (objid, result)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:setGameResults(objid, result)
  end, '设置玩家比赛结果', 'objid=', objid, ',result=', result)
end

function PlayerHelper.openBoxByPos (objid, x, y, z)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:openBoxByPos(objid, x, y, z)
  end, '打开可以操作的箱子', 'objid=', objid, ',x=', x, ',y=', y, ',z=', z)
end

function PlayerHelper.reviveToPos (objid, x, y, z)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:reviveToPos(objid, x, y, z)
  end, '复活玩家到指定点', 'objid=', objid, ',x=', x, ',y=', y, ',z=', z)
end

function PlayerHelper.openUIView (objid, uiid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:openUIView(objid, uiid)
  end, '打开一个UI界面', 'objid=', objid, ',uiid=', uiid)
end

function PlayerHelper.hideUIView (objid, uiid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Player:hideUIView(objid, uiid)
  end, '隐藏一个UI界面', 'objid=', objid, ',uiid=', uiid)
end