-- 剧情二
Story2 = MyStory:new()

function Story2:init ()
  local data = {
    title = '启程',
    name = '前往学院',
    desc = '先生带着我向学院出发了',
    tips = {
      '终于到了出发的时间了。我好激动。',
      '先生带着我向学院出发了。只是，没想到是要用跑的。',
      '这群可恶的强盗，居然要抢我的通行令。没办法了，先消灭他们再说。',
      '可恶的强盗终于被我消灭了。看来我还是很厉害的嘛。',
      '#G目前剧情到此。'
      -- '先生先离开了。风颖城，我来了。'
    },
    yexiaolongInitPosition = {
      { x = 0, y = 7, z = 23 },
      { x = 0, y = 7, z = 20 }
    },
    playerInitPosition = { x = 0, y = 7, z = 16 },
    movePositions1 = {
      { x = 0, y = 7, z = 70 },
      { x = 0, y = 7, z = 130 },
      { x = 0, y = 7, z = 190 },
      { x = 0, y = 7, z = 250 },
      { x = 0, y = 7, z = 280 }
    },
    movePositions2 = {
      { x = 0, y = 7, z = 65 },
      { x = 0, y = 7, z = 125 },
      { x = 0, y = 7, z = 185 },
      { x = 0, y = 7, z = 245 },
      { x = 0, y = 7, z = 275 }
    },
    leaveForAWhilePositions = {
      { x = 10, y = 7, z = 280 },
      { x = 24, y = 7, z = 230 }
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
  self:setData(data)

  if (MyStoryHelper:getMainStoryIndex() <= 2) then -- 剧情2
    local areaid = AreaHelper:getAreaByPos(data.eventPositions[1])
    data.areaid = areaid
  end
  return data
end

-- 前往学院
function Story2:goToCollege ()
  local story2 = MyStoryHelper:getStory(2)
  MyPlayerHelper:everyPlayerNotify('约定的时间到了')
  -- 初始化所有人位置
  local idx = 1
  MyPlayerHelper:everyPlayerDoSomeThing(function (p)
    p:setPosition(self:getInitPosition(idx, story2.playerInitPosition))
    p:wantLookAt(yexiaolong, 2)
    idx = idx + 1
  end)
  yexiaolong:wantMove('goToCollege', { story2.yexiaolongInitPosition[2] })
  yexiaolong:setPosition(story2.yexiaolongInitPosition[1])
  MyPlayerHelper:changeViewMode()
  MyPlayerHelper:everyPlayerEnableMove(false)
  -- 说话
  local waitSeconds = 2
  local hostPlayer = MyPlayerHelper:getHostPlayer()
  local playerNum = #MyPlayerHelper:getAllPlayers()
  if (playerNum == 1) then
    yexiaolong:speak(waitSeconds, '不错，你准时到了。那我们出发吧。')
  else
    yexiaolong:speak(waitSeconds, '不错，所有人都到齐了。那我们出发吧。')
  end
  yexiaolong.action:playHi(waitSeconds)
  MyTimeHelper:callFnAfterSecond(function ()
    yexiaolong:wantLookAt('goToCollege', hostPlayer.objid, 3)
  end, waitSeconds)

  waitSeconds = waitSeconds + 3
  MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(waitSeconds, '出发咯!')
  MyPlayerHelper:everyPlayerDoSomeThing(function (p)
    p.action:playHappy()
  end, waitSeconds)

  waitSeconds = waitSeconds + 2
  hostPlayer:speak(waitSeconds, '不过，先生，我们的马车在哪里？')

  waitSeconds = waitSeconds + 3
  yexiaolong:speak(waitSeconds, '嗯，这个嘛……')
  yexiaolong.action:playThink(waitSeconds)

  waitSeconds = waitSeconds + 2
  yexiaolong:thinks(waitSeconds, '没想到村里的东西这么好吃。一不小心把盘缠给花光了……')

  waitSeconds = waitSeconds + 3
  yexiaolong:speak(waitSeconds, '咳咳。还没有进入学院，就想着这些会让人懒惰的工具。这怎么能成？')
  yexiaolong.action:playFree2(waitSeconds)

  waitSeconds = waitSeconds + 3
  yexiaolong:speak(waitSeconds, '去学院学习可不是享福的。基本功不能落下。现在，让我们跑起来。出发！')

  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond (function (p)
    ActorHelper:addBuff(yexiaolong.objid, ActorHelper.BUFF.FASTER_RUN, 4, 6000)
    yexiaolong:wantMove('goToCollege', p.story2.movePositions1)
  end, waitSeconds, { story2 = story2 })

  waitSeconds = waitSeconds + 1
  MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(waitSeconds, '！！！')
  MyPlayerHelper:everyPlayerDoSomeThing(function (p)
    p.action:playDown()
  end, waitSeconds)

  waitSeconds = waitSeconds + 2
  if (#MyPlayerHelper:getAllPlayers() > 1) then
    MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(waitSeconds, '先生，等等我们。')
  else
    MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(waitSeconds, '先生，等等我。')
  end

  waitSeconds = waitSeconds + 1
  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(true) -- 玩家可以行动
    for i, v in ipairs(MyPlayerHelper:getAllPlayers()) do
      if (i == 1) then
        v.action:runTo(p.story2.movePositions2, function (v)
          Story2:teacherLeaveForAWhile(v)
        end, v)
      else
        v.action:runTo(p.story2.movePositions2)
      end
    end
    MyPlayerHelper:everyPlayerAddBuff(ActorHelper.BUFF.FASTER_RUN, 4, 6000)
  end, waitSeconds, { story2 = story2 })
  MyTimeHelper:callFnAfterSecond(function (p)
    MyStoryHelper:forward('跑步去学院')
  end, waitSeconds)

  waitSeconds = waitSeconds + 10
  MyPlayerHelper:everyPlayerSpeakAfterSecond(waitSeconds, '呼呼。先生跑得真快。')

  waitSeconds = waitSeconds + 10
  MyPlayerHelper:everyPlayerSpeakAfterSecond(waitSeconds, '呼呼。这条路真长啊。不知道还要跑多久。')
end

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

-- 先生暂时离开
function Story2:teacherLeaveForAWhile (myPlayer)
  local story2 = MyStoryHelper:getStory(2)
  myPlayer:speak(0, '先生，要到了吗？')

  local waitSeconds = 2
  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(false)
  end, waitSeconds)
  myPlayer.action:playThink(waitSeconds)
  yexiaolong:speak(waitSeconds, '……')

  waitSeconds = waitSeconds + 2
  myPlayer:speak(waitSeconds, '先生？')

  waitSeconds = waitSeconds + 2
  yexiaolong:speak(waitSeconds, '……')

  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond(function (p)
    yexiaolong:setFaceYaw(ActorHelper.FACE_YAW.SOUTH)
    local playerNum = #MyPlayerHelper:getAllPlayers()
    if (playerNum == 1) then
      yexiaolong:speak(0, '人有三急，你先行一步，我去去就来。')
    else
      yexiaolong:speak(0, '人有三急，你们先行，我去去就来。')
    end
  end, waitSeconds)

  waitSeconds = waitSeconds + 1
  myPlayer:speak(waitSeconds, '好的。')
  myPlayer.action:playFree2(waitSeconds)

  waitSeconds = waitSeconds + 1
  MyTimeHelper:callFnAfterSecond(function (p)
    yexiaolong:wantMove('leaveForAWhile', p.story2.leaveForAWhilePositions)
  end, waitSeconds, { story2 = story2 })
  
  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(true)

    for i, v in ipairs(MyPlayerHelper:getAllPlayers()) do
      if (i == 1) then
        v.action:runTo(p.story2.eventPositions, function (v)
          Story2:meetBandits(v)
        end, v)
      else
        v.action:runTo(p.story2.eventPositions)
      end
    end

  end, waitSeconds, { story2 = story2 })

  waitSeconds = waitSeconds + 3
  MyPlayerHelper:everyPlayerSpeakInHeartAfterSecond(waitSeconds, '这里的树木好茂密啊！')
end

-- 遭遇强盗
function Story2:meetBandits (hostPlayer)
  local story2 = MyStoryHelper:getStory(2)
  self:initQiangdao()
  local xiaotoumuId = qiangdaoXiaotoumu.monsters[1]
  local xiaolouluoId = qiangdaoLouluo.monsters[1]

  local waitSeconds = 2
  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(false)
    qiangdaoXiaotoumu:lookAt(hostPlayer.objid)
    qiangdaoLouluo:lookAt(hostPlayer.objid)
  end, waitSeconds)
  MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(waitSeconds, '！！！')

  waitSeconds = waitSeconds + 2
  qiangdaoXiaotoumu:speak(waitSeconds, '此树乃吾栽，此路亦吾开。欲从此路过，留下……')
  MonsterHelper:playAct(xiaotoumuId, ActorHelper.ACT.ATTACK, waitSeconds)

  waitSeconds = waitSeconds + 2
  qiangdaoXiaotoumu:thinks(waitSeconds, '又是穷鬼，真伤脑筋……')
  MonsterHelper:playAct(xiaotoumuId, ActorHelper.ACT.THINK, waitSeconds)

  waitSeconds = waitSeconds + 2
  qiangdaoLouluo:speak(waitSeconds, '买路财，老大。')
  MyTimeHelper:callFnAfterSecond(function ()
    MonsterHelper:lookAt(xiaolouluoId, xiaotoumuId)
  end, waitSeconds)

  waitSeconds = waitSeconds + 2
  qiangdaoXiaotoumu:speak(waitSeconds, '你个笨蛋，山野村民，身上能有什么财。')
  MyTimeHelper:callFnAfterSecond(function ()
    MonsterHelper:lookAt(xiaotoumuId, xiaolouluoId)
    MonsterHelper:playAct(xiaotoumuId, ActorHelper.ACT.ANGRY)
  end, waitSeconds)

  waitSeconds = waitSeconds + 3
  qiangdaoXiaotoumu:speak(waitSeconds, '不过，这是去往风颖城的道路。如果没有通行令，可是进不了城的。')
  MonsterHelper:playAct(xiaotoumuId, ActorHelper.ACT.FREE2, waitSeconds)

  waitSeconds = waitSeconds + 3
  qiangdaoXiaotoumu:speak(waitSeconds, '如果我们有了通行令，找个机会混进城抢几个城里的大户……')

  waitSeconds = waitSeconds + 2
  qiangdaoLouluo:speak(waitSeconds, '高啊，老大。')
  MonsterHelper:playAct(xiaolouluoId, ActorHelper.ACT.HAPPY, waitSeconds)

  waitSeconds = waitSeconds + 2
  qiangdaoLouluo:speak(waitSeconds, '小子，留下令牌来。')
  MyTimeHelper:callFnAfterSecond(function ()
    MonsterHelper:lookAt(xiaolouluoId, hostPlayer.objid)
    MonsterHelper:lookAt(xiaotoumuId, hostPlayer.objid)
    MonsterHelper:playAct(xiaolouluoId, ActorHelper.ACT.ATTACK)
  end, waitSeconds)

  waitSeconds = waitSeconds + 2
  hostPlayer:thinks(waitSeconds, '看样子只能拼了。')

  waitSeconds = waitSeconds + 2
  hostPlayer:speak(waitSeconds, '想要你们就来拿吧！')
  hostPlayer.action:playAngry(waitSeconds)

  waitSeconds = waitSeconds + 2
  qiangdaoXiaotoumu:speak(waitSeconds, '看来是遇到不要命的了。大伙们一起上。')
  MonsterHelper:playAct(xiaotoumuId, ActorHelper.ACT.ATTACK, waitSeconds)

  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:changeViewMode(nil, VIEWPORTTYPE.MAINVIEW)
    MyPlayerHelper:everyPlayerNotify('注意，你不能离此地过远')
    qiangdaoXiaotoumu:setAIActive(true)
    qiangdaoLouluo:setAIActive(true)
    MyPlayerHelper:everyPlayerEnableMove(true)
    MyStoryHelper:forward('消灭强盗')
  end, waitSeconds)
end

function Story2:showMessage (objid)
  local actorid = CreatureHelper:getActorID(objid)
  MyTimeHelper:callFnAfterSecond(function ()
    local story2 = MyStoryHelper:getStory(2)
    local isRight = false
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
        MyTimeHelper:callFnAfterSecond(function ()
          self:killXiaotoumuEvent()
        end, 1)
      end
    end
    if (isRight) then
      local remainXiaolouluoNum = #story2.louluoPositions - story2.killLouluoNum
      local remainXiaotoumuNum = #story2.xiaotoumuPositions - story2.killXiaotoumuNum
      if (remainXiaotoumuNum + remainXiaolouluoNum > 0) then
        local msg = '剩余强盗喽罗数：' .. remainXiaolouluoNum .. '。剩余强盗小头目数：' .. remainXiaotoumuNum .. '。'
        ChatHelper:sendSystemMsg(msg)
      else
        ChatHelper:sendSystemMsg('消灭所有强盗。')
        if (story2.standard == 1) then
          self:wipeOutQiangdao()
        end
      end
    end
  end, 1)
end

function Story2:comeBack (objid, areaid)
  local pos = MyPosition:new(ActorHelper:getPosition(objid))
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
  if (ActorHelper:isPlayer(objid)) then
    MyPlayerHelper:showToast(objid, '你不能跑得太远')
    -- local player = MyPlayerHelper:getPlayer(objid)
    -- PlayerHelper:setPosition(objid, pos.x, pos.y, pos.z)
  end
  ActorHelper:appendSpeed(objid, x, y, z)
  ActorHelper:tryNavigationToPos(objid, pos.x, pos.y, pos.z, false)
end

function Story2:wipeOutQiangdao ()
  local story2 = MyStoryHelper:getStory(2)
  local hostPlayer = MyPlayerHelper:getHostPlayer()
  MyStoryHelper:forward('终于消灭了强盗')
  MyPlayerHelper:everyPlayerEnableMove(false)
  yexiaolong:thinks(0, '算算时间，应该清理地差不多了。去看看怎么样了。')

  local waitSeconds = 2
  MyTimeHelper:callFnAfterSecond(function ()
    local pos = self:getAirPosition()
    yexiaolong:setPosition(pos)
    yexiaolong:wantLookAt(nil, hostPlayer.objid, 3)
    yexiaolong.action:playFree(1)
  end, waitSeconds)

  waitSeconds = waitSeconds + 1
  MyPlayerHelper:everyPlayerDoSomeThing (function (p)
    p:wantLookAt(yexiaolong.objid, 3)
  end, waitSeconds)

  waitSeconds = waitSeconds + 1
  yexiaolong:speak(waitSeconds, '不错。')

  waitSeconds = waitSeconds + 2
  hostPlayer:speak(waitSeconds, '先生，我消灭了这些可恶的强盗耶。你也觉得我不错吧。')
  hostPlayer.action:playHappy(waitSeconds)

  waitSeconds = waitSeconds + 2
  yexiaolong:speak(waitSeconds, '……我是说这些强盗不错。')

  waitSeconds = waitSeconds + 2
  hostPlayer:speak(waitSeconds, '！！！')
  hostPlayer.action:playDown(waitSeconds)

  waitSeconds = waitSeconds + 2
  yexiaolong:speak(waitSeconds, '我之前还在想，如果考验只是杀几条狼。那不是就招了个猎户嘛。')

  waitSeconds = waitSeconds + 3
  yexiaolong:speak(waitSeconds, '这样的话，回去之后肯定又会被小高嘲笑了。不错不错。')

  waitSeconds = waitSeconds + 3
  yexiaolong:speak(waitSeconds, '路见不平的少年英雄。哈哈……')
  yexiaolong.action:playHappy(waitSeconds)

  waitSeconds = waitSeconds + 3
  MyPlayerHelper:everyPlayerDoSomeThing (function (p)
    p.action:speakInHeart(p.objid, '路见不平？好像刚刚路上确实有几个坑。')
    p.action:playThink()
  end, waitSeconds)

  waitSeconds = waitSeconds + 3
  yexiaolong:speak(waitSeconds, '刚刚路上捡了把小剑，挺适合你现在用的。就给你好了。')
  MyPlayerHelper:everyPlayerDoSomeThing (function (p)
    Backpack:addItem(p.objid, 12003, 1) -- 短剑
  end, waitSeconds)

  waitSeconds = waitSeconds + 3
  self:endWords(hostPlayer, waitSeconds)
end

function Story2:endWords (player, waitSeconds)
  local story2 = MyStoryHelper:getStory(2)
  yexiaolong:speak(waitSeconds, '前面不远就是风颖城了。通行令牌已经给你，你出示令牌就可以进城了。')

  waitSeconds = waitSeconds + 3
  yexiaolong:speak(waitSeconds, '进城后你可以先四处逛逛。记得来学院报到。学院在东北方。')

  waitSeconds = waitSeconds + 3
  player:speak(waitSeconds, '先生，我们不一起进城吗？')
  player.action:playThink(waitSeconds)

  waitSeconds = waitSeconds + 2
  if (story2.standard == 1) then
    yexiaolong:speak(waitSeconds, '不了，我已经迫不及待想看看小高招的新学员了。我先走了。')
  else
    yexiaolong:speak(waitSeconds, '不了，你身上有伤，不易快行。我还有事，要先行一步。我先走了。')
  end

  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond(function ()
    yexiaolong:wantMove('goToCollege', story2.toCollegePositions)
    MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(1, '先生慢走。')
    MyPlayerHelper:everyPlayerDoSomeThing(function (p)
      p.action:playFree2()
    end)
  end, waitSeconds)

  waitSeconds = waitSeconds + 2
  MyPlayerHelper:everyPlayerSpeakInHeartAfterSecond(waitSeconds, '先生又走了。不会又发生什么吧。不知道风颖城是什么样子的。好期待。')
  MyPlayerHelper:everyPlayerEnableMove(true, waitSeconds)

  MyTimeHelper:callFnAfterSecond(function ()
    MyPlayerHelper:changeViewMode(nil, VIEWPORTTYPE.MAINVIEW)
    MyStoryHelper:forward('前往风颖城')
    -- ChatHelper:sendSystemMsg('时间有限，作者剧情就做到这里了。游戏结束标志没有设置。风颖城也还没有做完。主要把落叶村人物的作息完成了。后面的内容，作者会继续更新。希望你们喜欢，谢谢。')
    ChatHelper:sendSystemMsg('#G目前剧情到此。')
  end, waitSeconds)
end

function Story2:getAirPosition ()
  local hostPlayer = MyPlayerHelper:getHostPlayer()
  local pos = MyPosition:new(hostPlayer:getPosition())
  local pos2 = MyPosition:new(hostPlayer:getPosition())
  for i = 6, 1, -1 do
    pos.x = pos.x + i
    pos2.x = pos2.x + i + 1
    if (MyAreaHelper:isAirArea(pos) and MyAreaHelper:isAirArea(pos2)) then
      return pos, pos2
    else
      pos.x = pos.x - i
      pos2.x = pos2.x - i - 1
    end
    pos.z = pos.z + i
    pos2.z = pos2.z + i + 1
    if (MyAreaHelper:isAirArea(pos) and MyAreaHelper:isAirArea(pos2)) then
      return pos, pos2
    else
      pos.z = pos.z - i
      pos2.z = pos2.z - i - 1
    end
  end
  return pos, pos2
end

function Story2:killXiaotoumuEvent ()
  local story2 = MyStoryHelper:getStory(2)
  if (story2.standard == 1 and story2.killLouluoNum < #story2.louluoPositions) then -- 还有喽罗
    qiangdaoLouluo:speak(0, '他杀了老大！干掉他！')
    for i, v in ipairs(story2.xiaolouluos) do
      if (not(v.killed)) then
        CreatureHelper:setAIActive(v.objid, false)
      end
    end
    MyTimeHelper:callFnAfterSecond(function ()
      for i, v in ipairs(story2.xiaolouluos) do
        if (not(v.killed)) then
          CreatureHelper:setAIActive(v.objid, true)
          ActorHelper:addBuff(v.objid, 17, 3, 6000) -- 强力攻击3级
        end
      end
    end, 1)
  end
end

function Story2:initQiangdao ()
  local story2 = MyStoryHelper:getStory(2)
  qiangdaoXiaotoumu:setAIActive(false)
  qiangdaoLouluo:setAIActive(false)
  qiangdaoXiaotoumu:setPositions(story2.xiaotoumuPositions)
  qiangdaoLouluo:setPositions(story2.louluoPositions)
  for i, v in ipairs(qiangdaoXiaotoumu.monsters) do
    table.insert(story2.xiaotoumus, { objid = v, killed = false })
  end
  for i, v in ipairs(qiangdaoLouluo.monsters) do
    table.insert(story2.xiaolouluos, { objid = v, killed = false })
  end
end

function Story2:playerBadHurt (objid)
  local story2 = MyStoryHelper:getStory(2)
  local player = MyPlayerHelper:getPlayer(objid)
  story2.standard = 2
  MyPlayerHelper:changeViewMode()
  player:enableBeAttacked(false)
  player:enableMove(false)
  local waitSeconds = 0
  yexiaolong:thinks(waitSeconds, '果然还是太勉强了吗？')

  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond(function ()
    yexiaolong:speak(0, '住手！')
    for i, v in ipairs(story2.xiaotoumus) do
      if (not(v.killed)) then
        MyActorHelper:stopRun(v.objid)
        if (i == 1) then
          qiangdaoXiaotoumu:speak(1, '！！！')
        end
        MyTimeHelper:callFnAfterSecond(function ()
          MonsterHelper:lookAt(v.objid, yexiaolong.objid)
        end, 2)
      end
    end
    for i, v in ipairs(story2.xiaolouluos) do
      if (not(v.killed)) then
        MyActorHelper:stopRun(v.objid)
        if (i == 1) then
          qiangdaoLouluo:speak(1, '！！！')
        end
        MyTimeHelper:callFnAfterSecond(function ()
          MonsterHelper:lookAt(v.objid, yexiaolong.objid)
        end, 2)
      end
    end
  end, waitSeconds)

  waitSeconds = waitSeconds + 1
  local playerPos = player:getMyPosition()
  local areaid = AreaHelper:createAreaRect(playerPos, { x = 4, y = 2, z = 4 })
  local ids = AreaHelper:getAllCreaturesInAreaId(areaid)
  MyTimeHelper:callFnAfterSecond(function ()
    local pos = player:getDistancePosition(1.5)
    yexiaolong:setPosition(pos)
    yexiaolong.action:playFree2()
    WorldHelper:playRepelEffect(pos)
    for i, v in ipairs(ids) do
      local dstPos = MyActorHelper:getMyPosition(v)
      local speed = MathHelper:getSpeedVector3(pos, dstPos, 2)
      ActorHelper:appendSpeed(v, speed.x, speed.y, speed.z)
      WorldHelper:playAttackEffect(dstPos)
    end
    MyTimeHelper:callFnAfterSecond(function ()
      WorldHelper:stopRepelEffect(pos)
    end, waitSeconds + 2)
  end, waitSeconds)

  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond(function ()
    local num = #MyPlayerHelper:getAllPlayers() * 2
    yexiaolong:speak(0, '这里有', num, '瓶药剂。剩下的交给我吧。')
    Backpack:addItem(player.objid, MyConstant.POTION_ID, num) -- 回血药剂
    yexiaolong:lookAt(player.objid)
    -- player:lookAt(yexiaolong.objid)
  end, waitSeconds)

  waitSeconds = waitSeconds + 2
  MyTimeHelper:callFnAfterSecond(function ()
    local monsters = {}
    for i, v in ipairs(story2.xiaotoumus) do
      if (not(v.killed)) then
        local mPos = MyPosition:new(ActorHelper:getPosition(v.objid))
        table.insert(monsters, { v.objid, WorldHelper:calcDistance(playerPos, mPos) })
      end
    end
    for i, v in ipairs(story2.xiaolouluos) do
      if (not(v.killed)) then
        local mPos = MyPosition:new(ActorHelper:getPosition(v.objid))
        table.insert(monsters, { v.objid, WorldHelper:calcDistance(playerPos, mPos) })
      end
    end
    if (#monsters > 0) then
      table.sort(monsters, function (a, b)
        return a[2] > b[2]
      end)
      local ws = 0
      for i, v in ipairs(monsters) do
        ws = ws + 1
        MyTimeHelper:callFnAfterSecond(function ()
          local pos = MyActorHelper:getDistancePosition(v[1], -1.5)
          yexiaolong:setPosition(pos)
          yexiaolong:lookAt(v[1])
          MonsterHelper:lookAt(v[1], yexiaolong.objid)
          local attackPos = MyActorHelper:getDistancePosition(v[1], -1)
          WorldHelper:playAttackEffect(attackPos)
          WorldHelper:playBeAttackedSoundOnPos(attackPos)
          local dstPos = MyActorHelper:getMyPosition(v[1])
          local speed = MathHelper:getSpeedVector3(pos, dstPos, 1)
          ActorHelper:appendSpeed(v[1], speed.x, speed.y, speed.z)
          local actorid = CreatureHelper:getActorID(v[1])
          if (actorid == MyConstant.QIANGDAO_LOULUO_ACTOR_ID) then
            qiangdaoLouluo:speak(0, '啊！')
          else
            qiangdaoXiaotoumu:speak(0, '啊！')
          end
          -- yexiaolong.action:playAttack()
          MyTimeHelper:callFnFastRuns(function ()
            ActorHelper:killSelf(v[1])
          end, 0.3)
          MyTimeHelper:callFnAfterSecond(function ()
            WorldHelper:stopAttackEffect(attackPos)
          end, 2)
        end, ws)
      end

      ws = ws + 1
      yexiaolong:speak(ws, '高手，就是这么寂寞。')
      yexiaolong.action:playHappy(ws)

      ws = ws + 2
      local idx = 1
      MyPlayerHelper:everyPlayerDoSomeThing(function (p)
        local pos = yexiaolong:getDistancePosition(idx + 1.5)
        p:setPosition(pos)
        p:wantLookAt(yexiaolong, 2)
        if (p ~= player) then
          p:enableMove(false)
        end
        idx = idx + 1
      end, ws)

      ws = ws + 1
      player:speak(ws, '先生，你好厉害。')

      ws = ws + 2
      yexiaolong:thinks(ws, '不是我厉害，而是你太菜。')

      ws = ws + 2
      MyTimeHelper:callFnAfterSecond(function ()
        MyStoryHelper:forward('终于消灭了强盗')
        yexiaolong:lookAt(player.objid)
        yexiaolong:speak(0, '不错，这么快就恢复过来了。')
        self:endWords(player, 2)
      end, ws)
    end
  end, waitSeconds)
end