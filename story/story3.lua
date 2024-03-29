-- 剧情三
Story3 = MyStory:new()

function Story3:new ()
  local data = {
    title = '学院',
    name = '学院任务',
    desc = '来到学院就开始做任务了',
    tips = {
      '终于到学院了。先生好像说要报名来着，希望没有来晚。',
      '是先生的声音，我进去看看。',
      '先生说学院的任务主要是由高先生负责，我去问问看。',
      '原来新生还有兵器可以领，真是太棒了。先生好像说是真宝阁来着，我去看看。',
      '拿着新武器好开心。接下来做什么呢，要不要找先生问问。',
      '先生让我去消灭强盗大头目，我觉得目前对我来说还是挺难的，我得好好准备一番。',
      '终于消灭了强盗的威胁。不知道龙先生有什么事要交代我。',
      '先生说快要考试了，有点小紧张。',
      '要击败小火，我应该……没问题吧。',
      '丢人了，没想到小火这么厉害。看来想要通过考试，还得再准备准备。',
      '终于顺利通过了考试，我果然是天赋异禀。（目前剧情到此。后续内容还在制作中……）',
      -- '目前剧情到此',
    },
    prepose = {
      ['来到学院'] = 1,
      ['先生的声音'] = 2,
      ['对话高先生'] = 3,
      ['新生武器'] = 4,
      ['接受任务'] = 5,
      ['消灭大头目'] = 6,
      ['对话叶先生'] = 7,
      ['开始考试'] = 8,
      ['考试没通过'] = 9,
      ['考试通过'] = 10,
      ['新的征程'] = 11,
    },
    index = 3,
    posBeg = MyPosition:new(-31, 7, 590),
    posEnd = MyPosition:new(-7, 8, 576),
    startPos = MyPosition:new(-19, 7, 584), -- 剧情开始位置
    startArea = -99,
    yexiaolongInitPos = MyPosition:new(-17, 7.5, 593),
    gaoxiaohuInitPos = MyPosition:new(-16, 7.5, 594),
    yuewushuangInitPos = MyPosition:new(-16, 7.5, 595.5),
    playerPos = MyPosition:new(-20, 7.5, 594.5),
    airWallPosBeg = MyPosition:new(-19, 10, 592), -- 空气墙起点
    airWallPosEnd = MyPosition:new(-19, 7, 596), -- 空气墙终点
    airWallArea = nil,
    testAreaPosBeg = MyPosition:new(-12, 7, 594), -- 考核区域起点
    testAreaPosEnd = MyPosition:new(1, 7, 607), -- 考核区域终点
    failTestPos = MyPosition:new(17, 8.5, 605), -- 考试失败后江火出现位置
    testObjid = nil, -- 正在考试的玩家
    callHelpRobber = {}, -- { objid -> true } 叫了帮手的强盗，用于打强盗大头目剧情中，强盗生命值过低后叫帮手
  }
  self:checkData(data)

  if StoryHelper.getMainStoryIndex() <= 3 then -- 剧情没有超过3时
    data.startArea = AreaHelper.createAreaRectByRange(data.posBeg, data.posEnd)
  end

  self.__index = self
  setmetatable(data, self)
  return data
end

-- 来到学院
function Story3:comeToCollege ()
  local name
  if not(yexiaolong and yexiaolong:isFinishInit()) then -- 校验叶小龙
    name = '叶小龙'
  elseif not(yexiaolong and yexiaolong:isFinishInit()) then -- 校验高小虎
    name = '高小虎'
  elseif not(yuewushuang and yuewushuang:isFinishInit()) then -- 校验月无双
    name = '月无双'
  end
  if name then
    TimeHelper.callFnAfterSecond(function ()
      self:comeToCollege()
    end, 1)
    StoryHelper.showInitError('comeToCollege', name)
    return
  end

  local px = 0
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:setPosition(self.startPos.x + px, self.startPos.y, self.startPos.z)
    PlayerHelper.changeVMode(player.objid, VIEWPORTTYPE.BACKVIEW)
    PlayerHelper.rotateCamera(player.objid, ActorHelper.FACE_YAW.SOUTH, 0)
    if px == 0 then
      px = 1
    elseif px > 0 then
      px = -px
    else
      px = 1 - px
    end
  end)
  local hostPlayer = PlayerHelper.getHostPlayer()
  PlayerHelper.everyPlayerEnableMove(false)
  -- 调整三个生物的位置
  yexiaolong:setPosition(self.yexiaolongInitPos) -- 调整叶小龙位置
  gaoxiaohu:setPosition(self.gaoxiaohuInitPos) -- 调整高小虎位置
  yuewushuang:setPosition(self.yuewushuangInitPos) -- 调整月无双位置
  -- 使三个生物无法点击对话且不会乱跑
  yexiaolong:wantDoNothing('forceDoNothing noClick')
  gaoxiaohu:wantDoNothing('forceDoNothing noClick')
  yuewushuang:wantDoNothing('forceDoNothing noClick')
  -- 加上空气墙，目前没什么用了，不过暂时先不去掉
  self.airWallArea = AreaHelper.createAreaRectByRange(self.airWallPosBeg, self.airWallPosEnd)
  AreaHelper.fillBlock(self.airWallArea, 1001) -- 区域填充空气墙

  local ws = WaitSeconds:new()
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(3), '这就是紫荆学院。')
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(3), '希望我能在这里学得一身本事。')
  yexiaolong:lookAt(gaoxiaohu, ws:get())
  gaoxiaohu:lookAt(yexiaolong, ws:get())
  yuewushuang:lookAt(yexiaolong, ws:get())
  yexiaolong:speak(ws:use(), '小高小高，我终于找到你了。')
  PlayerHelper.everyPlayerEnableMove(true, ws:get())
  PlayerHelper.everyPlayerRunTo({ self.playerPos }, function (player)
    player:lookAt(yexiaolong)
    player:enableMove(false, '剧情中')
  end, ws:get())
  PlayerHelper.everyPlayerThinkToSelf(ws:use(), '咦，是先生的声音。进去看看。')
  TimeHelper.callFnAfterSecond(function ()
    StoryHelper.forwardAll(3, '来到学院')
  end, ws:get())
  gaoxiaohu:speak(ws:use(), '说了多少遍了，叫我小虎，别把我叫矮了。你也回来了。')
  yexiaolong:speak(ws:use(), '回来一阵子了，一直没找到你。小高，看看你的新学生。')
  gaoxiaohu:speak(ws:use(), '每次你都这样，真受不了你。我身边这位就是我新收的学生，月无双。')
  gaoxiaohu:lookAt(yuewushuang, ws:get())
  gaoxiaohu:speak(ws:use(), '这位就是之前跟你提起过的叶先生。')
  yuewushuang:lookAt(yexiaolong, ws:get())
  yexiaolong:lookAt(yuewushuang, ws:get())
  yuewushuang.action:playThank(ws:get())
  yuewushuang:speak(ws:use(), '见过叶先生。')
  yexiaolong:speak(ws:use(), '不错……')
  gaoxiaohu:lookAt(yexiaolong, ws:get())
  gaoxiaohu:speak(ws:use(), '那是，为此，我可是走遍了十里八乡。你的学生呢？')
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playHappy()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '先生先生。')
  yexiaolong:lookAt(hostPlayer, ws:get())
  gaoxiaohu:lookAt(hostPlayer, ws:get())
  yuewushuang:lookAt(hostPlayer, ws:get())
  yexiaolong:speak(ws:use(), '哦，你来了。')
  yexiaolong:lookAt(gaoxiaohu, ws:get())
  yexiaolong:speak(ws:use(), '这就是我的学生了。虽然看上去弱不禁风，不过我们也是经过了强盗的洗礼。')
  gaoxiaohu:lookAt(yexiaolong, ws:get())
  yuewushuang:lookAt(yexiaolong, ws:get())
  gaoxiaohu:speak(ws:use(), '强盗？他们还敢打劫你？')
  yexiaolong:speak(ws:use(), '回来的路上我发现了强盗的埋伏，就交给学生处理了。')
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playDown()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '！！！')
  gaoxiaohu:speak(ws:use(), '没想到现在强盗这么猖獗了。这事我们得好好说说。')
  yexiaolong:speak(ws:use(), '是得好好说说。一会儿再说吧，找你老半天，累死我了，我先去歇歇脚。')
  gaoxiaohu:speak(ws:use(), '好好好。')
  yexiaolong:lookAt(hostPlayer, ws:get())
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playStand()
  end, ws:get())
  yexiaolong:speak(ws:use(), '这位是学院的高先生。学院任务主要就是他在负责，学院的事找他就对了。')
  PlayerHelper.everyPlayerLookAt(gaoxiaohu, ws:get())
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playThank()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '高先生好。')
  gaoxiaohu:lookAt(hostPlayer, ws:get())
  gaoxiaohu:speak(ws:use(), '嗯……')
  yexiaolong:speak(ws:use(), '好了，我先走了。')
  PlayerHelper.everyPlayerLookAt(yexiaolong, ws:get())
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playHi()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '先生走好。')
  TimeHelper.callFnAfterSecond(function ()
    AreaHelper.clearAllBlock(self.airWallArea, 1001) -- 清除空气墙
    StoryHelper.forwardAll(3, '先生的声音')
    PlayerHelper.everyPlayerEnableMove(true)
    gaoxiaohu:doItNow()
    yuewushuang:doItNow()
    yexiaolong:doItNow()
  end, ws:get())
end

--[[
  强盗大头目找帮手
  @param    {number} objid 生物id
  @author   莫小仙
  @datetime 2021-10-16 16:08:37
]]
function Story3:callHelp (objid)
  local actorid = CreatureHelper.getActorID(objid)
  if not actorid or actorid ~= MyMap.ACTOR.QIANGDAO_DATOUMU_ACTOR_ID then -- 如果不是强盗大头目
    return
  end
  local hp = CreatureHelper.getHp(objid)
  if hp and hp < 300 then -- 生命值不到一半
    if not story3.callHelpRobber[objid] then -- 没找到表示没有叫过帮手
      story3.callHelpRobber[objid] = true -- 标记已经叫过帮手
      story3:robberComeOut(objid)
    end
  end
end

--[[
  在附近的玩家周围出现1个小头目以及3个喽罗
  @param    {number} objid 大头目id
  @author   莫小仙
  @datetime 2021-10-16 16:34:41
]]
function Story3:robberComeOut (objid)
  local pos = CacheHelper.getMyPosition(objid)
  local dis = 5 -- 出现强盗的距离
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    if pos then -- 位置存在，表示强大大头目还存在
      local playerPos = player:getMyPosition()
      local distance = MathHelper.getDistanceV2(pos, playerPos)
      if distance and distance < 10 then -- 水平10格内的所有玩家
        ChatHelper.speak('强盗大头目', player.objid, '你们还埋伏什么，赶紧出来！')
        -- 在前方出现一个小头目
        local pos1 = MathHelper.getDistancePosition(playerPos, 0, dis) -- 正前方5米处
        WorldHelper.spawnCreature(pos1.x, pos1.y, pos1.z, MyMap.ACTOR.QIANGDAO_XIAOTOUMU_ACTOR_ID, 1) -- 小头目
        -- 在左右后出现一共三个喽罗
        for i = 1, 3 do
          local tempPos = MathHelper.getDistancePosition(playerPos, 90 * i, dis)
          WorldHelper.spawnCreature(tempPos.x, tempPos.y, tempPos.z, MyMap.ACTOR.QIANGDAO_LOULUO_ACTOR_ID, 1) -- 喽罗
        end
      end
    end
  end)
end

--[[
  开始考核
  @param    {table} player 玩家
  @author   莫小仙
  @datetime 2021-10-07 16:38:33
]]
function Story3:startTest (player)
  if not jianghuo or not jianghuo:isFinishInit() then -- 校验
    TimeHelper.callFnAfterSecond(function ()
      self:startTest(player)
    end, 1)
    StoryHelper.showInitError('startTest', '江火')
    return
  end
  story3.testObjid = player.objid -- 记录考试玩家
  -- 未考试过时剧情前进
  StoryHelper.forwardByPlayer(player.objid, 3, '开始考试')
  -- 考试失败时剧情前进
  StoryHelper.forwardByPlayer(player.objid, 3, '考试通过', '开始考试')
  jianghuo:setPlayerClickEffective(player.objid, false) -- 玩家无法点击对话
  local ws = WaitSeconds:new()
  player:setMyPosition(-4, 7, 602) -- 移动玩家去演武场
  player:enableMove(false, '剧情中')
  PlayerHelper.rotateCamera(player.objid, ActorHelper.FACE_YAW.EAST, 0) -- 看向西方
  local pos = MyPosition:new(-10, 7, 602)
  jianghuo:setPosition(pos) -- 移动江火过来
  jianghuo:wantMove('forceDoNothing', { pos }) -- 避免江火乱跑
  jianghuo:nextWantLookAt('forceDoNothing', player.objid, 5)
  jianghuo:nextWantDoNothing('forceDoNothing')

  jianghuo:speakTo(player.objid, ws:use(), '现在我是考官，考核内容就是击败我。')
  -- jianghuo:lookAt(player, ws:get())
  player:speakSelf(ws:use(), '我会全力以赴的。')
  -- jianghuo:lookAt(player, ws:get()) -- 第二次看是避免第一次没看
  jianghuo:speakTo(player.objid, ws:use(), '当然，你全力以赴也不可能击败我。因此，我只会拿出三成的实力。')
  if not CreatureHelper.isHpFull(jianghuo.objid) then -- 没有满血
    jianghuo:speakTo(player.objid, ws:use(), '嗯？我状态竟然没有恢复。')
    TimeHelper.callFnFastRuns(function ()
      jianghuo.action:playAttack()
      ActorHelper.recoverAllHp(jianghuo.objid) -- 恢复生命
    end, ws:use())
  end
  jianghuo:speakTo(player.objid, ws:use(), '好了，考核正式开始。')
  TimeHelper.callFnFastRuns(function ()
    CreatureHelper.setTeam(jianghuo.objid, 2) -- 将江火的队伍变为蓝队
    CreatureHelper.setWalkSpeed(jianghuo.objid, 400) -- 设置移动速度
    jianghuo:openAI()
    player:enableMove(true, true)
  end, ws:use())
end

--[[
  检测是否是玩家在进行学院考试，如果是则处理
  @param    {table} player 玩家
  @param    {table} actor 生物
  @author   莫小仙
  @datetime 2021-10-06 19:19:07
]]
function Story3:checkIfTest (player, actor)
  local hp = CreatureHelper.getHp(actor.objid)
  local player = PlayerHelper.getPlayer(player.objid)
  if story3:isTesting(player) then -- 在学院考试
    if hp == 1 then -- 重伤
      story3:passTest(player)
    else -- 未重伤
      jianghuo:tryDodge(story3.testAreaPosBeg, story3.testAreaPosEnd)
    end
  end
end

--[[
  是否是在学院考试
  @param    {table} player 玩家
  @return   {boolean} 是否在考试
  @author   莫小仙
  @datetime 2021-10-06 19:50:24
]]
function Story3:isTesting (player)
  if PlayerHelper.isMainPlayer(player.objid) then -- 如果是房主
    local mainIndex = StoryHelper.getMainStoryIndex()
    local mainProgress = StoryHelper.getMainStoryProgress()
    if mainIndex == 3 and mainProgress == 9 then -- 在考试
      return true
    end
  else -- 不是房主
    if TaskHelper.hasTask(player.objid, story3:getTaskIdByName('开始考试')) -- 在考试
      and not TaskHelper.hasTask(player.objid, story3:getTaskIdByName('通过考试')) then -- 没通过
      return true
    end
  end
  return false
end

--[[
  通过考核
  @param    {table} player 玩家
  @author   莫小仙
  @datetime 2021-10-07 17:12:45
]]
function Story3:passTest (player)
  if not jianghuo or not jianghuo:isFinishInit() then -- 校验
    TimeHelper.callFnAfterSecond(function ()
      self:passTest(player)
    end, 1)
    StoryHelper.showInitError('passTest', '江火')
    return
  end
  StoryHelper.forwardByPlayer(player.objid, 3, '考试没通过', '考试通过') -- 剧情前进
  -- StoryHelper.forwardByPlayer(player.objid, 3, '考试通过') -- 剧情前进
  local ws = WaitSeconds:new()
  CreatureHelper.setTeam(jianghuo.objid, 1) -- 将江火的队伍变为红队
  CreatureHelper.setWalkSpeed(jianghuo.objid, -1) -- 恢复移动速度
  -- PlayerHelper.setPlayerEnableBeKilled(player.objid, true) -- 玩家可被击败
  jianghuo:stopRun()
  jianghuo:wantLookAt('forceDoNothing', player.objid, 5)
  jianghuo.action:playDie() -- 死亡动作
  player:enableMove(false, '剧情中')
  jianghuo:speakTo(player.objid, 0, '你小子下手可真狠。')
  TimeHelper.callFnFastRuns(function ()
    jianghuo.action:playStand() -- 站起来
    player.action:playDown() -- 趴下
    player:speakSelf(0, '我不是故意的。')
  end, ws:use())
  jianghuo:speakTo(player.objid, ws:use(), '你要是故意的，我早就给你邦邦两拳了。')
  jianghuo:speakTo(player.objid, ws:use(), '好了，你考试通过了。去找龙先生吧。我得休息一下。')
  TimeHelper.callFnFastRuns(function ()
    jianghuo.action:playSit() -- 坐下
    jianghuo:setPlayerClickEffective(player.objid, true) -- 可以点击对话
    jianghuo:wantDoNothing() -- 不做事
    player:enableMove(true, true) -- 恢复移动
    story3.testObjid = nil -- 考试结束
  end, ws:use())
end

--[[
  考核失败
  @param    {table} player 玩家
  @author   莫小仙
  @datetime 2021-10-07 17:25:56
]]
function Story3:failTest (player)
  if not jianghuo or not jianghuo:isFinishInit() then -- 校验
    TimeHelper.callFnAfterSecond(function ()
      self:failTest(player)
    end, 1)
    StoryHelper.showInitError('failTest', '江火')
    return
  end
  StoryHelper.forwardByPlayer(player.objid, 3, '考试没通过') -- 剧情前进
  TaskHelper.removeTask(player.objid, story3:getTaskIdByName('开始考试')) -- 移除开始考试任务标志
  CreatureHelper.setTeam(jianghuo.objid, 1) -- 将江火的队伍变为红队
  CreatureHelper.setWalkSpeed(jianghuo.objid, -1) -- 恢复移动速度
  local ws = WaitSeconds:new()
  -- PlayerHelper.setPlayerEnableBeKilled(player.objid, true) -- 玩家可被击败
  jianghuo:setPosition(story3.failTestPos)
  jianghuo:wantApproach('forceDoNothing', { story3.failTestPos }) -- 避免江火乱跑
  jianghuo:nextWantLookAt('forceDoNothing', player.objid, 5)
  PlayerHelper.rotateCamera(player.objid, ActorHelper.FACE_YAW.EAST, 0) -- 看向西方
  player:enableMove(false, '剧情中')
  jianghuo:speakTo(player.objid, ws:use(), '很遗憾，你没有通过考试。')
  player:speakSelf(ws:use(), '好难啊。')
  jianghuo:speakTo(player.objid, ws:use(), '如果不难那考试多没意思。再去准备准备补考吧。')
  -- 恢复生命
  TimeHelper.callFnFastRuns(function ()
    jianghuo.action:playAttack()
    ActorHelper.recoverAllHp(jianghuo.objid) -- 恢复生命
  end, ws:get())
  TimeHelper.callFnFastRuns(function ()
    jianghuo:setPlayerClickEffective(player.objid, true) -- 可以点击对话
    jianghuo:doItNow() -- 做现在该做的事
    player:enableMove(true, true) -- 恢复移动
    story3.testObjid = nil -- 考试结束
  end, ws:use())
end

--[[
  关闭考试，用于考试玩家中途退出游戏
  @param    {number} objid 玩家id
  @author   莫小仙
  @datetime 2021-10-10 19:28:09
]]
function Story3:closeTest (objid)
  StoryHelper.forwardByPlayer(objid, 3, '考试没通过') -- 剧情前进
  TaskHelper.removeTask(objid, story3:getTaskIdByName('开始考试')) -- 移除开始考试任务标志
  CreatureHelper.setTeam(jianghuo.objid, 1) -- 将江火的队伍变为红队
  CreatureHelper.setWalkSpeed(jianghuo.objid, -1) -- 恢复移动速度
  jianghuo:setPlayerClickEffective(objid, true) -- 可以点击对话
  jianghuo:doItNow() -- 做现在该做的事
  jianghuo:toastSpeak('人呢？')
  story3.testObjid = nil -- 考试结束
end

function Story3:recover (player)
  local mainProgress = StoryHelper.getMainStoryProgress()
  local hostPlayer = PlayerHelper.getHostPlayer()
  PlayerHelper.setPlayerEnableBeKilled(player.objid, true) -- 能被杀死
  if player == hostPlayer then -- 玩家是房主
    if mainProgress == 1 or mainProgress == 2 then -- 进度1或进度2
      player:enableMove(true)
      story3:comeToCollege() -- 来到学院
    end
  else -- 不是房主
    if mainProgress < 3 then -- 表示还在剧情对话中
      TaskHelper.addStoryTask(player.objid)
    else -- 剧情对话已完
      TaskHelper.addStoryTask(player.objid, 3, 2)
    end
    player:setMyPosition(hostPlayer:getMyPosition())
  end
end

function Story3:getProgressPrepose (name)
  return self.prepose[name]
end
