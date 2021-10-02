-- 剧情二
Story2 = MyStory:new()

function Story2:new ()
  local data = {
    title = '启程',
    name = '前往学院',
    desc = '先生带着我向学院出发了',
    tips = {
      '终于到了出发的时间了。我好激动。',
      '先生带着我向学院出发了。只是，没想到是要用跑的。',
      '竟然出现了强盗！',
      '这群可恶的强盗，居然要抢我的通行令。没办法了，先消灭他们再说。',
      '可恶的强盗终于被我消灭了。看来我还是很厉害的嘛。',
      '我……我竟然被一伙强盗打败了。还好先生及时赶到。',
      '先生消灭了强盗，好帅呀。',
      '先生要先离开？',
      '先生先离开了。风颖城，我来了。'
    },
    prepose = {
      ['该出发了'] = 1,
      ['跑步去学院'] = 2,
      ['出现强盗'] = 3,
      ['我要消灭强盗'] = 4,
      ['消灭强盗'] = 5,
      ['被强盗击败'] = 6,
      ['先生消灭强盗'] = 7,
      ['先生要离开'] = 8,
      ['临近风颖城'] = 9,
    },
    index = 2,
    yexiaolongInitPosition = {
      { x = 0, y = 7, z = 23 },
      { x = 0, y = 7, z = 20 }
    },
    playerInitPosition = { x = 0, y = 7, z = 16 },
    movePositions1 = { -- 叶小龙奔跑位置
      { x = 0, y = 7, z = 70 },
      { x = 0, y = 7, z = 130 },
      { x = 0, y = 7, z = 190 },
      { x = 0, y = 7, z = 250 },
      { x = 0, y = 7, z = 280 }
    },
    movePositions2 = { -- 玩家奔跑位置
      { x = 0, y = 7, z = 65 },
      { x = 0, y = 7, z = 125 },
      { x = 0, y = 7, z = 185 },
      { x = 0, y = 7, z = 245 },
      { x = 0, y = 7, z = 275 }
    },
    leaveForAWhilePositions = {
      { x = 10, y = 7, z = 280 },
      { x = 34, y = 7, z = 297 }
    },
    eventPositions = {
      { x = 0, y = 7, z = 320 }
    },
    xiaotoumuPositions = {
      { x = 0, y = 7, z = 330 }
    },
    louluoPositions = {
      { x = -2, y = 7, z = 330 },
      { x = 2, y = 7, z = 330 },
      { x = 4, y = 7, z = 330 },
      { x = -4, y = 7, z = 330 },
      { x = 6, y = 7, z = 328 },
      { x = -6, y = 7, z = 328 },
      { x = 8, y = 7, z = 326 },
      { x = -8, y = 7, z = 326 },
      { x = 10, y = 7, z = 324 },
      { x = -10, y = 7, z = 324 }
    },
    xiaotoumus = {},
    xiaolouluos = {},
    killXiaotoumuNum = 0,
    killLouluoNum = 0,
    toCollegePositions = {
      { x = 0, y = 7, z = 359 },
      { x = 0, y = 7, z = 420 },
      { x = -36, y = 7, z = 458 },
      { x = -36, y = 7, z = 500 },
      { x = -6, y = 7, z = 525 },
      { x = -6, y = 7, z = 580 },
      { x = -16, y = 7, z = 600 }
    },
    standard = 1
  }
  self:checkData(data)

  if (StoryHelper.getMainStoryIndex() <= 2) then -- 剧情2
    local areaid = AreaHelper.getAreaByPos(data.eventPositions[1])
    data.areaid = areaid
  end
  self.__index = self
  setmetatable(data, self)
  return data
end

-- 前往学院
function Story2:goToCollege ()
  if (not(yexiaolong) or not(yexiaolong:isFinishInit())) then -- 校验
    TimeHelper.callFnAfterSecond(function ()
      self:goToCollege()
    end, 1)
    StoryHelper.showInitError('goToCollege', '叶小龙')
    return
  end

  PlayerHelper.everyPlayerNotify('约定的时间到了')
  -- 初始化所有人位置
  local idx = 1
  PlayerHelper.everyPlayerDoSomeThing(function (p)
    p:setPosition(story2:getInitPosition(idx, self.playerInitPosition))
    p:wantLookAt(yexiaolong, 2)
    idx = idx + 1
  end)
  yexiaolong:wantMove('goToCollege', { self.yexiaolongInitPosition[2] })
  yexiaolong:setPosition(self.yexiaolongInitPosition[1])
  PlayerHelper.changeVMode()
  PlayerHelper.everyPlayerEnableMove(false)
  -- 说话
  local ws = WaitSeconds:new(2)
  local hostPlayer = PlayerHelper.getHostPlayer()
  local playerNum = #PlayerHelper.getActivePlayers()
  if (playerNum == 1) then
    yexiaolong:speak(ws:get(), '不错，你准时到了。那我们出发吧。')
  else
    yexiaolong:speak(ws:get(), '不错，所有人都到齐了。那我们出发吧。')
  end
  yexiaolong.action:playHi(ws:get())
  TimeHelper.callFnAfterSecond(function ()
    yexiaolong:wantLookAt('goToCollege', hostPlayer.objid, 3)
  end, ws:use(3))
  PlayerHelper.everyPlayerSpeak(ws:get(), '出发咯!')
  PlayerHelper.everyPlayerDoSomeThing(function (p)
    p.action:playHappy()
  end, ws:use())
  hostPlayer:speak(ws:use(3), '不过，先生，我们的马车在哪里？')
  yexiaolong:speak(ws:get(), '嗯，这个嘛……')
  yexiaolong.action:playThink(ws:use())
  yexiaolong:thinks(ws:use(3), '没想到村里的东西这么好吃。一不小心把盘缠给花光了……')
  yexiaolong:speak(ws:get(), '咳咳。还没有进入学院，就想着这些会让人懒惰的工具。这怎么能成？')
  yexiaolong.action:playFree2(ws:use(3))
  yexiaolong:speak(ws:get(), '去学院学习可不是享福的。基本功不能落下。现在，让我们跑起来。出发！')
  TimeHelper.callFnAfterSecond (function (p)
    ActorHelper.addBuff(yexiaolong.objid, ActorHelper.BUFF.FASTER_RUN, 4, 6000)
    yexiaolong:wantMove('goToCollege', self.movePositions1, nil, nil, nil, 600)
  end, ws:use(1))
  PlayerHelper.everyPlayerSpeak(ws:get(), '！！！')
  PlayerHelper.everyPlayerDoSomeThing(function (p)
    p.action:playDown()
  end, ws:use(2))
  if (#PlayerHelper.getActivePlayers() > 1) then
    PlayerHelper.everyPlayerSpeak(ws:use(1), '先生，等等我们。')
  else
    PlayerHelper.everyPlayerSpeak(ws:use(1), '先生，等等我。')
  end

  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:enableMove(true, true) -- 玩家可以行动
    if (PlayerHelper.isMainPlayer(player.objid)) then
      player.action:runTo(self.movePositions2, function ()
        self:teacherLeaveForAWhile(player)
      end)
    else
      player.action:runTo(self.movePositions2)
    end
    ActorHelper.addBuff(player.objid, ActorHelper.BUFF.FASTER_RUN, 4, 6000)
  end, ws:get())

  TimeHelper.callFnAfterSecond(function (p)
    StoryHelper.forward(2, '该出发了')
  end, ws:use(10))

  PlayerHelper.everyPlayerSpeakToSelf(ws:use(10), '呼呼。先生跑得真快。')

  PlayerHelper.everyPlayerSpeakToSelf(ws:get(), '呼呼。这条路真长啊。不知道还要跑多久。')
end

-- 先生暂时离开
function Story2:teacherLeaveForAWhile (player)
  player:speak(0, '先生，这是快要到了吗？')
  PlayerHelper.everyPlayerEnableMove(false)

  local ws = WaitSeconds:new()
  player.action:playThink(ws:use())
  yexiaolong:speak(ws:use(), '……')
  player:speak(ws:use(), '先生？')
  yexiaolong:speak(ws:use(), '……')
  TimeHelper.callFnAfterSecond(function (p)
    yexiaolong:setFaceYaw(ActorHelper.FACE_YAW.SOUTH)
    local playerNum = #PlayerHelper.getActivePlayers()
    if (playerNum == 1) then
      yexiaolong:speak(0, '人有三急，你先行一步，我去去就来。')
    else
      yexiaolong:speak(0, '人有三急，你们先行，我去去就来。')
    end
  end, ws:use(1))
  player:speak(ws:get(), '好的。')
  player.action:playFree2(ws:use(1))
  TimeHelper.callFnAfterSecond(function (p)
    yexiaolong:wantMove('leaveForAWhile', self.leaveForAWhilePositions)
  end, ws:use())

  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:enableMove(true, true) -- 玩家可以行动
    if (PlayerHelper.isMainPlayer(player.objid)) then
      player.action:runTo(self.eventPositions, function ()
        self:meetBandits()
      end)
    else
      player.action:runTo(self.eventPositions)
    end
  end, ws:use(3))

  PlayerHelper.everyPlayerThinkToSelf(ws:get(), '这里的树木好茂密啊！')
end

-- 遭遇强盗
function Story2:meetBandits ()
  local hostPlayer = PlayerHelper.getHostPlayer()
  if (StoryHelper.forward(2, '跑步去学院')) then
    story2:initQiangdao()
  else
    if (not(story2:initQiangdao(true))) then
      TimeHelper.callFnFastRuns(function ()
        self:meetBandits()
      end, 0.1)
      return false
    end
  end
  local xiaotoumuId = qiangdaoXiaotoumu.monsters[1]
  local xiaolouluoId = qiangdaoLouluo.monsters[1]

  local ws = WaitSeconds:new(1)
  TimeHelper.callFnAfterSecond(function (p)
    PlayerHelper.everyPlayerEnableMove(false)
    qiangdaoXiaotoumu:lookAt(hostPlayer.objid)
    qiangdaoLouluo:lookAt(hostPlayer.objid)
  end, ws:get())
  PlayerHelper.everyPlayerSpeak(ws:use(), '！！！')
  qiangdaoXiaotoumu:speak(ws:get(), '此树乃吾栽，此路亦吾开。欲从此路过，留下……')
  MonsterHelper.playAct(xiaotoumuId, ActorHelper.ACT.ATTACK, ws:use())
  qiangdaoXiaotoumu:thinks(ws:get(), '又是穷鬼，真伤脑筋……')
  MonsterHelper.playAct(xiaotoumuId, ActorHelper.ACT.THINK, ws:use())
  qiangdaoLouluo:speak(ws:get(), '买路财，老大。')
  TimeHelper.callFnAfterSecond(function ()
    ActorHelper.lookAt(xiaolouluoId, xiaotoumuId)
  end, ws:use())
  qiangdaoXiaotoumu:speak(ws:get(), '你个笨蛋，山野村民，身上能有什么财。')
  TimeHelper.callFnAfterSecond(function ()
    ActorHelper.lookAt(xiaotoumuId, xiaolouluoId)
    MonsterHelper.playAct(xiaotoumuId, ActorHelper.ACT.ANGRY)
  end, ws:use(3))
  qiangdaoXiaotoumu:speak(ws:get(), '不过，这是去往风颖城的道路。如果没有通行令，可是进不了城的。')
  MonsterHelper.playAct(xiaotoumuId, ActorHelper.ACT.FREE2, ws:use(3))
  qiangdaoXiaotoumu:speak(ws:use(), '如果我们有了通行令，找个机会混进城抢几个城里的大户……')
  qiangdaoLouluo:speak(ws:get(), '高啊，老大。')
  MonsterHelper.playAct(xiaolouluoId, ActorHelper.ACT.HAPPY, ws:use())
  qiangdaoLouluo:speak(ws:get(), '小子，留下令牌来。')
  TimeHelper.callFnAfterSecond(function ()
    ActorHelper.lookAt(xiaolouluoId, hostPlayer.objid)
    ActorHelper.lookAt(xiaotoumuId, hostPlayer.objid)
    MonsterHelper.playAct(xiaolouluoId, ActorHelper.ACT.ATTACK)
  end, ws:use())
  hostPlayer:thinks(ws:use(), '看样子只能拼了。')
  hostPlayer:speak(ws:get(), '想要你们就来拿吧！')
  hostPlayer.action:playAngry(ws:use())
  qiangdaoXiaotoumu:speak(ws:use(1), '看来是遇到不要命的了。大伙们一起上。')
  MonsterHelper.playAct(xiaotoumuId, ActorHelper.ACT.ATTACK, ws:use(1))
  TimeHelper.callFnAfterSecond(function (p)
    PlayerHelper.changeVMode(nil, VIEWPORTTYPE.MAINVIEW)
    PlayerHelper.everyPlayerNotify('注意，你不能离此地过远')
    StoryHelper.forward(2, '出现强盗')
    qiangdaoXiaotoumu:setAIActive(true)
    qiangdaoLouluo:setAIActive(true)
    PlayerHelper.everyPlayerDoSomeThing (function (p)
      PlayerHelper.setPlayerEnableBeKilled(p.objid, false)
    end)
    PlayerHelper.everyPlayerEnableMove(true)
  end, ws:get())
end

-- 消灭强盗
function Story2:wipeOutQiangdao ()
  if (not(yexiaolong) or not(yexiaolong:isFinishInit())) then -- 校验
    TimeHelper.callFnAfterSecond(function ()
      self:wipeOutQiangdao()
    end, 1)
    StoryHelper.showInitError('wipeOutQiangdao', '叶小龙')
    return
  end

  local hostPlayer = PlayerHelper.getHostPlayer()
  StoryHelper.forward(2, '我要消灭强盗')
  PlayerHelper.everyPlayerEnableMove(false)
  yexiaolong:thinks(0, '算算时间，应该清理得差不多了。去看看怎么样了。')
  local ws = WaitSeconds:new(2)
  TimeHelper.callFnAfterSecond(function ()
    local pos = story2:getAirPosition()
    yexiaolong:setPosition(pos)
    yexiaolong:wantLookAt(nil, hostPlayer.objid, 3)
    yexiaolong.action:playFree(1)
  end, ws:use(1))
  PlayerHelper.everyPlayerDoSomeThing (function (p)
    p:wantLookAt(yexiaolong.objid, 3)
  end, ws:use(1))
  yexiaolong:speak(ws:use(2), '不错。')
  hostPlayer:speak(ws:get(), '先生，我消灭了这些可恶的强盗耶。你也觉得我不错吧。')
  hostPlayer.action:playHappy(ws:use())
  yexiaolong:speak(ws:use(), '这些强盗挺不错的。')
  hostPlayer:speak(ws:get(), '！！！')
  hostPlayer.action:playDown(ws:use())
  yexiaolong:speak(ws:use(3), '起先我还在思量，如果考验只是杀几条狼，那岂不是就招了几个猎户回去嘛。')
  yexiaolong:speak(ws:use(3), '如此，回去之后定又会被小高嘲笑。不错不错。')
  yexiaolong:speak(ws:get(), '现在嘛……惩奸除恶的少年侠士。快哉。')
  yexiaolong.action:playHappy(ws:use(3))
  local playerNum = #PlayerHelper.getActivePlayers()
  if (playerNum == 1) then
    yexiaolong:speak(ws:get(), '对了，我这里恰好有把小剑，挺适合你现在用的。就给你好了。')
  else
    yexiaolong:speak(ws:get(), '对了，我这里恰好有几把小剑，挺适合你们现在用的。就给你们好了。')
  end
  PlayerHelper.everyPlayerDoSomeThing (function (p)
    BackpackHelper.addItem(p.objid, MyWeaponAttr.bronzeSword.levelIds[1], 1) -- 青铜剑
    if (p == hostPlayer) then
      StoryHelper.forward(2, '消灭强盗', '先生消灭强盗')
      self:endWords(hostPlayer)
    end
  end, ws:get())
end

-- 结束语
function Story2:endWords (player)
  if (not(yexiaolong) or not(yexiaolong:isFinishInit())) then -- 校验
    TimeHelper.callFnAfterSecond(function ()
      self:endWords(player)
    end, 1)
    StoryHelper.showInitError('endWords', '叶小龙')
    return
  end

  local ws = WaitSeconds:new(3)
  yexiaolong:speak(ws:use(3), '前面不远就是风颖城了。通行令牌已经给你，你出示令牌就可以进城了。')
  yexiaolong:speak(ws:use(3), '进城后你可以先四处逛逛。记得来学院报到。学院在东北方。')
  player:speak(ws:get(), '先生，我们不一起进城吗？')
  player.action:playThink(ws:use())
  if (self.standard == 1) then
    yexiaolong:speak(ws:use(), '不了，我已经迫不及待想瞧瞧小高招的新学员了。我去也。')
  else
    yexiaolong:speak(ws:use(), '不了，你身上有伤，不易快行。我还有事，要先行一步。我去也。')
  end
  TimeHelper.callFnAfterSecond(function ()
    yexiaolong:wantMove('goToCollege', self.toCollegePositions)
    PlayerHelper.everyPlayerSpeak(1, '先生慢行。')
    PlayerHelper.everyPlayerDoSomeThing(function (p)
      p.action:playFree2()
    end)
  end, ws:use())
  PlayerHelper.everyPlayerThinkToSelf(ws:get(), '先生又离开了。不会又发生什么吧。不知道风颖城是什么样子的。好期待。')
  PlayerHelper.everyPlayerEnableMove(true, ws:get())

  TimeHelper.callFnAfterSecond(function ()
    StoryHelper.forward(2, '先生要离开')
    PlayerHelper.changeVMode(nil, VIEWPORTTYPE.MAINVIEW)
    PlayerHelper.everyPlayerDoSomeThing (function (p)
      PlayerHelper.setPlayerEnableBeKilled(p.objid, true)
    end)
    -- ChatHelper.sendSystemMsg('时间有限，作者剧情就做到这里了。游戏结束标志没有设置。风颖城也还没有做完。主要把落叶村人物的作息完成了。后面的内容，作者会继续更新。希望你们喜欢，谢谢。')
    -- ChatHelper.sendSystemMsg('#G目前剧情到此。')
  end, ws:get())
end

-- 玩家受到重伤
function Story2:playerBadHurt (objid)
  if (self.standard == 2) then
    return
  end
  if (not(yexiaolong) or not(yexiaolong:isFinishInit())) then -- 校验
    TimeHelper.callFnAfterSecond(function ()
      self:playerBadHurt(objid)
    end, 1)
    StoryHelper.showInitError('playerBadHurt', '叶小龙')
    return
  end

  self.standard = 2
  StoryHelper.forward(2, '我要消灭强盗', '消灭强盗')
  local player = PlayerHelper.getPlayer(objid)
  PlayerHelper.changeVMode()
  player:enableBeAttacked(false)
  player:enableMove(false, '剧情中')
  local ws = WaitSeconds:new()
  yexiaolong:thinks(ws:use(), '果然还是太勉强了吗？')
  TimeHelper.callFnAfterSecond(function ()
    yexiaolong:speak(0, '住手！')
    for i, v in ipairs(self.xiaotoumus) do
      if (not(v.killed)) then
        CreatureHelper.stopRun(v.objid)
        if (i == 1) then
          qiangdaoXiaotoumu:speak(1, '！！！')
        end
        TimeHelper.callFnAfterSecond(function ()
          ActorHelper.lookAt(v.objid, yexiaolong.objid)
        end, 2)
      end
    end
    for i, v in ipairs(self.xiaolouluos) do
      if (not(v.killed)) then
        CreatureHelper.stopRun(v.objid)
        if (i == 1) then
          qiangdaoLouluo:speak(1, '！！！')
        end
        TimeHelper.callFnAfterSecond(function ()
          ActorHelper.lookAt(v.objid, yexiaolong.objid)
        end, 2)
      end
    end
  end, ws:use(1))
  local playerPos = player:getMyPosition()
  local areaid = AreaHelper.createAreaRect(playerPos, { x = 4, y = 2, z = 4 })
  local ids = AreaHelper.getAllCreaturesInAreaId(areaid)
  TimeHelper.callFnAfterSecond(function ()
    local pos = player:getDistancePosition(1.5)
    yexiaolong:setPosition(pos)
    yexiaolong.action:playFree2()
    WorldHelper.playRepelEffect(pos)
    for i, v in ipairs(ids) do
      local dstPos = ActorHelper.getMyPosition(v)
      ActorHelper.appendFixedSpeed(v, 2, pos, dstPos)
      WorldHelper.playAttackEffect(dstPos)
    end
    -- TimeHelper.callFnAfterSecond(function ()
    --   WorldHelper.stopRepelEffect(pos)
    -- end, ws:get() + 2)
  end, ws:use())
  TimeHelper.callFnAfterSecond(function ()
    local num = #PlayerHelper.getActivePlayers() * 2
    yexiaolong:speak(0, '这里有', num, '粒生血丹。剩下的交给我吧。')
    BackpackHelper.addItem(player.objid, MyMap.ITEM.CREATE_BLOOD_PILL_ID, num) -- 生血丹
    yexiaolong:lookAt(player.objid)
    StoryHelper.forward(2, '被强盗击败')
    -- player:lookAt(yexiaolong.objid)
  end, ws:use())
  TimeHelper.callFnAfterSecond(function ()
    self:yexiaolongWipeOutQiangdao(player)
  end, ws:get())
end

-- 叶小龙灭强盗
function Story2:yexiaolongWipeOutQiangdao (player)
  self.standard = 2
  player = player or PlayerHelper.getHostPlayer()
  local monsters = {}
  for i, v in ipairs(self.xiaotoumus) do
    if (not(v.killed)) then
      local mPos = MyPosition:new(ActorHelper.getPosition(v.objid))
      table.insert(monsters, { v.objid, WorldHelper.calcDistance(playerPos, mPos) })
    end
  end
  for i, v in ipairs(self.xiaolouluos) do
    if (not(v.killed)) then
      local mPos = MyPosition:new(ActorHelper.getPosition(v.objid))
      table.insert(monsters, { v.objid, WorldHelper.calcDistance(playerPos, mPos) })
    end
  end
  if (#monsters > 0) then
    table.sort(monsters, function (a, b)
      return a[2] > b[2]
    end)
    local wss = WaitSeconds:new()
    for i, v in ipairs(monsters) do
      TimeHelper.callFnAfterSecond(function ()
        local pos = ActorHelper.getDistancePosition(v[1], -1.5)
        yexiaolong:setPosition(pos)
        yexiaolong:lookAt(v[1])
        ActorHelper.lookAt(v[1], yexiaolong.objid)
        local attackPos = ActorHelper.getDistancePosition(v[1], -1)
        WorldHelper.playAttackEffect(attackPos)
        WorldHelper.playBeAttackedSoundOnPos(attackPos)
        local dstPos = ActorHelper.getMyPosition(v[1])
        ActorHelper.appendFixedSpeed(v[1], 2, pos, dstPos)
        local actorid = CreatureHelper.getActorID(v[1])
        if (actorid == MyMap.ACTOR.QIANGDAO_LOULUO_ACTOR_ID) then
          qiangdaoLouluo:speak(0, '啊！')
        else
          qiangdaoXiaotoumu:speak(0, '啊！')
        end
        -- yexiaolong.action:playAttack()
        TimeHelper.callFnFastRuns(function ()
          ActorHelper.killSelf(v[1])
        end, 0.3)
        TimeHelper.callFnAfterSecond(function ()
          WorldHelper.stopAttackEffect(attackPos)
        end, 2)
      end, wss:use(1))
    end

    wss:use(1)
    yexiaolong:speak(wss:get(), '高手，就是这么寂寞。')
    yexiaolong.action:playHappy(wss:use())

    local idx = 1
    PlayerHelper.everyPlayerDoSomeThing(function (p)
      local pos = yexiaolong:getDistancePosition(idx + 1.5)
      p:setPosition(pos)
      p:wantLookAt(yexiaolong, 2)
      if (p ~= player) then
        p:enableMove(false, '剧情中')
      end
      idx = idx + 1
    end, wss:use(1))
    player:speak(wss:use(), '先生，你好厉害。')
    yexiaolong:thinks(wss:use(), '不是我厉害，而是你太菜。')
    TimeHelper.callFnAfterSecond(function ()
      yexiaolong:lookAt(player.objid)
      yexiaolong:speak(0, '不错，这么快就又能动弹了。')
      StoryHelper.forward(2, '先生消灭强盗')
      self:endWords(player)
    end, wss:get())
  end
end

-- 初始化所有强盗
function Story2:initQiangdao (notFirst)
  if (notFirst) then -- 再次初始化
    if (not(self.initQiangdaoTimes)) then -- 初始化强盗次数
      self.initQiangdaoTimes = 1
    else
      self.initQiangdaoTimes = self.initQiangdaoTimes + 1
    end
    local areaid = AreaHelper.getAreaByPos(self.eventPositions[1])
    local objids = AreaHelper.getAllCreaturesInAreaId(areaid)
    local monsters1, monsters2 = {}, {}
    if (objids and #objids > 0) then
      LogHelper.debug('总数：', #objids)
      for i, objid in ipairs(objids) do
        local actorid = CreatureHelper.getActorID(objid)
        if (actorid == qiangdaoLouluo.actorid) then
          table.insert(monsters2, objid)
        elseif (actorid == qiangdaoXiaotoumu.actorid) then
          table.insert(monsters1, objid)
        end
      end
    end
    if (#monsters1 ~= #qiangdaoXiaotoumu.monsters) then -- 数量不等，则重新赋值小头目
      qiangdaoXiaotoumu.monsters = monsters1
    end
    if (#monsters2 ~= #qiangdaoXiaotoumu.monsters) then -- 数量不等，则重新赋值喽罗
      qiangdaoLouluo.monsters = monsters2
    end
    LogHelper.debug('小头目：', #qiangdaoXiaotoumu.monsters, ',喽罗：', #qiangdaoLouluo.monsters)
    local mainProgress = StoryHelper.getMainStoryProgress()
    if (mainProgress == 3) then -- 相遇
      qiangdaoXiaotoumu:setAIActive(false)
      qiangdaoLouluo:setAIActive(false)
      if (#qiangdaoXiaotoumu.monsters + #qiangdaoLouluo.monsters < 11) then -- 未找到所有强盗
        return false
      end
      qiangdaoXiaotoumu:setPositions(story2.xiaotoumuPositions)
      qiangdaoLouluo:setPositions(story2.louluoPositions)
    elseif (mainProgress == 4) then -- 开打
      if (self.initQiangdaoTimes < 20) then
        return false
      end
    elseif (mainProgress == 6 or mainProgress == 7) then -- 被打败/叶小龙打强盗
      qiangdaoXiaotoumu:setAIActive(false)
      qiangdaoLouluo:setAIActive(false)
      if (self.initQiangdaoTimes < 20) then
        return false
      end
    end
  else -- 第一次初始化
    qiangdaoXiaotoumu:initStoryMonsters()
    qiangdaoLouluo:initStoryMonsters()
    qiangdaoXiaotoumu:setAIActive(false)
    qiangdaoLouluo:setAIActive(false)
    qiangdaoXiaotoumu:setPositions(story2.xiaotoumuPositions)
    qiangdaoLouluo:setPositions(story2.louluoPositions)
  end
  for i, objid in ipairs(qiangdaoXiaotoumu.monsters) do
    table.insert(story2.xiaotoumus, { objid = objid, killed = false })
  end
  for i, objid in ipairs(qiangdaoLouluo.monsters) do
    table.insert(story2.xiaolouluos, { objid = objid, killed = false })
  end
  return true
end

-- 初始化位置
function Story2:getInitPosition (index, myPosition)
  local pos = MyPosition:new(myPosition)
  if (index > 1) then
    local temp = math.floor(index / 2)
    if (math.mod(index, 2) == 0) then
      temp = temp * -1
    end
    pos.x = pos.x + temp
  end
  return pos
end

-- 取得空气位置
function Story2:getAirPosition ()
  local hostPlayer = PlayerHelper.getHostPlayer()
  local pos = MyPosition:new(hostPlayer:getPosition())
  local pos2 = MyPosition:new(hostPlayer:getPosition())
  for i = 6, 1, -1 do
    pos.x = pos.x + i
    pos2.x = pos2.x + i + 1
    if (AreaHelper.isAirArea(pos) and AreaHelper.isAirArea(pos2)) then
      return pos, pos2
    else
      pos.x = pos.x - i
      pos2.x = pos2.x - i - 1
    end
    pos.z = pos.z + i
    pos2.z = pos2.z + i + 1
    if (AreaHelper.isAirArea(pos) and AreaHelper.isAirArea(pos2)) then
      return pos, pos2
    else
      pos.z = pos.z - i
      pos2.z = pos2.z - i - 1
    end
  end
  return pos, pos2
end

-- 显示剩余强盗数
function Story2:showMessage (objid)
  local actorid = CreatureHelper.getActorID(objid)
  TimeHelper.callFnAfterSecond(function ()
    local story2 = StoryHelper.getStory(2)
    local isRight = false -- 是否有强盗被击杀
    if (qiangdaoLouluo.actorid == actorid) then
      for i, v in ipairs(story2.xiaolouluos) do
        if (v.objid == objid) then
          v.killed = true
          break
        end
      end
      story2.killLouluoNum = story2.killLouluoNum + 1
      isRight = true
    elseif (qiangdaoXiaotoumu.actorid == actorid) then
      for i, v in ipairs(story2.xiaotoumus) do
        if (v.objid == objid) then
          v.killed = true
          break
        end
      end
      story2.killXiaotoumuNum = story2.killXiaotoumuNum + 1
      isRight = true
      if (story2.killXiaotoumuNum > 0) then
        TimeHelper.callFnAfterSecond(function ()
          story2:killXiaotoumuEvent()
        end, 1)
      end
    end
    if (isRight) then
      local remainXiaolouluoNum = #story2.xiaolouluos - story2.killLouluoNum
      local remainXiaotoumuNum = #story2.xiaotoumus - story2.killXiaotoumuNum
      if (remainXiaotoumuNum + remainXiaolouluoNum > 0) then
        local msg = '强盗剩余喽罗数：' .. remainXiaolouluoNum .. '，剩余小头目数：' .. remainXiaotoumuNum
        ChatHelper.sendSystemMsg(msg)
      else
        ChatHelper.sendSystemMsg('消灭所有强盗。')
        if (story2.standard == 1) then
          story2:wipeOutQiangdao()
        end
      end
    end
  end, 1)
end

-- 生物跑出范围圈让他回来
function Story2:comeBack (objid, areaid)
  local pos = MyPosition:new(ActorHelper.getPosition(objid))
  local x, y, z = 0, 0, 0
  if (pos.x < -29) then
    pos.x = -26
    x = 1
  elseif (pos.x > 27) then
    pos.x = 24
    x = -1
  end
  if (pos.z < 298) then
    pos.z = 301
    z = 1
  elseif (pos.z > 359) then
    pos.z = 356
    z = -1
  end
  ActorHelper.appendSpeed(objid, x, y, z)
  if (ActorHelper.isPlayer(objid)) then -- 玩家
    PlayerHelper.showToast(objid, '你不能跑得太远')
    -- local player = PlayerHelper.getPlayer(objid)
    -- PlayerHelper.setPosition(objid, pos.x, pos.y, pos.z)
    local player = PlayerHelper.getPlayer(objid)
    player.action:runTo({ pos })
  else -- 强盗
    ActorHelper.tryNavigationToPos(objid, pos.x, pos.y, pos.z, false)
  end
end

-- 干掉了强盗小头目事件
function Story2:killXiaotoumuEvent ()
  local story2 = StoryHelper.getStory(2)
  if (story2.standard == 1 and story2.killLouluoNum < #story2.xiaolouluos) then -- 还有喽罗
    qiangdaoLouluo:speak(0, '他杀了老大！干掉他！')
    for i, v in ipairs(story2.xiaolouluos) do
      if (not(v.killed)) then
        CreatureHelper.setAIActive(v.objid, false)
      end
    end
    TimeHelper.callFnAfterSecond(function ()
      for i, v in ipairs(story2.xiaolouluos) do
        if (not(v.killed)) then
          CreatureHelper.setAIActive(v.objid, true)
          ActorHelper.addBuff(v.objid, 17, 3, 6000) -- 强力攻击3级
        end
      end
    end, 1)
  end
end

function Story2:recover (player)
  local mainProgress = StoryHelper.getMainStoryProgress()
  TaskHelper.addStoryTask(player.objid)
  if (mainProgress == 1 or mainProgress == 2) then -- 村口集合
    if (player:isHostPlayer()) then
      story2:goToCollege()
    else
      player:setMyPosition(hostPlayer:getMyPosition())
    end
  elseif (mainProgress == 3) then -- 路遇强盗
    story2:meetBandits()
    PlayerHelper.setPlayerEnableBeKilled(player.objid, false) -- 不能被杀死
    if (not(AreaHelper.objInArea(story2.areaid, player.objid))) then -- 不在区域内则移动到区域内
      player:setMyPosition(story2.eventPositions[1])
    end
  elseif (mainProgress == 4) then -- 开打
    PlayerHelper.setPlayerEnableBeKilled(player.objid, false) -- 不能被杀死
    if (not(story2:initQiangdao(true))) then
      TimeHelper.callFnFastRuns(function ()
        self:recover(player)
      end, 0.1)
      return
    end
    if (not(AreaHelper.objInArea(story2.areaid, player.objid))) then -- 不在区域内则移动到区域内
      player:setMyPosition(story2.eventPositions[1])
    end
  elseif (mainProgress == 5) then -- 消灭了强盗
    PlayerHelper.setPlayerEnableBeKilled(player.objid, true) -- 能被杀死
    if (not(AreaHelper.objInArea(story2.areaid, player.objid))) then -- 不在区域内则移动到区域内
      player:setMyPosition(story2.eventPositions[1])
    end
    if (player:isHostPlayer()) then
      story2:wipeOutQiangdao()
    end
  elseif (mainProgress == 6) then -- 被强盗打败
    PlayerHelper.setPlayerEnableBeKilled(player.objid, false) -- 不能被杀死
    if (not(story2:initQiangdao(true))) then
      TimeHelper.callFnFastRuns(function ()
        self:recover(player)
      end, 0.1)
      return
    end
    if (player:isHostPlayer()) then
      story2:playerBadHurt(player.objid)
    end
  elseif (mainProgress == 7) then -- 先生赐了药，就去灭强盗
    PlayerHelper.setPlayerEnableBeKilled(player.objid, false) -- 不能被杀死
    if (not(story2:initQiangdao(true))) then
      TimeHelper.callFnFastRuns(function ()
        self:recover(player)
      end, 0.1)
      return
    end
    if (player:isHostPlayer()) then
      story2:yexiaolongWipeOutQiangdao()
    end
  elseif (mainProgress == 8) then -- 先生要先离开？
    PlayerHelper.setPlayerEnableBeKilled(player.objid, true) -- 能被杀死
    player:enableBeAttacked(true) -- 能被攻击
    if (player:isHostPlayer()) then
      story2:endWords(player)
    end
  elseif (mainProgress == #self.tips) then -- 先生离开
    PlayerHelper.setPlayerEnableBeKilled(player.objid, true) -- 能被杀死
    player:enableBeAttacked(true) -- 能被攻击
    -- 剧情二结束
  end
end

function Story2:getProgressPrepose (name)
  return self.prepose[name]
end
